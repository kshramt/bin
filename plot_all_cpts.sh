#!/bin/sh

GMT gmtset PAPER_MEDIA a4+
GMT gmtset PAGE_ORIENTATION portrait
GMT gmtset MEASURE_UNIT cm
GMT gmtset ANNOT_FONT_SIZE_PRIMARY 5p
GMT gmtset ANNOT_FONT_SIZE_SECONDARY 5p
GMT gmtset LABEL_FONT_SIZE 10p

GMT psxy -Jx1c -R0/80/0/15 -K <<EOF
EOF

for cpt in cool copper cyclic drywet gebco globe gray haxby hot jet nighttime no_green ocean panoply paired polar rainbow red2green relief sealand seis split topo wysiwyg globe_light
do
    if GMT makecpt -C${cpt} -Z 2>&1 | grep 'makecpt: Warning: Making a continuous cpt from a discrete cpt may give unexpected results!' > /dev/null; then
        GMT makecpt -C${cpt} > tmp.cpt
    else
        GMT makecpt -C${cpt} -Z > tmp.cpt
    fi
    GMT psscale -X3 -D0/5/8/0.5 -Ctmp.cpt -E -B:${cpt}: -O -K
done

GMT psxy -J -R -O <<EOF
EOF
