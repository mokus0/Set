	/*
	 *  <display.c>
	 *    Copyright 2007 James Cook - All Rights Reserved.
	 */

#include "SDL.h"

#include "display.h"

SDL_Surface *InitDisplay() {
	return SDL_SetVideoMode(640, 480, 32, SDL_DOUBLEBUF | SDL_HWSURFACE);
}
