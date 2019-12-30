#!/usr/bin/env tclsh
# WanTcl - a small library containing functions that I frequently
# use in my Tcl apps
# Copyright (C) Tim K 2018-2019 <timprogrammer@rambler.ru>.
#

proc incrementDict {d1 d2} {
    set result $d1
    foreach key [dict keys $d2] {
        if {! [dict exists $result $key]} {
            dict set result $key [dict get $d2 $key]
        } else {
            set vl [dict get $d1 $key]
            set vli [dict get $d2 $key]
            if {[string is integer $vl] && [string is integer $vli]} {
                dict set result $key [expr {$vl + $vli}]
            }
        }
    }
    return $result
}

proc recursiveListToJSON {vlist} {
    set result {}
    foreach itm $vlist {
        if {[string is integer $itm]} {
            lappend result $itm
        } else {
            lappend result "\"[string map [dict create "\"" "\\\""] $itm]\""
        }
    }
    return "\[[join $result ,]\]"
}

proc dictToJSON {dictionary} {
    set result {}
    dict for {kv vv} $dictionary {
        set vvp "\"$kv\": \"[string map [dict create "\"" "\\\""] $vv]\""
        if {[string is integer $vv]} {
            set vvp "\"$kv\": $vv"
        }
        lappend result $vvp
    }
    return "{[join $result ,]}"
}

package provide wantcl::dicts 1.0