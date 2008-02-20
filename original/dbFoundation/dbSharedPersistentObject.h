//
//  dbSharedPersistentObject.h
//  Deep Bondi Foundation
//
//  Created by mokus on Mon Jan 14 2002.
//  Copyright (c) 2002 Deep Bondi Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dbPersistentObject.h"

    /*
     *	dbSharedPersistentObject
     *    Abstract superclass for classes that manage a single shared instance.
     *  Subclasses should override 'dbPersistentObjectInstancePointer' to return a
     *  pointer to a static pointer to the shared instance, and should initialize
     *  the static pointer to nil.  When required (as in, the first time the shared
     *  instance is requested), the class will be instantiated, using +alloc and
     *  -init, and all subsequent requests will return the same (indestructible)
     *  object.
     */

@interface dbSharedPersistentObject : dbPersistentObject {

}

/* 
 *  This method should be overridden to return a pointer to the 
 *  pointer that should refer to the shared instance of the subclass.
 */
+ (id *) dbPersistentObjectInstancePointer;

/*
 *  This method normally should not need to be overridden - it just calls the
 *  initializer if needed and gets the shared instance otherwise.
 */
+ (id) sharedInstance;

/*
 *  This method may be overridden to allow you to do some one-shot 
 *  initialization after the shared instance is set up.  Useful, for
 *  example, if you overrode +alloc to return an instance of another
 *  class, and you now want to groom that object for is intended use
 */
+ (id) postInit: (id) instance;

@end
