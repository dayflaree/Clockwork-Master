--[[
Name: "sh_junk_base.lua".
Product: "HL2 RP".
--]]

ITEM = openAura.item:New();
ITEM.name = "Book Base";
ITEM.weight = 0.4;
ITEM.access = "3";
ITEM.category = "Literature";
ITEM.isBaseItem = true;
ITEM.batch = 1;
ITEM.business = true;

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	
	if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
		local entity = ents.Create("aura_book");
		
		openAura.player:GiveProperty(player, entity);
		
		entity:SetModel(self.model);
		entity:SetBook(self.uniqueID);
		entity:SetPos(trace.HitPos);
		entity:Spawn();
		
		if ( IsValid(itemEntity) ) then
			local physicsObject = itemEntity:GetPhysicsObject();
			
			entity:SetPos( itemEntity:GetPos() );
			entity:SetAngles( itemEntity:GetAngles() );
			
			if ( IsValid(physicsObject) ) then
				if ( !physicsObject:IsMoveable() ) then
					physicsObject = entity:GetPhysicsObject();
					
					if ( IsValid(physicsObject) ) then
						physicsObject:EnableMotion(false);
					end;
				end;
			end;
		else
			openAura.entity:MakeFlushToGround(entity, trace.HitPos, trace.HitNormal);
		end;
	else
		openAura.player:Notify(player, "You cannot drop a book that far away!");
		
		return false;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

-- Called when the item should be setup.
function ITEM:OnSetup()
	if (self.bookInformation) then
		self.bookInformation = string.gsub( string.gsub(self.bookInformation, "\n", "<br>"), "\t", string.rep("&nbsp;", 4) );
		self.bookInformation = "<html><font face='Arial' size='2'>"..self.bookInformation.."</font></html>";
	end;
end;

openAura.item:Register(ITEM);