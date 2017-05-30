#java -jar SpinPreProcess.jar ”<1,w,x,1>,<2,w,x,2>,<3,r,x,2>,<4,r,x,1>" $1
SECONDS=0
index=0
size=5
#index1=$(echo index | wc -l /Users/subhajitsidhanta/Downloads/Spin/training_data.arff)
index=$(wc -l < /Users/subhajitsidhanta/Downloads/Spin/training_data.arff)
index="$(expr $index / $size)"
for i in `seq 0 $index`
do
    SECONDS=0
    java -jar SpinPreProcess.jar $1 $i $size
    spin -a conspec$1Viol.pml
    gcc -o pan pan.c
    ./pan -a
    #echo “****after spin run: $i”
    duration=$SECONDS
    echo "$((duration / 3600)) minutes and $((duration % 3600)) seconds execution time."
done