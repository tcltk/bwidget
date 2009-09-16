# keramik.tcl -
#
# A sample pixmap theme for the tile package.
#
#  Copyright (c) 2004 Googie
#  Copyright (c) 2004 Pat Thoyts <patthoyts@users.sourceforge.net>
#
# $Id: keramik.tcl,v 1.2 2009/09/16 20:42:00 oberdorfer Exp $

package require Tk 8.4;                 # minimum version for Tile
package require tile 0.8;               # depends upon tile


namespace eval ttk {
    namespace eval theme {
        namespace eval keramik {
            variable version 0.5.2
        }
    }
}

namespace eval ttk::theme::keramik {
    
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
    
    ttk::style theme create keramik -parent alt -settings {
        
        
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
        
        # -----------------------------------------------------------------
        # Button elements
        #  - the button has a large rounded border and needs a bit of
        #    horizontal padding.
        #  - the checkbutton and radiobutton have the focus drawn around
        #    the whole widget - hence the new layouts.
        #
        ttk::style layout TButton {
            Button.background
            Button.button -children {
                Button.focus -children {
                    Button.label
                }
            }
        }
        ttk::style layout Toolbutton {
            Toolbutton.background
            Toolbutton.button -children {
                Toolbutton.focus -children {
                    Toolbutton.label
                }
            }
        }
        
        ttk::style element create button image [list $I(button-n) \
                {pressed !disabled}	$I(button-p) \
                {active !selected}	$I(button-h) \
                selected		$I(button-s) \
                disabled		$I(button-d)] \
                -border {8 6 8 16} -padding {6 6} -sticky news
        ttk::style configure TButton -padding {10 6} -anchor center
        
        ttk::style element create Toolbutton.button image [list $I(tbar-n) \
                {pressed !disabled}	$I(tbar-p) \
                {active !selected}	$I(tbar-a) \
                selected                $I(tbar-p)] \
                -border {2 9 2 18} -padding {2 2} -sticky news
        ttk::style configure Toolbutton -anchor center
        
        ttk::style element create Checkbutton.indicator \
                image [list $I(check-u) selected $I(check-c)] \
                -width 20 -sticky w
        
        ttk::style element create Radiobutton.indicator \
                image [list $I(radio-u) selected $I(radio-c)] \
                -width 20 -sticky w
        
        # The layout for the menubutton is modified to have a button element
        # drawn on top of the background. This means we can have transparent
        # pixels in the button element. Also, the pixmap has a special
        # region on the right for the arrow. So we draw the indicator as a
        # sibling element to the button, and draw it after (ie on top of) the
        # button image.
        ttk::style layout TMenubutton {
            Menubutton.background
            Menubutton.button -children {
                Menubutton.focus -children {
                    Menubutton.padding -children {
                        Menubutton.label -side left -expand true
                    }
                }
            }
            Menubutton.indicator -side right
        }
        ttk::style element create Menubutton.button image [list $I(mbut-n) \
                {active !disabled}      $I(mbut-a) \
                {pressed !disabled}     $I(mbut-a) \
                {disabled}              $I(mbut-d)] \
                -border {7 10 29 15} -padding {7 4 29 4} -sticky news
        ttk::style element create Menubutton.indicator image $I(mbut-arrow-n) \
                -width 11 -sticky w -padding {0 0 18 0}
        
        ttk::style element create Combobox.field image [list $I(cbox-n) \
                {readonly disabled}     $I(mbut-d) \
                {readonly active}       $I(mbut-a) \
                {readonly}              $I(mbut-n) \
                {disabled}              $I(cbox-d) \
                {active}                $I(cbox-a) \
                ] -border {9 10 32 15} -padding {9 4 8 4} -sticky news
        ttk::style element create Combobox.downarrow image $I(mbut-arrow-n) \
                -width 11 -sticky e -border {22 0 0 0}
        
        # -----------------------------------------------------------------
        # Scrollbars, scale and progress elements
        #  - the scrollbar has three arrow buttons, two at the bottom and
        #    one at the top.
        #
        ttk::style layout Vertical.TScrollbar {
            Scrollbar.background
            Vertical.Scrollbar.trough -children {
                Scrollbar.uparrow -side top
                Scrollbar.downarrow -side bottom
                Vertical.Scrollbar.thumb -side top -expand true -sticky ns
            }
        }
        
        ttk::style layout Horizontal.TScrollbar {
            Scrollbar.background
            Horizontal.Scrollbar.trough -children {
                Scrollbar.leftarrow -side left
                Scrollbar.rightarrow -side right
                Horizontal.Scrollbar.thumb -side left -expand true -sticky we
            }
        }
        
        ttk::style element create Horizontal.Scrollbar.thumb \
                image [list $I(hsb-n) {pressed !disabled} $I(hsb-p)] \
                -border {6 4} -width 15 -height 16 -sticky news
        ttk::style element create Horizontal.Scrollbar.trough image $I(hsb-t)
        
        ttk::style element create Vertical.Scrollbar.thumb \
                image [list $I(vsb-n) {pressed !disabled} $I(vsb-p)] \
                -border {4 6} -width 16 -height 15 -sticky news
        ttk::style element create Vertical.Scrollbar.trough image $I(vsb-t)
        
        ttk::style element create Horizontal.Scale.slider image $I(hslider-n) \
                -border 3
        ttk::style element create Horizontal.Scale.trough image $I(hslider-t) \
                -border {6 1 7 0} -padding 0 -sticky wes
        
        ttk::style element create Vertical.Scale.slider image $I(vslider-n) \
                -border 3
        ttk::style element create Vertical.Scale.trough image $I(vslider-t) \
                -border {1 6 0 7} -padding 0 -sticky nes
        
        ttk::style element create Horizontal.Progressbar.pbar \
                image $I(progress-h) -border {1 1 6}
        
        ttk::style element create Vertical.Progressbar.pbar \
                image $I(progress-v) -border {1 6 1 1}
        
        ttk::style element create uparrow \
                image [list $I(arrowup-n) {pressed !disabled} $I(arrowup-p)]
        
        ttk::style element create downarrow \
                image [list $I(arrowdown-n) {pressed !disabled} $I(arrowdown-p)]
        
        ttk::style element create rightarrow \
                image [list $I(arrowright-n) {pressed !disabled} $I(arrowright-p)]
        
        ttk::style element create leftarrow \
                image [list $I(arrowleft-n) {pressed !disabled} $I(arrowleft-p)]
        
        # Treeview elements
        #
        ttk::style element create Treeheading.cell \
                image [list $I(tree-n) pressed $I(tree-p)] \
                -border {5 15 5 8} -padding 12 -sticky ewns
        
        # -----------------------------------------------------------------
        # Notebook elements
        #
        ttk::style element create tab \
                image [list $I(tab-n) selected $I(tab-p) active $I(tab-p)] \
                -border {6 6 6 4} -padding {6 3} -height 12
        
        ttk::style configure TNotebook -tabmargins {0 3 0 0}
        ttk::style map TNotebook.Tab \
                -expand [list selected {0 3 2 2} !selected {0 0 2}]
        
        ## Settings.
        #
        ttk::style configure TLabelframe -borderwidth 2 -relief groove
        ttk::style configure Treeview.Row -background $colors(-window)
        ttk::style configure Treeview.Heading -borderwidth 0
    }
}


namespace eval ::tablelist:: {
    
    proc keramikTheme {} {
        variable themeDefaults
        array set themeDefaults [list \
                -background		white \
                -foreground		black \
                -disabledforeground	#aaaaaa \
                -stripebackground	"" \
                -selectbackground	#000000 \
                -selectforeground	#ffffff \
                -selectborderwidth	0 \
                -font			TkTextFont \
                -labelbackground	#cccccc \
                -labeldisabledBg	#cccccc \
                -labelactiveBg		#cccccc \
                -labelpressedBg		#cccccc \
                -labelforeground	black \
                -labeldisabledFg	#aaaaaa \
                -labelactiveFg		black \
                -labelpressedFg		black \
                -labelfont		TkDefaultFont \
                -labelborderwidth	2 \
                -labelpady		1 \
                -arrowcolor		black \
                -arrowstyle		flat8x5 \
                ]
    }
}



package provide ttk::theme::keramik $::ttk::theme::keramik::version
