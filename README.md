# moni-tor: a basic graph generator using Gnuplot for iftop traffic.

## Requirements:
+ Gnuplot
+ iftop (for the log)

## Usage:
- Generating an iftop log:
+ iftop -t -B -i <network interface> | tee /tmp/net_traffic
+ ctrl-c to stop iftop.

- Running the script:
+ ./moni-tor.sh /tmp/net_traffic <download/upload/both> <output destination>
+ The output destination will save the download/upload/download and upload files individually as an image.

# Licence:
Copyright 2019 Jack Muir (j_mc_m), under GPL V3+.

moni-tor is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
