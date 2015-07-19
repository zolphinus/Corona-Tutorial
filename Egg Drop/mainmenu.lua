local storyboard = require( "storyboard")
local scene = storyboard.newScene()

local ui = require("ui")
local gameNetwork = require( "gameNetwork" )

local btnAnim

local btnSound = audio.loadSound("btnSound.wav")


function scene:createScene( event)
   local screenGroup = self.view
   storyboard.removeScene("maingame")
   storyboard.removeScene("options")
   
   print( "\nmainmenu: createScene event")
end

function scene:enterScene( event)
   local screenGroup = self.view
   
   print( "mainmenu: enterScene event")
   
   local backgroundImage = display.newImageRect("mainMenuBG.png", 480, 320)
   backgroundImage.x = 240; backgroundImage.y = 160
   screenGroup:insert( backgroundImage)
   
   local playBtn
   local onPlayTouch = function( event)
      if event.phase == "release" then
	     
		 audio.play(btnSound)
		 storyboard.gotoScene("loadgame", "fade", 300)
	  end
   end
   
   playBtn = ui.newButton
   {
      defaultSrc = "playbtn.png",
	  defaultX = 100,
	  defaultY = 100,
	  overSrc = "playbtn-over.png",
	  overX = 100,
	  overY = 100,
	  onEvent = onPlayTouch,
	  id = "PlayButton",
	  text = "",
	  font = "Helvetica",
	  textColor = {255, 255, 255, 255},
	  size = 16,
	  emboss = false
   }
   
   playBtn.x = 240; playBtn.y = 440
   screenGroup:insert(playBtn)
   
   btnAnim = transition.to(playBtn, {time = 500, y = 260,
     transition = easing.inOutExpo})
	 
   
   local optBtn
      
   local onOptionsTouch = function( event)
	  if event.phase == "release" then
 	 
 		 audio.play(btnSound)
 		 storyboard.gotoScene( "options", "crossFade", 300)
 		
 	 end
   end
   
   optBtn = ui.newButton
   {
      defaultSrc = "optbtn.png",
	  defaultX = 60,
	  defaultY = 60,
	  overSrc = "optbtn-over.png",
	  overX = 60,
	  overY = 60,
	  onEvent = onOptionsTouch,
	  id = "OptionsButton",
	  text = "",
	  font = "Helvetica",
	  textColor = {255, 255, 255, 255},
	  size = 16,
	  emboss = false
   }
   
   optBtn.x = 430; optBtn.y = 440
   screenGroup:insert(optBtn)
   
   btnAnim = transition.to( optBtn, {time = 500, y = 280,
     transition = easing.inOutExpo})
	 
   local gpBtn
   
   local onGPTouch = function( event)
      if event.phase == "release" then
	     
		 
		 print("trying to show boards")
		audio.play(btnSound)
		print("attempting to set high score here")
		
		local function requestCallback( event )

			if ( event.type == "setHighScore" ) then
				--high score has been set
				print("77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777")
			end
		end

		gameNetwork.request( "setHighScore",
			{
			
				localPlayerScore = { category="CgkIzbzr7OUMEAIQCA", value= 100 },
				listener = requestCallback
			}
		)
		print("high score should be set")
		
		gameNetwork.show( "leaderboards" )
		 
		 print("leader board closed")
	  end
   end
   
   gpBtn = ui.newButton
   {
      defaultSrc = "ofbtn.png",
	  defaultX = 60,
	  defaultY = 60,
	  overSrc = "ofbtn-over.png",
	  overX = 60,
	  overY = 60,
	  onEvent = onGPTouch,
	  id = "GPButton",
	  text = "",
	  font = "Helvetica",
	  textColor = {255, 255, 255, 255},
	  size = 16,
	  emboss = false
   }
   
   gpBtn.x = 50; gpBtn.y = 440
   screenGroup:insert(gpBtn)
   
   btnAnim = transition.to( gpBtn, {time = 500, y = 280,
     transition = easing.inOutExpo})
	 
end

function scene:exitScene ()
   if btnAnim then transition.cancel( btnAnim ); end
   
   print( "mainmenu: exitScene event")
end

function scene:destroyScene()
   print( "((destroying mainmenu's view))")
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)
return scene