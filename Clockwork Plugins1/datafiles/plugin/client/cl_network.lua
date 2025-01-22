-- (c) Khub 2012-2013.
-- Clientside network controller
-- Functions that are used to communicate with the server, and which process the server's reply.

if (!Datafiles) then
	error("Execution of Datafiles/cl_network.lua was interrupted - Datafiles table is non-existant!");
	return;
end;

Datafiles.Network = {};

function Datafiles.Network:SendMessage(id, ...)
	net.Start("Datafiles");
	net.WriteString(tostring(id));

	for k, v in pairs({...}) do
		if (type(v) == "string") then
			net.WriteString(v);
		elseif (type(v) == "number") then
			net.WriteInt(v, 32);
		elseif (type(v) == "table") then
			net.WriteTable(v);
		elseif (type(v) == "boolean") then
			net.WriteBit(v);
		else
			Error("Failed to dispatch datafiles network message - unhandled value of type '" .. type(v) .. "'!");
			return;
		end;
	end;

	net.SendToServer();
end;

function Datafiles.Network:AddNote(characterkey, txt, bIsMedical)
	self:SendMessage("AddNote", tonumber(characterkey), txt, bIsMedical and true or false);
end;

function Datafiles.Network:UpdateLastSeen(characterkey)
	self:SendMessage("UpdateLastSeen", tonumber(characterkey));
end;

function Datafiles.Network:LoyaltyActRecord(characterkey, pointschange, note)
	self:SendMessage("LoyaltyActRecord", tonumber(characterkey), pointschange, note);
end;

function Datafiles.Network:ChangeLoyaltyTier(characterkey, tierid)
	self:SendMessage("SetLoyaltyTier", tonumber(characterkey), tonumber(tierid));
end;

function Datafiles.Network:RevokeLoyalistStatus(characterkey)
	self:SendMessage("SetLoyaltyTier", tonumber(characterkey), 0);
end;

function Datafiles.Network:RevokeCitizenship(characterkey)
	self:SendMessage("SetCitizenship", tonumber(characterkey), false);
end;

function Datafiles.Network:IssueCitizenship(characterkey)
	self:SendMessage("SetCitizenship", tonumber(characterkey), true);
end;

function Datafiles.Network:RevokeBOL(characterkey)
	self:SendMessage("SetWarrantStatus", tonumber(characterkey), false);
end;

function Datafiles.Network:PlaceBOL(characterkey)
	self:SendMessage("SetWarrantStatus", tonumber(characterkey), true);
end;

net.Receive("Datafiles", function()
	local action = net.ReadString();

	if (action == "Datafile") then
		if (Datafiles.DatafileFrame and IsValid(Datafiles.DatafileFrame) and Datafiles.DatafileFrame.Close) then
			Datafiles.DatafileFrame:Close();
		end;

		if (Datafiles.ModalDialog and IsValid(Datafiles.ModalDialog) and Datafiles.ModalDialog.Close) then
			Datafiles.ModalDialog:Close();
		end;

		Datafiles:CreatePopup(net.ReadTable());
	elseif (action == "Error") then
		MsgC(Color(255,200,0), "[Datafiles error!] " .. net.ReadString() .. "\n");
	else
		error("Unknown datafiles network action: " .. action);
	end;
end);