//
//  dbRandomGenerator.m
//  Deep Bondi Foundation
//
//  Created by mokus on Mon Jan 14 2002.
//  Copyright (c) 2002 Deep Bondi Enterprises. All rights reserved.
//

#import "dbRandomGenerator.h"
#import "unistd.h"

@implementation dbRandomGenerator

+ (id *) dbPersistentObjectInstancePointer {
    static dbRandomGenerator *_dbGlobalRandomGenerator = nil;

    return &_dbGlobalRandomGenerator;
}

- (id) init {
    return [self initWithStateSize: 256 seed: (unsigned) time(NULL)];
}

- (id) initWithStateSize: (int) size seed: (unsigned) startSeed{
    self = [super init];
    if (self) {
        state = (char *) malloc(size);
        stateSize = size;
        seed = startSeed;
        
        [self scrambleState];
        
        initstate(seed, state, stateSize);
    }
    
    return self;
}

- (void) scrambleState {
    int i;
    
    srandom(seed);
    
    for (i = 0; i < stateSize; i++) {
        state[i] = (char) time(NULL);
    }
}

- (unsigned) random {
    return random();
}

- (unsigned) randomInRange: (NSRange) aRange {
    return aRange.location + (random() % aRange.length);
}

- (unsigned) randomBetween: (unsigned) low and: (unsigned) high {
    return low + (random() % (high - low));
}


@end
