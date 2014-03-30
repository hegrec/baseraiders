include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS 
end 