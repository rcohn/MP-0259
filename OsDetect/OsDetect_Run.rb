# This ruby plugin was developed to test the detection of MAC||WINDOWS||LINUX operating systems for specific Wintab functions/calls. 
# When placed in the C:\Program Files (x86)\Google\Google Sketchup\Plugins\* and a instance of sketchup is launched, a tool will appear that when clicked, reveals the current OS the machine is running.
# The code should ideally be incorporated with another tool that has to call OS specific functions
#
#	AUTHORS
#         Andrew Peterson 7/15/2012
#	NAME
#		OsDetect_Run.rb
#
#




require 'sketchup.rb'


class OsDetect
	def activate
		if RUBY_PLATFORM =~ /mswin32/
			print ("Running on Windows OS.")
			UI.messagebox ("Running on Windows XP/Vista/7")
		end
		if (RUBY_PLATFORM =~ /darwin/)
			print ("Running on Mac OS.")	
			UI.messagebox ("Running on Mac OS.")
		end
		if (RUBY_PLATFORM =~ /linux/)
			print ("Running on Linux. No Compatibility")
			UI.messagebox ("Running on Linux. No Compatibility")
		end

	end
end

if( not $OsDetect_menu_loaded )
   
		toolbar=UI::Toolbar.new("Operating System Tools")
 		cmd1=UI::Command.new("Os Detect"){Sketchup.active_model.select_tool OsDetect.new}
		cmd1.small_icon="OsDetect_Run_Small.png"
		cmd1.large_icon="OsDetect_Run.png"
		cmd1.tooltip=("OsDetect Tool")
		toolbar.add_item cmd1
	
		toolbar.restore if toolbar.get_last_state==TB_VISIBLE
	
  
	add_separator_to_menu("Window")
		UI.menu("Window").add_item("Operating System Detect"){ 
		Sketchup.active_model.select_tool OsDetect.new }
		$OsDetect_menu_loaded = true
end
