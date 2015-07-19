display.setStatusBar( display.HiddenStatusBar)

local ui = require ("ui")

local openBtn
local closeBtn
local score = 100

local onOpenTouch = function( event)

   if event.phase == "release" then
   
      local message = "Posting to Twitter from Corona SDK and got a final score of" ..score.. "."
	  
	  local myString = string.gsub(message, "()", "%%20")
	  
	  native.showWebPopup(0, 0, 320, 300, "http://twitter.com/intent/tweet?text="..myString)
	  
   end
end


openBtn = ui.newButton
{
	defaultSrc = "openbtn.png",
	defaultX = 90,
	defaultY = 90,
	overSrc = "openbtn-over.png",
	overX = 90,
	overY = 90,
	onEvent = onOpenTouch
}

openBtn.x = 110; openBtn.y = 350

local onCloseTouch = function( event)
   if event.phase == "release" then
      native.cancelWebPopup()
   end
end


closeBtn = ui.newButton
{
	defaultSrc = "closebtn.png",
	defaultX = 90,
	defaultY = 90,
	overSrc = "closebtn-over.png",
	overX = 90,
	overY = 90,
	onEvent = onCloseTouch,
}

closeBtn.x = 210; closeBtn.y = 350