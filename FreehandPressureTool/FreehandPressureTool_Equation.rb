#-----------------------------------------------------------------------------
require 'sketchup.rb'

#-----------------------------------------------------------------------------
class FreehandPressureTool

def db(string)
  dir=File.dirname(__FILE__) ### adjust folder to suit tool
  toolname="FreehandTools"  ### adjust xxx to suit tool...
  locale=Sketchup.get_locale.upcase
  path=dir+"/"+toolname+locale+".lingvo"
  if not File.exist?(path)
     return string
  else
    freehandpressureinfo(string,path)
  end 
end#def

def getExtents
    bbox=Sketchup.active_model.bounds
    bbox.add(@ip.position)if @ip and @ip.valid?
    bbox.add(@ip1.position)if @ip1 and @ip1.valid?
    bbox.add(@ip2.position)if @ip2 and @ip2.valid?
    bbox.add(@ip3.position)if @ip3 and @ip3.valid?
    return bbox
end

def initialize
    @ip1 = nil
    @ip = nil
    @iplast= nil
	@index = nil
	@counter = nil
	@meter_length = 0
end

def activate
    @segment_length= 5.00.inch if not @segment_length
    @cursor=nil
    curpath=File.dirname(__FILE__)+"/Icons/FreehandPressureTool_Cursor.png"
    @cursor=UI::create_cursor(curpath,0,24)if curpath
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
	#prompts = ["Width of the Line?"]
	#	defaults = [1.0]
	#	input = prompts, defaults, "Diamond Freehand Settings"
	#	results = inputbox prompts, defaults
	#	return if not results
	#	@meter_length = results.x
	self.reset(nil)
end

def deactivate(view)
    view.invalidate if @drawn
end

def onSetCursor()
    UI::set_cursor(@cursor)if @cursor
end

def onMouseMove(flags, x, y, view)
        @ip.pick(view,x,y)
        if @ip.valid?
            @ip1.copy!(@ip)
            view.tooltip = @ip1.tooltip
            view.invalidate if @iplast.display? or @ip1.display?
            p1=@ip1.position;p1.z=@z
			if p1 and @points.last and p1.distance(@points.last)>=@segment_length
              @points<<p1
            end
            if @points[2] and @points.last.distance(@points.first)<=@segment_length
              Sketchup::set_status_text((db("Closed Loop")),SB_VCB_VALUE)
            else
              Sketchup::set_status_text(@segment_length.to_s,SB_VCB_VALUE)
            end
            begin
               view.drawing_color = "black"
               view.draw_polyline(@points)
			   @index = @index + 1
			rescue
              ###
            end
            @iplast=@ip1
            @ip1.clear

			if (@counter<@index)
				y = @counter
				#printf ("The Counter is: %s\n", @counter)
				#printf ("@index = %s\n", @index)



				#printf ("@points[@index] = %s\n", @points.at(x))
				#printf ("@points[@index - 2] = %s\n", @points[x - 2])
				final_point2 = @points.fetch(y+2)
				final_point = @points.fetch(y)
				#printf ("final point = %s\n", final_point)
				#printf ("final point - 2 = %s\n", final_point2)


				#printf ("final point = %s\n", final_point)
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

				z_all = final_point.z
				x1 = final_point.x
				y1 = final_point.y
				x2 = final_point2.x
				y2 = final_point2.y
				#printf ("x1 is: %x\n", x1)
				#printf ("y1 is: %x\n", y1)
				denominator = x2 - x1
				numerator = y2 - y1
				perpendicular = - (denominator / numerator)
				slope = numerator / denominator	


				printf ("The slope is: %s\n", slope)
				printf ("The inverse slope is: %s\n", perpendicular)
				midpointX = ((x2 - x1)*0.5) + x1
				midpointY = ((y2 - y1)*0.5) + y1
				p3 = Geom::Point3d.new
				p3.x = midpointX
				p3.y = midpointY
				#printf ("The midpoint is: %s\n", p3)
				d = 10
				a = midpointX
				b = midpointY
				m = perpendicular
				#The values have been set
				quadratic_a = (m**2) - 1
				quadratic_b_middle = -2*((m**2)*(a))
				quadratic_b = quadratic_b_middle - 2*a
				quadratic_c_first = a**2
				quadratic_c_second = (m**2)*(a**2)
				quadratic_c_third = d**2
				quadratic_c = quadratic_c_first + quadratic_c_second - quadratic_c_third
				#All the coefficents for the quadratic formula have been found (ax^2 + bx +c)
				e = ((quadratic_b)**2) - 4*(quadratic_a)*(quadratic_c)
				e_squared = e**0.5
				plus_numerator_to_quadratic = (-quadratic_b) + e_squared
				neg_numerator_to_quadratic = (-quadratic_b) - e_squared
				xplus = plus_numerator_to_quadratic / 2*quadratic_a
				#Quadratic formula has been calculated. In this case, because of the square root actually creating 2 numbers, this calculation was the b + sqrt(e_squared)
				yplus = (m*xplus) - (m*a) + b
				#Plug the value of x back in for the value of y
				if(xplus<0)
				xplus = plus_numerator_to_quadratic / 2*quadratic_a
				yplus = (m*xplus) - (m*a) + b
				else(xplus>0)
				xplus = neg_numerator_to_quadratic / 2*quadratic_a
				yplus = (m*xneg) - (m*a) + b
				end
				#Because we are only using one of the points, that means one is the outlier. Most likely it will be very large, so if thats the case, the formula is changed to subtract e_squared
				p_plus = Geom::Point3d.new
				p_plus.x = xplus
				p_plus.y = yplus
				p_plus.z = z_all
				p_neg = Geom::Point3d.new
				vector = Geom::Vector3d.new
				vector = final_point.vector_to final_point2
				vector1 = Geom::Vector3d.new
				vector1 = p3.vector_to p_plus

				vector1.length = 39.3701

				#meter_length = @meter_length
                # 		
				#meter_length = meter_length.to_l
				#meter_length = meter_length*0.5*39.3701

				#printf ("The maximum length is: %s\n", meter_length)    

				#vector1.length = meter_length



				p_length = Geom::Point3d.new
				x_length = vector1.x
				y_length = vector1.y
				p_length.x = x_length
				p_length.y = y_length
				x_length = x_length + p3.x
				y_length = y_length + p3.y
				p_length.x = x_length
				p_length.y = y_length
				p_plus.x = x_length
				p_plus.y = y_length
				p_plus.z = z_all



				rotation = Geom::Transformation.new(p3, vector, 3.14)
				p_neg = p_plus.transform rotation
				p_neg.z = z_all
				vector_neg = p3.vector_to p_neg

				#printf ("The slope is: %s\n", slope)
				#printf ("The inverse slope is: %s\n", perpendicular)
				#printf ("The midpoint is: %s\n", p3)
				#printf ("The first perpendicular point is: %s\n", p_plus)
				#printf ("The second perpendicular point is: %s\n", p_neg)
				#printf ("The width of the diamond is: %s\n", vector1.length*2.0*0.0254)
				angle = vector.angle_between vector1
				#printf ("The Angle is: %s\n", angle)
				#@vector_array<<vector1
				#@vector_array1<<vector_neg
				#vector_angle1 = @vector_array[y-1]
				#vector_angle2 = @vector_array[y]
				#vector_angle3 = @vector_array1[y-1]
				#vector_angle4 = @vector_array1[y]
				#angle1 = vector_angle3.angle_between vector_angle4
				#angle = vector_angle1.angle_between vector_angle2
				#printf ("The vector angle is: %s\n", angle)
				#printf ("The vector_neg angle is: %s\n", angle1)

				@polygon_plus<<p_plus
				@polygon_neg<<p_neg
				if(slope.abs<0.01)
					@polygon_plus.delete_at(y)
					@polygon_neg.delete_at(y)
					printf ("Delete")
				end
				#if(angle>1.2||angle1>1.2)
				#	@polygon_plus<<p_neg
				#	@polygon_neg<<p_plus
				#end
				@counter = @counter + 1
				#view.model.active_entities.add_line (p_plus,p_neg)
			end
			    view.invalidate
		end#if
	end


def onLButtonDown(flags, x, y, view)
    @ip.pick view, x, y
    if @ip.valid?
      view.tooltip=@ip.tooltip
      p1=@ip.position;p1.z=@z
      @points<<p1
      @iplast=@ip
      view.invalidate

    end
end

def onLButtonUp(flags, x, y, view)



   	#printf ("@points_neg is: %s\n", @polygon_neg)
	#printf ("@points is: %s\n" , @points)
	@polygon_neg_rev = @polygon_neg.reverse
	#printf ("@points_neg_rev is: %s\n", @polygon_neg_rev)
	#printf ("@polygon_plus is: %s\n", @polygon_plus)
	#x = @index
	#final_point_poly = @points.fetch(x)
	#x1 = final_point_poly.x
	#y1 = final_point_poly.y
	#p_polygon_final = Geom::Point3d.new
	#p_polygon_final.x = x1
	#p_polygon_final.y = y1
	#@polygon_plus<<p_polygon_final
	#printf ("@vector_array is: %s\n", @vector_array)
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

def draw(view)
    if @ip.valid?
       view.drawing_color = "white"
       begin
        view.draw_polyline(@points)

       rescue
        ###
       end
    end
    view.invalidate
end

def reset(view)
    ### get/set reference plane 'z'
    @z=Sketchup.active_model.get_attribute("2Dtools","z",nil)
    Sketchup.active_model.set_attribute("2Dtools","z",0.0.mm)if not @z
    @z=Sketchup.active_model.get_attribute("2Dtools","z",nil)
    @zmsg=" [ Z="+@z.to_s+" ] "
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
	@meter_length = 0
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
	  view.model.start_operation(db("Freehand Pressure Tool"))
       view.model.active_entities.add_face(@polygon_Points)
	  view.model.commit_operation
    rescue
      ###
    end#if
end
end


#-----------------------------------------------------------------------------
# shortcut
def freehandtool2D
    Sketchup.active_model.select_tool FreehandTool2D.new
end
######-----------------------------------------------