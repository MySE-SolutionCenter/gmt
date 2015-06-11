#! /bin/bash
# $Id$
#
# Computes the gravity and VGG anomaly over a cylinder and compares
# with theory and brute (sum of tiny cubes) results in cylinder25.txt
ps=cyltest.ps
# cylinder.mod was made thus:
#cylinder 25 10 10 1333 5084
gmt math -T-100/100/1 0 = trk
gmt talwani3d cylinder.mod -D1670 -Mh -Ntrk -o0,2 > faa.txt
gmt talwani3d cylinder.mod -D1670 -Mh -Ntrk -o0,2 -Fp > vgg_p.txt
gmt talwani3d cylinder.mod -D1670 -Mh -Ntrk -o0,2 -Fv > vgg_s.txt
gmt math -T-100/250/350 -25 = > tmp
gmt math -T-100/250/350 -I 25  = >> tmp
gmt psxy -R-100/100/-100/250 -JX6i/6i -P -Glightgray tmp -: -K -Xc -Y4i > $ps
awk '{print $1, $3}' cylinder25.txt | gmt psxy -R-100000/100000/-100/250 -J -Wfaint,blue -O -K >> $ps
awk '{print $1, $3}' cylinder25.txt | gmt psxy -R -J -Sc0.1c -Gblue -O -K >> $ps
awk '{print $1, $2}' cylinder25.txt | gmt psxy -R -J -Sc0.1c -Gred -O -K >> $ps
gmt psxy -R-100/100/-100/250 -J faa.txt -W0.25p,red -O -K -Bxafg1000 -Byafg1000 -BWsne+t"Testing FAA and VGG over cylinder" >> $ps
# Exact value over top at x = 0 only
gmt math -T-100/100/200 2 PI MUL 6.673e-6 MUL 1670 MUL 5084 1333 SUB 1333 25000 HYPOT ADD 5084 25000 HYPOT SUB MUL = tmp
gmt psxy -R -J -O -K tmp -W0.5p,- >> $ps
gmt psxy -R -J -O -K vgg_s.txt -W0.5p,darkgreen   >> $ps
gmt psxy -R -J -O -K vgg_p.txt -W1.5p,orange,2_2:0 >> $ps
cat << EOF > legend.txt
S 0.2i - 0.3i - 0.5p,- 0.5i FAA (at x = 0)
S 0.2i c 0.05i red - 0.5i FAA (brute force)
S 0.2i c 0.05i blue - 0.5i VGG (brute force)
S 0.2i - 0.3i - 1.5p,red 0.5i FAA
S 0.2i - 0.3i - 1.5p,darkgreen 0.5i VGG [SSK eq.]
S 0.2i - 0.3i - 1.5p,orange,2_2:0 0.5i VGG [PW eq.]
EOF
gmt pslegend -R -J -O -K -DjTL/2i/TL/0.1i/0.1i legend.txt -F+gwhite+p >> $ps
# Plot cylinder
gmt psxy -R-100/100/0/5084 -JX6i/-2.5i -O -K -Y-2.75i -Gblack -Bxafg1000+u" km" -Byaf -BWSne << EOF >> $ps
-25	5084
25	5084
25	1333
-25	1333
EOF
gmt psxy -R -J -O -T >> $ps
