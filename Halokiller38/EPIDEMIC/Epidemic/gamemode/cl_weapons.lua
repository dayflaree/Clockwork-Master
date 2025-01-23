
if( LightWeaponIcon ) then
	LightWeaponIcon:Remove();
	LightWeaponIcon = nil;
end

if( HeavyWeaponIcon ) then
	HeavyWeaponIcon:Remove();
	HeavyWeaponIcon = nil;
end

function CreateHeavyWeaponIcon( id )

	if( HeavyWeaponIcon ) then
		HeavyWeaponIcon:Remove();
	end

	local weap = weapons.Get( id );
	
	local w = weap.HUDWidth or 0;
	local h = weap.HUDHeight or 0;
	
	HeavyWeaponIcon = CreateModelIcon( weap.ItemModel or weap.WorldModel, weap.IconCamPos,  weap.IconLookAt, weap.IconFOV );
	HeavyWeaponIcon:SetSize( w, h );
	HeavyWeaponIcon:SetPos( ScrW() - 150 - w * .5, ScrH() - 72 - h * .5 );
	HeavyWeaponIcon:SetAmbientLight( Color( 255, 255, 255, 255 ) );
	
	HeavyWeaponIcon.OnMousePressed = function( pnl, mc )

		InventorySelection = 
		{
		
			dragging = false,
			weapon = true,
			heavyweap = true,
			Inv = -2,
			model = weap.ItemModel or weap.WorldModel,
			x = -1,
			y = -1,
			w = w, 
			h = h,
			tx = -1,
			ty = -1,
			id = id,
		
		};


		if( mc == MOUSE_LEFT ) then

			InventorySelection.dragging = true;
			StartItemDragging( weap.ItemModel or weap.WorldModel, weap.IconCamPos, weap.IconLookAt, weap.IconFOV, w, h );
		
		else
		
			CreateInventoryActionMenu( ItemData[id] );
	
		end
		
	end
	
end


function CreateLightWeaponIcon( id )

	if( LightWeaponIcon ) then
		LightWeaponIcon:Remove();
	end

	local weap = weapons.Get( id );
	
	local w = weap.HUDWidth or 0;
	local h = weap.HUDHeight or 0;
	
	LightWeaponIcon = CreateModelIcon( weap.ItemModel or weap.WorldModel, weap.IconCamPos,  weap.IconLookAt, weap.IconFOV );
	LightWeaponIcon:SetSize( w, h );
	LightWeaponIcon:SetPos( ScrW() - 108 - w * .5, ScrH() - 200 - h * .5 );
	LightWeaponIcon:SetAmbientLight( Color( 255, 255, 255, 255 ) );
	
	LightWeaponIcon.OnMousePressed = function( pnl, mc )

		InventorySelection = 
		{
		
			dragging = false,
			weapon = true,
			lightweap = true,
			Inv = -1,
			model = weap.ItemModel or weap.WorldModel,
			x = -1,
			y = -1,
			w = w, 
			h = h,
			tx = -1,
			ty = -1,
			id = id,
		
		};


		if( mc == MOUSE_LEFT ) then

			InventorySelection.dragging = true;
			StartItemDragging( weap.ItemModel or weap.WorldModel, weap.IconCamPos, weap.IconLookAt, weap.IconFOV, w, h );
		
		else
		
			CreateInventoryActionMenu( ItemData[id] );
	
		end
		
	end
	
end

function UpdateWeaponIcons()

	if( LightWeaponIcon ) then

		LightWeaponIcon:SetVisible( PlayerMenuPanel:IsVisible() );

	end

	if( HeavyWeaponIcon ) then

		HeavyWeaponIcon:SetVisible( PlayerMenuPanel:IsVisible() );

	end

end

function event.RMHWEAP()

	if( HeavyWeaponIcon ) then
	
		HeavyWeaponIcon:Remove();
		HeavyWeaponIcon = nil;
		CurrentHeavyWeapon = nil;
	
	end

end

function event.RMLWEAP()

	if( LightWeaponIcon ) then
	
		LightWeaponIcon:Remove();
		LightWeaponIcon = nil;
		CurrentLightWeapon = nil;
	
	end

end

function msgs.HWEAP( msg )

	local id = msg:ReadString();

	CreateHeavyWeaponIcon( id );
	
	CurrentHeavyWeapon = id;
	
	UpdateWeaponIcons();

end

function msgs.LWEAP( msg )

	local id = msg:ReadString();

	CreateLightWeaponIcon( id );
	
	CurrentLightWeapon = id;

	UpdateWeaponIcons();

end

function msgs.SWH( msg )

	--Why doesn't clientside have a :GetWeapon()?
	local weaps = LocalPlayer():GetWeapons();

	local id = msg:ReadString();
	local hp = msg:ReadShort();

	for k, v in pairs( weaps ) do
	
		if( v:GetClass() == id ) then
		
			v:GetTable().HealthAmt = hp;
			return;
		
		end
	
	end
	
end

function msgs.SAMM( msg )

	--Why doesn't clientside have a :GetWeapon()?
	local weaps = LocalPlayer():GetWeapons();

	local id = msg:ReadString();
	local amt = msg:ReadShort();

	for k, v in pairs( weaps ) do
	
		if( v:GetClass() == id and v:GetTable() and v:GetTable().Primary ) then
		
			v:GetTable().Primary.CurrentClip = amt;
			return;
		
		end
	
	end
	
end

function msgs.UJW( msg )

	local weap = msg:ReadEntity();
	
	if( weap and weap:IsValid() ) then
	
		weap:GetTable().Jammed = false;
	
	end

end
