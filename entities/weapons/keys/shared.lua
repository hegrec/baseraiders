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

SWEP.ViewModel = Model( "models/weapons/c_arms_citizen.mdl" );
SWEP.WorldModel = ""
SWEP.ViewModelFOV		= 52
SWEP.UseHands	= true

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 1, "NextIdle" )
	
end

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
			if  (!tr.Entity.nextlock || tr.Entity.nextlock < CurTime()) then
				self.Owner:EmitSound("doors/door_latch1.wav")
				tr.Entity:Fire("lock","",0)
				tr.Entity.Locked = true
			else
				self.Owner:SendNotify("You must wait "..math.ceil(tr.Entity.nextlock-CurTime()).." more seconds before relocking this door","NOTIFY_ERROR",4)
			end
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

function SWEP:UpdateNextIdle()

	local vm = self.Owner:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() )
	
end

function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle01" ) )
	
	self:UpdateNextIdle()
	
	return true

end

function SWEP:Think()
	
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	
	if ( idletime > 0 && CurTime() > idletime ) then

		vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_idle_0" .. math.random( 1, 2 ) ) )
		
		self:UpdateNextIdle()

	end
	
end