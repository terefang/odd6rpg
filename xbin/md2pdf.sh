#!/bin/bash

XDIR=$(cd $(dirname $0) && pwd)

bDATE=$(date '+%Y.%m.%d')

export OSFONTDIR=$XDIR/fonts:$HOME/.fonts:$HOME/.local/share/fonts:/usr/share/fonts
export GROFF_FONT_PATH=$XDIR/fonts:/usr/share/groff/1.22.3/font

FONT=lato

while [ ! "x" = "x$1" ]; do
    case "$1" in
        --font)
            shift
            FONT="$1"
            ;;
        -F)
            shift
            export OSFONTDIR="$1:$OSFONTDIR"
            export GROFF_FONT_PATH="$1:$GROFF_FONT_PATH"
            ;;
        -i)
            shift
            _FFROM="${_FFROM} $1"
            ;;
        -o)
            shift
            _FTO="$1"
            ;;
        *)
            echo "ERROR: unkown option '$1'"
            exit 1;
            ;;
    esac
    shift
done

if [ -z "$_FFROM" ]; then
    echo "ERROR: no input file" && exit 1
fi

if [ -z "$_FTO" ]; then
    echo "ERROR: no output file" && exit 1
fi


pandoc_data_dir="$XDIR/md2pdf"

PANDOC_OPTS=("--verbose" "--ascii" "-s" "-f" "markdown+grid_tables+table_captions")    # create an array
PANDOC_OPTS+=("-N")   # number sections
PANDOC_OPTS+=("-L")
PANDOC_OPTS+=("$XDIR/md2pdf/comments.lua")
PANDOC_OPTS+=("-L")
PANDOC_OPTS+=("$XDIR/md2pdf/pagebreak.lua")
PANDOC_OPTS+=("--data-dir=$pandoc_data_dir")
PANDOC_OPTS+=("--variable")
PANDOC_OPTS+=("layout=topspace=2cm,backspace=2cm,width=17cm,height=27cm")
PANDOC_OPTS+=("--variable")
PANDOC_OPTS+=("mainfont=${FONT}")
PANDOC_OPTS+=("--variable")
PANDOC_OPTS+=("fontsize=11pt")
PANDOC_OPTS+=("--variable")
PANDOC_OPTS+=("sansfont=ptsans")
PANDOC_OPTS+=("--variable")
PANDOC_OPTS+=("monofont=ptmono")
PANDOC_OPTS+=("--variable")
PANDOC_OPTS+=("papersize=A4")
PANDOC_OPTS+=("--variable")
#PANDOC_OPTS+=("fontfamily=LibreBaskerville")
PANDOC_OPTS+=("fontfamily=NunitoSans")
PANDOC_OPTS+=("-t")
PANDOC_OPTS+=("ms")
PANDOC_OPTS+=("--pdf-engine=pdfroff")
PANDOC_OPTS+=("--template=$XDIR/md2pdf/template.ms")

IFS=\ 
echo "EXEC: pandoc  ${PANDOC_OPTS[@]} -o $_FTO $_FFROM "

pandoc.local  "${PANDOC_OPTS[@]}" -o $_FTO $_FFROM

