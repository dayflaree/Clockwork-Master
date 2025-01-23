
local meta = FindMetaTable( "Entity" );

function meta:AttachProp( model, attachment, stayafterdead, skin )

	local ent = ents.Create( "ep_attachment" );
	ent:SetModel( model );
	ent:SetSkin( skin or 0 );
	ent:SetPlayer( self, attachment );
	--ent:SetAngleOffset( Angle( 0, 45, 0 ) );
	ent:Spawn();
	
	table.insert( self:GetTable().AttachedProps, { Model = model, Attachment = attachment, Entity = ent } );

	ent:GetTable().KeepAfterDeath = stayafterdead;

	return ent;

end

function meta:RemoveAttachmentFrom( attachment )

	for k, v in pairs( self:GetTable().AttachedProps ) do
	
		if( v.Attachment == attachment ) then
		
			if( v.Entity:IsValid() ) then
		
				v.Entity:Remove();
				
			end
			
			self:GetTable().AttachedProps[k] = nil;
		
		end
	
	end

end

function meta:AttachCig()
	
	local cig = self:AttachProp( "models/phycigold.mdl", "ValveBiped.Bip01_Head1" );
	self:SetNWEntity( "ActiveCig", cig );
	
	timer.Simple( 300, function()
		
		if( cig and cig:IsValid() ) then
			
			cig:Remove();
			
		end
		
	end );
	
end

function meta:AttachGlasses1()
	
	local glass = self:AttachProp( "models/katharsmodels/glasses-1/glasses-1.mdl", "ValveBiped.Bip01_Head1" );
	self.ActiveGlasses = glass;
	
end

function meta:AttachGlasses2()
	
	local glass = self:AttachProp( "models/katharsmodels/glasses-2/glasses-2.mdl", "ValveBiped.Bip01_Head1" );
	self.ActiveGlasses = glass;
	
end

function meta:AttachGlasses3()
	
	local glass = self:AttachProp( "models/katharsmodels/glasses-2-2/glasses-2-2.mdl", "ValveBiped.Bip01_Head1" );
	self.ActiveGlasses = glass;
	
end

function meta:DetatchGlasses()
	
	if( self.ActiveGlasses and self.ActiveGlasses:IsValid() ) then
		
		self.ActiveGlasses:Remove();
		
	end
	
	self.ActiveGlasses = nil;
	
end
