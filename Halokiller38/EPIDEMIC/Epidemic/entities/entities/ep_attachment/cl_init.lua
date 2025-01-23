
include( "shared.lua" );

local NonFlipWeapons =
{

	

}

local BeltWeapons =
{

	"models/weapons/necropolis/w_models/w_38special.mdl",
	"models/weapons/necropolis/w_models/w_44magnum.mdl",
	"models/weapons/necropolis/w_models/w_5946.mdl",
	"models/weapons/necropolis/w_models/w_chaos303030.mdl",
	"models/weapons/necropolis/w_models/w_colt1911.mdl",
	"models/weapons/necropolis/w_models/w_doctorx.mdl",
	"models/weapons/necropolis/w_models/w_glock19.mdl",
	"models/weapons/necropolis/w_models/w_m9.mdl",
	"models/weapons/necropolis/w_models/w_makarov.mdl",
	"models/weapons/necropolis/w_models/w_matteo.mdl",
	"models/weapons/necropolis/w_models/w_p226.mdl",
	"models/weapons/necropolis/w_models/w_pilskin.mdl",
	"models/weapons/necropolis/w_models/w_uzi.mdl",
	"models/weapons/w_shot_shortygun.mdl",
	"models/weapons/necropolis/w_models/w_roman.mdl",
	"models/weapons/w_smg_tmp.mdl"

}

local BeltWeaponsFlip =
{
	--"models/weapons/w_shot_shortygun.mdl",
}

local Up90DegFlip = 
{

	"models/weapons/necropolis/w_models/w_scarh.mdl"

}

SpecialAttach = { };
SpecialAttach.Male = { };
SpecialAttach.Female = { };
SpecialAttach.HECU = { };
SpecialAttach.Male["models/eltaco/backpack.mdl"] = { -2.94, 2.21, 14, 90, 82, -180, 1, "ValveBiped.Bip01_Spine2" };
SpecialAttach.Male["models/phycigold.mdl"] = { -0.2, 0.7, 1, 0, -10, 70, 0.7, "mouth" };
SpecialAttach.Male["models/katharsmodels/glasses-1/glasses-1.mdl"] = { 2.5, 0, -0.1, 180, 0, 0, 0.9, "mouth" };
SpecialAttach.Male["models/weapons/w_defuser.mdl"] = { -1, -2, 7, 270, 0, 180, 0.7, "ValveBiped.Bip01_Pelvis" };

SpecialAttach.Male["models/weapons/necropolis/w_models/w_38special.mdl"] = { -4.5, -2.94, -1.47, 82.06, 0, 0, 1, "ValveBiped.Bip01_R_Thigh" };

SpecialAttach.Female["models/eltaco/backpack.mdl"] = { -2.94, 2.21, 14, 90, 82, -180, 1, "ValveBiped.Bip01_Spine2" };
SpecialAttach.Female["models/phycigold.mdl"] = { -0.2, 0.7, 1, 0, -10, 70, 0.7, "mouth" };
SpecialAttach.Female["models/katharsmodels/glasses-1/glasses-1.mdl"] = { 2.5, 0, -0.1, 180, 0, 0, 0.9, "mouth" };
SpecialAttach.Female["models/weapons/w_defuser.mdl"] = { -1, -2, 7, 270, 0, 180, 0.7, "ValveBiped.Bip01_Pelvis" };

SpecialAttach.HECU["models/eltaco/backpack.mdl"] = { -2.94, 2.21, 14, 90, 82, -180, 1, "ValveBiped.Bip01_Spine2" };
SpecialAttach.HECU["models/weapons/w_defuser.mdl"] = { -1, -2, 7, 270, 0, 180, 0.7, "ValveBiped.Bip01_Pelvis" };

function ENT:DrawMale( owner, onback )
	
	local pos = self:GetPos();
	local ang = self:GetAngles();
	
	if( SpecialAttach.Male[self:GetModel()] ) then
		
		local pos2, ang2;
		
		if( string.find( SpecialAttach.Male[self:GetModel()][8], "ValveBiped" ) ) then
			
			local attachment = owner:LookupBone( SpecialAttach.Male[self:GetModel()][8] );
			pos2, ang2 = owner:GetBonePosition( attachment );
			
		else
			
			local attachment = owner:LookupAttachment( SpecialAttach.Male[self:GetModel()][8] );
			local struct = owner:GetAttachment( attachment );
			pos2, ang2 = struct.Pos, struct.Ang;
			
		end

		local x = ang2:Up() * SpecialAttach.Male[self:GetModel()][1];
		local y = ang2:Right() * SpecialAttach.Male[self:GetModel()][2];
		local z = ang2:Forward() * SpecialAttach.Male[self:GetModel()][3];

		ang2:RotateAroundAxis( ang2:Forward(), SpecialAttach.Male[self:GetModel()][4] );
		ang2:RotateAroundAxis( ang2:Right(), SpecialAttach.Male[self:GetModel()][5] );
		ang2:RotateAroundAxis( ang2:Up(), SpecialAttach.Male[self:GetModel()][6] );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
		self:SetModelScale( Vector( SpecialAttach.Male[self:GetModel()][7], SpecialAttach.Male[self:GetModel()][7], SpecialAttach.Male[self:GetModel()][7] ) );
		
	elseif( self:GetModel() == "models/katharsmodels/glasses-2/glasses-2.mdl" ) then
		
		local attachment = owner:LookupBone( "ValveBiped.Bip01_Head1" );
		local pos2, ang2 = owner:GetBonePosition( attachment );
		
		local x, y, z;
		
		x = ang2:Up() * 0;
		y = ang2:Right() * 3.9;
		z = ang2:Forward() * 3;
		
		ang2:RotateAroundAxis( ang2:Forward(), 0 );
		ang2:RotateAroundAxis( ang2:Right(), 270 );
		ang2:RotateAroundAxis( ang2:Up(), 270 );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
		self:SetModelScale( Vector( 0.9, 0.9, 0.9 ) );
		
	elseif( not onback and self:GetModel() == "models/items/healthkit.mdl" ) then
	
		local attachment = owner:LookupBone( "ValveBiped.Bip01_R_Hand" );
		local pos2, ang2 = owner:GetBonePosition( attachment );
		
		ang2:RotateAroundAxis( ang2:Forward(), 180 );
		
		pos = pos2;
		ang = ang2;
		
	elseif( onback ) then
	
		local attachment;
		local pos2, ang2;
		local x, y, z;
		
		if( not table.HasValue( BeltWeapons, self:GetModel() ) ) then

			attachment = owner:LookupBone( "ValveBiped.Bip01_Spine2" );
			pos2, ang2 = owner:GetBonePosition( attachment );

			x = ang2:Up() * 2.94;
			y = ang2:Right() * 2.21;
			z = ang2:Forward() * -8;
			
			if( !table.HasValue( NonFlipWeapons, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Right(), 180 );
				z = ang2:Forward() * 4;
				y = ang2:Right() * 3.5;
			
			end
			
			if( table.HasValue( Up90DegFlip, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Up(), -90 );
				x = ang2:Up() * -3.09;
			
			else
			
				ang2:RotateAroundAxis( ang2:Up(), -180 );
			
			end
			
		else
	
			attachment = owner:LookupBone( "ValveBiped.Bip01_R_Thigh" );
			pos2, ang2 = owner:GetBonePosition( attachment );
			
			x = ang2:Up() * -4.09;
			y = ang2:Right() * -2.94;
			z = ang2:Forward() * -1.47;
	
			ang2:RotateAroundAxis( ang2:Forward(), 82.06 );
			ang2:RotateAroundAxis( ang2:Right(), 0 );
			
			if( table.HasValue( BeltWeaponsFlip, self:GetModel() ) ) then
				
				ang2:RotateAroundAxis( ang2:Up(), 180 );
				x = ang2:Up() * 1.5;
				y = ang2:Right() * -2;
				z = ang2:Forward() * -3;
				
			end
			
			if( table.HasValue( Up90DegFlip, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Up(), 90 );
			
			else
			
				ang2:RotateAroundAxis( ang2:Up(), 0 );
			
			end
			
			if( string.find( self:GetModel(), "shortygun" ) ) then
			
				x = x + ang2:Up() * 5;
				z = z + ang2:Forward() * 7;
			
			end
	
		end
	
		self:SetModelScale( Vector( .8, .8, .8 ) );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
	end
	
	return pos, ang;
	
end

function ENT:DrawFemale( owner, onback )
	
	local pos = self:GetPos();
	local ang = self:GetAngles();
	
	if( SpecialAttach.Female[self:GetModel()] ) then
		
		local pos2, ang2;
		
		if( string.find( SpecialAttach.Female[self:GetModel()][8], "ValveBiped" ) ) then
			
			local attachment = owner:LookupBone( SpecialAttach.Female[self:GetModel()][8] );
			pos2, ang2 = owner:GetBonePosition( attachment );
			
		else
			
			local attachment = owner:LookupAttachment( SpecialAttach.Female[self:GetModel()][8] );
			local struct = owner:GetAttachment( attachment );
			pos2, ang2 = struct.Pos, struct.Ang;
			
		end

		local x = ang2:Up() * SpecialAttach.Female[self:GetModel()][1];
		local y = ang2:Right() * SpecialAttach.Female[self:GetModel()][2];
		local z = ang2:Forward() * SpecialAttach.Female[self:GetModel()][3];

		ang2:RotateAroundAxis( ang2:Forward(), SpecialAttach.Female[self:GetModel()][4] );
		ang2:RotateAroundAxis( ang2:Right(), SpecialAttach.Female[self:GetModel()][5] );
		ang2:RotateAroundAxis( ang2:Up(), SpecialAttach.Female[self:GetModel()][6] );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
		self:SetModelScale( Vector( SpecialAttach.Female[self:GetModel()][7], SpecialAttach.Female[self:GetModel()][7], SpecialAttach.Female[self:GetModel()][7] ) );
		
	elseif( self:GetModel() == "models/katharsmodels/glasses-2/glasses-2.mdl" ) then
		
		local attachment = owner:LookupBone( "ValveBiped.Bip01_Head1" );
		local pos2, ang2 = owner:GetBonePosition( attachment );
		
		local x, y, z;
		
		x = ang2:Up() * 0;
		y = ang2:Right() * 4.3;
		z = ang2:Forward() * 2.2;
		
		ang2:RotateAroundAxis( ang2:Forward(), 0 );
		ang2:RotateAroundAxis( ang2:Right(), 270 );
		ang2:RotateAroundAxis( ang2:Up(), 270 );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
		self:SetModelScale( Vector( 0.9, 0.9, 0.9 ) );
		
	elseif( not onback and self:GetModel() == "models/items/healthkit.mdl" ) then
	
		local attachment = owner:LookupBone( "ValveBiped.Bip01_R_Hand" );
		local pos2, ang2 = owner:GetBonePosition( attachment );
		
		ang2:RotateAroundAxis( ang2:Forward(), 180 );
		
		pos = pos2;
		ang = ang2;
		
	elseif( onback ) then
	
		local attachment;
		local pos2, ang2;
		local x, y, z;
		
		if( not table.HasValue( BeltWeapons, self:GetModel() ) ) then

			attachment = owner:LookupBone( "ValveBiped.Bip01_Spine2" );
			pos2, ang2 = owner:GetBonePosition( attachment );

			x = ang2:Up() * 2.94;
			y = ang2:Right() * 2.21;
			z = ang2:Forward() * -8;
			
			if( !table.HasValue( NonFlipWeapons, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Right(), 180 );
				z = ang2:Forward() * 4;
				y = ang2:Right() * 3.5;
			
			end
			
			if( table.HasValue( Up90DegFlip, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Up(), -90 );
				x = ang2:Up() * -3.09;
			
			else
			
				ang2:RotateAroundAxis( ang2:Up(), -180 );
			
			end
			
		else
	
			attachment = owner:LookupBone( "ValveBiped.Bip01_R_Thigh" );
			pos2, ang2 = owner:GetBonePosition( attachment );
			
			x = ang2:Up() * -4.09;
			y = ang2:Right() * -2.94;
			z = ang2:Forward() * -1.47;
	
			ang2:RotateAroundAxis( ang2:Forward(), 82.06 );
			ang2:RotateAroundAxis( ang2:Right(), 0 );
			
			if( table.HasValue( BeltWeaponsFlip, self:GetModel() ) ) then
				
				ang2:RotateAroundAxis( ang2:Up(), 180 );
				x = ang2:Up() * 1.5;
				y = ang2:Right() * -2;
				z = ang2:Forward() * -3;
				
			end
			
			if( table.HasValue( Up90DegFlip, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Up(), 90 );
			
			else
			
				ang2:RotateAroundAxis( ang2:Up(), 0 );
			
			end
			
			if( string.find( self:GetModel(), "shortygun" ) ) then
			
				x = x + ang2:Up() * 5;
				z = z + ang2:Forward() * 7;
			
			end
	
		end
	
		self:SetModelScale( Vector( .8, .8, .8 ) );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
	end
	
	return pos, ang;
	
end

function ENT:DrawHECU( owner, onback )
	
	local pos = self:GetPos();
	local ang = self:GetAngles();
	
	if( SpecialAttach.HECU[self:GetModel()] ) then
		
		local pos2, ang2;
		
		if( string.find( SpecialAttach.HECU[self:GetModel()][8], "ValveBiped" ) ) then
			
			local attachment = owner:LookupBone( SpecialAttach.HECU[self:GetModel()][8] );
			pos2, ang2 = owner:GetBonePosition( attachment );
			
		else
			
			local attachment = owner:LookupAttachment( SpecialAttach.HECU[self:GetModel()][8] );
			local struct = owner:GetAttachment( attachment );
			pos2, ang2 = struct.Pos, struct.Ang;
			
		end

		local x = ang2:Up() * SpecialAttach.HECU[self:GetModel()][1];
		local y = ang2:Right() * SpecialAttach.HECU[self:GetModel()][2];
		local z = ang2:Forward() * SpecialAttach.HECU[self:GetModel()][3];

		ang2:RotateAroundAxis( ang2:Forward(), SpecialAttach.HECU[self:GetModel()][4] );
		ang2:RotateAroundAxis( ang2:Right(), SpecialAttach.HECU[self:GetModel()][5] );
		ang2:RotateAroundAxis( ang2:Up(), SpecialAttach.HECU[self:GetModel()][6] );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
		self:SetModelScale( Vector( SpecialAttach.HECU[self:GetModel()][7], SpecialAttach.HECU[self:GetModel()][7], SpecialAttach.HECU[self:GetModel()][7] ) );
		
	elseif( self:GetModel() == "models/katharsmodels/glasses-2/glasses-2.mdl" ) then
		
		return
		
	elseif( not onback and self:GetModel() == "models/items/healthkit.mdl" ) then
	
		local attachment = owner:LookupBone( "ValveBiped.Bip01_R_Hand" );
		local pos2, ang2 = owner:GetBonePosition( attachment );
		
		ang2:RotateAroundAxis( ang2:Forward(), 180 );
		
		pos = pos2;
		ang = ang2;
		
	elseif( onback ) then
	
		local attachment;
		local pos2, ang2;
		local x, y, z;
		
		if( not table.HasValue( BeltWeapons, self:GetModel() ) ) then

			attachment = owner:LookupBone( "ValveBiped.Bip01_Spine2" );
			pos2, ang2 = owner:GetBonePosition( attachment );

			x = ang2:Up() * 2.94;
			y = ang2:Right() * 4.21;
			z = ang2:Forward() * -8;
			
			if( !table.HasValue( NonFlipWeapons, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Right(), 180 );
				z = ang2:Forward() * 4;
				y = ang2:Right() * 3.5;
			
			end
			
			if( table.HasValue( Up90DegFlip, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Up(), -90 );
				x = ang2:Up() * -3.09;
			
			else
			
				ang2:RotateAroundAxis( ang2:Up(), -180 );
			
			end
			
		else
	
			attachment = owner:LookupBone( "ValveBiped.Bip01_R_Thigh" );
			pos2, ang2 = owner:GetBonePosition( attachment );
			
			x = ang2:Up() * -8.09;
			y = ang2:Right() * -2.94;
			z = ang2:Forward() * -1.47;
	
			ang2:RotateAroundAxis( ang2:Forward(), 82.06 );
			ang2:RotateAroundAxis( ang2:Right(), 0 );
			
			if( table.HasValue( BeltWeaponsFlip, self:GetModel() ) ) then
				
				ang2:RotateAroundAxis( ang2:Up(), 180 );
				x = ang2:Up() * 1.5;
				y = ang2:Right() * -2;
				z = ang2:Forward() * -3;
				
			end
			
			if( table.HasValue( Up90DegFlip, self:GetModel() ) ) then
			
				ang2:RotateAroundAxis( ang2:Up(), 90 );
			
			else
			
				ang2:RotateAroundAxis( ang2:Up(), 0 );
			
			end
			
			if( string.find( self:GetModel(), "shortygun" ) ) then
			
				x = x + ang2:Up() * 5;
				z = z + ang2:Forward() * 7;
			
			end
	
		end
	
		self:SetModelScale( Vector( .8, .8, .8 ) );
		
		pos = pos2 + x + y + z;
		ang = ang2;
		
	end
	
	return pos, ang;
	
end

function ENT:Draw()

	local owner = self:GetOwner();
	
	if( LocalPlayer() == owner and EyePos():Distance( LocalPlayer():EyePos() ) < 5 ) then return; end
	
	if( not owner or not owner:IsValid() or not owner:Alive() ) then return; end
	
	if( owner:GetMoveType() == 8 ) then return; end
	
	local onback = self:GetNWBool( "Back" );
	
	local pos, ang;
	
	if( string.find( owner:GetModel(), "hecu" ) ) then
		
		pos, ang = self:DrawHECU( owner, onback );
		
	elseif( owner:GetTable().AnimTable and owner:GetTable().AnimTable == 3 ) then
		
		pos, ang = self:DrawFemale( owner, onback );
		
	else
		
		pos, ang = self:DrawMale( owner, onback );
		
	end
	
	self:SetRenderOrigin( pos );
	self:SetRenderAngles( ang );
	self:SetupBones();
	self:DrawModel();

end
