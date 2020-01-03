
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


local uiGroup = display.newGroup()
local volumeGroup = display.newGroup()

local function bgSliderListener( event )
	audio.setVolume( event.value / 100 )
end


local options = {
    frames = {
        { x=0, y=0, width=17, height=64 },
        { x=38, y=0, width=13, height=64 },
        { x=19, y=0, width=17, height=64 },
        { x=53, y=0, width=13, height=64 },
        { x=68, y=0, width=42, height=64 }
    },
    sheetContentWidth = 110,
    sheetContentHeight = 64
}
local sliderSheet = graphics.newImageSheet( "/images/widget-slider.png", options )
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	local background = display.newImageRect( sceneGroup, "/images/background.jpg", 1280, 720 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	uiGroup:insert(background)

	local settingsTitle = display.newText( sceneGroup, "Ustawienia", display.contentCenterX, 100, "fonts/Pixellari.ttf", 92 )
	settingsTitle:setFillColor( 249/255, 111/255, 41/255 )
	uiGroup:insert(settingsTitle)

	local controlsLabel = display.newText( sceneGroup, "Sterowanie:", display.contentCenterX, 190, "fonts/Pixellari.ttf", 66 )
	uiGroup:insert(controlsLabel)

	local jump = display.newText( sceneGroup, "Skok: SPACJA", display.contentCenterX, 260, "fonts/Pixellari.ttf", 50 )
	uiGroup:insert(jump)

	local slide = display.newText( sceneGroup, "Ślizg: CTRL", display.contentCenterX, 320, "fonts/Pixellari.ttf", 50 )
	uiGroup:insert(slide)

	local soundLabel = display.newText( sceneGroup, "Dźwięk:", display.contentCenterX, 420, "fonts/Pixellari.ttf", 66 )
	uiGroup:insert(soundLabel)

	local sliderWidth = 800
	-- Główny volume slider
	local bgSlider = widget.newSlider{
		sheet = sliderSheet,
        leftFrame = 1,
        middleFrame = 2,
        rightFrame = 3,
        fillFrame = 4,
        frameWidth = 18,
        frameHeight = 64,
        handleFrame = 5,
        handleWidth = 64,
        handleHeight = 64,
        x = display.contentCenterX,
        y = 510,
        orientation = "horizontal",
		width = 800,
		value = 50,
        listener = bgSliderListener
	}
	volumeGroup:insert( bgSlider )

	local menuButton = display.newText( sceneGroup, "Powrót", display.contentCenterX, 630, "fonts/Pixellari.ttf", 60 )
	menuButton:setFillColor( 1, 1, 1 )
	uiGroup:insert(menuButton)
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
