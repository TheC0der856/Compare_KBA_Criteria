#!/bin/bash
mkdir 3
cp /scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/CLUMPP.files/ClumppPopFile 3/pop
cp /scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/CLUMPP.files/ClumppIndFile.output 3/ind
cp /scratch/utr_gronefeld/clumpak/K=2/MajorCluster/labelsBelowFigure 3/labels
cp distruct/ClustersPermutationsAndColorsFile 3/perm
cp /scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/drawparams 3/drawparams
distruct/distruct1.1 -K 5 -M 1 -N 345 -p 3/pop -i 3/ind -o 3/out.ps -b 3/labels -c 3/perm -d 3/drawparams
mv 3/out.ps /scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/distructOutput.ps
rm 3/pop 3/ind 3/labels 3/drawparams 3/perm
rmdir 3
ps2pdf /scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/distructOutput.ps /scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/distructOutput.pdf
gs -sDEVICE=png16m -r600 -sOutputFile=/scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/distructOutput.png -dNOPAUSE -dBATCH -c "<< /PageSize [495 120] /PageOffset [-55 455] >> setpagedevice" -f /scratch/utr_gronefeld/clumpak/K=5/MinorCluster1/distructOutput.ps