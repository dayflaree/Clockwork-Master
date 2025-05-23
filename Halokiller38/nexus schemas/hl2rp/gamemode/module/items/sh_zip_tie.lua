--[[
Name: "sh_zip_tie.lua".
Product: "Half-Life 2".
--]]

local ITEM = {};

ITEM.name = "Zip Tie";
ITEM.cost = 4;
ITEM.model = "models/items/crossbowrounds.mdl";
ITEM.weight = 0.2;
ITEM.access = "v";
ITEM.useText = "Tie";
ITEM.factions = {FACTION_MPF, FACTION_OTA};
ITEM.business = true;
ITEM.description = "An orange zip tie with Thomas and Betts printed on the side.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player.isTying) then
		resistance.player.Notify(player, "You are already tying a character!");
		
		return false;
	else
		local trace = player:GetEyeTraceNoCursor();
		local target = resistance.entity.GetPlayer(trace.Entity);
		local tieTime = MODULE:GetDexterityTime(player);
		
		if (target) then
			if (target:GetSharedVar("sh_Tied") == 0) then
				if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
					if ( target:GetAimVector():DotProduct( player:GetAimVector() ) > 0 or target:IsRagdolled() ) then
						resistance.player.SetAction(player, "tie", tieTime);
						
						resistance.player.EntityConditionTimer(player, target, trace.Entity, tieTime, 192, function()
							if (player:Alive() and !player:IsRagdolled() and target:GetSharedVar("sh_Tied") == 0
							and target:GetAimVector():DotProduct( player:GetAimVector() ) > 0) then
								return true;
							end;
						end, function(success)
							if (success) then
								player.isTying = nil;
								
								MODULE:TiePlayer( target, true, nil, MODULE:PlayerIsCombine(player) );
								
								if ( MODULE:PlayerIsCombine(target) ) then
									local location = MODULE:PlayerGetLocation(player);
									
									MODULE:AddCombineDisplayLine("Downloading lost radio contact information...", Color(255, 255, 255, 255), nil, player);
									MODULE:AddCombineDisplayLine("WARNING! Radio contact lost for unit at "..location.."...", Color(255, 0, 0, 255), nil, player);
								end;
								
								player:UpdateInventory("zip_tie", -1);
								player:ProgressAttribute(ATB_DEXTERITY, 15, true);
							else
								player.isTying = nil;
							end;
							
							resistance.player.SetAction(player, "tie", false);
						end);
					else
						resistance.player.Notify(player, "You cannot tie characters that are facing you!");
						
						return false;
					end;
					
					player.isTying = true;
					
					resistance.player.SetMenuOpen(player, false);
					
					return false;
				else
					resistance.player.Notify(player, "This character is too far away!");
					
					return false;
				end;
			else
				resistance.player.Notify(player, "This character is already tied!");
				
				return false;
			end;
		else
			resistance.player.Notify(player, "That is not a valid character!");
			
			return false;
		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player.isTying) then
		resistance.player.Notify(player, "You are currently tying a character!");
		
		return false;
	end;
end;

resistance.item.Register(ITEM);