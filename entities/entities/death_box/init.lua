AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.TouchTable = {}

function ENT:Initialize()
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	local min=Vector(0-(self.Width/2),0-(self.Length/2),0-(self.Height/2))
    local max=Vector(self.Width/2,self.Length/2,self.Height/2)
	
	self.Entity:PhysicsInitBox(min, max)
	
	self.Entity:SetCollisionBounds(min, max)
	
	self.Entity:DrawShadow(false)
	self.Entity:SetTrigger(true)
	self.Entity:SetNotSolid(true)
	
	self.Active = 0
	
	self.Phys = self.Entity:GetPhysicsObject()
	if(self.Phys:IsValid()) then
		self.Phys:EnableMotion(false)
		self.Phys:Wake()
		self.Phys:EnableCollisions(true)
	end
end

function ENT:SphereTouch(ent, state)
	if(self.TouchFunction) then
		local work, err = pcall(self.TouchFunction, self, ent, state)
		//if(!work)then filex.Append("death_box_log_error.txt",err.."\n") end
	end
end

function ENT:StartTouch(ent)
	if(!self.TouchTable[ent]) then
		self:SphereTouch(ent, 1)
		self.TouchTable[ent] = true
	end
end

function ENT:Touch(ent)
	self:SphereTouch(ent, 2)
end

function ENT:EndTouch(ent)
	if(self.TouchTable[ent]) then
		self:SphereTouch(ent, 3)
		self.TouchTable[ent] = nil
	end
end

function ENT:OnRemove()
	for k, v in pairs(self.TouchTable) do
		if(k and k:IsValid()) then
			self:SphereTouch(k, 2)
		end
	end
end

function ENT:TouchFunction(ent, state)
	if(!IsValid(ent))then return end
	if(ent:IsPlayer())then
		ent:Spawn()
		//filex.Append("deat_box_log.txt",os.date("%c").. " - " ..ent:Name().." " ..ent:SteamID().."\n")
	else
		ent:Remove()
		//filex.Append("deat_box_log.txt",os.date("%c").. " - " ..ent:GetClass().." owner - " ..player.GetBySteamID(ent:GetNWInt("Owner")):Name().." "..player.GetBySteamID(ent:GetNWInt("Owner")).."\n")
	end
end
