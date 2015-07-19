display.setStatusBar( display.HiddenStatusBar)

local storyboard = require ("storyboard")

local gameNetwork = require( "gameNetwork" )
local playerName

local function loadLocalPlayerCallback( event )
   playerName = event.data.alias
   --saveSettings()  --save player data locally using your own "saveSettings()" function
end

local function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
   return true
end

local function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
end

local function gameNetworkSetup()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.init( "google", gpgsInitCallback )
   end
end

------HANDLE SYSTEM EVENTS------
local function systemEvents( event )
   print("systemEvent " .. event.type)
   if ( event.type == "applicationSuspend" ) then
      print( "suspending..........................." )
   elseif ( event.type == "applicationResume" ) then
      print( "resuming............................." )
   elseif ( event.type == "applicationExit" ) then
      print( "exiting.............................." )
   elseif ( event.type == "applicationStart" ) then
      gameNetworkSetup()  --login to the network here
   end
   return true
end

local store = require( "plugin.google.iap.v3" )

function transactionCallback( event )
    local transaction = event.transaction

    if ( transaction.state == "purchased" ) then
	    native.showAlert( "Corona", "Dream. Build. Ship.", { "OK", "Learn More" }, onComplete )
        print( "Transaction successful!" )
        print( "productIdentifier:", transaction.productIdentifier )
        print( "receipt:", transaction.receipt )
        print( "transactionIdentifier:", transaction.identifier )
        print( "date:", transaction.date )

    elseif ( transaction.state == "restored" ) then
        print( "Transaction restored from previous session" )
        print( "productIdentifier:", transaction.productIdentifier )
        print( "receipt:", transaction.receipt )
        print( "transactionIdentifier:", transaction.identifier )
        print( "date:", transaction.date )
        print( "originalReceipt:", transaction.originalReceipt )
        print( "originalTransactionIdentifier:", transaction.originalIdentifier )
        print( "originalDate:", transaction.originalDate )

    elseif ( transaction.state == "cancelled" ) then
        print( "User cancelled transaction" )

    elseif ( transaction.state == "failed" ) then
        print( "Transaction failed:", transaction.errorType, transaction.errorString )

    else
        print( "Unknown event" )
    end

    -- Tell the store that the transaction is finished
    -- If you are providing downloadable content, wait until after the download completes
    store.finishTransaction( transaction )
end

store.init( "google", transactionCallback )


Runtime:addEventListener( "system", systemEvents )


timer.performWithDelay(200, function () gameNetwork.request( "unlockAchievement", { achievement = { identifier="CgkIzbzr7OUMEAIQAg" }, listener = achievementRequestCallback} ) end, 1)

print("0000000000000000000000000000000000000000000000000000000000000000")

print("1111111111111111111111111111111111111111111111111111111111111111")
timer.performWithDelay(1000, function () gameNetwork.show("achievements") end, 1)


print("2222222222222222222222222222222222222222222222222222222222222222")

storyboard.gotoScene("loadmainmenu")