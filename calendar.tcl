#==========================================================
# calendar.tcl -- BWidget Calendar
#
#   a widget for playing with time
#   with an interface based on the iwidget calendar
#   written by Chris Maj cmaj_hat_freedomcorpse_hot_com
#   for the PgAccess project www.pgaccess.org
#   (lots of work needs to be done to get the embedded widget
#   method working, right now its just a simple dialog)
#==========================================================
# Index of commands:
#   Public commands
#       - Calendar::create
#   Private commands (internal helper procs)
#       - Calendar::_flipMonth
#       - Calendar::_selectDate
#       - Calendar::_clearDates
#==========================================================
#
namespace eval Calendar {

    Widget::declare Calendar {
        {-background        TkResource  ""          0 "label -background"}
        {-backwardimage     String      ""          0}
        {-currentdatefont   TkResource  ""          0 "label -font"}
        {-datefont          TkResource  ""          0 "label -font"}
        {-daybackground     TkResource  ""          0 "label -background"}
        {-dayfont           TkResource  ""          0 "label -font"}
        {-days              String      "Su Mo Tu We Th Fr Sa" 0}
        {-foreground        TkResource  ""          0 "label -foreground"}
        {-forwardimage      String      ""          0}
        {-height            Int         165         0 "%d >= 0"}
        {-highlightdaybackground TkResource "" 0 "label -highlightbackground"}
        {-highlightdaycolor      TkResource "" 0 "label -highlightcolor"}
        {-highlightdaythickness  TkResource "" 0 "label -highlightthickness"}
        {-highlightshowdate      TkResource "" 0 "label -highlightbackground"}
        {-multipleselection Int         1           0 "%d >= 0"}
        {-parent            String      ""          0}
        {-selectdates       String      ""          0}
        {-selectthickness   Int         3           0 "%d >= 0"}
        {-showdate          String      ""          0 ""}
        {-startday          Enum        "sunday"    0 {sunday monday tuesday wednesday thursday friday saturday}}
        {-title             String      "Calendar"  0}
        {-titlefont         TkResource  ""          0 "label -font"}
        {-type              Enum        "dialog"    1 {dialog popup embedded}}
        {-weekdaybackground TkResource  ""          0 "label -background"}
        {-weekendbackground TkResource  ""          0 "label -background"}
        {-width             Int         200         0 "%d >= 0"}
    }

}


#----------------------------------------------------------
# Calendar::create --
#
#   creates the calendar widget
#
# Arguments:
#   path    path to the calendar widget
#   args    args supplied to create the widget
#
# Results:
#   returns a sorted list of all selected dates
#----------------------------------------------------------
#
proc Calendar::create { path args } {

    variable $path
    upvar 0  $path data

    set data(dotw) "sunday monday tuesday wednesday thursday friday saturday"

    Widget::init Calendar "$path#Calendar" $args

    if {[Widget::cget "$path#Calendar" -type]=="embedded"} {
        set fr [frame $path \
            -takefocus 0 \
            -class Calendar]
    } else {
        if {[winfo exists $path]} {return}
        eval Dialog::create $path \
            -title [Widget::cget "$path#Calendar" -title] \
            -background [Widget::cget "$path#Calendar" -background] \
            -parent [Widget::cget "$path#Calendar" -parent]
        set fr [Dialog::getframe $path]
        $fr configure -width [Widget::cget "$path#Calendar" -width]
        $fr configure -height [Widget::cget "$path#Calendar" -height]
        $fr configure -relief flat
    }

    # make it easier to know what month/year we are on
    set data(showdate) [Widget::cget "$path#Calendar" -showdate]
    if {$data(showdate)==""} {
        set data(showdate) [clock seconds]
    } else {
        set data(showdate) [clock scan $data(showdate)]
    }
    set data(showmonth) [clock format $data(showdate) -format %B]
    set data(showyear) [clock format $data(showdate) -format %Y]
    set data(showday) [clock format $data(showdate) -format %d]
    set data(showdate) [clock format $data(showdate) -format "%e-%B-%Y"]
    set data(highlightshowdate) [Widget::cget "$path#Calendar" -highlightshowdate]

    set data(selectthickness) [Widget::cget "$path#Calendar" -selectthickness]
    set data(currentdatafont) [Widget::cget "$path#Calendar" -currentdatefont]
    set data(datefont) [Widget::cget "$path#Calendar" -datefont]
    set data(dayfont) [Widget::cget "$path#Calendar" -dayfont]
    set data(daybackground) [Widget::cget "$path#Calendar" -daybackground]
    set data(highlightdaybackground) [Widget::cget "$path#Calendar" -highlightdaybackground]
    set data(highlightdaycolor) [Widget::cget "$path#Calendar" -highlightdaycolor]
    set data(highlightdaythickness) [Widget::cget "$path#Calendar" -highlightdaythickness]
    set data(weekdaybackground) [Widget::cget "$path#Calendar" -weekdaybackground]
    set data(weekendbackground) [Widget::cget "$path#Calendar" -weekendbackground]
    set data(background) [Widget::cget "$path#Calendar" -background]
    set data(titlefont) [Widget::cget "$path#Calendar" -titlefont]
    set data(backwardimage) [Widget::cget "$path#Calendar" -backwardimage]
    set data(forwardimage) [Widget::cget "$path#Calendar" -forwardimage]
    set data(foreground) [Widget::cget "$path#Calendar" -foreground]
    set data(multipleselection) [Widget::cget "$path#Calendar" -multipleselection]
    set data(type) [Widget::cget "$path#Calendar" -type]
    # lets us pass in multiple pre-selected dates
    set data(selectdates) [list]
    foreach date [split [Widget::cget "$path#Calendar" -selectdates] {, }] {
        lappend data(selectdates) $date
    }

    # two buttons to move up/down a month
    Button $fr.leftbtn \
        -text "<" \
        -font $data(titlefont) \
        -command [list Calendar::_flipMonth $path -1]
    Button $fr.rightbtn \
        -text ">" \
        -font $data(titlefont) \
        -command [list Calendar::_flipMonth $path 1]
    if {[string length $data(backwardimage)] > 0} {
        $fr.leftbtn configure \
            -image $data(backwardimage)
    }
    if {[string length $data(forwardimage)] > 0} {
        $fr.rightbtn configure \
            -image $data(forwardimage)
    }

    # create a list of full month names
    set months [list]
    for {set i 1} {$i <= 12} {incr i} {
        set yr [clock format [clock seconds] -format %Y]
        set mo [clock format [clock scan "$yr-$i-1"] -format %B]
        lappend months $mo
    }

    # lets us pick the month
    ComboBox $fr.monthcombo \
        -font $data(titlefont) \
        -text $data(showmonth) \
        -textvariable ::Calendar::[subst {$path}](showmonth) \
        -editable 1 \
        -width 16 \
        -values $months \
        -modifycmd [list Calendar::_flipMonth $path 0]

    # lets us pick the year
    SpinBox $fr.yearspin \
        -font $data(titlefont) \
        -text $data(showyear) \
        -textvariable ::Calendar::[subst {$path}](showyear) \
        -editable 1 \
        -width 8 \
        -range [list 1492 2525 1] \
        -modifycmd [list Calendar::_flipMonth $path 0]

    grid $fr.leftbtn \
        -row 0 \
        -column 0 \
        -padx 10 \
        -pady 10 \
        -sticky news
    grid $fr.monthcombo \
        -row 0 \
        -column 1 \
        -padx 10 \
        -pady 10 \
        -columnspan 3
    grid $fr.yearspin \
        -row 0 \
        -column 4 \
        -padx 10 \
        -pady 10 \
        -columnspan 2
    grid $fr.rightbtn \
        -row 0 \
        -column 6 \
        -padx 10 \
        -pady 10 \
        -sticky news

    # list the days of the week in the format/order supplied
    set startday [Widget::cget "$path#Calendar" -startday]
    set data(startdayidx) [lsearch $data(dotw) $startday]
    set days [split [Widget::cget "$path#Calendar" -days]]
    for {set i $data(startdayidx)} {$i < [expr {$data(startdayidx) + 7}]} {incr i} {
        set day [lindex $days [expr {$i % 7}]]
        set someday "_"
        append someday $day "_1-" $i
        Label $fr.$someday \
            -font $data(dayfont) \
            -text $day \
            -background $data(daybackground)
        grid $fr.$someday \
            -row 1 \
            -column [expr {$i - $data(startdayidx)}] \
            -sticky s \
            -pady 2
    }

    # draw all the buttons we will use for days of the month
    for {set j 2} {$j < 8} {incr j} {
        for {set i 0} {$i < 7} {incr i} {
            set btn "_"
            append btn $i "x" $j
            Button $fr.$btn \
                -relief flat \
                -borderwidth $data(selectthickness) \
                -foreground $data(foreground) \
                -highlightbackground $data(highlightdaybackground) \
                -highlightcolor $data(highlightdaycolor) \
                -highlightthickness $data(highlightdaythickness)
            grid $fr.$btn \
                -row $j \
                -column $i \
                -sticky news
        }
    }

    # buttons at the bottom for clearing and/or finishing
    # the selection of dates, but only when we are a dialog
    # (not popup or embedded modes)
    if {[string match $data(type) "dialog"]} {
        Button $fr.okbtn \
            -text "OK" \
            -font $data(titlefont) \
            -command [list destroy $path]
        Button $fr.cancelbtn \
            -text "Cancel" \
            -font $data(titlefont) \
            -command [list Calendar::_clearDates $path 1]
        grid $fr.okbtn \
            -row [expr {$j+1}] \
            -column 1 \
            -columnspan 3 \
            -padx 10 \
            -pady 10 \
            -sticky news
        grid $fr.cancelbtn \
            -row [expr {$j+1}] \
            -column 4 \
            -columnspan 2 \
            -padx 10 \
            -pady 10 \
            -sticky news
    }

    # space the columns evenly
    # modified with tips from comp.lang.tcl posting by Donald Arseneau
    # BUT '-uniform' only works with newer versions of Tk
    if {$::tk_version>=8.4} {
        grid columnconfigure $fr {0 1 2 3 4 5 6} \
            -weight 1 \
            -uniform $fr
    } else {
        grid columnconfigure $fr {0 1 2 3 4 5 6} \
            -weight 1
    }

    # gets us to the right month
    _flipMonth $path $data(showdate)

    if {[string match $data(type) "popup"] \
     || [string match $data(type) "dialog"]} {
        # draws the calendar and waits for it to be destroyed
        Dialog::draw $path
        return [lsort -dictionary $data(selectdates)]
    }

}; # end proc Calendar::create


#----------------------------------------------------------
# Calendar::configure
#
# not yet used
#----------------------------------------------------------
#
proc Calendar::configure { path args } {
    return [Widget::configure "$path#Calendar" $args]
}; #end proc Calendar::configure


#----------------------------------------------------------
# Calendar::cget
#
# not yet used
#----------------------------------------------------------
#
proc Calendar::cget { path option } {
    return [Widget::cget "$path#Calendar" $option]
}; # end proc Calendar::cget


#----------------------------------------------------------
# Calendar::_flipMonth --
#
#   handles display of new month/year; places days of the
#   month in the proper places
#
# Arguments:
#   path        path of the calendar
#   flipday_    what date we are flipping to
#               OR if 1, go forward a month
#                 if -1, go back a month
#                  if 0, use the combobox selected month/year
#
# Results:
#   none returned
#
# Modifies:
#   current days of the month to reflect the newly selected
#   date
#----------------------------------------------------------
#
proc Calendar::_flipMonth { path flipday_ } {

    variable $path
    upvar 0  $path data

    if {[string match $data(type) "popup"] \
     || [string match $data(type) "dialog"]} {
        set fr [Dialog::getframe $path]
    } else {
        set fr $path
    }

    if {$flipday_ == -1} {
        set flipday_ "1-$data(showmonth)-$data(showyear)"
        set flipday_ [clock format [clock scan "last month" \
            -base [clock scan $flipday_]] -format "%D"]
    } elseif {$flipday_ == 1} {
        set flipday_ "1-$data(showmonth)-$data(showyear)"
        set flipday_ [clock format [clock scan "next month" \
            -base [clock scan $flipday_]] -format "%D"]
    } elseif {$flipday_ == 0} {
        set flipday_ "1-$data(showmonth)-$data(showyear)"
    }

    # crunching on some dates to make placement easier below
    set firstday [clock format [clock scan $flipday_] -format "%m/1/%y"]
    set firstdayow [expr {([clock format [clock scan $firstday] -format "%w"]-$data(startdayidx)) % 7}]
    set lastday [clock format [clock scan "yesterday" -base [clock scan [clock format [clock scan "next month" -base [clock scan $firstday]] -format "%m/1/%y"]]] -format "%D"]
    set lastdayom [clock format [clock scan $lastday] -format "%e"]
    set data(showmonth) [clock format [clock scan $firstday] -format "%B"]
    set data(showyear) [clock format [clock scan $firstday] -format "%Y"]
    set placeday 0
    set todayis [clock format [clock seconds] -format "%e-%B-%Y"]

    for {set j 2} {$j < 8} {incr j} {
        for {set i 0} {$i < 7} {incr i} {
            set btn "_"
            append btn $i "x" $j
            if {!$placeday && $firstdayow == $i} {
                set placeday 1
            }
            if {$placeday && $placeday <= $lastdayom} {
                set curday "$placeday-$data(showmonth)-$data(showyear)"
                # if this is today, use the right font
                if {[string match [string trim $curday] [string trim $todayis]]} {
                    $fr.$btn configure \
                        -font $data(currentdatafont)
                } else {
                    $fr.$btn configure \
                        -font $data(datefont)
                }
                # if this was a show date, highlight it
                if {[string match [string trim $curday] [string trim $data(showdate)]] \
                  && [string length $data(highlightshowdate)]>0} {
                    $fr.$btn configure \
                        -highlightbackground $data(highlightshowdate)
                } else {
                    $fr.$btn configure \
                        -highlightbackground $data(highlightdaybackground)
                }
                # different backgrounds for weekdays and weekends
                if {[lindex $data(dotw) [expr {($data(startdayidx) + $i) % 7}]] \
                    == "saturday"
                 || [lindex $data(dotw) [expr {($data(startdayidx) + $i) % 7}]] \
                    == "sunday"} {
                    $fr.$btn configure \
                        -background $data(weekendbackground)
                } else {
                    $fr.$btn configure \
                        -background $data(weekdaybackground)
                }
                $fr.$btn configure \
                    -text $placeday \
                    -command [list Calendar::_selectDate $fr.$btn $curday 0]
                # check to see if the date we just drew was
                # previously selected, maybe they went back
                # and forth a month or two a couple of times
                _selectDate $fr.$btn $curday 1
                incr placeday
            } elseif {!$placeday} {
                # click on day from previous month goes there
                $fr.$btn configure \
                    -text "" \
                    -relief flat \
                    -background $data(background) \
                    -highlightbackground $data(highlightdaybackground) \
                    -command [list Calendar::_flipMonth $path -1]
            } else {
                # click on day from next month goes there
                $fr.$btn configure \
                    -text "" \
                    -relief flat \
                    -background $data(background) \
                    -highlightbackground $data(highlightdaybackground) \
                    -command [list Calendar::_flipMonth $path 1]
            }
        }
    }

}; # end proc Calendar::_flipMonth


#----------------------------------------------------------
# Calendar::_selectDate --
#
#   handles selection and display of dates, by both
#   adding/deleting them from the list of selectdates and/or
#   updating the visual display.  if we are in popup mode,
#   the window will be destroyed after the first date is
#   selected.
#
# Arguments:
#   btnpath     path of the calendar widget button
#   clkd_       what date was selected
#   refresh_    whether to add/delete or just update the
#               display, 1 if just updating the display
#
# Results:
#   none returned
#
# Modifies:
#   the highlight of selected dates for the current month,
#   and the data(selectdates) list if not refreshing them
#----------------------------------------------------------
#
proc Calendar::_selectDate { btnpath clkd_ refresh_ } {

    set path [winfo toplevel $btnpath]
    variable $path
    upvar 0  $path data

    # this format is good for sorting
    set clkd_ [clock format [clock scan $clkd_] -format "%Y-%m-%d"]

    set clkpos [lsearch $data(selectdates) $clkd_]
    if {$clkpos == -1} {
        if {!$refresh_} {
            if {$data(multipleselection)} {
                # just keep adding dates
                $btnpath configure \
                    -relief sunken
                lappend data(selectdates) $clkd_
            } else {
                # ooh make sure that we only have one date
                # selected at a time so turn off the others
                set data(selectdates) [list]
                lappend data(selectdates) $clkd_
                # this makes things a little sluggish
                # another list (or an array) to hold the
                # button paths we need to change would speed
                # it up, but it works so wtf
                _flipMonth [winfo toplevel $btnpath] $clkd_
            }
        } else {
            # just a refresh, no biggie, we weren't selected
            $btnpath configure \
                -relief flat
        }
    } else {
        if {!$refresh_} {
            # we deselected a date
            $btnpath configure \
                -relief flat
            set data(selectdates) [lreplace $data(selectdates) $clkpos $clkpos]
        } else {
            # refreshing a previously selected date
            $btnpath configure \
                -relief sunken
        }
    }

    # should we disappear ?
    if {!$refresh_} {
        if {$data(multipleselection)>1} {
            if {[string match $data(type) "dialog"]} {
                if {[llength $data(selectdates)]==$data(multipleselection)} {
                    destroy [winfo toplevel $btnpath]
                }
            }
        } elseif {[string match $data(type) "popup"]} {
            destroy [winfo toplevel $btnpath]
        }
    }

}; # end proc Calendar::_selectDate


#----------------------------------------------------------
# Calendar::_clearDates --
#
#   clears the selected dates list
#
# Parameters:
#   path_       of the button firing this proc
#   destroy_    optional, can destroy the window
#
# Modifies:
#   data(selectdates) internal list
#----------------------------------------------------------
#
proc Calendar::_clearDates { path {destroy_ 0} } {
    variable $path
    upvar 0  $path data
    set data(selectdates) [list]
    if {$destroy_} {
        destroy $path
    } else {
        _flipMonth [winfo toplevel $path] 0
    }
}; # end proc Calendar::_clearDates
