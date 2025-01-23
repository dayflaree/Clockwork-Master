
include( "shared.lua" );

function ENT:Draw()

	if( self:GetModel() == "models/props_junk/garbage_bag001a.mdl" ) then
	
		self:SetColor( 50, 50, 50, 255 );
	
	end

	self.Entity:DrawModel();
	
	if( TS.HUDItemInfo ) then
		
		local trace = { }
		trace.start = LocalPlayer():EyePos();
		trace.endpos = trace.start + LocalPlayer():GetAimVector() * 90;
		trace.filter = LocalPlayer();
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity ~= self.Entity ) then return; end
	
		if( not TS.HUDItemInfo[self.Entity:EntIndex()] ) then
		
			RunConsoleCommand( "eng_reciteminfo", self.Entity:EntIndex() );
			TS.HUDItemInfo[self.Entity:EntIndex()] = { }
		
			local check = function()
			
				if( not self.Entity or not self.Entity:IsValid() ) then return; end
			
				if( not self.Entity.ItemName ) then
					TS.HUDItemInfo[self.Entity:EntIndex()] = nil;
				end
				
			end
		
			timer.Simple( 2, check );
		
		elseif( not self.Entity.ItemName ) then
		
			TS.HUDItemInfo[self.Entity:EntIndex()] = nil;
		
		end
	
	end
	
end