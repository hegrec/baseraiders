local PANEL = {}

function PANEL:Init()
	self:MakePopup()
	self:SetDraggable(false)
	self:SetTitle("Big Bill's Inventory")
	self:SetSize(700,380)
	self:SetPos(ScrW()*0.5-350,ScrH()-400)
	self.list = vgui.Create("DPanelList",self)
	self.list:SetPadding(3)
	self.list:SetSpacing(1)
	self.list:EnableVerticalScrollbar()
	self.list:StretchToParent(5,25,5,5)
	--ugly but w/e it's clientside
	for i,v in pairs(GetRPVehicleList()) do
		local pan = vgui.Create("DPanel")
		pan:SetTall(74)
		
		local panel = vgui.Create("DModelPanel",pan)
		panel:SetModel(v.Model)
		panel:SetSize(74,74)
		panel:SetCamPos(Vector(100,200,100))
		panel:SetLookAt(Vector(0,0,0))
		local smallpan = vgui.Create("DPanel",pan)
		smallpan:SetPos(74,5)
		smallpan:SetSize(200,64)
		smallpan.Paint = 
		function()
			local name = i
			draw.SimpleTextOutlined(name,"ScoreboardSub",5,10,Color(14,53,65,255),0,1,1,Color(29,128,156,255))
			
			draw.SimpleText(v.Description,"Default",5,25,Color(0,0,0,255),0,1)
			local mcol = Color(100,255,100,255)
			if GetMoney() < v.Price then mcol = Color(205,50,50,255) end
			draw.SimpleText("Cost: $"..v.Price,"HUDBars",5,50,mcol,0,1)
		end
		local butt = vgui.Create("DButton",pan)
		butt:SetPos(600,44)
		butt:SetSize(60,20)
		butt:SetText("Buy")
		butt.DoClick = function() RunConsoleCommand("buycar",i) end
		butt.Think = function() end
		self.list:AddItem(pan)
	end	
end
vgui.Register("CarMenu",PANEL,"DFrame")

local function ShowCarMenu()
	Panels["CarMenu"] = vgui.Create("CarMenu")
end 
usermessage.Hook("carMenu",ShowCarMenu)

local function closeCarMenu()
	Panels["CarMenu"]:Remove()
end
usermessage.Hook("closeCarMenu",closeCarMenu)

local car

local PAINT = {}

function PAINT:Init()
	self:SetSize(300,300)
	self:Center()
	self:MakePopup()
	self:SetTitle("Paint Car")
	gui.EnableScreenClicker(true)
	
	local Preview = vgui.Create("DModelPanel",self)
	Preview:SetModel(car:GetModel())
	Preview:StretchToParent(50,50,50,50)
	
	Preview:SetCamPos(Vector(100,200,100))
	Preview:SetLookAt(Vector(0,0,0))
	
	Preview.Entity:SetSkin(car:GetSkin())
	

	
	local skinleft = vgui.Create("DButton",self)
	skinleft:SetSize(35,20)
	skinleft:SetPos(5,self:GetTall()*0.5-skinleft:GetTall()*0.5)
	
	skinleft:SetText("<-")
	skinleft.DoClick = function() 

		local skin = Preview.Entity:GetSkin()
		local tbl
		for i,v in pairs(GetRPVehicleList()) do
			if v.Model == car:GetModel() then
				tbl = v
			end
		end
		if !tbl then return end
		if skin > 0 then
			Preview.Entity:SetSkin(skin-1)
		else
			Preview.Entity:SetSkin(car:SkinCount())
		end
	end
	
	local skinright = vgui.Create("DButton",self)
	skinright:SetSize(35,20)
	skinright:SetPos(self:GetWide()-(skinright:GetWide()+5),self:GetTall()*0.5-skinright:GetTall()*0.5)
	skinright:SetText("->")
	skinright.DoClick = function() 
		local skin = Preview.Entity:GetSkin()
		local tbl
		for i,v in pairs(GetRPVehicleList()) do
			if v.Model == car:GetModel() then
				tbl = v
			end
		end
		if !tbl then return end
		if skin < car:SkinCount() then
			Preview.Entity:SetSkin(skin+1)
		else
			Preview.Entity:SetSkin(0)
		end
	end
	
	local buySkin = vgui.Create("DButton",self)
	buySkin:SetSize(100,20)
	buySkin:SetPos(self:GetWide()*0.5-50,self:GetTall()-30)
	buySkin.DoClick = function()
		RunConsoleCommand("paintcar",Preview.Entity:GetSkin())
		self:Close()
	end
	buySkin:SetText("Paint Car")
	
end
function PAINT:Close()
	gui.EnableScreenClicker(false)
	self:Remove(true)
end
vgui.Register("PaintMenu",PAINT,"DFrame")

function ShowPaintMenu(um)
	car = ents.GetByIndex(um:ReadShort())
	Panels["PaintMenu"] = vgui.Create("PaintMenu")
end 
usermessage.Hook("carPaintMenu",ShowPaintMenu)