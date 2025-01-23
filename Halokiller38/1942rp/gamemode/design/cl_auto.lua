--[[
Name: "cl_auto.lua".
Product: "Day One".
--]]


DESIGN.dirtyTexture = surface.GetTextureID("dayone/dirty");
DESIGN.stunEffects = {};

BLUEPRINT:IncludePrefixed("sh_auto.lua");

surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(2048), 600, true, false, "nov_Large3D2D");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(31), 600, true, false, "nov_IntroTextSmall");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(24), 600, true, false, "nov_IntroTextTiny");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(36), 600, true, false, "nov_CinematicText");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(78), 600, true, false, "nov_IntroTextBig");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(24), 600, true, false, "nov_TargetIDText");
surface.CreateFont("Verdana", ScaleToWideScreen(17), 600, true, false, "nov_ChatBoxText");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(126), 600, true, false, "nov_MenuTextHuge");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(78), 600, true, false, "nov_MenuTextBig");
surface.CreateFont("Crappy Wehrmacht Typewriter", ScaleToWideScreen(20), 600, true, false, "nov_MainText");

blueprint.config.AddModerator("intro_text_small", "The small text displayed for the introduction.");
blueprint.config.AddModerator("intro_text_big", "The big text displayed for the introduction.");

BLUEPRINT:HookDataStream("RebuildBusiness", function(data)
	if (blueprint.menu.GetOpen() and DESIGN.businessPanel) then
		if (blueprint.menu.GetActiveTab() == DESIGN.businessPanel) then
			DESIGN.businessPanel:Rebuild();
		end;
	end;
end);

usermessage.Hook("bp_Frequency", function(msg)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", msg:ReadString(), function(text)
		BLUEPRINT:RunCommand("SetFreq", text);
	end);
end);

usermessage.Hook("bp_ObjectPhysDesc", function(msg)
	local entity = msg:ReadEntity();
	
	if ( IsValid(entity) ) then
		Derma_StringRequest("Physical Description", "What is the physical description of this object?", nil, function(text)
			BLUEPRINT:StartDataStream( "ObjectPhysDesc", {text, entity} );
		end);
	end;
end);

usermessage.Hook("bp_Stunned", function(msg)
	DESIGN:AddStunEffect( msg:ReadFloat() );
end);

usermessage.Hook("bp_Flashed", function(msg)
	DESIGN:AddFlashEffect();
end);

-- A function to add a flash effect.
function DESIGN:AddFlashEffect()
	local curTime = CurTime();
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + 10, 10};
	self.flashEffect = {curTime + 20, 20};
	
	surface.PlaySound("hl1/fvox/flatline.wav");
end;

-- A function to add a stun effect.
function DESIGN:AddStunEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + duration, duration};
	self.flashEffect = {curTime + (duration * 2), duration * 2, true};
end;

usermessage.Hook("bp_ClearEffects", function(msg)
	DESIGN.stunEffects = {};
	DESIGN.flashEffect = nil;
end);

-- A function to get whether a text entry is being used.
function DESIGN:IsTextEntryBeingUsed()
	if ( IsValid(self.textEntryFocused) ) then
		if ( self.textEntryFocused:IsVisible() ) then
			return true;
		end;
	end;
end;