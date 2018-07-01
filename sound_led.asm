; sound_led.asm - simple project to drive LED & Sound on Speaker
; see ExpressPCB folder for schematics
;
; Copyright (C) Henryk Paluch, hpaluch at seznam dot cz, http://henryx.info
; Few ideas taken from Gooligum Tutorials at
;     http://www.gooligum.com.au/tutorials.html

; PicKit3 workaround:
; New MPLAB X has initially troubles accessing PicKit3
; (exhibited on v2.35/XP SP3, VirtualBox 5.2.10 with Extension pack):
; At first it reports:
; "Firmware type..............Unknown Firmware Type"
; and finally:
; "Connection Failed."
;
; Fortunately there is easy workaround:
; just invoke "Read Device Memory" - it should succeed and then
; all programming functions should succeed.


; PIN assignment:
;  GP2 - LED diodes
;  GP1 - speaker drive

    LIST P=PIC10F206
    INCLUDE <P10F206.INC>

    __CONFIG  _MCLRE_ON & _CP_OFF & _WDT_OFF

    CONSTANT nLED = GP2 ; bit for LED on GPIO
; WARNING! GP1 is used for ISP programming - can have only light load!
    CONSTANT nSPKR = GP1 ; bit for SPKR on GPIO

; NOTE: if change above bits you need also to change instruction in code:
;     MOVLW ~(1<<TRISIO1 | 1<<TRISIO2 )  ; GP2 & GP1 OUTPUT, other are Inputs


;***** user data (general registers)
MY_DATA UDATA
sGPIO   RES 1
cnt1    RES 1
cnt2    RES 1

; Overwriting corrupted calibration value:
; WARNING! My PIC had corrupted calibration value:
; Line         Address         Opcode         Label         DisAssy
; 512            1FF            0002                          OPTION
; Which caused following erratic behaviour:
; a) pitch randomly changes on power-up
; b) GP2 is someties switched to FOSC4 output, which caues LED to not blink
;
; If it happens to you than you need to:
; - in Project Properties -> Conf -> PicKit3 -> Program Options:
; - enable "Program callibration memory"
; and uncomment following 2 lines:
;FIX_CAL CODE 0x1ff
;    MOVLW 0x2
; - and reprogram device
; - invoke Read Device Memory
; - open Window -> PIC Memory Views -> Program Memory
; - verify content of 0x1ff address - there must be above MOVLW 0x2 instruction
; - when OK, disable "Program callibration memory"
; - and comment out above two instructions again...

;*** RESET
RES_VECT  CODE    0x0000            ; processor reset vector
; uncomment following instruction if you have corrupted calibration
; (see above comments)...
;    MOVLW   0x0
    MOVWF   OSCCAL
;
START
    MOVLW  ~(1<<T0CS)      ; clear T0CS so that GP2 can be used
    OPTION
    MOVLW ~(1<<CMPON)
    MOVWF CMCON0           ; Turn Off Comparator to enable Output on GP1
    MOVLW ~(1<<TRISIO1 | 1<<TRISIO2 )  ; GP2 & GP1 OUTPUT, other are Inputs
    TRIS GPIO
    MOVLW ~(1<<nLED | 1<<nSPKR)
    MOVWF sGPIO
    MOVWF GPIO ; LED0, SPKR0
MY_LOOP
    CLRF cnt2 ; counter for LED
w2
; wait approx 1.024ms or 0.512ms
    CLRF cnt1 ; counter for SPKR (and nested counter for LED)
    BTFSC  sGPIO,nLED
    BSF  cnt1,7 ; CNT1 = 128 for LED in LOG1 => half interval
w1  NOP
    NOP
    DECFSZ cnt1,f
    GOTO w1
; xor speaker bit
    MOVF sGPIO,w
    XORLW 1<<nSPKR
    MOVWF sGPIO
    MOVWF GPIO
; outer LED loop
    DECFSZ cnt2,f
    GOTO   w2
; xor LED bit
    MOVF sGPIO,w
    XORLW 1<<nLED
    MOVWF sGPIO
    MOVWF GPIO
    GOTO MY_LOOP                          ; loop forever

    END