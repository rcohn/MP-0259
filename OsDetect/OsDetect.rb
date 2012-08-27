# This ruby plugin was developed to test the detection of MAC||WINDOWS operating systems for specific Wintab functions/calls. 
# When placed in the C:\Program Files (x86)\Google\Google Sketchup\Plugins\* and a instance of sketchup is launched, a messagebox will appear that reveals the current OS the machine is running.
# The code should ideally be incorporated with another tool that has to call OS specific functions
#
#	AUTHORS
#         Andrew Peterson 7/10/2012
#		
# /////NOTE\\\\\\
# OsDetect.rb lacks linux recognition and is only called once on the activation of sketchup. There is a upgraded version called OsDetec_Run.rb 
# This has more compatibility and is in the form of a tool.
#
#

require 'sketchup.rb'


class OsDetect
	if RUBY_PLATFORM =~ /mswin32/
		UI.messagebox ("Running on Windows OS.")
	else
		UI.messagebox ("Running on Mac OS")	
	end
	if RUBY_PLATFORM =~ /darwin/
		UI.messagebox ("Running on Mac OS")
	else
		UI.messagebox ("Running on Windows OS")
	end
end
