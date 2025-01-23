RP.job = {};
RP.job.jobs = {};

function RP.job:New(data)
	if (!data.uniqueID) then
		data.uniqueID = string.lower(string.gsub(data.name, " ", "_"));
	end;
	self.jobs[data.uniqueID] = data;
end;

function RP.job:Get(ID)
	if (self.jobs[string.lower(ID)]) then
		return self.jobs[string.lower(ID)];
	end;
	return false;
end;

if (SERVER) then

	function RP.job:SetJob(player, jobID, model)
		local jobTable = self:Get(jobID);
		if (jobTable) then
			player.job = jobTable.uniqueID;
			
			jobTable:OnSwitch(player);
			if (!model) then
				model = table.Random(jobTable.models);
			end;
			
			player:SetModel(model);
			player:Notify("Your new job is '"..jobTable.name.."'.");
			self:StreamData(player);
		end;	
	end;

	function RP.job:GetJob(player)
		if (player.job) then
			return self:Get(player.job);
		end;
		return false;
	end;
	
	function RP.job:StreamData(player)
		RP:DataStream(_player.GetAll(), "PlayerJob", {steamID = player:SteamID(), job = self:GetJob(player).uniqueID});
	end;

else
	
	RP:DataHook("PlayerJob", function(data)
		local player = RP.player:GetSteamID(data.steamID);
		print(player:Name().." : "..data.job);
		player.job = data.job;
	end);

end;
	