#!/bin/bash
declare -a StringArray=("antlr"  "bloat" "chart" "eclipse" "fop" "hsqldb" "jython" "luindex" "lusearch" "pmd" "xalan")
declare -a NumArray=("10" "20" "30" "40" "50")
#declare -a StringArray=("antlr") 
for filename in ${StringArray[@]} ; do
    echo -e -n "${filename}\t"
    for numstr in ${NumArray[@]} ; do
        dotfile="benchmark/dacapo_bench/mixed/${filename}_${numstr}init.dot"
        seqfile="benchmark/dacapo_bench/mixed/${filename}${numstr}.seq"
        ./dynamic/DyckReach 1 $dotfile $seqfile
        ./dynamic/DyckReach 0 $dotfile $seqfile
        #input_incseq="benchmark/dacapo_bench/incremental/${filename}${numstr}.seq"
        #time ../DyckReach 1  $init_dotfile $input_seqfile
        #time ../DyckReach 0  $init_dotfile $input_seqfile
    done
    echo " "
done

declare -a StringArray2=("btree"  "sample"   "parser"  "check"  "compiler"  "compress" "crypto"  "derby" "helloworld"   "mpegaudio"   "scimark"  "startup"  "sunflow" "xml" )         
#declare -a StringArray2=("btree" "check")
for filename in ${StringArray2[@]} ; do
    echo -e -n "${filename}\t"
    for numstr in ${NumArray[@]} ; do
        dotfile="benchmark/tal/mixed/${filename}_${numstr}init.dot"
        seqfile="benchmark/tal/mixed/${filename}${numstr}.seq"
        ./dynamic/DyckReach 1 $dotfile $seqfile
        ./dynamic/DyckReach 0 $dotfile $seqfile
        #input_incseq="benchmark/dacapo_bench/incremental/${filename}${numstr}.seq"
        #time ../DyckReach 1  $init_dotfile $input_seqfile
        #time ../DyckReach 0  $init_dotfile $input_seqfile
    done
    echo " "
done
