#		NAME
#
#				FreehandPressureTool.rb
#
#		PURPOSE
#				This is the .rb(ruby) file that needs to be placed into the plugins folder in C:\Program Files(x86)\Google\Google Sketchup\Plugins\
#				At the current date (8/22/2012) the pressure sensitivity is inactive due to the lack of wintab compatibility outside of the SketchUp window. 
#
#		
#		AUTHORS
#				Andrew Peterson 6/20/2012
#				Dave Fleck 6/20/2012
#


require 'sketchup.rb'

#-----------------------------------------------------------------------------
class FreehandPressureTool
def getExtents
    bbox=Sketchup.active_model.bounds
    bbox.add(@ip.position)if @ip and @ip.valid?
    bbox.add(@ip1.position)if @ip1 and @ip1.valid?
    bbox.add(@ip2.position)if @ip2 and @ip2.valid?
    bbox.add(@ip3.position)if @ip3 and @ip3.valid?
    return bbox
end
def initialize
    #creates the arrays
	@ip1 = nil
    @ip = nil
    @iplast= nil
	@index = nil
	@array = ["1.0", "2.0", "Pressure"]
	@counter = nil
end
def activate
	 #locates the cursor image
	 @cursor = nil
	 cursor_path = Sketchup.find_support_file("FreehandPressureTool_cursor.png", "Plugins/")
	 if cursor_path
		 #at default, the cursor draws in the top left corner, but it is shifted down 24 pixels so that it draws on the tip of the WACOM stylus cursor
		 @cursor = UI.create_cursor(cursor_path, 0, 24)
	 end
	#activates all the arrays
	@segment_length= 1.00.inch if not @segment_length
    @ip1 = Sketchup::InputPoint.new
    @ip = Sketchup::InputPoint.new
    @iplast= Sketchup::InputPoint.new
    @points=[]
	@polygon_points=[]
	@polygon_plus=[]
	@polygon_plus1=[]	
	@polygon_neg=[]
	@vector_array=[]
	@vector_array1=[]
	@meter_length_reset = 0
	@meter_length1 = 0
	@meter_lenght2 = 0


	self.inputbox #calls the inputbox when the tool is activated
	self.reset(nil)		
end
def inputbox
	#These are the 3 lines
	prompts = ["Main Line Width", "Shift Line Width", "Options"]
	#this calls the data from @array for the inputbox numbers. By saving it to an array, the data can be changed and called in the middle of the plugin's usage
	defaults = [@array[0], @array[1], @array[2]]
	list = ["", "", "Pressure|Set"]
	results = UI.inputbox prompts, defaults, list, "Freehand Pressure Tool"
	@array = results
	#converts the length to meters 
	meter_length1 = results[0]
	meter_length1 = meter_length1.to_l
	meter_length1 = meter_length1*0.5
	@meter_length1 = meter_length1
	@meter_length_reset = meter_length1
	#converts the second input line to meters also
	meter_length2 = results[1]
	meter_length2 = meter_length2.to_l
	meter_length2 = meter_length2*0.5
	@meter_length2 = meter_length2

	end
def deactivate(view)
    view.invalidate if @drawn
end
def onSetCursor()
    UI::set_cursor(@cursor)if @cursor
end
def onKeyDown(key, rpt, flags, view)
	#If shift is held when drawing, it switches to the second line
	if key==VK_SHIFT && rpt = 1
		@meter_length1 = @meter_length2
	end
	#if home is pressed, it brings up the current instance of the inputbox
	if key==VK_HOME && rpt = 1
		self.inputbox
	end
end
def onKeyUp (key, rpt, flags, view)
	#when the shift key is lifted, it resets to the first length
	if key==VK_SHIFT && rpt = 2
		meter_length1 = @array[0]
		meter_length1 = meter_length1.to_l
		meter_length1 = meter_length1*0.5
		@meter_length1 = meter_length1
	end
end
def onMouseMove(flags, x, y, view)
	#@points is the array that the actual raw data points are stored for the line that the mouse is tangent to
	  @ip.pick(view,x,y)
        if @ip.valid?
            @ip1.copy!(@ip)
            view.tooltip = @ip1.tooltip
            view.invalidate if @iplast.display? or @ip1.display?
            p1=@ip1.position
			if p1 and @points.last and p1.distance(@points.last)>=@segment_length
              @points<<p1
            end
            if @points[2] and @points.last.distance(@points.first)<=@segment_length
              Sketchup::set_status_text("Closed Loop")
            else
              Sketchup::set_status_text(@segment_length.to_s,SB_VCB_VALUE)
            end
            begin
               view.drawing_color = "black"
               view.draw_polyline(@points)
			   #@index allows for a counter to then calculate the points off
			   @index = @index + 1
			rescue
              ###
            end
            @iplast=@ip1
            @ip1.clear

			#Calculates the points
            #@counter should always be less than @index because it starts after the first point
			if (@counter<@index)
				y = @counter
				#counter allows us to call the current point and the point 2 ahead for the calculations
				final_point2 = @points.fetch(y+2)
				final_point = @points.fetch(y)
				p_plus = Geom::Point3d.new
				#sets the xy values of the points equal to integers
				z_all = final_point.z
				x1 = final_point.x
				y1 = final_point.y
				x2 = final_point2.x
				y2 = final_point2.y
				#calculates the midpoint between the 2 points
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
				p_plus = final_point2.transform z_rotation
				#makes a vector from the midpoint to the first perpendicular point
				vector1 = Geom::Vector3d.new
				vector1 = p3.vector_to p_plus
				###IMPORTANT###This is where the length is set (eventually to be replaced with pressure data) right now, it is recieving the values from the inputbox at a set width
				vector1.length = @meter_length1
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
				#creates a vector between the first 2 points
				vector = Geom::Vector3d.new
				vector = final_point.vector_to final_point2
				#rotates the point p_plus around the original line 180 degrees
				p_neg = Geom::Point3d.new
				rotation = Geom::Transformation.new(p3, vector, 3.14)
				p_neg = p_plus.transform rotation
				p_neg.z = z_all
				vector_neg = p3.vector_to p_neg
				#Saves the final points to their specific arrays
				@polygon_plus<<p_plus
				@polygon_neg<<p_neg
				#counter increments
				@counter = @counter + 1
				#if this line is uncommented, it will show the lines being calculated. Good for visuals but it will affect the tool because they are rendered real time
				view.models.active_entities.add_cline (p_plus, p_neg)
		end
			view.invalidate
		end#if
	end
def onLButtonDown(flags, x, y, view)
    @ip.pick view, x, y
    if @ip.valid?
        view.tooltip=@ip.tooltip
        p1=@ip.position
        @points<<p1
        @iplast=@ip
        view.invalidate
	end
end
def onLButtonUp(flags, x, y, view)
	#because the add_face entity must fill in linear order, we have to reverse the second array and add it.

	@polygon_neg_rev = @polygon_neg.reverse

	#we want the shape to retain the first and last points, from the @points array

	x = @index
	p_first = @points.first
	p_last = @points.last
	@polygon_plus<<p_last
	@polygon_plus1<<p_first
	@polygon_plus1 = @polygon_plus1 + @polygon_plus
	@polygon_Points = @polygon_plus1 + @polygon_neg_rev

	self.create_geometry(@points,view)### end this loop
    self.reset(view) ### start another
end
def resume(view)
  view.invalidate
end
def draw(view)
    if @ip.valid?

		#This sets the color of the temporary line. A link to the page with the strings for the line color is here.
		#https://developers.google.com/sketchup/docs/ourdoc/color#
      
        begin
			#draws the temporary line
			#NOTE|||| If 'polyline' is replaced with 'line' the temporary lines that are drawn are perforated. Might be desirable.
			view.drawing_color = "MidnightBlue"
			view.draw_polyline(@polygon_plus)
			view.draw_polyline(@polygon_neg)
			view.drawing_color = "White"
			#if this code is uncommented, it displays the line that the user is actually drawing
			#view.draw_polyline(@points)
       rescue
      end
    end
    view.invalidate
end
def onCancel(flag, view)
    self.reset(view)
end
def reset(view)
    #resets the variables
    @ip1.clear
    @ip.clear
    @iplast.clear
    @points=[]
	@counter = 0
	@index = 0
	@polygon_plus=[]
	@polygon_neg=[]
	@polygon_Points=[]
	@polygon_neg_rev=[]
	@polygon_plus1=[]
	@meter_length_reset = 0
	@vector_array=[]
	@vector_array1=[]
    if view
        view.tooltip = nil
        view.invalidate
    end

end
def create_geometry(points, view)
    points<<@points.first if points[2] and points.last.distance(points.first)<=@segment_length
	begin
		#creates the shape
	  view.model.start_operation("Freehand Pressure Tool")
		view.model.active_entities.add_face(@polygon_Points)
	  view.model.commit_operation
    rescue
   
    end#if
end
end


	#toolbar=UI::Toolbar.new("Pressure Tools")

	#cmd3=UI::Command.new("Freehand Pressure Tool"){Sketchup.active_model.select_tool FreehandPressureTool.new}
	#cmd3.small_icon="FreehandPressureTool_small.png"
	#cmd3.large_icon="FreehandPressureTool.png"
	#cmd3.tooltip=("Freehand Pressure Tool")
	#toolbar.add_item cmd3

	#toolbar.restore if toolbar.get_last_state==TB_VISIBLE



   #add_separator_to_menu("Draw")
   #UI.menu("Draw").add_item("Freehand Pressure Tool"){ 
   #Sketchup.active_model.select_tool FreehandPressureTool.new }
   #$FreehandPressureTool_menu_loaded = true
