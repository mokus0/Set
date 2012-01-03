#
#  SetCard.rb
#  RubySet
#
#  Created by James Cook on 11/23/07.
#  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
#

class SetCard
	def shape
		@shape
	end
	
	def color
		@color
	end
	
	def number
		@number
	end
	
	def shading
		@shading
	end
	
	def initialize(shape, color, number, shading)
		@shape = shape
		@color = color
		@number = number
		@shading = shading
	end
end

def checkAttr(a, b, c)
	if (a == b && b == c && a == c)
		return true;
	end
	
	if (a != b && b != c && a != c)
		return true;
	end
		
	return false;
end

def isSet(*cards)
	for attr in ["shape", "color", "number", "shading"]
		attrs = cards.map{|card| card.send(attr)}
		
		if (checkAttr(*attrs) == false)
			return false;
		end
	end
	
	return true;
end

# test...
#puts isSet(SetCard.new(0,0,0,0),SetCard.new(0,1,0,0),SetCard.new(0,2,0,0))