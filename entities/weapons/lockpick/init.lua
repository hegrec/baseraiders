AddCSLuaFile("shared.lua")
include("shared.lua");

SWEP.NextHit = 0

function SWEP:Initialize()
	self:SetWeaponHoldType( "melee" )
end

function SWEP:PrimaryAttack()
	if self.NextHit > CurTime() then return end
	self.NextHit = CurTime()+1
	self.lockpickboost = self.lockpickboost or 0
	local tr = self.Owner:EyeTrace(100)
	if !tr.Entity:IsValid() then self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER ) return end
	self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
	if tr.Entity:IsDoor() then 
		self:TryUnlock(tr)
	elseif tr.Entity:GetClass() == "gang_vault" and tr.Entity:GetGangID() != 0 then
		self:TrySteal(tr)
	end
	
end

function SWEP:TryUnlock(tr)
	if tr.Entity.ConstLocked == 1 then self.Owner:SendNotify("This door is unable to be lockpicked!","NOTIFY_ERROR",3) return end
	local num = math.random(1,100) - self.lockpickboost
	if num <= 10-tr.Entity:GetNWInt("level") then
		tr.Entity:Fire("unlock")
		tr.Entity.Locked = false
		tr.Entity.nextlock = CurTime()+5
		self.Owner:EmitSound("doors/latchunlocked1.wav")
		hook.Call("OnLockPickSuccess",GAMEMODE,self.Owner)
		self.lockpickboost = 0
	else
		self.Owner:EmitSound("physics/metal/metal_sheet_impact_bullet1.wav")
		self.Owner:TakeItem("Lock Pick")
		self.lockpickboost = self.lockpickboost + 1
	end

	local door = tr.Entity
	local alarms = ents.FindByClass("alarm_system")
	if door:GetNWInt("Territory") > 0 and territories[door:GetNWInt("Territory")].OwnerGangID then
		local owningGang = territories[door:GetNWInt("Territory")].OwnerGangID

		for i,v in pairs(alarms) do
			if (v.ownerGang == owningGang and v:GetPos():Distance(door:GetPos())<300) then
				v:Alert()
			end
		end	

	else
		local owner = door:GetOwn()
		for i,v in pairs(alarms) do
			if (v.pOwner == owner and v:GetPos():Distance(door:GetPos())<300) then
				v:Alert(true)
			end
		end		
	end
	

end

function SWEP:TrySteal(tr)

	local num = math.random(1,100)
	if num <= 10 then
		gangs.StealGangVaultItem(tr.Entity,self.Owner)
		self.Owner:EmitSound("doors/latchunlocked1.wav")
		hook.Call("OnLockPickSuccess",GAMEMODE,self.Owner)
		self.lockpickboost = 0
	else
		self.Owner:EmitSound("physics/metal/metal_sheet_impact_bullet1.wav")
		self.Owner:TakeItem("Lock Pick")
		self.lockpickboost = self.lockpickboost + 1
	end
end
