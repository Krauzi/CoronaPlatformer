
local composer = require( "composer" )

local scene = composer.newScene()

--------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 6)

local myRectangle
local floor1
local floor2

local livesText
local scoreText
local uiGroup

local function gameLoop()
 
	-- Move floor that drifted off screen back to the start
	if (floor1.x < -408) then
		floor1.x = 1006
	end

	if (floor2.x < -408) then
		floor2.x = 1006
	end


end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
		physics.pause()

		myRectangle = display.newRect( 60, 50, 50, 50 )
		myRectangle.strokeWidth = 3
		myRectangle:setFillColor( 0.5 )
		myRectangle:setStrokeColor( 1, 0, 0 )
		physics.addBody( myRectangle, "dynamic", {60, 50, 110, 50, 160, 100, 60, 100} )

		floor1 = display.newRect( 0, 300, 700, 50 )
		floor1.strokeWidth = 3
		floor1:setFillColor( 0.5 )
		floor1:setStrokeColor( 1, 1, 0 )
		physics.addBody( floor1, "kinematic", { 0,300, 300,300, 300,350, 0,350 } )
		floor1:setLinearVelocity(-100, 0)
		floor1.gravityScale = 0

		floor2 = display.newRect( 710, 300, 700, 50 )
		floor2.strokeWidth = 3
		floor2:setFillColor( 0.5 )
		floor2:setStrokeColor( 1, 1, 0 )
		physics.addBody( floor2, "kinematic", { 710,300, 1010,300, 1010,350, 710,350 } )
		floor2:setLinearVelocity(-100, 0)
		floor2.gravityScale = 0

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		gameLoopTimer = timer.performWithDelay( 100, gameLoop, 0 )
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
