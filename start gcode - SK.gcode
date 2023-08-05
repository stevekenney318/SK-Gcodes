; PrusaSlicer Start Code -- Verified for Mingda Magician X, X2 & Max. Should also work on Pro. 
; Version: SK.23.002
; 2023-08-03 01:11:05
; (control shift i to insert date & time)
; Original: 12/16/21
;
; ##########################################################
; https://github.com/stevekenney318/SK-Gcodes
; ##########################################################
; --
; -- ***** For PrusaSlicer only - uses PrusaSlicer parameters (placeholders)
; --
; -- https://help.prusa3d.com/article/list-of-placeholders_205643
; -- 
; -- found this reference for Cura - http://files.fieldofview.com/cura/Replacement_Patterns.html
; -- 
; -- other helpful info:
; -- start gcode generator - https://lostintech.co.uk/ext/gcode.php
; --
; ##########################################################
; Begin Start G-code
; ##########################################################
; 
;
; Info
; ************************************************ 
; ************************************************ 
; 1st Layer Temps: [first_layer_temperature]°/[first_layer_bed_temperature]°
; Other Layer Temps: [temperature]°/[bed_temperature]°
;
; Layer Height: [layer_height]
; 1st Layer Height: [first_layer_height]
;
; Bed Max: [print_bed_max]
; Bed Min: [print_bed_min]
; Bed Size: [print_bed_size]
; Max Print height:[max_print_height]
;
; ************************************************
; PreHeat Time: [template_custom_gcode] seconds. 
; ** You can change this value in the gcode section of the Printer tab. **
; ** Look for 'template_custom_gcode' - It is at the bottom and only requires a number in seconds **
; ** Leave Empty or use 0 for no preheating **
; ************************************************ 
; ************************************************

; print starting alert
M300 P56 S466
M300 P56 S523
M300 P56 S587

; Disable filament runout detection
M412 S0 ; Disable filament runout detection
M500 ; Save settings

; printing settings
G21 ; set units to millimeters
G90 ; use absolute coordinates
M83 ; use relative distances for extrusion
M155 S3 ; send temperature data every 3 seconds (standard setting)


; setting temps
M117 Setting temps.
M140 S[first_layer_bed_temperature] ; set bed temp
M104 S[first_layer_temperature] ; set nozzle temp

; home XYZ, then move to front center for prehet and nozzle clean
M117 Home all 
G28 ; home all
M300 S1000 P4 ; alert carriage move
M300 S1000 P4 ; alert carriage move
M203 Z8 ; changes Max Z feedrate (slower for long move). requires 'M203 Z{machine_max_feedrate_z[0]}' after move to return to machine setting is slicer
G0 X{print_bed_max[0] / 2} Y30 Z90 F5000 ; move to pre leveling position - clean nozzle
M203 Z{machine_max_feedrate_z[0]}

; waiting on temps
M117 Waiting on temps..
M190 R[first_layer_bed_temperature] ; wait for bed temp
M109 R[first_layer_temperature] ; wait for nozzle temp (for probing)

; Reset extruder to 0
G92 E0
G1 E-[filament_retract_length] F{filament_retract_speed[0] * 60} ; retract filament

; temps reached
M117 Temps reached
M300 P56 S700
M300 P56 S700
G4 S5 ; wait time to show message

; ####################################################
; The following section is for preheating. The time can be changed by changing the placeholder [template_custom_gcode]
; This value is located on the 'Custom G-code' page in the last section labeled 'Template Custom G-code'
; If set to 0 there is no preheat time, and countdown will begin to move the carriage for Bed leveling 
; Any value other than 0, is the preheat time in seconds. Carriage will move after set number of seconds.
; ####################################################
;
; ####################################################
; Start Preheating
; ####################################################
M117 PreHeat for [template_custom_gcode] seconds... change in template_custom_gcode
G4 S[template_custom_gcode] ; wait time while preheating

M300 S1000 P4 ; alert carriage move
M300 S1000 P4 ; alert carriage move
; wait 3 seconds to clean ooze
M117 Clean nozzle before probing starts in ...

G4 S1 ; wait for 1 second
M117 ... 3 seconds
M300 S1000 P4

G4 S1 ; wait for 1 second
M117 ... 2 seconds
M300 S1000 P4

G4 S1 ; wait for 1 second
M117 ... 1 second
M300 S1000 P4

G4 S1 ; wait for 1 second
M117 ... Start to probe
M300 S1000 P4
; ####################################################
; End Preheating
; ####################################################

; ####################################################
; Move carriage to begin Bed Leveling process
; ####################################################
;
M203 Z8 ; changes Max Z feedrate (slower for long move). requires 'M203 Z{machine_max_feedrate_z[0]}' after move to return to machine setting is slicer
G0 X{print_bed_max[0] - 30} Y30 Z15 F5000 ; move to XYZ pre-location for leveling
M203 Z{machine_max_feedrate_z[0]}

; ####################################################
; Start Bed Leveling process
; ####################################################
;
; Start Automatic (Bilinear) Bed Leveling
M117 Automatic (Bilinear) Bed Leveling in process

; these lines are for OctoPrint plugin - Bed Visualizer
M155 S30 ; reduce temperature reporting rate to reduce output pollution
@BEDLEVELVISUALIZER	; tell the plugin to watch for reported mesh (OctoPrint plugin - Bed Visualizer)
G29  ; run bilinear probing
M155 S3  ; reset temperature reporting

; Save settings to EEPROM
M117 Saved settings to EEPROM
M500 ; save settings

; Turn off fan
M107 ; turn off fan

;*** Message and Tone
M117  Automatic (Bilinear) Bed Leveling Completed
M300 S250 P80
;
; ####################################################
; End of Bed Leveling process
; ####################################################

; use last mesh
M420 S1 ; use last-saved mesh

; Time to start printing
M117 Time to start printing
M300 S1000 P4 ; alert carriage move
M300 S1000 P4 ; alert carriage move

; ####################################################
; Start Purge line
; ####################################################
;
; SELECT ONE (Right or Left)
; Comment out other side

; Right side
;
M117 Purge line on the right Side of Bed
G92 E0 ; Reset Extruder
G1 X{print_bed_max[0] - 3} Y205 Z0.3 F5000  ; Move to start position
G91 ; use relative coordinates
G1 Y-180 F1500 E15 ; Draw 1st line
G0 Z0.1 ; move up a little
G1 Y180 F1500 E30 ; Draw the 2nd line

;*****
; OR *
;*****

; Left side
;
; M117 Purge line on the left Side of Bed
; G92 E0 ; reset extruder
; G1 Z1.0 F3000 ; move z up little to prevent scratching of surface
; G1 X2 Y20 Z0.3 F5000.0 ; move to start-line position
; G1 X2 Y200.0 Z0.3 F1500.0 E15 ; draw 1st line
; G1 X2 Y200.0 Z0.4 F5000.0 ; move to side a little
; G1 X2 Y20 Z0.4 F1500.0 E30 ; draw 2nd line

;
; ####################################################
; End Purge line
; ####################################################

G90 ; use absolute coordinates
G92 E0 ; Reset Extruder
G1 Z1.0 F3000 ; move z up little to prevent scratching of surface

; ##########################################################
; Finish Start G-code
; ##########################################################