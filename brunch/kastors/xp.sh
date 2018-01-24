#!/bin/bash

runtimes="libkomp gcc clang"

threads="96 88 80 72 24 32 40 48 56 64"
for t in $threads; do
    for r in $runtimes; do
        prog="/home/pviroule/kastors-noaff/kastors/build-${r}/plasma/dpotrf_taskdep"
        output="all_data_${r}.dat"
        ld_path=""
        if [ "$r" == "libkomp" ]; then
            ld_path="LD_LIBRARY_PATH=/home/pviroule/install/libkomp-affinity/lib:$LD_LIBRARY_PATH"
            prog="/home/pviroule/kastors/build-clang/plasma/dpotrf_taskdep"
        elif [ "$r" == "ompss" ]; then
            source /home/pviroule/ompss-17.06.1/ompss.env
        fi
        echo "$r" >> xp.log
        prefix="OMP_NUM_THREADS=\"$t\" OMP_PLACES=\"{0}:$t\""
        #eval "$ld_path $prefix ldd $prog >> xp.log"
        echo "$ld_path $prefix $prog -n 8192 -b 256 -i 3 >> $output" >> xp.log
        echo "$ld_path $prefix $prog -n 16384 -b 256 -i 3 >> $output" >> xp.log
        echo "$ld_path $prefix $prog -n 32768 -b 512 -i 3 >> $output" >> xp.log
        eval "$ld_path $prefix $prog -n 8192 -b 256 -i 5 >> $output"
        eval "$ld_path $prefix $prog -n 16384 -b 256 -i 5 >> $output"
        eval "$ld_path $prefix $prog -n 32768 -b 512 -i 5 >> $output"
    done
done

threads="1 2 4 8 12 16"

for t in $threads; do
    for r in $runtimes; do
        prog="/home/pviroule/kastors-noaff/kastors/build-${r}/plasma/dpotrf_taskdep"
        output="all_data_${r}.dat"
        ld_path=""
        if [ "$r" == "libkomp" ]; then
            ld_path="LD_LIBRARY_PATH=/home/pviroule/install/libkomp-affinity/lib:$LD_LIBRARY_PATH"
            prog="/home/pviroule/kastors/build-clang/plasma/dpotrf_taskdep"
        elif [ "$r" == "ompss" ]; then
            source /home/pviroule/ompss-17.06.1/ompss.env
        fi
        echo "$r" >> xp.log
        prefix="OMP_NUM_THREADS=\"$t\" OMP_PLACES=\"{0}:$t\""
        #eval "$ld_path $prefix ldd $prog >> xp.log"
        echo "$ld_path $prefix $prog -n 8192 -b 256 -i 3 >> $output" >> xp.log
        echo "$ld_path $prefix $prog -n 16384 -b 256 -i 3 >> $output" >> xp.log
        echo "$ld_path $prefix $prog -n 32768 -b 512 -i 3 >> $output" >> xp.log
        eval "$ld_path $prefix $prog -n 8192 -b 256 -i 5 >> $output"
        eval "$ld_path $prefix $prog -n 16384 -b 256 -i 5 >> $output"
        eval "$ld_path $prefix $prog -n 32768 -b 512 -i 5 >> $output"
    done
done
