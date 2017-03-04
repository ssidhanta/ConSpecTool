# ConSpecTool
ConSpec Tool Source  files

#callConspecChecker.sh         shell command line file to run the verifier
conspec*.pml                   PROMELA source file for specification. Replace * by RYWViol 			       or RYW for RYW, etc.
#serializations.txt            the generated serializations
#SpinPreProcess.jar            java jar to generate serializations.txt


HOW TO RUN ..........................................

spin -a conspec*.pml

gcc -o pan pan.c

./pan -a

Alternatively (for redefining LTL formulas...........

echo "#define p (check==true)" > conspec.aut

spin -f '!([] ( !mrviol))' >> conspec.aut

spin -a -N conspec.aut conspec.pml

gcc -o pan pan.c

./pan -a
