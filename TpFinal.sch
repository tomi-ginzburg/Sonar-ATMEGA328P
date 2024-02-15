EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:C C3
U 1 1 654DC34D
P 6750 3850
F 0 "C3" H 6865 3896 50  0000 L CNN
F 1 "100n" H 6865 3805 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 6788 3700 50  0001 C CNN
F 3 "~" H 6750 3850 50  0001 C CNN
	1    6750 3850
	1    0    0    -1  
$EndComp
$Comp
L Device:R R3
U 1 1 654DCB1A
P 7400 3700
F 0 "R3" V 7193 3700 50  0000 C CNN
F 1 "10k" V 7284 3700 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 7330 3700 50  0001 C CNN
F 3 "~" H 7400 3700 50  0001 C CNN
	1    7400 3700
	0    1    1    0   
$EndComp
$Comp
L power:GND #PWR0101
U 1 1 654DE095
P 6750 4000
F 0 "#PWR0101" H 6750 3750 50  0001 C CNN
F 1 "GND" H 6755 3827 50  0000 C CNN
F 2 "" H 6750 4000 50  0001 C CNN
F 3 "" H 6750 4000 50  0001 C CNN
	1    6750 4000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 654DE65A
P 7100 4100
F 0 "#PWR0102" H 7100 3850 50  0001 C CNN
F 1 "GND" H 7105 3927 50  0000 C CNN
F 2 "" H 7100 4100 50  0001 C CNN
F 3 "" H 7100 4100 50  0001 C CNN
	1    7100 4100
	1    0    0    -1  
$EndComp
Connection ~ 6750 3700
Text GLabel 7750 3700 2    50   Input ~ 0
Vcc
Wire Wire Line
	4850 1650 4850 1750
Text GLabel 4850 1650 0    50   Input ~ 0
Vcc
$Comp
L MCU_Microchip_ATmega:ATmega328P-PU U1
U 1 1 654E18F7
P 4850 3400
F 0 "U1" H 4206 3446 50  0000 R CNN
F 1 "ATmega328P-PU" H 4206 3355 50  0000 R CNN
F 2 "Package_DIP:DIP-28_W7.62mm_Socket_LongPads" H 4850 3400 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/ATmega328_P%20AVR%20MCU%20with%20picoPower%20Technology%20Data%20Sheet%2040001984A.pdf" H 4850 3400 50  0001 C CNN
	1    4850 3400
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Push SW1
U 1 1 654E4205
P 7100 3900
F 0 "SW1" V 7054 4048 50  0000 L CNN
F 1 "SW_Push" V 7145 4048 50  0000 L CNN
F 2 "Button_Switch_THT:SW_PUSH_6mm" H 7100 4100 50  0001 C CNN
F 3 "~" H 7100 4100 50  0001 C CNN
	1    7100 3900
	0    1    1    0   
$EndComp
$Comp
L Device:Crystal Y1
U 1 1 654EBF64
P 6600 3150
F 0 "Y1" V 6554 3281 50  0000 L CNN
F 1 "16Meg" V 6645 3281 50  0000 L CNN
F 2 "Crystal:Crystal_HC49-4H_Vertical" H 6600 3150 50  0001 C CNN
F 3 "~" H 6600 3150 50  0001 C CNN
	1    6600 3150
	0    1    1    0   
$EndComp
$Comp
L Device:CP1 C1
U 1 1 654EDDA7
P 6950 3000
F 0 "C1" V 7202 3000 50  0000 C CNN
F 1 "22p" V 7111 3000 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 6950 3000 50  0001 C CNN
F 3 "~" H 6950 3000 50  0001 C CNN
	1    6950 3000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6800 3300 6600 3300
Wire Wire Line
	7100 3300 7350 3300
Wire Wire Line
	7350 3300 7350 3150
Wire Wire Line
	7350 3000 7100 3000
Wire Wire Line
	6800 3000 6600 3000
$Comp
L power:GND #PWR0103
U 1 1 654F0F65
P 7600 3200
F 0 "#PWR0103" H 7600 2950 50  0001 C CNN
F 1 "GND" H 7605 3027 50  0000 C CNN
F 2 "" H 7600 3200 50  0001 C CNN
F 3 "" H 7600 3200 50  0001 C CNN
	1    7600 3200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7600 3200 7600 3150
Wire Wire Line
	7600 3150 7350 3150
Connection ~ 7350 3150
Wire Wire Line
	7350 3150 7350 3000
$Comp
L power:GND #PWR0104
U 1 1 654F8EBF
P 5950 5200
F 0 "#PWR0104" H 5950 4950 50  0001 C CNN
F 1 "GND" H 5955 5027 50  0000 C CNN
F 2 "" H 5950 5200 50  0001 C CNN
F 3 "" H 5950 5200 50  0001 C CNN
	1    5950 5200
	1    0    0    -1  
$EndComp
Wire Wire Line
	5950 5200 5950 5150
$Comp
L Device:R R1
U 1 1 654FA5A9
P 6300 4450
F 0 "R1" H 6370 4496 50  0000 L CNN
F 1 "1k" H 6370 4405 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 6230 4450 50  0001 C CNN
F 3 "~" H 6300 4450 50  0001 C CNN
	1    6300 4450
	1    0    0    -1  
$EndComp
Wire Wire Line
	7100 3700 6750 3700
Wire Wire Line
	5450 3700 6750 3700
$Comp
L Connector:Conn_01x03_Female J5
U 1 1 6550761D
P 5000 5600
F 0 "J5" V 5150 5550 50  0000 L CNN
F 1 "KY-8" V 5250 5500 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x03_P2.54mm_Vertical" H 5000 5600 50  0001 C CNN
F 3 "~" H 5000 5600 50  0001 C CNN
	1    5000 5600
	0    1    1    0   
$EndComp
Wire Wire Line
	5650 5150 5100 5150
Wire Wire Line
	5100 5150 5100 5400
$Comp
L power:GND #PWR0106
U 1 1 65509312
P 4450 5300
F 0 "#PWR0106" H 4450 5050 50  0001 C CNN
F 1 "GND" H 4455 5127 50  0000 C CNN
F 2 "" H 4450 5300 50  0001 C CNN
F 3 "" H 4450 5300 50  0001 C CNN
	1    4450 5300
	1    0    0    -1  
$EndComp
Wire Wire Line
	4450 5300 4900 5300
Wire Wire Line
	4900 5300 4900 5400
Wire Wire Line
	6150 2050 6150 2300
Wire Wire Line
	6150 2300 5450 2300
Text GLabel 6050 1950 0    50   Input ~ 0
Vcc
$Comp
L power:GND #PWR0107
U 1 1 6550CC4E
P 5650 1850
F 0 "#PWR0107" H 5650 1600 50  0001 C CNN
F 1 "GND" H 5655 1677 50  0000 C CNN
F 2 "" H 5650 1850 50  0001 C CNN
F 3 "" H 5650 1850 50  0001 C CNN
	1    5650 1850
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x04_Male J2
U 1 1 6550F91B
P 8450 2400
F 0 "J2" H 8422 2282 50  0000 R CNN
F 1 "UltraSonido" H 8422 2373 50  0000 R CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x04_P2.54mm_Vertical" H 8450 2400 50  0001 C CNN
F 3 "~" H 8450 2400 50  0001 C CNN
	1    8450 2400
	-1   0    0    1   
$EndComp
Wire Wire Line
	7500 2300 7500 1700
Wire Wire Line
	7500 1700 5450 1700
Wire Wire Line
	5450 1700 5450 2200
$Comp
L power:GND #PWR0108
U 1 1 655150B0
P 7650 2150
F 0 "#PWR0108" H 7650 1900 50  0001 C CNN
F 1 "GND" H 7655 1977 50  0000 C CNN
F 2 "" H 7650 2150 50  0001 C CNN
F 3 "" H 7650 2150 50  0001 C CNN
	1    7650 2150
	1    0    0    -1  
$EndComp
Wire Wire Line
	7650 2150 7650 2100
Wire Wire Line
	7650 2100 7750 2100
Wire Wire Line
	7750 2100 7750 2200
Text GLabel 7600 2500 0    50   Input ~ 0
Vcc
Wire Wire Line
	7100 3700 7250 3700
Connection ~ 7100 3700
Wire Wire Line
	7550 3700 7750 3700
$Comp
L power:GND #PWR0109
U 1 1 655302D8
P 4850 4900
F 0 "#PWR0109" H 4850 4650 50  0001 C CNN
F 1 "GND" H 4855 4727 50  0000 C CNN
F 2 "" H 4850 4900 50  0001 C CNN
F 3 "" H 4850 4900 50  0001 C CNN
	1    4850 4900
	1    0    0    -1  
$EndComp
Wire Wire Line
	3100 2750 3550 2750
Wire Wire Line
	3850 2750 3850 1750
Wire Wire Line
	3850 1750 4850 1750
Connection ~ 4850 1750
Wire Wire Line
	4850 1750 4850 1900
Wire Wire Line
	4850 4900 3100 4900
Wire Wire Line
	3100 4900 3100 2850
Connection ~ 4850 4900
Wire Wire Line
	4850 1750 4950 1750
Wire Wire Line
	4950 1750 4950 1900
Wire Wire Line
	5450 4600 5650 4600
Wire Wire Line
	5650 4600 5650 5150
$Comp
L Connector:Conn_01x02_Male J3
U 1 1 65530942
P 2900 2750
F 0 "J3" H 3008 2931 50  0000 C CNN
F 1 "Vin" H 3008 2840 50  0000 C CNN
F 2 "TerminalBlock_Phoenix:TerminalBlock_Phoenix_MKDS-3-2-5.08_1x02_P5.08mm_Horizontal" H 2900 2750 50  0001 C CNN
F 3 "~" H 2900 2750 50  0001 C CNN
	1    2900 2750
	1    0    0    -1  
$EndComp
Text GLabel 8850 2850 2    50   Input ~ 0
Vcc
Wire Wire Line
	8450 2850 8850 2850
$Comp
L power:GND #PWR01
U 1 1 654FF98F
P 8700 3050
F 0 "#PWR01" H 8700 2800 50  0001 C CNN
F 1 "GND" H 8705 2877 50  0000 C CNN
F 2 "" H 8700 3050 50  0001 C CNN
F 3 "" H 8700 3050 50  0001 C CNN
	1    8700 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	8450 3050 8700 3050
Wire Wire Line
	8450 2950 9050 2950
Wire Wire Line
	9050 2950 9050 2600
Wire Wire Line
	5450 2500 7300 2500
Wire Wire Line
	7300 2500 7300 2600
Wire Wire Line
	7300 2600 9050 2600
Wire Wire Line
	6600 3000 6250 3000
Wire Wire Line
	6250 3000 6250 2800
Wire Wire Line
	6250 2800 5450 2800
Connection ~ 6600 3000
Wire Wire Line
	5450 2900 6150 2900
Wire Wire Line
	6150 2900 6150 3300
Wire Wire Line
	6150 3300 6600 3300
Connection ~ 6600 3300
Wire Wire Line
	5450 2700 7100 2700
Wire Wire Line
	7100 2700 7100 2950
Wire Wire Line
	7950 2850 7200 2850
Wire Wire Line
	7200 2850 7200 2600
Wire Wire Line
	7200 2600 5450 2600
$Comp
L Connector_Generic:Conn_02x03_Top_Bottom J6
U 1 1 6551FD82
P 8150 2950
F 0 "J6" H 8200 2625 50  0000 C CNN
F 1 "ICSP" H 8200 2716 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_2x03_P2.54mm_Vertical" H 8150 2950 50  0001 C CNN
F 3 "~" H 8150 2950 50  0001 C CNN
	1    8150 2950
	1    0    0    1   
$EndComp
Wire Wire Line
	7950 2950 7750 2950
Wire Wire Line
	7750 2950 7750 3500
Wire Wire Line
	7750 3500 7100 3500
Wire Wire Line
	7100 3500 7100 3700
$Comp
L Device:CP1 C2
U 1 1 654EFB9F
P 6950 3300
F 0 "C2" V 7202 3300 50  0000 C CNN
F 1 "22p" V 7111 3300 50  0000 C CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 6950 3300 50  0001 C CNN
F 3 "~" H 6950 3300 50  0001 C CNN
	1    6950 3300
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7950 3050 7500 3050
Wire Wire Line
	7500 3050 7500 2950
Wire Wire Line
	7500 2950 7100 2950
Wire Wire Line
	5950 3900 5450 3900
Wire Wire Line
	5950 3900 5950 5050
Wire Wire Line
	6300 4600 6300 4950
Wire Wire Line
	6300 4300 6300 4000
Wire Wire Line
	6300 4000 5450 4000
Wire Wire Line
	6300 4000 6550 4000
Wire Wire Line
	6550 4000 6550 4300
Connection ~ 6300 4000
$Comp
L Device:R R4
U 1 1 656A4091
P 6750 2200
F 0 "R4" V 6850 2150 50  0000 C CNN
F 1 "1k" V 6850 2300 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 6680 2200 50  0001 C CNN
F 3 "~" H 6750 2200 50  0001 C CNN
	1    6750 2200
	0    1    1    0   
$EndComp
$Comp
L Device:C C4
U 1 1 656A522E
P 3550 2900
F 0 "C4" H 3665 2946 50  0000 L CNN
F 1 "100n" H 3665 2855 50  0000 L CNN
F 2 "Capacitor_THT:C_Disc_D3.0mm_W1.6mm_P2.50mm" H 3588 2750 50  0001 C CNN
F 3 "~" H 3550 2900 50  0001 C CNN
	1    3550 2900
	1    0    0    -1  
$EndComp
Connection ~ 3550 2750
Wire Wire Line
	3550 2750 3850 2750
$Comp
L power:GND #PWR02
U 1 1 656A6390
P 3550 3100
F 0 "#PWR02" H 3550 2850 50  0001 C CNN
F 1 "GND" H 3555 2927 50  0000 C CNN
F 2 "" H 3550 3100 50  0001 C CNN
F 3 "" H 3550 3100 50  0001 C CNN
	1    3550 3100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3550 3050 3550 3100
$Comp
L power:GND #PWR0110
U 1 1 656AE9DF
P 7000 2200
F 0 "#PWR0110" H 7000 1950 50  0001 C CNN
F 1 "GND" H 7005 2027 50  0000 C CNN
F 2 "" H 7000 2200 50  0001 C CNN
F 3 "" H 7000 2200 50  0001 C CNN
	1    7000 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	7000 2200 6900 2200
Wire Wire Line
	6600 2200 6600 2400
Wire Wire Line
	5450 2400 6600 2400
$Comp
L Motor:Motor_Servo M1
U 1 1 65763ABA
P 6950 1950
F 0 "M1" H 7282 2015 50  0000 L CNN
F 1 "Motor_Servo" H 7282 1924 50  0000 L CNN
F 2 "" H 6950 1760 50  0001 C CNN
F 3 "http://forums.parallax.com/uploads/attachments/46831/74481.png" H 6950 1760 50  0001 C CNN
	1    6950 1950
	1    0    0    1   
$EndComp
Wire Wire Line
	5650 1850 6650 1850
Wire Wire Line
	6050 1950 6650 1950
Wire Wire Line
	6150 2050 6650 2050
Wire Notes Line
	6900 4750 6900 5450
Wire Notes Line
	6550 5450 6550 4750
Wire Notes Line
	6900 5450 6550 5450
Wire Notes Line
	6550 4750 6900 4750
$Comp
L Connector:Conn_01x06_Female J4
U 1 1 654F1CE9
P 6850 5050
F 0 "J4" H 6700 4500 50  0000 L CNN
F 1 "BT HC-05" H 6550 4600 50  0000 L CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x06_P2.54mm_Vertical" H 6850 5050 50  0001 C CNN
F 3 "~" H 6850 5050 50  0001 C CNN
	1    6850 5050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0105
U 1 1 655046F6
P 6550 4600
F 0 "#PWR0105" H 6550 4350 50  0001 C CNN
F 1 "GND" H 6555 4427 50  0000 C CNN
F 2 "" H 6550 4600 50  0001 C CNN
F 3 "" H 6550 4600 50  0001 C CNN
	1    6550 4600
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 655041DB
P 6550 4450
F 0 "R2" V 6343 4450 50  0000 C CNN
F 1 "2k" V 6434 4450 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0207_L6.3mm_D2.5mm_P7.62mm_Horizontal" V 6480 4450 50  0001 C CNN
F 3 "~" H 6550 4450 50  0001 C CNN
	1    6550 4450
	-1   0    0    1   
$EndComp
Wire Wire Line
	6500 5250 6650 5250
Text GLabel 6500 5250 0    50   Input ~ 0
Vcc
Wire Wire Line
	6300 4950 6650 4950
Wire Wire Line
	5950 5050 6650 5050
Wire Wire Line
	5950 5150 6650 5150
Text Notes 6400 4950 0    50   ~ 0
Rx
Text Notes 6400 5050 0    50   ~ 0
Tx
Wire Notes Line
	4750 5400 5200 5400
Wire Notes Line
	5200 5400 5200 5700
Wire Notes Line
	5200 5700 4750 5700
Wire Notes Line
	4750 5700 4750 5400
Wire Wire Line
	7750 2200 8250 2200
Wire Wire Line
	7500 2300 8250 2300
Wire Wire Line
	6600 2400 8250 2400
Connection ~ 6600 2400
Wire Wire Line
	7600 2500 8250 2500
Wire Notes Line
	8150 2100 8150 2550
Wire Notes Line
	8150 2550 8550 2550
Wire Notes Line
	8550 2550 8550 2100
Wire Notes Line
	8550 2100 8150 2100
Text Notes 7800 2400 0    50   ~ 0
Trigger
Text Notes 7850 2300 0    50   ~ 0
Echo
NoConn ~ 5000 5400
NoConn ~ 6650 4850
NoConn ~ 6650 5350
$EndSCHEMATC
