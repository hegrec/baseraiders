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
	local lockpickskill = self.Owner:GetLevel("Security")
	local num = math.random(1,100)
	if num <= math.Clamp(lockpickskill+3-tr.Entity:GetNWInt("level"),1,20) then
		tr.Entity:Fire("unlock")
		self.Owner:EmitSound("door/latchunlocked1.wav")
		hook.Call("OnLockPickSuccess",GAMEMODE,self.Owner)
		self.Owner:AddStars(1)
	else
		self.Owner:EmitSound("physics/metal/metal_sheet_impact_bullet1.wav")
		
		local tbl =  GetItems()["Lock Pick"]
		umsg.Start("losegun",self.Owner)
			umsg.String("Lock Pick")
		umsg.End()
		self.Owner.TotalWeight = self.Owner.TotalWeight - tbl.Weight
		if(self.Owner.TotalWeight < 0)then self.Owner.TotalWeight = 0 end
		self.Owner:StripWeapon("lockpick")
	end
end
