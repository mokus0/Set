#
#  SetAttributes.rb
#  RubySet
#
#  Created by James Cook on 11/23/07.
#  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
#

class Shape
	def Shape.all
		[Shape.oval, Shape.squiggle, Shape.diamond]
	end
	
	def Shape.oval
		"oval"
	end
	def Shape.squiggle
		"squiggle"
	end
	def Shape.diamond
		"diamond"
	end
end

class Color
	def Color.all
		[Color.red, Color.green, Color.blue]
	end
	
	def Color.red
		"red"
	end
	def Color.green
		"green"
	end
	def Color.blue
		"blue"
	end
end

class Number
	def Number.all
		[Number.one, Number.two, Number.three]
	end
	
	def Number.one
		1
	end
	def Number.two
		2
	end
	def Number.three
		3
	end
end

class Shading
	def Shading.all
		[Shading.open, Shading.shaded, Shading.solid]
	end
	
	def Shading.open
		"open"
	end
	def Shading.shaded
		"shaded"
	end
	def Shading.solid
		"solid"
	end
end