# plastik.tcl - Copyright (C) 2004 Googie
#
# A sample pixmap theme for the tile package.
#
#  Copyright (c) 2004 Googie
#  Copyright (c) 2005 Pat Thoyts <patthoyts@users.sourceforge.net>
#
# $Id: plastik.tcl,v 1.3 2009/10/25 19:24:34 oberdorfer Exp $

package require Tk 8.4;                 # minimum version for Tile
package require tile 0.8;               # depends upon tile

namespace eval ttk {
  namespace eval theme {
    namespace eval plastik {
      variable version 0.5.2
    }
  }
}



namespace eval ttk::theme::plastik {

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
    	-frame 		"#efefef"
	-disabledfg	"#aaaaaa"
	-selectbg	"#657a9e"
	-selectfg	"#ffffff"
    }


  ttk::style theme create plastik -parent clam -settings {
    ttk::style configure . \
	-foreground "Black" \
    	-background $colors(-frame) \
	-troughcolor $colors(-frame) \
	-selectbackground $colors(-selectbg) \
	-selectforeground $colors(-selectfg) \
	-fieldbackground $colors(-frame) \
	-font TkDefaultFont \
	-borderwidth 1 \
	;

    ttk::style map . -foreground [list disabled $colors(-disabledfg)]

    #
    # Layouts:
    #
    ttk::style layout Vertical.TScrollbar {
	Vertical.Scrollbar.uparrow -side top -sticky {}
	Vertical.Scrollbar.downarrow -side bottom -sticky {}
	Vertical.Scrollbar.trough -sticky ns -children {
	    Vertical.Scrollbar.thumb -expand 1 -unit 1 -children {
		Vertical.Scrollbar.grip -sticky {}
	    }
	}
    }

    ttk::style layout Horizontal.TScrollbar {
	Horizontal.Scrollbar.leftarrow -side left -sticky {}
	Horizontal.Scrollbar.rightarrow -side right -sticky {}
	Horizontal.Scrollbar.trough -sticky ew -children {
	    Horizontal.Scrollbar.thumb -expand 1 -unit 1 -children {
		Horizontal.Scrollbar.grip -sticky {}
	    }
        }
    }

    ttk::style layout TButton {
        Button.button -children {
	    Button.focus -children {
		Button.padding -children {
		    Button.label -side left -expand true
		}
	    }
	}
    }

    ttk::style layout Toolbutton {
        Toolbutton.border -children {
            Toolbutton.button -children {
                Toolbutton.padding -children {
                    Toolbutton.label -side left -expand true
                }
            }
        }
    }

    ttk::style layout TMenubutton {
	Menubutton.button -children {
	    Menubutton.indicator -side right
	    Menubutton.focus -children {
		Menubutton.padding -children {
		    Menubutton.label -side left -expand true
		}
	    }
	}
    }

    #
    # Elements:
    #
    ttk::style element create Button.button image [list $I(button-n) \
	    pressed	$I(button-p) \
	    active	$I(button-h) \
	] -border {4 10} -padding 4 -sticky ewns
    ttk::style element create Toolbutton.button image [list $I(tbutton-n) \
	    selected	$I(tbutton-p) \
	    pressed	$I(tbutton-p) \
	    active	$I(tbutton-h) \
	] -border {4 9} -padding 3 -sticky news

    ttk::style element create Checkbutton.indicator image [list $I(check-nu) \
	    {active selected}	$I(check-hc) \
	    {pressed selected}	$I(check-pc) \
	    active              $I(check-hu) \
	    selected            $I(check-nc) \
	] -sticky {}

    ttk::style element create Radiobutton.indicator image [list $I(radio-nu) \
	    {active selected}	$I(radio-hc) \
	    {pressed selected}  $I(radio-pc) \
	    active              $I(radio-hu) \
	    selected            $I(radio-nc) \
	] -sticky {}

    ttk::style element create Horizontal.Scrollbar.thumb image $I(hsb-n) \
	-border 3 -sticky ew
    ttk::style element create Horizontal.Scrollbar.grip image $I(hsb-g)
    ttk::style element create Horizontal.Scrollbar.trough image $I(hsb-t)

    ttk::style element create Vertical.Scrollbar.thumb image $I(vsb-n) \
	-border 3 -sticky ns
    ttk::style element create Vertical.Scrollbar.grip image $I(vsb-g)
    ttk::style element create Vertical.Scrollbar.trough image $I(vsb-t)

    ttk::style element create Scrollbar.uparrow image \
	[list $I(arrowup-n) pressed $I(arrowup-p)] -sticky {}
    ttk::style element create Scrollbar.downarrow \
	image [list $I(arrowdown-n) pressed $I(arrowdown-p)] -sticky {}
    ttk::style element create Scrollbar.leftarrow \
	image [list $I(arrowleft-n) pressed $I(arrowleft-p)] -sticky {}
    ttk::style element create Scrollbar.rightarrow \
	image [list $I(arrowright-n) pressed $I(arrowright-p)] -sticky {}

    ttk::style element create Horizontal.Scale.slider image $I(hslider-n) \
	-sticky {}
    ttk::style element create Horizontal.Scale.trough image $I(hslider-t) \
	-border 1 -padding 0
    ttk::style element create Vertical.Scale.slider image $I(vslider-n) \
	-sticky {}
    ttk::style element create Vertical.Scale.trough image $I(vslider-t) \
	-border 1 -padding 0

    ttk::style element create Entry.field \
	image [list $I(entry-n) focus $I(entry-f)] \
	-border 2 -padding {3 4} -sticky news

    ttk::style element create Labelframe.border image $I(border) \
	-border 4 -padding 4 -sticky news

    ttk::style element create Menubutton.button \
	image [list $I(combo-r) active $I(combo-ra)] \
	-sticky news -border {4 6 24 15} -padding {4 4 5}
    ttk::style element create Menubutton.indicator image $I(arrow-d) \
	-sticky e -border {15 0 0 0}

    ttk::style element create Combobox.field \
	image [list $I(combo-n) \
	    {readonly active}	$I(combo-ra) \
	    {focus active}	$I(combo-fa) \
	    active		$I(combo-a) \
	    {!readonly focus}	$I(combo-f) \
	    readonly		$I(combo-r) \
	] -border {4 6 24 15} -padding {4 4 5} -sticky news
    ttk::style element create Combobox.downarrow image $I(arrow-d) \
	-sticky e -border {15 0 0 0}

    ttk::style element create Notebook.client image $I(notebook-c) -border 4
    ttk::style element create Notebook.tab image [list $I(notebook-tn) \
	    selected	$I(notebook-ts) \
	    active	$I(notebook-ta) \
	] -padding {0 2 0 0} -border {4 10 4 10}

    ttk::style element create Progressbar.trough \
	image $I(hprogress-t) -border 2
    ttk::style element create Horizontal.Progressbar.pbar \
	image $I(hprogress-b) -border {2 9}
    ttk::style element create Vertical.Progressbar.pbar \
	image $I(vprogress-b) -border {9 2}

    ## Panedwindow parts.
    #
    ::ttk::style element create hsash image \
            [list $I(hsb-n) {active !disabled} $I(hsb-n)] \
            -height 7 -border {2 0}
    ::ttk::style element create vsash image \
            [list $I(vsb-n) {active !disabled} $I(vsb-n)] \
            -width 7 -border {0 2}


    ttk::style element create Treeheading.cell \
	image [list $I(tree-n) pressed $I(tree-p)] \
	-border {4 10} -padding 4 -sticky ewns

    #
    # Settings:
    #
    ttk::style configure TButton -width -10 -anchor center
    ttk::style configure Toolbutton -anchor center
    ttk::style configure TNotebook -tabmargins {0 2 0 0}
    ttk::style configure TNotebook.Tab -padding {6 2 6 2} -expand {0 0 2}
    ttk::style map TNotebook.Tab -expand [list selected {1 2 4 2}]
    ttk::style configure Treeview -padding 0
  }
}

package provide ttk::theme::plastik $::ttk::theme::plastik::version
