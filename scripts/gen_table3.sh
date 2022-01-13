#!/bin/bash
declare -a StringArray=("antlr"  "bloat" "chart" "eclipse" "fop" "hsqldb" "jython" "luindex" "lusearch" "pmd" "xalan")
#declare -a StringArray=("antlr") 
for filename in ${StringArray[@]} ; do
    echo -e -n "${filename}\t"
    #dotfile="benchmark/dacapo_bench/decremental/${filename}.dot"
    seqfile="benchmark/dacapo_bench/incremental/${filename}_inc.seq"
    ./dynamic/DyckReach 1 init.dot $seqfile
    ./dynamic/DyckReach 0 init.dot $seqfile
    dotfile="benchmark/dacapo_bench/decremental/${filename}.dot"
    seqfile="benchmark/dacapo_bench/decremental/${filename}_dec.seq"
    ./dynamic/DyckReach 1 $dotfile $seqfile
    ./dynamic/DyckReach 0 $dotfile $seqfile
    #input_incseq="benchmark/dacapo_bench/incremental/${filename}${numstr}.seq"
    #time ../DyckReach 1  $init_dotfile $input_seqfile
    #time ../DyckReach 0  $init_dotfile $input_seqfile
    echo " "
done

declare -a StringArray2=("btree"  "compiler"  "crypto"  "helloworld"  "mushroom"  "sample"   "startup"  "xml" "check"  "compress"  "derby"   "mpegaudio"   "parser"    "scimark"  "sunflow")
#declare -a StringArray2=("btree" "check")
for filename in ${StringArray2[@]} ; do
    echo -e -n "${filename}\t"
    seqfile="benchmark/tal/incremental/${filename}_inc.seq"
    ./dynamic/DyckReach 1 init.dot $seqfile
    ./dynamic/DyckReach 0 init.dot $seqfile
    dotfile="benchmark/tal/decremental/${filename}.dot"
    seqfile="benchmark/tal/decremental/${filename}_dec.seq"
    ./dynamic/DyckReach 1 $dotfile $seqfile
    ./dynamic/DyckReach 0 $dotfile $seqfile
    echo " "
done
