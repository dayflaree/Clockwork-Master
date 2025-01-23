
include( "shared.lua" );

function ENT:Draw()

	local owner = self:GetOwner();
	
	if( LocalPlayer() == owner and EyePos():Distance( LocalPlayer():EyePos() ) < 6 ) then return; end

	if( not owner or not owner:IsValid() or not owner:Alive() ) then return; end
	
	local attachment = owner:LookupBone( "ValveBiped.Bip01_Spine2" );
	local pos, ang = owner:GetBonePosition( attachment );

	local x = ang:Up() * 0.74;
	local y = ang:Right() * 5.88;
	local z = ang:Forward() * 0.00;

	ang:RotateAroundAxis( ang:Forward(), 95.29 );
	ang:RotateAroundAxis( ang:Right(), -93.97 );
	ang:RotateAroundAxis( ang:Up(), 180 );
	
	self:SetPos( pos + x + y + z );
	self:SetAngles( ang );

	--[[
	if( self:GetModel() == "models/fallout 3/backpack_2.mdl" ) then
	
		print( "ya" );
	
		local attachment = owner:LookupBone( "ValveBiped.Bip01_Spine2" );
		local pos, ang = owner:GetBonePosition( attachment );

		local x = ang:Up() * -0.74;
		local y = ang:Right() * 5.88;
		local z = ang:Forward() * 2.94;

		ang:RotateAroundAxis( ang:Forward(), -95.29 );
		ang:RotateAroundAxis( ang:Right(), -93.97 );
		ang:RotateAroundAxis( ang:Up(), 180 );
		
		self:SetPos( pos + x + y + z );
		self:SetAngles( ang );
		
	elseif( self:GetModel() == "models/cigar_lit/cigar_lit.mdl" ) then
	
	else
	
		print( "no" );
	
		--Horsey's cook
		local attachment = owner:LookupBone( "ValveBiped.Bip01_Head1" );
		local pos, ang = owner:GetBonePosition( attachment );

		local x = ang:Up() * 0;
		local y = ang:Right() * 0.74;
		local z = ang:Forward() * 5.88;

		ang:RotateAroundAxis( ang:Forward(), -86.03 );
		ang:RotateAroundAxis( ang:Right(), -47.65 );
		ang:RotateAroundAxis( ang:Up(), -6.62 );
		
		self:SetPos( pos + x + y + z );
		self:SetAngles( ang );
	
	end
	--]]

	self:DrawModel();
	
end