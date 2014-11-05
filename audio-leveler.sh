#!/bin/bash

# process arguments
while [[ $# > 1 ]]
do
key="$1"
shift

# set vars
case $key in
    -g|--gain)
    GAIN="$1"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
done

# catch no gain set
if [ ! ${GAIN} ]; then
	
	# pring usage info
    echo
    echo "`basename $0`"
    echo
    echo "options:"
    echo " -g --gain	required gain modification (ie. -1dB)"
    echo
	
	# display reference file detail if present
    if [ -f ./reference.wav ]; then
		normalize-audio -n ./reference.wav;
    fi
	
	# loop over wav files in converting folder converting and showing detail
	for file in ./*.mp3; do 
		normalize-audio -n "${file}";
	done

	# now for aif's
	for file in ./*.aif; do 
        normalize-audio -n "${file}";
    done

	# exit
    exit;

fi

# remove processing dir if present from last run
if [ -d ./.converting ]; then
	rm -rf ./.converting;
fi

# create converted dir if not present
if [ ! -d ./converted ]; then
	mkdir ./converted;
fi

# create processing dir if not present
if [ ! -d ./.converting ]; then
	mkdir ./.converting;
fi

# convert each mp3 and aif into processing folder 
if hash avconv > /dev/null; then
    for file in ./*.mp3
        do avconv -loglevel quiet -i "${file}" "./.converting/`echo ${file%.mp3}.wav`";
    done
    for file in ./*.aif
        do avconv -loglevel quiet -i "${file}" "./.converting/`echo ${file%.aif}.wav`";
    done
fi

# adjust gain on all processing (wav) files
if hash normalize-audio > /dev/null; then
    if [ -d ./.converting ]; then
    	
    	# display the reference file detail
    	if [ -f ./reference.wav ]; then
        	normalize-audio -n ./reference.wav;
        fi
        
        # cd to converting folder
        cd ./.converting;
        
        # loop over wav files in converting folder converting and showing detail
    	for file in *.wav; do 
    		normalize-audio -q "${file}";
			normalize-audio -q -g ${GAIN} "${file}";
    		normalize-audio -n "${file}";
    		
    		# post process move files to converted folder and convert back to mp3
			if [ -d ../converted ]; then
				avconv -loglevel quiet -i "${file}" "../converted/`echo ${file%.wav}.mp3`";
			fi
    	done
    fi
fi

cd ..;

# remove processing dir
if [ -d ./.converting ]; then
	rm -rf ./.converting;
fi

# exit
exit;