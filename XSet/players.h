	/*
	 *  </Users/mokus/Projects/XSet/players.h>
	 *    Copyright 2007 Deep Bondi - All Rights Reserved.
	 */

#ifndef __players_h__
#define __players_h__

#include "SDL.h"

// data structures about players get defined here

// a struct describing a single player
typedef struct {
	// color?
	int score;
	} player;

// "players" is equivalent to an array of 4 "player" structs
typedef struct {
	int NumPlayers;
	player Player[4];
	} players;


// players.c functions called from outside players.c get declared here
void SelectPlayers(SDL_Surface *screen, players *Players);


#endif /* __players_h__ */
