/*
 * Contains the list of available games
 */
 var _g = new Array();
 var _games;
 var _gamesCounter = -1;


_gamesCounter++;_g[_gamesCounter] = new Object();
_g[_gamesCounter].name = 'Four Sail';
_g[_gamesCounter].path = 'foursail.swf'; // or .swf or .jar, or path to folder
_g[_gamesCounter].type = 'flash';  // type: unity / flash / html / java
_g[_gamesCounter].credits = 'Ethan Kennerly';
_g[_gamesCounter].instructions = 'Left/Right Steer. J/L Main left/right. D Head left. F Head right. -30sec Approach. +30sec Race!';
