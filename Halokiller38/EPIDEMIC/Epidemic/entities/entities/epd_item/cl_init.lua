
include( "shared.lua" );

function ENT:Draw()

	self.Entity:DrawModel();
	
	if( HUDItemInfo ) then
		
		local trace = { }
		trace.start = LocalPlayer():EyePos();
		trace.endpos = trace.start + LocalPlayer():GetAimVector() * 70;
		trace.filter = LocalPlayer();
		
		local tr = util.TraceLine( trace );
		
		if( tr.Entity ~= self.Entity ) then return; end
	
		if( not HUDItemInfo[self.Entity:EntIndex()] ) then
		
			RunConsoleCommand( "eng_reciteminfo", self.Entity:EntIndex() );
			HUDItemInfo[self.Entity:EntIndex()] = { }
		
			local check = function()
			
				if( not self.Entity or not self.Entity:IsValid() ) then return; end
			
				if( not self.Entity:GetTable().ItemName ) then
					HUDItemInfo[self.Entity:EntIndex()] = nil;
				end
				
			end
		
			timer.Simple( 2, check );
		
		elseif( not self.Entity:GetTable().ItemName ) then
		
			HUDItemInfo[self.Entity:EntIndex()] = nil;
		
		end
	
	end
	
end