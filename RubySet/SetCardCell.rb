#
#  SetCardCell.rb
#  RubySet
#
#  Created by James Cook on 11/23/07.
#  Copyright (c) 2007 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class SetCardCell <  OSX::NSButtonCell
	def initImageCell(img)
		super_initImageCell(img)
		
		@card = nil
		
		return self
	end
	
	def drawInteriorWithFrame_inView(frame, view)
		if (@card == nil)
			SetCardCell.drawCardBackInRect(frame)
		else
			SetCardCell.drawCardInRect(@card, rect)
		end
	end

	def SetCardCell.drawCardInRect(card, rect)
		
	end

	def SetCardCell.drawCardBackInRect(rect)
		
	end
end
