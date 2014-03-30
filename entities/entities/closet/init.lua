AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.Users = {}
function ENT:Initialize()
	self:SetModel("models/props_c17/FurnitureDresser001a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion(false)
end 

function ENT:Use(activator, caller)
	hook.Call("OnUseCloset",GAMEMODE,activator)
end 