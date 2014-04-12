AddCSLuaFile("shared.lua")
include("shared.lua");

SWEP.NextHit = 0

function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" )
end

function SWEP:PrimaryAttack()
	if self.NextHit > CurTime() then return end
	self.NextHit = CurTime()+1
	local tr = self.Owner:EyeTrace(100)
	if !tr.Entity:IsValid() then self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER ) return end
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	if !tr.Entity:IsDoor() then return end
	
	self:TryUnlock(tr)
	
end

function SWEP:TryUnlock(tr)
	if tr.Entity.ConstLocked == 1 then self.Owner:SendNotify("This door is unable to be lockpicked!","NOTIFY_ERROR",3) return end
	local lockpickskill = self.Owner:GetSkillLevel("Security")
	local num = math.random(1,100)
	if num <= 10+math.Clamp(lockpickskill+3-tr.Entity:GetNWInt("level"),1,20) then
		tr.Entity:Fire("unlock")
		tr.Entity.Locked = false
		self.Owner:EmitSound("doors/latchunlocked1.wav")
		hook.Call("OnLockPickSuccess",GAMEMODE,self.Owner)
	else
		self.Owner:EmitSound("physics/metal/metal_sheet_impact_bullet1.wav")
		self.Owner:TakeItem("Lock Pick")
		if (!self.Owner:HasItem("Lock Pick")) then self.Owner:StripWeapon("lockpick") end
	end
end
