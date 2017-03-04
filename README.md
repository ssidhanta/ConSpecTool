# ConSpecTool
ConSpec Tool Source  files

callConspecChecker.sh         shell command line file to run the verifier tool
conspec*.pml                   PROMELA source file for specification. Replace * by RYWViol 			       or RYW for RYW, etc.
#serializations.txt            the generated serializations
SpinPreProcess.jar            java jar to accept from user a given session trace as input and  generate valid legal serializations . The valid serializations and session trace is written into the conpsec*.pml file as input arrays.


HOW TO RUN ..........................................

simply run the shell command:
sh callConspecChecker.sh

The shell file calls the SpinPreProcess.jar with the session trace given as an input string in the shell file
The shell file then runs the following commands:
spin -a conspec*.pml

gcc -o pan pan.c

./pan -a

Spin internals.................
Alternatively you can run the following commands yourself 

spin -a conspec*.pml

gcc -o pan pan.c

./pan -a

Alternatively (for redefining LTL formulas...........

echo "#define p (check==true)" > conspec.aut

spin -f '!([] ( !mrviol))' >> conspec.aut

spin -a -N conspec.aut conspec.pml

gcc -o pan pan.c

./pan -a
