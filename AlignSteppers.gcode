; ###################################################################
; # This will run G34 to align Z stepper motors
; # https://marlinfw.org/docs/gcode/G034-zsaa.html
; ###################################################################
; -- https://github.com/stevekenney318/SK-Gcodes
; -- Original: 20230628
; -- Steve Kenney
; ###################################################################
; ###################################################################
;
; home
M117 Home all 
G28 ; home all

M117 Start stepper alignment
G4 S2 ; wait for 2 second 

; align steppers to target accuracy of 0.01
G34 T0.01

; added 7/2/23 SK 
; empty m117 line to reset ready message area (to show firmware version - SK)
G4 S5 ; wait for 5 seconds
M117