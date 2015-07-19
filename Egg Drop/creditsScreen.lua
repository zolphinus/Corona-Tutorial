local storyboard = require( "storyboard")
local scene = storyboard.newScene()

local backgroundImage

local btnAnim

local btnSound = audio.loadSound("btnSound.wav")

function scene:createScene( event)
   local screenGroup = self.view
   
   storyboard.removeScene("options")
   
   print( "\ncreditScreen: createScene event")
end

function scene:enterScene( event)
   local screenGroup = self.view
   
   print( "creditsScene: enterScene event")
   
   backgroundImage = display.newImageRect("creditsScreen.png", 480, 320)
   backgroundImage.x = 240; backgroundImage.y = 160
   screenGroup:insert( backgroundImage)
   
   local changeToOptions = function( event)
      if event.phase == "began" then
	   
		 storyboard.gotoScene("options", "crossFade", 300)
	  end
   end
   
   backgroundImage:addEventListener("touch", changeToOptions)
end

function scene:exitScene ()
   
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