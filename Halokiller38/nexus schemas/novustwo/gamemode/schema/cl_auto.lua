--[[
Name: "cl_auto.lua".
Product: "Novus Two".
--]]

SCHEMA.scratchTexture = surface.GetTextureID("apocalyptia/scratch");
SCHEMA.stunEffects = {};

NEXUS:IncludePrefixed("sh_auto.lua");

surface.CreateFont("alsina", ScaleToWideScreen(2048), 600, true, false, "nov_Large3D2D");
surface.CreateFont("alsina", ScaleToWideScreen(31), 600, true, false, "nov_IntroTextSmall");
surface.CreateFont("alsina", ScaleToWideScreen(24), 600, true, false, "nov_IntroTextTiny");
surface.CreateFont("alsina", ScaleToWideScreen(36), 600, true, false, "nov_CinematicText");
surface.CreateFont("alsina", ScaleToWideScreen(66), 600, true, false, "nov_IntroTextBig");
surface.CreateFont("alsina", ScaleToWideScreen(24), 600, true, false, "nov_TargetIDText");
surface.CreateFont("Verdana", ScaleToWideScreen(17), 600, true, false, "nov_ChatBoxText");
surface.CreateFont("alsina", ScaleToWideScreen(51), 600, true, false, "nov_MenuTextBig");
surface.CreateFont("alsina", ScaleToWideScreen(20), 600, true, false, "nov_MainText");

nexus.config.SetOverwatch("intro_text_small", "The small text displayed for the introduction.");
nexus.config.SetOverwatch("intro_text_big", "The big text displayed for the introduction.");

NEXUS:HookDataStream("RebuildBusiness", function(data)
	if (nexus.menu.GetOpen() and SCHEMA.businessPanel) then
		if (nexus.menu.GetActiveTab() == SCHEMA.businessPanel) then
			SCHEMA.businessPanel:Rebuild();
		end;
	end;
end);

usermessage.Hook("nx_Frequency", function(msg)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", msg:ReadString(), function(text)
		NEXUS:RunCommand("SetFreq", text);
	end);
end);

usermessage.Hook("nx_ObjectPhysDesc", function(msg)
	local entity = msg:ReadEntity();
	
	if ( IsValid(entity) ) then
		Derma_StringRequest("Physical Description", "What is the physical description of this object?", nil, function(text)
			NEXUS:StartDataStream( "ObjectPhysDesc", {text, entity} );
		end);
	end;
end);

usermessage.Hook("nx_Stunned", function(msg)
	SCHEMA:AddStunEffect( msg:ReadFloat() );
end);

usermessage.Hook("nx_Flashed", function(msg)
	SCHEMA:AddFlashEffect();
end);

-- A function to add a flash effect.
function SCHEMA:AddFlashEffect()
	local curTime = CurTime();
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + 10, 10};
	self.flashEffect = {curTime + 20, 20};
	
	surface.PlaySound("hl1/fvox/flatline.wav");
end;

-- A function to add a stun effect.
function SCHEMA:AddStunEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + duration, duration};
	self.flashEffect = {curTime + (duration * 2), duration * 2, true};
end;

usermessage.Hook("nx_ClearEffects", function(msg)
	SCHEMA.stunEffects = {};
	SCHEMA.flashEffect = nil;
end);

-- A function to get whether a text entry is being used.
function SCHEMA:IsTextEntryBeingUsed()
	if ( IsValid(self.textEntryFocused) ) then
		if ( self.textEntryFocused:IsVisible() ) then
			return true;
		end;
	end;
end;