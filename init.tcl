# ----------------------------------------------------------------------------
#  init.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: init.tcl,v 1.91 2009/09/06 20:51:44 oberdorfer Exp $
# ----------------------------------------------------------------------------
#
namespace eval Widget {}
proc Widget::_opt_defaults {{prio widgetDefault}} {
    if {$::tcl_version >= 8.4} {
	set plat [tk windowingsystem]
    } else {
	set plat $::tcl_platform(platform)
    }
    switch -exact $plat {
	"aqua" {
	}
	"win32" -
	"windows" {
	    #option add *Listbox.background	SystemWindow $prio
	    option add *ListBox.background	SystemWindow $prio
	    #option add *Button.padY		0 $prio
	    option add *ButtonBox.padY		0 $prio
	    option add *Dialog.padY		0 $prio
	    option add *Dialog.anchor		e $prio
	}
	"x11" -
	default {
	    option add *Scrollbar.width		12 $prio
	    option add *Scrollbar.borderWidth	1  $prio
	    option add *Dialog.separator	1  $prio
	    option add *MainFrame.relief	raised $prio
	    option add *MainFrame.separator	none   $prio
	}
    }
}
Widget::_opt_defaults

option read [file join $::BWIDGET::LIBRARY "lang" "en.rc"]

## Add a TraverseIn binding to standard Tk widgets to handle some of
## the BWidget-specific things we do.
bind Entry   <<TraverseIn>> { %W selection range 0 end; %W icursor end }
bind Spinbox <<TraverseIn>> { %W selection range 0 end; %W icursor end }

bind all <Key-Tab>       { Widget::traverseTo [Widget::focusNext %W] }
bind all <<PrevWindow>>  { Widget::traverseTo [Widget::focusPrev %W] }

namespace eval ::BWidget {

    if {[lsearch -exact [font names] "TkTextFont"] < 0} {
        catch {font create TkTextFont}
        catch {font create TkDefaultFont}
        catch {font create TkHeadingFont}
        catch {font create TkCaptionFont}
        catch {font create TkTooltipFont}

        switch -- [tk windowingsystem] {
            "win32" {
                if {$::tcl_platform(osVersion) >= 5.0} {
                    variable family "Tahoma"
                } else {
                    variable family "MS Sans Serif"
                }
                variable size 8

                font configure TkDefaultFont -family $family -size $size
                font configure TkTextFont    -family $family -size $size
                font configure TkHeadingFont -family $family -size $size
                font configure TkCaptionFont -family $family -size $size \
                    -weight bold
                font configure TkTooltipFont -family $family -size $size
            }

            "classic" - "aqua" {
                variable family "Lucida Grande"
                variable size 13
                variable viewsize 12
                variable smallsize 11

                font configure TkDefaultFont -family $family -size $size
                font configure TkTextFont    -family $family -size $size
                font configure TkHeadingFont -family $family -size $smallsize
                font configure TkCaptionFont -family $family -size $size \
                    -weight bold
                font configure TkTooltipFont -family $family -size $viewsize
            }

            "x11" {
                if {![catch {tk::pkgconfig get fontsystem} fs]
                    && [string equal $fs "xft"]} {
                    variable family "sans-serif"
                } else {
                    variable family "Helvetica"
                }
                variable size -12
                variable ttsize -10
                variable capsize -14

                font configure TkDefaultFont -family $family -size $size
                font configure TkTextFont    -family $family -size $size
                font configure TkHeadingFont -family $family -size $size \
                    -weight bold
                font configure TkCaptionFont -family $family -size $capsize \
                    -weight bold
                font configure TkTooltipFont -family $family -size $ttsize
            }
        }
    }
} ; ## namespace eval ::BWidget


BWidget::set_themedefaults "initialize"
