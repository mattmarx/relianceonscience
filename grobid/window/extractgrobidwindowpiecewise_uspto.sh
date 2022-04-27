for x in {10767..10783}
do
 echo "DOING  $x"
 python3 ../multi_proc_prog.py ./window_u20052019/windowscombined-$x ./window_u20052019/window_u20052019OUT/grobidwindowoutput-$x
done
