AddCSLuaFile ("cl_init.lua");
AddCSLuaFile ("shared.lua");

include ("shared.lua");

SWEP.Weight = 5;
SWEP.AutoSwitchTo = false;
SWEP.AutoSwitchFrom = false;

local meta = FindMetaTable("Player")

function meta:GetEyeTrace()
	if ( self:GetTable().LastPlayertTrace == CurTime() ) then
		return self:GetTable().PlayerTrace
	end

	self:GetTable().PlayerTrace = util.TraceLine( util.GetPlayerTrace( self, self:GetCursorAimVector() ) )
	self:GetTable().LastPlayertTrace = CurTime()
       
	return self:GetTable().PlayerTrace
end

function SWEP:Initialize()
	self.Group = {}
end

function SWEP:Think() end

function SWEP:PrimaryAttack() end

function SWEP:SecondaryAttack() end

function SWEP:Reload() end

function SWEP:Deploy()
	if #self.Group > 0 and !self.Owner:KeyDown( IN_SPEED ) then
		self.Group = UpdateGroup( self.Group )
		if #self.Group > 0 then
			if #self.Owner.Units > 0 then
				numremoved = 0
				for i=1, #self.Owner.Units do
					if !table.HasValue( self.Group, self.Owner.Units[i] ) then
						self.Owner.Units[i-numremoved]:Deselect( self.Owner )
						numremoved = numremoved + 1
					end
				end
			end
			for i=1, #self.Group do
				if self.Group[i]:IsValid() then
					if !self.Group[i]:IsDead() then
						self.Group[i]:Select( self.Owner )
					end
				end
			end
			self.Owner:ChatPrint( "Group 4 Selected." )
		end
	end
	if self.Owner:KeyDown( IN_SPEED ) and #self.Owner.Units > 0 then
		self.Group = {}
		for _, unit in pairs( self.Owner.Units ) do
			table.insert( self.Group, unit )
		end
		self.Owner:ChatPrint( "Units hot grouped successfully." )
	elseif !self.Owner:KeyDown( IN_SPEED ) and #self.Owner.Units > 0 and #self.Group <= 0 then
		self.Owner:ChatPrint( "You must be holding sprint to bind these units." )
	elseif #self.Owner.Units == 0 then
		self.Owner:ChatPrint( "Select some units to hot group first." )
	end
	self.Owner:SelectWeapon( "command_staff" )
end

function UpdateGroup( grp )
	local numremoved = 0
	for i=1, #grp do
		if !grp[i-numremoved]:IsValid() then
			table.remove( grp, i-numremoved )
			numremoved = numremoved + 1
		elseif grp[i-numremoved]:IsDead() then
			table.remove( grp, i-numremoved )
			numremoved = numremoved + 1
		end
	end
	return grp
end