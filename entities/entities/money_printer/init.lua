AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel(self.tbl.Model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self.NextMoney = CurTime()+30
end 

function ENT:Think()
	if CurTime()>self.NextMoney then
		self.NextMoney = CurTime()+30
		if (self:IsPowered()) then
			self:SpawnMoney()
		end
	end
end
function ENT:SpawnMoney()
	local spawnpos = self:GetPos()+self:GetForward()*10
	
	local ent = self.MoneyEntity
	if (!ent or !ent:IsValid()) then
		ent = ents.Create("money")
		ent:SetPos(spawnpos)
		ent:Spawn()
		self.MoneyEntity = ent
	end
	
	local amtToAdd = math.min(self.tbl.MaxMoney-ent:GetAmount(),self.tbl.MoneyIncrement)
	ent:AddMoney(amtToAdd)
end
	