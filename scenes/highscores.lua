local composer = require( "composer" )

local scene = composer.newScene()

--------------------------------------------------------------------------------------
local json = require( "json") 

local musicTrack
local MenuButton 
local topText
local scores
local HighscoresGroup = display.newGroup()

local function gotoMenu()
	composer.gotoScene( "scenes.menu", { time=400, effect="crossFade" } )
end

local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function Success(jsonTable)

	local decoded, pos, msg = json.decode( jsonTable )
	if not decoded then
		print( "Decode failed at "..tostring(pos)..": "..tostring(msg) )
		display.remove(topText)
		topText = display.newText("Błąd serwera!", display.contentCenterX, 100, "fonts/Pixellari.ttf", 64 )
    	topText:setFillColor( 1, 0, 0 )
	else
		display.remove(topText)
		topText = display.newText("Najlepsze wyniki:", display.contentCenterX, 100, "fonts/Pixellari.ttf", 64 )
		topText:setFillColor( 1, 1, 0 )
		
		local scoresString = ""
		local count = 0
		for k, v in pairs(decoded) do
			print(k, v.name, v.score, v.playerId)
			scoresString = scoresString .. k .. ". " .. v.name .. " " .. v.score .. "\n"
			count = count + 1
		end
		scores = display.newText(scoresString, display.contentCenterX, display.contentCenterY, "fonts/Pixellari.ttf", 40 )
    		scores:setFillColor( 1, 1, 1 )
	end

	
end

local function networkListener( event )
 
    if ( event.isError ) then
		print( "Network error: ", event.response )
		topText = display.newText("Brak połączenia!", display.contentCenterX, 100, "fonts/Pixellari.ttf", 64 )
    	topText:setFillColor( 1, 0, 0 )
    else
		print ( "RESPONSE: " .. event.response )
		Success(event.response)
    end
end

local function FetchHighscores()

    local headers = {}
	headers["Content-Type"] = "application/json"
	local params = {}
	params.headers = headers
	network.request( "http://mostalecki.pythonanywhere.com/highscores/", "GET", networkListener, params )
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


	MenuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 600, "fonts/Pixellari.ttf", 64 )
    MenuButton:setFillColor( 1, 1, 1  )
	MenuButton:addEventListener( "tap", gotoMenu)
	
	FetchHighscores()
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
		display.remove(MenuButton)
		display.remove(topText)
		display.remove(scores)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "scenes.highscores" )
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