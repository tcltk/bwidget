# ----------------------------------------------------------------------------
#  dynhelp.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: dynhelp.tcl,v 1.12 2003/05/07 08:24:04 hobbs Exp $
# ----------------------------------------------------------------------------
#  Index of commands:
#     - DynamicHelp::configure
#     - DynamicHelp::include
#     - DynamicHelp::sethelp
#     - DynamicHelp::register
#     - DynamicHelp::_motion_balloon
#     - DynamicHelp::_motion_info
#     - DynamicHelp::_leave_info
#     - DynamicHelp::_menu_info
#     - DynamicHelp::_show_help
#     - DynamicHelp::_init
# ----------------------------------------------------------------------------

# JDC: allow variable and ballon help at the same timees

namespace eval DynamicHelp {
    Widget::declare DynamicHelp {
        {-foreground     TkResource black         0 label}
        {-topbackground  TkResource black         0 {label -foreground}}
        {-background     TkResource "#FFFFC0"     0 label}
        {-borderwidth    TkResource 1             0 label}
        {-justify        TkResource left          0 label}
        {-font           TkResource "helvetica 8" 0 label}
        {-delay          Int        600           0 "%d >= 100 & %d <= 2000"}
	{-state          Enum       "normal"      0 {normal disabled}}
        {-padx           TkResource 1             0 label}
        {-pady           TkResource 1             0 label}
        {-bd             Synonym    -borderwidth}
        {-bg             Synonym    -background}
        {-fg             Synonym    -foreground}
        {-topbg          Synonym    -topbackground}
    }

    proc use {} {}

    variable _registered
    variable _canvases

    variable _top     ".help_shell"
    variable _id      ""
    variable _delay   600
    variable _current_balloon ""
    variable _current_variable ""
    variable _saved

    Widget::init DynamicHelp $_top {}

    bind BwHelpBalloon <Enter>   {DynamicHelp::_motion_balloon enter  %W %X %Y}
    bind BwHelpBalloon <Motion>  {DynamicHelp::_motion_balloon motion %W %X %Y}
    bind BwHelpBalloon <Leave>   {DynamicHelp::_motion_balloon leave  %W %X %Y}
    bind BwHelpBalloon <Button>  {DynamicHelp::_motion_balloon button %W %X %Y}
    bind BwHelpBalloon <Destroy> {if {[info exists DynamicHelp::_registered(%W,balloon)]} {unset DynamicHelp::_registered(%W,balloon)}}

    bind BwHelpVariable <Enter>   {DynamicHelp::_motion_info %W}
    bind BwHelpVariable <Motion>  {DynamicHelp::_motion_info %W}
    bind BwHelpVariable <Leave>   {DynamicHelp::_leave_info  %W}
    bind BwHelpVariable <Destroy> {if {[info exists DynamicHelp::_registered(%W,variable)]} {unset DynamicHelp::_registered(%W,variable)}}

    bind BwHelpMenu <<MenuSelect>> {DynamicHelp::_menu_info select %W}
    bind BwHelpMenu <Unmap>        {DynamicHelp::_menu_info unmap  %W}
    bind BwHelpMenu <Destroy>      {if {[info exists DynamicHelp::_registered(%W)]} {unset DynamicHelp::_registered(%W)}}
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::configure
# ----------------------------------------------------------------------------
proc DynamicHelp::configure { args } {
    variable _top
    variable _delay

    set res [Widget::configure $_top $args]
    if { [Widget::hasChanged $_top -delay val] } {
        set _delay $val
    }

    return $res
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::include
# ----------------------------------------------------------------------------
proc DynamicHelp::include { class type } {
    set helpoptions [list \
	    [list -helptext String "" 0] \
	    [list -helpvar  String "" 0] \
	    [list -helptype Enum $type 0 [list balloon variable]] \
	    ]
    Widget::declare $class $helpoptions
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::sethelp
# ----------------------------------------------------------------------------
proc DynamicHelp::sethelp { path subpath {force 0}} {
    foreach {ctype ctext cvar} [Widget::hasChangedX $path \
	    -helptype -helptext -helpvar] break
    if { $force || $ctype || $ctext || $cvar } {
	set htype [Widget::cget $path -helptype]
        switch $htype {
            balloon {
                return [register $subpath balloon \
			[Widget::cget $path -helptext]]
            }
            variable {
                return [register $subpath variable \
			[Widget::cget $path -helpvar] \
			[Widget::cget $path -helptext]]
            }
        }
        return [register $subpath $htype]
    }
}

# ----------------------------------------------------------------------------
#  Command DynamicHelp::register
#
#  DynamicHelp::register path balloon  ?itemOrTag? text
#  DynamicHelp::register path variable ?itemOrTag? text varName
#  DynamicHelp::register path menu varName
#  DynamicHelp::register path menuentry index text
# ----------------------------------------------------------------------------
proc DynamicHelp::register { path type args } {
    variable _registered
    variable _canvases

    set len [llength $args]
    if {$type == "balloon"  && $len > 1} { set type canvasBalloon  }
    if {$type == "variable" && $len > 2} { set type canvasVariable }

    if { [winfo exists $path] } {
        set evt  [bindtags $path]
        switch $type {
            balloon {
		set text [lindex $args 0]
		set idx [lsearch $evt "BwHelpBalloon"]
		set evt [lreplace $evt $idx $idx]
                if { $text != "" } {
		    set _registered($path,balloon) $text
		    lappend evt BwHelpBalloon
                } else {
                    if {[info exists _registered($path,balloon)]} {
                        unset _registered($path,balloon)
                    }
		}
		bindtags $path $evt
                return 1
            }

	    canvasBalloon {
		set tagOrItem  [lindex $args 0]
		set text       [lindex $args 1]
		if { $text != "" } {
		    set _registered($path,$tagOrItem,balloon) $text
		} else {
		    if {[info exists _registered($path,$tagOrItem,balloon)]} {
			unset _registered($path,$tagOrItem,balloon)
		    }
		}

		if {![info exists _canvases($path,balloon)]} {
		    ## This canvas doesn't have the bindings yet.
		    $path bind BwHelpBalloon <Enter> \
			{DynamicHelp::_motion_balloon enter  %W %X %Y 1}
		    $path bind BwHelpBalloon <Motion> \
			{DynamicHelp::_motion_balloon motion %W %X %Y 1}
		    $path bind BwHelpBalloon <Leave> \
			{DynamicHelp::_motion_balloon leave  %W %X %Y 1}
		    $path bind BwHelpBalloon <Button> \
			{DynamicHelp::_motion_balloon button %W %X %Y 1}
		    bind $path <Destroy> \
			{DynamicHelp::_unset_help %W}
		    set _canvases($path,balloon) 1
		}
		$path addtag BwHelpBalloon withtag $tagOrItem
		return 1
	    }

            variable {
		set idx  [lsearch $evt "BwHelpVariable"]
		set evt  [lreplace $evt $idx $idx]
                set var  [lindex $args 0]
                set text [lindex $args 1]
                if { $text != "" && $var != "" } {
                    set _registered($path,variable) [list $var $text]
                    lappend evt BwHelpVariable
                } else {
                    if {[info exists _registered($path,variable)]} {
                        unset _registered($path,variable)
                    }
                }
                bindtags $path $evt
                return 1
            }

	    canvasVariable {
		set tagOrItem  [lindex $args 0]
		set var        [lindex $args 1]
		set text       [lindex $args 2]
		if { $text != "" && $var != "" } {
		    set _registered($path,$tagOrItem,variable) [list $var $text]
		} else {
		    if {[info exists _registered($path,$tagOrItem,variable)]} {
			unset _registered($path,$tagOrItem,variable)
		    }
		}
		if {![info exists _canvases($path,variable)]} {
		    $path bind BwHelpVariable <Enter> \
		    	{DynamicHelp::_motion_info %W 1}
		    $path bind BwHelpVariable <Motion> \
		    	{DynamicHelp::_motion_info %W 1}
		    $path bind BwHelpVariable <Leave> \
		    	{DynamicHelp::_leave_info  %W 1}
		    bind $path <Destroy> \
		    	{DynamicHelp::_unset_help  %W 1}
		    set _canvases($path,variable) 1
		}
		$path addtag BwHelpVariable withtag $tagOrItem
		return 1
	    }

            menu {
                set cpath [BWidget::clonename $path]
                if { [winfo exists $cpath] } {
                    set path $cpath
                }
                set var [lindex $args 0]
                if { $var != "" } {
                    set _registered($path) [list $var]
                    lappend evt BwHelpMenu
                } else {
                    if {[info exists _registered($path)]} {
                        unset _registered($path)
                    }
                }
                bindtags $path $evt
                return 1
            }

            menuentry {
                set cpath [BWidget::clonename $path]
                if { [winfo exists $cpath] } {
                    set path $cpath
                }
                if { [info exists _registered($path)] } {
                    if { [set index [lindex $args 0]] != "" } {
                        set text  [lindex $args 1]
                        set idx   [lsearch $_registered($path) [list $index *]]
                        if { $text != "" } {
                            if { $idx == -1 } {
                                lappend _registered($path) [list $index $text]
                            } else {
                                set _registered($path) [lreplace $_registered($path) $idx $idx [list $index $text]]
                            }
                        } else {
                            set _registered($path) [lreplace $_registered($path) $idx $idx]
                        }
                    }
                    return 1
                }
                return 0
            }
        }
        if {[info exists _registered($path,balloon)]} {
            unset _registered($path,balloon)
        }
        if {[info exists _registered($path,variable)]} {
            unset _registered($path,variable)
        }
        if {[info exists _registered($path)]} {
            unset _registered($path)
        }
        bindtags $path $evt
        return 1
    } else {
        if {[info exists _registered($path,balloon)]} {
            unset _registered($path,balloon)
        }
	if {[info exists _registered($path,variable)]} {
            unset _registered($path,variable)
        }
        if {[info exists _registered($path)]} {
            unset _registered($path)
        }
        return 0
    }
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::_motion_balloon
# ----------------------------------------------------------------------------
proc DynamicHelp::_motion_balloon { type path x y {isCanvasItem 0} } {
    variable _top
    variable _id
    variable _delay
    variable _current_balloon

    set w $path
    if {$isCanvasItem} { set path [_get_canvas_path $path balloon] }

    if { $_current_balloon != $path && $type == "enter" } {
        set _current_balloon $path
        set type "motion"
        destroy $_top
    }
    if { $_current_balloon == $path } {
        if { $_id != "" } {
            after cancel $_id
            set _id ""
        }
        if { $type == "motion" } {
            if { ![winfo exists $_top] } {
                set _id [after $_delay [list DynamicHelp::_show_help $path $w $x $y]]
            }
        } else {
            destroy $_top
            set _current_balloon ""
        }
    }
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::_motion_info
# ----------------------------------------------------------------------------
proc DynamicHelp::_motion_info { path {isCanvasItem 0} } {
    variable _registered
    variable _current_variable
    variable _saved

    if {$isCanvasItem} { set path [_get_canvas_path $path variable] }

    if { $_current_variable != $path && [info exists _registered($path,variable)] } {
        if { ![info exists _saved] } {
            set _saved [GlobalVar::getvar [lindex $_registered($path,variable) 0]]
        }
        GlobalVar::setvar [lindex $_registered($path,variable) 0] [lindex $_registered($path,variable) 1]
        set _current_variable $path
    }
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::_leave_info
# ----------------------------------------------------------------------------
proc DynamicHelp::_leave_info { path {isCanvasItem 0} } {
    variable _registered
    variable _current_variable
    variable _saved

    if {$isCanvasItem} { set path [_get_canvas_path $path variable] }

    if { [info exists _registered($path,variable)] } {
        GlobalVar::setvar [lindex $_registered($path,variable) 0] $_saved
    }
    unset _saved
    set _current_variable ""
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::_menu_info
#    Version of R1v1 restored, due to lack of [winfo ismapped] and <Unmap>
#    under windows for menu.
# ----------------------------------------------------------------------------
proc DynamicHelp::_menu_info { event path } {
    variable _registered

    if { [info exists _registered($path)] } {
        set index [$path index active]
        if { [string compare $index "none"] &&
             [set idx [lsearch $_registered($path) [list $index *]]] != -1 } {
            GlobalVar::setvar [lindex $_registered($path) 0] \
                [lindex [lindex $_registered($path) $idx] 1]
        } else {
            GlobalVar::setvar [lindex $_registered($path) 0] ""
        }
    }
}


# ----------------------------------------------------------------------------
#  Command DynamicHelp::_show_help
# ----------------------------------------------------------------------------
proc DynamicHelp::_show_help { path w x y } {
    variable _top
    variable _registered
    variable _id
    variable _delay

    if { [Widget::getoption $_top -state] == "disabled" } { return }

    if { [info exists _registered($path,balloon)] } {
        destroy  $_top
        toplevel $_top -relief flat \
            -bg [Widget::getoption $_top -topbackground] \
            -bd [Widget::getoption $_top -borderwidth] \
            -screen [winfo screen $w]

        wm overrideredirect $_top 1
        wm transient $_top
        wm withdraw $_top

        label $_top.label -text $_registered($path,balloon) \
            -relief flat -bd 0 -highlightthickness 0 \
	    -padx       [Widget::getoption $_top -padx] \
	    -pady       [Widget::getoption $_top -pady] \
            -foreground [Widget::getoption $_top -foreground] \
            -background [Widget::getoption $_top -background] \
            -font       [Widget::getoption $_top -font] \
            -justify    [Widget::getoption $_top -justify]


        pack $_top.label -side left
        update idletasks

	if {![winfo exists $_top]} {return}

        set  scrwidth  [winfo vrootwidth  .]
        set  scrheight [winfo vrootheight .]
        set  width     [winfo reqwidth  $_top]
        set  height    [winfo reqheight $_top]
        incr y 12
        incr x 8

        if { $x+$width > $scrwidth } {
            set x [expr {$scrwidth - $width}]
        }
        if { $y+$height > $scrheight } {
            set y [expr {$y - 12 - $height}]
        }

        wm geometry  $_top "+$x+$y"
        update idletasks

	if {![winfo exists $_top]} {return}
        wm deiconify $_top
    }
}

# ----------------------------------------------------------------------------
#  Command DynamicHelp::_unset_help
# ----------------------------------------------------------------------------
proc DynamicHelp::_unset_help {path} {
    variable _registered
    foreach var [array names _registered $path,*] { unset _registered($var) }
}

# ----------------------------------------------------------------------------
#  Command DynamicHelp::_get_canvas_path
# ----------------------------------------------------------------------------
proc DynamicHelp::_get_canvas_path { path type {item ""} } {
    variable _registered

    if {$item == ""} { set item [$path find withtag current] }

    ## Check the tags related to this item for the one that
    ## represents our text.  If we have text specific to this
    ## item or for 'all' items, they override any other tags.
    eval [list lappend tags $item all] [$path itemcget $item -tags]
    foreach tag $tags {
	set check $path,$tag
	if {![info exists _registered($check,$type)]} { continue }
	return $check
    }
}
