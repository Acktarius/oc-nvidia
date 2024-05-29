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

## this script is delivered “as is” and I deny any and all liability for any damages arising out of using this script

ideally place in the /opt folder

`cd /opt`

`git clone https://github.com/Acktarius/oc-nvidia.git`

`cd oc-nvidia`

`sudo chmod 755 oc-nvidia.sh`


oc-nvidia is a bash script which can be launch as a service to setup overclock pre mining operation.

`sudo ./oc-nvidia.sh`

the value will be picked from oc_settings.txt file
or can be set using parameter : 
* power limit in W :  
`plv`  
* core clock offset :  
**WIP**  
* memory clock offset :  
**WIP**  
* fan speed for a two fan gpu in % :  
`fsv`  

