	/*
	 *  <main.c>
	 *    Copyright 2007 Deep Bondi Enterprises - All Rights Reserved.
	 */

#include "SDL.h"

#include "xset.h"

void XBoxStartup() {
	SDL_Surface *screen = InitDisplay();
	
	players currentPlayers = {
		.NumPlayers = 0
	};
	
	SelectPlayers(screen, &currentPlayers);
	while (currentPlayers.NumPlayers > 0) {
		PlayGame(screen, &currentPlayers);
		
		SelectPlayers(screen, &currentPlayers);
	}
}