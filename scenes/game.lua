
local composer = require( "composer" )
local heroSheet = require( "scenes.heroSheet" )
local barbarianSheet = require( "scenes.barbarianSheet" )

local scene = composer.newScene()

--------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 6)

local hero
local heroRunning = heroSheet:getRunningSheet()
local heroSequences = heroSheet:getSequences()
local heroShape = heroSheet:getShape()

-- TYMCZASOWO
local barbarianRunning = barbarianSheet:getRunningSheet()
local barbarianSequences = barbarianSheet:getSequences()
local barbarianShape = barbarianSheet:getShape()


local floor1
local floor2
local background1
local background2

local obstacleTable = {}

local livesText
local scoreText
local uiGroup

local function createObstacle()
 
	local newObstacle = display.newImageRect("images/rock.png", 155, 100)
	--newObstacle.strokeWidth = 3
	--newObstacle:setFillColor( 0.5 )
	--newObstacle:setStrokeColor( 0, 0, 1 )
	newObstacle.x = 2050
	newObstacle.y = 642
	local rockShape = {  -5,-50, 54,-13, 75,46, -75,46, -64,-10 }
	physics.addBody( newObstacle, "static", { shape=rockShape } )
	--newObstacle:setLinearVelocity(-600, 0)
	transition.to( newObstacle, { time=6000, alpha=1, x=-700, y=newObstacle.y} )
    table.insert( obstacleTable, newObstacle )
	newObstacle.myName = "obstacle"
	newObstacle.isFixedRotation = true

end

local function gameLoop()
	-- Move floor that drifted off screen back to the start
	-- if (floor1.x  < -700) then
	-- 	floor1.x = floor2.x + 1400
	-- end

	-- if (floor2.x < -700) then
	-- 	floor2.x = floor1.x + 1400
	-- end

	-- Dispose of obstacles that drifted off screen
	for i = #obstacleTable, 1, -1 do
        local thisObstacle = obstacleTable[i]
 
        if ( thisObstacle.x < -100 or thisObstacle.y > 770)
		then
            display.remove( thisObstacle )
            table.remove( obstacleTable, i )
        end
    end

end

local function onKeyEvent( event )
	-- Jumping
	if ( event.keyName == "space" ) then
		if (event.phase == "down" and math.floor(hero.y) > 525 ) then
			hero.isJumping = true
			hero:setSequence( "jumpStart" )
			hero:play()

			local vx, vy = hero:getLinearVelocity()
			hero:setLinearVelocity( vx, 0 )
			hero:applyLinearImpulse( nil, -550, hero.x, hero.y )
        end
	end

    return false
end

local function heroListener( event )
	local thisSprite = event.target  -- "event.target" references the sprite
	--print("Sprite y: "..math.round(thisSprite.y) .. " isJumping: "..tostring(hero.isJumping))
	if (hero.isJumping == true) then
		if (thisSprite.sequence == "jumpStart" and math.round(thisSprite.y) == 547) then
			hero:setSequence( "jumpUp" )
			hero:play()
		end
	
		if (thisSprite.sequence == "jumpUp" and math.round(thisSprite.y) == 352) then
			hero:setSequence( "jumpPeak" )
			hero:play()
		end
	
		if (thisSprite.sequence == "jumpPeak" and math.round(thisSprite.y) == 356) then
			hero:setSequence( "jumpFall" )
			hero:play()
		end

		if (thisSprite.sequence == "jumpFall" and (math.round(thisSprite.y) == 580 or math.round(thisSprite.y) == 581)) then
			hero:setSequence( "run" )
			hero:play()
			hero.isJumping = false
		end
	end

	if (thisSprite.sequence == "death") then
		hero.isBodyActive = false
		hero.y = hero.y + 10;
	end
end

local function sensorCollision( self, event )
	local collideObject = event.other
	
end

local function scrollBackground(background)
	background.x = 2870
	transition.to( background, { time=60000, alpha=1, x=-960, y=background.y, onComplete=scrollBackground} )
end

local function scrollFloor(floor)
	--floor.x = 2050
	if (floor == floor1) then
		floor.x = floor2.x + 1370
	else
		floor.x = floor1.x + 1370
	end
	transition.to( floor, { time=6000, alpha=1, x=-700, y=floor.y, onComplete=scrollFloor} )
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

	physics.pause()

	background1 = display.newImageRect( "images/background_run.png", 1920, 1080 )
	background1.x = 960
	background1.y = display.contentCenterY
	transition.to( background1, { time=30000, alpha=1, x=-960, y=background1.y, onComplete=scrollBackground} )

	background2 = display.newImageRect( "images/background_run.png", 1920, 1080 )
	background2.x = background1.x + 1910
	background2.y = display.contentCenterY
	transition.to( background2, { time=60000, alpha=1, x=-960, y=background2.y, onComplete=scrollBackground} )

	floor1 = display.newImageRect("images/platform.png", 1400 , 305)
	floor1.x = 700
	floor1.y = 800
	floor1.id = "ground"

	local floorShape = { -700,-125, 700,-125, 700,152, -700,152 }
	physics.addBody( floor1, "static", {shape=floorShape, bounce=0.0 } )
	transition.to( floor1, { time=3000, alpha=1, x=-700, y=floor1.y,  onComplete=scrollFloor} )

	floor2 = display.newImageRect("images/platform.png", 1400 , 305)
	floor2.x = 2070
	floor2.y = 800
	floor2.id = "ground"
	physics.addBody( floor2, "static", { shape=floorShape, bounce=0.0 } )
	transition.to( floor2, { time=6000, alpha=1, x=-700, y=floor1.y,  onComplete=scrollFloor} )

	-- Create hero
	hero = display.newSprite( heroRunning, heroSequences )
	hero.x = 100
	hero.y = floor1.y - 220

	-- Add physics to hero
	physics.addBody( hero, "dynamic",
		{ density=1.0, bounce=0.0, shape=heroShape },
		{ isSensor=true }
	)

	hero.gravityScale = 13

	hero.isFixedRotation = true
	hero.isJumping = false

	hero.collision = sensorCollision

	physics.setDrawMode( "hybrid" )

	hero:addEventListener( "sprite", heroListener )
	hero:addEventListener( "collision" )
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

		hero:setSequence( "run" )
		hero:play()

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
		Runtime:addEventListener( "key", onKeyEvent )

		gameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0 )
		spawnTimer = timer.performWithDelay(2000, createObstacle, 0)
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
