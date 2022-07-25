#!/bin/sh

export AFL_IMPORT_FIRST=1

alacritty -e bash -c 'afl-fuzz -i input -o output -m none -M compcov1 -- bin/compcov @@' &
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S compcov2 -L 0 -- bin/compcov @@'&

# Max 1 ASAN
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S sanitizers -- bin/sanitizers @@'&

alacritty -e bash -c 'afl-fuzz -i input -o output -c bin/cmplog -p exploit -m none -S cmplog1 -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -c bin/cmplog -p coe -m none -S cmplog2 -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -c bin/cmplog -m none -S cmplog3 -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -c bin/cmplog -p exploit -m none -S cmplog4 -L 0 -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -c bin/cmplog -p coe -m none -S cmplog5 -L 0 -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -c bin/cmplog -m none -S cmplog6 -L 0 -- bin/regular @@'&

alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular1 -L 0 -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular2 -L 0 -p explore -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular3 -L 0 -p coe -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular4 -L 0 -p exploit -- bin/regular @@'&

alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular5 -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular6 -p explore -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular7 -p coe -- bin/regular @@'&
alacritty -e bash -c 'afl-fuzz -i input -o output -m none -S regular8 -p exploit -- bin/regular @@'&

# Switch "-i input" to "-i -" to restart fuzzing
