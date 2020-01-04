
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
	-- Move floor that drifted off screen back to the start
	if (floor1.x  < -700) then
		floor1.x = floor2.x + 1400
	end

	if (floor2.x < -700) then
		floor2.x = floor1.x + 1400
	end

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
		-- Let him jump a little quicker before he reaches the floor 
		if (event.phase == "down" and math.floor(hero.y) > 525) then
			-- hero.isJumping = true
			-- hero:pause()
			-- hero:setSequence ( "jumpUp" )
			-- hero:play()
			hero:setLinearVelocity(0, -550)
        end
	end

    return false
end

local hero_options = {
	frames = {
        { x=0, y=1, width=143, height=187 },
        { x=145, y=1, width=126, height=187 },
        { x=272, y=1, width=124, height=187 },
        { x=397, y=1, width=162, height=187 },
		{ x=561, y=1, width=153, height=187 },
		{ x=717, y=1, width=126, height=187 },
		{ x=846, y=1, width=138, height=187 },
		{ x=987, y=1, width=135, height=187 },
		{ x=1126, y=1, width=130, height=187 },
        { x=1269, y=1, width=112, height=187 },
        { x=1388, y=1, width=156, height=187 },
		{ x=1550, y=1, width=162, height=187 }
    },
    sheetContentWidth = 1712,
    sheetContentHeight = 189
}
local sheet_hero = graphics.newImageSheet( "/images/hero_sprite.png", hero_options )


local sequences_hero = {
    {
        name = "normalRun",
        start = 1,
        count = 8,
        time = 600,
        loopCount = 0,
        loopDirection = "forward"
	},
	{
        name = "jumpUp",
        frames = { 9, 10 },
        time = 550,
        loopCount = 0
    },
    {
        name = "jumpDown",
        frames = { 11, 12 },
        time = 550,
        loopCount = 0
	}
}

local function heroListener( event )
 
	local thisSprite = event.target  -- "event.target" references the sprite
	--print(math.round(event.target.y))
	--print(hero.isJumping)
end

local function swapSprite()

end

local function scrollBackground(background)
	background.x = 2870
	transition.to( background, { time=60000, alpha=1, x=-960, y=background.y, onComplete=scrollBackground} )
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

		background1 = display.newImageRect( "images/background_run.png", 1920, 1080 )
		background1.x = 960
		background1.y = display.contentCenterY
		transition.to( background1, { time=30000, alpha=1, x=-960, y=background1.y, onComplete=scrollBackground} )

		background2 = display.newImageRect( "images/background_run.png", 1920, 1080 )
		background2.x = background1.x + 1910
		background2.y = display.contentCenterY
		transition.to( background2, { time=60000, alpha=1, x=-960, y=background2.y, onComplete=scrollBackground} )
		

		hero = display.newSprite( sheet_hero, sequences_hero )
		hero.x = 100
		hero.y = 524
		hero.isJumping = false
		physics.addBody( hero, "dynamic", {60, 590, 110, 590, 160, 640, 60, 640} )
		hero.gravityScale = 6
		hero.isFixedRotation = true

		hero:setStrokeColor( 1, 0 ,0 )
		hero.strokeWidth = 1

		hero:addEventListener( "sprite", heroListener )

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
		hero:setSequence( "normalRun" )
		hero:play()
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
