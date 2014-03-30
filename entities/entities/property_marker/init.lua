ENT.Type = "brush"

function ENT:Initialize()
	self:PhysicsInitBox(self.minVec,self.maxVec)
	self:SetCollisionBounds(self.minVec,self.maxVec)
	 
	self:SetMaterial("models/flesh")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid( SOLID_BBOX )
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion( false )
	end
end

function ENT:SetProperty(num)
	self.property = num
end
function ENT:SetMaxVector(v)
	self.maxVec = v
end
function ENT:SetMinVector(v)
	self.minVec = v
end

function ENT:StartTouch(ent)
	if !ent:IsPlayer() and !ent:IsVehicle() then
		--Add ent to a table or something
	end
end