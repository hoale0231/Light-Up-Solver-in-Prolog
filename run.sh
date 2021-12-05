#! /bin/bash

if [[ ! -e $1 ]]; then
	echo Usage: $0 input-file
	exit 1
fi

BASE=$1
BASE=${BASE#input/in}
BASE=${BASE%.txt}

./input_helper input/in$BASE.txt query/query$BASE.pl
swipl < query/query$BASE.pl > prolog/prolog$BASE.txt
./output_helper input/in$BASE.txt prolog/prolog$BASE.txt output/out$BASE.txt

