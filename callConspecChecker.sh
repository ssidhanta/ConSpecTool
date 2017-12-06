#java -jar SpinPreProcess.jar ”<1,w,x,1>,<2,w,x,2>,<3,r,x,2>,<4,r,x,1>" $1
#SECONDS=0
STARTTIME=$(($(gdate +%s%N)/1000000)) 
#STARTTIME=${STARTTIME%.*}
#time a_command
index=0
size=5
#index1=$(echo index | wc -l /Users/subhajitsidhanta/Downloads/Spin/training_data.arff)
index=$(wc -l < $1) #/Users/subhajitsidhanta/Downloads/Spin/training_data.arff)
index="$(expr $index / $size)"
for i in `seq 0 $index`
do
    #SECONDS=0
    STARTTIME=$(($(gdate +%s%N)/1000000)) 
    #STARTTIME=${STARTTIME%.*}
    java -jar SpinPreProcess.jar $1 $2 #$i $size
    #spin -a conspec$2Viol.pml
    spin -a burkhardt$2Viol.pml
    gcc -o pan pan.c
    ./pan -a
    #echo “****after spin run: $i”
    #duration=$SECONDS
    ENDTIME=$(($(gdate +%s%N)/1000000))
    #echo "$((duration / 3600)) seconds and $((duration % 3600)) milliseconds execution time."
    #TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."subset($2,1,3)}'`
    #ENDTIME=${ENDTIME%.*}
    DIFF=$((ENDTIME - STARTTIME))
    #DIFF=${DIFF%%.*}
    #echo $((DIFF)) | xargs printf "%.*f\n" $p
    #real_time=$(echo "$time a_command | grep ^real | awk 'print $2')
    echo "Time diff is: $DIFF seconds"
done
