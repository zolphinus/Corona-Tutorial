local storyboard = require( "storyboard")
local scene = storyboard.newScene()

local ui = require("ui")
local store = require( "plugin.google.iap.v3" )




local btnAnim

local btnSound = audio.loadSound("btnSound.wav")

local listOfProducts = 
{
    "com.quatro_gato.eggDrop.special_egg",
    "com.quatro_gato.eggDrop.test",
    --"bad.product.id",
}

local function productCallback( event )

    if ( event.isError ) then
        print( event.errorType )
        print( event.errorString )
        return
    end

    print( "Showing valid products:", #event.products )
    for i = 1,#event.products do
        print( event.products[i].title )              --string
        print( event.products[i].description )        --string
        print( event.products[i].localizedPrice )     --string
        print( event.products[i].productIdentifier )  --string
        print( event.products[i].type )               --string
        print( event.products[i].priceAmountMicros )  --string
        print( event.products[i].priceCurrencyCode )  --string
        print( event.products[i].originalJson )       --string
    end

    print( "Showing invalid products:", #event.invalidProducts )
    for j = 1,#event.invalidProducts do
        print( event.invalidProducts[j] )
    end
end



function scene:createScene( event)
   local screenGroup = self.view
   
   storyboard.removeScene("mainmenu")
   storyboard.removeScene("creditsScreen")
   
   print( "\noptions: createScene event")
end

function scene:enterScene( event)
   local screenGroup = self.view
   
   print( "options: enterScene event")
   
   local backgroundImage = display.newImageRect("optionsBG.png", 480, 320)
   backgroundImage.x = 240; backgroundImage.y = 160
   screenGroup:insert( backgroundImage)
   
   local creditsBtn
   
   local onCreditsTouch = function( event)
      if event.phase == "release" then
	     
		 audio.play(btnSound)
		 storyboard.gotoScene("creditsScreen", "crossFade", 300)
	  end
   end
   
   creditsBtn = ui.newButton
   {
      defaultSrc = "creditsbtn.png",
	  defaultX = 100,
	  defaultY = 100,
	  overSrc = "creditsbtn-over.png",
	  overX = 100,
	  overY = 100,
	  onEvent = onCreditsTouch,
	  id = "CreditsButton",
	  text = "",
	  font = "Helvetica",
	  textColor = {255, 255, 255, 255},
	  size = 16,
	  emboss = false
   }
   
   creditsBtn.x = 240; creditsBtn.y = 440
   screenGroup:insert(creditsBtn)
   
   btnAnim = transition.to(creditsBtn, {time = 500, y = 260,
     transition = easing.inOutExpo})
	 
   
   local closeBtn
      
   local onCloseTouch = function( event)
	  if event.phase == "release" then
 	 
 		 audio.play(btnSound)
 		 storyboard.gotoScene( "mainmenu", "zoomInOutFadeRotate", 500)
 		
 	 end
   end
   
   closeBtn = ui.newButton
   {
      defaultSrc = "closebtn.png",
	  defaultX = 60,
	  defaultY = 60,
	  overSrc = "closebtn-over.png",
	  overX = 60,
	  overY = 60,
	  onEvent = onCloseTouch,
	  id = "CloseButton",
	  text = "",
	  font = "Helvetica",
	  textColor = {255, 255, 255, 255},
	  size = 16,
	  emboss = false
   }
   
   closeBtn.x = 50; closeBtn.y = 280
   screenGroup:insert(closeBtn)
   
   
   local buyEggBtn
      
   local onBuyEggTouch = function( event)
	  if event.phase == "release" then
 	 
 		 audio.play(btnSound)
		 
		 --store stuff here
		 
		 if store.isActive then
		    print("store is active")
			
			if store.canLoadProducts then
			   print("LOADING PRODUCTS")
			   print("LOADING PRODUCTS")
			   print("LOADING PRODUCTS")
			   print("LOADING PRODUCTS")
			   print("LOADING PRODUCTS")
			   store.loadProducts( listOfProducts, productCallback )
			end
			
			
		 end
 		
		
		--store.purchase("com.quatro_gato.eggDrop.special_egg")
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		print( "MYAPP - Purchase: *********************************************" )
		store.purchase("com.quatro_gato.eggDrop.test")
		
		print("my app purchase is done")
		print("my app purchase is done")
		print("my app purchase is done")
		print("my app purchase is done")
		print("my app purchase is done")
		print("my app purchase is done")
		print("my app purchase is done")
 	 end
   end
   
   buyEggBtn = ui.newButton
   {
      defaultSrc = "buyEggbtn.png",
	  defaultX = 60,
	  defaultY = 60,
	  overSrc = "buyEggbtn-over.png",
	  overX = 60,
	  overY = 60,
	  onEvent = onBuyEggTouch,
	  id = "BuyEggButton",
	  text = "",
	  font = "Helvetica",
	  textColor = {255, 255, 255, 255},
	  size = 16,
	  emboss = false
   }
   
   buyEggBtn.x = 340; buyEggBtn.y = 280
   screenGroup:insert(buyEggBtn)
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