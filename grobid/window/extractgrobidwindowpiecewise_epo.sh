
#for x in {10001..10003}
for x in {10001..10003}
do
 echo "DOING epor $x"
 python3 ../multi_proc_prog.py window_epo2020/windowscombined-$x window_epo2020/window_epo2020OUT/grobidwindowoutput-$x
done
