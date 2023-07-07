; ##########################################################
; -- Last Revision: 20230629-1
; -- Original: 12/16/21
; -- ***** For PrusaSlicer only - uses PrusaSlicer parameters (placeholders)
; -- https://help.prusa3d.com/article/list-of-placeholders_205643
; -- 
; --used on Mingda Magician X & Max, will work on Pro also.
; --
; -- found this reference for Cura - http://files.fieldofview.com/cura/Replacement_Patterns.html
; -- 
; -- other helpful info:
; --  start gcode generator - https://lostintech.co.uk/ext/gcode.php
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
M300 P56 S466
M300 P56 S523
M300 P56 S587

M412 S0 ; Disable filament runout detection
M500 ; Save settings

M155 S3 ; send temperature data every 3 seconds
G21 ; set units to millimeters
G90 ; use absolute coordinates
M83 ; use relative distances for extrusion


; setting temps
M117 Setting temps.
M140 S[first_layer_bed_temperature] ; set bed temp
M104 S[first_layer_temperature] ; set nozzle temp

; home
M117 Home all 
G28 ; home all
M300 S1000 P4 ; alert carriage move
M300 S1000 P4 ; alert carriage move
M203 Z8 ; changes Max Z feedrate (slower for long move). requires 'M203 Z{machine_max_feedrate_z[0]}' after move to return to machine setting is slicer
G0 X{print_bed_max[0] / 2} Y30 Z90 F5000 ; move to pre leveling position - clean nozzle
M203 Z{machine_max_feedrate_z[0]}

; waiting temps
M117 Waiting on temps..
M190 R[first_layer_bed_temperature] ; wait for bed temp
M109 R[first_layer_temperature] ; wait for nozzle temp (for probing)

G92 E0
G1 E-[filament_retract_length] F{filament_retract_speed[0] * 60} ; retract

M117 Temps reached
M300 P56 S700
M300 P56 S700
G4 S5 ; wait time to show message


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

M203 Z8 ; changes Max Z feedrate (slower for long move). requires 'M203 Z{machine_max_feedrate_z[0]}' after move to return to machine setting is slicer
G0 X{print_bed_max[0] - 30} Y30 Z15 F5000 ; move to XYZ pre-location for leveling
M203 Z{machine_max_feedrate_z[0]}

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

; use last mesh
M420 S1 ; use last-saved mesh

; Time to start
M117 Time to start printing
M300 S1000 P4 ; alert carriage move
M300 S1000 P4 ; alert carriage move

; ##########################################################
;*** Purge line on the right Side of Bed
M117 Purge line on the right Side of Bed
; ****************************************************
; Purge line
G92 E0 ; Reset Extruder
G1 X{print_bed_max[0] - 7} Y205 Z0.3 F5000  ; Move to start position
G91 ; use relative coordinates
G1 Y-180 F1500 E15 ; Draw 1st line
G0 Z0.1 ; move up a little
G1 Y180 F1500 E30 ; Draw the 2nd line
G90 ; use absolute coordinates
G92 E0 ; Reset Extruder
G1 Z1.0 F3000 ; move z up little to prevent scratching of surface
; ##########################################################
; Finish Start G-code
; ##########################################################