
local composer = require( "composer" )

local scene = composer.newScene()

--------------------------------------------------------------------------------------

local musicTrack

local function gotoGame()
	composer.gotoScene( "scenes.game", { time=400, effect="crossFade" } )
	audio.stop( 1 )
end

local function gotoSettings()
    composer.gotoScene( "scenes.settings", { time=400, effect="crossFade" } )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
	local sceneGroup = self.view

	local background = display.newImageRect( sceneGroup, "/images/background.jpg", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local title1 = display.newText( sceneGroup, "CORONA", display.contentCenterX, 180, "fonts/Pixellari.ttf", 112 )
	title1:setFillColor( 249/255, 111/255, 41/255 )
	local title2 = display.newText( sceneGroup, "PLATFORMER", display.contentCenterX, 260, "fonts/Pixellari.ttf", 86 )
	title2:setFillColor( 1, 1, 1)

	local playButton = display.newText( sceneGroup, "Graj", display.contentCenterX, 400, "fonts/Pixellari.ttf", 64 )
	playButton:setFillColor( 1, 1, 1 )

	local settingsButton = display.newText( sceneGroup, "Ustawienia", display.contentCenterX, 470, "fonts/Pixellari.ttf", 64 )
	settingsButton:setFillColor( 1, 1, 1  )

	playButton:addEventListener( "tap", gotoGame )
	settingsButton:addEventListener( "tap", gotoSettings )

	musicTrack = audio.loadStream( "audio/main-menu.ogg" )
end


-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		-- preferuje start muzyczki wcześniej
		audio.play( musicTrack, { channel=1, loops=-1 } )
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		-- Start the music!
		
	end
end


-- hide()
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		-- Stop the music!
		-- audio.stop( 1 )
	end
end


-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
	audio.dispose( musicTrack )
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
