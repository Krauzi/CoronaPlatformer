
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
	print("-----------------------------------------------")
	-- Move floor that drifted off screen back to the start
	if (floor1.x  < -700) then
		floor1.x = floor2.x + 1400
	end

	if (floor2.x < -700) then
		floor2.x = floor1.x + 1400
	end


end

local function onKeyEvent( event )
	-- Jumping
	if ( event.keyName == "space" ) then
        if (event.phase == "down" and math.floor(myRectangle.y) == 595) then
			myRectangle:setLinearVelocity(0, -450)
        end
	end
	--TODO: crouching/slide

    return false
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

		myRectangle = display.newRect( 60, 590, 50, 50 )
		myRectangle.strokeWidth = 3
		myRectangle:setFillColor( 0.5 )
		myRectangle:setStrokeColor( 1, 0, 0 )
		physics.addBody( myRectangle, "dynamic", {60, 590, 110, 590, 160, 640, 60, 640} )
		myRectangle.gravityScale = 4

		floor1 = display.newRect( 700, 650, 1400, 50 )
		floor1.strokeWidth = 3
		floor1:setFillColor( 0.5 )
		floor1:setStrokeColor( 1, 1, 0 )
		physics.addBody( floor1, "kinematic", { 0,650, 1400,650, 1400,700, 0,700 } )
		floor1:setLinearVelocity(-333, 0)
		floor1.gravityScale = 0

		floor2 = display.newRect( 2100, 650, 1400, 50 )
		floor2.strokeWidth = 3
		floor2:setFillColor( 0.5 )
		floor2:setStrokeColor( 1, 1, 0 )
		physics.addBody( floor2, "kinematic", { 1400,650, 2800,650, 2800,700, 1400,700 } )
		floor2:setLinearVelocity(-333, 0)
		floor2.gravityScale = 0

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "key", onKeyEvent )
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
