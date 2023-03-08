# oc-nvidia

## this script is delivered “as is” and I deny any and all liability for any damages arising out of using this script

oc-nvidia is a bash script which can be launch as a service to setup overclock pre mining operation.
`sudo ./oc-nvidia.sh`

the value will be defaulted to the one in the oc_start.txt file
or can be set using parameter : 
* power limit in W :
`pl`
* core clock offset :
`cc`
* memory clock offset :
`mc`
* fan speed for a two fan gpu in % :
`fs`

## Exemple
`sudo ./oc-nvidia.sh fs 80 cc 100 mc -500 pl 100`

