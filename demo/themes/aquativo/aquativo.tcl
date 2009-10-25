# aquativo --
#
#   Copyright (C) 2004 Pat Thoyts <patthoyts@users.sourceforge.net>
#
#   Import the aquativo Gtk theme (C) Andrew Wyatt, FEWT Software
#   Original: http://www.fewt.com
#   Link: http://art.gnome.org/themes/gtk2/432.php
# ------------------------------------------------------------------------------
# Revision change history:
#   $Id: aquativo.tcl,v 1.3 2009/10/25 19:10:41 oberdorfer Exp $
#
#   Aug.'08: code refractured for the use with >= tk8.5,
#            johann.oberdorfer@gmail.com
# ------------------------------------------------------------------------------

package require Tk 8.4;                 # minimum version for Tile
package require tile 0.8;               # depends upon tile

namespace eval ttk {
  namespace eval theme {
    namespace eval aquativo {
      variable version 0.0.1
    }
  }
}

# TkDefaultFont", "TkTextFont" and "TkMenuFont
#   font create System {*}[font actual System] 
#   font configure System -size 16 -weight bold


namespace eval ttk::theme::aquativo {

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

  
  # "-parent" option controls the treeview "+" icon (collapse/expand)
  # at the beginning of each tree node
  
  ::ttk::style theme create aquativo -settings {
    
    # Defaults
    
    ::ttk::style configure "." \
        -font TkDefaultFont \
        -background "#fafafa" \
        -foreground "Black"
    
    # I really like the mapping options!
    ::ttk::style map "." \
        -foreground { disabled "#565248" } \
        -background { disabled "#e3e1dd"
          pressed  "#bab5ab"
          active   "#c1d2ee" }
    
    # ::ttk::style layout TButton {
    #  Button.button -children { Button.focus -children { Button.label } }
    # }
    
    ::ttk::style configure TButton -padding {1 1} -width -11
    
    # Troughs

    # ttk::style layout Horizontal.TScrollbar:
    # Horizontal.Scrollbar.trough -sticky we -children {
    #   Horizontal.Scrollbar.leftarrow -side left -sticky {}
    #   Horizontal.Scrollbar.rightarrow -side right -sticky {}
    #   Horizontal.Scrollbar.thumb -expand 1 -sticky nswe
    # }

    # ::ttk::style element create trough image $I(horizontal_trough) \
    #    -border 3

    ::ttk::style element create Horizontal.Scrollbar.trough \
        image $I(horizontal_trough) -border 0 -sticky ew

    ::ttk::style element create Vertical.Scrollbar.trough \
        image $I(vertical_trough) -border 0

    ::ttk::style element create Vertical.Scale.trough \
        image $I(vertical_trough) -border 2
    ::ttk::style element create Progress.trough \
        image $I(vertical_trough) -border 2

    ## Panedwindow parts.
    #
    ::ttk::style element create hsash image \
            [list $I(hseparator-n) {active !disabled} $I(hseparator-a)] \
            -border {2 0}
    ::ttk::style element create vsash image \
            [list $I(vseparator-n) {active !disabled} $I(vseparator-a)] \
            -border {0 2}

    # Buttons, Checkbuttons and Radiobuttons
    
    ::ttk::style layout TButton {
      Button.background
      Button.button -children {
        Button.focus -children {
          Button.label
        }
      }
    }
    
    ::ttk::style element create Button.button image \
        [list $I(buttonNorm) pressed $I(buttonPressed) active $I(button)] \
        -border {4 4} -padding 3 -sticky nsew
    
    ::ttk::style element create Checkbutton.indicator image \
        [list $I(checkbox_unchecked) selected $I(checkbox_checked)] \
        -width 20 -sticky w
    ::ttk::style element create Radiobutton.indicator image \
        [list $I(option_out) selected $I(option_in)] \
        -width 20 -sticky w
    
    # Menubuttons:
    
    ::ttk::style element create Menubutton.button image \
        [list $I(menubar_option) ] \
        -border {7 10 29 15} -padding {7 4 29 4} -sticky news
    
    ::ttk::style element create Menubutton.indicator image \
        [list $I(menubar_option_arrow) disabled $I(menubar_option_arrow_insensitive)] \
        -width 11 -sticky w -padding {0 0 18 0}
    
    # Scrollbar

    ::ttk::style element create Horizontal.Scrollbar.thumb \
        image $I(scrollbar_horizontal) -border 7 -width 15 -height 0 -sticky nsew

    #::ttk::style element create Horizontal.Scrollbar.thumb \
    #    image [list $I(scrollbar_horizontal) \
	#       !selected $I(scrollbar_horizontal_inactive) \
	#       pressed  $I(scrollbar_horizontal)] -border 7 -width 15 -height 0 -sticky nsew

    ::ttk::style element create Vertical.Scrollbar.thumb \
        image $I(scrollbar_vertical) -border 7 -width 0 -height 15 -sticky nsew
    
    # Scale
    
    ::ttk::style element create Horizontal.Scale.slider \
        image $I(scrollbar_horizontal) \
        -border 3 -width 30 -height 16
    
    ::ttk::style element create Vertical.Scale.slider \
        image $I(scrollbar_vertical) \
        -border 3 -width 16 -height 30
    
    # Progress
    
    ::ttk::style element create Progress.bar image $I(progressbar)
    
    # Arrows
    
    ::ttk::style element create uparrow image \
        [list $I(arrow_up_normal) \
        pressed $I(arrow_up_active) \
        disabled $I(arrow_up_insensitive)]
    ::ttk::style element create downarrow image \
        [list $I(arrow_down_normal) \
        pressed $I(arrow_down_active) \
        disabled $I(arrow_down_insensitive)]
    ::ttk::style element create leftarrow image \
        [list $I(arrow_left_normal) \
        pressed $I(arrow_left_active) \
        disabled $I(arrow_left_insensitive)]
    ::ttk::style element create rightarrow image \
        [list $I(arrow_right_normal) \
        pressed $I(arrow_right_active) \
        disabled $I(arrow_right_insensitive)]
    
    # Notebook parts
    
    ::ttk::style element create tab image \
        [list $I(notebook) selected  $I(notebook_active)] \
        -sticky news \
        -border {10 2 10 2} -height 10
    
    ::ttk::style configure TNotebook.Tab -padding {2 2}
    ::ttk::style configure TNotebook -expandtab {2 2}
    
    
    # Labelframes
    
    ::ttk::style configure TLabelframe -borderwidth 2 -relief groove
  }
}

namespace eval ::tablelist:: {

    proc aquativoTheme {} {
      variable themeDefaults
      array set themeDefaults [list \
	-background		white \
	-foreground		black \
	-disabledforeground	black \
	-stripebackground	#EDF3FE \
	-selectbackground	#000000 \
	-selectforeground	#ffffff \
	-selectborderwidth	0 \
	-font			TkTextFont \
        -labelbackground	#fafafa \
	-labeldisabledBg	#fafafa \
	-labelactiveBg		#fafafa \
	-labelpressedBg		#fafafa \
	-labelforeground	black \
	-labeldisabledFg	black \
	-labelactiveFg		black \
	-labelpressedFg		black \
	-labelfont		TkDefaultFont \
	-labelborderwidth	2 \
	-labelpady		1 \
	-arrowcolor		#777777 \
	-arrowstyle		flat7x7 \
	-showseparators         yes \
      ]
   }
}


package provide ttk::theme::aquativo $::ttk::theme::aquativo::version
