# ----------------------------------------------------------------------------
#  themeutils.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: themeutils.tcl,v 1.0 2009/09/05 21:01:07 oberdorfer Exp $
# ----------------------------------------------------------------------------
#  Index of commands:
#     - BWidget::usepackage
#     - BWidget::using
#     - BWidget::wrap
#     - BWidget::getcurrent_theme
#     - BWidget::read_ttkstylecolors
#     - BWidget::set_themedefaults
#     - BWidget::default_Color
#     - BWidget::[themename]_Color
#     - BWidget::_themechanged
# ----------------------------------------------------------------------------
# color mapping:
#     SystemWindow        -background
#     SystemWindowFrame   -background
#     SystemWindowText    -foreground
#     SystemButtonText    -activeforeground
#     SystemButtonFace    -activebackground
#     SystemDisabledText  -disabledforeground
#     SystemHighlight     -selectbackground
#     SystemHighlightText -selectforeground
#     SystemMenu          -background
#     SystemMenuText      -foreground
#     SystemScrollbar     -troughcolor
# ----------------------------------------------------------------------------

# Notes:
#
#   - Themed color declarations and names do not follow a strict rule,
#     so -most likely- there might be differences from theme to theme.
#     As a consequece of this fact, we have to support a minimum set
#     of color declarations which needs to be declared for most common
#     themes. Unsupported themes 'll fall back to the "default" color scheme.

#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

namespace eval BWidget {
    variable colors

    # theme related bindings:
    if {[lsearch [bindtags .] BWThemeChanged] < 0} {
        bindtags . [linsert [bindtags .] 1 BWThemeChanged]
    }

    bind BWThemeChanged <<ThemeChanged>> \
            "+ [namespace current]::_themechanged"
}


proc BWidget::usepackage { package } {
    variable _includes

    if { ![info exists _includes($package)] } { 
        # each package supported to enhance BWidgets is setup here.
        switch -- $package {
            "ttk" {
	        if { [catch {package present tile 0.8}] != 0 } {
                    return -code error "Tile 0.8 is not available!"
		}
		# check, if the theme name currently set has a
		# color array declaration, represented by a defined
		# procedure such as "BWidget::[themename]_Color

		set ctheme [getcurrent_theme]
		if { [lsearch [get_colordcls] $ctheme] == -1 } {
		    return -code error \
                        "color declarations for $ctheme missing!"
		}
                set_themedefaults
		Widget::theme 1
            }
	    default {
	        return -code error \
		  "[namespace curren] - invalid argument specified!"
	    }
        }
    }

    set _includes($package) 1
    return 1
}


proc BWidget::using { package } {
    if {[info exists ::BWidget::_includes($package)]} {
        return $::BWidget::_includes($package)
    }
    return 0
}


# a simple wrapper to distinguish between tk and ttk
proc BWidget::wrap {wtype wpath args} {

    if { [using ttk] } {
        # filter out (ttk-)unsupported (tk-)options:
	foreach opt {-background -bd -borderwith -highlightthickness} {
            set args [Widget::getArgument $args $opt tmp]
	}

        return [eval ttk::${wtype} $wpath $args]
    } else {
        return [eval $wtype $wpath $args]
    }
}


#------------------------------------------------------------------------------
# returns the current (tile) theme name
#------------------------------------------------------------------------------
proc BWidget::getcurrent_theme {} {
    variable colors

    if { [using ttk] } {
         # future version: "return [ttk::style theme use]"
         return $ttk::currentTheme
    } else {
         if { [info exists colors(style)] } {
             return $colors(style)
	 }
    }
    return -code error "cannot read style name - declaration is missing!"
}


# this function is a replacement for [ttk::style configure .]
# and takes as well the style decl's from the "default" style into account

proc BWidget::read_ttkstylecolors {} {

    # default style comes 1st:
    # temporarily sets the current theme to themeName,
    # evaluate script, then restore the previous theme.

    ttk::style theme settings "default" {
        set cargs [ttk::style configure .]
    }
    
    # superseed color defaults with values from currently active theme:
    foreach {opt val} [ttk::style configure .] {
      if { [set idx [lsearch $cargs $opt]] == -1 } {
          lappend cargs $opt $val
      } else {
          incr idx
	  if { ![string equal [lindex $cargs $idx] $val] } {
              set cargs [lreplace $cargs $idx $idx $val]
	  }
      }
    }

    return $cargs
}


#------------------------------------------------------------------------------
# make sure, to keep the commonly used "BWidget::colors" array up to date
#------------------------------------------------------------------------------

proc BWidget::set_themedefaults { {initialize ""} } {
    variable colors
    variable _prevtheme

    if { [string length $initialize] != 0 } {
        default_Color
        return
    }

    set currtheme [getcurrent_theme]

    if { [info exists _prevtheme] &&
         [string equal $_prevtheme $currtheme] } { return }
    set _prevtheme $currtheme

    # evaluate procedure where the naming matches the currently active theme:
    if { [catch { "${currtheme}_Color" }] != 0 } {
        default_Color
    }

    if { ![using ttk] } { return }

    # superseed color options from the ones provided by ttk theme (if available),
    # to fit as close as possible with the curent style, if one of the refered
    # option is not provided (which is most likely the case), we take the ones
    # which are declared by our own!

    # "-selectbackground" { set colors(SystemHighlight)     $val }
    # "-selectforeground" { set colors(SystemHighlightText) $val }

    foreach {opt val} [BWidget::read_ttkstylecolors] {
      switch -- $opt {
          "-foreground"  { set colors(SystemWindowText)  $val }
          "-background"  { set colors(SystemWindowFrame) $val }
          "-troughcolor" { set colors(SystemScrollbar)   $val }
      }
    }
}


proc BWidget::_themechanged {} {

    set_themedefaults

    # -- propagate new color settings:
    # note:
    #   modifying the option database doesn't affect existing widgets,
    #   only new widgets 'll be taken into account
    #
    #     Priorities:
    #         widgetDefault: 20   /   userDefault:   60
    #         startupFile:   40   /   interactive:   80 (D)
    set prio "userDefault"
    
    option add *background       $BWidget::colors(SystemWindowFrame)   $prio
    option add *foreground       $BWidget::colors(SystemWindowText)    $prio
    option add *selectbackground $BWidget::colors(SystemHighlight)     $prio
    option add *selectforeground $BWidget::colors(SystemHighlightText) $prio

    option add *Entry.highlightColor $BWidget::colors(SystemHighlight) $prio
    option add *Entry.highlightThickness 2 $prio

    option add *Text.background  $BWidget::colors(SystemWindow)        $prio
    option add *Text.foreground  $BWidget::colors(SystemWindowText)    $prio
    option add *Text.highlightBackground \
                                 $BWidget::colors(SystemHighlight)     $prio

    # -- modify existing tk widgts...
    set standard_dcls [list \
            [list -background          $BWidget::colors(SystemWindowFrame)] \
            [list -foreground          $BWidget::colors(SystemWindowText)] \
            [list -highlightColor      $BWidget::colors(SystemHighlight)] \
            [list -highlightBackground $BWidget::colors(SystemHighlight)] \
            [list -selectbackground    $BWidget::colors(SystemHighlight)] \
            [list -selectforeground    $BWidget::colors(SystemHighlightText)] \
    ]

    set menu_dcls [list \
            [list -background          $BWidget::colors(SystemMenu)] \
            [list -foreground          $BWidget::colors(SystemMenuText)] \
            [list -activebackground    $BWidget::colors(SystemHighlight)] \
            [list -activeforeground    $BWidget::colors(SystemHighlightText)] \
    ]

    # filter out:
    #  - ttk witdgets, which do not support a "-style" argument,
    #  - as well as custom widgets
    # widgets which fail to have an argument list at all are skipped

    set custom_classes {
            ComboBox ListBox MainFrame ScrollableFrame Tree
	    ScrolledWindow PanedWindow LabelFrame TitleFrame NoteBook
	    DragSite DropSite Listbox SelectFont ButtonBox DynamicHelp
	    ArrowButton LabelEntry SpinBox Separator
	    TLabel TFrame ProgressBar ComboboxPopdown
	    Canvas Entry Text
    }

    set widget_list {}
    foreach w [Widget::getallwidgets .] {
        set nostyle 0
        if { [lsearch $custom_classes [winfo class $w]] == -1 &&
	     [catch {$w configure} cargs] == 0 } {
	    foreach item $cargs {
	        if { [string compare [lindex $item 0] "-style"] != 0 } {
	            set nostyle 1
		    break
	        }
	    }
        }
	if { $nostyle == 1 } { lappend widget_list $w }
    }

    # o.k now for processing the color adjustment...

    foreach child $widget_list {
        set wclass [winfo class $child]

        switch -- $wclass {
	  "Menu"  { set col_dcls [lrange $menu_dcls 0 end] }
	  default { set col_dcls [lrange $standard_dcls 0 end] }
	}
        foreach citem $col_dcls {
            set copt [lindex $citem 0]
            set cval [lindex $citem 1]

            foreach optitem [$child configure] {
                if { [lsearch $optitem $copt] != -1 } {
	            catch { $child configure $copt $cval }
                }
            }
	}
    }

}


#------------------------------------------------------------------------------
# get color declarations
#------------------------------------------------------------------------------
proc BWidget::get_colordcls { } {
    set stylelist {}
    set keyword "_Color"
    foreach name [info proc] {
         if { [regexp -all -- $keyword $name] } {
	     set nlen [string length $name]
	     set klen [string length $keyword]
	     set stylename [string range $name 0 [expr {$nlen - $klen - 1}]]
	     # ![regexp -nocase -- "default" $stylename]
             lappend stylelist $stylename
	 }
    }
    return [lsort -dictionary $stylelist]
}


proc BWidget::default_Color { } {
    variable colors
    set colors(style) "default"

    if {[string equal $::tcl_platform(platform) "windows"]} {
         array set colors {
            SystemWindow        SystemWindow
            SystemWindowFrame   SystemWindowFrame
            SystemWindowText    SystemWindowText
            SystemButtonFace    SystemButtonFace
            SystemButtonText    SystemButtonText
            SystemDisabledText  SystemDisabledText
            SystemHighlight     SystemHighlight
            SystemHighlightText SystemHighlightText
            SystemMenu          SystemMenu
            SystemMenuText      SystemMenuText
            SystemScrollbar     SystemScrollbar
         }
      } else {
         array set colors {
            SystemWindow        "White"
            SystemWindowFrame   "#d9d9d9"
            SystemWindowText    "Black"
            SystemButtonFace    "#d9d9d9"
            SystemButtonText    "Black"
            SystemDisabledText  "#a3a3a3"
            SystemHighlight     "#c3c3c3"
            SystemHighlightText "White"
            SystemMenu          "#d9d9d9"
            SystemMenuText      "Black"
            SystemScrollbar     "#d9d9d9"
         }
    }
}


proc BWidget::winxpblue_Color { } {
    variable colors
    set colors(style) "winxpblue"

    array set colors {
      Style               "winxpblue"
      SystemWindow        "White"
      SystemWindowFrame   "#ece9d8"
      SystemWindowText    "Black"
      SystemButtonFace    "#d9d9d9"
      SystemButtonText    "Black"
      SystemDisabledText  "#a3a3a3"
      SystemHighlight     "#c1d2ee"
      SystemHighlightText "Black"
      SystemMenu          "LightGrey"
      SystemMenuText      "Black"
      SystemScrollbar     "#d9d9d9"
    }
}

proc BWidget::plastik_Color { } {
    variable colors
    set colors(style) "plastik"

    array set colors {
      SystemWindow        "LightGrey"
      SystemWindowFrame   "#efefef"
      SystemWindowText    "Black"
      SystemButtonFace    "#efefef"
      SystemButtonText    "Black"
      SystemDisabledText  "#aaaaaa"
      SystemHighlight     "#c3c3c3"
      SystemHighlightText "Black"
      SystemMenu          "LightGrey"
      SystemMenuText      "Black"
      SystemScrollbar     "#efefef"
    }
}

proc BWidget::keramik_Color { } {
    variable colors
    set colors(style) "keramik"

    array set colors {
      SystemWindow        "#ffffff"
      SystemWindowFrame   "#dddddd"
      SystemWindowText    "Black"
      SystemButtonFace    "#efefef"
      SystemButtonText    "Black"
      SystemDisabledText  "#aaaaaa"
      SystemHighlight     "#eeeeee"
      SystemHighlightText "Black"
      SystemMenu          "LightGrey"
      SystemMenuText      "Black"
      SystemScrollbar     "#efefef"
    }
}

proc BWidget::keramik_alt_Color { } {
    keramik_Color
    set colors(style) "keramik_alt"

}

proc BWidget::black_Color { } {
    variable colors
    set colors(style) "black"

    array set colors {
      SystemWindow        "#424242"
      SystemWindowFrame   "#424242"
      SystemWindowText    "Black"
      SystemButtonFace    "#efefef"
      SystemButtonText    "Black"
      SystemDisabledText  "DarkGrey"
      SystemHighlight     "Black"
      SystemHighlightText "LightGrey"
      SystemMenu          "#222222"
      SystemMenuText      "#ffffff"
      SystemScrollbar     "#626262"
    }
}


proc BWidget::aquativo_Color { } {
    variable colors
    set colors(style) "aquativo"

    array set colors {
      SystemWindow        "#EDF3FE"
      SystemWindowFrame   "White"
      SystemWindowText    "Black"
      SystemButtonFace    "#fafafa"
      SystemButtonText    "Black"
      SystemDisabledText  "#fafafa"
      SystemHighlight     "RoyalBlue"
      SystemHighlightText "White"
      SystemMenu          "LightGrey"
      SystemMenuText      "Black"
      SystemScrollbar     "White"
    }
}

