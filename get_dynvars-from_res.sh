#!/bin/bash

[ ! -f calc-comvel ] && ifort -O3 -o calc-comvel calc-comvel.f90 
INPUT=$1
RCM="rcm.dat"
RIMP="rimp.dat"
VIMP="vimp.dat"
XHEINT="xheint.dat"
TE="te.dat"
NP="np.dat"
TIME="time.dat"
STAMP=$(date +"%Y%m%d%H%M")
TMPOUT="dynvars.$STAMP.dat.tmp"
OUTFILE="dynvars.$STAMP.dat"


DT="5*10^(-4)"
ITER="200"
OFFSET="60"


TIMESTEP=$(echo "scale=6;$ITER*$DT"|bc)
awk '/Center of Mass/{print$8,$9,$10}' $INPUT | sed 's/,//g' | sed 's/)//' > $RCM
awk '/Impurity position/{getline x;print$3,$4,x}' $INPUT > $RIMP
awk '/Impurity velocity/{getline x;print$3,$4,$5,x}' $INPUT > $VIMP
awk '/Interaction energy \(X-He\) . /{print$5}' $INPUT > $XHEINT
awk '/TOTAL energy \(He\+X\)/{print$5}' $INPUT > $TE
awk '/Number of particles ....... /{print$5}' $INPUT > $NP
NENTRIES=$(cat $RCM | wc -l)
TOTAL=$(echo "scale=1;$NENTRIES*$TIMESTEP+$OFFSET"|bc)
START=$(echo "scale=1;$TIMESTEP+$OFFSET"|bc)
seq $START $TIMESTEP $TOTAL > $TIME

### Full time resolution
echo $NENTRIES > $TMPOUT
paste $TIME $RIMP $RCM $VIMP $XHEINT $TE $NP >> $TMPOUT
rm $TIME $RIMP $RCM $VIMP $XHEINT $TE $NP

#### Reduce time resolution to reduce numerical noise in the COM velocity derivative.
#TMP1="tmp1.dat"
#TMP2="tmp2.dat"
#CUT=5 # Only keep every (N%5)th line
#paste $TIME $RIMP $RCM $VIMP $LHE $XHEINT $TE $NP > $TMP1
#awk 'NR%$CUT==0' $TMP1 > $TMP2
#NENTRIES=$(cat $TMP2 | wc -l)
#echo $NENTRIES > $TMPOUT
#cat $TMP2 >> $TMPOUT
#rm $TIME $RIMP $RCM $VIMP $XHEINT $TE $NP $TMP1 $TMP2 $LHE

./calc-comvel < $TMPOUT > $OUTFILE
rm $TMPOUT

./plot.sh $OUTFILE
