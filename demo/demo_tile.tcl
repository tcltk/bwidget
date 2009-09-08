#!/bin/sh
# The next line is executed by /bin/sh, but not tcl \
exec wish "$0" ${1+"$@"}

set appDir [file dirname [info script]]
lappend auto_path [file join $appDir ".."]

set dir [file join $appDir "themes"]
if {[lsearch -exact auto_path $dir] == -1} {
    lappend auto_path $dir
}

package require tile 0.8

package require BWidget 1.9.1
::BWidget::usepackage ttk

source [file join $appDir "demo_main.tcl"]

Demo::main
after idle Demo::setTheme

wm geom . [wm geom .]
