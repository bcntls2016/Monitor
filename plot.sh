#!/bin/bash

INPUT_DATA=$1

TITLE='Rb*5p{/Symbol \50}{/Symbol \325}_1_/_2 {/Symbol \254} {/Symbol \325}_3_/_2{/Symbol \51}{/E \100}^4He_1_0_0_0, {/Symbol h}=0.4 {/Symbol \256} v_a_d_d{/Symbol \273}136 ms^-^1'

gnuplot5 -e "INDATA='${INPUT_DATA}'; \
	         TITLE='${TITLE}'" total_energy-num_particles.plt

gnuplot5 -e "INDATA='${INPUT_DATA}'; \
	         TITLE='${TITLE}'" position-velocity-com.plt

gnuplot5 -e "INDATA='${INPUT_DATA}'; \
	         TITLE='${TITLE}'" position-velocity-lab.plt