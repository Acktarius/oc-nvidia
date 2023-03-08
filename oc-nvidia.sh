#!/bin/bash

ocfor="(Overclock for "
ocfor+=$(nvidia-settings -c :0 -q gpus | grep 'NVIDIA' | cut -d " " -f 8,9,10)
echo "${ocfor}"

for n in 1 3 5 7; do
v=$(( $n+1 ))
if [ "${!n}" == "pl" ]; then
pl=${!v}
else
	if [ "${!n}" == "cc" ]; then
	cclkoff=${!v}
	else
		if [ "${!n}" == "mc" ]; then
		mclkoff=${!v}		
		else
			if [ "${!n}" == "fs" ]; then
			fspeed=${!v}
			fi	
		fi
	fi
fi
done

#read -p "Enter power limit : " pl
if [ ! $pl > 0 ]; then
pl=$(cat oc_start.txt | grep 'pl' | cut -d " " -f 3)
fi
nvidia-smi -i 0 -pl $pl


#read -p "gpu core clock offset : " cclkoff
if [ ! $cclkoff > 0 ]; then
cclkoff=$(cat oc_start.txt | grep 'cclkoff' | cut -d " " -f 3)
fi
textcc='[gpu:0]/GPUGraphicsClockOffset[2]='
textcc+=$cclkoff
nvidia-settings -c :0 -a $textcc

#read -p "gpu memory clock offset : " mclkoff
if [ ! $mclkoff > 0 ]; then
mclkoff=$(cat oc_start.txt | grep 'mclkoff' | cut -d " " -f 3)
fi
textmc='[gpu:0]/GPUMemoryTransferRateOffset[2]='
textmc+=$mclkoff
nvidia-settings -c :0 -a $textmc

#read -p "Fan speed % " fspeed
if [ ! $fspeed > 0 ]; then
fspeed=$(cat oc_start.txt | grep 'fspeed' | cut -d " " -f 3)
fi
textf='[fan:0]/GPUTargetFanSpeed='
textf+=$fspeed
nvidia-settings -a $textf
textf='[fan:1]/GPUTargetFanSpeed='
textf+=$fspeed
nvidia-settings -a $textf

echo 'Done, happy hashing !'
