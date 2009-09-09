# if { [catch {package require tile 0.8 }] != 0 } { return }

if {[file isdirectory [file join $dir aquativo]]} {
    package ifneeded ttk::theme::aquativo 0.0.1 \
        [list source [file join $dir aquativo.tcl]]
}
