--[[
	© 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

COMMAND = openAura.command:New();
COMMAND.tip = "Set your radio frequency, or a stationary radio's frequency.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local radio;
	
	if (IsValid(trace.Entity) and trace.Entity:GetClass() == "aura_radio") then
		if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
			radio = trace.Entity;
		else
			openAura.player:Notify(player, "This stationary radio is too far away!");
			
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
				
				openAura.player:Notify(player, "You have set this stationary radio's frequency to "..frequency..".");
			else
				player:SetCharacterData("frequency", frequency);
				
				openAura.player:Notify(player, "You have set your radio frequency to "..frequency..".");
			end;
		else
			openAura.player:Notify(player, "The radio frequency must be between 101.1 and 199.9!");
		end;
	else
		openAura.player:Notify(player, "The radio frequency must look like xxx.x!");
	end;
end;

openAura.command:Register(COMMAND, "SetFreq");

COMMAND = openAura.command:New();
COMMAND.tip = "Set a character's custom class.";
COMMAND.text = "<string Name> <string Class>";
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = openAura.player:Get( arguments[1] )
	
	if (target) then
		target:SetCharacterData( "customclass", arguments[2] );
		
		openAura.player:NotifyAll(player:Name().." set "..target:Name().."'s custom class to "..arguments[2]..".");
	else
		openAura.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

openAura.command:Register(COMMAND, "CharSetCustomClass");

COMMAND = openAura.command:New();
COMMAND.tip = "Heal a character if you own a medical item.";
COMMAND.text = "<string Item>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local itemTable = openAura.item:Get( arguments[1] );
	local entity = player:GetEyeTraceNoCursor().Entity;
	local healed;
	
	local target = openAura.entity:GetPlayer(entity);
	
	if (target) then
		if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if (itemTable and arguments[1] == "stimpack") then
				if ( player:HasItem("stimpack") ) then
					target:SetHealth( math.Clamp( target:Health() + openAura.schema:GetHealAmount(player, 3), 0, target:GetMaxHealth() ) );
					target:EmitSound("items/medshot4.wav");
					
					player:UpdateInventory("stimpack", -1, true);
					
					healed = true;
				else
					openAura.player:Notify(player, "You do not own a health vial!");
				end;
			elseif (itemTable and arguments[1] == "antibiotics") then
				if ( player:HasItem("antibiotics") ) then
					target:SetHealth( math.Clamp( target:Health() + openAura.schema:GetHealAmount(player, 1.5), 0, target:GetMaxHealth() ) );
					target:EmitSound("items/medshot4.wav");
					
					player:UpdateInventory("antibiotics", -1, true);
					
					healed = true;
				else
					openAura.player:Notify(player, "You do not own a health vial!");
				end;
			elseif (itemTable and arguments[1] == "bandage") then
				if ( player:HasItem("bandage") ) then
					target:SetHealth( math.Clamp( target:Health() + openAura.schema:GetHealAmount(player), 0, target:GetMaxHealth() ) );
					target:EmitSound("items/medshot4.wav");
					
					player:UpdateInventory("bandage", -1, true);
					
					healed = true;
				else
					openAura.player:Notify(player, "You do not own a bandage!");
				end;
			else
				openAura.player:Notify(player, "This is not a valid item!");
			end;
			
			if (healed) then
				openAura.plugin:Call("PlayerHealed", target, player, itemTable);
				
				if (openAura.player:GetAction(target) == "die") then
					openAura.player:SetRagdollState(target, RAGDOLL_NONE);
				end;
				
				player:FakePickup(target);
			end;
		else
			openAura.player:Notify(player, "This character is too far away!");
		end;
	else
		openAura.player:Notify(player, "You must look at a character!");
	end;
end;

openAura.command:Register(COMMAND, "CharHeal");

COMMAND = openAura.command:New();
COMMAND.tip = "Remove trash spawns at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 32);
	local trashSpawns = 0;
	
	for k, v in pairs(openAura.schema.trashSpawns) do
		if (v:Distance(position) <= 256) then
			trashSpawns = trashSpawns + 1;
			
			openAura.schema.trashSpawns[k] = nil;
		end;
	end
	
	if (trashSpawns > 0) then
		if (trashSpawns == 1) then
			openAura.player:Notify(player, "You have removed "..trashSpawns.." trash spawn.");
		else
			openAura.player:Notify(player, "You have removed "..trashSpawns.." trash spawns.");
		end;
	else
		openAura.player:Notify(player, "There were no trash spawns near this position.");
	end;
	
	openAura.schema:SaveTrashSpawns();
end;

openAura.command:Register(COMMAND, "TrashSpawnRemove");

COMMAND = openAura.command:New();
COMMAND.tip = "Add a trash spawn at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 32);
	
	openAura.schema.trashSpawns[#openAura.schema.trashSpawns + 1] = position;
	openAura.schema:SaveTrashSpawns();
	
	openAura.player:Notify(player, "You have added a trash spawn.");
end;

openAura.command:Register(COMMAND, "TrashSpawnAdd");

COMMAND = openAura.command:New();
COMMAND.tip = "Set the physical description of an object.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if ( IsValid(target) ) then
		if (target:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if ( openAura.entity:IsPhysicsEntity(target) ) then
				if ( player:QueryCharacter("key") == target:GetOwnerKey() ) then
					player.objectPhysDesc = target;
					
					umsg.Start("aura_ObjectPhysDesc", player);
						umsg.Entity(target);
					umsg.End();
				else
					openAura.player:Notify(player, "You are not the owner of this entity!");
				end;
			else
				openAura.player:Notify(player, "This entity is not a physics entity!");
			end;
		else
			openAura.player:Notify(player, "This entity is too far away!");
		end;
	else
		openAura.player:Notify(player, "You must look at a valid entity!");
	end;
end;

openAura.command:Register(COMMAND, "ObjectPhysDesc");

COMMAND = openAura.command:New();
COMMAND.tip = "Use a zip tie from your inventory.";
COMMAND.flags = CMD_DEFAULT;

COMMAND = openAura.command:New();
COMMAND.tip = "Use a zip tie from your inventory.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	openAura.player:RunOpenAuraCommand(player, "InvAction", "zip_tie", "use");
end;

openAura.command:Register(COMMAND, "InvZipTie");

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = openAura.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
	
	if (target) then
		if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
			if (player:GetSharedVar("tied") == 0) then
				if (target:GetSharedVar("tied") != 0) then
					if (target:GetVelocity():Length() == 0) then
						if (!player.searching) then
							target.beingSearched = true;
							player.searching = target;
							
							openAura.player:OpenStorage( player, {
								name = openAura.player:FormatRecognisedText(player, "%s", target),
								weight = openAura.inventory:GetMaximumWeight(target),
								entity = target,
								distance = 192,
								cash = openAura.player:GetCash(target),
								inventory = openAura.player:GetInventory(target),
								OnClose = function(player, storageTable, entity)
									player.searching = nil;
									
									if ( IsValid(entity) ) then
										entity.beingSearched = nil;
									end;
								end,
								OnTake = function(player, storageTable, itemTable)
									local target = openAura.entity:GetPlayer(storageTable.entity);
									
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
							openAura.player:Notify(player, "You are already searching a character!");
						end;
					else
						openAura.player:Notify(player, "You cannot search a moving character!");
					end;
				else
					openAura.player:Notify(player, "This character is not tied!");
				end;
			else
				openAura.player:Notify(player, "You don't have permission to do this right now!");
			end;
		else
			openAura.player:Notify(player, "This character is too far away!");
		end;
	else
		openAura.player:Notify(player, "You must look at a character!");
	end;
end;

openAura.command:Register(COMMAND, "CharSearch");


COMMAND = openAura.command:New();
COMMAND.tip = "Purchase a permit for your character.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( openAura.config:Get("permits"):Get() ) then
		if (player:QueryCharacter("faction") == FACTION_CITIZEN) then
			if ( openAura.player:HasFlags(player, "x") ) then
				local permits = {};
				local permit = string.lower( arguments[1] );
				
				for k, v in pairs( openAura.item:GetAll() ) do
					if ( v.cost and v.access and !openAura:HasObjectAccess(player, v) ) then
						if ( string.find(v.access, "1") ) then
							permits.generalGoods = (permits.generalGoods or 0) + (v.cost * v.batch);
						else
							for k2, v2 in pairs(openAura.schema.customPermits) do
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
							
							if ( openAura.player:CanAfford(player, cost) ) then
								if (permit == "generalgoods") then
									openAura.player:GiveCash(player, -cost, "buying general goods permit");
									openAura.player:GiveFlags(player, "1");
								else
									local permitTable = openAura.schema.customPermits[permit];
									
									if (permitTable) then
										openAura.player:GiveCash(player, -cost, "buying "..string.lower(permitTable.name).." permit");
										openAura.player:GiveFlags(player, permitTable.flag);
									end;
								end;
								
								timer.Simple(0.5, function()
									if ( IsValid(player) ) then
										openAura:StartDataStream(player, "RebuildBusiness", true);
									end;
								end);
							else
								local amount = cost - player:QueryCharacter("cash");
								openAura.player:Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
							end;
							
							return;
						end;
					end;
					
					if ( permit == "generalgoods" or openAura.schema.customPermits[permit] ) then
						openAura.player:Notify(player, "You already have this permit!");
					else
						openAura.player:Notify(player, "This is not a valid permit!");
					end;
				else
					openAura.player:Notify(player, "You already have this permit!");
				end;
			elseif (string.lower( arguments[1] ) == "business") then
				local cost = openAura.config:Get("business_cost"):Get();
				
				if ( openAura.player:CanAfford(player, cost) ) then
					openAura.player:GiveCash(player, -cost, "buying business permit");
					openAura.player:GiveFlags(player, "x");
					
					timer.Simple(0.25, function()
						if ( IsValid(player) ) then
							openAura:StartDataStream(player, "RebuildBusiness", true);
						end;
					end);
				else
					local amount = cost - player:QueryCharacter("cash");
					openAura.player:Notify(player, "You need another "..FORMAT_CASH(amount, nil, true).."!");
				end;
			else
				openAura.player:Notify(player, "This is not a valid permit!");
			end;
		else
			openAura.player:Notify(player, "You are not a citizen!");
		end;
	else
		openAura.player:Notify(player, "The permit system has not been enabled!");
	end;
end;

openAura.command:Register(COMMAND, "PermitBuy");

COMMAND = openAura.command:New();
COMMAND.tip = "Take a character's permit(s) away.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( openAura.schema:PlayerIsCombine(player) ) then
		if ( !openAura.schema:IsPlayerCombineRank(player, "RCT") ) then
			local target = player:GetEyeTraceNoCursor().Entity;
			
			if ( target and target:IsPlayer() ) then
				if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
					if (target:QueryCharacter("faction") == FACTION_CITIZEN) then
						for k, v in pairs(openAura.schema.customPermits) do
							openAura.player:TakeFlags(target, v);
						end;
						
						openAura.player:Notify(player, "You have taken this character's permit(s)!");
					else
						openAura.player:Notify(player, "This character is not a citizen!");
					end;
				else
					openAura.player:Notify(player, "This character is too far away!");
				end;
			else
				openAura.player:Notify(player, "You must look at a character!");
			end;
		else
			openAura.player:Notify(player, "You are not ranked high enough for this!");
		end;
	else
		openAura.player:Notify(player, "You are not the Combine!");
	end;
end;

openAura.command:Register(COMMAND, "PermitTake");