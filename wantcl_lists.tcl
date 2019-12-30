#!/usr/bin/env tclsh
# WanTcl - a small library containing functions that I frequently
# use in my Tcl apps
# Copyright (C) Tim K 2018-2019 <timprogrammer@rambler.ru>.
#

proc lhas {listing args} {
    foreach potential $args {
        foreach itm $listing {
            if {$itm == $potential} {
                return 1
            }
        }
    }
    return 0
}

proc lfilter {listing filteringMethod} {
    set result {}
    foreach itm $listing {
        if {[$filteringMethod $itm]} {
            lappend result $itm
        }
    }
    return $result
}

proc ldict {listing action args} {
    set result {}
    foreach itm $listing {
        if {[expr {[llength $itm] % 2}] == 0} {
            lappend result [dict $action $itm {*}$args]
        }
    }
    return $result
}

proc rsplit {str sep} {
    set insideQuotes 0
    set preparation 0
    set substr {}
    set result {}
    for {set index 0} {$index < [string length $str]} {incr index} {
        set character [string index $str $index]
        if {$character == "'" || $character == "\""} {
            if {$preparation} {
                set substr "$substr$character"
            } else {
                incr insideQuotes
                lappend result $substr
                set substr {}
            }
        } elseif {$character == "\{" || $character == "\}"} {
            if {$character == "\}"} {
                set substr "$substr$character"
            }
            incr insideQuotes
            lappend result $substr
            set substr {}
            if {$character == "\{"} {
                set substr "$substr$character"
            }
        } elseif {$character == "\\"} {
            if {$preparation} {
                set substr "$substr$character"
                set preparation 0
            } else {
                set preparation 1
            }
        } elseif {$character == $sep && [expr {$insideQuotes % 2}] == 0 && ! $preparation} {
            incr insideQuotes
            lappend result $substr
            set substr {}
        } else {
            set substr "$substr$character"
        }
        if {$preparation} {
            set preparation 0
        }
    }
    if {[string length $substr] >= 1} {
        lappend result $substr
    }
    return $result
}

package provide wantcl::lists 1.0