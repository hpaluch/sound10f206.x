; sound_led.asm - simple project to drive LED & Sound on Speaker
; see ExpressPCB folder for schematics
;
; Copyright (C) Henryk Paluch, hpaluch at seznam dot cz, http://henryx.info
; Few ideas taken from Gooligum Tutorials at
;     http://www.gooligum.com.au/tutorials.html

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

;*** RESET
RES_VECT  CODE    0x0000            ; processor reset vector
; WARNING! My PIC has corrupted calibration value:
; Line         Address         Opcode         Label         DisAssy
; 512            1FF            0002                          OPTION
; Which causes following erratic behaviour:
; a) pitch randomly changes on power-up
; b) GP2 is someties switched to FOSC4 output, which caues LED to not blink
; comment out 'MOVLW 0x0' instruction bellow if you are sure that your PIC is OK
;
    MOVLW   0x0
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