#java -jar SpinPreProcess.jar ”<1,w,x,1>,<2,w,x,2>,<3,r,x,2>,<4,r,x,1>" $1
#SECONDS=0
STARTTIME=$((10#$(date +%s)/1000000))
#STARTTIME=$(($(date +%s%N)/1000000))
#STARTTIME=${STARTTIME%.*}
#time a_command
index=0
size=50
#index1=$(echo index | wc -l /Users/subhajitsidhanta/Downloads/Spin/training_data.arff)
file=$1$2
echo $file
echo "&*&*&*Aftee fuile pront **********"
index=$(wc -l < $file) #/Users/subhajitsidhanta/Downloads/Spin/training_data.arff)
index="$(expr $index / $size)"
for i in `seq 0 $index`
do
    #SECONDS=0
    STARTTIME=$(($(date +%s)/1000000))
    #STARTTIME=$(($(gdate +%s%N)/1000000))
    #STARTTIME=${STARTTIME%.*}
    #java -jar SpinPreProcess.jar $file $3 $1 #$i $size
    spin -a conspec$3Viol.pml
    #spin -a burkhardt$2Viol.pml
    gcc -o pan pan.c
    ./pan -a
    #echo “****after spin run: $i”
    #duration=$SECONDS
    ENDTIME=$(($(date +%s%N)/1000000))
    #echo "$((duration / 3600)) seconds and $((duration % 3600)) milliseconds execution time."
    #TIMEDIFF=`echo "$ENDTIME - $STARTTIME" | bc | awk -F"." '{print $1"."subset($2,1,3)}'`
    #ENDTIME=${ENDTIME%.*}
    DIFF=$((ENDTIME - STARTTIME))
    #DIFF=${DIFF%%.*}
    #echo $((DIFF)) | xargs printf "%.*f\n" $p
    #real_time=$(echo "$time a_command | grep ^real | awk 'print $2')
    echo "Time diff is: $DIFF seconds"
done
