#!/bin/bash

XDIR=$(cd $(dirname $0) && pwd)

XFDIR=$XDIR/fonts

FNAME=name
RNAME=name
FFILE=name.ttf
FTYPE=ttf
MAP=/usr/share/groff/current/font/devps/generate/textmap

while [ ! "x" = "x$1" ]; do
    case "$1" in
        -file|-f)
            shift
            FFILE="$1"
            ;;
        -name|-n)
            shift
            FNAME="$1"
            ;;
        -roffname)
            shift
            RNAME="$1"
            ;;
        -ttf)
            FTYPE=ttf
            ;;
        -otf)
            FTYPE=otf
            ;;
        *)
            echo "ERROR: unkown option '$1'"
            exit 1;
            ;;
    esac
    shift
done

cp ${FFILE} ${XFDIR}/${RNAME}.${FTYPE}

fontforge -lang=ff -c "Open(\"${FFILE}\");Generate(\"${XFDIR}/devps/${RNAME}.pfa\");"

cd ${XFDIR}/devps/ && afmtodit -o ${XFDIR}/devps/${RNAME} ${RNAME}.afm ${MAP} ${RNAME}

echo "" >> ${XFDIR}/devps/download
echo -e "${FNAME}\t${RNAME}.pfa" >> ${XFDIR}/devps/download
echo -e "${RNAME}\t${RNAME}.pfa" >> ${XFDIR}/devps/download
echo "" >> ${XFDIR}/devps/download
