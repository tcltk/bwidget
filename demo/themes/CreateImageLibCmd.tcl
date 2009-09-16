#!/usr/bin/ksh
# the next line restarts using wish \
exec wish "$0" "$@"


# CreateImageLibCmd.tcl ---
# -------------------------------------------------------------------------
# Purpose:
#   A utility script to create base64 multimedia encoded gif's
#   from a given image directory.
#
# Copyright(c) 2009,  Johann Oberdorfer
#                     mail-to: johann.oberdorfer@googlemail.com
# -------------------------------------------------------------------------
# This source file is distributed under the BSD license.
# -------------------------------------------------------------------------


# where to find tcllib:
lappend auto_path [file join $::env(HOME) "t/lib1"]
  package require base64


namespace eval ::CreateImageLib:: {
  variable defaults
  
  array set defaults {
    pattern       "*.gif"
    imageDir       "images"
    imageLib       "ImageLib.tcl"
    dclsFile       "CreateImageLib.def"
    imageArrayName "images"
  }
}


proc ::CreateImageLib::ReadDeclaredImageNames { fname } {
  set imagename_dcls [list]

  if { ![file exists $fname] } { return $imagename_dcls }

  set fp [open $fname "r"]

  while { ![eof $fp] } {
    if { [string length [set row [string trim [gets $fp]]]] } {
      lappend imagename_dcls $row
    }
  }

  close $fp
  return $imagename_dcls
}


proc ::CreateImageLib::ConvertFile { fileName } {

  set fp [open $fileName "r"]
  fconfigure $fp -translation binary

  set data [read $fp [file size $fileName]]
  close $fp

  return [base64::encode $data]
}


proc ::CreateImageLib::CreateImageLib {dir} {
  variable defaults

  set cdir [pwd]
  cd $dir

  # verify if there is a declaration file available
  # which triggers the image lib creation... 

  if { ![file exists $defaults(dclsFile)] ||
       ![llength [set imagename_dcls \
                     [ReadDeclaredImageNames $defaults(dclsFile)]]] ||
       ![file isdirectory $defaults(imageDir)] ||
       ![llength [set fileList \
                    [glob -nocomplain \
                          [file join $defaults(imageDir) \
				     $defaults(pattern)]]]] } {
      cd $cdir
      return
  }

  # puts "Creating file: [file join $dir $defaults(imageLib)] ..."

  set fp [open $defaults(imageLib) "w"]
  puts $fp "# [file tail $defaults(imageLib)] ---"
  puts $fp "# Automatically created by: [file tail [info script]]\n"

  set cnt     0
  set created 0
  set skipped 0
  
  foreach fname $fileList {

      set keystr [file tail [file rootname $fname]]

      if { [file isfile $fname] &&
               [lsearch -regexp $imagename_dcls $keystr] != -1} {

          # assemble array name:
          set imageName $defaults(imageArrayName)
          append imageName "("
          append imageName [file rootname [file tail $fname]]
          append imageName ")"

          set imageData [ConvertFile $fname]

          puts $fp "set $imageName \[image create photo -data \{"
          puts $fp "$imageData\n\}\]"
          incr created
      } else {
          incr skipped
      }

      incr cnt
  }

  close $fp

  puts \
"
  [info script] summary:
  
      Image Library created ... [file join $dir $defaults(imageLib)]
      Images processed ........ $cnt
      Created images .......... $created
      Skipped ................. $skipped
"

  flush stdout
  cd $cdir
}


proc ::CreateImageLib::ProcessDir {dir} {
  variable defaults

  set cdir [pwd]
  cd $dir

  foreach fp [glob -nocomplain [file join $dir "*"]] {
    if { [file isdirectory $fp] &&
         [string compare -nocase [file tail $fp] "CVS"] != 0 &&
	 [string compare [file tail $fp] $defaults(imageDir)] != 0 } {
	
	# process current dir and continue proceccing afterwards...
        # puts "--> $fp"

	CreateImageLib $fp
        ProcessDir $fp
    }
  }

  flush stdout
  cd $cdir
}


proc ::CreateImageLib::RunCreate {} {

  # retrieve all sub'directories starting from:
  set dir [pwd]
  ProcessDir $dir
  cd $dir
}


# here we go ...
::CreateImageLib::RunCreate
exit 0
