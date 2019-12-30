#!/usr/bin/env tclsh
# WanTcl - a small library containing functions that I frequently
# use in my Tcl apps
# Copyright (C) Tim K 2018-2019 <timprogrammer@rambler.ru>.
#

package require http
package require tls
package require wantcl::dicts

set wantcl_userAgent "WanTcl/1.0.0 Tcl/[info patchlevel]"

proc dictToCGI {dictionary} {
    set result {}
    dict for {keyv valuev} $dictionary {
        lappend result "$keyv=$valuev"
    }
    return [join $result &]
}

proc httpGet {url arguments} {
    http::register https 443 tls::socket
    global wantcl_userAgent
    http::config -useragent $wantcl_userAgent
    set token [http::geturl "$url?[dictToCGI $arguments]"]
    set ncode [http::ncode $token]
    set data [http::data $token]
    http::unregister https
    http::cleanup $token
    return [dict create code $ncode data $data]
}

proc httpPost {url {formatv cgi} {arguments {}}} {
    http::register https 443 tls::socket
    global wantcl_userAgent
    http::config -useragent $wantcl_userAgent
    set argsPosted [dictToCGI $arguments]
    if {[string tolower $formatv] == {json}} {
        set argsPosted [dictToJSON $arguments]
    } elseif {[string tolower $formatv] == {direct}} {
        set argsPosted $arguments
    }
    set token [http::geturl $url -query $argsPosted]
    set ncode [http::ncode $token]
    set data [http::data $token]
    http::unregister https
    http::cleanup $token
    return [dict create code $ncode data $data]
}

package provide wantcl::http 1.0