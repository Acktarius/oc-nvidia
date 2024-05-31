#!/bin/bash
# overclock nvidia for Ubuntu users
# this file is subject to Licence
# Copyright (c) 2024, Acktarius

#declaration variables and functions
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo $SCRIPT_DIR
#trip
trip() {
kill -INT $$
}
#implement value of coin mention in argument
if [[ -n $1 ]];then
if [[ -f $SCRIPT_DIR/oc_settings_$1.txt ]]; then
cat $SCRIPT_DIR/oc_settings_$1.txt > $SCRIPT_DIR/oc_settings.txt
fi
fi
#Nvidia gpu
nbCard=$(nvidia-settings -q gpus | grep -c 'NVIDIA')
echo "nombre de carte =  ${nbCard}"
#Reset function ------------------------------------------------Reset
reset() {
for ((j = 0 ; j < ${nbCard} ; j++)); do
##fans
nvidia-settings -a [gpu:$j]/GPUFanControlState=0
##Core clock & mem offset
nvidia-settings -a [gpu:$j]/GPUGraphicsClockOffsetAllPerformanceLevels=0
nvidia-settings -a [gpu:$j]/GPUMemoryTransferRateOffsetAllPerformanceLevels=0
##Power
dPower=$(nvidia-smi -i $j -q | grep "Default Power Limit" | head -n 1 | cut -d ":" -f 2 | cut -d "." -f 1 | tr -d " "
)
if [[ $dPower =~ ^[0-9]+$ ]]; then
nvidia-smi -i $j -pl $dPower
fi
done
}
#fsv fan speed value ------------------------------------------Fan Speed
declare -a fsv
fsvs=$(cat $SCRIPT_DIR/oc_settings.txt | grep 'fsv')
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

fanSpeedControl() {
if [[ $2 != "-1" ]]; then 
nvidia-settings -a [gpu:$1]/GPUFanControlState=1
fi
}
fanSpeed() {
if [[ $2 != "-1" ]]; then 
nvidia-settings -a [fan:$1]/GPUTargetFanSpeed=$2
fi
}

#------------------------------------------------------------Core Clock OffSet
declare -a cclkov
cclkovs=$(cat $SCRIPT_DIR/oc_settings.txt | grep 'cclkov')
cclkovss=${cclkovs##"cclkov:"}
read -a cclkov <<< ${cclkovss//","/" "}
echo "carte core clock offset ${#cclkov[@]} ${cclkov[@]} "
coreClockOffset() {
#nvidia-settings -a [gpu:$1]/GpuPowerMizerMode=0
if [[ $2 != "-1" ]]; then 
nvidia-settings -a [gpu:$1]/GPUGraphicsClockOffsetAllPerformanceLevels=$2
fi
}

#------------------------------------------------------------Mem Clock OffSet
declare -a mclkov
mclkovs=$(cat $SCRIPT_DIR/oc_settings.txt | grep 'mclkov')
mclkovss=${mclkovs##"mclkov:"}
read -a mclkov <<< ${mclkovss//","/" "}
echo "carte mem clock offset ${#mclkov[@]} ${mclkov[@]} "
memClockOffset() {
if [[ $2 != "-1" ]]; then 
nvidia-settings -a [gpu:$1]/GPUMemoryTransferRateOffsetAllPerformanceLevels=$2
fi
}

#------------------------------------------------------------Power Limit
declare -a plv
plvs=$(cat $SCRIPT_DIR/oc_settings.txt | grep 'plv')
plvss=${plvs##"plv:"}
read -a plv <<< ${plvss//","/" "}
echo "${#plv[@]}"
powerLimit() {
if [[ $2 != "-1" ]]; then 
nvidia-smi -i $1 -pl $2 > /dev/null
fi
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
if [[ ${fsv[$i]} != "-1" ]]; then
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
fi
done
##Check core offset value



#Main
#Reset ?
if [[ $1 == "reset" ]]; then
reset
exit
fi

##Fan Speed Control
for ((i = 0 ; i < ${#fsv[@]} ; i++)); do
fanSpeedControl $i ${fsv[$i]}
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

unset plv mclkov cclkov fansv fsv
