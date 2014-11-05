audio-leveler
=============

Bash script to match audio levels in several mp3 and aif files based on a required bB level. 

Usage: 

$ audio-leveler.sh

Outputs arg list and levels of files to be converted. If reference.wav is present this is shown also (handy if you're trying to match against an existing file)

$ audio-leveler.sh -g -4dB

Adjusts files to aprox. peak level of -4dB and converts to mp3 files at ./converted. Original files are not modified.