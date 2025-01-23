--[[
	Free Clockwork!
--]]

include("shared.lua")

-- Called each frame.
function ENT:Think()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		Clockwork.entity:FetchItemData(self, self:GetDTInt("Index"));
		return;
	end;
	
	local playerEyePos = Clockwork.Client:EyePos();
	local player = self:GetPlayer();
	local eyePos = EyePos();
	
	if (IsValid(player)) then
		local isPlayer = player:IsPlayer();
		
		if ((eyePos:Distance(playerEyePos) > 32 or GetViewEntity() != Clockwork.Client
		or Clockwork.Client != player or !isPlayer) and (!isPlayer or player:Alive())) then
			self:SetNoDraw(false);
		else
			self:SetNoDraw(true);
		end;
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	if (!Clockwork.entity:HasFetchedItemData(self)) then
		return;
	end;

	local playerEyePos = Clockwork.Client:EyePos();
	local r, g, b, a = self:GetColor();
	local itemTable = Clockwork.entity:FetchItemTable(self);
	local modelScale = itemTable("attachmentModelScale", Vector());
	local eyePos = EyePos();
	local player = self:GetPlayer();
	
	if (IsValid(player) and (player:GetMoveType() == MOVETYPE_WALK
	or player:IsRagdolled() or player:InVehicle())) then
		local position, angles = self:GetRealPosition();
		local isPlayer = player:IsPlayer();
		
		if (position and angles) then
			self:SetPos(position); self:SetAngles(angles);
			
			if (itemTable.GetAttachmentModelScale) then
				local newModelScale = itemTable:GetAttachmentModelScale(player, self);
				
				if (newModelScale) then
					modelScale = newModelScale;
				end;
			end;
			
			if ((eyePos:Distance(playerEyePos) > 32 or GetViewEntity() != Clockwork.Client
			or Clockwork.Client != player or !isPlayer) and (!isPlayer or player:Alive()) and a > 0) then
				self:SetModelScale(modelScale);
				self:DrawModel();
			end;
		end;
	end;

	self:SetModelScale(Vector());
end;