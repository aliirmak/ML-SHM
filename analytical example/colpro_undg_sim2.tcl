# SET UP ----------------------------------------------------------------------------
# units: kip, inch, sec
wipe;					# clear memory of all past model definitions
file mkdir Data; 				# create data directory
model BasicBuilder -ndm 2 -ndf 3;		# Define the model builder, ndm=#dimension, ndf=#dofs

# define GEOMETRY -------------------------------------------------------------
set LBeam 5.0; 		# beam length
set ACol 1.624e-3;				# cross-sectional area, make stiff
set IzCol 1.971e-6; 			# Column moment of inertia
set massDens 12.74; 		# unit dead-load weight in kg/m
set Mass [expr 3000.0*10.0/40.0];

# define constants--------------------------
set g 9.81;			# g.
set pi 3.1415926535897931

# nodal coordinates:
for {set i 1} {$i <= 41} {incr i} {
	node $i [expr $LBeam/40.0*($i-1)] 0;
	mass $i 0 $Mass 0;
}

# Single point constraints -- Boundary Conditions
fix 1 1 1 0; 			# node DX DY RZ
fix 41 1 1 0; 			# node DX DY RZ

# Material parameters
set T 6.630004974187237
set K [expr $T*1.8+32.0]
set E [expr (206.216-0.4884*$K+0.0044*$K*$K)*pow(10.0,9.0)]; 	# Concrete Elastic Modulus (the term in sqr root needs to be in psi
# set E_red [expr 0.50*(206.216-0.4884*$K+0.0044*$K*$K)*pow(10.0,9.0)];

# define geometric transformation: performs a linear geometric transformation of beam stiffness and resisting force from the basic system to the global-coordinate system
set ColTransfTag 1; 			# associate a tag to column transformation
geomTransf Linear $ColTransfTag; 	

# element connectivity:
for {set i 1} {$i <= 40} {incr i} {
    if {$i!=100} {
	    element elasticBeamColumn $i $i [expr $i+1] $ACol $E $IzCol $ColTransfTag -mass $massDens;
    } else {
	    element elasticBeamColumn $i $i [expr $i+1] $ACol $E $IzCol $ColTransfTag -mass $massDens;
    }
}

# define DAMPING
# apply Rayleigh DAMPING from $xDamp
# D=$alphaM*M + $betaKcurr*Kcurrent + $betaKcomm*KlastCommit + $beatKinit*$Kinitial
set xDamp 0.001;				# 2% damping ratio
set lambda [eigen 1]; 			# eigenvalue mode 1
set omega [expr pow($lambda,0.5)];
# puts $omega
set alphaM 0.;				# M-prop. damping; D = alphaM*M
set betaKcurr 0.;         			# K-proportional damping;      +beatKcurr*KCurrent
set betaKcomm [expr 2.*$xDamp/($omega)];   	# K-prop. damping parameter;   +betaKcomm*KlastCommitt
set betaKinit 0.;         			# initial-stiffness proportional damping      +beatKinit*Kini
# define damping
rayleigh $alphaM $betaKcurr $betaKinit $betaKcomm; 				# RAYLEIGH damping

# Define RECORDERS -------------------------------------------------------------
recorder Node -file data/1/2500.txt -time -nodeRange 2 40 -dof 2 accel

# reset time to zero
loadConst -time 0.0

# DYNAMIC ANALYSIS PARAMETERS
constraints Transformation ;
# DOF NUMBERER (number the degrees of freedom in the domain):
numberer Plain
# Solution SYSTEM 
system SparseGeneral -piv
# convergence test
set Tol 1.e-8;      # Convergence Test: tolerance
set maxNumIter 10;  # Convergence Test: maximum number of iterations until failure
set printFlag 0;    # Convergence Test: flag used to print information
set TestType EnergyIncr;	# Convergence-test type
test $TestType $Tol $maxNumIter $printFlag;
# Solution ALGORITHM:
set algorithmType ModifiedNewton 
algorithm $algorithmType; 
# Static INTEGRATOR:
set NewmarkGamma 0.5;	# Newmark-integrator gamma parameter (also HHT)
set NewmarkBeta 0.25;	# Newmark-integrator beta parameter
integrator Newmark $NewmarkGamma $NewmarkBeta 
# ANALYSIS
analysis Transient

# Uniform EXCITATION: acceleration input
# DYNAMIC EQ ANALYSIS --------------------------------------------------------
set GMdirection 2;
set GMfile1 "eq/1/2500_1.txt"
set GMfile2 "eq/1/2500_2.txt"
set GMfact 1.0;				# ground-motion scaling factor

# set up ground-motion-analysis parameters
set DtEQ	[expr 1./1024.];	# time-step Dt for lateral analysis
set TmaxAnalysis	[expr 300.];	# maximum duration of ground-motion analysis -- should be 50*$sec

set IDloadTag 400;		# load tag
set IDgmSeries1 401;
set IDgmSeries2 402;
set AccelSeries1 "Series -dt $DtEQ -filePath $GMfile1 -factor  $GMfact";			# time series information
set AccelSeries2 "Series -dt $DtEQ -filePath $GMfile2 -factor  $GMfact";			# time series information
pattern MultipleSupport $IDloadTag  {
    groundMotion $IDgmSeries1 Plain -accel $AccelSeries1
	imposedMotion 1  $GMdirection $IDgmSeries1
	groundMotion $IDgmSeries2 Plain -accel $AccelSeries2
	imposedMotion 41  $GMdirection $IDgmSeries2
};	# end pattern

set DtAnalysis	[expr 0.005];	# time-step Dt for lateral analysis
set Nsteps [expr int($TmaxAnalysis/$DtAnalysis)];
set ok [analyze $Nsteps $DtAnalysis];			# actually perform analysis; returns ok=0 if analysis was successful

if {$ok != 0} {      ;					# if analysis was not successful.
	# change some analysis parameters to achieve convergence
	# performance is slower inside this loop
	#    Time-controlled analysis
	set ok 0;
	set controlTime [getTime];
	while {$controlTime < $TmaxAnalysis && $ok == 0} {
		set ok [analyze 1 $DtAnalysis]
		set controlTime [getTime]
		set ok [analyze 1 $DtAnalysis]
		if {$ok != 0} {
			puts "Trying Newton with Initial Tangent .."
			test NormDispIncr   $Tol 1000  0
			algorithm Newton -initial
			set ok [analyze 1 $DtAnalysis]
			test $TestType $Tol $maxNumIter  0
			algorithm $algorithmType
		}
		if {$ok != 0} {
			puts "Trying Broyden .."
			algorithm Broyden 8
			set ok [analyze 1 $DtAnalysis]
			algorithm $algorithmType
		}
		if {$ok != 0} {
			puts "Trying NewtonWithLineSearch .."
			algorithm NewtonLineSearch .8
			set ok [analyze 1 $DtAnalysis]
			algorithm $algorithmType
		}
	}
};      # end if ok !0