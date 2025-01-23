


WALLET = "Wallet"
BANK = "Bank"

function PMETA:UpdateMoney()
	umsg.Start("ocrp_money", self)
		umsg.Long(self:GetMoney( WALLET ))
		umsg.Long(self:GetMoney( BANK ))
	umsg.End()
end

function PMETA:GetMoney( Type )
	return self.OCRPData["Money"][Type]
end

function PMETA:SetMoney( Type, Amount )
	self.OCRPData["Money"][Type] = Amount
	self:UpdateMoney()
end

function PMETA:TakeMoney( Type, Amount )
	if !self.Loaded then return false end
	if self.OCRPData["Money"][Type] < Amount then
		return false
	end
	self.OCRPData["Money"][Type] = self.OCRPData["Money"][Type] - Amount
	self:UpdateMoney()
	SaveMoney( self )
end

function PMETA:AddMoney( Type, Amount, Bool )
	if !self.Loaded then return false end
	if Type == BANK and Bool then
		if self.OCRPData["Money"][WALLET] < Amount then
			return false
		end
	elseif Type == WALLET and Bool then
		if self.OCRPData["Money"][BANK] < Amount then
			return false
		end
	end
	self.OCRPData["Money"][Type] = self.OCRPData["Money"][Type] + Amount
	self:UpdateMoney()
	SaveMoney( self )
end

--[[

function PMETA:SetMoney( Type, amount )
	if Type == WALLET then
		self:SetNWInt( "wallet", amount )
	else
		self:SetNWInt( "bank", amount )
	end
	SaveMoney(self)
end
	
function PMETA:GetMoney( Type )
	if Type == WALLET then
		return tonumber(self:GetNWInt( "wallet" ))
	else
		return tonumber(self:GetNWInt( "bank" ))
	end
end


function PMETA:TakeMoney( Type, amount )
	local curwallet = self:GetMoney(WALLET)
	local curbank = self:GetMoney(BANK)
	
	if Type == WALLET then
		self:SetMoney(WALLET, curwallet - math.Round(amount) )
	else
		self:SetMoney(BANK, curbank - math.Round(amount) )
	end

end

function PMETA:AddMoney( Type, amount)
	local curwallet = self:GetMoney(WALLET)
	local curbank = self:GetMoney(BANK)
	
	if Type == WALLET then
		self:SetMoney(WALLET, curwallet + math.Round(amount) )
	else
		self:SetMoney(BANK, curbank + math.Round(amount) )
	end
end]]--

function PMETA:PayWage()
	if !self:IsValid() then return end
	print("DOING WAGE: Nick: ".. self:Nick() .." Time: ".. CurTime())
	if !self.Loaded then return false end
	local bonus = 1
	if self:GetLevel() <= 4 then
		bonus = 1.25
	end

	if self:Team() == CLASS_CITIZEN then
		self:AddMoney(BANK,math.Round(( (60 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )))
		self:Hint("You have recieved $"..math.Round(( (60 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )).." for being a Citizen of this city. It has been sent to your bank account.")		
	elseif self:Team() == CLASS_POLICE then
		self:AddMoney(BANK, math.Round(( (80 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )) )
		self:Hint("You have recieved $"..math.Round(( (80 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )).." for being a Police officer of this city. It has been sent to your bank account.")		
	elseif self:Team() == CLASS_MEDIC then
		self:AddMoney(BANK, math.Round(( (90 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )) )
		self:Hint("You have recieved $"..math.Round(( (90 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )).." for being a Paramedic of this city. It has been sent to your bank account.")
	elseif self:Team() == CLASS_FIREMAN then
		self:AddMoney(BANK, math.Round(( (90 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )) )
		self:Hint("You have recieved $"..math.Round(( (90 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )).." for being a Fire Fighter of this city. It has been sent to your bank account.")
	elseif self:Team() == CLASS_SWAT then
		self:AddMoney(BANK, math.Round(( (90 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )) )
		self:Hint("You have recieved $"..math.Round(( (90 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )).." for being part of the SWAT team of this city. It has been sent to your bank account.")	
	elseif self:Team() == CLASS_CHIEF then
		self:AddMoney(BANK, math.Round(( (100 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )) )
		self:Hint("You have recieved $"..math.Round(( (100 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )).." for being a police chief of this city. It has been sent to your bank account.")		
	elseif self:Team() == CLASS_Mayor then
		self:AddMoney(BANK,math.Round(( (120 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )))
		self:Hint("You have recieved $"..math.Round(( (120 * bonus) + math.Round(GetGlobalInt("Eco_points") / 5) )).." for being the Mayor of this city. It has been sent to your bank account.")
	end
end

function ManageWages()
	local Number = 1
	for k, v in pairs(player.GetAll()) do
		if v:Team() == CLASS_CITIZEN then
			v.OCRPData["MyModel"] = v:GetModel()
		end
		Number = Number + 1
		print(Number)
		timer.Simple(Number, function() v:PayWage() end)
	end
	Number = 1
end

timer.Create( "WagesAll", 90, 0, ManageWages)

function PMETA:Withdraw( amount )
	
	if self:GetMoney(BANK) < amount then
		return false
	end
	
	self:AddMoney(WALLET, amount, true)
	self:TakeMoney(BANK, amount)
end

concommand.Add("OCRP_Withdraw_Money",function(ply,cmd,args) if math.Round(args[1]) < 0 then return end
for _,obj in pairs(ents.FindByClass("Bank_atm")) do if obj:GetPos():Distance(ply:GetPos()) < 100 then ply:Withdraw(math.Round(args[1])) end end end)

concommand.Add("OCRP_Deposit_Money",function(ply,cmd,args) if math.Round(args[1]) < 0 then return end
for _,obj in pairs(ents.FindByClass("Bank_atm")) do if obj:GetPos():Distance(ply:GetPos()) < 100 then ply:Deposit(math.Round(args[1])) end end end)

function PMETA:Deposit( amount )
	if amount < 0 then
		return false
	end
	
	self:AddMoney(BANK, amount, true)
	self:TakeMoney(WALLET, amount)
end
	
