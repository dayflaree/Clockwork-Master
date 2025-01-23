
function GM:PlayerCanSeePlayersChat( strText, bTeamOnly, pListener, pSpeaker )
	if pListener.SpecEntity != nil then
		pListener = pListener.SpecEntity
	end
	if bTeamOnly then
		return true
	end
	local exploded = string.Explode(" ",strText)
	if string.find(exploded[1],"/sa") && pListener:GetLevel() <= 1 then
		return true
	end
	if string.find(exploded[1],"/a") && pListener:GetLevel() <= 3 then
		return true
	end
	if pListener != pSpeaker then 
		if pListener:Alive() then 
			if string.find(exploded[1],"///") then
				if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600 then
					return true
				end
			elseif string.find(exploded[1],"//") && !string.find(exploded[1],"///") then 
				return true
			elseif string.find(exploded[1],"/account") then
				return false
			elseif string.find(exploded[1],"/") && !string.find(exploded[1],"//") && !string.find(exploded[1],"///") then
				if string.find(exploded[1],"/me") then 
					if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
						return true
					elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
						return true
					end
				elseif string.find(exploded[1],"/help") then 
					if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
						return true
					elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
						return true
					end
				elseif string.find(exploded[1],"/broadcast") then 
					if !pSpeaker:GetNWBool("Handcuffed") then 
						return true
					end
				elseif string.find(exploded[1],"/advert") then
					if !pSpeaker:GetNWBool("Handcuffed") then 
						if pSpeaker:HasItem("item_cell") then 
							return true
						end
						--[[if pSpeaker:GetMoney(WALLET) >= 10 then
							pSpeaker:TakeMoney(WALLET,10)
							pSpeaker:Hint("You have purchased an advert for $10")
							return true
						else
							pSpeaker:Hint("You do not have $10 in your wallet")
							return false
						end]]
					end
				elseif string.find(exploded[1],"/pm") then
					local strTextExploded = string.Explode(" ", strText)
					local Name = string.lower(strTextExploded[2])
					if !pSpeaker:GetNWBool("Handcuffed") then 
						if pSpeaker:HasItem("item_cell") then 
							if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
								return true
							elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
								return true
							elseif string.find(string.lower(pListener:Nick()), Name) then
								return true
							end
						end
					end
				elseif string.find(exploded[1],"/org") then
					if !pSpeaker:GetNWBool("Handcuffed") then 
						if pSpeaker:HasItem("item_cell") then 
							if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
								return true
							elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
								return true		
							elseif pSpeaker:GetOrg() != 0 then
								if pListener.Org == pSpeaker.Org then
									return true
								end
							end
						end
					end
				elseif string.find(exploded[1],"/radio") then
					if !pSpeaker:GetNWBool("Handcuffed") then 
						if pSpeaker:HasItem("item_policeradio") then
							if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
								return true
							elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
								return true					
							elseif pListener:Team() != CLASS_CITIZEN then
								return true
							end
						end
					end
				elseif string.find(exploded[1],"/911") then 
					if !pSpeaker:GetNWBool("Handcuffed") then 
						if pSpeaker:HasItem("item_cell") then 
							if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
								return true
							elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
								return true					
							elseif pListener:Team() != CLASS_CITIZEN then
								for _,ply in pairs(player.GetAll()) do
									if ply:Team() != CLASS_CITIZEN then
										local txt = string.gsub(strText,"/911","")
										umsg.Start("OCRP_911Alert", ply)
										umsg.String(pSpeaker:Nick().." : "..txt)
										umsg.Long(CurTime() + 30)
										umsg.End()
									end
									return true
								end
							end
						end
					end
				elseif string.find(exploded[1],"/711") then 
					if !pSpeaker:GetNWBool("Handcuffed") then 
						if pSpeaker:HasItem("item_cell") then 
							if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
								return true
							elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
								return true					
							elseif pListener:Team() != CLASS_CITIZEN then
								for _,ply in pairs(player.GetAll()) do
									if ply:Team() != CLASS_CITIZEN then
										local txt = string.gsub(strText,"/911","")
										umsg.Start("OCRP_911Alert", ply)
										umsg.String(pSpeaker:Nick().." : "..txt)
										umsg.Long(CurTime() + 30)
										umsg.End()
									end
									return true
								end
							end
						end
					end
				elseif string.find(exploded[1],"/411") then 
					if !pSpeaker:GetNWBool("Handcuffed") then 
						if pSpeaker:HasItem("item_cell") then 
							if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 300 then
								return true
							elseif pListener:GetPos():Distance(pSpeaker:GetPos()) <= 600  && pListener:Visible(pSpeaker) then
								return true					
							elseif pListener:Team() != CLASS_CITIZEN then
								for _,ply in pairs(player.GetAll()) do
									if ply:Team() != CLASS_CITIZEN then
										local txt = string.gsub(strText,"/911","")
										umsg.Start("OCRP_911Alert", ply)
										umsg.String(pSpeaker:Nick().." : "..txt)
										umsg.Long(CurTime() + 30)
										umsg.End()
									end
									return true
								end
							end
						end
					end
				elseif string.find(exploded[1],"/y") then
					if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 800 then
						return true
					end
				elseif string.find(exploded[1],"/w") then
					if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 200 then
						return true
					end
				end
			else
				if pListener:GetPos():Distance(pSpeaker:GetPos()) <= 400 then
					return true
				end
			end
		end
		if string.find(exploded[1],"//") && !string.find(exploded[1],"///") then 
			return true
		end
		return false
	else
		return true 
	end
end

function ISaid( pSpeaker, strText, team, death )
	for _,ply1 in pairs(player.GetAll()) do
		if GAMEMODE:PlayerCanSeePlayersChat( strText, false, ply1, pSpeaker ) then
			return strText
		end
	end
end
hook.Add( "PlayerSay", "ISaid", ISaid );

concommand.Add("OCRP_IsTyping",function(ply1,cmd,args) 
									for _,ply in pairs(player.GetAll()) do
										umsg.Start("OCRP_IsTyping", ply)
										umsg.Entity(ply1)
										umsg.Bool(true)
										umsg.End()
									end
								end)
								
concommand.Add("OCRP_EndTyping",function(ply1,cmd,args) 
						for _,ply in pairs(player.GetAll()) do
							umsg.Start("OCRP_IsTyping", ply)
								umsg.Entity(ply1)
								umsg.Bool(false)
							umsg.End()
						end	
end)						
								
concommand.Add("OCRP_Broadcast", 
function(ply, command, args) 
	if ply:Team() != CLASS_Mayor  then return end
	for _,ply in pairs(player.GetAll()) do
		umsg.Start("OCRP_CreateBroadcast", ply)
		umsg.String(args[1])
		umsg.Long(CurTime() + args[2])
		umsg.End()
	end
end)

--[[function GM:PlayerCanHearPlayersVoice( ply1, ply2 )
	if ply1.SpecEntity != nil then
		ply1 = ply1.SpecEntity
	end
	if !ply1:IsValid() or !ply2:IsValid() then return false end
	if !ply1:Alive() then return false end
	if !ply2:Alive() then return false end
	if ply1:GetPos():Distance(ply2:GetPos()) < 500 then 
		if ply1:Visible(ply2) then
			return true 
		elseif ply1:GetPos():Distance(ply2:GetPos()) < 150 then
			return true 
		end	
	end
	return false
end
]]

-- function PoliceRadioToggle( ply,cmd,args )
	-- if !ply.PoliceRadio then ply.PoliceRadio = true end
	-- if ply.PoliceRadio == true then
		-- ply.PoliceRadio = false
	-- else
		-- ply.PoliceRadio = true
	-- end
-- end
-- concommand.Add("OCRP_PoliceRadioToggle",PoliceRadioToggle)

-- function GM:PlayerCanHearPlayersVoice( ply1, ply2 )
	-- if ply1.SpecEntity != nil then
		-- ply1 = ply1.SpecEntity
	-- end
	-- if !ply1:IsValid() or !ply2:IsValid() then return false, false end
	-- if !ply1:Alive() then return false, false end
	-- if !ply2:Alive() then return false, false end
	-- if (ply2:Team() != CLASS_CITIZEN and ply2.PoliceRadio == true) and (ply1:Team() != CLASS_CITIZEN) then
		-- return true
	-- end
	-- if ply1:GetPos():Distance(ply2:GetPos()) < 700 then -- JAKE: When you see this - Added the fading voice functionality. Piss easy to remove, just remove the second fale/trues. May end up keeping though.
		-- if ply1:Visible(ply2) then
			-- return true, true 
		-- elseif ply1:GetPos():Distance(ply2:GetPos()) < 150 then
			-- return true, true
		-- end	
	-- end
	-- return false, false
-- end

ChatRadius_Whisper = 200;
ChatRadius_Local = 600;
ChatRadius_Yell = 800;


function GM:PlayerCanHearPlayersVoice ( ply1, ply2 )
	if ply1.SpecEntity != nil then
		ply1 = ply1.SpecEntity
	end
	if !ply1:IsValid() or !ply2:IsValid() then return false, false end
	if !ply1:Alive() then return false, false end
	if !ply2:Alive() then return false, false end

	if ply1:GetPos():Distance(ply2:GetPos()) < 700 then -- JAKE: When you see this - Added the fading voice functionality. Piss easy to remove, just remove the second fale/trues. May end up keeping though.
		if ply1:Visible(ply2) then
			return true, true 
		elseif ply1:GetPos():Distance(ply2:GetPos()) < 150 then
			return true, true
		end	
	end

	
	local wereGov = ply1:Team() != CLASS_CITIZEN && ply1:Team() != CLASS_MAYOR;
	local theyreGov = ply2:Team() != CLASS_CITIZEN && ply2:Team() != CLASS_MAYOR;
	
	if (wereGov && theyreGov && ply2:GetNWBool("tradio", false)) then return true end
	
	if (theyreGov && ply2:GetNWBool("tradio", false)) then
		local nearCop;
		for k, v in pairs(player.GetAll()) do
			if (v:GetPos():Distance(ply1:GetPos()) < ChatRadius_Whisper && v:Team() != CLASS_CITIZEN) then
				nearCop = true;
				break;
			end
		end
		
		if (!nearCop) then
			for k, v in pairs(ents.FindByClass("prop_vehicle_jeep")) do
				if (v:GetPos():Distance(ply1:GetPos()) < ChatRadius_Whisper && v.vehicleTable && v.vehicleTable.RequiredClass) then
					nearCop = true;
					break;
				end
			end
		end
		
		if (nearCop) then return true end
	end
	
	return false
end

function GM.ChangeRadioTalking ( Player, Cmd, Args )
	if (!Args[1]) then return; end
	
	if (tonumber(Args[1]) == 1) then
		Player:SetNWBool("tradio", true);
	else
		Player:SetNWBool("tradio", false);
	end
end
concommand.Add("ocrp_tr", GM.ChangeRadioTalking);



function SV_PrintToAdmin( Speaker, ChatType, Message )
	for k, v in pairs(player.GetAll()) do
		umsg.Start( "ocrp_printadmin", v )
			umsg.String( Speaker:Nick() )
			umsg.String( ChatType )
			umsg.String( Message )
		umsg.End()
	end
end
