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
echo "nombre de carte =  ${nbCard}"
#fsv fan speed value ------------------------------------------Fan Speed
declare -a fsv
fsvs=$(cat oc_settings.txt | grep 'fsv')
fsvss=${fsvs##"fsv:"}
read -a fsv <<< ${fsvss//","/" "}
declare -a fansv
for ((i = 0 ; i < ${#fsv[@]} ; i++)); do
if [[ $(nvidia-settings -q fans --verbose 2> /dev/null | grep -c "gpu:${i}") == 1 ]]; then
fansv+=("${fsv[$i]}")
elif [[ $(nvidia-settings -q fans --verbose 2> /dev/null | grep -c "gpu:${i}") == 2 ]]; then
fansv+=("${fsv[$i]}")
fansv+=("${fsv[$i]}")
fi
done
echo ${fansv[@]}

fanSpeedControl() {
nvidia-settings -a [gpu:$1]/GPUFanControlState=1
}
fanSpeed() {
nvidia-settings -a [fan:$1]/GPUTargetFanSpeed=$2
}

#------------------------------------------------------------Core Clock OffSet
declare -a cclkov
cclkovs=$(cat oc_settings.txt | grep 'cclkov')
cclkovss=${cclkovs##"cclkov:"}
read -a cclkov <<< ${cclkovss//","/" "}
echo "carte core clock offset ${#cclkov[@]} ${cclkov[@]} "
coreClockOffset() {
#nvidia-settings -a [gpu:$1]/GpuPowerMizerMode=0
nvidia-settings -a [gpu:$1]/GPUGraphicsClockOffsetAllPerformanceLevels=$2
}

#------------------------------------------------------------Mem Clock OffSet
declare -a mclkov
mclkovs=$(cat oc_settings.txt | grep 'mclkov')
mclkovss=${mclkovs##"mclkov:"}
read -a mclkov <<< ${mclkovss//","/" "}
echo "carte mem clock offset ${#mclkov[@]} ${mclkov[@]} "
memClockOffset() {
nvidia-settings -a [gpu:$1]/GPUMemoryTransferRateOffsetAllPerformanceLevels=$2
}

#------------------------------------------------------------Power Limit
declare -a plv
plvs=$(cat oc_settings.txt | grep 'plv')
plvss=${plvs##"plv:"}
read -a plv <<< ${plvss//","/" "}
echo "${#plv[@]}"
powerLimit() {
nvidia-smi -i $1 -pl $2 
#> /dev/null
}

#Checks nb parameters
if [[ ${#cclkov[@]} != $nbCard ]]; then
echo "numbers of core offset parameters doesn't match card quantity"; sleep 3; trip
elif  [[ ${#plv[@]} != $nbCard ]]; then
echo  "numbers of power limit parameters differs from number of cards"; sleep 3; trip
elif  [[ ${#fsv[@]} != $nbCard ]]; then
echo  "numbers of power limit parameters differs from number of cards"; sleep 3; trip
fi

#Checks fans value
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
##Check core offset value



#Main
##Fan Speed Control
for ((i = 0 ; i < ${#fsv[@]} ; i++)); do
fanSpeedControl $i
done

##Fan Speed
for ((i = 0 ; i < ${#fansv[@]} ; i++)); do
fanSpeed $i ${fansv[$i]}
done
##Coreclock offset
for ((i = 0 ; i < ${#cclkov[@]} ; i++)); do
coreClockOffset $i ${cclkov[$i]}
done

##Memclock offset
for ((i = 0 ; i < ${#mclkov[@]} ; i++)); do
memClockOffset $i ${mclkov[$i]}
done

##PowerLimit
for ((i = 0 ; i < ${#plv[@]} ; i++)); do
powerLimit $i ${plv[$i]}
done
