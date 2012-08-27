# The Diamond Line Tool is a tool for SketchUp 8.0 and later.
# It is the prototype for the Freehand Pressure Tool developed at Wacom Corp.
# This tool was developed cerca 8/8/2012
# Created by Andrew Peterson and Dave Fleck

require 'sketchup.rb'


class DiamondLineTool
def initialize
    @ip1 = nil
    @ip2 = nil
    @xdown = 0
    @ydown = 0
	
end
def activate
    # The Sketchup::InputPoint class is used to get 3D points from screen
    # positions.  It uses the SketchUp inferencing code.
    # In this tool, we will have two points for the endpoints of the line.
    @ip1 = Sketchup::InputPoint.new
    @ip2 = Sketchup::InputPoint.new
    @ip = Sketchup::InputPoint.new
    @drawn = false

    # This sets the label for the VCB
    Sketchup::set_status_text $exStrings.GetString("Length"), SB_VCB_LABEL
	 @cursor = nil
	 cursor_path = Sketchup.find_support_file("DiamondLineTool_cursor.png", "Plugins/")
	 if cursor_path
		 @cursor = UI.create_cursor(cursor_path, 5, 24)
	 end
	
	
	
	self.reset(nil)
end
def deactivate(view)
    view.invalidate if @drawn
end
def onSetCursor()
    UI::set_cursor(@cursor)if @cursor
end
def onMouseMove(flags, x, y, view)
    if( @state == 0 )
        # We are getting the first end of the line.  Call the pick method
        # on the InputPoint to get a 3D position from the 2D screen position
        # that is based as an argument to this method.
        @ip.pick view, x, y
        if( @ip != @ip1 )
            # if the point has changed from the last one we got, then
            # see if we need to display the point.  We need to display it
            # if it has a display representation or if the previous point
            # was displayed.  The invalidate method on the view is used
            # to tell the view that something has changed so that you need
            # to refresh the view.
            view.invalidate if( @ip.display? or @ip1.display? )
            @ip1.copy! @ip
            
            # set the tooltip that should be displayed to this point
            view.tooltip = @ip1.tooltip
        end
    else
        # Getting the second end of the line
        # If you pass in another InputPoint on the pick method of InputPoint
        # it uses that second point to do additional inferencing such as
        # parallel to an axis.
        @ip2.pick view, x, y, @ip1
        view.tooltip = @ip2.tooltip if( @ip2.valid? )
        view.invalidate
	       
        # Update the length displayed in the VCB
        if( @ip2.valid? )
            length = @ip1.position.distance(@ip2.position)
            Sketchup::set_status_text length.to_s, SB_VCB_VALUE
        end
        
        # Check to see if the mouse was moved far enough to create a line.
        # This is used so that you can create a line by either draggin
        # or doing click-move-click
        if( (x-@xdown).abs > 10 || (y-@ydown).abs > 10 )
            @dragging = true
        end
    end
end
def onLButtonDown(flags, x, y, view)
    # When the user clicks the first time, we switch to getting the
    # second point.  When they click a second time we create the line
    if( @state == 0 )
        @ip1.pick view, x, y
        if( @ip1.valid? )
            @state = 1
            Sketchup::set_status_text $exStrings.GetString("Select second end"), SB_PROMPT
            @xdown = x
            @ydown = y
        end
    else
        # create the line on the second click
        if( @ip2.valid? )
            self.create_geometry(@ip1.position, @ip2.position,view)
            self.reset(view)
        end
    end
    
    # Clear any inference lock
    view.lock_inference
end
def onLButtonUp(flags, x, y, view)
    # If we are doing a drag, then create the line on the mouse up event
    if( @dragging && @ip2.valid? )
        self.create_geometry(@ip1.position, @ip2.position,view)
        self.reset(view)
    end
end
def draw(view)
   @drawn = false
    
    # Show the current input point
    if( @ip.valid? && @ip.display? )
        @ip.draw(view)
        @drawn = true
		view.set_color_from_line(@ip, @ip2)
		end
	if( @ip2.valid? )
		@ip2.draw(view) if( @ip2.display? )
		
		# The set_color_from_line method determines what color
        # to use to draw a line based on its direction.  For example
        # red, green or blue.
    if view.inference_locked?
        line_width = 2
        else
        line_width = 1
        end
	view.drawing_color = "MidnightBlue"	
	view.line_width = line_width
	self.draw_geometry(@ip1.position, @ip2.position, view)
		@drawn = true
    end
end
def onCancel(flag, view)
    self.reset(view)
end
def reset(view)
    # This variable keeps track of which point we are currently getting
    @state = 0
    
    # Display a prompt on the status bar
    Sketchup::set_status_text($exStrings.GetString("Select first end"), SB_PROMPT)
    
    # clear the InputPoints
    @ip1.clear
    @ip2.clear
    
    if( view )
        view.tooltip = nil
        view.invalidate if @drawn
    end
    
    @drawn = false
    @dragging = false
end
def create_geometry(p1, p2, view)
   	###EQUATION TIME###
	# a = midpointX = X value of midpoint
	# b = midpointY = Y value of midpoint
	# d = distance of the segment
	# x = the final x value for the segment
	# y = the final y value for the segment
	# m = inverted slope (perpendicular)
	
	###FORMAL EQUATIONS###
	#d = sqrt(((y-b)**2)+((x-a)**2))
	#m = (y-b)/(x-a)
	#y = (mx-ma)+b
	
	
	###UNCOMMENT###
	#a = midpointX
	#b = midpointY
	#d = 12
	#m = perpendicular
	#x = nil
	#y = nil
	
	
	
	
	
	
	
	x1 = 0
	y1 = 0
	x2 = 0
	y2 = 0
	denominator = 0
	numerator = 0
	perpendicular = 0
	slope = 0
	midpointX = 0
	midpointY = 0
	d = 0
	a = 0
	b = 0
	m = 0
	z = 0
	vecline = 0
	xplus = 0
	yplus = 0
	xneg = 0
	yneg = 0
	
	z_all = p1.z
	x1 = p1.x
	y1 = p1.y
	x2 = p2.x
	y2 = p2.y
	midpointX = ((x2 - x1)*0.5) + x1
				midpointY = ((y2 - y1)*0.5) + y1
				#creates the midpoint
				p3 = Geom::Point3d.new
				p3.x = midpointX
				p3.y = midpointY
				p3.z = z_all
				#clones the midpoint, but gives the point z-axis height in order to form a vector for rotation
				p_z = Geom::Point3d.new
				p_z.x = p3.x
				p_z.y = p3.y
				p_z.z = 10
				#makes a vector to the point p_z from the midpoint
				vector_z = p3.vector_to p_z
				#creates and applies the transformation.rotation object
				z_rotation = Geom::Transformation.rotation p3, vector_z, 1.57
				p_plus = p2.transform z_rotation
				#makes a vector from the midpoint to the first perpendicular point
				vector1 = Geom::Vector3d.new
				vector1 = p3.vector_to p_plus
				
				
				meter_length = 0
				prompts = ["Width of the Diamond?"]
				defaults = [1.0]
				input = prompts, defaults, "Diamond LineTool Settings"
				results = inputbox prompts, defaults
	
				return if not results
				meter_length = results.x
				
				meter_length = meter_length.to_l
				meter_length = meter_length*0.5*39.3701
		
				printf ("The maximum length is: %s\n", meter_length)    
				
				vector1.length = meter_length
	
				###IMPORTANT###This is where the length is set (eventually to be replaced with pressure data) right now, it is recieving the values from the inputbox at a set width		
				
				#Retrieves the endpoint of the new vector 
				p_length = Geom::Point3d.new
				x_length = vector1.x
				y_length = vector1.y
				p_length.x = x_length
				p_length.y = y_length
				x_length = x_length + p3.x
				y_length = y_length + p3.y
				p_length.x = x_length
				p_length.y = y_length
				#resets p_plus to the new length
				p_plus.x = x_length
				p_plus.y = y_length
				p_plus.z = z_all
				
				#creats a vector between the first 2 points
				vector = Geom::Vector3d.new
				vector = p1.vector_to p2
				#rotates the point p_plus around the original line 180 degrees
				p_neg = Geom::Point3d.new
				rotation = Geom::Transformation.new(p3, vector, 3.14)
				p_neg = p_plus.transform rotation
				p_neg.z = z_all
				vector_neg = p3.vector_to p_neg
	
	
	
	printf ("The slope is: %s\n", slope)
	printf ("The inverse slope is: %s\n", perpendicular)
	printf ("The midpoint is: %s\n", p3)
	printf ("The first perpendicular point is: %s\n", p_plus)
	printf ("The second perpendicular point is: %s\n", p_neg)
	printf ("The width of the diamond is: %s\n", vector1.length*2.0*0.025)
	
	view.model.entities.add_face (p1,p_plus,p2,p_neg)
end
def draw_geometry(pt1, pt2, view)
    view.draw_line(pt1, pt2)
end
end # class DiamondLineTool
def DiamondLineTool
    Sketchup.active_model.select_tool DiamondLineTool.new
end
#if( not $DiamondLineTool_menu_loaded )
# toolbar=UI::Toolbar.new("Diamond Tools")
# 	cmd3=UI::Command.new("Diamond Tool"){Sketchup.active_model.select_tool DiamondLineTool.new}
#	cmd3.small_icon="DiamondLineTool_Small.png"
#	cmd3.large_icon="DiamondLineTool.png"
#	cmd3.tooltip=("Diamond Tool")
#	toolbar.add_item cmd3
#	
#	toolbar.restore if toolbar.get_last_state==TB_VISIBLE
#	
#
#
#  add_separator_to_menu("Draw")
#   UI.menu("Draw").add_item("Diamond Line Tool"){ 
#	Sketchup.active_model.select_tool FreehandPressureTool.new }
#    $FreehandPressureTool_menu_loaded = true
#end