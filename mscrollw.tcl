# -----------------------------------------------------------------------------
#  mscrollw.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: scrollw.tcl,v 1.11 2004/02/04 00:11:29 hobbs Exp $
# -----------------------------------------------------------------------------
#  Index of commands:
#     - MultipleScrollableWidgets::create
#     - MultipleScrollableWidgets::getframe
#     - MultipleScrollableWidgets::addwidget
#     - MultipleScrollableWidgets::removewidget
#     - MultipleScrollableWidgets::configure
#     - MultipleScrollableWidgets::cget
#     - MultipleScrollableWidgets::xview
#     - MultipleScrollableWidgets::yview
#     - MultipleScrollableWidgets::xscrollcommand
#     - MultipleScrollableWidgets::yscrollcommand
# -----------------------------------------------------------------------------

namespace eval MultipleScrollableWidgets {
    Widget::define MultipleScrollableWidgets mscrollw

    namespace eval ScrollableWidget {
        Widget::declare MultipleScrollableWidgets::ScrollableWidget {
            {-scroll Enum both 0 {none both vertical horizontal}}
        }
    }

    Widget::declare MultipleScrollableWidgets {
	{-background  TkResource ""   0 button}
	{-relief      TkResource flat 0 frame}
	{-borderwidth TkResource 0    0 frame}
        {-xscrollcommand    TkResource "" 0 canvas}
        {-yscrollcommand    TkResource "" 0 canvas}
	{-bg	      Synonym	 -background}
	{-bd	      Synonym	 -borderwidth}
    }

    Widget::addmap MultipleScrollableWidgets "" :cmd {-relief {} -borderwidth {}}
}


# -----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::create
# -----------------------------------------------------------------------------
proc MultipleScrollableWidgets::create { path args } {
    Widget::init MultipleScrollableWidgets $path $args

    Widget::getVariable $path data

    set data(widgets) {}

    set bg     [Widget::cget $path -background]
    set sw     [eval [list frame $path \
			  -relief flat -borderwidth 0 -background $bg \
			  -highlightthickness 0 -takefocus 0] \
		    [Widget::subcget $path :cmd]]

    #bind $path <Configure> [list MultipleScrollableWidgets::_realize $path]
    #bind $path <Destroy>   [list MultipleScrollableWidgets::_destroy $path]

    return [Widget::create MultipleScrollableWidgets $path]
}


# -----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::getframe
# -----------------------------------------------------------------------------
proc MultipleScrollableWidgets::getframe { path } {
    return $path
}


# -----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::addwidget
# -----------------------------------------------------------------------------
proc MultipleScrollableWidgets::addwidget { path widget args } {
    Widget::init MultipleScrollableWidgets::ScrollableWidget $widget $args
    Widget::getVariable $path data
    lappend data(widgets) $widget
    set scroll [Widget::getoption $widget -scroll]
    switch -exact -- $scroll {
      both {
        set data($widget:x) 1; set data($widget:y) 1
        $widget configure \
            -xscrollcommand \
                [list MultipleScrollableWidgets::xscrollcommand $path $widget] \
            -yscrollcommand \
                [list MultipleScrollableWidgets::yscrollcommand $path $widget]
      }
      vertical {
        set data($widget:x) 0; set data($widget:y) 1
        $widget configure \
            -yscrollcommand \
                [list MultipleScrollableWidgets::yscrollcommand $path $widget]
      }
      horizontal {
        set data($widget:x) 1; set data($widget:y) 0
        $widget configure \
            -xscrollcommand \
                [list MultipleScrollableWidgets::xscrollcommand $path $widget]
      }
      default {set data($widget:x) 0; set data($widget:y) 0}
    }
}

# -----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::removewidget
# -----------------------------------------------------------------------------
proc MultipleScrollableWidgets::removewidget { path widget } {
    Widget::getVariable $path data
    set index [lsearch -exact $data(widgets) $widget]
    if {$index == -1} {
      error "widget \"$widget\" is not contained in widget \"$path\"!"
    } else {
      set data(widgets) [lreplace $data(widgets) $index $index]
      if {$data($widget:x)} {
        $widget configure -xscrollcommand {}
      }
      if {$data($widget:y)} {
        $widget configure -yscrollcommand {}
      }
      array unset data $widget:* 
      Widget::destroy $widget
    }
}


# -----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::configure
# -----------------------------------------------------------------------------
proc MultipleScrollableWidgets::configure { path args } {
    Widget::getVariable $path data

    set res [Widget::configure $path $args]
    if { [Widget::hasChanged $path -background bg] } {
	$path configure -background $bg
    }
    return $res
}


# -----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::cget
# -----------------------------------------------------------------------------
proc MultipleScrollableWidgets::cget { path option } {
    return [Widget::cget $path $option]
}


# ----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::xview
# ----------------------------------------------------------------------------
proc MultipleScrollableWidgets::xview { path args } {
    #puts "xview '$path' '$args'"
    set result {}
    Widget::getVariable $path data
    foreach widget $data(widgets) {
      set result [eval [list $widget xview] $args]
    }
    return $result
}


# ----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::yview
# ----------------------------------------------------------------------------
proc MultipleScrollableWidgets::yview { path args } {
    #puts "yview '$path' '$args'"
    set result {}
    Widget::getVariable $path data
    foreach widget $data(widgets) {
      set result [eval [list $widget yview] $args]
    }
    return $result
}


# ----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::xscrollcommand
# ----------------------------------------------------------------------------
proc MultipleScrollableWidgets::xscrollcommand { path widget args } {
    #puts "xscrollcommand '$path' '$widget' '$args'"
    set cmd [Widget::cget $path -xscrollcommand]
    if {[string length $cmd]} {
      return [eval $cmd $args]
    }
}


# ----------------------------------------------------------------------------
#  Command MultipleScrollableWidgets::yscrollcommand
# ----------------------------------------------------------------------------
proc MultipleScrollableWidgets::yscrollcommand { path widget args } {
    #puts "yscrollcommand '$path' '$widget' '$args'"
    set cmd [Widget::cget $path -yscrollcommand]
    if {[string length $cmd]} {
      return [eval $cmd $args]
    }
}
