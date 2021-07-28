for x in {10001..10013}
do
 echo "DOING 2020 $x"
 python3 ../multi_proc_prog.py window_2020/windowscombined-$x /window_2020/window_2020OUT/grobidwindowoutput-$x
done
