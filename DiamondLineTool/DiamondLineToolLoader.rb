require 'sketchup.rb'


load 'DiamondLineTool.rb'
class Setup2dTools
    def activate
 toolbar=UI::Toolbar.new("Diamond Tools")
 	cmd1=UI::Command.new("Diamond Tool"){Sketchup.active_model.select_tool DiamondLineTool.new}
	cmd1.small_icon="DiamondLineTool_small.png"
	cmd1.large_icon="DiamondLineTool.png"
	cmd1.tooltip=("Diamond Tool")
	toolbar.add_item cmd1
	
	toolbar.restore if toolbar.get_last_state==TB_VISIBLE
	
	

   add_separator_to_menu("Draw")
   UI.menu("Draw").add_item("Diamond Line Tool"){ 
	Sketchup.active_model.select_tool DiamondLineTool.new }
    $FreehandPressureTool_menu_loaded = true
end
	
	
end #class
###
### adds Toolbar for 2D Tools...
if not file_loaded?(__FILE__)
  Sketchup.active_model.select_tool(Setup2dTools.new)
end#if
file_loaded(__FILE__)