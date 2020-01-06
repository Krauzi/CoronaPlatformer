
local composer = require( "composer" )

local scene = composer.newScene()

--------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 6)

local hero
local floor1
local floor2
local background1
local background2

local obstacleTable = {}

local livesText
local scoreText
local uiGroup

local function createObstacle()
 
	local newObstacle = display.newRect(2050, 595, 50, 50)
	newObstacle.strokeWidth = 3
	newObstacle:setFillColor( 0.5 )
	newObstacle:setStrokeColor( 0, 0, 1 )
	physics.addBody( newObstacle, "dynamic", {1500, 595, 1550, 595, 1550, 645, 1500, 645} )
	--newObstacle:setLinearVelocity(-600, 0)
	transition.to( newObstacle, { time=6000, alpha=1, x=-700, y=newObstacle.y} )
    table.insert( obstacleTable, newObstacle )
    newObstacle.myName = "obstacle"

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

local running_hero_options = {
	frames = {
        { x=0, y=1, width=143, height=187 },
        { x=145, y=1, width=126, height=187 },
        { x=272, y=1, width=124, height=187 },
        { x=397, y=1, width=162, height=187 },
		{ x=561, y=1, width=153, height=187 },
		{ x=717, y=1, width=126, height=187 },
		{ x=846, y=1, width=138, height=187 },
		{ x=987, y=1, width=135, height=187 }
    },
    sheetContentWidth = 1123,
    sheetContentHeight = 189
}

local sheet_running_hero = graphics.newImageSheet( "/images/running-sprite.png", running_hero_options )

local jumping_hero_options = {
	frames = {
		{ x=1, y=1, width=130, height=187 },
		{ x=144, y=1, width=112, height=187 },
		{ x=263, y=1, width=156, height=187 },
		{ x=425, y=1, width=162, height=187 }
	},
	sheetContentWidth = 587,
	sheetContentHeight = 189
}

local sheet_jumping_hero = graphics.newImageSheet( "/images/jump-sprite.png", jumping_hero_options )

local attack_hero_options = {
	frames = {
		{ x=58, y=12, width=120, height=204 },
		{ x=228, y=12, width=152, height=204 },
		{ x=405, y=12, width=221, height=204 },
		{ x=635, y=12, width=157, height=204 },
		{ x=802, y=12, width=118, height=204 },
		{ x=930, y=12, width=276, height=204 },
		{ x=1212, y=12, width=182, height=204 },
		{ x=1404, y=12, width=173, height=204 },
		{ x=1623, y=12, width=130, height=204 }
	},
	sheetContentWidth = 1755,
	sheetContentHeight = 217
}

local sheet_attacking_hero = graphics.newImageSheet( "/images/attack-sprite.png", attack_hero_options)


local sequences_hero = {
    {
        name = "normalRun",
        start = 1,
        count = 8,
        time = 600,
        loopCount = 0,
		loopDirection = "forward",
		sheet = sheet_running_hero
	},
	{
        name = "jumpStart",
        frames = { 1 },
		loopCount = 0,
		sheet = sheet_jumping_hero
	},
	{
        name = "jumpUp",
        frames = { 2 },
		loopCount = 0,
		sheet = sheet_jumping_hero
	},
    {
        name = "jumpPeak",
        frames = { 3 },
		loopCount = 0,
		sheet = sheet_jumping_hero
	},
	{
        name = "jumpFall",
        frames = { 4 },
		loopCount = 0,
		sheet = sheet_jumping_hero
	},
	{
		name = "attack",
        start = 1,
        count = 9,
		time = 700,
		loopCount = 0,
		loopDirection = "forward",
		sheet = sheet_attacking_hero
	}
}

local function heroListener( event )
	local thisSprite = event.target  -- "event.target" references the sprite
	--print("Sprite y: "..math.round(thisSprite.y) .. " isJumping: "..tostring(hero.isJumping))
	if (hero.isJumping == true) then
		if (thisSprite.sequence == "jumpStart" and math.round(thisSprite.y) == 495) then
			hero:setSequence( "jumpUp" )
			hero:play()
		end
	
		if (thisSprite.sequence == "jumpUp" and math.round(thisSprite.y) == 300) then
			hero:setSequence( "jumpPeak" )
			hero:play()
		end
	
		if (thisSprite.sequence == "jumpPeak" and math.round(thisSprite.y) == 302) then
			hero:setSequence( "jumpFall" )
			hero:play()
		end

		if (thisSprite.sequence == "jumpFall" and (math.round(thisSprite.y) == 528 or math.round(thisSprite.y) == 529)) then
			hero:setSequence( "normalRun" )
			hero:play()
			hero.isJumping = false
		end
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
	--700, 650, 1400, 50
	--floor1:setFillColor( 0.5 )
	--floor1.strokeWidth = 3
	--floor1:setStrokeColor( 1, 1, 0 )
	floor1.id = "ground"
	--shape={ 0, 647‬, 1400, 647‬, 1400, 952, 0, 952 }
	local floorShape = { -700,-125, 700,-125, 700,152, -700,152 }
	physics.addBody( floor1, "static", {shape=floorShape, bounce=0.0 } )
	transition.to( floor1, { time=3000, alpha=1, x=-700, y=floor1.y,  onComplete=scrollFloor} )

	floor2 = display.newImageRect("images/platform.png", 1400 , 305)
	floor2.x = 2070
	floor2.y = 800
	floor2.id = "ground"
	physics.addBody( floor2, "static", { shape=floorShape, bounce=0.0 } )
	transition.to( floor2, { time=6000, alpha=1, x=-700, y=floor1.y,  onComplete=scrollFloor} )

	hero = display.newSprite( sheet_running_hero, sequences_hero )
	hero.x = 100
	hero.y = floor1.y - 220

	local heroShape = { 5,-74, 52,-54, 58,20, 32,94, -22,94, -50,40, -40,-30 }
	physics.addBody( hero, "dynamic",
		{ density=1.0, bounce=0.0, shape=heroShape },  -- Main body element
		{ isSensor=true }  -- Foot sensor element
	)

	hero.gravityScale = 13

	hero.isFixedRotation = true
	hero.isJumping = false

	hero.collision = sensorCollision

	--physics.setDrawMode( "hybrid" )

	hero:addEventListener( "sprite", heroListener )
	hero:addEventListener( "collision" )
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

		hero:setSequence( "attack" )
		hero:play()

		-- floor1 = display.newRect( 700, 650, 1400, 50 )
		-- floor1.strokeWidth = 3
		-- floor1.id = "floor"
		-- floor1:setFillColor( 0.5 )
		-- floor1:setStrokeColor( 1, 1, 0 )
		-- physics.addBody( floor1, "static", { 0,650, 1400,650, 1400,700, 0,700 })
		-- floor1:setLinearVelocity(-333, 0)
		-- floor1.gravityScale = 0

		-- floor2 = display.newRect( 2100, 650, 1400, 50 )
		-- floor2.strokeWidth = 3
		-- floor2.id = "floor"
		-- floor2:setFillColor( 0.5 )
		-- floor2:setStrokeColor( 1, 1, 0 )
		-- physics.addBody( floor2, "static", { 1400,650, 2800,650, 2800,700, 1400,700 })
		-- floor2:setLinearVelocity(-333, 0)
		-- floor2.gravityScale = 0

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
