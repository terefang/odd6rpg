#!/bin/bash
#
bDATE=$(date '+%Y.%m.%d_%H%M%S')

XDIR=$(cd $(dirname $0) && pwd)

bDIR=lite

case "$1" in
    -lite*) 
        bDIR=lite
        ;;
    -core*) 
        bDIR=core
        ;;
    *)
        echo "unknown option, exiting."
        exit 1
        ;; 
esac


FROM=""
for x in ${XDIR}/${bDIR}/*.md; do

    FROM="$FROM -i ${x}"

    T=$(basename $x)

done

cd $XDIR && $XDIR/xbin/md2pdf.sh ${FROM} -o $XDIR/${bDIR}.pdf

# END.