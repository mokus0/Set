//
//  dbPersistentObject.m
//  Deep Bondi Foundation
//
//  Created by mokus on Mon Jan 14 2002.
//  Copyright (c) 2002 Deep Bondi Enterprises. All rights reserved.
//

#import "dbPersistentObject.h"


@implementation dbPersistentObject

- (void) reallyReallyReallyDealloc {
    NSDeallocateObject(self);
}

- (void) dealloc {
    /* Do Nothing, Intentionally! */
}

- (oneway void) release {
    /* Nothing again! */
}

- (id) autorelease {
    return self;
}

- (id) retain {
    return self;
}

- (unsigned) retainCount {
    return 1;
}

@end
