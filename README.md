# oc-nvidia

---
meant to be use with NVIDIA 1660Super and 1660Ti  
---

**seems to work well with driver 550**  
`sudo apt install nvidia-driver-550-server nvidia-dkms-550-server`  
`sudo reboot`  
*check with*  
`nvidia-smi`  
*if successful*  
`sudo apt install nvidia-settings`  
  
*in /usr/share/X11/xorg.conf.d/10-nvidia.conf* add :  
`Option "Coolbits" "28"`  


## this script is delivered “as is” and I deny any and all liability for any damages arising out of using this script

## Install

ideally place in the /opt folder

`cd /opt`

`git clone https://github.com/Acktarius/oc-nvidia.git`

`cd oc-nvidia`

`sudo chmod 755 oc-nvidia.sh`

## Run

oc-nvidia is a bash script to setup overclock pre mining operation.  

`sudo ./oc-nvidia.sh`  

you can call specific setting for a coin ie. :  

`sudo ./oc-nvidia.sh CCX`  

you can reset with :  
`sudo ./oc-nvidia.sh reset`  

the value will be picked from oc_settings.txt file
*(oc_settings.txt files provided in this repo are for a 9 cards rig)*  

*a* ***-1*** *value will get ignored*   
* power limit in W :  
`plv`  
* core clock offset :  
  `cclkov`    
* memory clock offset :  
`mclkov`  
* fan speed for a two fan gpu in % :  
`fsv`  

