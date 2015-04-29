# Readme: lampe
interactive bash-script to control up to 9 hue-lamps.

## Configure
This script does not register a user on the hue-bridge; see [Getting Started at meethue.com](http://www.developers.meethue.com/documentation/getting-started). After that you should set the IP of your bridge by modifying the variable "bridgeip" inside the "lampe"-script with your favourite editor.

### configure using vi
```.sh
cd # to location of the lampe-script
vim lampe
2j
12l
i
# enter the IP of your hui-bridge
:wq
```
## Usage
Use "lampe" like a computer-game without gamepad or arrow-keys - use WASD. *(:*
```
W - increase brightness
A - lower saturation
S - lower brightness
D - increase saturation
```

### example output 
```
Lamp 3 [==========--                                      ] off  
```

## TODOs
- [ ] add support for hue to set color with 