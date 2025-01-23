--[[
	Free Clockwork!
--]]

COMMAND = Clockwork.command:New();
COMMAND.tip = "Search a character if they are tied.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.entity:GetPlayer(player:GetEyeTraceNoCursor().Entity);
	
	if (!target) then
		Clockwork.player:Notify(player, "You must look at a character!");
		return;
	end;
	
	if (target:GetShootPos():Distance(player:GetShootPos()) > 192) then
		Clockwork.player:Notify(player, "This character is too far away!");
		return;
	end;
	
	if (!player:GetSharedVar("IsTied")) then
		if (target:GetSharedVar("IsTied")) then
			if (target:GetVelocity():Length() == 0) then
				if (!player.cwIsSearchingChar) then
					target.cwIsBeingSearched = true;
					player.cwIsSearchingChar = target;
					
					Clockwork.storage:Open(player, {
						name = Clockwork.player:FormatRecognisedText(player, "%s", target),
						weight = target:GetMaxWeight(),
						entity = target,
						distance = 192,
						cash = target:GetCash(),
						inventory = target:GetInventory(),
						OnClose = function(player, storageTable, entity)
							player.cwIsSearchingChar = nil;
							
							if (IsValid(entity)) then
								entity.cwIsBeingSearched = nil;
							end;
						end,
						OnTakeItem = function(player, storageTable, itemTable)
							local target = Clockwork.entity:GetPlayer(storageTable.entity);
							
							if (target and IsValid(target)) then
								if (target:IsWearingItem(itemTable)) then
									target:RemoveClothes();
								end;
							end;
						end,
						OnGiveItem = function(player, storageTable, itemTable)
							if (player:IsWearingItem(itemTable)) then
								player:RemoveClothes();
							end;
						end
					});
				else
					Clockwork.player:Notify(player, "You are already searching a character!");
				end;
			else
				Clockwork.player:Notify(player, "You cannot search a moving character!");
			end;
		else
			Clockwork.player:Notify(player, "This character is not tied!");
		end;
	else
		Clockwork.player:Notify(player, "You cannot do this action at the moment!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharSearch");


COMMAND = Clockwork.command:New();
COMMAND.tip = "Set a character's custom class.";
COMMAND.text = "<string Name> <string Class>";
COMMAND.access = "o";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	if (target) then
		target:SetCharacterData("customclass", arguments[2]);
		target:SetSharedVar("customclass", arguments[2]);
		
		Clockwork.player:NotifyAll(player:Name().." set "..target:Name().."'s custom class to "..arguments[2]..".");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharSetCustomClass");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Take a character's custom class.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	if (target) then
		target:SetCharacterData("customclass", nil);
		target:SetSharedVar("customclass", "");
		
		Clockwork.player:NotifyAll(player:Name().." took "..target:Name().."'s custom class.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharTakeCustomClass");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Permanently kill a character.";
COMMAND.text = "<string Name>";
COMMAND.access = "o";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID( arguments[1] )
	
	/*if (target) then
		if ( !target:GetCharacterData("permakilled") ) then
			Clockwork.schema:PermaKillPlayer( target, target:GetRagdollEntity() );
		else
			Clockwork.player:Notify(player, "This character is already permanently killed!");
			
			return;
		end;
		
		Clockwork.player:NotifyAll(player:Name().." permanently killed the character '"..target:Name().."'.");
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;*/
	Clockwork.player:Notify(player, "Perma Killing is not implemented yet!")
end;

Clockwork.command:Register(COMMAND, "CharPermaKill");


COMMAND = Clockwork.command:New();
COMMAND.tip = "Heal a character if you own a medical item.";
COMMAND.text = "<string Item>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (!player:GetSharedVar("IsTied")) then
		local bIsHealed = false;
		local entity = player:GetEyeTraceNoCursor().Entity;
		local target = Clockwork.entity:GetPlayer(entity);
		
		if (target) then
			if (entity:GetPos():Distance(player:GetShootPos()) <= 192) then
				local itemTable = player:FindItemByID(arguments[1]);
				
				if (!itemTable) then
					Clockwork.player:Notify("You do not own this item!");
					return;
				end;
				
				if (arguments[1] == "health_vial") then
					target:SetHealth(math.Clamp(target:Health() + Clockwork.schema:GetHealAmount(player, 1.5), 0, target:GetMaxHealth()));
					target:EmitSound("items/medshot4.wav");
					player:TakeItem(itemTable);
					bIsHealed = true;
				elseif (arguments[1] == "health_kit") then
					target:SetHealth(math.Clamp(target:Health() + Clockwork.schema:GetHealAmount(player, 2), 0, target:GetMaxHealth()));
					target:EmitSound("items/medshot4.wav");
					player:TakeItem(itemTable);
					bIsHealed = true;
				elseif (arguments[1] == "bandage") then
					target:SetHealth(math.Clamp(target:Health() + Clockwork.schema:GetHealAmount(player), 0, target:GetMaxHealth()));
					target:EmitSound("items/medshot4.wav");
					player:TakeItem(itemTable);
					bIsHealed = true;
				else
					Clockwork.player:Notify(player, "This is not a valid item!");
				end;
				
				if (bIsHealed) then
					Clockwork.plugin:Call("PlayerHealed", target, player, itemTable);
					
					if (Clockwork.player:GetAction(target) == "die") then
						Clockwork.player:SetRagdollState(target, RAGDOLL_NONE);
					end;
					
					player:FakePickup(target);
				end;
			else
				Clockwork.player:Notify(player, "This character is too far away!");
			end;
		else
			Clockwork.player:Notify(player, "You must look at a character!");
		end;
	else
		Clockwork.player:Notify(player, "You cannot do this action at the moment!");
	end;
end;

Clockwork.command:Register(COMMAND, "CharHeal");


COMMAND = Clockwork.command:New();
COMMAND.tip = "Dispatch a message to all characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( Clockwork.schema:PlayerIsCombine(player) ) then
		if (Clockwork.schema:IsPlayerCombineRank( player, {"SCN", "OfC", "SeC"} ) or player:QueryCharacter("faction") == FACTION_OTA or Clockwork.player:IsAdmin(player)) then
			local text = table.concat(arguments, " ");
			
			if (text == "") then
				Clockwork.player:Notify(player, "You did not specify enough text!");
				
				return;
			end;
			
			Clockwork.schema:SayDispatch(player, text);
		else
			Clockwork.player:Notify(player, "You are not ranked high enough to use this command!");
		end;
	else
		Clockwork.player:Notify(player, "You are not the Combine!");
	end;
end;

Clockwork.command:Register(COMMAND, "Dispatch");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Notifies rations are availble";
COMMAND.text = "";
COMMAND.flags = CMD_DEFAULT | CMD_FALLENOVER;
COMMAND.arguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if ( Clockwork.schema:PlayerIsCombine(player) ) then
		Clockwork.schema:SayDispatch(player, "Rations");
	else
		Clockwork.player:Notify(player, "You are not the Combine!");
	end;
end;

Clockwork.command:Register(COMMAND, "DispatchRations");


COMMAND = Clockwork.command:New();
COMMAND.tip = "Request assistance from Civil Protection.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_DEATHCODE;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local isCityAdmin = (player:QueryCharacter("faction") == FACTION_CITYADMIN);
	local isCombine = Clockwork.schema:PlayerIsCombine(player);
	local text = table.concat(arguments, " ");
	
	if (text == "") then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		
		return;
	end;
	
	if (player:HasItemByID("request_device") or isCombine or isCityAdmin) then
		local curTime = CurTime();
		
		if (!player.nextRequestTime or isCityAdmin or isCombine or curTime >= player.nextRequestTime) then
			Clockwork.schema:SayRequest(player, text);
			
			if (!isCityAdmin and !isCombine) then
				player.nextRequestTime = curTime + 5;
			end;
		else
			Clockwork.player:Notify(player, "You cannot send a request for another "..math.ceil(player.nextRequestTime - curTime).." second(s)!");
		end;
	else
		Clockwork.player:Notify(player, "You do not own a request device!");
	end;
end;

Clockwork.command:Register(COMMAND, "Request");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set your radio frequency.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (!Clockwork.schema:PlayerIsCombine(player)) then
		local frequency = arguments[1];
		
		if (string.find(frequency, "^%d%d%d%.%d$")) then
			local start, finish, decimal = string.match(frequency, "(%d)%d(%d)%.(%d)");
			start = tonumber(start); finish = tonumber(finish); decimal = tonumber(decimal);
			
			if ( !player:HasItemByID("handheld_radio") ) then
				Clockwork.player:Notify(player, "You do not own a radio item!");
				return;
			end;
			
			if (start == 1 and finish > 0 and finish < 10 and decimal > 0 and decimal < 10) then
				player:SetCharacterData("Frequency", frequency);
				Clockwork.player:Notify(player, "You have set your radio frequency to "..frequency..".");
			else
				Clockwork.player:Notify(player, "The radio frequency must be between 101.1 and 199.9!");
			end;
		else
			Clockwork.player:Notify(player, "The radio frequency must look like xxx.x!");
		end;
	else
		Clockwork.player:Notify(player, "Your radio is combine-locked");
		player:SetCharacterData("Frequency", "911.9");
	end;
end;

Clockwork.command:Register(COMMAND, "SetFreq");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Send a radio message out to other characters.";
COMMAND.text = "<string Text>";
COMMAND.flags = CMD_DEFAULT | CMD_DEATHCODE | CMD_FALLENOVER;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	if (Clockwork.schema:IsPlayerCombine(player)) then
		player:SetCharacterData("Frequency", "911.9");
	end;
	Clockwork.player:SayRadio(player, table.concat(arguments, " "), true);
end;

Clockwork.command:Register(COMMAND, "R");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Untie the character that you're looking at.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local untieTime = Clockwork.schema:GetDexterityTime(player);
	local eyeTrace = player:GetEyeTraceNoCursor();
	local target = eyeTrace.Entity;
	local entity = target;
	
	if (IsValid(target)) then
		target = Clockwork.entity:GetPlayer(target);
		
		if (target and !player:GetSharedVar("IsTied")) then
			if (target:GetShootPos():Distance(player:GetShootPos()) <= 192) then
				if (target:GetSharedVar("IsTied") and target:Alive()) then
					Clockwork.player:SetAction(player, "untie", untieTime);
					
					target:SetSharedVar("BeingUntied", true);
					
					Clockwork.player:EntityConditionTimer(player, target, entity, untieTime, 192, function()
						return player:Alive() and target:Alive() and !player:IsRagdolled() and !player:GetSharedVar("IsTied");
					end, function(success)
						if (success) then
							Clockwork.schema:TiePlayer(target, false);
						end;
						
						if (IsValid(target)) then
							target:SetSharedVar("BeingUntied", false);
						end;
						
						Clockwork.player:SetAction(player, "untie", false);
					end);
				else
					Clockwork.player:Notify(player, "This character is either not tied, or not alive!");
				end;
			else
				Clockwork.player:Notify(player, "This character is too far away!");
			end;
		else
			Clockwork.player:Notify(player, "You cannot do this action at the moment!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a character!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyUntie");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Use a zip tie from your inventory.";
COMMAND.flags = CMD_DEFAULT;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	Clockwork.player:RunClockworkCommand(player, "InvAction", "use", "zip_tie");
end;

Clockwork.command:Register(COMMAND, "InvZipTie");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Take a container's password.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(traceLine.Entity)) then
			local model = string.lower(traceLine.Entity:GetModel());
			
			if (Clockwork.schema.containers[model]) then
				if (!traceLine.Entity.cwInventory) then
					Clockwork.schema.storage[traceLine.Entity] = traceLine.Entity;

					traceLine.Entity.cwInventory = {};
				end;
				
				traceLine.Entity.cwPassword = nil;
				
				Clockwork.player:Notify(player, "This container's password has been removed.");
			else
				Clockwork.player:Notify(player, "This is not a valid container!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid container!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid container!");
	end;
end;

Clockwork.command:Register(COMMAND, "ContTakePassword");

COMMAND.tip = "Set a container's password.";
COMMAND.text = "<string Pass>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(traceLine.Entity)) then
			local model = string.lower(traceLine.Entity:GetModel());
			
			if (Clockwork.schema.containers[model]) then
				if (!traceLine.Entity.cwInventory) then
					Clockwork.schema.storage[traceLine.Entity] = traceLine.Entity;
					traceLine.Entity.cwInventory = {};
				end;
				
				traceLine.Entity.cwPassword = table.concat(arguments, " ");
				Clockwork.player:Notify(player, "This container's password has been set to '"..traceLine.Entity.cwPassword.."'.");
			else
				Clockwork.player:Notify(player, "This is not a valid container!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid container!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid container!");
	end;
end;

Clockwork.command:Register(COMMAND, "ContSetPassword");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set a container's message.";
COMMAND.text = "<string Message>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(traceLine.Entity)) then
			traceLine.Entity.cwMessage = arguments[1];
			Clockwork.player:Notify(player, "You have set this container's message.");
		else
			Clockwork.player:Notify(player, "This is not a valid container!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid container!");
	end;
end;

Clockwork.command:Register(COMMAND, "ContSetMessage");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Take a container's name.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(traceLine.Entity)) then
			local model = string.lower(traceLine.Entity:GetModel());
			local name = table.concat(arguments, " ");
			
			if (Clockwork.schema.containers[model]) then
				if (!traceLine.Entity.cwInventory) then
					Clockwork.schema.storage[traceLine.Entity] = traceLine.Entity;
					traceLine.Entity.cwInventory = {};
				end;
				
				traceLine.Entity:SetNetworkedString("Name", "");
			else
				Clockwork.player:Notify(player, "This is not a valid container!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid container!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid container!");
	end;
end;

Clockwork.command:Register(COMMAND, "ContTakeName");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Set a container's name.";
COMMAND.text = "[string Name]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(traceLine.Entity)) then
			local model = string.lower(traceLine.Entity:GetModel());
			local name = table.concat(arguments, " ");
			
			if (Clockwork.schema.containers[model]) then
				if (!traceLine.Entity.cwInventory) then
					Clockwork.schema.storage[traceLine.Entity] = traceLine.Entity;
					traceLine.Entity.cwInventory = {};
				end;
				
				traceLine.Entity:SetNetworkedString("Name", name);
			else
				Clockwork.player:Notify(player, "This is not a valid container!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid container!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid container!");
	end;
end;

Clockwork.command:Register(COMMAND, "ContSetName");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Fill a container with random items.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(traceLine.Entity)) then
			local model = string.lower(traceLine.Entity:GetModel());
			
			if (Clockwork.schema.containers[model]) then
				if (!traceLine.Entity.cwInventory) then
					Clockwork.schema.storage[traceLine.Entity] = traceLine.Entity;
					traceLine.Entity.cwInventory = {};
				end;
				
				local containerWeight = Clockwork.schema.containers[model][1];
				local weight = Clockwork.inventory:CalculateWeight(traceLine.Entity.cwInventory);
				
				while (weight < containerWeight) do
					local randomItemInfo = Clockwork.schema:GetRandomItemInfo();
					
					if (randomItemInfo) then
						Clockwork.inventory:AddInstance(
							traceLine.Entity.cwInventory, Clockwork.item:CreateInstance(randomItemInfo[1])
						);
						
						weight = weight + randomItemInfo[2];
					end;
				end;
				
				Clockwork.player:Notify(player, "This container has been filled with random items.");
			else
				Clockwork.player:Notify(player, "This is not a valid container!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid container!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid container!");
	end;
end;

Clockwork.command:Register(COMMAND, "ContFill");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Remove lockers at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	local removed = 0;
	
	for k, v in pairs(ents.FindByClass("cw_locker")) do
		if (v:GetPos():Distance(traceLine.HitPos) <= 256) then
			if (IsValid(v)) then
				v:Remove();
			end;
			removed = removed + 1;
		end;
	end;
	
	if (removed > 0) then
		if (removed == 1) then
			Clockwork.player:Notify(player, "You have removed "..removed.." locker.");
		else
			Clockwork.player:Notify(player, "You have removed "..removed.." lockers.");
		end;
	else
		Clockwork.player:Notify(player, "There were no lockers near this position.");
	end;
	
	Clockwork.schema:SaveLockerList();
end;

Clockwork.command:Register(COMMAND, "LockerRemove");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a locker at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "a";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	local data = {
		position = traceLine.HitPos + Vector(0, 0, 35)
	};
	
	data.angles = player:EyeAngles();
	data.angles.pitch = 0;
	data.angles.roll = 0;
	data.angles.yaw = data.angles.yaw + 180;
	
	data.entity = ents.Create("cw_locker");
	data.entity:SetAngles(data.angles);
	data.entity:SetPos(data.position);
	data.entity:Spawn();
	
	data.entity:GetPhysicsObject():EnableMotion(false);
	
	Clockwork.schema.lockerList[#Clockwork.schema.lockerList + 1] = data;
	Clockwork.schema:SaveLockerList();
	
	Clockwork.player:Notify(player, "You have added a locker.");
end;

Clockwork.command:Register(COMMAND, "LockerAdd");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Make a copy of a unique item.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity) and traceLine.Entity:GetClass() == "cw_item") then
		local itemTable = traceLine.Entity:GetItemTable();
		
		if (itemTable:GetData("Name") != "") then
			local copyInstance = Clockwork.item:CreateCopy(itemTable);
			
			if (copyInstance) then
				local copyEntity = Clockwork.entity:CreateItem(
					nil, copyInstance, traceLine.HitPos + Vector(0, 0, 32)
				);
				
				if (IsValid(copyEntity)) then
					Clockwork.entity:CopyOwner(traceLine.Entity, copyEntity);
					player.cwItemCreateTime = CurTime() + 30;
				end;
			end;
		else
			Clockwork.player:Notify(player, "You cannot copy items that aren't customized!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a valid item entity!");
	end;
end;

Clockwork.command:Register(COMMAND, "UniqueItemCopy");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Save a unique item type to file for later use.";
COMMAND.text = "<string UniqueID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity) and traceLine.Entity:GetClass() == "cw_item") then
		local itemTable = traceLine.Entity:GetItemTable();
		
		if (itemTable:GetData("Name") != "") then
			if (itemTable:IsBasedFrom("custom_script")) then
				local itemType = {
					uniqueID = itemTable("uniqueID"),
					data = {Name = itemTable:GetData("Name")}
				};
				
				Clockwork:SaveSchemaData("itemtypes/"..arguments[1], itemType);
			else
				local itemType = {
					uniqueID = itemTable("uniqueID"),
					data = itemTable("data")
				};
				
				Clockwork:SaveSchemaData("itemtypes/"..arguments[1], itemType);
			end;
			
			Clockwork.player:Notify(player, "You have saved this item type as '"..arguments[1].."'.");
		else
			Clockwork.player:Notify(player, "You cannot save items that aren't customized!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a valid item entity!");
	end;
end;

Clockwork.command:Register(COMMAND, "UniqueItemSave");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Load a unique item type from file as an item entity.";
COMMAND.text = "<string UniqueID>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	local itemType = Clockwork:RestoreSchemaData("itemtypes/"..arguments[1], false);
	
	if (itemType) then
		local itemInstance = Clockwork.item:CreateInstance(
			itemType.uniqueID, nil, itemType.data
		);
		local bIsScriptItem = itemInstance:IsBasedFrom("custom_script");
		
		if (itemInstance and (!bIsScriptItem or itemInstance:OnLoaded())) then
			local itemEntity = Clockwork.entity:CreateItem(
				nil, itemInstance, traceLine.HitPos + Vector(0, 0, 32)
			);
			
			if (IsValid(itemEntity)) then
				player.cwItemCreateTime = CurTime() + 30;
			end;
			
			--[[
				Something wrong here... let's write to the file again
				just to validate that everything is okay.
			--]]
			
			if (bIsScriptItem and table.Count(itemType.data) > 1) then
				itemType = {
					uniqueID = itemInstance("uniqueID"),
					data = {Name = itemInstance:GetData("Name")}
				};
				
				Clockwork:SaveSchemaData("itemtypes/"..arguments[1], itemType);
			end;
		else
			Clockwork.player:Notify(player, "The item type '"..arguments[1].."' is no longer supported!");
		end;
	else
		Clockwork.player:Notify(player, "There is no item type '"..arguments[1].."' saved on file!");
	end;
end;

Clockwork.command:Register(COMMAND, "UniqueItemLoad");

COMMAND = Clockwork.command:New();
COMMAND.tip = "List all saved unique item types to the console.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	player:PrintMessage(2, "######## [Clockwork] Item Types ########");
		local bOneItemType = false;
		
		for k, v in pairs(file.Find(Clockwork:GetSchemaDataPath().."/itemtypes/*.cw")) do
			player:PrintMessage(2, v);
			bOneItemType = true;
		end;
		
		if (!bOneItemType) then
			player:PrintMessage(2, "There are no item types saved to file!");
		end;
	player:PrintMessage(2, "######## [Clockwork] Item Types ########");
	
	Clockwork.player:Notify(player, "The item types have been printed to the console.");
end;

Clockwork.command:Register(COMMAND, "UniqueItemList");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Fill a container with a unique item type.";
COMMAND.text = "<string UniqueID> [number Amount]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local traceLine = player:GetEyeTraceNoCursor();
	
	if (IsValid(traceLine.Entity)) then
		if (Clockwork.entity:IsPhysicsEntity(traceLine.Entity)) then
			local model = string.lower(traceLine.Entity:GetModel());
			
			if (Clockwork.schema.containers[model]) then
				if (!traceLine.Entity.cwInventory) then
					Clockwork.schema.storage[traceLine.Entity] = traceLine.Entity;
					traceLine.Entity.cwInventory = {};
				end;
				
				local itemType = Clockwork:RestoreSchemaData("itemtypes/"..arguments[1], false);
				local amount = tonumber(arguments[2]);
				
				if (!amount or amount == 0) then
					Clockwork.player:Notify(player, "That is not a valid amount!");
					return;
				end;
				
				if (itemType) then
					local itemInstance = Clockwork.item:CreateInstance(
						itemType.uniqueID, nil, itemType.data
					);
					local bIsScriptItem = itemInstance:IsBasedFrom("custom_script");
					
					if (itemInstance and (!bIsScriptItem or itemInstance:OnLoaded())) then
						for i = 1, amount do
							if (i == 1) then
								Clockwork.inventory:AddInstance(
									traceLine.Entity.cwInventory, itemInstance
								);
							else
								Clockwork.inventory:AddInstance(
									traceLine.Entity.cwInventory,
									Clockwork.item:CreateCopy(itemInstance)
								);
							end;
						end;
						
						--[[
							Something wrong here... let's write to the file again
							just to validate that everything is okay.
						--]]
						
						if (bIsScriptItem and table.Count(itemType.data) > 1) then
							itemType = {
								uniqueID = itemInstance("uniqueID"),
								data = {Name = itemInstance:GetData("Name")}
							};
							
							Clockwork:SaveSchemaData("itemtypes/"..arguments[1], itemType);
						end;
						
						Clockwork.player:Notify(player, "This container has been filled with the unique item.");
					else
						Clockwork.player:Notify(player, "The item type '"..arguments[1].."' is no longer supported!");
					end;
				else
					Clockwork.player:Notify(player, "There is no item type '"..arguments[1].."' saved on file!");
				end;
			else
				Clockwork.player:Notify(player, "This is not a valid container!");
			end;
		else
			Clockwork.player:Notify(player, "This is not a valid container!");
		end;
	else
		Clockwork.player:Notify(player, "This is not a valid container!");
	end;
end;

Clockwork.command:Register(COMMAND, "UniqueItemFill");


/* HL2RP Shit */
COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a ration dispenser at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("cw_rationdispenser");
	
	entity:SetPos(trace.HitPos);
	entity:Spawn();
	
	if ( IsValid(entity) ) then
		entity:SetAngles( Angle(0, player:EyeAngles().yaw + 180, 0) );
		
		Clockwork.player:Notify(player, "You have added a ration dispenser.");
	end;
end;

Clockwork.command:Register(COMMAND, "DispenserAdd");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a ration dispenser at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("cw_shield");
	
	entity:SetPos(trace.HitPos);
	entity:Spawn();
	
	if ( IsValid(entity) ) then
		Clockwork.player:Notify(player, "You have added a ration dispenser.");
	end;
end;

Clockwork.command:Register(COMMAND, "ShieldAdd");

COMMAND = Clockwork.command:New();
COMMAND.tip = "View data about a given character.";
COMMAND.text = "<string Name>";
COMMAND.flags = CMD_DEFAULT;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	 if (Clockwork.schema:PlayerIsCombine(player)) then
		local target;
		if (arguments[1]) then
			target = Clockwork.player:FindByID(arguments[1]);
		else
			target = player:GetEyeTraceNoCursor().Entity;
		end;
		
		if (target and target:IsPlayer()) then
			if (player != target) then
				Clockwork:StartDataStream(player, "EditData", {target, target:GetCharacterData("CombineData")});
				player.editDataAuth = target;
			else
				Clockwork.player:Notify(player, "You cannot edit your own data!");
			end;
		else
			Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
		end;
	else
		Clockwork.player:Notify(player, "You are not an MPF unit!");
	end;
end;

Clockwork.command:Register(COMMAND, "ViewData");


COMMAND = Clockwork.command:New();
COMMAND.tip = "Report a player you don't like.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.optionalArguments = 0;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;
	if (target and target:IsPlayer()) then
		if (player != target) then
			local listeners = {};
			for _, v in pairs(_player.GetAll()) do
				if (Clockwork.player:IsAdmin(v) or v:IsSuperAdmin() or v:IsAdmin()) then
					table.insert(listeners, v);
				end;
			end;
			if (table.Count(listeners) > 0) then
				Clockwork.chatBox:Add(listeners, player, "report", target:Name());
			else
				Clockwork.player:Notify(player, "We're sorry - No admins are online to hear your cries!");
			end;
		else
			Clockwork.player:Notify(player, "You cannot report yourself!");
		end;
	else
		Clockwork.player:Notify(player, "You must be looking at a character!");
	end;
end;

Clockwork.command:Register(COMMAND, "PlyReport");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Lets the SeC promote units";
COMMAND.text = "<string UnitNumbers> <string Rank>";
COMMAND.access = "S";
COMMAND.arguments = 2;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		if (Clockwork.schema:PlayerIsCombine(target)) then
			local unitNumbers = string.sub(target:Name(), -5);
			Clockwork.player:NotifyAll(player:Name().." changed MPF Unit #"..unitNumbers.."'s rank to "..arguments[2]..".");
			
			Clockwork.player:SetName(target, "MPF-"..arguments[2].."."..unitNumbers);
		else
			Clockwork.player:Notify(player, target:Name().." is not an MPF character!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid character!");
	end;
end;

Clockwork.command:Register(COMMAND, "SetMPFRank");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a player to a whitelist.";
COMMAND.text = "<string Name>";
COMMAND.access = "S";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local faction = "Metropolice Force";
		
		if (Clockwork.faction.stored[faction]) then
			if (Clockwork.faction.stored[faction].whitelist) then
				if (!Clockwork.player:IsWhitelisted(target, faction)) then
					Clockwork.player:SetWhitelisted(target, faction, true);
					Clockwork.player:SaveCharacter(target);
					
					Clockwork.player:NotifyAll(player:Name().." enlisted "..target:Name().." to the MPF!");
				else
					Clockwork.player:Notify(player, target:Name().." is already on the "..faction.." whitelist!");
				end;
			else
				Clockwork.player:Notify(player, faction.." does not have a whitelist!");
			end;
		else
			Clockwork.player:Notify(player, faction.." is not a valid faction!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "MPFWhitelist");

COMMAND = Clockwork.command:New();
COMMAND.tip = "Add a player to a whitelist.";
COMMAND.text = "<string Name>";
COMMAND.access = "S";
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1])
	
	if (target) then
		local faction = "Metropolice Force";
		
		if (Clockwork.faction.stored[faction]) then
			if (Clockwork.faction.stored[faction].whitelist) then
				if (!Clockwork.player:IsWhitelisted(target, faction)) then
					Clockwork.player:SetWhitelisted(target, faction, false);
					Clockwork.player:SaveCharacter(target);
					
					Clockwork.player:NotifyAll(player:Name().." un-enlisted "..target:Name().." from the MPF!");
				else
					Clockwork.player:Notify(player, target:Name().." is already on the "..faction.." whitelist!");
				end;
			else
				Clockwork.player:Notify(player, faction.." does not have a whitelist!");
			end;
		else
			Clockwork.player:Notify(player, faction.." is not a valid faction!");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player!");
	end;
end;

Clockwork.command:Register(COMMAND, "MPFDewhitelist");