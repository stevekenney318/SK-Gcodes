; ###################################################################
; # CAUTION - this file will reset your printer to Factory Settings #
; ###################################################################
; -- https://github.com/stevekenney318/SK-Gcodes
; -- Original: 20230619
; -- Steve Kenney
; ###################################################################
; ###################################################################
;
G4 S56 ; wait for 1 minute to give oppurtuniy to CANCEL factory reset
M117 ... Waiting 1 minute before FACTORY RESET

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
M117 ... FACTORY RESET in Progress
M300 S1000 P4

M502 ; Factory Reset - Reset all configurable settings to their factory defaults - https://marlinfw.org/docs/gcode/M502.html
M500 ; Save all configurable settings to EEPROM - https://marlinfw.org/docs/gcode/M500.html

M117 ... FACTORY RESET complete
M300 S1000 P4