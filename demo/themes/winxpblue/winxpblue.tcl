# winxpblue.tcl --
#
#   Copyright (C) 2004 Pat Thoyts <patthoyts@users.sourceforge.net>
#
#   Import the WinXP-Blue Gtk2 Theme by Ativo
#   URL: http://art.gnome.org/download/themes/gtk2/474/GTK2-WinXP-Blue.tar.gz
# ------------------------------------------------------------------------------
# Revision change history:
#   $Id: winxpblue.tcl,v 1.3 2009/10/25 19:25:35 oberdorfer Exp $
#
#   Aug.'08: code refractured/adopted slightly for the use with >= tk8.5,
#            johann.oberdorfer@gmail.com
# ------------------------------------------------------------------------------

package require Tk 8.4;                 # minimum version for Tile
package require tile 0.8;               # depends upon tile


namespace eval ::ttk:: {
  namespace eval theme {
    namespace eval winxpblue {
      variable version 0.2
    }
  }
}


namespace eval ::ttk::theme::winxpblue {
  
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
  
  ::ttk::style theme create winxpblue -parent clam -settings {
    
    # defaults:
    
    ::ttk::style configure "." \
        -foreground       "Black" \
        -background       "#ece9d8" \
        -selectbackground "#4a6984" \
        -selectforeground "#ffffff" \
	-font TkDefaultFont ;
    
    # gtkrc has #ece9d8 for background, notebook_active looks like #efebde
    
    # Mats: changed -background  disabled
    ::ttk::style map "." \
      -foreground { disabled "#565248" } \
      -background { disabled "#ece9d8"
                    pressed  "#bab5ab"
                    active   "#c1d2ee" }

    # Buttons, checkbuttons, radiobuttons, menubuttons:
    
    ::ttk::style layout TButton {
      Button.button -children { Button.focus -children { Button.label } }
    }
    ::ttk::style configure TButton -padding 3 -width -11
    
    ::ttk::style element create Button.button image \
        [list $I(buttonNorm) pressed $I(buttonPressed) active $I(button)] \
        -border {4 9} -padding 5 -sticky nsew

    ::ttk::style element create Checkbutton.indicator image \
        [list $I(checkbox_unchecked) selected $I(checkbox_checked)] \
        -width 20 -sticky w
	
    ::ttk::style element create Radiobutton.indicator image \
        [list $I(option_out) selected $I(option_in)] \
        -width 20 -sticky w

    ::ttk::style element create Menubutton.indicator image $I(menubar_option_arrow)
    
    # Scrollbars, scale, progress bars:
    
    ::ttk::style element create Horizontal.Scrollbar.thumb \
        image $I(scroll_horizontal) -border 3 -width 16 -height 0 -sticky nsew
    ::ttk::style element create Vertical.Scrollbar.thumb \
        image $I(scroll_vertical) -border 3 -width 0 -height 16 -sticky nsew
    ::ttk::style element create trough \
        image $I(horizontal_trough) -sticky ew -border {0 2} -height 18
    ::ttk::style element create Vertical.Scrollbar.trough \
        image $I(vertical_trough) -sticky ns -border {2 0} -width 18
    ::ttk::style element create Vertical.Scale.trough \
        image $I(vertical_trough) -sticky ns -border {2 0}
    ::ttk::style element create Progress.bar image $I(progressbar)
    ::ttk::style element create Progress.trough image $I(through) -border 4

    ## Panedwindow parts.
    #
    ::ttk::style element create hsash image \
            [list $I(hsb-n) {active !disabled} $I(hsb-a)] \
            -border {2 0}
    ::ttk::style element create vsash image \
            [list $I(vsb-n) {active !disabled} $I(vsb-a)] \
            -border {0 2}
    
    # Notebook parts:
    
    ::ttk::style element create tab image \
        [list $I(notebook_inactive) selected $I(notebook_active)] \
        -border {2 2 2 1} -width 8
    ::ttk::style configure TNotebook.Tab -padding {4 2}
    ::ttk::style configure TNotebook -expandtab {2 1}
    
    # Arrows:
    
    ::ttk::style element create uparrow image $I(arrow_up_normal) -sticky {}
    ::ttk::style element create downarrow image $I(arrow_down_normal) -sticky {}
    ::ttk::style element create leftarrow image $I(arrow_left_normal) -sticky {}
    ::ttk::style element create rightarrow image $I(arrow_right_normal) -sticky {}

    # Panes:
    # doesn't work: ::ttk::style configure Sash -sashthickness 6 -gripcount 10

    # maybe a nice effect
    # (although the image was not intended to be used like this):

    #::ttk::style element create Sash.hsash \
    #    image $I(hsb-n) -border 1 -width 0 -height 7 -sticky nsew
    #::ttk::style element create Sash.vsash \
    #    image $I(vsb-n) -border 1 -width 0 -width 7 -sticky nsew
  }
}


namespace eval ::tablelist:: {

  proc winxpblueTheme {} {
    variable themeDefaults
    array set themeDefaults [list \
	-background		white \
	-foreground		black \
	-disabledforeground	#565248 \
	-stripebackground	#e0e8f0 \
	-selectbackground	#4a6984 \
	-selectforeground	#ffffff \
	-selectborderwidth	0 \
	-font			TkTextFont \
        -labelbackground	#ece9d8 \
	-labeldisabledBg	#e3e1dd \
	-labelactiveBg		#c1d2ee \
	-labelpressedBg		#bab5ab \
	-labelforeground	black \
	-labeldisabledFg	#565248 \
	-labelactiveFg		black \
	-labelpressedFg		black \
	-labelfont		TkDefaultFont \
	-labelborderwidth	2 \
	-labelpady		1 \
	-arrowcolor		#aca899 \
	-arrowstyle		flat9x5 \
	-showseparators         yes \
      ]

    # for some reason, these options needs to be explicitely set:
    option add *Tablelist.foreground       $themeDefaults(-foreground)
    option add *Tablelist.background       $themeDefaults(-background)
    option add *Tablelist.stripebackground $themeDefaults(-stripebackground)
  }
}


# -------------------------------------------------------------------------
# -------------------------------------------------------------------------

package provide ttk::theme::winxpblue $::ttk::theme::winxpblue::version
