require 'sketchup.rb'
require 'rubyextension'
include Pressure

		if RUBY_PLATFORM =~ /mswin32/
			print ("Running on Windows OS")
			#UI.messagebox ("Running on Windows")
		end
		if (RUBY_PLATFORM =~ /darwin/)
			print ("Running on Mac OS.")	
			#UI.messagebox ("Running on Mac OS.")
		end
		if (RUBY_PLATFORM =~ /linux/)
			print ("Running on Linux. No Compatibility")
			#UI.messagebox ("Running on Linux. No Compatibility")
		end
