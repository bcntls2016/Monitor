set term postscript eps enhanced color font ",16" lw 2; set size nosquare 1,1
set out "total_energy-num_particles.eps"
set grid
set ytics nomirror tc lt 1
set y2tics nomirror tc lt 2
set mxtics 4
set ylabel 'Energy / [K]' tc lt 1
set y2label 'Number' tc lt 2 
set xl 'Time / [ps]'
set title TITLE
p INDATA u 1:18 w l axes x1y1 lt 1 t 'Total energy', \
  INDATA u 1:19 w l axes x1y2 lt 2 t '# 4-helium atoms'
set out

