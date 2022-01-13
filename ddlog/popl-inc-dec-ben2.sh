#!/bin/bash

#benchmark=("sample")
#benchmark=(sample)


benchmark=(btree       compiler    crypto      helloworld  mushroom    sample      startup     check       compress    derby     parser      scimark     sunflow mpegaudio  xml)
#benchmark=(btree )    #compiler    crypto      helloworld  mushroom    sample      startup     check       compress    derby     parser      scimark     sunflow mpegaudio  xml)
#benchmark=(antlr  bloat  chart  eclipse  fop  hsqldb  jython  luindex  lusearch  pmd  xalan)

#benchmark=(xml)

num_set=(10 20 30 40 50)


for prog in "${benchmark[@]}"
do

    ## This is the original version which compiles each prog.
    # echo "** $prog compile"
    # rm dyck.dl graph.dat
#     ./gen-dyck.pl 1 popl/inc/${prog}_inc.seq > graph.dat
    # ./compile

    # This is the new version with pre-compiled prog.
#    rm -rf dyck_ddlog
#    ln -sf /nethome/qzhang414/projects/datalog/build/${prog}_ddlog   dyck_ddlog

    echo "** $prog static"
    ./gen-dyck-i.pl 1 popl/incremental/${prog}_inc.seq > graph.dat
    ./run | sed 's/Timestamp: /0.000000001*/g' | bc

    
    rm graph.dat
    echo "** $prog incremental"
    ./gen-dyck-i.pl 2 popl/incremental/${prog}_inc.seq > graph.dat
#    ./gen-dyck.pl 2 popl/incremental/${prog}_inc.seq > graph.dat
    ./run  | sed 's/Timestamp: /0.000000001*/g' | bc

    rm graph.dat
    echo "** $prog decremental"
    ./gen-dyck-i.pl 3 popl/decremental/${prog}_dec.seq popl/decremental/${prog}_init.seq > graph.dat
#    ./gen-dyck.pl 3 popl/decremetal/${prog}_dec.seq popl/decremetal/${prog}_init.seq > graph.dat
    { read s_time; read d1_time; read d2_time; read d3_time; read d4_time; read d5_time; read d6_time; read d7_time; read d8_time; read d9_time; read d10_time;} < <(./run | sed 's/Timestamp: //g')
    ftime=$((d1_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d2_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d3_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d4_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d5_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d6_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d7_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d8_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d9_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc
    ftime=$((d10_time-s_time))
    echo $ftime | sed 's/^/0.000000001*/g' | bc



    
    


done



