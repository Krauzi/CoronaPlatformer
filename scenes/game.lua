
local composer = require( "composer" )

local scene = composer.newScene()

--------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 6)

local myRectangle
local runningHero
local floor1
local floor2

local obstacleTable = {}

local livesText
local scoreText
local uiGroup

local function createObstacle()
 
	local newObstacle = display.newRect(1500, 595, 50, 50)
	newObstacle.strokeWidth = 3
	newObstacle:setFillColor( 0.5 )
	newObstacle:setStrokeColor( 0, 0, 1 )
	physics.addBody( newObstacle, "dynamic", {1500, 595, 1550, 595, 1550, 645, 1500, 645} )
	newObstacle:setLinearVelocity(-333, 0)
    table.insert( obstacleTable, newObstacle )
    newObstacle.myName = "obstacle"

end

local function gameLoop()
	print("-----------------------------------------------")
	-- Move floor that drifted off screen back to the start
	if (floor1.x  < -700) then
		floor1.x = floor2.x + 1400
	end

	if (floor2.x < -700) then
		floor2.x = floor1.x + 1400
	end

	createObstacle()

end

local function onKeyEvent( event )
	-- Jumping
	if ( event.keyName == "space" ) then
        if (event.phase == "down") then
			runningHero:setLinearVelocity(0, -450)
        end
	end
	--TODO: crouching/slide

    return false
end

local running_options = {
    frames = {
        { x=0, y=0, width=143, height=189 },
        { x=145, y=0, width=126, height=189 },
        { x=272, y=0, width=124, height=189 },
        { x=397, y=0, width=162, height=189 },
		{ x=561, y=0, width=153, height=189 },
		{ x=717, y=0, width=126, height=189 },
		{ x=846, y=0, width=138, height=189 },
		{ x=987, y=0, width=135, height=189 }
    },
    sheetContentWidth = 1123,
    sheetContentHeight = 189
}
local sheet_runningHero = graphics.newImageSheet( "/images/running-sprite.png", running_options )


local sequences_runningHero = {
    {
        name = "normalRun",
        start = 1,
        count = 8,
        time = 600,
        loopCount = 0,
        loopDirection = "forward"
    }
}

local function heroListener( event )
 
    local thisSprite = event.target  -- "event.target" references the sprite

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

		runningHero = display.newSprite( sheet_runningHero, sequences_runningHero )
		runningHero.x = 100
		runningHero.y = 524
		physics.addBody( runningHero, "dynamic", {60, 590, 110, 590, 160, 640, 60, 640} )
		runningHero.gravityScale = 4
		runningHero:addEventListener( "sprite", heroListener )

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
		runningHero:setSequence( "normalRun" )
		runningHero:play()
		gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0 )
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
