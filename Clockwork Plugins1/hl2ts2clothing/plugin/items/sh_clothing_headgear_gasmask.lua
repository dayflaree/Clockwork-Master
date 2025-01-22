local ITEM = Clockwork.item:New();
ITEM.name = "Civilian Gas Mask";
ITEM.model = "models/fty/items/gasmask.mdl";
ITEM.weight = 2;
ITEM.useText = "Wear";
ITEM.uniqueID = "civilian_gasmask"
ITEM.category = "Clothing";
ITEM.description = "Dirty gasmask, contains few union modifications.";
ITEM.customFunctions = {"Remove"};
ITEM.access = "V";
ITEM.cost = 50;  
ITEM.business = true;  
 
local bodyGroup = 4;
 
 
-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
 
 
                        local target = player
                        local targetBodyGroups = target:GetCharacterData("bodygroups") or {};
                        local bodyGroupState = 0;
                        local model = target:GetModel();
						
						player:PlayerWearGasmask(nil);
               
                        if( bodyGroup < target:GetNumBodyGroups() )then
                                targetBodyGroups[model] = targetBodyGroups[model] or {};
                       
                                if( bodyGroupState == 0 )then
                                        targetBodyGroups[model][tostring(bodyGroup)] = nil;
                                else
                                        targetBodyGroups[model][tostring(bodyGroup)] = bodyGroupState;
                                end;
                       
                                target:SetBodygroup(bodyGroup, bodyGroupState);
                       
                                target:SetCharacterData("bodygroups", targetBodyGroups);
                               
                        end;
return true
               
end;
 
 
-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
        if (player:Alive() and !player:IsRagdolled()) then
                if (!self.CanPlayerWear or self:CanPlayerWear(player, itemEntity) != false) then
               
                local target = player
                local targetBodyGroups = target:GetCharacterData("bodygroups", {});
                local bodyGroupState = 2;
				
				player:PlayerWearGasmask(self);
 
                local model = target:GetModel();
               
                if( bodyGroup < target:GetNumBodyGroups() )then
                        targetBodyGroups[model] = targetBodyGroups[model] or {};
                       
                        if( bodyGroupState == 0 )then
                                targetBodyGroups[model][tostring(bodyGroup)] = nil;
                        else
                                targetBodyGroups[model][tostring(bodyGroup)] = bodyGroupState;
                        end;
                       
						target:SetCharacterData("bodygroups", targetBodyGroups);
						target:SetBodygroup(bodyGroup, bodyGroupState);
               
                        return true;
 
                        end;
                end;
        end;
end;
 
if (SERVER) then
        function ITEM:OnCustomFunction(player, name)
                if (name == "Remove") then
               
                        local target = player
                        local targetBodyGroups = target:GetCharacterData("bodygroups") or {};
                        local bodyGroupState = 0;
                        local model = target:GetModel();
						
								player:PlayerWearGasmask(nil);
               
                        if( bodyGroup < target:GetNumBodyGroups() )then
                                targetBodyGroups[model] = targetBodyGroups[model] or {};
                       
                                if( bodyGroupState == 0 )then
                                        targetBodyGroups[model][tostring(bodyGroup)] = nil;
                                else
                                        targetBodyGroups[model][tostring(bodyGroup)] = bodyGroupState;
                                end;
                       
                                target:SetBodygroup(bodyGroup, bodyGroupState);
                       
                                target:SetCharacterData("bodygroups", targetBodyGroups);
                               
                        end;
                                               
end;
end;
end;

function ITEM:GetLocalAmount(amount)
	if (Clockwork.Client:GetSharedVar("Gasmask") == self.index) then
		return amount - 1;
	else
		return amount;
	end;
end;

function ITEM:HasPlayerEquipped(player, arguments)
	if (SERVER) then
		return (player:GetCharacterData("Gasmask") == self.index);
	else
		return (player:GetSharedVar("Gasmask") == self.index);
	end;
end;

function ITEM:OnPlayerUnequipped(player, arguments)
	   local target = player
                        local targetBodyGroups = target:GetCharacterData("bodygroups") or {};
                        local bodyGroupState = 0;
                        local model = target:GetModel();
						
						player:PlayerWearGasmask(nil);
               
                        if( bodyGroup < target:GetNumBodyGroups() )then
                                targetBodyGroups[model] = targetBodyGroups[model] or {};
                       
                                if( bodyGroupState == 0 )then
                                        targetBodyGroups[model][tostring(bodyGroup)] = nil;
                                else
                                        targetBodyGroups[model][tostring(bodyGroup)] = bodyGroupState;
                                end;
                       
                                target:SetBodygroup(bodyGroup, bodyGroupState);
                       
                                target:SetCharacterData("bodygroups", targetBodyGroups);
                               
                        end;
return true
end;
 
ITEM:Register();