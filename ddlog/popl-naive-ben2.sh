#!/bin/bash


benchmark=(btree       compiler    crypto      helloworld  mushroom    sample      startup     xml check       compress    derby       mpegaudio   parser      scimark     sunflow)
#benchmark=(btree)
#benchmark=(antlr  bloat   eclipse   hsqldb  chart )
num_set=(10 20 30 40 50)

for prog in "${benchmark[@]}"
do
    
    echo "** $prog compile"


    rm graph.dat
    echo "** $prog incremental naive"
    file=""
    total=0
    while IFS= read -r line
    do
    	file+="$line"
    	file+=$'\n'
    	echo "$file" | sed  '/^$/d' > tmp.seq
    	./gen-dyck.pl 0 tmp.seq > graph.dat
    	t=$(./run | sed 's/Timestamp: //g')
    	total=$((total+t))

    done < popl/incremental/${prog}_inc.seq
    display=`echo $total | sed 's/^/0.000000001*/g' | bc`
    echo "Total: $display"


    rm graph.dat
    echo "** $prog decremental naive"

    file=""
    total=0
    while IFS= read -r line
    do
    	file+="$line"
    	file+=$'\n'
    	echo "$file" | sed  '/^$/d' > tmp.seq
    	./gen-dyck.pl 4 tmp.seq popl/decremental/${prog}_init.seq > graph.dat
    	t=$(./run | sed 's/Timestamp: //g')
    	total=$((total+t))

    done < popl/decremental/${prog}_dec.seq
    display=`echo $total | sed 's/^/0.000000001*/g' | bc`
    echo "Total: $display"


    
    rm graph.dat
    echo "** $prog mixed naive"
    for num in "${num_set[@]}"
    do

	echo "    seq $num"
        rm graph.dat
	file=""
	total=0
	while IFS= read -r line
	do
    	    file+="$line"
    	    file+=$'\n'
    	    echo "$file" | sed  '/^$/d' > tmp.seq
    	    ./gen-dyck.pl 4 tmp.seq popl/mixed/${prog}_${num}init.seq > graph.dat
    	    t=$(./run | sed 's/Timestamp: //g')
    	    total=$((total+t))

	done < popl/mixed/${prog}${num}.seq
	display=`echo $total | sed 's/^/0.000000001*/g' | bc`
	echo "Total: $display"
    done

    


done



