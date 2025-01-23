--[[
	Free Clockwork!
--]]

-- Called when the Clockwork shared variables are added.
function Clockwork.schema:ClockworkAddSharedVars(globalVars, playerVars)
	playerVars:Number("Stamina", true);
	playerVars:Number("NextQuit", true);
	playerVars:Bool("BeingTied", true);
	playerVars:Bool("IsTied");
	playerVars:String("citizenid");
	playerVars:String("customclass");
	playerVars:Bool("scanner");
end;