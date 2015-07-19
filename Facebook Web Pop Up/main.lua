display.setStatusBar( display.HiddenStatusBar)

local ui = require ("ui")

local openBtn
local closeBtn
local score = 100

local appID = "40"

local onOpenTouch = function( event)

   if event.phase == "release" then
      local message1 = "App Name Here"
	  
      local message2 = "Posting to Twitter from Corona SDK and got a final score of" ..score.. "."
	  local message3 = "Download the game and play!"
	  
	  
	  local myString1 = string.gsub(message1, "()", "%%20")
	  local myString2 = string.gsub(message2, "()", "%%20")
	  local myString3 = string.gsub(message3, "()", "%%20")
	  
	  native.showWebPopup(0, 0, 320, 300, "http://www.facebook.com/dialog/feed?app_id="
	    ..appID.."&redirect_uri=http://www.google.com&display=touch&link=http://www.yahoo.com"
		.."&picture=http://www.yourwebsite.com/image.png&name="
		..myString1.."&caption=" ..myString2.. "&description=".. myString3)
	  
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