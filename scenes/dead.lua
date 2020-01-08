local composer = require( "composer" )

local scene = composer.newScene()
--------------------------------------------------------------------------------------

local function gotoMenu()
	composer.gotoScene( "scenes.menu", { time=400, effect="crossFade" } )
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

	local losetext = display.newText( sceneGroup, "Przegrałeś!", display.contentCenterX, 180, "fonts/Pixellari.ttf", 112 )
	losetext:setFillColor( 249/255, 111/255, 41/255 )

	local scoretext = display.newText( sceneGroup, "Twój wynik: " .. _G.finalScore, display.contentCenterX, 280, "fonts/Pixellari.ttf", 86 )
	scoretext:setFillColor( 1, 1, 1)
	
	local MenuButton = display.newText( sceneGroup, "Wróć", display.contentCenterX, 400, "fonts/Pixellari.ttf", 64 )
	MenuButton:setFillColor( 1, 1, 1 )
	MenuButton:addEventListener( "tap", gotoMenu)
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
		composer.removeScene( "scenes.dead" )
	end
end


-- destroy()
function scene:destroy( event )
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	-- Dispose audio!
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