AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel("models/props_combine/combinethumper001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_NONE)
 
	self:SetUseType(SIMPLE_USE)
	
	
	self.ent = ents.Create("prop_thumper")
	self.ent:SetPos(self:GetPos())
	self.ent.tbl = self.tbl
	self.ent:SetAngles(self:GetAngles())
	self.ent:SetItemName(self:GetItemName())
	self.ent:Spawn()
	self.ent:Activate()
	self.barrels = {}
	
	self:SetNWInt("FillPercentage",0)
end
function ENT:Think()

	local i=1
	while (i<#self.barrels) do
		if !self.barrels[i]:IsValid() then
			table.remove(self.barrels,i)
		else
			i = i + 1
		end
	end
	if #self.barrels >= 5 then return end
	
	
	
	local tracedata = {}

	tracedata.start = self:GetBarrelPos()
	tracedata.endpos = self:GetBarrelPos() + Vector(0,0,45)
	tracedata.filter = {self,self.ent}
	tracedata.mins = Vector( -14.5,-14.5,0)
	tracedata.maxs = Vector(14.5,14.5,0)
	tracedata.mask = MASK_SHOT_HULL
	local tr = util.TraceHull( tracedata )
	if tr.Entity:IsValid() then
		return
	end
	if !self.ent:IsValid() then self:Remove() return end
	self.ent:SetAngles(self:GetAngles())
	self:SetNWInt("FillPercentage",self:GetNWInt("FillPercentage")+0.5)
	
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
		table.insert(self.barrels,ent)
		self:SetNWInt("FillPercentage",0)
	end
end
function ENT:Use(activator, caller)
	
end 