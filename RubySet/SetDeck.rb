#
#  SetDeck.rb
#  RubySet
#
#  Created by James Cook on 11/23/07.
#  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
#

require "SetCard";
require "SetAttributes";

class SetDeck < Array
	def initialize()
		for shape in Shape.all
			for color in Color.all
				for number in Number.all
					for shading in Shading.all
						self.push(SetCard.new(shape, color, number, shading));
					end
				end
			end
		end
	end
	
	def shuffle!
		size.downto(1) { |n| push delete_at(rand(n)) }
		self
	end
end
