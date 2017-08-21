program com_velocity

	implicit none
	integer							::	i, j, nentries
	real (kind = 8)					::	dt, mass
	real (kind = 8), allocatable	::	t(:), xheintt(:), tet(:), npt(:), rimpt(:,:), &
										rcmt(:,:), vimpt(:,:), vcmt(:,:), limpt(:,:)!, lhet(:,:)
	real (kind = 8), parameter		:: ua2ppstohbar = 0.157460975155982741051865790456372908890603750261480535551
	real (kind = 8), parameter		:: ktops=7.63822291d0
	read(5,*) nentries
	!write(*,*) nentries
	allocate(t(nentries))
	allocate(xheintt(nentries))
	allocate(tet(nentries))
	allocate(npt(nentries))
	allocate(rimpt(nentries,3))
	allocate(rcmt(nentries,3))
	allocate(vimpt(nentries,3))
	allocate(vcmt(nentries,3))
	allocate(limpt(nentries,3))
	!allocate(lhet(nentries,3))
	do i = 1,nentries
		!read(5,*) t(i), rimpt(i,:), rcmt(i,:), vimpt(i,:), lhet(i,:), xheintt(i), tet(i), npt(i)
		read(5,*) t(i), rimpt(i,:), rcmt(i,:), vimpt(i,:), xheintt(i), tet(i), npt(i)
	end do
	
	! This correction to the x-component of the ang.momt. of the droplet is only
	! because in the old version of the dynamics code it is multiplied with the
	! volume element twice. For most grids this is (0.4A)^3=0.064A^3.
	!lhet(:,1)=lhet(:,1)/0.064

	mass=131.29 ! mass in atomic units (u)
	vimpt=vimpt/ktops
  	dt=t(2)-t(1)
  	!! calc. vcm(t) from rcm(t) [ vcmt from rcmt ]
  	do j=1,3
  		do i=1,nentries
			if (i>4 .and. i<(nentries-3)) then	! do 8th-order central finite difference
				vcmt(i,j) = (1.0/280) * rcmt(i-4,j) + (-4.0/105) * rcmt(i-3,j) &
						+ (1.0/5) * rcmt(i-2,j) + (-4.0/5) * rcmt(i-1,j) &
						+ (4.0/5) * rcmt(i+1,j) + (-1.0/5) * rcmt(i+2,j) &
						+ (4.0/105) * rcmt(i+3,j) + (-1.0/280) * rcmt(i+4,j)
				vcmt(i,j) = vcmt(i,j)/dt
			else if (i<5) then					! do 6th-order forward finite difference
				vcmt(i,j) = (-49.0/20) * rcmt(i,j) &
						+ (6.0) * rcmt(i+1,j) + (-15.0/2) * rcmt(i+2,j) &
						+ (20.0/3) * rcmt(i+3,j) + (-15.0/4) * rcmt(i+4,j) &
						+ (6.0/5) * rcmt(i+5,j) + (-1.0/6) * rcmt(i+6,j)
				vcmt(i,j) = vcmt(i,j)/dt
			else								! do 6th-order backward finite difference
				vcmt(i,j) = (49.0/20) * rcmt(i,j) &
						+ (-6.0) * rcmt(i-1,j) + (15.0/2) * rcmt(i-2,j) &
						+ (-20.0/3) * rcmt(i-3,j) + (15.0/4) * rcmt(i-4,j) &
						+ (-6.0/5) * rcmt(i-5,j) + (1.0/6) * rcmt(i-6,j)
				vcmt(i,j) = vcmt(i,j)/dt
			end if
		end do
  	end do
  	
  	!! calc. limp(t) from rimp(t), rcm(t), vimp(t) and vcm(t)
  	do i=1,nentries
		limpt(i,1) = ( rimpt(i,2) - rcmt(i,2) ) * ( vimpt(i,3) - vcmt(i,3) ) &
					- ( rimpt(i,3) - rcmt(i,3) ) * ( vimpt(i,2) - vcmt(i,2) )
		limpt(i,2) = - ((rimpt(i,1)-rcmt(i,1))*(vimpt(i,3)-vcmt(i,3)) - (rimpt(i,3)-rcmt(i,3))*(vimpt(i,1)-vcmt(i,1)))
		limpt(i,3) = ( rimpt(i,1) - rcmt(i,1) ) * ( vimpt(i,2) - vcmt(i,2) ) &
					- ( rimpt(i,2) - rcmt(i,2) ) * ( vimpt(i,1) - vcmt(i,1) )
	end do
	limpt = mass * ua2ppstohbar * limpt
  	
	write(*,*) "## Time is in picosecond (ps)"
	write(*,*) "## Positions are in angstrom (A)"
	write(*,*) "## Velocities are in angstrom per picosecond (A/ps)"
	write(*,*) "## Angular momenta are in reduced Planck's constant (hbar)"
	write(*,*) "## Energies are in kelvin (K)"
	write(*,*)
	write(*,7000)	"#", &
					"1", &
					"2", &
					"3", &
					"4", &
					"5", &
					"6", &
					"7", &
					"8", &
					"9", &
					"10", &
					"11", &
					"12", &
					"13", &
					"14", &
					"15", &
					"16", &
					"17", &
					"18", &
					"19"!, &
					!"20", &
					!"21", &
					!"22"
	write(*,7000)	"#", &
					"t", &
					"ximp(t)", &
					"yimp(t)", &
					"zimp(t)", &
					"xcm(t)", &
					"ycm(t)", &
					"zcm(t)", &
					"vximp(t)", &
					"vyimp(t)", &
					"vzimp(t)", &
					"vxcm(t)", &
					"vycm(t)", &
					"vzcm(t)", &
					"lximp(t)", &
					"lyimp(t)", &
					"lzimp(t)", &
					!"lxHe(t)", &
					!"lyHe(t)", &
					!"lzHe(t)", &
					"eXHeint(t)", &
					"etot(t)", &
					"nparticles(t)"
	write(*,7200) "#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	
	do i=1,nentries
		write(*,7100)	t(i), &
						rimpt(i,1), &
						rimpt(i,2), &
						rimpt(i,3), &
						rcmt(i,1), &
						rcmt(i,2), &
						rcmt(i,3), &
						vimpt(i,1), &
						vimpt(i,2), &
						vimpt(i,3), &
						vcmt(i,1), &
						vcmt(i,2), &
						vcmt(i,3), &
						limpt(i,1), &
						limpt(i,2), &
						limpt(i,3), &
						!lhet(i,1), &
						!lhet(i,2), &
						!lhet(i,3), &
						xheintt(i), &
						tet(i), &
						npt(i)
	end do
	
	7000 format(a1, 1x, a4, 18(2x, a13), 2x, a11, 2x, a12, 2x, a16)
	7100 format(f6.1, 18(2x, es13.6), 2x, f11.6, 2x, f12.6, 2x, es16.10)
	7200 format(a321)
end program
