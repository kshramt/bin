#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

GMT gmtset PAPER_MEDIA a4+
GMT gmtset PAGE_ORIENTATION portrait
GMT gmtset MEASURE_UNIT cm
GMT gmtset ANNOT_FONT_SIZE_PRIMARY 5p
GMT gmtset ANNOT_FONT_SIZE_SECONDARY 5p
GMT gmtset LABEL_FONT_SIZE 10p

GMT psxy -Jx1c -R0/80/0/15 -K <<EOF
EOF

CPT_FILE=$(mktemp --suffix=.cpt)

for cpt in cool copper cyclic drywet gebco globe gray haxby hot jet nighttime no_green ocean panoply paired polar rainbow red2green relief sealand seis split topo wysiwyg globe_light
do
    if GMT makecpt -C${cpt} -Z 2>&1 | grep 'makecpt: Warning: Making a continuous cpt from a discrete cpt may give unexpected results!' > /dev/null; then
        GMT makecpt -C${cpt} > ${CPT_FILE}
    else
        GMT makecpt -C${cpt} -Z > ${CPT_FILE}
    fi
    GMT psscale -X3 -D0/5/8/0.5 -C${CPT_FILE} -E -B:${cpt}: -O -K
done

GMT psxy -J -R -O <<EOF
EOF
