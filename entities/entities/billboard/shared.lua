ENT.Type = "anim"
ENT.Base = "base_anim" 
if(!SERVER)then 
	//surface.CreateFont("coolvetica", 26, 500, true, false, "Billboard" ) --scoreboardhead is 48, sub is 24 
	surface.CreateFont("Billboard", {font='coolvetica', size=26, weight=500})
end

function ENT:Initialize()
	if(SERVER)then
		self:SetModel("models/error.mdl")
		self:DrawShadow(false)
	end
end

function ENT:Draw()
	self.Entity:SetRenderBoundsWS(self:GetPos(),self:GetNWVector("endpos"))
	cam.Start3D2D(self:GetPos(), self:GetAngles(), 1)
		surface.SetDrawColor(0,0,0,255)
		if(self:GetNWString("bgclr") != "")then
			local tmpclr = string.Explode("|",self:GetNWString("bgclr"))
			surface.SetDrawColor(tmpclr[1],tmpclr[2],tmpclr[3],255)
		end
		surface.DrawRect(0,0,self:GetNWInt("width"),self:GetNWInt("height"))
		
		if self:GetNWString("txt") then 
			local txtclr = Color(255,255,255,255)
			if(self:GetNWString("txtclr") != "")then
				local tmpclr = string.Explode("|",self:GetNWString("txtclr"))
				txtclr = Color(tmpclr[1],tmpclr[2],tmpclr[3],255)
			end
			self.XPos = self:GetNWInt("width") / 2
			for i=1,6 do --theres 4 lines of text possible
				while(TW(self:GetNWString("txt"..i),"Billboard") > self:GetNWInt("width"))do
					local trimmed = self:GetNWString("txt"..i):sub(0,self:GetNWString("txt"..i):len()-1)
					self:SetNWString("txt"..i,trimmed)
				end
				if(self:GetNWInt("height") > (i - 1) * 28 + 31)then	
					draw.SimpleText(self:GetNWString("txt"..i), "Billboard", self.XPos, (i - 1) * 28 + 5, txtclr, 1) 
				else
					break
				end
			end
		end
	cam.End3D2D()
end

function ENT:IsOwnable()
	return self:GetNWBool("ownable")
end 

function ENT:UpdateTransmitState()
	return TRANSMIT_PVS 
end