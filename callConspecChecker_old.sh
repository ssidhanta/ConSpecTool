STARTTIME=$(($(gdate +%s%N)/1000000)) 
#STARTTIME=${STARTTIME%.*}
#time a_command
index=$(wc -l < /Users/subhajitsidhanta/Downloads/Spin/training_data.arff)
java -jar SpinPreProcess.jar $1 0 $index

#echo $1

spin -a conspec$1Viol.pml

gcc -o pan pan.c

./pan -a

ENDTIME=$(($(gdate +%s%N)/1000000))
DIFF=$((ENDTIME - STARTTIME))
echo "Time diff is: $DIFF seconds"