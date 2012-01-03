	/*
	 *  <players.c>
	 *    Copyright 2007 Deep Bondi - All Rights Reserved.
	 */

#include <stdlib.h>
#include "SDL.h"

#include "xset.h"

void SelectPlayers(SDL_Surface *screen, players *Players) {
	// test data...
	Players->NumPlayers = 1;
	Players->Player[0] = (player) { .score = 0 };
	
	// show player screen, &c.
}
