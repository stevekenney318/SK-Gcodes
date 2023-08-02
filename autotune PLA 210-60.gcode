; ##########################################################
; -- Last Revision: 20230111.1
; -- Original: 11/24/2022
; -- autotune PLA - Steve Kenney
; ##########################################################
;------------------------------------------------------
;was autotune.gcode - Steve Kenney - 10/18/2022
;This gcode was specifically created for Mingda Magician Series printers.
;For other printers, use at your own risk, and understand each line below.
;This gcode will automatically Auto-tune hotend & bed temps..
;It will also automatically update PID info for each and save both to eeprom.
;No need to enter them manually.
;Actual run times (from cold) for estimate - Magician X - Print time: 6m 22s , Magician Max - Print time: 9m 48s
;Prior to Auto-tune, hotend will home, and then move to predetermined position
; 10/28/2022 - SK 
; added section to wait for cool temps (30°C) before starting (ex: if autotune was just run, or preheat set, just finished print)
; 01/11/23 - SK
; removed cool down section - took way too long !
; changed hotend to 10 cycles
;------------------------------------------------------

;Auto-tune examples - https://marlinfw.org/docs/gcode/M303.html
;; Auto-tune hotend at 210 °C for 8 cycles and update settings (U1)
;; M303 E0 C8 S210 U1
;; Auto-tune bed at 60 °C for 8 cycles and update settings (U1)
;; M303 E-1 C8 S60 U1

; start
M300 S440 P200 
M300 S660 P250
M300 S880 P300
G28 ; home all
G0 Z10 X50 Y50 F5000 ; move to Auto-tune position


;nozzle
M117 Auto tuning Nozzle now...
M300 S180 P20 ; tone
M106 ; part cooling fans on 100%.
M303 E0 C10 S210 U1 ; autotone nozzle - this is the line to change nozzle temp if need be.
M107 ; part cooling fans off.
M300 S180 P20 ; tone


;bed
M117 Auto tuning Bed now...
M300 S180 P20 ; tone
M303 E-1 C5 S60 U1 ; autotune bed - this is the line to change bed temp if need be.
M300 S180 P20

; save settings to eeprom
M117 Saving settings to eeprom
M500 ; save settings to eeprom
M117 Saved settings to eeprom

; return home
G28 ; home all

; Autotune(s) finished
M300 S440 P200 
M300 S660 P250
M300 S880 P300

M117 Finished auto tuning.