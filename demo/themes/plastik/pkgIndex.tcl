# pkgIndex.tcl for additional tile pixmap themes.
#
# We don't provide the package is the image subdirectory isn't present,
# or we don't have the right version of Tcl/Tk
#
# To use this automatically within tile, the tile-using application should
# use tile::availableThemes and tile::setTheme 
#
# $Id: pkgIndex.tcl,v 1.2 2009/09/16 20:44:15 oberdorfer Exp $

if {![package vsatisfies [package provide Tcl] 8.4]} { return }

package ifneeded ttk::theme::plastik 0.5.2 \
    [list source [file join $dir plastik.tcl]]

