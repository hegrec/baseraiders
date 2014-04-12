if CLIENT then
	SWEP.PrintName = "Keys"
	SWEP.Author	= "Darkspider/Train"
	SWEP.Purpose = "Lock / Unlock doors"
	SWEP.Instructions = "Left click to lock doors. Right click to unlock doors."
	SWEP.Slot = 1
	SWEP.SlotPos = 2
else
	AddCSLuaFile("shared.lua")
end 

SWEP.Primary.ClipSize = -1;
SWEP.Primary.DefaultClip = -1;
SWEP.Primary.Automatic = false;
SWEP.Primary.Ammo = "none";
SWEP.HoldType = "normal"
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.Ammo = "none"; 
SWEP.ViewModel = Model( "models/weapons/v_fists.mdl" );
SWEP.WorldModel = Model( "models/weapons/w_fists.mdl" );

function SWEP:Initialize()
	if( SERVER ) then
		self:SetWeaponHoldType( "normal" )
	end
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + (self.Owner:GetAimVector()*70)
	tr.filter = self.Owner
	tr = util.TraceLine(tr)
	if IsValid(tr.Entity) and tr.Entity:IsDoor() and !tr.Entity.Locked then
		tr.Entity.Roommates = tr.Entity.Roommates or {}
		local territoryDoor = tr.Entity:GetNWInt("Territory") != 0
		local mygangcontrols = territories[tr.Entity:GetNWInt("Territory")] && territories[tr.Entity:GetNWInt("Territory")].ActiveHub && territories[tr.Entity:GetNWInt("Territory")].ActiveHub:GetGangID() == self.Owner:GetGangID()
		local nocontest = territories[tr.Entity:GetNWInt("Territory")] && !territories[tr.Entity:GetNWInt("Territory")].ContestingHub
		
		if tr.Entity.DoorOwner == self.Owner:SteamID() || table.HasValue(tr.Entity.Roommates,self.Owner) || (territoryDoor && mygangcontrols && nocontest) then
			self.Owner:EmitSound("doors/door_latch1.wav")
			tr.Entity:Fire("lock","",0)
			tr.Entity.Locked = true
		end
	end
	if IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_vehicle_jeep" and !tr.Entity.Locked then
		if(tr.Entity.CarOwner == self.Owner:SteamID())then 
			self.Owner:EmitSound("doors/door_latch1.wav")
			tr.Entity:Fire("lock","",0)
			tr.Entity.Locked = true
		end
	end
end 

function SWEP:SecondaryAttack()
	if CLIENT then return end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = tr.start + (self.Owner:GetAimVector()*70)
	tr.filter = self.Owner
	tr = util.TraceLine(tr)
	if IsValid(tr.Entity) and tr.Entity:IsDoor() and tr.Entity.Locked then
		tr.Entity.Roommates = tr.Entity.Roommates or {}
		local territoryDoor = tr.Entity:GetNWInt("Territory") != 0
		local mygangcontrols = territories[tr.Entity:GetNWInt("Territory")] && territories[tr.Entity:GetNWInt("Territory")].ActiveHub && territories[tr.Entity:GetNWInt("Territory")].ActiveHub:GetGangID() == self.Owner:GetGangID()
		local nocontest = territories[tr.Entity:GetNWInt("Territory")] && !territories[tr.Entity:GetNWInt("Territory")].ContestingHub
		
		if tr.Entity.DoorOwner == self.Owner:SteamID() || table.HasValue(tr.Entity.Roommates,self.Owner) || (territoryDoor && mygangcontrols && nocontest) then
			self.Owner:EmitSound("doors/latchunlocked1.wav")
			tr.Entity:Fire("unlock","",0)
			tr.Entity.Locked = nil
		end
	end
	if IsValid(tr.Entity) and tr.Entity:GetClass() == "prop_vehicle_jeep" and tr.Entity.Locked then
		if(tr.Entity.CarOwner == self.Owner:SteamID())then 
			self.Owner:EmitSound("doors/latchunlocked1.wav")
			tr.Entity:Fire("unlock","",0)
			tr.Entity.Locked = nil
		end
	end
end 