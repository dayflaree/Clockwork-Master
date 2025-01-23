
ITEM.Name = "Knock Out Juice";
ITEM.NicePhrase = "knock out juice";
ITEM.Description = "Watch as your consciousness lowers";
ITEM.Model = "models/props_junk/garbage_metalcan001a.mdl"
ITEM.CamPos = Vector( 50, 78, 90 );
ITEM.LookAt = Vector( 0, 0, 0 ); 
ITEM.FOV = 5;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ex";

ITEM.Tier = 2;

function ITEM:Use()

	local function f()
	
		self.Owner:SetPlayerConscious( math.Clamp( self.Owner:GetPlayerConscious() - 3, 1, 100 ) );
		
		if( self.Owner:GetPlayerConscious() > 1 ) then
		
			timer.Simple( .3, f );
		
		end
	
	end
	
	f();
	
	return true;

end

function ITEM:Examine()
	
	self.Owner:NoticePlainWhite( "Unlabelled tin can." );

end
