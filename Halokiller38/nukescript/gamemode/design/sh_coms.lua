--[[
Name: "sh_coms.lua".
Product: "Day One".
--]]

local COMMAND = {};

COMMAND.tip = "Set your radio frequency, or a stationary radio's frequency.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local radio;
	
	if (IsValid(trace.Entity) and trace.Entity:GetClass() == "bp_radio") then
		if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
			radio = trace.Entity;
		else
			blueprint.player.Notify(player, "This stationary radio is too far away!");
			
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
				
				blueprint.player.Notify(player, "You have set this stationary radio's frequency to "..frequency..".");
			else
				player:SetCharacterData("frequency", frequency);
				
				blueprint.player.Notify(player, "You have set your radio frequency to "..frequency..".");
			end;
		else
			blueprint.player.Notify(player, "The radio frequency must be between 101.1 and 199.9!");
		end;
	else
		blueprint.player.Notify(player, "The radio frequency must look like xxx.x!");
	end;
end;

blueprint.command.Register(COMMAND, "SetFreq");

COMMAND = {};
COMMAND.tip = "Permanently kill a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = blueprint.player.Get( arguments[1] );
	
	if (target) then
		if ( !target:GetCharacterData("permakilled") ) then
			DESIGN:PermaKillPlayer( target, target:GetRagdollEntity() );
		else
			blueprint.player.Notify(player, "This character is already permanently killed!");
			
			return;
		end;
		
		blueprint.player.NotifyAll(player:Name().." permanently killed the character '"..target:Name().."'.");
	else
		blueprint.player.Notify(player, arguments[1].." is not a valid character!");
	end;
end;

blueprint.command.Register(COMMAND, "CharPermaKill");

COMMAND = {};
COMMAND.tip = "Heal a character if you own a medical item.";
COMMAND.text = "<string Item>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (player:GetSharedVar("sh_Tied") == 0) then
		local itemTable = blueprint.item.Get( arguments[1] );
		local entity = player:GetEyeTraceNoCursor().Entity;
		local healed;
		
		local target = blueprint.entity.GetPlayer(entity);
		
		if (target) then
			if (entity:GetPos():Distance( player:GetShootPos() ) <= 192) then
				if (itemTable and arguments[1] == "antibiotics") then
					if ( player:HasItem("antibiotics") ) then
						target:SetHealth( math.Clamp( target:Health() + DESIGN:GetHealAmount(player, 1.5), 0, target:GetMaxHealth() ) );
						target:EmitSound("items/medshot4.wav");
						
						player:UpdateInventory("antibiotics", -1, true);
						
						healed = true;
					else
						blueprint.player.Notify(player, "You do not own a health vial!");
					end;
				elseif (itemTable and arguments[1] == "bandage") then
					if ( player:HasItem("bandage") ) then
						target:SetHealth( math.Clamp( target:Health() + DESIGN:GetHealAmount(player), 0, target:GetMaxHealth() ) );
						target:EmitSound("items/medshot4.wav");
						
						player:UpdateInventory("bandage", -1, true);
						
						healed = true;
					else
						blueprint.player.Notify(player, "You do not own a bandage!");
					end;
				else
					blueprint.player.Notify(player, "This is not a valid item!");
				end;
				
				if (healed) then
					blueprint.plugin.Call("PlayerHealed", target, player, itemTable);
					
					if (blueprint.player.GetAction(target) == "die") then
						blueprint.player.SetRagdollState(target, RAGDOLL_NONE);
					end;
					
					player:FakePickup(target);
				end;
			else
				blueprint.player.Notify(player, "This character is too far away!");
			end;
		else
			blueprint.player.Notify(player, "You must look at a character!");
		end;
	else
		blueprint.player.Notify(player, "You don't have permission to do this right now!");
	end;
end;

blueprint.command.Register(COMMAND, "CharHeal");

COMMAND = {};
COMMAND.tip = "Search a character if they are tied.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = blueprint.entity.GetPlayer(player:GetEyeTraceNoCursor().Entity);
	
	if (target) then
		if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
			if (player:GetSharedVar("sh_Tied") == 0) then
				if (target:GetSharedVar("sh_Tied") != 0) then
					if (target:GetVelocity():Length() == 0) then
						if (!player.searching) then
							target.beingSearched = true;
							player.searching = target;
							
							blueprint.player.OpenStorage( player, {
								name = blueprint.player.FormatRecognisedText(player, "%s", target),
								weight = blueprint.inventory.GetMaximumWeight(target),
								entity = target,
								distance = 192,
								cash = blueprint.player.GetCash(target),
								inventory = blueprint.player.GetInventory(target),
								OnClose = function(player, storageTable, entity)
									player.searching = nil;
									
									if ( IsValid(entity) ) then
										entity.beingSearched = nil;
									end;
								end
							} );
						else
							blueprint.player.Notify(player, "You are already searching a character!");
						end;
					else
						blueprint.player.Notify(player, "You cannot search a moving character!");
					end;
				else
					blueprint.player.Notify(player, "This character is not tied!");
				end;
			else
				blueprint.player.Notify(player, "You don't have permission to do this right now!");
			end;
		else
			blueprint.player.Notify(player, "This character is too far away!");
		end;
	else
		blueprint.player.Notify(player, "You must look at a character!");
	end;
end;

blueprint.command.Register(COMMAND, "CharSearch");

COMMAND = {};
COMMAND.tip = "Remove trash spawns at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 32);
	local trashSpawns = 0;
	
	for k, v in pairs(DESIGN.trashSpawns) do
		if (v:Distance(position) <= 256) then
			trashSpawns = trashSpawns + 1;
			
			DESIGN.trashSpawns[k] = nil;
		end;
	end
	
	if (trashSpawns > 0) then
		if (trashSpawns == 1) then
			blueprint.player.Notify(player, "You have removed "..trashSpawns.." trash spawn.");
		else
			blueprint.player.Notify(player, "You have removed "..trashSpawns.." trash spawns.");
		end;
	else
		blueprint.player.Notify(player, "There were no trash spawns near this position.");
	end;
	
	DESIGN:SaveTrashSpawns();
end;

blueprint.command.Register(COMMAND, "TrashSpawnRemove");

COMMAND = {};
COMMAND.tip = "Add a trash spawn at your target position.";
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local position = player:GetEyeTraceNoCursor().HitPos + Vector(0, 0, 32);
	
	DESIGN.trashSpawns[#DESIGN.trashSpawns + 1] = position;
	DESIGN:SaveTrashSpawns();
	
	blueprint.player.Notify(player, "You have added a trash spawn.");
end;

blueprint.command.Register(COMMAND, "TrashSpawnAdd");

COMMAND = {};
COMMAND.tip = "Set the physical description of an object.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	
	if ( IsValid(target) ) then
		if (target:GetPos():Distance( player:GetShootPos() ) <= 192) then
			if ( blueprint.entity.IsPhysicsEntity(target) ) then
				if ( player:QueryCharacter("key") == target:GetOwnerKey() ) then
					player.objectPhysDesc = target;
					
					umsg.Start("bp_ObjectPhysDesc", player);
						umsg.Entity(target);
					umsg.End();
				else
					blueprint.player.Notify(player, "You are not the owner of this entity!");
				end;
			else
				blueprint.player.Notify(player, "This entity is not a physics entity!");
			end;
		else
			blueprint.player.Notify(player, "This entity is too far away!");
		end;
	else
		blueprint.player.Notify(player, "You must look at a valid entity!");
	end;
end;

blueprint.command.Register(COMMAND, "ObjectPhysDesc");

COMMAND = {};
COMMAND.tip = "Use a zip tie from your inventory.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	blueprint.player.RunBlueprintCommand(player, "InvAction", "zip_tie", "use");
end;

blueprint.command.Register(COMMAND, "InvZipTie");