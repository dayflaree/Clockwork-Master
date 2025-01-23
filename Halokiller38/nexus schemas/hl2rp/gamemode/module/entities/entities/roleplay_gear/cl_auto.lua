--[[
Name: "cl_auto.lua".
Product: "resistance".
Credits:
	CapsAdmin for the concept.
	Lexi for something or other.
--]]

include("sh_auto.lua")

-- Called when the entity initializes.
function ENT:Initialize()
	self:SharedInitialize();
end;

-- Called each frame.
function ENT:Think()
	local playerEyePos = g_LocalPlayer:EyePos();
	local player = self:GetPlayer();
	local eyePos = EyePos();
	
	if ( IsValid(player) ) then
		local isPlayer = player:IsPlayer();
		
		if ( (eyePos:Distance(playerEyePos) > 32 or GetViewEntity() != g_LocalPlayer
		or g_LocalPlayer != player or !isPlayer) and ( !isPlayer or player:Alive() ) ) then
			self:SetNoDraw(false);
		else
			self:SetNoDraw(true);
		end;
	end;
end;

-- Called when the entity should draw.
function ENT:Draw()
	local playerEyePos = g_LocalPlayer:EyePos();
	local itemTable = self:GetItem();
	local eyePos = EyePos();
	local player = self:GetPlayer();
	
	if (itemTable and itemTable.attachmentScale) then
		self:SetModelScale(itemTable.attachmentScale);
	end;
	
	if ( IsValid(player) and ( player:GetMoveType() == MOVETYPE_WALK or player:IsRagdolled() or player:InVehicle() ) ) then
		local position, angles = self:GetRealPosition();
		local isPlayer = player:IsPlayer();
		
		if (position and angles) then
            self:SetPos(position);
            self:SetAngles(angles);
			
			if ( (eyePos:Distance(playerEyePos) > 32 or GetViewEntity() != g_LocalPlayer
			or g_LocalPlayer != player or !isPlayer) and ( !isPlayer or player:Alive() ) ) then
				self:DrawModel();
			end;
		end;
	end;
end;