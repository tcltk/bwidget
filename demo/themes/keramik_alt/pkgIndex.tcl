# pkgIndex.tcl for additional tile pixmap themes.
#
# We don't provide the package is the image subdirectory isn't present,
# or we don't have the right version of Tcl/Tk
#
# To use this automatically within tile, the tile-using application should
# use tile::availableThemes and tile::setTheme 
#
# $Id: pkgIndex.tcl,v 1.3 2009/10/25 19:24:03 oberdorfer Exp $

if {![package vsatisfies [package provide Tcl] 8.4]} { return }

package ifneeded ttk::theme::keramik_alt 0.5.2 \
    [list source [file join $dir keramik_alt.tcl]]
