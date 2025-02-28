namespace eval DemoCalendar {
    variable singleDate
}

proc DemoCalendar::pickSingleDate { path_ } {
    variable singleDate
    set singleDate [Calendar::create $path_ \
        -type popup \
        -datefont "Times 12" \
        -dayfont "Times 12" \
        -currentdatefont "Times 14 bold" \
        -titlefont "Times 16"]
}

proc DemoCalendar::pickMultipleDates { path_ {lbpath_ ""} } {
    set dates [Calendar::create $path_ \
        -multipleselection 1 \
        -datefont "Arial 12" \
        -dayfont "Arial 12" \
        -currentdatefont "Arial 14 bold" \
        -titlefont "Arial 16"]
    if {[string length $lbpath_]>0} {
        $lbpath_ delete [$lbpath_ items]
        foreach day $dates {
            $lbpath_ insert end [string map {- {}} $day] \
                -text $day
        }
    }
}

proc DemoCalendar::pickColorfulDate { path_ } {
    variable colorfulDate
    set colorfulDate [Calendar::create $path_ \
        -background navyblue \
        -foreground blue \
        -daybackground yellow \
        -highlightdaybackground navyblue \
        -highlightdaythickness 2 \
        -weekdaybackground white \
        -weekendbackground green \
        -multipleselection 0 \
        -selectthickness 5 \
        -showdate $colorfulDate \
        -highlightshowdate red \
        -selectdates $colorfulDate]
}

proc DemoCalendar::create { nb } {
    set frame   [$nb insert end demoCalendar \
                    -text "Calendar"]

    # single dates
    set titf1   [TitleFrame $frame.titf1 \
                    -text "Single Date"]
    set subf    [$titf1 getframe]
    set btn     [Button $subf.btn \
                    -text "Pick" \
                    -command [list DemoCalendar::pickSingleDate $titf1.cal]]
    set ent     [Entry $subf.ent \
                    -editable 0 \
                    -textvariable DemoCalendar::singleDate]
    pack $btn $ent \
        -side top \
        -pady 4 \
        -fill x

    # multiple dates
    set titf2   [TitleFrame $frame.titf2 \
                    -text "Multiple Dates"]
    set subf    [$titf2 getframe]
    set btn     [Button $subf.btn \
                    -text "Pick" \
                    -command [list DemoCalendar::pickMultipleDates $titf2.cal $subf.lb]]
    set lb      [ListBox $subf.lb \
                    -height 5]
    pack $btn $lb \
        -side top \
        -pady 4 \
        -fill x

    # lots of colors
    set titf3   [TitleFrame $frame.titf3 \
                    -text "Easy on the eyes"]
    set subf    [$titf3 getframe]
    set btn     [Button $subf.btn \
                    -text "Pick" \
                    -command [list DemoCalendar::pickColorfulDate $titf3.cal]]
    set ent     [Entry $subf.ent \
                    -editable 0 \
                    -textvariable DemoCalendar::colorfulDate]
    pack $btn $ent \
        -side top \
        -pady 4 \
        -fill x

    # pack the title frames nicely
    pack $titf1 $titf2 $titf3 \
        -pady 4

    return $frame
}
