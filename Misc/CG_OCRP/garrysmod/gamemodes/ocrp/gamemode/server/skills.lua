function PMETA:UpdateSkill(skill) 
	umsg.Start("OCRP_UpdateSkill", self)
		umsg.String(skill)
		umsg.Long(self.OCRPData["Skills"][skill])
		umsg.Long(self.OCRPData["Skills"].Points)
	umsg.End()
end

function PMETA:UpgradeSkill(skill)
	if self.OCRPData["Skills"].Points < 1 then return end
	if self.OCRPData["Skills"][skill] == nil then self.OCRPData["Skills"][skill] = 0 end
	if self.OCRPData["Skills"][skill] < GAMEMODE.OCRP_Skills[skill].MaxLevel then
		local bool = true
		if GAMEMODE.OCRP_Skills[skill].Requirements != nil then
			for _,data in pairs(GAMEMODE.OCRP_Skills[skill].Requirements) do
				if !self:HasSkill(data.Skill,data.level) then
					bool = false
				end
			end
		end
		if bool then
			self.OCRPData["Skills"][skill] = self.OCRPData["Skills"][skill] + 1
			self:TakePoints(1)
		end
	end
	self:UpdateSkill(skill)
	GAMEMODE:SaveSQLSkill( self, skill )
	if GAMEMODE.OCRP_Skills[skill].Function != nil then
		GAMEMODE.OCRP_Skills[skill].Function(self,skill)
	end
end
concommand.Add("OCRP_UpgradeSkill",function(ply,cmd,args) ply:UpgradeSkill(tostring(args[1])) end)

function PMETA:HasSkill(skill,level)
	if level == nil then level = 1 end
	if self.OCRPData["Skills"][skill] != nil then
		if self.OCRPData["Skills"][skill] >= level then
			return true
		end
	end
	return false
end

function PMETA:TakePoints(amt)
	self.OCRPData["Skills"].Points = self.OCRPData["Skills"].Points - amt
end

function PMETA:GivePoints(amt)
	self.OCRPData["Skills"].Points = self.OCRPData["Skills"].Points + amt
end

function PMETA:ResetSkills()
	for skill,level in pairs(self.OCRPData["Skills"]) do
		if skill != "Points" &&  level > 0 then
			self:GiveItem("item_"..skill)
			self:GivePoints(level)
			self.OCRPData["Skills"][skill] = 0 
			self:UpdateSkill(skill) 
			GAMEMODE:SaveSQLSkill( self, skill )
			if GAMEMODE.OCRP_Skills[skill].RemoveFunc != nil then
				print("lololol")
				
				GAMEMODE.OCRP_Skills[skill].RemoveFunc(self,skill)
			end
		end
	end
end
