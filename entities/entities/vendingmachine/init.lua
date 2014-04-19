AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.Users = {}
function ENT:Initialize()
	self:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()
	phys:EnableMotion(false)
end 
--I FIXED THIS UP A BIT TRAIN DUNNO IF IT IS FULLY DONE BUT IT SHUOLD BE 
--VENDING_MACHINE_SODA_COST is declared in sh_hunger.lua
WATER_COST = 5
function ENT:Use(activator, caller)
	self.Users[activator:SteamID()] = self.Users[activator:SteamID()] or 0
	if self.Users[activator:SteamID()] > CurTime() then return end
	if(activator:GetMoney() < WATER_COST)then activator:SendNotify("You can not afford this item","NOTIFY_ERROR",4) return end
	if !activator:GiveItem("Water") then return end
	
	activator:AddMoney(-1*WATER_COST)
	activator:SendNotify("You bought some water!","NOTIFY_GENERIC",4)
	self.Users[activator:SteamID()] = CurTime()+2 --NO SPAM!
end 