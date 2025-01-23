/* 
	HL2RP Shit
*/

table.sort(Clockwork.schema.voices, function(a, b) return a.command < b.command; end);
table.sort(Clockwork.schema.dispatchVoices, function(a, b) return a.command < b.command; end);


Clockwork.directory:AddCategory("Combine Dispatcher", "Commands");
Clockwork.directory:AddCategory("Civil Protection", "Commands");

for k, v in pairs(Clockwork.schema.dispatchVoices) do
	Clockwork.directory:AddCode("Combine Dispatcher", [[
		<div class="auraInfoTitle">]]..string.upper(v.command)..[[</div>
		<div class="auraInfoText">]]..v.phrase..[[</div>
	]], true);
end;

for k, v in pairs(Clockwork.schema.voices) do
	Clockwork.directory:AddCode("Civil Protection", [[
		<div class="auraInfoTitle">]]..string.upper(v.command)..[[</div>
		<div class="auraInfoText">]]..v.phrase..[[</div>
	]], true);
end;

-- A function to get whether a player is Combine.
function Clockwork.schema:PlayerIsCombine(player, bHuman)
	local faction = player:GetFaction();
	
	if ( self:IsCombineFaction(faction) ) then
		if (bHuman) then
			if (faction == FACTION_MPF) then
				return true;
			end;
		elseif (bHuman == false) then
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

-- Called when the scoreboard's class players should be sorted.
function Clockwork.schema:ScoreboardSortClassPlayers(class, a, b)
	if (class == "Metropolice Force" or class == "Overwatch Transhuman Arm") then
		local rankA = self:GetPlayerCombineRank(a);
		local rankB = self:GetPlayerCombineRank(b);
		
		if (rankA == rankB) then
			return a:Name() < b:Name();
		else
			return rankA > rankB;
		end;
	end;
end;

-- Called when the player info text is needed.
function Clockwork.schema:GetPlayerInfoText(playerInfoText)
	local citizenID = Clockwork.Client:GetSharedVar("citizenid");
	
	if (citizenID) then
		if (Clockwork.Client:GetFaction() == FACTION_CITIZEN) then
			playerInfoText:Add("CITIZEN_ID", "Citizen ID: #"..citizenID);
		end;
	end;
end;

-- Called when the player should see the class
function Clockwork.schema:PlayerCanSeeClass(class)
	return false;
end;

-- Called when a player's scoreboard class is needed.
function Clockwork.schema:GetPlayerScoreboardClass(player)
	local faction = player:GetFaction();

	if (player:GetSharedVar("customclass") != "") then
		return player:GetSharedVar("customclass");
	end;

	if (faction == FACTION_MPF) then
		return "Metropolice Force";
	end;
	
	if (faction == FACTION_OTA) then
		return "Overwatch Transhuman Arm";
	end;
end;


-- Called when a player's scoreboard options are needed.
function Clockwork.schema:GetPlayerScoreboardOptions(player, options, menu)
	if ( Clockwork.command:Get("CharSetcustomclass") ) then
		if ( Clockwork.player:HasFlags(Clockwork.Client, Clockwork.command:Get("CharSetcustomclass").access) ) then
			options["Custom Class"] = {};
			options["Custom Class"]["Set"] = function()
				Derma_StringRequest(player:Name(), "What would you like to set their custom class to?", player:GetSharedVar("customclass"), function(text)
					Clockwork:RunCommand("CharSetcustomclass", player:Name(), text);
				end);
			end;
			
			if (player:GetSharedVar("customclass") != "") then
				options["Custom Class"]["Take"] = function()
					Clockwork:RunCommand( "CharTakecustomclass", player:Name() );
				end;
			end;
		end;
	end;
end;


-- Called when the local player's character screen faction is needed.
function Clockwork.schema:GetPlayerCharacterScreenFaction(character)
	if (character.customclass and character.customclass != "") then
		return character.customclass;
	end;
end;

-- A function to get a player's scanner entity.
function Clockwork.schema:GetScannerEntity(player)
	local scannerEntity = player:GetSharedVar("scanner");
	
	if ( IsValid(scannerEntity) ) then
		return scannerEntity;
	end;
end;

-- Called when the target player's fade distance is needed.
function Clockwork.schema:GetTargetPlayerFadeDistance(player)
	if ( IsValid( self:GetScannerEntity(Clockwork.Client) ) ) then
		return 512;
	end;
end;

-- Called when a player's typing display position is needed.
function Clockwork.schema:GetPlayerTypingDisplayPosition(player)
	local scannerEntity = self:GetScannerEntity(player);
	
	if ( IsValid(scannerEntity) ) then
		local position = scannerEntity:GetBonePosition( scannerEntity:LookupBone("Scanner.Body") );
		local curTime = CurTime();
		
		if (!position) then
			return scannerEntity:GetPos() + Vector(0, 0, 8);
		else
			return position;
		end;
	end;
end;

-- Called when the scoreboard's player info should be adjusted.
function Clockwork.schema:ScoreboardAdjustPlayerInfo(info)
	if ( self:IsPlayerCombineRank(info.player, "SCN") ) then
		if ( self:IsPlayerCombineRank(info.player, "SYNTH") ) then
			info.model = "models/shield_scanner.mdl";
		else
			info.model = "models/combine_scanner.mdl";
		end;
	end;
end;

-- Called when the local player's class model info should be adjusted.
function Clockwork.schema:PlayerAdjustClassModelInfo(class, info)
	if (class == CLASS_SCN) then
		if ( self:IsPlayerCombineRank(openAura.Client, "SCN")
		and self:IsPlayerCombineRank(openAura.Client, "SYNTH") ) then
			info.model = "models/shield_scanner.mdl";
		else
			info.model = "models/combine_scanner.mdl";
		end;
	end;
end;

Clockwork:HookDataStream("EditData", function(data)
	if (IsValid(data[1])) then
		local dataPanel = vgui.Create("cwBasicEditbox");
		dataPanel:Populate(data[1]:Name(), data[2] or "");
		
		dataPanel:SetCallback(function(text)
			Clockwork:StartDataStream("EditData", {data[1], string.sub(text, 0, 2000)});
		end);
		
		dataPanel:MakePopup();		
		gui.EnableScreenClicker(true);
	end;
end);
