; ##########################################################
; -- Last Revision: 20230702-1
; -- Original: 12/16/21
; -- ***** For PrusaSlicer only - uses PrusaSlicer parameters (placeholders)
; -- https://help.prusa3d.com/article/list-of-placeholders_205643
; -- 
; --used on Mingda Magician X & Max, will work on Pro also.
; --
; -- found this reference for Cura - http://files.fieldofview.com/cura/Replacement_Patterns.html
; -- 
; ##########################################################
; Begin End G-code
; ##########################################################

G92 E0
G1 E-[filament_retract_length] F{filament_retract_speed[0] * 60} ; retract
G1 E-[filament_retract_length] F{filament_retract_speed[0] * 60} ; retract

G91 ; use relative coordinates
G0 Z2 F5000 ; move relative Z+10
G90 ; use absolute coordinates

; G0 X0 Y{print_bed_max[0]} F5000
G0 X0 F10000
; G0 Y{print_bed_max[0]} F3800

M106 S0 ; turn off cooling fan
M104 S0 ; turn off extruder
M140 S0 ; turn off bed
M84 ; disable motors

M117 Print Completed

; Print Complete Tones
M300 S440 P200 
M300 S660 P250
M300 S880 P300

; added 7/2/23 SK 
; empty m117 line to reset ready message area (to show firmware version - SK)
M117

; ##########################################################
; Finish End G-code
; ##########################################################