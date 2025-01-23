--[[
Name: "cl_auto.lua".
Product: "Half-Life 2".
--]]

MODULE.stunEffects = {};
MODULE.combineOverlay = Material("effects/combine_binocoverlay");
MODULE.randomDisplayLines = {
	"Transmitting physical transition vector...",
	"Modulating external temperature levels...",
	"Parsing view ports and data arrays...",
	"Translating Union practicalities...",
	"Updating biosignal co-ordinates...",
	"Parsing Resistance protocol messages...",
	"Downloading recent dictionaries...",
	"Pinging connection to network...",
	"Updating mainframe connection...",
	"Synchronizing locational data...",
	"Translating radio messages...",
	"Emptying outgoing pipes...",
	"Sensoring proximity...",
	"Pinging loopback...",
	"Idle connection..."
};

RESISTANCE:IncludePrefixed("sh_auto.lua");

surface.CreateFont("Verdana", ScaleToWideScreen(17), 600, true, false, "hl2_ChatBoxText");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(2048), 600, true, false, "hl2_Large3D2D");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(29), 600, true, false, "hl2_IntroTextSmall");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(24), 600, true, false, "hl2_IntroTextTiny");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(34), 600, true, false, "hl2_CinematicText");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(64), 600, true, false, "hl2_IntroTextBig");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(18), 600, true, false, "hl2_MainText");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(22), 600, true, false, "hl2_TargetIDText");
surface.CreateFont("Mailart Rubberstamp", ScaleToWideScreen(49), 600, true, false, "hl2_MenuTextBig");

resistance.directory.AddCategory("Combine Dispatcher", "Commands");
resistance.directory.AddCategory("Civil Protection", "Commands");

resistance.config.SetAdministration("server_whitelist_identity", "The identity used for the server whitelist.\nLeave blank for no identity.");
resistance.config.SetAdministration("combine_lock_overrides", "Whether or not the merchant permits are active.");
resistance.config.SetAdministration("intro_text_small", "The small text displayed for the introduction.");
resistance.config.SetAdministration("intro_text_big", "The big text displayed for the introduction.");
resistance.config.SetAdministration("knockout_time", "The time that a player gets knocked out for (seconds).", 0, 7200);
resistance.config.SetAdministration("business_cost", "The amount that it costs to start a business.");
resistance.config.SetAdministration("cwu_props", "Whether or not to use Civil Worker's Union props.");
resistance.config.SetAdministration("permits", "Whether or not permits are enabled.");

table.sort(MODULE.voices, function(a, b) return a.command < b.command; end);
table.sort(MODULE.dispatchVoices, function(a, b) return a.command < b.command; end);

for k, v in pairs(MODULE.dispatchVoices) do
	resistance.directory.AddCode("Combine Dispatcher", "<b><font color=\"red\">"..v.command.."</font></b>");
	resistance.directory.AddCode("Combine Dispatcher", "<i>"..v.phrase.."</i>");
end;

for k, v in pairs(MODULE.voices) do
	resistance.directory.AddCode("Civil Protection", "<b><font color=\"red\">"..v.command.."</font></b>");
	resistance.directory.AddCode("Civil Protection", "<i>"..v.phrase.."</i>");
end;

RESISTANCE:HookDataStream("RebuildBusiness", function(data)
	if ( resistance.menu.GetOpen() and IsValid(MODULE.businessPanel) ) then
		if (resistance.menu.GetActivePanel() == MODULE.businessPanel) then
			MODULE.businessPanel:Rebuild();
		end;
	end;
end);

usermessage.Hook("roleplay_ObjectPhysDesc", function(msg)
	local entity = msg:ReadEntity();
	
	if ( IsValid(entity) ) then
		Derma_StringRequest("Physical Description", "What is the physical description of this object?", nil, function(text)
			RESISTANCE:StartDataStream( "ObjectPhysDesc", {text, entity} );
		end);
	end;
end);

usermessage.Hook("roleplay_Frequency", function(msg)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", msg:ReadString(), function(text)
		RESISTANCE:RunCommand("SetFreq", text);
		
		if ( !resistance.menu.GetOpen() ) then
			gui.EnableScreenClicker(false);
		end;
	end);
	
	if ( !resistance.menu.GetOpen() ) then
		gui.EnableScreenClicker(true);
	end;
end);

RESISTANCE:HookDataStream("EditObjectives", function(data)
	if ( MODULE.objectivesPanel and MODULE.objectivesPanel:IsValid() ) then
		MODULE.objectivesPanel:Close();
		MODULE.objectivesPanel:Remove();
	end;
	
	MODULE.objectivesPanel = vgui.Create("roleplay_Objectives");
	MODULE.objectivesPanel:Populate(data or "");
	MODULE.objectivesPanel:MakePopup();
	
	gui.EnableScreenClicker(true);
end);

RESISTANCE:HookDataStream("EditData", function(data)
	if ( IsValid( data[1] ) ) then
		if ( MODULE.dataPanel and MODULE.dataPanel:IsValid() ) then
			MODULE.dataPanel:Close();
			MODULE.dataPanel:Remove();
		end;
		
		MODULE.dataPanel = vgui.Create("roleplay_Data");
		MODULE.dataPanel:Populate(data[1], data[2] or "");
		MODULE.dataPanel:MakePopup();
		
		gui.EnableScreenClicker(true);
	end;
end);

usermessage.Hook("roleplay_Stunned", function(msg)
	MODULE:AddStunEffect( msg:ReadFloat() );
end);

usermessage.Hook("roleplay_Flashed", function(msg)
	MODULE:AddFlashEffect();
end);

-- A function to add a flash effect.
function MODULE:AddFlashEffect()
	local curTime = CurTime();
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + 10, 10};
	self.flashEffect = {curTime + 20, 20};
	
	surface.PlaySound("hl1/fvox/flatline.wav");
end;

-- A function to add a stun effect.
function MODULE:AddStunEffect(duration)
	local curTime = CurTime();
	
	if (!duration or duration == 0) then
		duration = 1;
	end;
	
	self.stunEffects[#self.stunEffects + 1] = {curTime + duration, duration};
	self.flashEffect = {curTime + (duration * 2), duration * 2, true};
end;

usermessage.Hook("roleplay_ClearEffects", function(msg)
	MODULE.stunEffects = {};
	MODULE.flashEffect = nil;
end);

RESISTANCE:HookDataStream("CombineDisplayLine", function(data)
	MODULE:AddCombineDisplayLine( data[1], data[2] );
end);

resistance.chatBox.RegisterClass("request_eavesdrop", "ic", function(info)
	if (info.shouldHear) then
		resistance.chatBox.Add(info.filtered, nil, Color(255, 255, 150, 255), info.name.." requests \""..info.text.."\"");
	end;
end);

resistance.chatBox.RegisterClass("broadcast", "ic", function(info)
	resistance.chatBox.Add(info.filtered, nil, Color(150, 125, 175, 255), info.name.." broadcasts \""..info.text.."\"");
end);

resistance.chatBox.RegisterClass("dispatch", "ic", function(info)
	resistance.chatBox.Add(info.filtered, nil, Color(150, 100, 100, 255), "Dispatch broadcasts \""..info.text.."\"");
end);

resistance.chatBox.RegisterClass("request", "ic", function(info)
	resistance.chatBox.Add(info.filtered, nil, Color(175, 125, 100, 255), info.name.." requests \""..info.text.."\"");
end);

-- A function to get a player's scanner entity.
function MODULE:GetScannerEntity(player)
	local scannerEntity = player:GetSharedVar("sh_Scanner");
	
	if ( IsValid(scannerEntity) ) then
		return scannerEntity;
	end;
end;

-- A function to get whether a text entry is being used.
function MODULE:IsTextEntryBeingUsed()
	if (self.textEntryFocused) then
		if ( self.textEntryFocused:IsValid() and self.textEntryFocused:IsVisible() ) then
			return true;
		end;
	end;
end;

-- A function to add a Combine display line.
function MODULE:AddCombineDisplayLine(text, color)
	if ( self:PlayerIsCombine(g_LocalPlayer) ) then
		if (!self.combineDisplayLines) then
			self.combineDisplayLines = {};
		end;
		
		table.insert( self.combineDisplayLines, {"<:: "..text, CurTime() + 8, 5, color} );
	end;
end;

-- A function to get whether a player is Combine.
function MODULE:PlayerIsCombine(player, human)
	local faction = resistance.player.GetFaction(player);
	
	if ( self:IsCombineFaction(faction) ) then
		if (human) then
			if (faction == FACTION_MPF) then
				return true;
			end;
		elseif (human == false) then
			if (faction == FACTION_MPF) then
				return false;
			else
				return true;
			end;
		else
			return true;
		end;
	end;
end;