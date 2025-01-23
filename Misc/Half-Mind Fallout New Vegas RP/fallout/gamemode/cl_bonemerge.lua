local s_Meta = FindMetaTable( "Player" );

function s_Meta:CreateNewBonemerge( szModel )

	b = ClientsideModel( szModel, RENDERGROUP_OPAQUE );
	b:SetModel( szModel );
	b:InvalidateBoneCache();
	b:SetParent( self );
	b:AddEffects( EF_BONEMERGE );
	b:SetupBones();
	function b:Think()

		local ply = self:GetParent();
	
		if( IsValid( ply ) ) then
		
			if( !self.LastParent ) then
		
				if( !self.bLastAliveState ) then
				
					self.bLastAliveState = ply:Alive();
					
				end
				
				if( !self.nLastCharID ) then
					
					self.nLastCharID = ply:CharID();
					
				end
				
			else
			
				if( !self.bLastAliveState ) then
				
					self.bLastAliveState = self.LastParent:Alive();
					
				end
				
				if( !self.nLastCharID ) then
					
					self.nLastCharID = self.LastParent:CharID();
					
				end
			
			
			end

			if( ply:GetNoDraw() and !self.bLastDrawState ) then
			
				self:SetNoDraw( true );
				
			elseif( !ply:GetNoDraw() and self.bLastDrawState ) then
			
				self:SetNoDraw( false );
				
			end

			if( !self.LastParent ) then
			
				if( !ply:Alive() and self.bLastAliveState ) then
					
					print("bonemerging1")
					self.LastParent = ply;
					self:SetParent( ply:GetRagdollEntity() );
					self:AddEffects( EF_BONEMERGE );
					
				end
				
				if( ply:CharID() != self.nLastCharID ) then

					self:Remove();
					
				end
				
			else
			
				if( self.LastParent:Alive() and !self.bLastAliveState ) then
				
					print("bonemerging2")
					self:SetParent( self.LastParent );
					self:AddEffects( EF_BONEMERGE );
					self.LastParent = nil;
					
				end
				
			end
			
		else
		
			if( !IsValid( self.LastParent ) ) then

				self:Remove();
				
			else
			
				print("bonemerging3")
				self:SetParent( self.LastParent );
				self:AddEffects( EF_BONEMERGE );
				self.LastParent = nil;
			
			end
		
		end
		
		self.bLastDrawState = self:GetNoDraw();
		if( !self.LastParent ) then
		
			if( IsValid( ply ) ) then
		
				self.bLastAliveState = ply:Alive();
				self.nLastCharID = ply:CharID();
				
			end
			
		else
			
			if( !IsValid( self.LastParent ) ) then return end
		
			self.bLastAliveState = self.LastParent:Alive();
			self.nLastCharID = self.LastParent:CharID();
		
		end

	end
	hook.Add( "Think", b, b.Think );
	
	return b;

end

GM.BonemergeItems = GM.BonemergeItems or {};
GM.DummyItems = GM.DummyItems or {};

local function nReceiveDummyItem( len )
	
	local s_Owner = net.ReadEntity();
	local s_iID = net.ReadInt( 32 );
	local s_szClass = net.ReadString();
	local s_bIsEquipped = net.ReadBool();
	
	GAMEMODE.DummyItems[s_iID] = {
	
		szClass = s_szClass,
		bIsEquipped = s_bIsEquipped,
		Owner = s_Owner,
		
	};

	hook.Run( "OnReceiveDummyItem", s_iID, GAMEMODE.DummyItems[s_iID] );

end
net.Receive( "nReceiveDummyItem", nReceiveDummyItem );

function GM:OnReceiveDummyItem( s_iID, s_DummyItem )

	local metaitem = GAMEMODE:GetMetaItem( s_DummyItem.szClass );
	if( s_DummyItem.bIsEquipped ) then
	
		GAMEMODE.BonemergeItems[s_iID] = {

			Owner = s_DummyItem.Owner,
			szClass = s_DummyItem.szClass,
			bIsEquipped = s_DummyItem.bIsEquipped,
			
		};
	
	elseif( !s_DummyItem.bIsEquipped and GAMEMODE.BonemergeItems[s_iID] ) then
	
		local metaitem = GAMEMODE:GetMetaItem( GAMEMODE.BonemergeItems[s_iID]["szClass"] );
		local owner = GAMEMODE.BonemergeItems[s_iID]["Owner"];
		if( owner[s_DummyItem.szClass] ) then
		
			if( !isbool( owner[s_DummyItem.szClass] ) ) then
			
				owner[s_DummyItem.szClass]:Remove();
			
			end
			owner[s_DummyItem.szClass] = nil;
			
			if( metaitem.Clothing ) then
			
				owner.BonemergeBody:Remove();
				owner.BonemergeBody = nil;
				
			end
			
		end
		
		GAMEMODE.BonemergeItems[s_iID] = nil;
	
	end

end

local function BonemergeThink()

	for k,v in next, player.GetAll() do
	
		if( !IsValid( v ) ) then continue end
		if( !v.CharID ) then continue end
		if( v:CharID() <= 0 ) then continue end
		
		if( !v.BonemergeHead or !IsValid( v.BonemergeHead ) ) then

			v.BonemergeHead = v:CreateNewBonemerge( v:Face() );
			if( v.BonemergeHead ) then
			
				v.BonemergeHead:SetSubMaterial( v.BonemergeHead:GetFacemap(), v:Facemap() );
				for m,n in pairs( v.BonemergeHead:GetEyemap() ) do
				
					v.BonemergeHead:SetSubMaterial( n, v:Eyemap() ); -- n = eyemap index, v = eyemap mat path
				
				end
				
			end
		
		end
		
		for m,n in next, GAMEMODE.BonemergeItems do

			if( n.Owner == v and ( !v[n.szClass] ) and n.bIsEquipped ) then

				local metaitem = GAMEMODE:GetMetaItem( n.szClass );
				if( metaitem.Clothing ) then
				
					if( v.BonemergeBody ) then
					
						v.BonemergeBody:Remove();
						v.BonemergeBody = nil;
						
					end
				
					local szArms,nSkin = GAMEMODE:GetModelArms( v:GetModel(), v:Face() );
					if( metaitem.UseRealModelPath ) then
						
						szArms = metaitem.HandsPath;
						
					end
					v.BonemergeBody = v:CreateNewBonemerge( szArms );
					if( v.BonemergeBody ) then
					
						v.BonemergeBody:SetSkin( nSkin );
						
					end
					
					v[n.szClass] = true;
					
				end
				
				if( metaitem.BonemergeModel ) then

					local headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, v:Sex() );
					if( metaitem.UseSuffix ) then
					
						headgearMdl = GAMEMODE:GetHeadgearGender( metaitem.BonemergeModel, v:Sex(), true );
						
					end
				
					v[n.szClass] = v:CreateNewBonemerge( headgearMdl );

					if( metaitem.Bodygroup ) then
					
						v[n.szClass]:SetBodygroup( metaitem.Bodygroup, metaitem.BodygroupValue );
						
					end
					
					if( metaitem.Skin ) then
					
						v[n.szClass]:SetSkin( metaitem.Skin );
						
					end
					
				end

			end
		
		end
		
		// this needs to be after the items loop so we can make sure there isnt going to be a body model.
		
		if( !v.BonemergeBody or !IsValid( v.BonemergeBody ) ) then
		
			local szArms,nSkin = GAMEMODE:GetModelArms( v:GetModel(), v:Face() );

			v.BonemergeBody = v:CreateNewBonemerge( szArms );
			if( v.BonemergeBody ) then
			
				v.BonemergeBody:SetSkin( nSkin );
				
			end
		
		end
	
		if( !v.BonemergeHair or !IsValid( v.BonemergeHair ) ) then
			
			v.BonemergeHair = v:CreateNewBonemerge( v:Hair() );
			v.BonemergeFacialHair = v:CreateNewBonemerge( v:FacialHair() );

			if( v.BonemergeHair ) then
			
				v.BonemergeHair:SetColor( v:HairColor() );
				
			end
			
			if( v.BonemergeFacialHair ) then
			
				v.BonemergeFacialHair:SetColor( v:HairColor() );
				
			end
		
		end
	
	end

end
hook.Add( "Think", "Fallout.BonemergeThink", BonemergeThink );