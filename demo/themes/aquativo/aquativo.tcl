# aquativo --
#
#   Copyright (C) 2004 Pat Thoyts <patthoyts@users.sourceforge.net>
#
#   Import the aquativo Gtk theme (C) Andrew Wyatt, FEWT Software
#   Original: http://www.fewt.com
#   Link: http://art.gnome.org/themes/gtk2/432.php
# ------------------------------------------------------------------------------
# Revision change history:
#   $Id: aquativo.tcl,v 1.1 2009/09/09 19:30:56 oberdorfer Exp $
#
#   Aug.'08: code refractured for the use with >= tk8.5,
#            johann.oberdorfer@gmail.com
# ------------------------------------------------------------------------------

package require Tk 8.4;                 # minimum version for Tile
package require tile;                   # depends upon tile

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
  
  variable imgdir [file join [file dirname [info script]] aquativo gtk-2.0]
  variable I
  
  if {[info commands ::ttk::style] ne ""} {
    set styleCmd ttk::style
  } else {
    set styleCmd style
  }
  
  proc LoadImages {imgdir {patterns {*.gif}}} {
    foreach pattern $patterns {
      foreach file [glob -directory $imgdir $pattern] {
        set img [file tail [file rootname $file]]
        # puts "--> $img"
        if {![info exists images($img)]} {
          set images($img) [image create photo -file $file]
        }
      }
    }
    return [array get images]
  }
  
  array set I [LoadImages $imgdir "*.gif"]
  
  
  # "-parent" option controls the treeview "+" icon (collapse/expand)
  # at the beginning of each tree node
  
  $styleCmd theme create aquativo -settings {
    
    # Defaults
    
    $styleCmd configure "." \
        -font TkDefaultFont \
        -background "#fafafa" \
        -foreground "Black"
    
    # I really like the mapping options!
    $styleCmd map "." \
        -foreground { disabled "#565248" } \
        -background { disabled "#e3e1dd"
          pressed  "#bab5ab"
          active   "#c1d2ee" }
    
    # $styleCmd layout TButton {
    #  Button.button -children { Button.focus -children { Button.label } }
    # }
    
    $styleCmd configure TButton -padding {1 1} -width -11
    
    # Troughs

    # ttk::style layout Horizontal.TScrollbar:
    # Horizontal.Scrollbar.trough -sticky we -children {
    #   Horizontal.Scrollbar.leftarrow -side left -sticky {}
    #   Horizontal.Scrollbar.rightarrow -side right -sticky {}
    #   Horizontal.Scrollbar.thumb -expand 1 -sticky nswe
    # }

    # $styleCmd element create trough image $I(horizontal_trough) \
    #    -border 3

    $styleCmd element create Horizontal.Scrollbar.trough \
        image $I(horizontal_trough) -border 0 -sticky ew

    $styleCmd element create Vertical.Scrollbar.trough \
        image $I(vertical_trough) -border 0

    $styleCmd element create Vertical.Scale.trough \
        image $I(vertical_trough) -border 2
    $styleCmd element create Progress.trough \
        image $I(vertical_trough) -border 2
    
    # Buttons, Checkbuttons and Radiobuttons
    
    $styleCmd layout TButton {
      Button.background
      Button.button -children {
        Button.focus -children {
          Button.label
        }
      }
    }
    
    $styleCmd element create Button.button image \
        [list $I(buttonNorm) pressed $I(buttonPressed) active $I(button)] \
        -border {4 4} -padding 3 -sticky nsew
    
    $styleCmd element create Checkbutton.indicator image \
        [list $I(checkbox_unchecked) selected $I(checkbox_checked)] \
        -width 20 -sticky w
    $styleCmd element create Radiobutton.indicator image \
        [list $I(option_out) selected $I(option_in)] \
        -width 20 -sticky w
    
    # Menubuttons:
    
    $styleCmd element create Menubutton.button image \
        [list $I(menubar_option) ] \
        -border {7 10 29 15} -padding {7 4 29 4} -sticky news
    
    $styleCmd element create Menubutton.indicator image \
        [list $I(menubar_option_arrow) disabled $I(menubar_option_arrow_insensitive)] \
        -width 11 -sticky w -padding {0 0 18 0}
    
    # Scrollbar

    $styleCmd element create Horizontal.Scrollbar.thumb \
        image $I(scrollbar_horizontal) -border 7 -width 15 -height 0 -sticky nsew

    #$styleCmd element create Horizontal.Scrollbar.thumb \
    #    image [list $I(scrollbar_horizontal) \
	#       !selected $I(scrollbar_horizontal_inactive) \
	#       pressed  $I(scrollbar_horizontal)] -border 7 -width 15 -height 0 -sticky nsew

    $styleCmd element create Vertical.Scrollbar.thumb \
        image $I(scrollbar_vertical) -border 7 -width 0 -height 15 -sticky nsew
    
    # Scale
    
    $styleCmd element create Horizontal.Scale.slider \
        image $I(scrollbar_horizontal) \
        -border 3 -width 30 -height 16
    
    $styleCmd element create Vertical.Scale.slider \
        image $I(scrollbar_vertical) \
        -border 3 -width 16 -height 30
    
    # Progress
    
    $styleCmd element create Progress.bar image $I(progressbar)
    
    # Arrows
    
    $styleCmd element create uparrow image \
        [list $I(arrow_up_normal) \
        pressed $I(arrow_up_active) \
        disabled $I(arrow_up_insensitive)]
    $styleCmd element create downarrow image \
        [list $I(arrow_down_normal) \
        pressed $I(arrow_down_active) \
        disabled $I(arrow_down_insensitive)]
    $styleCmd element create leftarrow image \
        [list $I(arrow_left_normal) \
        pressed $I(arrow_left_active) \
        disabled $I(arrow_left_insensitive)]
    $styleCmd element create rightarrow image \
        [list $I(arrow_right_normal) \
        pressed $I(arrow_right_active) \
        disabled $I(arrow_right_insensitive)]
    
    # Notebook parts
    
    $styleCmd element create tab image \
        [list $I(notebook) selected  $I(notebook_active)] \
        -sticky news \
        -border {10 6 10 6} -height 10
    
    $styleCmd configure TNotebook.Tab -padding {2 2}
    $styleCmd configure TNotebook -expandtab {2 2}
    
    
    # Labelframes
    
    $styleCmd configure TLabelframe -borderwidth 2 -relief groove
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
