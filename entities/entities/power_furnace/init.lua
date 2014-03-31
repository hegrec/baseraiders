ENT.Type = "brush"

function ENT:Initialize()
	self:PhysicsInitBox(self.minVec,self.maxVec)
	self:SetCollisionBounds(self.minVec,self.maxVec)
	 
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid( SOLID_BBOX )
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
	end
end

function ENT:SetMarker(str)
	self.marker = str
end
function ENT:SetMaxVector(v)
	self.maxVec = v
end
function ENT:SetMinVector(v)
	self.minVec = v
end
ENT.PoweringWood = {}
function ENT:StartTouch(ent)
	if ent:GetItemName() == "Wood" then
		self.PoweringWood[ent] = true
		ent:Ignite(60)
		timer.Simple(59,function()ent:Remove() end)
	end
end
function ENT:EndTouch(ent)
	self.PoweringWood[ent] = nil
end