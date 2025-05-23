--[[
	� 2011 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM = openAura.item:New();
ITEM.name = "Zip Tie";
ITEM.cost = 1500;
ITEM.model = "models/items/crossbowrounds.mdl";
ITEM.weight = 0.1;
ITEM.useText = "Tie";
ITEM.business = true;
ITEM.access = "T";
ITEM.description = "An orange zip tie with Thomas and Betts printed on the side.";

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (player.isTying) then
		openAura.player:Notify(player, "You are already tying a character!");
		
		return false;
	else
		local trace = player:GetEyeTraceNoCursor();
		local target = openAura.entity:GetPlayer(trace.Entity);
		
		if ( target and target:Alive() ) then
			if ( !target:GetSharedVar("tied") ) then
				if (target:GetShootPos():Distance( player:GetShootPos() ) <= 192) then
					local canTie = (target:GetAimVector():DotProduct( player:GetAimVector() ) > 0);
					local tieTime = openAura.schema:GetDexterityTime(player);
					
					if ( openAura.augments:Has(player, AUG_QUICKHANDS) ) then
						tieTime = tieTime * 0.7;
					end;
					
					if ( canTie or target:IsRagdolled() ) then
						openAura.player:SetAction(player, "tie", tieTime);
						
						target:SetSharedVar("beingTied", true);
						
						openAura.player:EntityConditionTimer(player, target, trace.Entity, tieTime, 192, function()
							local canTie = (target:GetAimVector():DotProduct( player:GetAimVector() ) > 0);
							
							if ( ( canTie or target:IsRagdolled() ) and player:Alive() and !player:IsRagdolled()
							and !target:GetSharedVar("tied") ) then
								return true;
							end;
						end, function(success)
							if (success) then
								player.isTying = nil;
								
								openAura.schema:TiePlayer(target, true);
								
								player:UpdateInventory("zip_tie", -1);
								player:ProgressAttribute(ATB_DEXTERITY, 15, true);
								
								openAura.victories:Progress(player, VIC_ZIPNINJA);
							else
								player.isTying = nil;
							end;
							
							openAura.player:SetAction(player, "tie", false);
							
							if ( IsValid(target) ) then
								target:SetSharedVar("beingTied", false);
							end;
						end);
					else
						openAura.player:Notify(player, "You cannot tie characters that are facing you!");
						
						return false;
					end;
					
					openAura.player:SetMenuOpen(player, false);
					
					player.isTying = true;
					
					return false;
				else
					openAura.player:Notify(player, "This character is too far away!");
					
					return false;
				end;
			else
				openAura.player:RunOpenAuraCommand(player, "CharSearch");
				
				return false;
			end;
		else
			openAura.player:Notify(player, "That is not a valid character!");
			
			return false;
		end;
	end;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position)
	if (player.isTying) then
		openAura.player:Notify(player, "You are currently tying a character!");
		
		return false;
	end;
end;

openAura.item:Register(ITEM);