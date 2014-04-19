--AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	self.Entity:SetModel("models/props/de_prodigy/ammo_can_01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
	self:SetUseType(SIMPLE_USE)
end
function ENT:Use(ent)
	ent:ConCommand("use_gang_bank "..self:EntIndex())

end
function ENT:SetGangID(gangID)
	self:SetDTInt(0,gangID)
end
function ENT:SetGangName(gangName)
	self:SetDTString(0,gangName)
end
function ENT:SetSpawner(pl)
	if pl:GetGangID() == 0 then return end
	self:SetGangID(pl:GetGangID())
	self:SetGangName(pl:GetGangName())
end