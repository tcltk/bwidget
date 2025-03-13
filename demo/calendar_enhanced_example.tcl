# Example showing the enhanced and new features of BWidget::clendar
# Copyright (C) 2025 Th. Wunderlich
# File is in WIN-1252 (ANSI) encoding (because of Umlaut U and a) and with Unix (LF)

package require Tk
package require BWidget

cd [file dirname [info script]]

source "../calendar.tcl"

set date ""
ttk::label .l1 -text "Result of calendar in German:"
ttk::label .l2 -textvariable date
ttk::label .l3 -text "Result from embedded calendar:"
ttk::frame .embedFrame
ttk::label .l4 \
    -width 66 \
    -textvariable \
        [Calendar::create .embedFrame.cal \
            -type embedded]
grid .l1         -row 0 -column 0
grid .l2         -row 0 -column 1
grid .l3         -row 1 -column 0
grid .l4         -row 1 -column 1
grid .embedFrame -row 2 -column 0 -columnspan 2
grid columnconfigure . 2 -weight 1
grid rowconfigure    . 2 -weight 1
set date [Calendar::create .cal\
    -title "Kalender" \
    -multipleselection 0 \
    -buttonnames "\u00dcbernehmen Abbrechen" \
    -months "Januar Februar M\u00e4rz April Mai Juni Juli August September Oktober November Dezember" \
    -days "So Mo Di Mi Do Fr Sa" \
    -startday "monday"]
