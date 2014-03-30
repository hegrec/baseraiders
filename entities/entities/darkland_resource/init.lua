--AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
 
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	self.StartingOre = 10
	self.OreLeft = self.StartingOre
	self:SetUseType(SIMPLE_USE)
	self.Length = self.Entity:OBBMaxs().z - self.Entity:OBBMins().z
	local tr = util.QuickTrace(self.Entity:GetPos()+Vector(0,0,500),Vector(0,0,-1000),self.Entity)
	
	self.Entity:SetPos(tr.HitPos + Vector(0,0,self.Length/2))
end 

function ENT:SetResource(index)
	local tbl = GetItems()[index]
	self:SetModel(tbl.Model)
	self.OreIndex = index
	self:SetMaterial("models/debug/debugwhite")
	local col = tbl.OreColor
	self:SetColor(col.r,col.g,col.b,255)	
end
function ENT:Use(activator, caller)

end

function ENT:IsMined(pl)
	pl:GiveItem(self.OreIndex)
	self:CalculatePosition()
end
function ENT:CalculatePosition()
	self.Entity:SetPos(self.Entity:GetPos()-Vector(0,0,self.OreLeft/self.StartingOre*self.Length))
end
