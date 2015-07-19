display.setStatusBar( display.HiddenStatusBar)

local hudGroup = display.newGroup()
local gameGroup = display.newGroup()
local levelGroup = display.newGroup()
local stars = display.newGroup()

local physics = require ("physics")

local mCeil = math.ceil
local mAtan2 = math.atan2
local mPi = math.pi
local mSqrt = math.sqrt

local background
local ground
local powerShot
local arrow
local panda
local poof
local starGone
local scoreText
local gameOverDisplay

local gameIsActive = false
local waitingForNewRound
local restartTimer
local counter
local timerInfo
local numSeconds = 30
local counterSize = 50
local gameScore = 0
local starWidth = 30
local starHeight = 30



local startNewRound = function ()
   if panda then
      
	  local activateRound = function()
	  
	     waitingForNewRound = false
		 
		 if restartTimer then
		    timer.cancel( restartTimer)
		 end
		 
		 ground:toFront()
		 panda.x = 240
		 panda.y = 300
		 panda.rotation = 0
		 panda.isVisible = true
		 panda.isBodyActive = true
		 
		 panda:setSequence("set")
		 panda:play()
		 
		 local pandaLoaded = function()
		    
			gameIsActive = true
			panda.inAir = false
			panda.isHit = false
			panda:toFront()
			
			panda.bodyType = "static"
			
		 end
		 
		 transition.to(panda, { time = 1000, y = 255,
		   onComplete = pandaLoaded})
	  end
	  
	  activateRound()
	  
   end
end


local callNewRound = function()
   local isGameOver = false
   
   local pandaGone = function()
      panda:setLinearVelocity(0, 0)
	  panda.bodyType = "static"
	  panda.isVisible = false
	  panda.isBodyActive = false
	  panda.rotation = 0
	  
	  poof.x = panda.x; poof.y = panda.y
	  poof.alpha = 0
	  poof.isVisible = true
	  
	  local fadePoof = function()
	     transition.to(poof, {time = 100, alpha = 0})
	  end
	  transition.to(poof, {time = 50, alpha = 1.0, onComplete = fadePoof})
	  
	  restartTimer = timer.performWithDelay( 300, function()
	    waitingForNewRound = true;
		end, 1)
		
   end
   
   local poofTimer = timer.performWithDelay(500, pandaGone, 1)
   
   if isGameOver == false then
     restartTimer = timer.performWithDelay( 1500, startNewRound, 1)  
   end
end

local setScore = function( scoreNum)
   
   local newScore = scoreNum
   gameScore = newScore
   
   if gameScore < 0 then gameScore = 0; end
   
   scoreText.text = gameScore
   scoreText.xScale = 0.5; scoreText.yScale = 0.5
   scoreText.x = (480 - (scoreText.contentWidth * 0.5)) - 15
   scoreText.y = 20
end

local callGameOver = function()
   gameIsActive = false
   physics.pause()
   
   panda:removeSelf()
   panda = nil
   stars:removeSelf()
   stars = nil
   
   local shade = display.newRect(display.contentWidth /2, display.contentHeight / 2,
     display.contentWidth, display.contentHeight)
   shade:setFillColor(0, 0, 0, 255)
   
   shade.alpha = 0
   
   gameOverDisplay = display.newImage( "gameOverScreen.png")
   gameOverDisplay.x = 240; gameOverDisplay.y = 160
   gameOverDisplay.alpha = 0
   
   hudGroup:insert(shade)
   hudGroup:insert( gameOverDisplay)
   
   transition.to( shade, {time = 200, alpha = 0.65})
   transition.to(gameOverDisplay, {time = 500, alpha = 1})
   
   local newScore = gameScore
   setScore( newScore)
   
   counter.isVisible = false
   
   scoreText.isVisible = false
   scoreText.text = "Score: " .. gameScore
   scoreText.xScale = 0.5; scoreText.yScale = 0.5
   scoreText.x = 280
   scoreText.y = 160
   scoreText:toFront()
   timer.performWithDelay( 1000, function() scoreText.isVisible = true; end, 1)
   
end

local drawBackground = function()

   background = display.newImage("background.png")
   background.x = 240; background.y = 160
   gameGroup:insert(background)
   
   ground = display.newImage("ground.png")
   ground.x = 240; ground.y = 300
   
   local groundShape = { -240, -18, 240, -18, 240, 18, -240, 18}
   physics.addBody(ground, "static", {density = 1.0, bounce = 0,
     friction = 0.5, shape = groundShape})
	 
   gameGroup:insert(ground) 
   
end

local hud = function()
   
   local helpText = display.newImage("help.png")
   helpText.x = 240; helpText.y = 160
   helpText.isVisible = true
   hudGroup:insert(helpText)
   
   timer.performWithDelay(10000, function() helpText.isVisible = false; end, 1)
   
   transition.to(helpText, {delay = 9000, time = 1000, x = -320,
     transition = easing.inOutExpo})
	 
   counter = display.newText( "Time: " .. tostring(numSeconds),
     0, 0, "Helvetica-Bold", counterSize)
   counter:setTextColor( 255, 255, 255, 255)
   counter.xScale = 0.5; counter.yScale = 0.5
   counter.x = 60; counter.y = 15
   counter.alpha = 0
   
   transition.to(counter, {delay = 9000, time = 1000, alpha = 1,
     transition = easing.inOutExpo})
	 
   hudGroup:insert(counter)
   
   scoreText = display.newText( "0", 470, 22, "Helvetica-Bold", 52)
   scoreText:setTextColor(255, 255, 255, 255)
   scoreText.text = gameScore
   scoreText.xScale = 0.5; scoreText.yScale = 0.5
   scoreText.x = (480 - (scoreText.contentWidth * 0.5)) - 15
   scoreText.y = 15
   scoreText.alpha = 0
   
   transition.to( scoreText, {delay = 9000, time = 1000, alpha = 1,
     transition = easing.inOutExpo})
	 
   hudGroup:insert(scoreText)
   
end

local myTimer = function()

   numSeconds = numSeconds - 1
   counter.text = "Time: " .. tostring(numSeconds)
   print(numSeconds)
   
   if numSeconds < 1 or stars.numChildren <= 0 then
     timer.cancel(timerInfo)
	 panda:pause()
	 restartTimer = timer.performWithDelay(300, function()
	   callGameOver(); end, 1)
   end
end

local startTimer = function()

   print("Start Timer")
   timerInfo = timer.performWithDelay( 1000, myTimer, 0)
end

local createPowerShot = function()

   powerShot = display.newImage("glow.png")
   powerShot.xScale = 1.0; powerShot.yScale = 1.0
   powerShot.isVisible = false
   
   gameGroup:insert(powerShot)
end

local createPanda = function()

   local onPandaCollision = function(self, event)
   
      if event.phase == "began" then
	     
		 if panda.isHit == false then
		 
		    panda.isHit = true
			
			if event.other.myName == "star" then
			   callNewRound(true, "yes")
			else
			   callNewRound(true, "no")
			end
			
			if event.other.myName == "wall" then
			   callNewRound(true, "yes")
			else
			   callNewRound(true, "no")
			end
			
		 elseif panda.isHit then
		    return true
		 end
	  end
   end
   
   arrow = display.newImage("arrow.png")
   arrow.x = 240; arrow.y = 225
   arrow.isVisible = false
   
   gameGroup:insert( arrow)
   
   local options =
   {
      width = 128,
	  height = 128,
	  numFrames = 5
   }
   
   local pandaSheet = graphics.newImageSheet("pandaSprite.png", options)
   
   local pandaSequenceData =
   {
      {
	     name = "set",
		 start = 1,
		 count = 2,
		 time = 200,
		 loopCount = 0
	  },
	  
	  {
	     name = "crouch",
		 start = 3,
		 count = 1,
		 time = 1,
		 loopCount = 0
	  },
	  
	  {
	     name = "air",
		 start = 4,
		 count = 2,
		 time = 100,
		 loopCount = 0
	  }
	  
   }
   
   
   panda = display.newSprite(pandaSheet, pandaSequenceData)
   
   panda:setSequence("set")
   panda:play()
   
   panda.x = 240; panda.y = 225
   panda.isVisible = false
   
   panda.isReady = false
   panda.inAir = false
   panda.isHit = false
   panda.isBullet = true
   panda.trailNum = 0
   
   panda.radius = 12
   physics.addBody(panda, "static", {density = 1.0, bounce = 0.4, friction = 0.15,
     radius = panda.radius})
   panda.rotation = 0
   
   panda.collision = onPandaCollision
   panda:addEventListener("collision", panda)
   
   poof = display.newImage("poof.png")
   poof.alpha = 1.0
   poof.isVisible = false
   
   gameGroup:insert(panda)
   gameGroup:insert(poof)
end

local onStarCollision = function(self, event)

   if event.phase == "began" and self.isHit == false then
   
      self.isHit = true
	  print("star destroyed")
	  self.isVisible = false
	  self.isBodyActive = false
	  
	  stars.numChildren = stars.numChildren - 1
	  
	  if stars.numChildren < 0 then
	    stars.numChildren = 0
	  end
	  
	  self.parent:remove(self)
	  self = nil
	  
	  local newScore = gameScore + 500
	  setScore(newScore)
   end
end

local onScreenTouch = function(event)
   
   if gameIsActive then
     
	 if event.phase == "began" and panda.inAir == false then
	    
		panda.y = 225
		panda.isReady = true
		powerShot.isVisible = true
		powerShot.alpha = 0.75
		powerShot.x = panda.x; powerShot.y = panda.y
		powerShot.xScale = 0.1; powerShot.yScale = 0.1
		
		arrow.isVisible = true
		
		panda:setSequence("crouch")
		panda:play()
		
	 elseif event.phase == "ended" and panda.isReady then
	 
	    local fling = function()
		
		   powerShot.isVisible = false
		   arrow.isVisible = false
		   
		   local x = event.x
		   local y = event.y
		   
		   local xForce = (panda.x - x) * 4
		   local yForce = (panda.y - y) * 4
		   
		   panda:setSequence("air")
		   panda:play()
		   
		   panda.bodyType = "dynamic"
		   panda:applyForce(xForce, yForce, panda.x, panda.y)
		   panda.isReady = false
		   panda.inAir = true
		   
		end
		
		transition.to(powerShot, {time = 175, xScale = 0.1,
		  yScale = 0.1, onComplete = fling})
		  
	 end
	 
	 if powerShot.isVisible == true then
	    local xOffset = panda.x
		local yOffset = panda.y
		
		local distanceBetween = mCeil(mSqrt( ((event.y - yOffset) ^ 2) +
		  ((event.x - xOffset) ^ 2) ))
		  
		powerShot.xScale = -distanceBetween * 0.02
		powerShot.yScale = -distanceBetween * 0.02
		
		local angleBetween = mCeil(mAtan2( (event.y - yOffset),
		  (event.x - xOffset) ) * 180 / mPi) + 90
		  
		panda.rotation = angleBetween + 180
		arrow.rotation = panda.rotation
	 end
	 
   end
end

local reorderLayers = function()

   gameGroup:insert(levelGroup)
   ground:toFront()
   panda:toFront()
   poof:toFront()
   hudGroup:toFront()
   
end

local createStars = function()
   
   local numOfRows = 4
   local numOfColumns = 12
   
   local starPlacement = {x = (display.contentWidth * 0.5) -
     (starWidth * numOfColumns) /2 + 10, y = 50}
	 
   for row = 0, numOfRows - 1 do
      for column = 0, numOfColumns - 1 do
	  
	     local star = display.newImage("star.png")
		 star.name = "star"
		 star.isHit = false
		 star.x = starPlacement.x + (column * starWidth)
		 star.y = starPlacement.y + (row * starHeight)
		 physics.addBody(star, "static", {density = 1, friction = 0,
		   bounce = 0})
		 stars.insert(stars, star)
		 
		 star.collision = onStarCollision
		 star:addEventListener("collision", star)
		 
		 local function starAnimation()
		    local starRotation = function()
			   transition.to(star, {time = 1000, rotation = 1080,
			     onComplete = starAnimation})
			end
			
			transition.to(star, {time = 1000, rotation = -1080,
			     onComplete = starAnimation})
		 end
		 
		 starAnimation()
		 
	  end
   end
   
   local leftWall = display.newRect (0, 0, 0, display.contentHeight)
   leftWall.name = "wall"
   
   local rightWall = display.newRect (display.contentWidth, 0, 0, display.contentHeight)
   rightWall.name = "wall"
   
   physics.addBody(leftWall, "static", {bounce = 0.0, friction = 10})
   physics.addBody(rightWall, "static", {bounce = 0.0, friction = 10})
   
   reorderLayers()
end

local gameInit = function()

   physics.start(true)
   physics.setGravity(0, 9.8)
   
   drawBackground()
   createPowerShot()
   createPanda()
   createStars()
   hud()
   
   Runtime:addEventListener("touch", onScreenTouch)
   
   local gameTimer = timer.performWithDelay(10000, function()
     startNewRound(); end, 1)
   local gameTimer = timer.performWithDelay(10000, function()
     startTimer(); end, 1)
   
end

gameInit()