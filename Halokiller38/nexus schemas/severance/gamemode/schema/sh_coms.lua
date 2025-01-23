--[[
Name: "sh_coms.lua".
Product: "Severance".
--]]

local COMMAND = {};

COMMAND = {};
COMMAND.tip = "Set the physical description of an object.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if ( IsValid(target) ) then
		if (target:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if ( nexus.entity.IsPhysicsEntity(target) ) then
				if ( player:QueryCharacter("key") == target:GetOwnerKey() ) then
					player.objectPhysDesc = target;
					
					umsg.Start("nx_ObjectPhysDesc", player);
						umsg.Entity(target);
					umsg.End();
				else
					nexus.player.Notify(player, "You are not the owner of this entity!");
				end;
			else
				nexus.player.Notify(player, "This entity is not a physics entity!");
			end;
		else
			nexus.player.Notify(player, "This entity is too far away!");
		end;
	else
		nexus.player.Notify(player, "You must look at a valid entity!");
	end;
end;

nexus.command.Register(COMMAND, "ObjectPhysDesc");

COMMAND = {};
COMMAND.tip = "Set your radio frequency, or a stationary radio's frequency.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local radio;
	
	if (IsValid(trace.Entity) and trace.Entity:GetClass() == "nx_radio") then
		if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
			radio = trace.Entity;
		else
			nexus.player.Notify(player, "This stationary radio is too far away!");
			
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
				
				nexus.player.Notify(player, "You have set this stationary radio's frequency to "..frequency..".");
			else
				player:SetCharacterData("frequency", frequency);
				
				nexus.player.Notify(player, "You have set your radio frequency to "..frequency..".");
			end;
		else
			nexus.player.Notify(player, "The radio frequency must be between 101.1 and 199.9!");
		end;
	else
		nexus.player.Notify(player, "The radio frequency must look like xxx.x!");
	end;
end;

nexus.command.Register(COMMAND, "SetFreq");

COMMAND = {};
COMMAND.tip = "Permanently kill a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = nexus.player.Get( arguments[1] );
	
	if (target) then
		if ( !target:GetCharacterData("permakilled") ) then
			SCHEMA:PermaKillPlayer( target, target:GetRagdollEntity() );
		else
			nexus.player.Notify(player, "This character is already permanently killed!");
			
			return;
		end;
		
		nexus.player.NotifyAll(player:Name().." permanently killed the character '"..target:Name().."'.");
	else
		nexus.player.Notify(player, arguments[1].." is not a valid character!");
	end;
end;

nexus.command.Register(COMMAND, "CharPermaKill");

COMMAND = {};
COMMAND.tip = "Heal a character if you own a medical item.";
COMMAND.text = "<string Item>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetSharedVar("sh_Tied") == 0) then
		local itemTable = nexus.item.Get( arguments[1] );
		local entity = player:GetEyeTraceNoCursor().Entity;
		local healed;
		
		local target = nexus.entity.GetPlayer(entity);
		
		if (target) then
			if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
				if (itemTable and arguments[1] == "health_vial") then
					if ( player:HasItem("health_vial") ) then
						target:SetHealth( math.Clamp( target:Health() + SCHEMA:GetHealAmount(player, 1.5), 0, target:GetMaxHealth() ) );
						target:EmitSound("items/medshot4.wav");
						
						player:UpdateInventory("health_vial", -1, true);
						
						healed = true;
					else
						nexus.player.Notify(player, "You do not own a health vial!");
					end;
				elseif (itemTable and arguments[1] == "health_kit") then
					if ( player:HasItem("health_kit") ) then
						target:SetHealth( math.Clamp( target:Health() + SCHEMA:GetHealAmount(player, 2), 0, target:GetMaxHealth() ) );
						target:EmitSound("items/medshot4.wav");
						
						player:UpdateInventory("health_kit", -1, true);
						
						healed = true;
					else
						nexus.player.Notify(player, "You do not own a health kit!");
					end;
				elseif (itemTable and arguments[1] == "bandage") then
					if ( player:HasItem("bandage") ) then
						target:SetHealth( math.Clamp( target:Health() + SCHEMA:GetHealAmount(player), 0, target:GetMaxHealth() ) );
						target:EmitSound("items/medshot4.wav");
						
						player:UpdateInventory("bandage", -1, true);
						
						healed = true;
					else
						nexus.player.Notify(player, "You do not own a bandage!");
					end;
				else
					nexus.player.Notify(player, "This is not a valid item!");
				end;
				
				if (healed) then
					nexus.mount.Call("PlayerHealed", target, player, itemTable);
					
					if (nexus.player.GetAction(target) == "die") then
						nexus.player.SetRagdollState(target, RAGDOLL_NONE);
					end;
					
					player:FakePickup(target);
				end;
			else
				nexus.player.Notify(player, "This character is too far away!");
			end;
		else
			nexus.player.Notify(player, "You must look at a character!");
		end;
	else
		nexus.player.Notify(player, "You don't have permission to do this right now!");
	end;
end;

nexus.command.Register(COMMAND, "CharHeal");

COMMAND = {};
COMMAND.tip = "Search a character if they are tied.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
COMMAND = {};
COMMAND.tip = "Search a character if they are tied.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = nexus.entity.GetPlayer(player:GetEyeTraceNoCursor().Entity);
	
	if (target) then
		if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
			if (player:GetSharedVar("sh_Tied") == 0) then
				if (target:GetSharedVar("sh_Tied") != 0) then
					if (target:GetVelocity():Length() == 0) then
						if (!player.searching) then
							target.beingSearched = true;
							player.searching = target;
							
							nexus.player.OpenStorage( player, {
								name = nexus.player.FormatRecognisedText(player, "%s", target),
								weight = nexus.inventory.GetMaximumWeight(target),
								entity = target,
								distance = 192,
								cash = nexus.player.GetCash(target),
								inventory = nexus.player.GetInventory(target),
								OnClose = function(player, storageTable, entity)
									player.searching = nil;
									
									if ( IsValid(entity) ) then
										entity.beingSearched = nil;
									end;
								end,
								OnTake = function(player, storageTable, itemTable)
									local target = nexus.entity.GetPlayer(storageTable.entity);
									
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
							nexus.player.Notify(player, "You are already searching a character!");
						end;
					else
						nexus.player.Notify(player, "You cannot search a moving character!");
					end;
				else
					nexus.player.Notify(player, "This character is not tied!");
				end;
			else
				nexus.player.Notify(player, "You don't have permission to do this right now!");
			end;
		else
			nexus.player.Notify(player, "This character is too far away!");
		end;
	else
		nexus.player.Notify(player, "You must look at a character!");
	end;
end;

nexus.command.Register(COMMAND, "CharSearch");

COMMAND = {};
COMMAND.tip = "Use a zip tie from your inventory.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	nexus.player.RunNexusCommand(player, "InvAction", "zip_tie", "use");
end;

nexus.command.Register(COMMAND, "InvZipTie");