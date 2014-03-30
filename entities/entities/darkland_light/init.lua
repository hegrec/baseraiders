AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()
	print(self.tbl.Model)
	self.Entity:SetModel(self.tbl.Model)
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	
end 

function ENT:Use(activator, caller)
	if !activator:IsPlayer() then return end
	if !activator:GiveItem(self.GroupIndex) then return end
	self:Remove()
end 