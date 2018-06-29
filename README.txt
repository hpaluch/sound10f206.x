Hello!

  Here is introductory project for PIC10F206 microcontroller
made by http://www.microchip.com
  
  The project just flashes two LEDs and Outputs two tones
to speaker.

  Schematics is in ExpressPCB sub folder.

  Project has been tested on DM163045 PICDEM Lab Development Kit
with PicKit 3 programmer (included in PICDEM). All used parts
are included in that kit.

  Tested in MPLAB X IDE v1.80

HW Setup:

- Power off PICDEM Kit
- Remove jumpers J3, J4 (turn off power from other MCU sockets)
- Put jumper J5 (power on U5 socket for PIC10F206)
- Connect PicKit 3 to USB
- Connect PicKit 3 to PICDEM board
- Power on PicDEM board
- Program device using "Run" command of MPLAB X IDE.


Links:

* PIC10F206 datasheet 
   old: http://www.microchip.com/TechDoc.aspx?type=datasheet&product=10f206
   new: https://www.microchip.com/wwwproducts/en/PIC10F206
* DM163045 - PICDEM Lab Development Kit 
   old: http://www.microchipdirect.com/productsearch.aspx?keywords=DM163045
   new: http://www.microchip.com/Developmenttools/ProductDetails/DM163045
* MPLAB X IDE
   old: http://www.microchip.com/pagehandler/en-us/family/mplabx/
   new: http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-v1.80-windows-installer.zip
        from page: http://www.microchip.com/development-tools/pic-and-dspic-downloads-archive
* IRFD 9020 - power P-Channel MOSFET - tranzistor data-sheet including package layout:
  - https://www.vishay.com/docs/91137/sihfd902.pdf

Other Links:

* The MOSFET - very good intro (how to drive LOAD)
    http://www.talkingelectronics.com/projects/MOSFET/MOSFET.html
* Gooligum PIC tutorials - intro to baseline PIC & MPASM
    http://www.gooligum.com.au/tutorials.html
