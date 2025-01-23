
ITEM.Name = "Glasses";
ITEM.NicePhrase = "glasses";
ITEM.Description = "Now you can see things a lot."; 
ITEM.Model = "models/katharsmodels/glasses-1/glasses-1.mdl"
ITEM.CamPos = Vector( 50, 50, 50 );
ITEM.LookAt = Vector( -2, 0, 0 ); 
ITEM.FOV = 7;
ITEM.Width = 1;
ITEM.Height = 1;
ITEM.Flags = "ux";
ITEM.InventoryUse = true;

ITEM.Tier = 3;

function ITEM:Use()
	
	if( self.Owner.ActiveGlasses ) then
		
		self.Owner:DetatchGlasses();
		
	else
		
		self.Owner:AttachGlasses1();
		
	end

end

function ITEM:Drop()

	self.Owner:DetatchGlasses();

end

function ITEM:Examine()
	
	local n = math.random( 1, 2 );
	if( n == 1 ) then
		
		self.Owner:NoticePlainWhite( "A little bent." );
		
	elseif( n == 2 ) then
		
		self.Owner:NoticePlainWhite( "Fingerprints all over the lens." );
		
	end

end
