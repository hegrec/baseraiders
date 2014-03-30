ENT.Type = "anim"
ENT.Base = "base_anim" 
if(!SERVER)then 
	//surface.CreateFont("coolvetica", 26, 500, true, false, "Billboard" ) --scoreboardhead is 48, sub is 24 
	surface.CreateFont("Billboard", {font='coolvetica', size=26, weight=500})
end


function ENT:Draw()
	self.Entity:DrawModel()
	
	local pos = self.Entity:GetPos() + (self.Entity:GetUp() * 3)
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	cam.Start3D2D(pos, ang, 0.4)
		if self:GetNWString("txt") != "" then 
			draw.SimpleText(self:GetNWString("txt"),"Billboard",0,0,Color(255,255,255,255),1)
		end
	cam.End3D2D()

end