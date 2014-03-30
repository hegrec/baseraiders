--DMultiModelPanel
--Made by Train

local PANEL = {}

AccessorFunc(PANEL, "m_fAnimSpeed", 	"AnimSpeed")
AccessorFunc(PANEL, "vCamPos", 		"CamPos")
AccessorFunc(PANEL, "fFOV", 			"FOV")
AccessorFunc(PANEL, "vLookatPos", 		"LookAt")
AccessorFunc(PANEL, "colAmbientLight", "AmbientLight")
AccessorFunc(PANEL, "colColor", 		"Color")
AccessorFunc(PANEL, "bAnimated", 		"Animated")

function PANEL:Init()
	self.Entities = {}
	self.LastPaint = 0
	self.DirectionalLight = {}
	
	self:SetCamPos(Vector(50, 50, 50))
	self:SetLookAt(Vector(0, 0, 40))
	self:SetFOV(70)
	
	self:SetText("")
	self:SetAnimSpeed(0.5)
	self:SetAnimated(false)
	
	self:SetAmbientLight(Color(50, 50, 50))
	
	self:SetDirectionalLight(BOX_TOP, Color(255, 255, 255))
	self:SetDirectionalLight(BOX_FRONT, Color(255, 255, 255))
	
	self:SetColor(Color(255, 255, 255, 255))
end

function PANEL:SetDirectionalLight(iDirection, color)
	self.DirectionalLight[iDirection] = color
end

function PANEL:AddModel(strModelName)
	if (!ClientsideModel) then return end
	local index = table.insert(self.Entities, ClientsideModel(strModelName, RENDER_GROUP_OPAQUE_ENTITY))
	if (!IsValid(self.Entities[index])) then return end
	self.Entities[index]:SetNoDraw(true)
	self.Entities[index].Draw = true --allows for hiding of models
	
	local iSeq = self.Entities[index]:LookupSequence( "walk_all" )
	if (iSeq <= 0) then iSeq = self.Entities[index]:LookupSequence("WalkUnarmed_all") end
	if (iSeq <= 0) then iSeq = self.Entities[index]:LookupSequence("walk_all_moderate") end
	
	if (iSeq > 0) then self.Entities[index]:ResetSequence(iSeq) end
	
	return index
end

function PANEL:GetEntityByName(str)
	for k,v in pairs(self.Entites)do
		if(str == v)then
			return k
		end
	end
end

function PANEL:GetEntity(index)
	return self.Entities[index]
end

function PANEL:RemoveModel(index)
	table.remove(self.Entities, index)
end

function PANEL:Paint()
	if (!IsValid(self.Entities[1])) then return end
	local x, y = self:LocalToScreen(0, 0)
	
	for k,v in pairs(self.Entities)do
		if(IsValid(v))then
			if(v.LayoutEntity)then
				v:LayoutEntity(unpack(v.LayoutEntityArgs))
			end
		end
	end
	cam.Start3D(self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall())
	cam.IgnoreZ(true)
	
	render.SuppressEngineLighting(true)
	render.SetLightingOrigin(self.Entities[1]:GetPos())

	render.ResetModelLighting(self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255)
	render.SetColorModulation(self.colColor.r/255, self.colColor.g/255, self.colColor.b/255)
	render.SetBlend(self.colColor.a/255)
	
	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if (col) then
			render.SetModelLighting(i, col.r/255, col.g/255, col.b/255)
		end
	end
	
	for k,v in pairs(self.Entities)do
		if(IsValid(v) and v.Draw)then
			v:DrawModel()
		end
	end
	
	render.SuppressEngineLighting(false)
	cam.IgnoreZ(false)
	cam.End3D()
	
	self.LastPaint = RealTime()
end

function PANEL:RunAnimation()
	for k,v in pairs(self.entities)do
		v:FrameAdvance((RealTime()-self.LastPaint) * self.m_fAnimSpeed)	
	end
end

function PANEL:SetLayoutFunction(index, func, ...)
	if(type(func) != "function")then return end
	self.Entities[index].LayoutEntity = func
	self.Entities[index].LayoutEntityArgs = {...}
end
derma.DefineControl("DMultiModelPanel", "A panel containing a model", PANEL, "DModelPanel")