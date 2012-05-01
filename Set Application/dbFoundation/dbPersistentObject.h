//
//  dbPersistentObject.h
//  Deep Bondi Foundation
//
//  Created by mokus on Mon Jan 14 2002.
//  Copyright (c) 2002 Deep Bondi Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>

    /*
     *	dbPersistentObject
     *    This is an abstract superclass for objects that should never be deallocated
     *  unintentionally.  Mostly (and so far only) used as a base for classes that
     *  only create a single 'shared instance' that should rarely actually be
     *  deallocated.
     */

@interface dbPersistentObject : NSObject {

}

    /*
     *	reallyReallyReallyDealloc
     *    This can be used to force a persistent object to be deallocated.
     */
- (void) reallyReallyReallyDealloc;

@end
