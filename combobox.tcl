# ------------------------------------------------------------------------------
#  combobox.tcl
#  This file is part of Unifix BWidget Toolkit
#  $Id: combobox.tcl,v 1.11 2000/02/29 02:41:35 ericm Exp $
# ------------------------------------------------------------------------------
#  Index of commands:
#     - ComboBox::create
#     - ComboBox::configure
#     - ComboBox::cget
#     - ComboBox::setvalue
#     - ComboBox::getvalue
#     - ComboBox::_create_popup
#     - ComboBox::_mapliste
#     - ComboBox::_unmapliste
#     - ComboBox::_select
#     - ComboBox::_modify_value
# ------------------------------------------------------------------------------

namespace eval ComboBox {
    ArrowButton::use
    Entry::use
    LabelFrame::use

    Widget::bwinclude ComboBox LabelFrame .labf \
        rename     {-text -label} \
        remove     {-focus} \
        prefix     {label -justify -width -anchor -height -font} \
        initialize {-relief sunken -borderwidth 2}

    Widget::bwinclude ComboBox Entry .e \
        remove {-relief -bd -borderwidth -bg -fg} \
        rename {-foreground -entryfg -background -entrybg}

    Widget::declare ComboBox {
        {-height      TkResource 0  0 listbox}
        {-values      String     "" 0}
        {-images      String     "" 0}
        {-indents     String     "" 0}
        {-modifycmd   String     "" 0}
        {-postcommand String     "" 0}
    }

    Widget::addmap ComboBox "" :cmd {-background {}}
    Widget::addmap ComboBox ArrowButton .a {
        -foreground {} -background {} -disabledforeground {} -state {}
    }

    Widget::syncoptions ComboBox Entry .e {-text {}}
    Widget::syncoptions ComboBox LabelFrame .labf {-label -text -underline {}}

    ::bind BwComboBox <FocusIn> {focus %W.labf}
    ::bind BwComboBox <Destroy> {Widget::destroy %W; rename %W {}}

    proc ::ComboBox { path args } { return [eval ComboBox::create $path $args] }
    proc use {} {}
}


# ------------------------------------------------------------------------------
#  Command ComboBox::create
# ------------------------------------------------------------------------------
proc ComboBox::create { path args } {
    Widget::init ComboBox $path $args

    eval frame $path [Widget::subcget $path :cmd] \
        -highlightthickness 0 -bd 0 -relief flat -takefocus 0 -class ComboBox

    bindtags $path [list $path BwComboBox [winfo toplevel $path] all]

    set labf  [eval LabelFrame::create $path.labf [Widget::subcget $path .labf] \
                   -focus $path.e]
    set entry [eval Entry::create $path.e [Widget::subcget $path .e] \
                   -relief flat -borderwidth 0 -takefocus 1]
    ::bind $path.e <FocusIn> "$path _focus_in"
    ::bind $path.e <FocusOut> "$path _focus_out"

    if {[string equal $::tcl_platform(platform) "unix"]} {
        set ipadx 0
        set width 11
    } else {
        set ipadx 2
        set width 15
    }
    set height [winfo reqheight $entry]
    set arrow [eval ArrowButton::create $path.a [Widget::subcget $path .a] \
                   -width $width -height $height \
                   -highlightthickness 0 -borderwidth 1 -takefocus 0 \
                   -dir   bottom \
                   -type  button \
		   -ipadx $ipadx \
                   -command [list "ComboBox::_mapliste $path"]]

    set frame [LabelFrame::getframe $labf]

    pack $arrow -in $frame -side right -fill y
    pack $entry -in $frame -side left  -fill both -expand yes
    pack $labf  -fill x -expand yes

    if { [Widget::cget $path -editable] } {
        ::bind $entry <ButtonPress-1> "ComboBox::_unmapliste $path"
        Entry::configure $path.e -editable true
    } else {
        ::bind $entry <ButtonPress-1> "ArrowButton::invoke $path.a"
        Entry::configure $path.e -editable false
    }

    ::bind $path  <ButtonPress-1> "ComboBox::_unmapliste $path"
    ::bind $entry <Key-Up>        "ComboBox::_unmapliste $path"
    ::bind $entry <Key-Down>      "ComboBox::_mapliste $path"
    ::bind $entry <Control-Up>        "ComboBox::_modify_value $path previous"
    ::bind $entry <Control-Down>      "ComboBox::_modify_value $path next"
    ::bind $entry <Control-Prior>     "ComboBox::_modify_value $path first"
    ::bind $entry <Control-Next>      "ComboBox::_modify_value $path last"

    rename $path ::$path:cmd
    proc ::$path { cmd args } "return \[eval ComboBox::\$cmd $path \$args\]"

    return $path
}


# ------------------------------------------------------------------------------
#  Command ComboBox::configure
# ------------------------------------------------------------------------------
proc ComboBox::configure { path args } {
    set res [Widget::configure $path $args]

#     if { [Widget::hasChanged $path -values values] |
#          [Widget::hasChanged $path -height h] |
#          [Widget::hasChanged $path -font f] } {
#         destroy $path.shell.listb
#     }

    if { [Widget::hasChanged $path -editable ed] } {
        if { $ed } {
            ::bind $path.e <ButtonPress-1> "ComboBox::_unmapliste $path"
	    Entry::configure $path.e -editable true
	} else {
	    ::bind $path.e <ButtonPress-1> "ArrowButton::invoke $path.a"
	    Entry::configure $path.e -editable false
        }
    }

    return $res
}


# ------------------------------------------------------------------------------
#  Command ComboBox::cget
# ------------------------------------------------------------------------------
proc ComboBox::cget { path option } {
#    Widget::setoption $path -text [Entry::cget $path.e -text]
    return [Widget::cget $path $option]
}


# ------------------------------------------------------------------------------
#  Command ComboBox::setvalue
# ------------------------------------------------------------------------------
proc ComboBox::setvalue { path index } {
    set values [Widget::getoption $path -values]
    set value  [Entry::cget $path.e -text]
    switch -- $index {
        next {
            if { [set idx [lsearch $values $value]] != -1 } {
                incr idx
            } else {
                set idx [lsearch $values "$value*"]
            }
        }
        previous {
            if { [set idx [lsearch $values $value]] != -1 } {
                incr idx -1
            } else {
                set idx [lsearch $values "$value*"]
            }
        }
        first {
            set idx 0
        }
        last {
            set idx [expr {[llength $values]-1}]
        }
        default {
            if { [string index $index 0] == "@" } {
                set idx [string range $index 1 end]
		if { ![string is integer $idx] } {
                    return -code error "bad index \"$index\""
                }
            } else {
                return -code error "bad index \"$index\""
            }
        }
    }
    if { $idx >= 0 && $idx < [llength $values] } {
        set newval [lindex $values $idx]
	Entry::configure $path.e -text $newval
        return 1
    }
    return 0
}


# ------------------------------------------------------------------------------
#  Command ComboBox::getvalue
# ------------------------------------------------------------------------------
proc ComboBox::getvalue { path } {
    set values [Widget::getoption $path -values]
    set value  [Entry::cget $path.e -text]

    return [lsearch $values $value]
}


# ------------------------------------------------------------------------------
#  Command ComboBox::bind
# ------------------------------------------------------------------------------
proc ComboBox::bind { path args } {
    return [eval ::bind $path.e $args]
}


# ------------------------------------------------------------------------------
#  Command ComboBox::_create_popup
# ------------------------------------------------------------------------------
proc ComboBox::_create_popup { path } {
    set shell $path.shell
    set lval  [Widget::cget $path -values]
    set h     [Widget::cget $path -height]
    if { $h <= 0 } {
        set len [llength $lval]
        if { $len < 3 } {
            set h 3
        } elseif { $len > 10 } {
            set h 10
        } else {
            set h $len
        }
    }
    if { $::tcl_platform(platform) == "unix" } {
	set sbwidth 11
    } else {
	set sbwidth 15
    }
    if {![winfo exists $path.shell]} {
        set shell [toplevel $path.shell -relief sunken -bd 2]
        wm overrideredirect $shell 1
        wm transient $shell [winfo toplevel $path]
        wm withdraw  $shell

        set sw     [ScrolledWindow $shell.sw -managed 0 -size $sbwidth -ipad 0]
        set listb  [listbox $shell.listb \
		-relief flat -borderwidth 0 -highlightthickness 0 \
		-exportselection false \
		-font   [Widget::cget $path -font]  \
		-height $h \
		-listvariable [Widget::varForOption $path -values]]
        pack $sw -fill both -expand yes
        $sw setwidget $listb
#        _update_listbox $path 1

        ::bind $listb <ButtonRelease-1> "ComboBox::_select $path @%x,%y"
        ::bind $listb <Return>          "ComboBox::_select $path active; break"
        ::bind $listb <Escape>          "ComboBox::_unmapliste $path; break"
    } else {
        set listb $shell.listb
        destroy $shell.sw
        set sw [ScrolledWindow $shell.sw -managed 0 -size $sbwidth -ipad 0]
        $listb configure -height $h -font [Widget::cget $path -font]
        pack $sw -fill both -expand yes
        $sw setwidget $listb
        raise $listb
#        _update_listbox $path 0
    }
}


# ------------------------------------------------------------------------------
#  Command ComboBox::_update_listbox
# ------------------------------------------------------------------------------
proc ComboBox::_update_listbox {path force} {
    if {[Widget::hasChanged $path -values values] || $force} {
        set listb $path.shell.listb
        $listb delete 0 end
        eval $listb insert end $values
    }
}


# ------------------------------------------------------------------------------
#  Command ComboBox::_mapliste
# ------------------------------------------------------------------------------
proc ComboBox::_mapliste { path } {
    set listb $path.shell.listb
    if {[winfo exists $path.shell] &&
        ![string compare [wm state $path.shell] "normal"]} {
	_unmapliste $path
        return
    }

    if { [Widget::getoption $path -state] == "disabled" } {
        return
    }
    if { [set cmd [Widget::getoption $path -postcommand]] != "" } {
        uplevel \#0 $cmd
    }
    if { ![llength [Widget::getoption $path -values]] } {
        return
    }
    _create_popup $path

    ArrowButton::configure $path.a -relief sunken
    update

    $listb selection clear 0 end
    set values [Widget::getoption $path -values]
    set curval [Entry::cget $path.e -text]
    if { [set idx [lsearch $values $curval]] != -1 ||
         [set idx [lsearch $values "$curval*"]] != -1 } {
        $listb selection set $idx
        $listb activate $idx
        $listb see $idx
    } else {
	$listb selection set 0
        $listb activate 0
        $listb see 0
    }

    set frame [LabelFrame::getframe $path.labf]
    BWidget::place $path.shell [winfo width $frame] 0 below $frame
    wm deiconify $path.shell
    raise $path.shell
    BWidget::focus set $listb
    BWidget::grab global $path
}


# ------------------------------------------------------------------------------
#  Command ComboBox::_unmapliste
# ------------------------------------------------------------------------------
proc ComboBox::_unmapliste { path } {
    if {[winfo exists $path.shell] && \
	    ![string compare [wm state $path.shell] "normal"]} {
        BWidget::grab release $path
        BWidget::focus release $path.shell.listb
	# Update now because otherwise [focus -force...] makes the app hang!
	update
	focus -force $path.e
        wm withdraw $path.shell
        ArrowButton::configure $path.a -relief raised
    }
}


# ------------------------------------------------------------------------------
#  Command ComboBox::_select
# ------------------------------------------------------------------------------
proc ComboBox::_select { path index } {
    set index [$path.shell.listb index $index]
    _unmapliste $path
    if { $index != -1 } {
        if { [setvalue $path @$index] } {
            if { [set cmd [Widget::getoption $path -modifycmd]] != "" } {
                uplevel \#0 $cmd
            }
        }
    }
    $path.e selection clear
    $path.e selection range 0 end
    return -code break
}


# ------------------------------------------------------------------------------
#  Command ComboBox::_modify_value
# ------------------------------------------------------------------------------
proc ComboBox::_modify_value { path direction } {
    if { [setvalue $path $direction] } {
        if { [set cmd [Widget::getoption $path -modifycmd]] != "" } {
            uplevel \#0 $cmd
        }
    }
}

# ----------------------------------------------------------------------------
#  Command ComboBox::_focus_in
# ----------------------------------------------------------------------------
proc ComboBox::_focus_in { path } {
    variable background
    variable foreground

    if { [Widget::getoption $path -editable] == 0 } {
        set value  [Entry::cget $path.e -text]
        if {[string equal $value ""]} {
            # If the entry is empty, we need to do some magic to
            # make it "selected"
            if {[$path.e cget -bg] != [$path.e cget -selectbackground]} {
                # Copy only if we know that this is not the selection
                # background color (by accident... focus out without
                # focus in etc.
                set background [$path.e cget -bg]
                set foreground [$path.e cget -fg]
            }
            $path.e configure -bg [$path.e cget -selectbackground]
            $path.e configure -fg [$path.e cget -selectforeground]
        }
    }
    $path.e selection clear
    $path.e selection range 0 end
}


# ----------------------------------------------------------------------------
#  Command ComboBox::_focus_out
# ----------------------------------------------------------------------------
proc ComboBox::_focus_out { path } {
    variable background
    variable foreground

    if { [Widget::getoption $path -editable] == 0 } {
        if {[info exists background]} {
            $path.e configure -bg $background
            $path.e configure -fg $foreground
            unset background
            unset foreground
        }
    }
}
