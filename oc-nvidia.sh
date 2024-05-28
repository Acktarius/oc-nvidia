#!/bin/bash
# overclock nvidia for Ubuntu users
# this file is subject to Licence
# Copyright (c) 2024, Acktarius

#declaration variables and functions
#trip
trip() {
kill -INT $$
}
#Nvidia gpu
nbCard=$(nvidia-settings -q gpus | grep -c 'NVIDIA')
#fsv fan speed value
declare -a fsv
fsvs=$(cat oc_settings.txt | grep 'fsv')
fsvss=${fsvs##"fsv,"}
read -a fsv <<< ${fsvss//","/" "}


fanSpeed() {
nvidia-settings -a [fan:$1]/GPUTargetFanSpeed=$2

}

#------------------------------------------------------------Core Clock
: '
declare -a cclkv
cclkvs$(cat oc_settings.txt | grep 'cclkv')
cclkvss=${cclkvs##"cclkv,"}
read -a cclkv <<< ${cclkvss//","/" "}

coreClock() {
nvidia-settings -c :0 -a [gpu:$1]/GPUGraphicsClockOffset[2]=$2
}
'
#------------------------------------------------------------Core Clock OffSet
declare -a cclkov
cclkovs=$(cat oc_settings.txt | grep 'cclkov')
cclkovss=${cclkovs##"cclkov,"}
read -a cclkov <<< ${cclkovss//","/" "}
echo "${#cclkov[@]}"
coreClockOffset() {
#nvidia-settings -a [gpu:$1]/GpuPowerMizerMode=1
nvidia-settings -c :$1 -a [gpu:$1]/GPUGraphicsClockOffset[2]=$2
}


#------------------------------------------------------------Power Limit
declare -a plv
plvs=$(cat oc_settings.txt | grep 'plv')
plvss=${plvs##"plv,"}
read -a plv <<< ${plvss//","/" "}
echo "${#plv[@]}"
powerLimit() {
nvidia-smi -i $1 -pl $2 > /dev/null
}

#Checks fans value
## nb parameters
if [[ ${#fsv[@]} != $nbCard ]]; then
echo "incorrect number of parameters"
sleep 3
trip
fi
## acceptable value
for ((i = 0 ; i < ${#fsv[@]} ; i++)); do
    if [[ ${fsv[$i]} -lt 41 ]]; then
  	echo "fan spped value incorrect, less than 41"
  	sleep 3
  	break
  	trip
  elif [[ ${fsv[$i]} -gt 100 ]]; then
  	echo "fan speed value incorrect, more than 100"
  	sleep 3
  	break
  	trip
  fi
done
#Check core offset value
#Checks fans value
## nb parameters
if [[ ${#cclkov[@]} != $nbCard ]]; then
echo "incorrect number of parameters for core clock offset"
sleep 3
trip
fi



#Main
##Fan Speed
#for ((i = 0 ; i < ${#fsv[@]} ; i++)); do
#fanSpeed $i ${fsv[$i]}
#done
##Coreclock offset

##PowerLimit
for ((i = 0 ; i < ${#plv[@]} ; i++)); do
powerLimit $i ${plv[$i]}
done
