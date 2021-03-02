# Copyright 2019 Jack Muir (j_mc_m), under GPL V3+
#
# moni-tor is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

#
# Notices:
# - Before I get any comments about this, yes, I know that it is *very*
#   bad practice to comment on *how* the scripts function, rather than just
#   explaining what they do. 
# - Also, I know that it looks like utter crap.
#

#!/bin/bash

time=0
time_interval=2

download_upload=$2
dest=$3

usage() {
    echo "Usage: $0 <iftop log> <download/upload/both> <output destination>"
    exit
}

# Checks there are three arguments given.
if [ $(echo $@ | wc -w) != 3 ]; then
    usage
fi

# Checks that a valid option is given.
if [ $download_upload == "download" ]; then
    odd_even="Total receive rate:"
elif [ $download_upload == "upload" ]; then
    odd_even="Total send rate:"
elif [ $download_upload == "both" ]; then
    $0 $1 download $3
    $0 $1 upload $3
    exit
else
    echo "Not an option: $2"
    usage
fi

# While there is input
while IFS= read -r line; do
    #
    # This mess performs unit conversion on each line as it's read, so that it's
    # all in kilobytes (KiB). Basically, it checks the unit, removes the unit,
    # and rearranges it, adding in a decimal place where needed.
    #
    if [ $(echo $line | grep '[0-9][b|B]') ]; then
	echo "$time 0.0$(echo $line | tr -d "b")"
    elif [ $(echo $line | grep '[0-9]M[b|B]') ]; then
	echo "$time $(echo $line | tr -d "M[b|B]" | sed 's/\.//')0"
    else
	echo "$time $(echo $line | tr -d "K[b|B]")"
    fi

    # Increment the time.
    ((time += $time_interval))

    #
    # This mess filters the text in the input file so give it a stream of text to
    # read into the while loop, to then generate a graph out of. It filters the
    # row based on the download/upload option, filters the 10 second interval
    # column, deletes the blank lines, then the output of the whole while loop is
    # piped into Gnuplot
    #
done <<< $(grep "$odd_even" $1 \
	       | awk '{print $4}' \
	       | sed '/^$/d') \
    | gnuplot -p \
	      -e "set xlabel \"Time (seconds)\"" \
	      -e "set ylabel \"Speed (KiB)\"" \
	      -e "set terminal png" \
	      -e "set output \"$dest/$download_upload.png\"" \
	      -e "plot \"/dev/stdin\" with linespoints"
