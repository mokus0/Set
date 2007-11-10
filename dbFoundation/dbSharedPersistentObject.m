//
//  dbSharedPersistentObject.m
//  Deep Bondi Foundation
//
//  Created by mokus on Mon Jan 14 2002.
//  Copyright (c) 2002 Deep Bondi Enterprises. All rights reserved.
//

#import "dbSharedPersistentObject.h"


@implementation dbSharedPersistentObject

+ (id *) dbPersistentObjectInstancePointer {
    /*
     * We're an abstract class!  Don't let anybody initialize us,
     * at least not like this...
     *
     * Like I said in the .h, override this if you wanna do anything
     * useful with your subclass.
     */
    return nil;
}

+ (id) sharedInstance {
    id *Pointer = [self dbPersistentObjectInstancePointer];
    id instance = nil;
    
    if (Pointer) {
        if (*Pointer) {
            instance = *Pointer;
        } else {
            instance = *Pointer = [[self alloc] init];
			instance = [self postInit: instance];
        }
    } else {
        NSLog(@"%@: nil Pointer-to-Pointer returned by dbPersistentObjectInstancePointer", self );
    }
    
    return instance;
}

+ (id) postInit: (id) instance {
	return instance;
}

- (void) reallyReallyReallyDealloc {
    id *Pointer = [[self class] dbPersistentObjectInstancePointer];
    
    if (Pointer) {
        *Pointer = nil;
    }
    
    [super reallyReallyReallyDealloc];
}

@end
