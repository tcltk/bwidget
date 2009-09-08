#!/bin/sh
# The next line is executed by /bin/sh, but not tcl \
exec wish "$0" ${1+"$@"}

# ----------------------------------------------------------------------------
#  demo.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: demo.tcl,v 1.6 2009/09/08 21:22:09 oberdorfer Exp $
# ----------------------------------------------------------------------------
#

set appDir [file dirname [info script]]
lappend auto_path [file join $appDir ".."]

package require BWidget 1.9.1

source [file join $appDir "demo_main.tcl"]

Demo::main
Demo::setTheme

wm geom . [wm geom .]
