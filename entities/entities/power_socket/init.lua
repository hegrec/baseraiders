AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.Users = {}
function ENT:Initialize()
	self:SetModel("models/props_lab/powerbox02b.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion(false)
	self:SetNWInt("WattsAvailable",1000)
end 
