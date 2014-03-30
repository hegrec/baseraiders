AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetModel("models/props_c17/FurnitureTable002a.mdl")
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
	end
end 

function ENT:OnTakeDamage(dmg) 

end

function ENT:OnRemove()

end

function ENT:Use(activator, caller)

end 

