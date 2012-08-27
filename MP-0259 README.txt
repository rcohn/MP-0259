
THIS IS THE README FOR THE MP-0259 "Mini-Project" dealing with Sketchup, Ruby Plugins and Wintab Functionality. 

There are 6 folders in the MP-0259 Folder
 
*a breakdown of the folder contents*

MP-0259/FreehandPressureTool

	-This folder contains the files:

			FreehandPressureTool.rb (The main rubyscript that contains the plugin)

			FreehandPressureTool.png (The large (24x24) icon for the tool)

			FreehandPressureTool_small.png (The small (16x16) icon for the tool)

			FreehandPressureTool_cursor.png (The cursor icon for the tool, size: 24x24)

			FreehandPressureLoader.rb (The loader for the tool (see "loader explanation" for reasoning on why a loader is necessary)

			FreehandPressureTool_equation.rb (an outdated version of FreehandPressureTool.rb that relies on a BUGGY equation to do calculations vs. the later implemented vector and geometry method)

	-The Freehand Pressure Tool ideally should incorporate pressure sensitivity.

MP-0259/DiamondLineTool

	-This folder contains the files:

			DiamondLineTool.rb (The main rubyscript that contains the plugin)	

			DiamondLineTool.png (The large (24x24) icon for the tool)

			DiamondLineTool_small.png (The small (16x16) icon for the tool)

			DiamondLineToolLoader.rb (The loader for the tool (see "loader explanation" for reasoning on why a loader is necessary)

			DiamondLineTool_cursor.rb (The cursor icon for the tool, size: 24x24)

	-The Diamond Line Tool was a prototype method for the final project, FreehandPressureTool. The geometric sequence it uses is replicated on each OnMouseMove (in the freehandpressuretool.rb) to create the points.
	 It is a essentially "simplified" version of the FreehandPressureTool that just creates the diamond shape and does not store the points in a Array.

MP-0259/OsDetect

	-This folder contains the files:

			OsDetect.rb (A one instance rubyscript that is called when sketchup is opened. It will tell whether the OS is MAC||WINDOWS)

			OsDetect_Run.rb (A evolved version of the OsDetect.rb script. This actually creates a tool, that when clicked will dictate if the OS is on MAC||WINDOWS||LINUX)

			OsDetect_Run.png (The large (24x24) icon for the tool)

			OsDetect_Run_small.png (The small (16x16) icon for the tool)

	-The OsDetect folder contains the files made for the detection of the operating system and the eventual subsequent calls to the Wintab32.dll. In order for a final ruby plugin that incorporates WACOM driver pressure sensitivity, 
	 this code must be used to allow for cross-OS access. 

MP-0259/C Extension for Ruby

	-This folder contains the files:

			extconf.rb (When executed, this creates a makefile)

			Extension_Run_Start.rb (This loads the extension module and file into SketchUp)

			rubyextension.c (The main .c file that contains the extended methods)

			ruby.h (the ruby cross-communication header file)

			MSGPACK.h (Files that are necessary for PressureTest)
			PCKTDEF.h				""
			PRSTEST.h				""			
			resource.h				""
			Utils.c					""		
			Utils.h					""
			WINTAB.h				""

	-The C extension for ruby would, theoretically allow for cross platform tablet communication. Unfortunately Wintab is designated for running in the .exe active window, not as a shared object. 
	 Directions on creating the extension are listed under "C extension creation"

MP-0259/SketchUp Example Files

	-This folder contains the files:

			Diamond Test (shows an example of what the DiamondLineTool can accomplish)

			Freehand Test (shows an example of what the FreehandPressureTool can accomplish)

			Freehand Test2 (Same as prior file, but uses the Geom Module)

			Multiple Parameters Test (Shows succesful Z-Axis integration and interaction with other 3d objects)

			Quadratic Glitch (Shows the initial reasoning for switching to a geometric style conversion system)

			Z-Axis Test (Test Z-Axis compatbility)

	-These are SketchUp example files that show the integration of the plugin into SketchUp.

	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

______________________________________________________________________

LOADING THE PLUGINS INTO SKETCHUP

SketchUp Parameters
	-All plugins were developed on the latest version of SketchUp circa July 2012. They are compatible with SketchUp 8.0 and up.
	-The SketchUp interface should be set in METERS. The plugins were developed in meters and do not have multi-unit functionality (easily put in though)
	-The user should have a WACOM tablet to register the "feel" of the plugins, but it is not necessary for functionality. 

Operating System Parameters
	-Currently the plugins run on Mac and Windows. Linux SketchUp compatibility is a risky, the user must download a windows simulator. None of the plugins have been tested on Linux.

How to load the plugins
	1. Locate the plugin folder on the C drive. 
		-Windows: C:\Program Files (x86)\Google\Google SketchUp\Plugins\*
		-Mac: Macintosh HD/Library/Application Support/Google Sketchup 8/SketchUp/Plugins/*
	2. Find the folder of the plugin you wish to install.
	3. Copy the contents of that folder (all of them, including icons and loaders) into the * destinations above. 
	4. It should look like this

	C:\Program Files (x86)\Goog\Google Sket\Plugins\FreehandPressureTool.rb
										 \FreehandPressureLoader.rb	
										 
	5. Execute SketchUp
	6. To see the toolbars, go to View\Toolbars\Pressure Tools || Diamond Tools || OS Tools
		- There are secondary activation methods in Draw\Freehand Pressure Tool and Draw\Diamond Line Tool and Windows\Operating System Detect

_____________________________________________________________________________

WHY A LOADER IS NECESSARY

	- If a toolbar with multiple tool on it is desirable, then a loader is needed. There should be prexisting code at the bottom of each plugin .rb file that allows for loader independecy. Right now it is commmented out. 
	  
________________________________________________________________________________

SETTING UP A DEVELOPER ENVIROMENT

  1. Install Ruby (1.8.6) with the one click installer (located on the MP-0259 folder or online)
  2. If ruby development with visual studios is desired, then the RubyInSteel software is helpful.
			-It gives colors and recognition to the ruby syntax in VS2010
			
			http://www.sapphiresteel.com/spip?page=download (Download RubyInSteel^2 (not the all-in-one installer))

			Ruby must be installed prior to this because it requires a interpreter

			It is a free 60 day trial
  3. Install SketchUp
  4. Alter the config.h file in ruby (explained below)
  5. The Google SketchUp API is extremely useful.
   
__________________________________________________________________________________

HOW TO CREATE THE MAKEFILE AND EXTENSION

	1. Download the Ruby one-click installer. It needs to be 1.8.6. (There should be a .exe included in the MP-0259 folder)
	2. Once the installation is complete, open up the config.h file in the Ruby folder off the C drive
	
		C:\Ruby\lib\ruby\1.8\i386-mswin32\* 
		
		Find the config.h file in this folder and then comment out these lines. (They should be at the top)
		
		
										//#if _MSC


										//_VER != 1200
										//#error MSC version unmatch
										//#endiine USE_WINSOCK2 1		


	3. Now that ruby is configured, open up the visual studio command prompt. The .c source file (and subsequent header files) must be in the same folder with the 
	   extconf.rb ruby file.
	4. Navigate to the folder with the "cd" key (C:\MP-0259\C Extension for Ruby\*)
	5. Type "ruby extconf.rb" in place of the asterisk placed above
	6. The command prompt should return "creating makefile"
	7. Then type "nmake" and return
	8. It creates the necessary libraries and .obj files for the conversion
	9. Copy all the .obj, .lib, .so (and the makefile) files to the SketchUp Plugins folder
	10. Copy Extension_Run_Start.rb to the plugin folder also to load the module and connect the extension with SketchUp
	
			*quick overview of the theory of Extension_Run_Start*

					require 'sketchup.rb'
					require 'rubyextension'----------> This requires the .so makefile
					include Pressure-------------->This loads the module and the subsequent methods
					                                                                           ___
							if RUBY_PLATFORM =~ /mswin32/                                         |
								print ("Running on Windows OS")                                   |  
								#UI.messagebox ("Running on Windows")                             |    
							end																      |
							if (RUBY_PLATFORM =~ /darwin/)										  |]   This is copied from the OsDetect_Run.rb file.
 								print ("Running on Mac OS.")	                                  |]]- It detects the OS and then (could) send a message displaying it.
								#UI.messagebox ("Running on Mac OS.")                             |]   In the future it would be needed to load what type of extension (MAC||WINDOWS)
							end                                                                   |
							if (RUBY_PLATFORM =~ /linux/)                                         |  
							 	print ("Running on Linux. No Compatibility")                      |
								#UI.messagebox ("Running on Linux. No Compatibility")             |
							end                                                                ___|
	11. Activate SketchUp
	12. Go to windows/ruby console
	13. type in pressureshow (or whatever keywords you have declared in the .c file for the ruby methods)

						VALUE Pressure = Qnil;  ---->Module definition
						void Init_rubyextension(); ----->Init definition
						VALUE method_pressure(VALUE self); ----->method definition 
						void Init_rubyextension() {
							Pressure = rb_define_module("Pressure"); ---->connecting the module to ruby
							rb_define_method(Pressure, "pressureshow", method_pressure, 0); ---->connecting the method to ruby

	14. It will execute the method and return a VALUE (ruby can only return values)
	
	
	*CODE NEEDED FOR THE .C EXTENSION FROM RUBY

		-the file ruby.h must be included in the same directory and the project (#include "ruby.h")
		-once the ruby.h file is included however, there will be build errors because the syntax is consistent with ruby and C, so VS2010 draws errors
		-an example of a basic extension is shown below
		-keep in mind that extconf.rb looks for Init_'word'
		 in this case it looks for rubyextension. There have also been glitches if it needs to look for a uppercase Init_''
	
				#include "ruby.h"
				#include <windows.h>
				#include <math.h>
				#include <string.h>
				#include <stdio.h>


				VALUE Pressure = Qnil;

				void Init_rubyextension();

				VALUE method_pressure(VALUE self);

				VALUE method_pressure2(VALUE self);
				
				void Init_rubyextension()
					{
						Pressure = rb_define_module("Pressure");

						rb_define_method(Pressure, "pressureshow", method_pressure, 0);
						rb_define_method(Pressure, "pressureshow2", method_pressure2, 0);
					}

				VALUE method_pressure(VALUE self) 
					{
						int x = 10;
						return INT2NUM(x);
					}

				VALUE method_pressure2(VALUE self)
					{
						int y = 15;
						return INT2NUM(y);
					}

		
		If this was loaded into SketchUp and the in the ruby console, the user typed "pressureshow" it should return 10. If pressureshow2 is typed, 15 should be returned.

		As of now, the extension in the 'C Extension for Ruby' folder has 3 methods and when typed in order return false, false and then a garbage number

	15. SIDENOTE: Any ruby plugin can also call the functions without needing the loading code on each header. For example, a seperate ruby plugin could be made that 
		shows a messagebox when clicked.
			
			def activate
				UI.messagebox (*)

	16. If we put 'pressureshow' it will return that value. This is key to allowing ruby to pull the pressure data.

	______________________________________________________________________________________________________________________________________