-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local composer = require( "composer" )
 
display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )
 
audio.reserveChannels( 1 )
audio.setVolume( 0.5 )
 
composer.gotoScene( "scenes.menu" )