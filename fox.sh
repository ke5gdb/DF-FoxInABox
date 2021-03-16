#!/bin/bash

# Raspberry Pi 'FoxInABox'
#
# 2016 - Slim Shady & Thick Shady


if [[ "$1" == --no-wait ]] ; then
	NOWAIT=TRUE
fi

cd /boot/fox/

echo "17" | sudo tee /sys/class/gpio/export
echo "out" | sudo tee /sys/class/gpio/gpio17/direction
#echo "1" | sudo tee /sys/class/gpio/gpio17/active_low
echo "0" | sudo tee /sys/class/gpio/gpio17/value

while [ TRUE ] ; do
	while read line; do
		# Array of conditionals to interpret script.txt file
		if [[ "$line" == wait* ]] ; then		# Wait command
			if [ $NOWAIT ] ; then
				sleep 5
			else
				sleep $(echo $line | cut -c5-)
			fi

		elif [[ "$line" == \#* ]] ; then		# Don't parse comments
			echo -n

		elif [[ "$line" == "" ]] ; then			# Don't parse empty lines
			echo -n

		elif [[ "$line" == key* ]] ; then		# Key command
			echo Keying radio
			echo "1" | sudo tee /sys/class/gpio/gpio17/value

		elif [[ "$line" == unkey* ]] ; then		# Key command
			echo -n Unkeying radio
			echo "0" | sudo tee /sys/class/gpio/gpio17/value

		elif [[ "$line" == sayf* ]] ; then		# Unkey command
			SAY=$(echo $line | cut -c5-)
			echo $SAY
			pico2wave -w /tmp/audio.wav "$SAY"
			play -v .25 /tmp/audio.wav > /dev/null 2>&1

		elif [[ "$line" == sayfile* ]] ; then		# Say file command
			FILE=$(echo $line | cut -c8-)
			echo $FILE
			cat $FILE | festival --tts

		elif [[ "$line" == saycmd* ]] ; then		# Say file command
			CMD=$(echo $line | cut -c8-)
			echo $CMD
			eval $CMD | festival --tts

		elif [[ "$line" == sayfcmd* ]] ; then		# Say file command
			CMD=$(echo $line | cut -c8-)
			echo $CMD
			SAY=$(eval $CMD)
			echo $SAY
			pico2wave -w /tmp/audio.wav "$SAY"
			play -v .25 /tmp/audio.wav > /dev/null 2>&1

		elif [[ "$line" == say* ]] ; then		# Say command
			SAY=$(echo $line | cut -c4-)
			echo $SAY
			echo $SAY | festival --tts

		else						# Play files
			echo -n Playing $line...
			play -v .25 $line > /dev/null 2>&1
			echo done!
		fi
	done < script.txt
done
