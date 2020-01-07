
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

local died = false
local hitobstacle = false
local lives = 3
local score = 0
_G.finalScore = 0
local livesText
local scoreText
local backGroup = display.newGroup()
local obstacleGroup = display.newGroup()
local uiGroup = display.newGroup()
local floorGroup = display.newGroup()
local heroGroup = display.newGroup()


local function gotoDead()
	composer.gotoScene( "scenes.dead", { time=400, effect="crossFade" } )
end

local function createObstacle()
	if(died == false) then
		local newObstacle = display.newImageRect(obstacleGroup, "images/rock.png", 155, 100)
		--newObstacle.strokeWidth = 3
		--newObstacle:setFillColor( 0.5 )
		--newObstacle:setStrokeColor( 0, 0, 1 )
		newObstacle.x = 2050
		newObstacle.y = 642
		local rockShape = {  -5,-50, 54,-13, 75,46, -75,46, -64,-20, -17,-20, -5,-50 }
		physics.addBody( newObstacle, "static", { shape=rockShape } )
		--newObstacle:setLinearVelocity(-600, 0)
		transition.to( newObstacle, { time=6000, alpha=1, x=-700, y=newObstacle.y, tag="transTag"} )
		table.insert( obstacleTable, newObstacle )
		newObstacle.myName = "obstacle"
		newObstacle.isFixedRotation = true
	end
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
	if(died == false and hitobstacle == false) then
		for i = #obstacleTable, 1, -1 do
			local thisObstacle = obstacleTable[i]
	
			if ( thisObstacle.x < -100 or thisObstacle.y > 770) then
				display.remove( thisObstacle )
				table.remove( obstacleTable, i )
			end
		end
	end
end

local function timerScore()
	score = score + 1
	scoreText.text = "Score: " .. score 
end

--Hero stay on position after hit an obstacle
local function stay()
	if(died == false) then
		if(hero.x < 100 or hero.x > 100) then
			hero.x = 100
		end
	end
end

--check hero LinearVelocity
local function checkrun()
	if(died == false) then
		local x = hero:getLinearVelocity()
		if(math.floor(hero.y) > 527 and (x < 0 or x > 0)) then
			hero:setLinearVelocity(0, 0)
		end
	end
end

scoreTimer = timer.performWithDelay(1000, timerScore, 0)
timer.performWithDelay(500, stay, 0)
timer.performWithDelay(1000, checkrun, 0)

local function visible()
	timer.performWithDelay(100, 
		function() 
			hero.isVisible = false
		end )
	timer.performWithDelay(200, 
		function() 
			hero.isVisible = true			
		end )
	timer.performWithDelay(300, 
		function() 
			hero.isVisible = false
		end )
	timer.performWithDelay(400, 
		function() 
			hero.isVisible = true
		end )
	timer.performWithDelay(500, 
		function() 
			hero.isVisible = false
		end )
	timer.performWithDelay(600, 
		function() 
			hero.isVisible = true
		end )
	timer.performWithDelay(700, 
		function() 
			hero.isVisible = false
		end )
	timer.performWithDelay(800, 
		function() 
			hero.isVisible = true
		end )
end

local function onCollision( event )
 
	if ( event.phase == "began" ) then
		 if(hitobstacle == false) then

			local obj1 = event.object1
			local obj2 = event.object2
		
			if ( ( obj1.myName == "obstacle" and obj2.myName == "heroName" ) or ( obj1.myName == "heroName" and obj2.myName == "obstacle" ) )then
				
					lives = lives - 1
					livesText.text = "Lives: " .. lives
				
				if(lives ~= 0 ) then
					if(obj1.myName == "obstacle") then
						hitobstacle = true
						obj1.isSensor = true
						visible()
					end

					if(obj2.myName == "obstacle") then
						hitobstacle = true
						obj2.isSensor = true
						visible()
					end
				end
				if ( lives == 0 ) then
					died = true
					hero.isSensor = true
					hero:setLinearVelocity( 0, -1000 )
					

					local loseText = display.newText( uiGroup, "Przegrałeś!", display.contentCenterX, 250, "fonts/Pixellari.ttf", 100 )
						loseText:setFillColor( 249/255, 111/255, 41/255 )

						Runtime:removeEventListener("collision", onCollision)
						transition.cancel( "transTag" )
						timer.cancel(scoreTimer)
						hero:pause()
						
					timer.performWithDelay( 3000, 
					function() 
						_G.finalScore = score;
						gotoDead()
					end )
				end

				timer.performWithDelay(500, 
				function() 
					hitobstacle = false
				end )
			end
		end
	end
	return true
end

Runtime:addEventListener( "collision", onCollision )

local function onKeyEvent( event )
	-- Jumping
	if(died == false) then 
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
	transition.to( background, { time=60000, alpha=1, x=-960, y=background.y, onComplete=scrollBackground, tag="transTag"} )
end

local function scrollFloor(floor)
	--floor.x = 2050
	if (floor == floor1) then
		floor.x = floor2.x + 1370
	else
		floor.x = floor1.x + 1370
	end
	transition.to( floor, { time=6000, alpha=1, x=-700, y=floor.y, onComplete=scrollFloor, tag="transTag"} )
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( backGroup )
	sceneGroup:insert( uiGroup ) 
	sceneGroup:insert( obstacleGroup )
	sceneGroup:insert( floorGroup )
	sceneGroup:insert( heroGroup ) 

	died = false
	physics.pause()

	livesText = display.newText( uiGroup, "Lives: " .. lives, 100, 60, "fonts/Pixellari.ttf", 50 )
	scoreText = display.newText( uiGroup, "Score: " .. score, 640, 60, "fonts/Pixellari.ttf", 50 )
	score = 0
	lives = 3
	scoreText.text = "Score: " .. score
	livesText.text = "Lives: " .. lives 

	background1 = display.newImageRect( backGroup, "images/background_run.png", 1920, 1080 )
	background1.x = 960
	background1.y = display.contentCenterY
	transition.to( background1, { time=30000, alpha=1, x=-960, y=background1.y, onComplete=scrollBackground, tag="transTag"} )

	background2 = display.newImageRect(backGroup,  "images/background_run.png", 1920, 1080 )
	background2.x = background1.x + 1910
	background2.y = display.contentCenterY
	transition.to( background2, { time=60000, alpha=1, x=-960, y=background2.y, onComplete=scrollBackground, tag="transTag"} )
		
	floor1 = display.newImageRect(floorGroup, "images/platform.png", 1400 , 305)
	floor1.x = 700
	floor1.y = 800
	floor1.id = "ground"
	
	local floorShape = { -700,-125, 700,-125, 700,152, -700,152 }
	physics.addBody( floor1, "static", {shape=floorShape, bounce=0.0 } )
	transition.to( floor1, { time=3000, alpha=1, x=-700, y=floor1.y,  onComplete=scrollFloor, tag="transTag"} )

	floor2 = display.newImageRect(floorGroup, "images/platform.png", 1400 , 305)
	floor2.x = 2070
	floor2.y = 800
	floor2.id = "ground"
	physics.addBody( floor2, "static", { shape=floorShape, bounce=0.0 } )
	transition.to( floor2, { time=6000, alpha=1, x=-700, y=floor1.y,  onComplete=scrollFloor, tag="transTag"} )
	
	-- Create hero
	hero = display.newSprite(heroGroup, heroRunning, heroSequences )
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
	hero.myName = "heroName"

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
		composer.removeScene( "scenes.game" )
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
