# pkgIndex.tcl for additional tile pixmap themes.
#
# We don't provide the package is the image subdirectory isn't present,
# or we don't have the right version of Tcl/Tk
#
# To use this automatically within tile, the tile-using application should
# use tile::availableThemes and tile::setTheme 
#
# $Id: pkgIndex.tcl,v 1.3 2009/10/25 19:24:34 oberdorfer Exp $

package ifneeded ttk::theme::plastik 0.5.2 \
    [list source [file join $dir plastik.tcl]]

