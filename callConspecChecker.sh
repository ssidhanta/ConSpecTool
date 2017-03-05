java -jar SpinPreProcess.jar "<1,w,x,1>,<2,w,x,2>,<3,r,x,2>,<4,r,x,1>"

spin -a conspec$1Viol.pml

gcc -o pan pan.c

./pan -a