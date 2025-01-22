local ITEM = Clockwork.item:New();
ITEM.name = "Padded Green Jeans";
ITEM.model = "models/fty/items/pants_rebel.mdl";
ITEM.weight = 1.8;
ITEM.useText = "Wear Pants";
ITEM.category = "Clothing";
ITEM.description = "A pair of jeans that are reinforced with kevlar pads, take caution and avoid wearing this from the public authoritary eye.";
ITEM.customFunctions = {"Remove"};
ITEM.access = "V";
ITEM.cost = 200;  
ITEM.business = true;  
ITEM.addInvSpace = 1.5;
 
local bodyGroup = 2;
 


-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
 
 
                        local target = player
                        local targetBodyGroups = target:GetCharacterData("bodygroups") or {};
                        local bodyGroupState = 0;
                        local model = target:GetModel();
               
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
                local targetBodyGroups = target:GetCharacterData("bodygroups") or {};
                local bodyGroupState = 4;
 
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
 
ITEM:Register();