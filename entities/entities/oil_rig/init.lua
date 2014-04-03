AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel("models/props_combine/combinethumper001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
 
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	self:SetUseType(SIMPLE_USE)
	self:SetNoDraw(true)
	self.ent = ents.Create("prop_thumper")
	self.ent:SetPos(self:GetPos())
	self.ent:SetAngles(self:GetAngles())
	self.ent:SetNWString("ItemName",self.tbl.Name)
	self.ent:Spawn()
	self.ent:Activate()
	
	
	self:SetNWInt("FillPercentage",0)
end
function ENT:Remove()
	self.ent:Remove()
end
function ENT:Think()
	--if (self.activeBarrel and self.activeBarrel:IsValid() and self.activeBarrel:GetPos():Distance(pos)<20 )then return end

	self:SetNWInt("FillPercentage",self:GetNWInt("FillPercentage")+1)
	
	if self:GetNWInt("FillPercentage")>= 100 then
		local pos = self:GetBarrelPos()
		if (self.activeBarrel and self.activeBarrel:IsValid() and self.activeBarrel:GetPos():Distance(pos)<20 )then return end
		local tr = {}
		tr.start = pos
		tr.endpos = pos + Vector(0,0,1000)
		tr.filter = self.activeBarrel
		tr = util.TraceLine(tr)
		
		
		local tr2 = {}
		tr2.start = tr.HitPos-Vector(0,0,1)
		tr2.endpos = pos - Vector(0,0,3000)
		tr2 = util.TraceLine(tr2)

		local ent = SpawnRoleplayItem("Crude Oil",tr2.HitPos)
		self.activeBarrel = ent
		self:SetNWInt("FillPercentage",0)
	end
end
function ENT:Use(activator, caller)
	
end 