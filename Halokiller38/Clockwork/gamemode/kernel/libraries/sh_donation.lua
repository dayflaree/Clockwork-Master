--[[
	Free Clockwork!
--]]

Clockwork.donation = Clockwork:NewLibrary("Donation");
Clockwork.donation.stored = {};

-- A function to register a new donation subscription.
function Clockwork.donation:Register(uniqueID, friendlyName, description, imageName)
	self.stored[uniqueID] = {
		friendlyName = friendlyName,
		description = description,
		imageName = imageName
	};
	
	if (imageName and SERVER) then
		resource.AddFile("materials/"..imageName..".vtf");
		resource.AddFile("materials/"..imageName..".vmt");
	end;
end;

-- A function to get a donation subscription table.
function Clockwork.donation:Get(uniqueID)
	return self.stored[uniqueID];
end;

if (SERVER) then
	function Clockwork.donation:IsSubscribed(player, uniqueID)
		local expireTime = player.cwDonations[uniqueID];
		
		if (expireTime and (expireTime == 0 or os.clock() < expireTime)) then
			return expireTime;
		end;
		
		return false;
	end;
else
	Clockwork.donation.active = {};
	Clockwork.donation.hasDonated = false;
	
	-- A function to get whether the local player is subscribed to a donation.
	function Clockwork.donation:IsSubscribed(uniqueID)
		return self.active[uniqueID] or false;
	end;
	
	-- A function to get whether the local player has donated at all.
	function Clockwork.donation:HasDonated()
		return self.hasDonated;
	end;
	
	Clockwork:HookDataStream("Donations", function(data)
		Clockwork.donation.active = data;
		
		if (table.Count(data) > 0) then
			Clockwork.donation.hasDonated = true;
		end;
	end);
end;