local storyboard = require( "storyboard")
local scene = storyboard.newScene()

local myTimer
local loadingImage

function scene:createScene( event)
   local screenGroup = self.view
   
   print( "\nloadmainmenu: createScene event")
end

function scene:enterScene( event)
   local screenGroup = self.view
   
   print( "loadmainmenu: enterScene event")
   
   loadingImage = display.newImageRect("loading.png", 480, 320)
   loadingImage.x = 240; loadingImage.y = 160
   screenGroup:insert( loadingImage)
   
   local goToMenu = function ()
      storyboard.gotoScene( "mainmenu", "zoomOutInFadeRotate", 500)
   end
   myTimer = timer.performWithDelay(1000, goToMenu, 1)
end

function scene:exitScene ()
   if myTimer then timer.cancel (myTimer); end
   
   print( "loadmainmenu: exitScene event")
end

function scene:destroyScene()
   print( "((destroying loadmainmenu's view))")
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)
return scene