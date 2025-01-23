--[[
Name: "sh_coms.lua".
Product: "Half-Life 2".
--]]

local COMMAND = {};

COMMAND.tip = "Dispatch a message to all characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( MODULE:PlayerIsCombine(player) ) then
		if (MODULE:IsPlayerCombineRank( player, {"SCN", "DvL", "SeC"} ) or player:QueryCharacter("faction") == FACTION_OTA) then
			local text = table.concat(arguments, " ");
			
			if (text == "") then
				resistance.player.Notify(player, "You did not specify enough text!");
				
				return;
			end;
			
			MODULE:SayDispatch(player, text);
		else
			resistance.player.Notify(player, "You are not ranked high enough to use this command!");
		end;
	else
		resistance.player.Notify(player, "You are not the Combine!");
	end;
end;

resistance.command.Register(COMMAND, "Dispatch");

COMMAND = {};
COMMAND.tip = "Broadcast a message to all characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:QueryCharacter("faction") == FACTION_ADMIN) then
		local text = table.concat(arguments, " ");
		
		if (text == "") then
			resistance.player.Notify(player, "You did not specify enough text!");
			
			return;
		end;
		
		MODULE:SayBroadcast(player, text);
	else
		resistance.player.Notify(player, "You are not an Administrator!");
	end;
end;

resistance.command.Register(COMMAND, "Broadcast");

COMMAND = {};
COMMAND.tip = "Request assistance from Civil Protection.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_DEATHCODE;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local isCityAdmin = (player:QueryCharacter("faction") == FACTION_ADMIN);
	local isCombine = MODULE:PlayerIsCombine(player);
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		resistance.player.Notify(player, "You did not specify enough text!");
		
		return;
	end;
	
	if (player:HasItem("request_device") or isCombine or isCityAdmin) then
		local curTime = CurTime();
		
		if (!player.nextRequestTime or isCityAdmin or isCombine or curTime >= player.nextRequestTime) then
			MODULE:SayRequest(player, text);
			
			if (!isCityAdmin and !isCombine) then
				player.nextRequestTime = curTime + 30;
			end;
		else
			resistance.player.Notify(player, "You cannot send a request for another "..math.ceil(player.nextRequestTime - curTime).." second(s)!");
		end;
	else
		resistance.player.Notify(player, "You do not own a request device!");
	end;
end;

resistance.command.Register(COMMAND, "Request");

COMMAND = {};
COMMAND.tip = "Set the physical description of an object.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if ( IsValid(target) ) then
		if (target:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if ( resistance.entity.IsPhysicsEntity(target) ) then
				if ( player:QueryCharacter("key") == target:GetOwnerKey() ) then
					player.objectPhysDesc = target;
					
					umsg.Start("roleplay_ObjectPhysDesc", player);
						umsg.Entity(target);
					umsg.End();
				else
					resistance.player.Notify(player, "You are not the owner of this entity!");
				end;
			else
				resistance.player.Notify(player, "This entity is not a physics entity!");
			end;
		else
			resistance.player.Notify(player, "This entity is too far away!");
		end;
	else
		resistance.player.Notify(player, "You must look at a valid entity!");
	end;
end;

resistance.command.Register(COMMAND, "ObjectPhysDesc");

COMMAND = {};
COMMAND.tip = "Remove a player from a server whitelist.";
COMMAND.text = "<string Name> <string ID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = resistance.player.Get( arguments[1] )
	local identity = string.lower( arguments[2] );
	
	if (target) then
		if ( target:GetData("serverwhitelist") ) then
			if ( !target:GetData("serverwhitelist")[identity] ) then
				resistance.player.Notify(player, target:Name().." is not on the '"..identity.."' server whitelist!");
				
				return;
			else
				target:GetData("serverwhitelist")[identity] = nil;
			end;
		end;
		
		resistance.player.SaveCharacter(target);
		
		resistance.player.NotifyAll(player:Name().." has removed "..target:Name().." from the '"..identity.."' server whitelist.");
	else
		resistance.player.Notify(player, arguments[1].." is not a valid character!");
	end;
end;

resistance.command.Register(COMMAND, "PlyRemoveSeverWhitelist");

COMMAND = {};
COMMAND.tip = "Add a player to a server whitelist.";
COMMAND.text = "<string Name> <string ID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = resistance.player.Get( arguments[1] )
	local identity = string.lower( arguments[2] );
	
	if (target) then
		if ( target:GetData("serverwhitelist")[identity] ) then
			resistance.player.Notify(player, target:Name().." is already on the '"..identity.."' server whitelist!");
			
			return;
		else
			target:GetData("serverwhitelist")[identity] = true;
		end;
		
		resistance.player.SaveCharacter(target);
		
		resistance.player.NotifyAll(player:Name().." has added "..target:Name().." to the '"..identity.."' server whitelist.");
	else
		resistance.player.Notify(player, arguments[1].." is not a valid character!");
	end;
end;

resistance.command.Register(COMMAND, "PlyAddServerWhitelist");

COMMAND = {};
COMMAND.tip = "View the Civil Protection objectives.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( MODULE:PlayerIsCombine(player) ) then
		RESISTANCE:StartDataStream(player, "EditObjectives", MODULE.combineObjectives);
		
		player.editObjectivesAuthorised = true;
	else
		resistance.player.Notify(player, "You are not the Combine!");
	end;
end;

resistance.command.Register(COMMAND, "ViewObjectives");

COMMAND = {};
COMMAND.tip = "View data about a given character.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( MODULE:PlayerIsCombine(player) ) then
		local target = resistance.player.Get( arguments[1] );
		
		if (target) then
			if (player != target) then
				RESISTANCE:StartDataStream( player, "EditData", { target, target:GetCharacterData("combinedata") } );
				
				player.editDataAuthorised = target;
			else
				resistance.player.Notify(player, "You cannot view or edit your own data!");
			end;
		else
			resistance.player.Notify(player, arguments[1].." is not a valid character!");
		end;
	else
		resistance.player.Notify(player, "You are not the Combine!");
	end;
end;

resistance.command.Register(COMMAND, "ViewData");

COMMAND = {};
COMMAND.tip = "Follow the closest character to you (as a scanner).";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( MODULE.scanners[player] ) then
		local scanner = MODULE.scanners[player][1];
		
		if ( IsValid(scanner) ) then
			local closest;
			
			for k, v in ipairs( g_Player.GetAll() ) do
				if ( v:HasInitialized() and !MODULE.scanners[v] ) then
					if ( resistance.player.CanSeeEntity(player, v, 0.9, true) ) then
						local distance = v:GetPos():Distance( scanner:GetPos() );
						
						if ( !closest or distance < closest[2] ) then
							closest = {v, distance};
						end;
					end;
				end;
			end;
			
			if (closest) then
				scanner.followTarget = closest[1];
				
				scanner:Input("SetFollowTarget", closest[1], closest[1], "!activator");
				
				resistance.player.Notify(player, "You are now following "..closest[1]:Name().."!");
			else
				resistance.player.Notify(player, "There are no characters near you!");
			end;
		end;
	else
		resistance.player.Notify(player, "You are not a scanner!");
	end;
end;

resistance.command.Register(COMMAND, "CharFollow");

COMMAND = {};
COMMAND.tip = "Heal a character if you own a medical item.";
COMMAND.text = "<string Item>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetSharedVar("sh_Tied") == 0) then
		local itemTable = resistance.item.Get( arguments[1] );
		local entity = player:GetEyeTraceNoCursor().Entity;
		local healed;
		
		local target = resistance.entity.GetPlayer(entity);
		
		if (target) then
			if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
				if ( !MODULE.scanners[target] ) then
					if (itemTable and arguments[1] == "health_vial") then
						if ( player:HasItem("health_vial") ) then
							target:SetHealth( math.Clamp( target:Health() + MODULE:GetHealAmount(player, 1.5), 0, target:GetMaxHealth() ) );
							target:EmitSound("items/medshot4.wav");
							
							player:UpdateInventory("health_vial", -1, true);
							
							healed = true;
						else
							resistance.player.Notify(player, "You do not own a health vial!");
						end;
					elseif (itemTable and arguments[1] == "health_kit") then
						if ( player:HasItem("health_kit") ) then
							target:SetHealth( math.Clamp( target:Health() + MODULE:GetHealAmount(player, 2), 0, target:GetMaxHealth() ) );
							target:EmitSound("items/medshot4.wav");
							
							player:UpdateInventory("health_kit", -1, true);
							
							healed = true;
						else
							resistance.player.Notify(player, "You do not own a health kit!");
						end;
					elseif (itemTable and arguments[1] == "bandage") then
						if ( player:HasItem("bandage") ) then
							target:SetHealth( math.Clamp( target:Health() + MODULE:GetHealAmount(player), 0, target:GetMaxHealth() ) );
							target:EmitSound("items/medshot4.wav");
							
							player:UpdateInventory("bandage", -1, true);
							
							healed = true;
						else
							resistance.player.Notify(player, "You do not own a bandage!");
						end;
					else
						resistance.player.Notify(player, "This is not a valid item!");
					end;
					
					if (healed) then
						resistance.plugin.Call("PlayerHealed", target, player, itemTable);
						
						player:FakePickup(target);
					end;
				elseif (itemTable and arguments[1] == "power_node") then
					if ( player:HasItem("power_node") ) then
						target:SetHealth( target:GetMaxHealth() );
						target:EmitSound("npc/scanner/scanner_electric1.wav");
						
						player:UpdateInventory("power_node", -1, true);
						
						MODULE:MakePlayerScanner(target, true);
					else
						resistance.player.Notify(player, "You do not own a bandage!");
					end;
				else
					resistance.player.Notify(player, "This is not a valid item!");
				end;
			else
				resistance.player.Notify(player, "This character is too far away!");
			end;
		else
			resistance.player.Notify(player, "You must look at a character!");
		end;
	else
		resistance.player.Notify(player, "You don't have permission to do this right now!");
	end;
end;

resistance.command.Register(COMMAND, "CharHeal");

COMMAND = {};
COMMAND.tip = "Search a character if they are tied.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = resistance.entity.GetPlayer(player:GetEyeTraceNoCursor().Entity);
	
	if (target) then
		if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
			if (player:GetSharedVar("sh_Tied") == 0) then
				if (target:GetSharedVar("sh_Tied") != 0) then
					if (target:GetVelocity():Length() == 0) then
						if (!player.searching) then
							target.beingSearched = true;
							player.searching = target;
							
							resistance.player.OpenStorage( player, {
								name = resistance.player.FormatRecognisedText(player, "%s", target),
								weight = resistance.inventory.GetMaximumWeight(target),
								entity = target,
								distance = 192,
								cash = resistance.player.GetCash(target),
								inventory = resistance.player.GetInventory(target),
								OnClose = function(player, storageTable, entity)
									player.searching = nil;
									
									if ( IsValid(entity) ) then
										entity.beingSearched = nil;
									end;
								end,
								OnTake = function(player, storageTable, itemTable)
									local target = resistance.entity.GetPlayer(storageTable.entity);
									
									if (target) then
										if (target:GetCharacterData("clothes") == itemTable.index) then
											if ( !target:HasItem(itemTable.index) ) then
												target:SetCharacterData("clothes", nil);
												
												itemTable:OnChangeClothes(target, false);
											end;
										end;
									end;
								end,
								OnGive = function(player, storageTable, itemTable)
									if (player:GetCharacterData("clothes") == itemTable.index) then
										if ( !player:HasItem(itemTable.index) ) then
											player:SetCharacterData("clothes", nil);
											
											itemTable:OnChangeClothes(player, false);
										end;
									end;
								end
							} );
						else
							resistance.player.Notify(player, "You are already searching a character!");
						end;
					else
						resistance.player.Notify(player, "You cannot search a moving character!");
					end;
				else
					resistance.player.Notify(player, "This character is not tied!");
				end;
			else
				resistance.player.Notify(player, "You don't have permission to do this right now!");
			end;
		else
			resistance.player.Notify(player, "This character is too far away!");
		end;
	else
		resistance.player.Notify(player, "You must look at a character!");
	end;
end;

resistance.command.Register(COMMAND, "CharSearch");

COMMAND = {};
COMMAND.tip = "Set a character's custom class.";
COMMAND.text = "<string Name> <string Class>";
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = resistance.player.Get( arguments[1] )
	
	if (target) then
		target:SetCharacterData( "customclass", arguments[2] );
		
		resistance.player.NotifyAll(player:Name().." set "..target:Name().."'s custom class to "..arguments[2]..".");
	else
		resistance.player.Notify(player, arguments[1].." is not a valid character!");
	end;
end;

resistance.command.Register(COMMAND, "CharSetCustomClass");

COMMAND = {};
COMMAND.tip = "Take a character's custom class.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = resistance.player.Get( arguments[1] )
	
	if (target) then
		target:SetCharacterData("customclass", nil);
		
		resistance.player.NotifyAll(player:Name().." took "..target:Name().."'s custom class.");
	else
		resistance.player.Notify(player, arguments[1].." is not a valid character!");
	end;
end;

resistance.command.Register(COMMAND, "CharTakeCustomClass");

COMMAND = {};
COMMAND.tip = "Permanently kill a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = resistance.player.Get( arguments[1] )
	
	if (target) then
		if ( !target:GetCharacterData("permakilled") ) then
			MODULE:PermaKillPlayer( target, target:GetRagdollEntity() );
		else
			resistance.player.Notify(player, "This character is already permanently killed!");
			
			return;
		end;
		
		resistance.player.NotifyAll(player:Name().." permanently killed the character '"..target:Name().."'.");
	else
		resistance.player.Notify(player, arguments[1].." is not a valid character!");
	end;
end;

resistance.command.Register(COMMAND, "CharPermaKill");

COMMAND = {};
COMMAND.tip = "Turn PK mode on for the given amount of minutes.";
COMMAND.text = "<number Minutes>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local minutes = tonumber( arguments[1] );
	
	if (minutes and minutes > 0) then
		RESISTANCE:SetSharedVar("sh_PKMode", 1);
		RESISTANCE:CreateTimer("Perma-Kill Mode", minutes * 60, 1, function()
			RESISTANCE:SetSharedVar("sh_PKMode", 0);
			
			resistance.player.NotifyAll("Perma-kill mode has been turned off, you are safe now.");
		end);
		
		resistance.player.NotifyAll(player:Name().." has turned on perma-kill mode for "..minutes.." minute(s), try not to be killed.");
	else
		resistance.player.Notify(player, "This is not a valid amount of minutes!");
	end;
end;

resistance.command.Register(COMMAND, "PKModeOn");

COMMAND = {};
COMMAND.tip = "Turn PK mode off and cancel the timer.";
COMMAND.access = "o";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	RESISTANCE:SetSharedVar("sh_PKMode", 0);
	RESISTANCE:DestroyTimer("Perma-Kill Mode");
	
	resistance.player.NotifyAll(player:Name().." has turned off perma-kill mode, you are safe now.");
end;

resistance.command.Register(COMMAND, "PKModeOff");

COMMAND = {};
COMMAND.tip = "Set your radio frequency, or a stationary radio's frequency.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local radio;
	
	if (IsValid(trace.Entity) and trace.Entity:GetClass() == "roleplay_radio") then
		if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
			radio = trace.Entity;
		else
			resistance.player.Notify(player, "This stationary radio is too far away!");
			
			return;
		end;
	end;
	
	local frequency = arguments[1];
	
	if ( string.find(frequency, "^%d%d%d%.%d$") ) then
		local start, finish, decimal = string.match(frequency, "(%d)%d(%d)%.(%d)");
		
		start = tonumber(start);
		finish = tonumber(finish);
		decimal = tonumber(decimal);
		
		if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
			if (radio) then
				trace.Entity:SetFrequency(frequency);
				
				resistance.player.Notify(player, "You have set this stationary radio's frequency to "..frequency..".");
			else
				player:SetCharacterData("frequency", frequency);
				
				resistance.player.Notify(player, "You have set your radio frequency to "..frequency..".");
			end;
		else
			resistance.player.Notify(player, "The radio frequency must be between 101.1 and 199.9!");
		end;
	else
		resistance.player.Notify(player, "The radio frequency must look like xxx.x!");
	end;
end;

resistance.command.Register(COMMAND, "SetFreq");

COMMAND = {};
COMMAND.tip = "Set the name of a non-playable character.";
COMMAND.text = "<string Name> <string Title>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local target = trace.Entity;
	
	if ( target and target:IsNPC() ) then
		if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
			target:SetNetworkedString( "roleplay_Name", arguments[1] );
			target:SetNetworkedString( "roleplay_Title", arguments[2] );
		else
			resistance.player.Notify(player, "This NPC is too far away!");
		end;
	else
		resistance.player.Notify(player, "You must look at an NPC!");
	end;
end;

resistance.command.Register(COMMAND, "SetNPCName");

COMMAND = {};
COMMAND.tip = "Purchase a permit for your character.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( resistance.config.Get("permits"):Get() ) then
		if (player:QueryCharacter("faction") == FACTION_CITIZEN) then
			if ( resistance.player.HasFlags(player, "x") ) then
				local permits = {};
				local permit = string.lower( arguments[1] );
				
				for k, v in pairs( resistance.item.GetAll() ) do
					if ( v.cost and v.access and !RESISTANCE:HasObjectAccess(player, v) ) then
						if ( string.find(v.access, "1") ) then
							permits.generalGoods = (permits.generalGoods or 0) + (v.cost * v.batch);
						else
							for k2, v2 in pairs(MODULE.customPermits) do
								if ( string.find(v.access, v2.flag) ) then
									permits[v2.key] = (permits[v2.key] or 0) + (v.cost * v.batch);
									
									break;
								end;
							end;
						end;
					end;
				end;
				
				if (table.Count(permits) > 0) then
					for k, v in pairs(permits) do
						if (string.lower(k) == permit) then
							local cost = v;
							
							if ( resistance.player.CanAfford(player, cost) ) then
								if (permit == "generalgoods") then
									resistance.player.GiveCash(player, -cost, "buying general goods permit");
									resistance.player.GiveFlags(player, "1");
								else
									local permitTable = MODULE.customPermits[permit];
									
									if (permitTable) then
										resistance.player.GiveCash(player, -cost, "buying "..string.lower(permitTable.name).." permit");
										resistance.player.GiveFlags(player, permitTable.flag);
									end;
								end;
								
								timer.Simple(0.5, function()
									if ( IsValid(player) ) then
										RESISTANCE:StartDataStream(player, "RebuildBusiness", true);
									end;
								end);
							else
								local amount = cost - player:QueryCharacter("cash");
								
								resistance.player.Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
							end;
							
							return;
						end;
					end;
					
					if ( permit == "generalgoods" or MODULE.customPermits[permit] ) then
						resistance.player.Notify(player, "You already have this permit!");
					else
						resistance.player.Notify(player, "This is not a valid permit!");
					end;
				else
					resistance.player.Notify(player, "You already have this permit!");
				end;
			elseif (string.lower( arguments[1] ) == "business") then
				local cost = resistance.config.Get("business_cost"):Get();
				
				if ( resistance.player.CanAfford(player, cost) ) then
					resistance.player.GiveCash(player, -cost, "buying business permit");
					resistance.player.GiveFlags(player, "x");
					
					timer.Simple(0.25, function()
						if ( IsValid(player) ) then
							RESISTANCE:StartDataStream(player, "RebuildBusiness", true);
						end;
					end);
				else
					local amount = cost - player:QueryCharacter("cash");
					
					resistance.player.Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
				end;
			else
				resistance.player.Notify(player, "This is not a valid permit!");
			end;
		else
			resistance.player.Notify(player, "You are not a citizen!");
		end;
	else
		resistance.player.Notify(player, "The permit system has not been enabled!");
	end;
end;

resistance.command.Register(COMMAND, "PermitBuy");

COMMAND = {};
COMMAND.tip = "Take a character's permit(s) away.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( MODULE:PlayerIsCombine(player) ) then
		if ( !MODULE:IsPlayerCombineRank(player, "RCT") ) then
			local target = player:GetEyeTraceNoCursor().Entity;
			
			if ( target and target:IsPlayer() ) then
				if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
					if (target:QueryCharacter("faction") == FACTION_CITIZEN) then
						for k, v in pairs(MODULE.customPermits) do
							resistance.player.TakeFlags(target, v);
						end;
						
						resistance.player.Notify(player, "You have taken this character's permit(s)!");
					else
						resistance.player.Notify(player, "This character is not a citizen!");
					end;
				else
					resistance.player.Notify(player, "This character is too far away!");
				end;
			else
				resistance.player.Notify(player, "You must look at a character!");
			end;
		else
			resistance.player.Notify(player, "You are not ranked high enough for this!");
		end;
	else
		resistance.player.Notify(player, "You are not the Combine!");
	end;
end;

resistance.command.Register(COMMAND, "PermitTake");

COMMAND = {};
COMMAND.tip = "Add a ration dispenser at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("roleplay_rationdispenser");
	
	entity:SetPos(trace.HitPos);
	entity:Spawn();
	
	if ( IsValid(entity) ) then
		entity:SetAngles( Angle(0, player:EyeAngles().yaw + 180, 0) );
		
		resistance.player.Notify(player, "You have added a ration dispenser.");
	end;
end;

resistance.command.Register(COMMAND, "DispenserAdd");

COMMAND = {};
COMMAND.tip = "Use a zip tie from your inventory.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	resistance.player.RunResistanceCommand(player, "InvAction", "zip_tie", "use");
end;

resistance.command.Register(COMMAND, "InvZipTie");