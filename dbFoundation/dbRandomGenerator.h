//
//  dbRandomGenerator.h
//  Deep Bondi Foundation
//
//  Created by mokus on Mon Jan 14 2002.
//  Copyright (c) 2002 Deep Bondi Enterprises. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "dbSharedPersistentObject.h"


@interface dbRandomGenerator : dbSharedPersistentObject {
    char *state;
    int stateSize;
    unsigned seed;
}

    /*
     *	initWithStateSize:seed:
     *
     * 	  Initializes the random number generator, creating 'size' bytes of state,
     *  and seeding it using 'seed', as well as randomly generated state data.
     */
- (id) initWithStateSize: (int) size seed: (unsigned) seed;

    /*
     *	scrambleState;
     *
     *    called internally to randomize the state array.
     */
- (void) scrambleState;

    /*
     *  random
     *    return a random unsigned integer.  Every bit is 'usably random' (for most
     *  applications).  Value is between 0 and the maximum possible value of an
     *  unsigned integer (inclusive).
     */
- (unsigned) random;

    /*
     *	randomInRange:
     *
     *	  return a random number within the specified range.
     */
- (unsigned) randomInRange: (NSRange) aRange;

    /*
     *	randomBetween:and:
     *
     *    return a random number within the specified range.
     */
- (unsigned) randomBetween: (unsigned) low and: (unsigned) high;

@end
