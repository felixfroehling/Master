##
## RunScripts.tcl 
## CarMaker 9.0 ScriptControl Example - IPG Automotive GmbH (www.ipg-automotive.com)
##
## $Id: RunScripts.tcl,v 1.6 2020/05/07 15:36:55 kh Exp $


# A script can specified with a path relative to current script
RunScript StartStop.tcl
RunScript WaitForCondition.tcl
RunScript Math.tcl

# Absolute paths can also be used, but should be avoided.
# Example:
# RunScript /home/hil/Scripts/StartStop.tcl


