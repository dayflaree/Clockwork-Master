local ITEM = Clockwork.item:New(nil, true);

ITEM.name = "Civil Protection Bug";
ITEM.uniqueID = "bug_base";
ITEM.model = "models/props_lab/citizenradio.mdl";
ITEM.weight = 5;
ITEM.category = "Communication";
ITEM.business = false;
ITEM.tuningDisabled = false;
ITEM.frequencyID = "freq_0000";
ITEM.description = "A small, synthetic item disguised as a brick. It has an inbuilt speaker and microphone.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	local trace = player:GetEyeTraceNoCursor();
	if (player:GetFaction() == FACTION_MPF) then

	if (trace.HitPos:Distance( player:GetShootPos() ) <= 192) then
		local radio = ents.Create("cw_bug");
		
		Clockwork.player:GiveProperty(player, radio);
		
		radio:SetItemTable(self);
		radio:SetModel(self.model);
		radio:SetPos(trace.HitPos);
		radio:Spawn();

		if (self("frequencyID")) then
			radio:SetFrequency(self("frequencyID"));
		end;

		if (self("tuningDisabled")) then
			radio:SetDisableChannelTuning(true);
		end;
		
		if (IsValid(itemEntity)) then
			local physicsObject = itemEntity:GetPhysicsObject();
			
			radio:SetPos( itemEntity:GetPos() );
			radio:SetAngles( itemEntity:GetAngles() );
			
			if (IsValid(physicsObject)) then
				if (!physicsObject:IsMoveable()) then
					physicsObject = radio:GetPhysicsObject();
					
					if (IsValid(physicsObject)) then
						physicsObject:EnableMotion(false);
					end;
				end;
			end;
		else
			Clockwork.entity:MakeFlushToGround(radio, trace.HitPos, trace.HitNormal);
		end;
	else
		Clockwork.player:Notify(player, "You cannot drop a bug that far away!");
		
		return false;
	end;
	else return false; 
	end
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) end;

ITEM:Register();