--[[
Name: "sv_auto.lua".
Product: "Half-Life 2".
--]]

local PLUGIN = PLUGIN;

RESISTANCE:IncludePrefixed("sh_auto.lua");

resistance.hint.Add("Books", "Invest in a book, give your character some knowledge.");

RESISTANCE:HookDataStream("TakeBook", function(player, data)
	if ( IsValid(data) ) then
		if (data:GetClass() == "roleplay_book") then
			if ( player:GetPos():Distance( data:GetPos() ) <= 192 and player:GetEyeTraceNoCursor().Entity == data) then
				local success, fault = player:UpdateInventory(data.book.uniqueID, 1);
				
				if (!success) then
					resistance.player.Notify(player, fault);
				else
					data:Remove();
				end;
			end;
		end;
	end;
end);

-- A function to load the books.
function PLUGIN:LoadBooks()
	local books = RESISTANCE:RestoreModuleData( "plugins/books/"..game.GetMap() );
	
	for k, v in pairs(books) do
		if ( resistance.item.GetAll()[v.book] ) then
			local entity = ents.Create("roleplay_book");
			
			resistance.player.GivePropertyOffline(v.key, v.uniqueID, entity);
			
			entity:SetAngles(v.angles);
			entity:SetBook(v.book);
			entity:SetPos(v.position);
			entity:Spawn();
			
			if (!v.moveable) then
				local physicsObject = entity:GetPhysicsObject();
				
				if ( IsValid(physicsObject) ) then
					physicsObject:EnableMotion(false);
				end;
			end;
		end;
	end;
end;

-- A function to save the books.
function PLUGIN:SaveBooks()
	local books = {};
	
	for k, v in pairs( ents.FindByClass("roleplay_book") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		books[#books + 1] = {
			key = resistance.entity.QueryProperty(v, "key"),
			book = v.book.uniqueID,
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = resistance.entity.QueryProperty(v, "uniqueID"),
			position = v:GetPos()
		};
	end;
	
	RESISTANCE:SaveModuleData("plugins/books/"..game.GetMap(), books);
end;