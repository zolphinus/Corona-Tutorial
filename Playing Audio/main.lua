local ui = require("ui")

local backgroundSound = audio.loadStream("song2.mp3")

local myMusic

local onPlayTouch = function( event)

   if event.phase == "release" then
   
      myMusic = audio.play(backgroundSound, {channel = 1,
	    loops = -1})
   end
end

playBtn = ui.newButton
{
   defaultSrc = "playbtn.png",
   defaultX = 100,
   defaultY = 50,
   overSrc = "playbtn-over.png",
   overX = 100,
   overY = 50,
   onEvent = onPlayTouch,
   id = "PlayButton",
   text = "",
   font = "Helvetica",
   textColor = {255, 255, 255, 255},
   size = 16,
   emboss = false
}

playBtn.x = 160; playBtn.y = 100


local onPauseTouch = function( event)

   if event.phase == "release" then
   
      myMusic = audio.pause(backgroundSound)
	  print("pause")
   end
end

pauseBtn = ui.newButton
{
   defaultSrc = "pausebtn.png",
   defaultX = 100,
   defaultY = 50,
   overSrc = "pausebtn-over.png",
   overX = 100,
   overY = 50,
   onEvent = onPauseTouch,
   id = "PauseButton",
   text = "",
   font = "Helvetica",
   textColor = {255, 255, 255, 255},
   size = 16,
   emboss = false
}

pauseBtn.x = 160; pauseBtn.y = 160

local onResumeTouch = function( event)

   if event.phase == "release" then
      myMusic = audio.resume(backgroundSound)
	  print("resume")
   end
end


resumeBtn = ui.newButton
{
   defaultSrc = "resumebtn.png",
   defaultX = 100,
   defaultY = 50,
   overSrc = "resumebtn-over.png",
   overX = 100,
   overY = 50,
   onEvent = onResumeTouch,
   id = "PauseButton",
   text = "",
   font = "Helvetica",
   textColor = {255, 255, 255, 255},
   size = 16,
   emboss = false
}

resumeBtn.x = 160; resumeBtn.y = 220

local onStopTouch = function( event)

   if event.phase == "release" then
      myMusic = audio.stop(1)
	  print("stop")
   end
end


stopBtn = ui.newButton
{
   defaultSrc = "stopbtn.png",
   defaultX = 100,
   defaultY = 50,
   overSrc = "stopbtn-over.png",
   overX = 100,
   overY = 50,
   onEvent = onStopTouch,
   id = "StopButton",
   text = "",
   font = "Helvetica",
   textColor = {255, 255, 255, 255},
   size = 16,
   emboss = false
}

stopBtn.x = 160; stopBtn.y = 280



local onRewindTouch = function( event)

   if event.phase == "release" then
      myMusic = audio.rewind(backgroundSound)
	  print("rewind")
   end
end


rewindBtn = ui.newButton
{
   defaultSrc = "rewindbtn.png",
   defaultX = 100,
   defaultY = 50,
   overSrc = "rewindbtn-over.png",
   overX = 100,
   overY = 50,
   onEvent = onRewindTouch,
   id = "RewindButton",
   text = "",
   font = "Helvetica",
   textColor = {255, 255, 255, 255},
   size = 16,
   emboss = false
}

rewindBtn.x = 160; rewindBtn.y = 340

