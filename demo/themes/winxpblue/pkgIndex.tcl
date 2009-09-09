# if { [catch {package require tile 0.8 }] != 0 } { return }

if {[file isdirectory [file join $dir winxpblue]]} {
    package ifneeded ttk::theme::winxpblue 0.0.1 \
        [list source [file join $dir winxpblue.tcl]]
}
