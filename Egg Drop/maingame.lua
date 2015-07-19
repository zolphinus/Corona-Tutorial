local storyboard = require ("storyboard")
local scene = storyboard.newScene()

local physics = require "physics"
local ui = require ("ui")
local gameNetwork = require ("gameNetwork")

local background
local ground
local charObject
local friedEgg
local scoreText
local eggText
local livesText
local shade
local gameOverScreen
local highScoreText
local highScore

local pauseBtn
local pauseBG
local menuBtn

local gameIsActive = false
local startDrop
local gameLives = 3
local gameScore = 0
local eggCount = 0
local mRand = math.random

local eggDensity = 1.0
local eggShape = { -12,-13, 12,-13, 12,13 , -12,13}
local panShape = { 15,-13 , 65,-13 , 65,-13 , 15,13}

system.setAccelerometerInterval(100)
local eggCaughtSound = audio.loadSound("friedEgg.wav")
local gameOverSound = audio.loadSound("gameover.wav")
local btnSound = audio.loadSound( "btnSound.wav")

local saveValue = function( strFilename, strValue)

   local theFile = strFilename
   local theValue = strValue
   
   local path = system.pathForFile(theFile, system.DocumentsDirectory)
	 
   local file = io.open(path, "w+")
   if file then
   
      file:write(theValue)
	  io.close(file)
   end
end

local loadValue = function( strFilename)

   local theFile = strFilename
   
   local path = system.pathForFile( theFile, system.DocumentsDirectory)
   
   local file = io.open(path, "r")
   if file then
      
	  local contents = file:read("*a")
	  io.close(file)
	  return contents
   else
      file = io.open(path, "w")
	  file:write("0")
	  io.close(file)
	  return "0"
   end
end

function scene:createScene(event)
   local gameGroup = self.view
   
   storyboard.removeScene("loadgame")
   print( "\nmaingame: createScene event")
end

function scene:enterScene(event)
   local gameGroup = self.view
   print( "maingame: enterScene event")
   
   local gameActivate = function()
	   gameIsActive = true
	   pauseBtn.isVisible = true
	   pauseBtn.isActive = true
	end
	
	local moveChar = function(event)

	   charObject.x = display.contentCenterX -
		 (display.contentCenterX * (event.yGravity * 3))
	   
	   if((charObject.x - charObject.width * 0.5) < 0) then
		  charObject.x = charObject.width * 0.5
	   elseif((charObject.x + charObject.width * 0.5) > display.contentWidth) then
		  charObject.x = display.contentWidth - charObject.width * 0.5
	   end
	end
	
	local setScore = function(scoreNum)
		local newScore = scoreNum
	   gameScore = newScore
	   if gameScore < 0 then gameScore = 0; end
	   
	   scoreText.text = "Score: " .. gameScore
	   scoreText.xScale = 0.5; scoreText.yScale = 0.5
	   scoreText.x = (scoreText.contentWidth * 0.5) + 15
	   scoreText.y = 15
	end

	local callGameOver = function()
	   audio.play( gameOverSound)
	   gameIsActive = false
	   physics.pause()
	   
	   
	   pauseBtn.isActive = false
	   pauseBtn.isVisible = false
	   
	   shade = display.newRect(0, 0, 570, 320)
	   shade:setFillColor(0, 0, 0, 255)
	   shade.x = 240; shade.y = 160
	   shade.alpha = 0
	   
	   gameOverScreen = display.newImageRect("gameOver.png", 400, 300)
	   local newScore = gameScore
	   setScore( newScore)
	   gameOverScreen.x = 240; gameOverScreen.y = 160
	   gameOverScreen.alpha = 0
	   gameGroup:insert(shade)
	   gameGroup:insert(gameOverScreen)
	   transition.to(shade, {time = 200, alpha = 0.65})
	   transition.to(gameOverScreen, {time = 500, alpha = 1})
	   
	   scoreText.isVisible = false
	   scoreText.text = "Score: " .. gameScore
	   scoreText.xScale = 0.5; scoreText.yScale = 0.5
	   scoreText.x = 240
	   scoreText.y = 160
	   scoreText:toFront()
	   timer.performWithDelay(0,
		 function() scoreText.isVisible = true; end, 1)
		 
	   local newHighScore = false
	   
	   if gameScore > highScore then
		  highScore = gameScore
		  local highScoreFilename = "highScore.data"
		  saveValue(highScoreFilename, tostring(highScore))
		  local function requestCallback( event )

				if ( event.type == "setHighScore" ) then
					--high score has been set
					print("77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777")
				else
				   print("88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888")
				   print("88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888")
				   print("88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888")
				   print("88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888")
				   
				end
			end

			gameNetwork.request( "setHighScore",
				{
				
					localPlayerScore = { category="CgkIzbzr7OUMEAIQCA", value= highScore },
					listener = requestCallback
				}
			)
		  
	   end
	   
	   highScoreText = display.newText( "Best Game Score: " .. tostring(highScore),
		 0, 0, "Arial", 30)
	   highScoreText:setTextColor(255, 255, 255, 255)
	   highScoreText.xScale = 0.5; highScoreText.yScale = 0.5
	   highScoreText.x = 240; highScoreText.y = 120
	   
	   gameGroup:insert(highScoreText)
	   
	   local onMenuTouch = function(event)
		  if event.phase == "release" then
			 
			 audio.play(btnSound)
			 storyboard.gotoScene("mainmenu", "fade", 500)
		  end
	   end
	   
	   
	   
	   menuBtn = ui.newButton{
		  defaultSrc = "menubtn.png",
		  defaultX = 60,
		  defaultY = 60,
		  overSrc = "menubtn-over.png",
		  overX = 60,
		  overY = 60,
		  onEvent = onMenuTouch,
		  id = "MenuButton",
		  text = "",
		  font = "Helvetica",
		  textColor = {255, 255, 255, 255},
		  size = 16,
		  emboss = false
	   }
	   
	   menuBtn.x = 100; menuBtn.y = 260
	   
	   gameGroup:insert(menuBtn)
	   
	   
	end
	
	local drawBackground = function()
	   
	   background = display.newImageRect( "bg.png", 480, 320)
	   background.x = 240; background.y = 160
	   gameGroup:insert( background)
	   
	   ground = display.newImageRect( "grass.png", 480, 75)
	   ground.x = 240; ground.y = 325
	   ground.myName = "ground"
	   local groundShape = { -285,-18, 285,-18 , 285,18 , -285,18}
	   physics.addBody(ground, "static", {density = 1.0, bounce = 0,
		 friction = 0.5, shape = groundShape})
	   gameGroup:insert(ground)
	end

	local hud = function()

	   eggText = display.newText( "Caught: " .. eggCount, 0, 0, "Arial", 45)
	   eggText:setTextColor(255, 255, 255, 255)
	   eggText.xScale = 0.5; eggText.yScale = 0.5
	   eggText.x = (480 - (eggText.contentWidth * 0.5)) - 15
	   eggText.y = 305
	   gameGroup:insert( eggText )
	   
	   livesText = display.newText( "Lives: " .. gameLives, 0, 0, "Arial", 45)
	   livesText:setTextColor(255, 255, 255, 255)
	   livesText.xScale = 0.5; livesText.yScale = 0.5
	   livesText.x = (480 - (livesText.contentWidth * 0.5)) -15
	   livesText.y = 15
	   gameGroup:insert( livesText)
	   
	   scoreText = display.newText( "Score: " .. gameScore, 0, 0, "Arial", 45)
	   scoreText:setTextColor(255, 255, 255, 255)
	   scoreText.xScale = 0.5; scoreText.yScale = 0.5
	   scoreText.x = (scoreText.contentWidth * 0.5) + 15
	   scoreText.y = 15
	   gameGroup:insert(scoreText)
	   
	   local onPauseTouch = function( event)
	   
		  if event.phase == "release" and pauseBtn.isActive then
		  
			 audio.play(btnSound)
			 
			 if gameIsActive then
			 
				gameIsActive = false
				physics.pause()
				
				local function pauseGame()
				
				   timer.pause(startDrop)
				   print("timer has been paused")
				end
				timer.performWithDelay(1, pauseGame)
				
				 if not shade then
					shade = display.newRect(0, 0, 570, 380)
					shade:setFillColor(0, 0, 0, 255)
					shade.x = 240; shade.y = 160
					gameGroup:insert(shade)
				 end
				 shade.alpha = 0.5
				 
				 if pauseBG then
					pauseBG.isVisible = true
					pauseBG.isActive = true
					pauseBG:toFront()
				 end
				 
				 pauseBtn:toFront()
			 else
			 
				if shade then
				   display.remove(shade)
				   shade = nil
				end
				
				if pauseBG then
				   pauseBG.isVisible = false
				   pauseBG.isActive = false
				end
				
				gameIsActive = true
				physics.start()
				
				local function resumeGame()
				   timer.resume(startDrop)
				   print("timer has been removed")
				end
				timer.performWithDelay(1, resumeGame)
			 end
			 
		  end
	   end
	   
	   pauseBtn = ui.newButton{
		  defaultSrc = "pausebtn.png",
		  defaultX = 44,
		  defaultY = 44,
		  overSrc = "pausebtn-over.png",
		  overX = 44,
		  overY = 44,
		  onEvent = onPauseTouch,
		  id = "PauseButton",
		  text = "",
		  font = "Helvetica",
		  textColor = {255, 255, 255, 255},
		  size = 16,
		  emboss = false
	   }
	   
	   pauseBtn.x = 38; pauseBtn.y = 288
	   pauseBtn.isVisible = false
	   pauseBtn.isActive = false
	   
	   gameGroup:insert(pauseBtn)
	   
	   pauseBG = display.newImageRect("pauseoverlay.png", 480, 320)
	   pauseBG.x = 240; pauseBG.y = 160
	   pauseBG.isVisible = false
	   pauseBG.isActive = false
	   
	   gameGroup:insert(pauseBG)
	end

	local livesCount = function()
	   gameLives = gameLives - 1
	   livesText.text = "Lives: " .. gameLives
	   livesText.xScale = 0.5; livesText.yScale = 0.5
	   
	   livesText.x = (480 - (livesText.contentWidth * 0.5)) - 15
	   livesText.y = 15
	   print(gameLives .. "eggs left")
	   if gameLives < 1 then
	      Runtime:removeEventListener("accelerometer", moveChar)
		  callGameOver()
	   end
	end

	local createChar = function()

	   local charOptions =
	   {
		  width = 128,
		  height = 128,
		  numFrames = 4
	   }
	   local characterSheet = graphics.newImageSheet("charSprite.png", charOptions)
	   
	   local charSequenceData =
	   {
		  {
			 name = "move",
			 start = 1,
			 count = 4,
			 time = 400,
			 loopCount = 0
		  }
	   }
	   
	   charObject = display.newSprite(characterSheet, charSequenceData)
	   charObject:setSequence("move")
	   charObject:play()
	   
	   charObject.x = 240; charObject.y = 250
	   physics.addBody( charObject, "static", {density = 1.0,
		 bounce = 0.4, friction = 0.15, shape = panShape})
	   charObject.rotation = 0
	   charObject.isHit = false
	   charObject.myName = "character"
	   
	   friedEgg = display.newImageRect("friedEgg.png", 40, 23)
	   friedEgg.alpha = 1.0
	   friedEgg.isVisible = false
	   gameGroup:insert( charObject)
	   gameGroup:insert( friedEgg)
	end

	local onEggCollision = function( self, event )

	  if event.force > 1 and not self.isHit then
	 
		 audio.play( eggCaughtSound)
		 
		 self.isHit = true
		 print( "Egg destroyed!")
		 self.isvisible = false
		 friedEgg.x = self.x; friedEgg.y = self.y
		 friedEgg.alpha = 0
		 friedEgg.isVisible = true
		 
		 local fadeEgg = function()
			transition.to(friedEgg, {time = 500, alpha = 0})
		 end
		 transition.to(friedEgg, {time = 50, alpha = 1.0, 
		   onComplete = fadeEgg})
		 self.parent:remove( self)
		 self = nil
		 
		 if event.other.myName == "character" then
		 
			eggCount = eggCount + 1
			eggText.text = "Caught: " .. eggCount
			eggText.xScale = 0.5; eggText.yScale = 0.5
			eggText.x = (480 - (eggText.contentWidth * 0.5)) - 15
			eggText.y = 305
			print("egg caught")
			local newScore = gameScore + 500
			setScore( newScore)
		 elseif event.other.myName == "ground" then
			livesCount()
			print("ground hit")
		 end
		 
		 if gameLives < 1 then
			timer.cancel(startDrop)
			print("timer cancelled")
		 end
		 
		 if eggCount == 1 then
		    gameNetwork.request("unlockAchievement", "CY_w895w9w55w454")
		 end
	  end
	end

	local eggDrop = function()

	   local egg = display.newImage( "egg.png", 26, 30)
	   egg.x = 240 + mRand( 120); egg.y = -100
	   egg.isHit = false
	   physics.addBody( egg, "dynamic", {density = eggDensity,
		 bounce = 0, friction = 0.5, shape = eggShape})
	   egg.isFixedRotation = true
	   gameGroup:insert(egg)
	   
	   egg.postCollision = onEggCollision
	   egg:addEventListener("postCollision", egg)
	end

	local eggTimer = function()
	   startDrop = timer.performWithDelay( 1000, eggDrop, 0)
	end


	local gameStart = function()
	   physics.start(true)
	   physics.setGravity(0, 9.8)
	   
	   local highScoreFilename = "highScore.data"
	   local loadedHighScore = loadValue(highScoreFilename)
	   
	   highScore = tonumber(loadedHighScore)
	   
	   drawBackground()
	   createChar()
	   eggTimer()
	   hud()
	   gameActivate()
	   Runtime:addEventListener("accelerometer", moveChar)
	end

	gameStart()
	
end








function scene:exitScene(event)
   print( "maingame: exitScene event")
end

function scene:destroyScene(event)
   print( "((destroying maingame's view))" )
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene