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

def checkAttr(a,b,c)
	if (a == b && b == c)
		return true;
	end
	
	if (a != b && b != c && a != c)
		return true;
	end
	
	return false;
end

def isSet(card1, card2, card3)
	for attr in ["shape", "color", "number", "shading"]
		a = card1.send(attr);
		b = card2.send(attr);
		c = card3.send(attr);
		
		if (checkAttr(a, b, c) == false)
			return false;
		end
	end
	
	return true;
end