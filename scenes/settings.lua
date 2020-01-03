
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local widget = require( "widget" )

local function gotoMenu()
	composer.gotoScene( "scenes.menu", { time=400, effect="crossFade" } )
end

local function sliderListener( event )
    print( "Slider at " .. event.value .. "%" )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "/images/background.jpg", 720, 410 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local settingsTitle = display.newText( sceneGroup, "Ustawienia", display.contentCenterX, 520, "fonts/Pixellari.ttf", 70 )
	settingsTitle:setFillColor( 1, 1, 1 )

	local controlsLabel = display.newText( sceneGroup, "Sterowanie:", display.contentCenterX, 600, "fonts/Pixellari.ttf", 56 )

	local jump = display.newText( sceneGroup, "Skok: SPACJA", display.contentCenterX, 660, "fonts/Pixellari.ttf", 40 )

	local slide = display.newText( sceneGroup, "Ślizg: CTRL", display.contentCenterX, 710, "fonts/Pixellari.ttf", 40 )

	local menuButton = display.newText( sceneGroup, "Powrót", display.contentCenterX, 800, "fonts/Pixellari.ttf", 52 )
	menuButton:setFillColor( 1, 1, 1 )
	menuButton:addEventListener( "tap", gotoMenu )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
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

		composer.removeScene( "settings" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
