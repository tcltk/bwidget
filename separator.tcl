# ------------------------------------------------------------------------------
#  separator.tcl
#  This file is part of Unifix BWidget Toolkit
# ------------------------------------------------------------------------------
#  Index of commands:
#     - Separator::create
#     - Separator::configure
#     - Separator::cget
# ------------------------------------------------------------------------------

namespace eval Separator {
    Widget::declare Separator {
        {-background TkResource ""         0 frame}
        {-relief     Enum       groove     0 {ridge groove}}
        {-orient     Enum       horizontal 1 {horizontal vertical}}
        {-bg         Synonym    -background}
    }
    Widget::addmap Separator "" :cmd {-background {}}

    Widget::redir_create_command ::Separator
    proc use {} {}
}


# ------------------------------------------------------------------------------
#  Command Separator::create
# ------------------------------------------------------------------------------
proc Separator::create { path args } {
    array set maps [list Separator {} :cmd {}]
    array set maps [Widget::parseArgs Separator $args]
    eval [list frame $path] $maps(:cmd) -class Separator
    Widget::initFromODB Separator $path $maps(Separator)

    if { [Widget::cget $path -orient] == "horizontal" } {
	$path configure -borderwidth 1 -height 2
    } else {
	$path configure -borderwidth 1 -width 2
    }

    bind $path <Destroy> {Widget::destroy %W; rename %W {}}
    if { [string equal [Widget::cget $path -relief] "groove"] } {
	$path configure -relief sunken
    } else {
	$path configure -relief raised
    }

    rename $path ::$path:cmd
    Widget::redir_widget_command $path Separator

    return $path
}


# ------------------------------------------------------------------------------
#  Command Separator::configure
# ------------------------------------------------------------------------------
proc Separator::configure { path args } {
    set res [Widget::configure $path $args]

    if { [Widget::hasChanged $path -relief relief] } {
        if { $relief == "groove" } {
            $path:cmd configure -relief sunken
        } else {
            $path:cmd configure -relief raised
        }
    }

    return $res
}


# ------------------------------------------------------------------------------
#  Command Separator::cget
# ------------------------------------------------------------------------------
proc Separator::cget { path option } {
    return [Widget::cget $path $option]
}
