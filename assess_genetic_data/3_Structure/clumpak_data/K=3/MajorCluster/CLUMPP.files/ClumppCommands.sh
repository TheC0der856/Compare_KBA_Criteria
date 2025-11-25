#!/bin/bash
mkdir 3
cp /scratch/utr_gronefeld/clumpak/K=3/MajorCluster/CLUMPP.files/ClumppIndFile 3/ClumppIndFile
cp /scratch/utr_gronefeld/clumpak/K=3/MajorCluster/CLUMPP.files/clumpp.paramfile 3/clumpp.paramfile
CLUMPP/CLUMPP 3/clumpp.paramfile -i 3/ClumppIndFile -o 3/ClumppIndFile.output -j 3/ClumppIndFile.misc -c 345 -m 3 -k 3 -r 20
mv 3/ClumppIndFile.output 3/ClumppIndFile.misc /scratch/utr_gronefeld/clumpak/K=3/MajorCluster/CLUMPP.files
rm 3/ClumppIndFile 3/clumpp.paramfile
rmdir 3
