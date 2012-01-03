#
#  SetTestController.rb
#  SetTest
#
#  Created by James Cook on 2/20/08.
#  Copyright (c) 2008 __MyCompanyName__. All rights reserved.
#

require 'osx/cocoa'

class SetTestController < OSX::NSObject
    ib_outlets :cardCell, :cardButton

    ib_action :click do |sender|
		@cardCell.card = OSX::SetCard.deckCardAfter(@cardCell.card)
		@cardButton.setNeedsDisplay(true)
    end
end
