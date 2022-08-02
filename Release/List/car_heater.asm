
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATtiny13A
;Program type           : Application
;Clock frequency        : 9,600000 MHz
;Memory model           : Tiny
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 16 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Automatic register allocation for global variables: On
;Smart register allocation: Off

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny13A
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 64
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0010
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _flag=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

	.CSEG
;#include <tiny13a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <1wire.h>
;
;#define SBR(port, bit)        port |= (1<<bit)
;#define CBR(port, bit)        port &= (~(1<<bit))
;#define INV(port, bit)        port ^= (1<<bit)
;#define SBRC(port, bit)      ((port & (1<<bit)) == 0)
;#define SBRS(port, bit)      ((port & (1<<bit)) != 0)
;
;#define BTN             2
;#define BUZZER          0
;#define POWER           OCR0B
;#define BTN_PRESSED     !PINB.2
;
;//Settings
;#define TEMP_SW         4
;#define STEP_TIME       3
;#define STEP_POWER      20
;#define MAX_TIME        15
;#define MAX_POWER       100
;#define DEFAULT_POWER   40
;#define DEFAULT_TIME    12
;
;eeprom unsigned char power_set;
;eeprom unsigned char time_set;
;
;//**********************
;unsigned char flag;
;#define SETTINGS        0
;
;char btn_func(void);
;
;void initdev(){
; 0000 0022 void initdev(){

	.CSEG
_initdev:
; .FSTART _initdev
; 0000 0023 //Config port
; 0000 0024     SBR(PORTB, BTN);
	SBI  0x18,2
; 0000 0025     CBR(DDRB, BTN);
	CBI  0x17,2
; 0000 0026     SBR(DDRB, BUZZER);
	SBI  0x17,0
; 0000 0027     SBR(DDRB, 1);
	SBI  0x17,1
; 0000 0028 // Timer/Counter 0 initialization
; 0000 0029 TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (1<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (1<<WGM00);  //TOP on OCR0A Freq PWM = 90kHz
	LDI  R30,LOW(35)
	OUT  0x2F,R30
; 0000 002A TCCR0B=(1<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00); //freq DIV 1
	LDI  R30,LOW(9)
	OUT  0x33,R30
; 0000 002B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 002C OCR0A=100;  //TOP
	LDI  R30,LOW(100)
	OUT  0x36,R30
; 0000 002D OCR0B=MAX_POWER;   //PWM, OCR0B pin only! (whith TOP on OCR0A)
	OUT  0x29,R30
; 0000 002E 
; 0000 002F //Turnoff analogcomp
; 0000 0030     ACSR=(1<<ACD);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0031 }
	RET
; .FEND
;
;void buzz(unsigned char cnt, unsigned int del ){
; 0000 0033 void buzz(unsigned char cnt, unsigned int del ){
_buzz:
; .FSTART _buzz
; 0000 0034    unsigned char i;
; 0000 0035 
; 0000 0036     for(i=0; i<cnt; i++){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R16
;	cnt -> Y+3
;	del -> Y+1
;	i -> R16
	LDI  R16,LOW(0)
_0x4:
	LDD  R30,Y+3
	CP   R16,R30
	BRSH _0x5
; 0000 0037         SBR(PORTB, BUZZER);
	SBI  0x18,0
; 0000 0038         delay_ms(del);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _delay_ms
; 0000 0039         CBR(PORTB, BUZZER);
	CBI  0x18,0
; 0000 003A         delay_ms(del);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _delay_ms
; 0000 003B     }
	SUBI R16,-1
	RJMP _0x4
_0x5:
; 0000 003C }
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void delay_min(unsigned char var){
; 0000 003E void delay_min(unsigned char var){
_delay_min:
; .FSTART _delay_min
; 0000 003F     unsigned char min, i;
; 0000 0040 
; 0000 0041     for(min=0; min<var; min++){
	ST   -Y,R26
	RCALL __SAVELOCR2
;	var -> Y+2
;	min -> R16
;	i -> R17
	LDI  R16,LOW(0)
_0x7:
	LDD  R30,Y+2
	CP   R16,R30
	BRSH _0x8
; 0000 0042         for(i=0; i<60; i++){
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,60
	BRSH _0xB
; 0000 0043             delay_ms(1000);
	RCALL SUBOPT_0x0
; 0000 0044             btn_func();
	RCALL _btn_func
; 0000 0045         }
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 0046     }
	SUBI R16,-1
	RJMP _0x7
_0x8:
; 0000 0047 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; .FEND
;
;void rd_sets(unsigned char var){
; 0000 0049 void rd_sets(unsigned char var){
_rd_sets:
; .FSTART _rd_sets
; 0000 004A 
; 0000 004B     //CLEAR EEPROM BYTE = 255, CHECK EEPROM AND SET DEFAULT, IF CLEAR.
; 0000 004C     if(power_set > MAX_POWER) power_set = DEFAULT_POWER;
	ST   -Y,R26
;	var -> Y+0
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x65)
	BRLO _0xC
	RCALL SUBOPT_0x1
	LDI  R30,LOW(40)
	RCALL __EEPROMWRB
; 0000 004D     if(time_set > MAX_TIME) time_set = DEFAULT_TIME;
_0xC:
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x10)
	BRLO _0xD
	RCALL SUBOPT_0x2
	LDI  R30,LOW(12)
	RCALL __EEPROMWRB
; 0000 004E 
; 0000 004F      switch(var){
_0xD:
	LD   R30,Y
	RCALL SUBOPT_0x3
; 0000 0050         case 1:
	BRNE _0x11
; 0000 0051             buzz(power_set/STEP_POWER, 200);
	RCALL SUBOPT_0x4
	LDI  R31,0
	MOV  R26,R30
	MOV  R27,R31
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x5
; 0000 0052         break;
	RJMP _0x10
; 0000 0053 
; 0000 0054         case 2:
_0x11:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
; 0000 0055             buzz(time_set/STEP_TIME, 200);
	RCALL SUBOPT_0x6
	LDI  R31,0
	MOV  R26,R30
	MOV  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x5
; 0000 0056         break;
; 0000 0057 
; 0000 0058         default:break;
_0x13:
; 0000 0059      }
_0x10:
; 0000 005A }
	ADIW R28,1
	RET
; .FEND
;
;char btn_press(){
; 0000 005C char btn_press(){
_btn_press:
; .FSTART _btn_press
; 0000 005D unsigned int btn_cnt=0;
; 0000 005E 
; 0000 005F     while(BTN_PRESSED){
	RCALL __SAVELOCR2
;	btn_cnt -> R16,R17
	__GETWRN 16,17,0
_0x14:
	SBIC 0x16,2
	RJMP _0x16
; 0000 0060         btn_cnt++;
	__ADDWRN 16,17,1
; 0000 0061         if(btn_cnt == 100){
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x17
; 0000 0062             buzz(1, 2000);
	RCALL SUBOPT_0x7
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _buzz
; 0000 0063             return 2;
	LDI  R30,LOW(2)
	RJMP _0x2000002
; 0000 0064         }
; 0000 0065         delay_ms(50);
_0x17:
	RCALL SUBOPT_0x8
	RCALL _delay_ms
; 0000 0066     }
	RJMP _0x14
_0x16:
; 0000 0067 
; 0000 0068     if(btn_cnt)
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x18
; 0000 0069         return 1;
	LDI  R30,LOW(1)
	RJMP _0x2000002
; 0000 006A     else
_0x18:
; 0000 006B         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0000 006C }
; .FEND
;
;char btn_func(){
; 0000 006E char btn_func(){
_btn_func:
; .FSTART _btn_func
; 0000 006F unsigned char menu_state, btn_state;
; 0000 0070 
; 0000 0071     if(btn_press()==2){
	RCALL __SAVELOCR2
;	menu_state -> R16
;	btn_state -> R17
	RCALL _btn_press
	CPI  R30,LOW(0x2)
	BRNE _0x1A
; 0000 0072         if(SBRC(flag, SETTINGS))
	SBRC R4,0
	RJMP _0x1B
; 0000 0073             SBR(flag, SETTINGS);
	LDI  R30,LOW(1)
	OR   R4,R30
; 0000 0074         else
	RJMP _0x1C
_0x1B:
; 0000 0075             CBR(flag, SETTINGS);
	LDI  R30,LOW(254)
	AND  R4,R30
; 0000 0076     }
_0x1C:
; 0000 0077 
; 0000 0078     if(SBRC(flag, SETTINGS))
_0x1A:
	SBRC R4,0
	RJMP _0x1D
; 0000 0079         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2000002
; 0000 007A 
; 0000 007B     menu_state=1;
_0x1D:
	LDI  R16,LOW(1)
; 0000 007C     rd_sets(menu_state);
	MOV  R26,R16
	RCALL _rd_sets
; 0000 007D 
; 0000 007E     while(SBRS(flag, SETTINGS)){
_0x1E:
	SBRS R4,0
	RJMP _0x20
; 0000 007F         btn_state = btn_press();
	RCALL _btn_press
	MOV  R17,R30
; 0000 0080         if(btn_state==1){
	CPI  R17,1
	BRNE _0x21
; 0000 0081             switch(menu_state){
	MOV  R30,R16
	RCALL SUBOPT_0x3
; 0000 0082                 case 1:
	BRNE _0x25
; 0000 0083                     if(power_set > MAX_POWER)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x65)
	BRLO _0x26
; 0000 0084                         power_set=STEP_POWER;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(20)
	RJMP _0x3C
; 0000 0085                     else
_0x26:
; 0000 0086                         power_set+=STEP_POWER;
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(20)
	RCALL SUBOPT_0x1
_0x3C:
	RCALL __EEPROMWRB
; 0000 0087                 break;
	RJMP _0x24
; 0000 0088 
; 0000 0089                 case 2:
_0x25:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2B
; 0000 008A                     if(time_set > MAX_TIME)
	RCALL SUBOPT_0x6
	CPI  R30,LOW(0x10)
	BRLO _0x29
; 0000 008B                         time_set=STEP_TIME;
	RCALL SUBOPT_0x2
	LDI  R30,LOW(3)
	RJMP _0x3D
; 0000 008C                     else
_0x29:
; 0000 008D                         time_set+=STEP_TIME;
	RCALL SUBOPT_0x6
	SUBI R30,-LOW(3)
	RCALL SUBOPT_0x2
_0x3D:
	RCALL __EEPROMWRB
; 0000 008E                 break;
; 0000 008F 
; 0000 0090                 default:break;
_0x2B:
; 0000 0091             }
_0x24:
; 0000 0092             rd_sets(menu_state);
	RJMP _0x3E
; 0000 0093         }
; 0000 0094         else if(btn_state==2){
_0x21:
	CPI  R17,2
	BRNE _0x2D
; 0000 0095             menu_state++;
	SUBI R16,-1
; 0000 0096             if(menu_state > 2)
	CPI  R16,3
	BRLO _0x2E
; 0000 0097                 menu_state=0;
	LDI  R16,LOW(0)
; 0000 0098             rd_sets(menu_state);
_0x2E:
_0x3E:
	MOV  R26,R16
	RCALL _rd_sets
; 0000 0099         }
; 0000 009A 
; 0000 009B         if(!menu_state)
_0x2D:
	CPI  R16,0
	BRNE _0x2F
; 0000 009C             CBR(flag, SETTINGS);
	LDI  R30,LOW(254)
	AND  R4,R30
; 0000 009D     }
_0x2F:
	RJMP _0x1E
_0x20:
; 0000 009E     buzz(1, 50);
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	RCALL _buzz
; 0000 009F }
_0x2000002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;signed char read_ds18b20(){
; 0000 00A1 signed char read_ds18b20(){
_read_ds18b20:
; .FSTART _read_ds18b20
; 0000 00A2   unsigned char data[2];
; 0000 00A3   signed char temp;
; 0000 00A4   signed int raw;
; 0000 00A5 
; 0000 00A6   w1_init();
	SBIW R28,2
	RCALL __SAVELOCR3
;	data -> Y+3
;	temp -> R16
;	raw -> R17,R18
	RCALL _w1_init
; 0000 00A7   delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00A8   if(w1_init()){
	RCALL _w1_init
	CPI  R30,0
	BREQ _0x30
; 0000 00A9     w1_write(0xCC);
	LDI  R26,LOW(204)
	RCALL _w1_write
; 0000 00AA     w1_write(0x44);
	LDI  R26,LOW(68)
	RCALL _w1_write
; 0000 00AB     delay_ms(1000);
	RCALL SUBOPT_0x0
; 0000 00AC     //Читаем данные с датчика
; 0000 00AD     w1_init();
	RCALL _w1_init
; 0000 00AE     w1_write(0xCC);
	LDI  R26,LOW(204)
	RCALL _w1_write
; 0000 00AF     w1_write(0xBE);
	LDI  R26,LOW(190)
	RCALL _w1_write
; 0000 00B0       data[0] = w1_read();
	RCALL _w1_read
	STD  Y+3,R30
; 0000 00B1       data[1] = w1_read();
	RCALL _w1_read
	STD  Y+4,R30
; 0000 00B2 
; 0000 00B3     raw = (data[1] << 8) | (data[0] & ~0x03);
	LDI  R30,0
	LDD  R31,Y+4
	MOV  R26,R30
	MOV  R27,R31
	LDD  R30,Y+3
	LDI  R31,0
	ANDI R30,LOW(0xFFFC)
	OR   R30,R26
	OR   R31,R27
	__PUTW1R 17,18
; 0000 00B4     temp = raw>>4;
	RCALL __ASRW4
	MOV  R16,R30
; 0000 00B5 
; 0000 00B6     return temp;
	RJMP _0x2000001
; 0000 00B7   } else return -127;
_0x30:
	LDI  R30,LOW(129)
; 0000 00B8 }
_0x2000001:
	RCALL __LOADLOCR3
	ADIW R28,5
	RET
; .FEND
;
;void main(){
; 0000 00BA void main(){
_main:
; .FSTART _main
; 0000 00BB     signed char t;
; 0000 00BC     initdev();
;	t -> R16
	RCALL _initdev
; 0000 00BD     t= read_ds18b20();
	RCALL _read_ds18b20
	MOV  R16,R30
; 0000 00BE     if(t<-30 || t>60){
	CPI  R16,226
	BRLT _0x33
	CPI  R16,61
	BRLT _0x32
_0x33:
; 0000 00BF         buzz(1, 5000);
	RCALL SUBOPT_0x7
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RCALL _buzz
; 0000 00C0         delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	RCALL _delay_ms
; 0000 00C1         goto DEFAULT;
	RJMP _0x35
; 0000 00C2     }
; 0000 00C3 
; 0000 00C4             if( t<TEMP_SW ){
_0x32:
	CPI  R16,4
	BRGE _0x36
; 0000 00C5 DEFAULT:        buzz(1, 50);
_0x35:
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	RCALL _buzz
; 0000 00C6                 POWER=MAX_POWER;
	LDI  R30,LOW(100)
	OUT  0x29,R30
; 0000 00C7                 delay_min(time_set);
	RCALL SUBOPT_0x6
	MOV  R26,R30
	RCALL _delay_min
; 0000 00C8                 buzz(2, 50);
; 0000 00C9                 POWER=power_set;
; 0000 00CA             }
; 0000 00CB             else{
_0x36:
; 0000 00CC                 buzz(2, 50);
_0x3F:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL SUBOPT_0x8
	RCALL _buzz
; 0000 00CD                 POWER=power_set;
	RCALL SUBOPT_0x4
	OUT  0x29,R30
; 0000 00CE             }
; 0000 00CF 
; 0000 00D0     while(1){
_0x38:
; 0000 00D1         delay_ms(1000);
	RCALL SUBOPT_0x0
; 0000 00D2         btn_func();
	RCALL _btn_func
; 0000 00D3     }
	RJMP _0x38
; 0000 00D4 }
_0x3B:
	RJMP _0x3B
; .FEND

	.ESEG
_power_set:
	.BYTE 0x1
_time_set:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_power_set)
	LDI  R27,HIGH(_power_set)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_time_set)
	LDI  R27,HIGH(_time_set)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	RCALL __DIVW21
	ST   -Y,R30
	LDI  R26,LOW(200)
	LDI  R27,0
	RJMP _buzz

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(50)
	LDI  R27,0
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x960
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x18
	.equ __w1_bit=0x04

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x480
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x2D
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xF3
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x3A8
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x6
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USW 0xC0
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x6
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x2A
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xF0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x10
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOV  R30,R26
	MOV  R31,R27
	MOV  R26,R0
	MOV  R27,R1
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
