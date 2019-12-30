#!/usr/bin/env tclsh
# WanTcl - a small library containing functions that I frequently
# use in my Tcl apps
# Copyright (C) Tim K 2018-2019 <timprogrammer@rambler.ru>.
#

package require wantcl::lists

proc decr {str {bywhat 1}} {
    upvar $str thisone
    incr thisone [expr {$bywhat * (-1)}]
}

proc invert {str} {
    upvar $str vl
    return [expr {! $vl}]
}

proc characters {str} {
    set result {}
    for {set index 0} {$index < [string length $str]} {incr index} {
        lappend result [string index $str $index]
    }
    return $result
}

proc normalizeSentence {arg} {
    set nstc [rsplit $arg .]
    set result {}
    foreach sentence $nstc {
        set splitSentence [rsplit $sentence { }]
        set resultSentence {}
        for {set index 0} {$index < [llength $splitSentence]} {incr index} {
            set word [lindex $splitSentence $index]
            if {$index == 0} {
                set wordSubst [string range $word 1 end]
                set firstChar [string toupper [string index $word 0]]
                set word "$firstChar$wordSubst"
            }
            lappend resultSentence $word
        }
        lappend result [join $resultSentence { }]
    }
    return [join $result { }]
}

proc occurencesCount {str} {
    set str [string tolower $str]
    set result [dict create]
    for {set index 0} {$index < [string length $str]} {incr index} {
        set character [string index $str $index]
        if {! [dict exists $result $character]} {
            dict set result $character 1
        } else {
            set vl [dict get $result $character]
            incr vl
            dict set result $character $vl
        }
    }
    return $result
}

package provide wantcl::strings 1.0