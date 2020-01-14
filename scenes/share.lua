local composer = require( "composer" )

local scene = composer.newScene()

--------------------------------------------------------------------------------------
local json = require( "json") 

local musicTrack
local name
local field
local ShareButton
local nametext
local BackButton
local finalshare 
local MenuButton 
local ShareGroup = display.newGroup()

local function goBack()
    composer.gotoScene( "scenes.dead", { time=400, effect="crossFade" } )
end

local function gotoMenu()
	composer.gotoScene( "scenes.menu", { time=400, effect="crossFade" } )
end

local function Success()
	display.remove(finalshare)
    finalshare = display.newText("Udostępniłeś wynik " .. name .. " !!!\nTwój wynik to " .. _G.finalScore , display.contentCenterX, 360, "fonts/Pixellari.ttf", 64 )
    finalshare:setFillColor( 1, 1, 1 )
    display.remove(field)
    display.remove(ShareButton)
    display.remove(nametext)
    display.remove(BackButton)
    MenuButton = display.newText("Wróć", display.contentCenterX, 570, "fonts/Pixellari.ttf", 64 )
    MenuButton:setFillColor( 1, 1, 1  )
    MenuButton:addEventListener( "tap", gotoMenu)
end

local function networkListener( event )
 
    if ( event.isError ) then
		print( "Network error: ", event.response )
		finalshare = display.newText("Brak połączenia!", display.contentCenterX, 420, "fonts/Pixellari.ttf", 64 )
    	finalshare:setFillColor( 1, 0, 0 )
    else
		print ( "RESPONSE: " .. event.response )
		Success()
    end
end

local function Share()

	name = field.text

    local headers = {}
	headers["Content-Type"] = "application/json"
	local body = {
		["name"] = name,
		["score"] = _G.finalScore,
		["playerId"] = system.getInfo("deviceID")
	}
	local params = {}
	params.headers = headers
	params.body = json.encode(body)
	network.request( "http://mostalecki.pythonanywhere.com/highscores/", "POST", networkListener, params )
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

	local sharescore = display.newText( sceneGroup, "Udostępnij swój wynik!", display.contentCenterX, 180, "fonts/Pixellari.ttf", 112 )
    sharescore:setFillColor( 249/255, 111/255, 41/255 )
    
    nametext = display.newText( sceneGroup, "Wpisz nazwę gracza: ", display.contentCenterX, 270, "fonts/Pixellari.ttf", 64 )
	nametext:setFillColor( 1, 1, 1 )

    field = native.newTextField( display.contentCenterX, 350, 390, 65 )
    field.align = "center"
    field.font = native.newFont( "fonts/Pixellari.ttf", 50 )


	ShareButton = display.newText( sceneGroup, "Udostępnij", display.contentCenterX, 500, "fonts/Pixellari.ttf", 64 )
	ShareButton:setFillColor( 1, 1, 1 )
    ShareButton:addEventListener( "tap", Share)

	BackButton = display.newText( sceneGroup, "Wróć", display.contentCenterX, 570, "fonts/Pixellari.ttf", 64 )
    BackButton:setFillColor( 1, 1, 1  )
    BackButton:addEventListener( "tap", goBack)
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
        display.remove(finalshare)
        display.remove(MenuButton)
	elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        composer.removeScene( "scenes.share" )
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