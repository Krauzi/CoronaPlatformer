
local composer = require( "composer" )
local collisionFilters = require( "plugin.collisionFilters" )

local heroSheet = require( "scenes.heroSheet" )
local barbarianSheet = require( "scenes.barbarianSheet" )
local eagleSheet = require( "scenes.eagleSheet" )


local scene = composer.newScene()
--------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setGravity(0, 6)
physics.setContinuous( false )

--AUDIO
local hitSound
local deathSound

local hero
local heroRunning = heroSheet:getRunningSheet()
local heroSequences = heroSheet:getSequences()
local heroShape = heroSheet:getShape()
local attackField

-- TYMCZASOWO
local barbarianRunning = barbarianSheet:getRunningSheet()
local barbarianSequences = barbarianSheet:getSequences()
local barbarianShape = barbarianSheet:getShape()
local eagleFlying = eagleSheet:getFlyingSheet()
local eagleSequences = eagleSheet:getSequences()
local eagleShape = eagleSheet:getShape()


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
local floorGroup = display.newGroup()
local obstacleGroup = display.newGroup()
local uiGroup = display.newGroup()
local heroGroup = display.newGroup()


local function gotoDead()
	composer.gotoScene( "scenes.dead", { time=400, effect="crossFade" } )
end

local function createObstacle()
	if(died == false) then
		local newObstacle
		local whatObstacle = math.random( 3 )
		local xDelta = math.random(-300, 100)
		if (whatObstacle == 1) then
			newObstacle = display.newImageRect(obstacleGroup, "images/rock.png", 155, 100)
			newObstacle.x = 2050 + xDelta
			newObstacle.y = 642
			newObstacle.myName = "obstacle"

			local rockShape = {  -5,-50, 54,-13, 75,46, -72,46, -64,-10 }
			physics.addBody( newObstacle, "static", { shape=rockShape } )
			transition.to( newObstacle, { time=6000, alpha=1, x=-700+xDelta, y=newObstacle.y, tag="transTag"} )

			
		elseif (whatObstacle == 2) then
			newObstacle = display.newImageRect(obstacleGroup, "images/log1-pix2.png", 220, 110)
			newObstacle.x = 2050 +xDelta
			newObstacle.y = 652
			newObstacle.myName = "obstacle"

			local logShape = {  10,53, -108,11, -76,-55, -56,-55, 46,-21, 103,11, 110,26 }
			physics.addBody( newObstacle, "static", { shape=logShape } )
			transition.to( newObstacle, { time=6000, alpha=1, x=-700+xDelta, y=newObstacle.y, tag="transTag"} )
			
		else
			newObstacle = display.newSprite(heroGroup, barbarianRunning, barbarianSequences )
			newObstacle.x = 2050 + xDelta
			newObstacle.y = floor1.y - 220
			newObstacle.myName = "enemy"

			newObstacle:setSequence( "run" )
			newObstacle:play()

			physics.addBody( newObstacle, "static", { shape=barbarianShape } )
			transition.to( newObstacle, { time=5000, alpha=1, x=-700+xDelta, y=newObstacle.y, tag="transTag"} )
		end
		newObstacle.isFixedRotation = true
		table.insert( obstacleTable, newObstacle )
	end
end

local function spawnEnemy()
	if(died == false) then
		local newEnemy
		--local whatObstacle = math.random( 2 )
		local xDelta = math.random(-300, 100)
		--if (whatObstacle == 1) then
			newEnemy = display.newSprite(heroGroup, barbarianRunning, barbarianSequences )
			newEnemy.x = 2050 + xDelta
			newEnemy.y = floor1.y - 220

			newEnemy:setSequence( "run" )
			newEnemy:play()

			physics.addBody( newEnemy, "static", { shape=barbarianShape } )
			transition.to( newEnemy, { time=6000, alpha=1, x=-700+xDelta, y=newEnemy.y, tag="transTag"} )

			
		--else
		--	newObstacle = display.newImageRect(obstacleGroup, "images/log1-pix2.png", 220, 110)
		--	newObstacle.x = 2050 +xDelta
		--	newObstacle.y = 652

		--	local logShape = {  10,53, -108,11, -76,-55, -56,-55, 46,-21, 103,11, 110,26 }
		--	physics.addBody( newObstacle, "static", { shape=logShape } )
		--	transition.to( newObstacle, { time=6000, alpha=1, x=-700+xDelta, y=newObstacle.y, tag="transTag"} )
		--end
		table.insert( obstacleTable, newEnemy)
		newEnemy.myName = "enemy"
		newEnemy.isFixedRotation = true
	end
end

local function gameLoop()
	-- Dispose of obstacles that drifted off screen
	if(died == false and hitobstacle == false) then
		for i = #obstacleTable, 1, -1 do
			local thisObstacle = obstacleTable[i]
			
			if (thisObstacle.x == nil) then
				table.remove( obstacleTable, i )
			elseif ( thisObstacle.x < -100 or thisObstacle.y > 770) then
				display.remove( thisObstacle )
				table.remove( obstacleTable, i )
			end
		end
	end
end

local function timerScore()
	score = score + 1
	scoreText.text = "Wynik: " .. score 
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

ScoreTiemr = timer.performWithDelay(1000, timerScore, 0)
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
 
	
end

local function finishAttack()
	hero.isAttacking = false
	hero:setSequence( "run" )
	hero:play()
end

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
		if ( event.keyName == "x") then
			if (event.phase == "down" and hero.isAttacking == false) then
				hero.isAttacking = true
				hero:setSequence( "attack" )
				hero:play()
				AttackTimer = timer.performWithDelay(700, finishAttack, 1)
			end
		end
	end
    return false
end

local function heroListener( event )
	local thisSprite = event.target  -- "event.target" references the sprite

	--print("Sprite y: "..math.round(thisSprite.y) .. " isJumping: "..tostring(hero.isJumping))

	print(hero.y)

	if (hero.isJumping == true) then
		if (thisSprite.sequence == "jumpStart" and math.round(thisSprite.y) == 547) then
			hero:setSequence( "jumpUp" )
			hero:play()
		end
	
		if (thisSprite.sequence == "jumpUp" and math.round(thisSprite.y) == 346) then
			hero:setSequence( "jumpPeak" )
			hero:play()
		end
	
		if (thisSprite.sequence == "jumpPeak" and math.round(thisSprite.y) == 351) then
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

local function onAttackCollision( self, event )
	if (event.other.myName == "enemy" and hero.isAttacking == true) then
		display.remove( event.other )
		event.other.isBodyActive = false
	end
end

-- Local (hero) object collision listener
local function onLocalCollision( self, event )
	if ( event.phase == "began" and hitobstacle == false) then
		local obj1 = event.other

		--if (obj1.myName == "attack") then
		--	print("ELO")
		--end

		if ( obj1.myName == "obstacle" or obj1.myName == "enemy") then

			if(obj1.myName == "enemy") then
				if (hero.isAttacking) then
					return false
				else
					display.remove( obj1 )
					obj1.isBodyActive = false
				end
			end

			print("SELF: " .. self.x .. " " .. self.y)
			print("OBJ: " .. obj1.x .. " " .. obj1.y)
			print(tostring(physics.getAverageCollisionPositions()))

			if(lives ~= 0 ) then
				lives = lives - 1
				livesText.text = "Życia: " .. lives

				hitobstacle = true
				obj1.isSensor = true

				visible()

			end

			if (lives > 0) then
				audio.play( hitSound)
			else
				audio.play( deathSound)
			end

			if ( lives == 0 ) then
				died = true
				hero.isSensor = true
				hero:setLinearVelocity( 0, -1000 )
				   
				local loseText = display.newText( uiGroup, "Przegrałeś!", display.contentCenterX, 250, "fonts/Pixellari.ttf", 100 )
				loseText:setFillColor( 249/255, 111/255, 41/255 )

				hero:pause()
				timer.cancel(ScoreTiemr)
				
				-- To tutaj powoduje bug z podwójnym ekranem końcowym
				-- transition.cancel( "transTag")
					   
				timer.performWithDelay( 3000,
					function()
						_G.finalScore = score
						gotoDead()
					end )
			end

			timer.performWithDelay(500,
				function()
					hitobstacle = false
				end )
			end
   end

   return true
end

local function scrollBackground(background)
	background.x = 2870
	transition.to( background, { time=60000, alpha=1, x=-960, y=background.y, onComplete=scrollBackground, tag="transTag"} )
end

local function scrollFloor(floor)
	print(hero.density)
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
	hitSound = audio.loadSound( "audio/hit.wav" )
	deathSound = audio.loadSound( "audio/death.wav" )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	sceneGroup:insert( backGroup )
	sceneGroup:insert( floorGroup )
	sceneGroup:insert( uiGroup ) 
	sceneGroup:insert( obstacleGroup )
	sceneGroup:insert( heroGroup ) 

	died = false
	physics.pause()

	livesText = display.newText( uiGroup, "Życia: " .. lives, 100, 60, "fonts/Pixellari.ttf", 50 )
	scoreText = display.newText( uiGroup, "Wynik: " .. score, 640, 60, "fonts/Pixellari.ttf", 50 )
	score = 0
	lives = 3

	scoreText.text = "Wynik: " .. score
	livesText.text = "Życia: " .. lives 

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
		{ isSensor=true,  shape=heroShape }
	)

	hero.gravityScale = 13

	hero.isFixedRotation = true
	hero.isJumping = false
	hero.isAttacking = false
	hero.myName = "heroName"

	hero.collision = onLocalCollision


	hero:addEventListener( "sprite", heroListener )
	hero:addEventListener( "collision" )

	local attackFieldShape = {0,-50, -100,-100, 30,-100, 60,0, -10,85, 40,85, 0,0}

	attackField = display.newPolygon( hero.x+60, hero.y, attackFieldShape)
	attackField.isVisible = false
	physics.addBody( attackField, "dynamic",
		{ isSensor=true,  shape=attackFieldShape }
	)

	attackField.myName = "attack"
	attackField.isFixedRotation = true
	attackField.collision = onAttackCollision
	attackField:addEventListener( "collision" )

	local pistonJoint = physics.newJoint( "pivot", hero, attackField, hero.x, hero.y, 0, 0 )

	--physics.setDrawMode( "hybrid" )
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

		-- Global collision listener
		Runtime:addEventListener( "collision", onCollision )

		GameLoopTimer = timer.performWithDelay( 1000, gameLoop, 0 )
		ObstacleSpawnTimer = timer.performWithDelay(2000, createObstacle, 0)
		--EnemySpawnTimer = timer.performWithDelay(2500, spawnEnemy, 0)
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		transition.cancel( "transTag" )

		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		Runtime:removeEventListener( "collision", onCollision )
		hero:removeEventListener("collision", onCollision)

		physics.pause()
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
