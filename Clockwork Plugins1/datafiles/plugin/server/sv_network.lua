-- (c) Khub 2012-2013.
-- Serverside network controller
-- Functions that handle network requests from the client, pass them to the database processor and send updated character data back to the client.

util.AddNetworkString("Datafiles");

Datafiles.Network = {};
function Datafiles.Network:SendCharacterData(ply, data)
	if (IsValid(ply)) then
		net.Start("Datafiles");
		net.WriteString("Datafile");
		net.WriteTable(data);
		net.Send(ply);
	end;
end;

local SendError = function(ply, txt)
	net.Start("Datafiles");
	net.WriteString("Error");
	net.WriteString(txt);
	net.Send(ply);
end;

net.Receive("Datafiles", function(len, ply)
	local action = net.ReadString();
	local ck = net.ReadInt(32); -- Character key

	if (!ck or ck == 0) then
		SendError(ply, "Received invalid character ID!");
		return;
	end; 

	if (action == "AddNote") then
		Datafiles.Database:AddNote(ply, ck, net.ReadString(), net.ReadBit() == 1 and true or false);
	elseif (action == "UpdateLastSeen") then
		Datafiles.Database:UpdateLastSeen(ply, ck);
	elseif (action == "LoyaltyActRecord") then
		local pointsChange = net.ReadInt(32);
		local note = net.ReadString();

		if (pointsChange > 0) then
			local subject = Datafiles.Database:GetPlayerByCharacterKey(ck);

			if (IsValid(subject) and subject:DatafilesIsLoyalist()) then
				local tierID = subject.Datafile.LoyaltyTier;

				if (Datafiles.Privileges:GetPlayerRank(ply) < Datafiles.LoyalistTiers[tierID].canGivePoints) then
					SendError(ply, "You aren't eligible to issue loyalty points to members of the " .. Datafiles.LoyalistTiers[tierID].tierName .. " loyalty tier!");
					return;
				end;
			end;
		end;

		Datafiles.Database:AddLoyaltyAct(ply, ck, pointsChange, note);
	elseif (action == "SetLoyaltyTier") then
		local tierID = net.ReadInt(32);

		if (tierID == 0) then
			if (!Datafiles.Privileges:Verify(ply, Datafiles.Privileges.Config.RevokeLoyaltyStatus)) then
				SendError(ply, "You aren't eligible to revoke loyalty statuses.");
				return;
			end;

			Datafiles.Database:SetLoyaltyTier(ply, ck, 0);
		else
			local tierData = Datafiles.LoyalistTiers[tierID];

			if (!tierData) then
				SendError(ply, "Invalid loyalty tier ID (" .. tierID .. ") supplied.");
				return;
			end;

			if (Datafiles.Privileges:GetPlayerRank(ply) < tierData.canManipulate) then
				SendError(ply, "You aren't eligible to apply the desired loyalist tier.");
				return;
			end;

			Datafiles.Database:SetLoyaltyTier(ply, ck, tierID);
		end;
	elseif (action == "SetCitizenship") then
		if (!Datafiles.Privileges:Verify(ply, Datafiles.Privileges.Config.ManipulateCitizenship)) then
			SendError(ply, "You aren't eligible to manipulate citizenships.");
			return;
		end;

		Datafiles.Database:SetCitizenship(ply, ck, net.ReadBit() == 1 and true or false);
	elseif (action == "SetWarrantStatus") then
		if (!Datafiles.Privileges:Verify(ply, Datafiles.Privileges.Config.ManipulateBOL)) then
			SendError(ply, "You aren't eligible to manipulate BOL warrant statuses.");
			return;
		end;

		Datafiles.Database:SetWarrantStatus(ply, ck, net.ReadBit() == 1 and true or false);
	end;
end);