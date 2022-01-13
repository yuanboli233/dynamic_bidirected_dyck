#!/bin/bash

#benchmark=("sample")
#benchmark=(sample)


benchmark=(btree       compiler    crypto      helloworld  mushroom    sample      startup     check       compress    derby     parser      scimark     sunflow mpegaudio  xml)
#benchmark=(btree )     # compiler    crypto      helloworld  mushroom    sample      startup     check       compress    derby     parser      scimark     sunflow mpegaudio  xml)
#benchmark=(antlr  bloat  chart  eclipse  fop  hsqldb  jython  luindex  lusearch  pmd  xalan)
#benchmark=(btree)
num_set=(10 20 30 40 50)


for prog in "${benchmark[@]}"
do

    ## This is the original version which compiles each prog.
    # echo "** $prog compile"
    # rm dyck.dl graph.dat
    #./gen-dyck.pl 1 popl/inc/${prog}_inc.seq > graph.dat
    # ./compile

    # This is the new version with pre-compiled prog.
#    rm -rf dyck_ddlog
#    ln -sf /nethome/qzhang414/projects/datalog/build/${prog}_ddlog   dyck_ddlog
    

    
    #  echo "** $prog static"
    #  ./run | sed 's/Timestamp: /0.000000001*/g' | bc

    # rm graph.dat
    # echo "** $prog incremental"
    # ./gen-dyck.pl 2 popl/inc/${prog}_inc.seq > graph.dat
    # ./run  | sed 's/Timestamp: /0.000000001*/g' | bc
    
    # rm graph.dat
    # echo "** $prog decremental"
    # ./gen-dyck.pl 3 popl/dec/${prog}_dec.seq popl/dec/${prog}.seq > graph.dat
    # { read s_time; read d_time;} < <(./run | sed 's/Timestamp: //g')
    # ftime=$((d_time-s_time))
    # echo $ftime | sed 's/^/0.000000001*/g' | bc


    
    echo "** $prog mixed"
    for num in "${num_set[@]}"
    do
    	echo "    seq $num"
    	rm graph.dat
    	./gen-dyck.pl 3 popl/mixed/${prog}${num}.seq  popl/mixed/${prog}_${num}init.seq > graph.dat
	
    	{ read s_time; read d_time;} < <(./run | sed 's/Timestamp: //g')
    	ftime=$((d_time-s_time))
    	echo $ftime | sed 's/^/0.000000001*/g' | bc
    done


done



