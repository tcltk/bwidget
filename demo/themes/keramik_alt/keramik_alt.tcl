# keramik.tcl - 
#
# A sample pixmap theme for the tile package.
#
#  Copyright (c) 2004 Googie
#  Copyright (c) 2004 Pat Thoyts <patthoyts@users.sourceforge.net>
#
# $Id: keramik_alt.tcl,v 1.2 2009/09/16 20:43:49 oberdorfer Exp $

package require Tk 8.4;                 # minimum version for Tile
package require tile 0.8.0;             # depends upon tile 0.8.0
package require ttk::theme::keramik;    # the parent theme

namespace eval ttk {
    namespace eval theme {
        namespace eval keramik_alt {
	    variable version 0.5.2
	}
    }
}

namespace eval ttk::theme::keramik_alt {

    variable I
    
    set thisDir  [file dirname [info script]]
    set imageDir [file join $thisDir "images"]
    set imageLib [file join $thisDir "ImageLib.tcl"] \
            
    # try to load image library file...
    if { [file exists $imageLib] } {
        
        source $imageLib
        array set I [array get images]
        
    } else {
        
        proc LoadImages {imgdir {patterns {*.gif}}} {
            foreach pattern $patterns {
                foreach file [glob -directory $imgdir $pattern] {
                    set img [file tail [file rootname $file]]
                    if {![info exists images($img)]} {
                        set images($img) [image create photo -file $file]
                    }
                }}
            return [array get images]
        }
        
        array set I [LoadImages $imageDir "*.gif"]
    }

    variable colors
    array set colors {
        -frame      "#dddddd"
        -lighter    "#cccccc"
        -window     "#ffffff"
        -selectbg   "#eeeeee"
        -selectfg   "#000000"
        -disabledfg "#aaaaaa"
    }

    ttk::style theme create keramik_alt -parent keramik -settings {

        # -----------------------------------------------------------------
        # Theme defaults
        #
        ttk::style configure . \
            -borderwidth 1 \
	    -foreground "Black" \
            -background $colors(-frame) \
            -troughcolor $colors(-lighter) \
	    -fieldbackground $colors(-window) \
            -font TkDefaultFont \
            ;

        ttk::style map . -foreground [list disabled $colors(-disabledfg)]

	# The alternative keramik theme doesn't have the conspicuous
	# highlighted scrollbars of the main keramik theme.
	#
        ttk::style element create Vertical.Scrollbar.thumb \
            image [list $I(vsb-a) {pressed !disabled} $I(vsb-h)] \
            -border {4 6} -width 16 -height 15 -sticky news
        ttk::style element create Horizontal.Scrollbar.thumb \
	    image [list $I(hsb-a) {pressed !disabled} $I(hsb-h)] \
	    -border {6 4} -width 15 -height 16 -sticky news

	# Repeat the settings because they don't seem to be copied from the
	# parent theme.
	#
        ttk::style configure TButton -padding {10 6} -anchor center
	ttk::style configure Toolbutton -anchor center
	ttk::style configure TNotebook -tabmargins {0 3 0 0}
	ttk::style map TNotebook.Tab \
		-expand [list selected {0 3 2 2} !selected {0 0 2}]

	ttk::style configure TLabelframe -borderwidth 2 -relief groove
	ttk::style configure Treeview -padding 0
	ttk::style configure Treeview.Row -background $colors(-window)
	ttk::style configure Treeview.Heading -borderwidth 0
    }
}

package provide ttk::theme::keramik_alt $::ttk::theme::keramik_alt::version
