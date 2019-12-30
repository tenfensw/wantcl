#!/usr/bin/env tclsh
set directory "$::env(HOME)/Library/Tcl/wantcl"
if {[file isdirectory $directory]} {
	file delete -force $directory
}

file mkdir $directory
foreach fn {wantcl_dict.tcl wantcl_http.tcl wantcl_lists.tcl wantcl_string.tcl pkgIndex.tcl} {
	file copy $fn "$directory/$fn"
}

puts done
exit 0

