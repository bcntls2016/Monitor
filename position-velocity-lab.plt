set encoding iso_8859_15
set term postscript eps enhanced color font ",16" lw 2; set size nosquare 1,1
set out "position-velocity-lab.eps"
set grid
set ytics nomirror tc lt 1
set y2tics nomirror tc lt 2
set mxtics 4
set ylabel 'Length / [{\305}]' tc lt 1
set y2label 'Velocity / [ms^-^1]' tc lt 2 
set xl 'Time / [ps]'
set title TITLE
p INDATA u 1:($4) w l axes x1y1 lt 1 t 'Distance between Rb*5p and the origin of the box', \
  INDATA u 1:(($10)*100) w l axes x1y2 lt 2 t 'Velocity of Rb*5p relative to origin of the box'
set out
