local COMMAND = {};
COMMAND.description = "Give you some items";
COMMAND.arguments = 1;
COMMAND.help = "<string Identifier>";
function COMMAND:OnRun(player, arguments)
	if (!RP.item:Get(arguments[1])) then
		player:Notify("Invalid Item Identifier!");
		return;
	end;
	
	local newItem = RP.item:CreateID(arguments[1]);
	RP.inventory:GiveItem(player, newItem);
	player:Notify("You've given yourself an item ("..RP.item:Get(newItem).name..")");
end;

RP.command:New("give", COMMAND);

local COMMAND = {};
COMMAND.description = "Runs an inventory command";
COMMAND.arguments = 3;
COMMAND.help = "<string Action> <string itemID> <string uniqueID>";
function COMMAND:OnRun(player, arguments)
	if (!RP.item:Get(arguments[2])) then
		player:Notify("Invalid uniqueID or itemID!");
		return false;
	end;
		
	local action = arguments[1];
	local itemID = arguments[2];
	local uniqueID = arguments[3];
	
	local itemTable = RP.item:Get(itemID);
	if (!RP.inventory:HasItem(player, uniqueID, itemID)) then
		player:Notify("You do not own a "..itemTable.name.." ("..itemID..")!");
		return false;
	end;
	
	if (action == "use") then
		itemTable:OnUse(player, itemID);
	
	elseif (action == "unequip") then
		player:UnloadItem(itemID);
		
	elseif (action == "drop") then
		if (itemTable:OnDrop(player)) then
			RP.inventory:DropItem(player, uniqueID, itemID);
		else
			player:Notify("You cannot drop that item");
		end;
		
	else
		player:Notify("Invalid Inventory Action!");
	end;
end;

RP.command:New("inventory", COMMAND);

local COMMAND = {};
COMMAND.description = "Applies yourself for a job";
COMMAND.arguments = 2;
COMMAND.help = "<string UniqueID> <string Model>";
function COMMAND:OnRun(player, arguments)
	local jobTable = RP.job:Get(arguments[1]);
	
	if (jobTable and arguments[2] and table.HasValue(jobTable.models, arguments[2])) then
		local count = 0;
		for _, v in pairs(_player.GetAll()) do
			local jT = RP.job:GetJob(v);
			if (jT) then
				if (jobTable.uniqueID == jT.uniqueID) then
					count = count + 1;
				end;
			end;
		end;
		if (count <= jobTable.MaxCount) then
			if (jobTable.mustVote) then
				RP.vote:StartVote(player:Name().." for "..jobTable.name, function(success, reply, player)
					player:Notify(reply);
					if (success) then
						RP.job:SetJob(player, jobTable.uniqueID);
					end;
				end, player);
			else
				RP.job:SetJob(player, jobTable.uniqueID);
			end;
		else
			player:Notify("There are too many players on that job!");
		end;
	else
		player:Notify("Malformed JobRequest format!");
	end;
	
end;
RP.command:New("jobApply", COMMAND);

local COMMAND = {};
COMMAND.description = "Votes!";
COMMAND.arguments = 1;
COMMAND.help = "<string yes/no>";
function COMMAND:OnRun(player, arguments)
	if (RP.vote.current) then
		if (table.HasValue(RP.vote.current.voters, player:SteamID())) then
			player:Notify("You have already voted!");
		else
			if (arguments[1] == "yes") then	
				RP.vote.current.upVotes = RP.vote.current.upVotes + 1;
			end;
			player:Notify("Thank you for voting.");
			table.insert(RP.vote.current.voters, player:SteamID());
		end;
	else
		player:Notify("There is either no vote taking place, or it has timed out!");
	end;
end;
RP.command:New("vote", COMMAND);