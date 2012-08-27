require 'sketchup.rb'

load 'FreehandPressureTool.rb'

class Setup2dTools
    def activate
    toolbar=UI::Toolbar.new("Pressure Tools")
		
	cmd3=UI::Command.new("Freehand Pressure Tool"){Sketchup.active_model.select_tool FreehandPressureTool.new}
	cmd3.small_icon="FreehandPressureTool_small.png"
	cmd3.large_icon="FreehandPressureTool.png"
	cmd3.tooltip=("Freehand Pressure Tool")
	toolbar.add_item cmd3
	
	toolbar.restore if toolbar.get_last_state==TB_VISIBLE
	
   add_separator_to_menu("Draw")
   UI.menu("Draw").add_item("Freehand Pressure Tool"){ 
   Sketchup.active_model.select_tool FreehandPressureTool.new }
   $FreehandPressureTool_menu_loaded = true
end
	
end #class
###
### adds Toolbar for 2D Tools...
if not file_loaded?(__FILE__)
  Sketchup.active_model.select_tool(Setup2dTools.new)
end#if
file_loaded(__FILE__)