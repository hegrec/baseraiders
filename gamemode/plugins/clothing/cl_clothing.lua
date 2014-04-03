local PANEL = {}

ownedHats = {}
ownedClothes = {}

local offsets = {} --taken directly from the entity for easy positioning
offsets["models/americahat/americahat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/highhat/highhat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/bunnyears/bunnyears.mdl"] = {
	UpOffset = 4.5,
	RightOffset = 0,
	ForwardOffset = -2,
	Scale = 1.1
}
offsets["models/captainshat/captainshat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/beerhat/beerhat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/mariohat/mariohat.mdl"] = {
	UpOffset = 2,
	RightOffset = 0,
	ForwardOffset = -3.2
}
offsets["models/paperbag/paperbag.mdl"] = {
	UpOffset = -8,
	RightOffset = 0,
	ForwardOffset = -3.2,
	Scale = 1.2
}
offsets["models/headcrabclassic.mdl"] = {
	UpOffset = 0.5,
	RightOffset = 0,
	ForwardOffset = 0,
	Scale = 0.75
}
offsets["models/props/de_tides/vending_hat.mdl"] = {
	UpOffset = 0.6,
	RightOffset = 0,
	ForwardOffset = -3.3
}             

local hatindex = 1 --used for iterating thru hats in the closet
local skinindex = 1

function PANEL:Init()
	self:MakePopup()
	self:SetDraggable(false)
	self:SetTitle("The Hat Store")
	self:SetSize(700,380)
	self:SetPos(ScrW()*0.5-350,ScrH()-400)
	self.list = vgui.Create("DPanelList",self)
	self.list:SetPadding(3)
	self.list:SetSpacing(1)
	self.list:EnableVerticalScrollbar()
	self.list:StretchToParent(5,25,5,5)
	for i,v in pairs(GetClothes()) do
		if v.Type == "Hat"  and !table.HasValue(ownedHats,i)then
			local pan = vgui.Create("DPanel")
			pan:SetTall(74)
			pan.index = i
			local panel = vgui.Create("DModelPanel",pan)
			panel:SetModel(v.Model)
			panel:SetSize(74,74)
			panel:SetCamPos(Vector(10,20,10))
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
			butt:SetPos(620,44)
			butt:SetSize(60,20)
			butt:SetText("Buy")
			butt.DoClick = function() RunConsoleCommand("buyhat",i) end
			butt.Think = function() end
			self.list:AddItem(pan)
		end
	end	
end
vgui.Register("HatMenu",PANEL,"DFrame")

local function ShowHatMenu()
	Panels["HatMenu"] = vgui.Create("HatMenu")
end 
usermessage.Hook("hatMenu",ShowHatMenu)

local function boughtHat( um )
	local hat = um:ReadString()
	for i,v in pairs(Panels["HatMenu"].list:GetItems()) do
		if v.index == hat then
			Panels["HatMenu"].list:RemoveItem(v)
			Panels["HatMenu"].list:Rebuild()
			return
		end
	end

end
usermessage.Hook("boughtHat",boughtHat)

local CLOTHES = {}
function CLOTHES:Init()
	self:MakePopup()
	self:SetDraggable(false)
	self:SetTitle("The Clothes Store")
	self:SetSize(700,380)
	self:SetPos(ScrW()*0.5-350,ScrH()-400)
	self.list = vgui.Create("DPanelList",self)
	self.list:SetPadding(3)
	self.list:SetSpacing(1)
	self.list:EnableVerticalScrollbar()
	self.list:StretchToParent(5,25,5,5)
	local clothestype = "MaleClothes"
	if(IsFemale(GetModel()))then
		clothestype = "FemaleClothes"
	end
	for i,v in pairs(GetClothes()) do
		if v.Type == clothestype and !table.HasValue(ownedClothes,i)then
			local pan = vgui.Create("DPanel")
			pan:SetTall(79)
			pan.index = i
			local panel = vgui.Create("DModelPanel",pan)
			panel:SetModel(GetModel())
			panel.Entity:SetSkin(v.Skin)
			panel:SetSize(79,79)
			panel:SetCamPos(Vector(10,50,35))
			panel:SetLookAt(Vector(0,0,35))
			local smallpan = vgui.Create("DPanel",pan)
			smallpan:SetPos(79,5)
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
			butt.DoClick = function() RunConsoleCommand("buyskin",i) end
			butt.Think = function() end
			self.list:AddItem(pan)
		end
	end
end
vgui.Register("clothesMenu",CLOTHES,"DFrame")

local function ShowClothesMenu()
	Panels["clothesMenu"] = vgui.Create("clothesMenu")
end 
usermessage.Hook("clothesMenu",ShowClothesMenu)

local function boughtClothes( um )
	local skin = um:ReadString()
	for i,v in pairs(Panels["clothesMenu"].list:GetItems()) do
		if v.index == skin then
			Panels["clothesMenu"].list:RemoveItem(v)
			Panels["clothesMenu"].list:Rebuild()
			return
		end
	end

end
usermessage.Hook("boughtClothes",boughtClothes)

local currentHat = ""
local currentSkin = ""
local CLOSET = {}

function CLOSET:Init()
	self:SetSize(200,400)
	self:Center()
	self:MakePopup()
	self:SetTitle("My Clothing")
	gui.EnableScreenClicker(true)
	
	local Preview = vgui.Create("DMultiModelPanel",self)
	Preview:SetPos(-88,24)
	--Preview:SetSize(150,360)
	Preview:SetSize(376,376)
	
	local human = Preview:AddModel(GetModel())
	local hat
	if GetClothes()[currentHat] then
		for k,v in pairs(ownedHats)do
			if(v == currentHat)then hatindex = k end
		end
		hat = Preview:AddModel(GetClothes()[currentHat].Model)
	else
		hat = Preview:AddModel("models/props_borealis/bluebarrel001.mdl")
		Preview:GetEntity(hat).Draw = false --its a giant fucking blue barrel, why wouldnt I hide it?
	end

	local skin = 0
	if GetClothes()[currentSkin] then
		for k,v in pairs(ownedClothes)do
			if(v == currentSkin)then skinindex = k end
		end
		skin = GetClothes()[currentSkin].Skin
	end
	
	Preview:GetEntity(human):SetSkin(skin)
	
	Preview:SetCamPos(Vector(10,80,35))
	Preview:SetLookAt(Vector(0,0,35))
	
	Preview:GetEntity(human):ResetSequence(Preview:GetEntity(human):LookupSequence( "idle_subtle" ))
	
	Preview:SetLayoutFunction(human,function(Entity) Entity:SetAngles(Angle(0,80, 0)) end)
	Preview:SetLayoutFunction(hat,function(Entity,human,offset) 
		local attach = human:GetAttachment(human:LookupAttachment("eyes"))
		if attach then
			local ang = attach.Ang
			Entity:SetAngles(ang)
			
			local offset = offset[Entity:GetModel()]
			
			if(!offset)then return end
			if(offset.Scale)then Entity:SetModelScale(Vector(offset.Scale,offset.Scale,offset.Scale)) end
			local pos = attach.Pos + (ang:Up() * offset.UpOffset)
			pos = pos + (ang:Right() * offset.RightOffset)
			pos = pos + (ang:Forward() * offset.ForwardOffset)
			
			Entity:SetPos(pos)
		end
	end,Preview:GetEntity(human),offsets)
	
	local hatleft = vgui.Create("DButton",self)
	hatleft:SetPos(8,55)
	hatleft:SetSize(35,20)
	hatleft:SetText("<-")
	hatleft.DoClick = function(Entity) 
		hatindex = hatindex - 1
		if(hatindex == 0)then hatindex = #ownedHats end

		if(ownedHats[hatindex] == "Default")then
			Preview:GetEntity(hat).Draw = false --the hat is default, hide it.
		else
			Preview:GetEntity(hat).Draw = true
			Preview:GetEntity(hat):SetModel(GetClothes()[ownedHats[hatindex]].Model)
		end
		RunConsoleCommand("sethat",ownedHats[hatindex])
	end
	
	local hatright = vgui.Create("DButton",self)
	hatright:SetPos(157,55)
	hatright:SetSize(35,20)
	hatright:SetText("->")
	hatright.DoClick = function() 
		hatindex = hatindex + 1
		if(hatindex > #ownedHats)then hatindex = 1 end

		if(ownedHats[hatindex] == "Default")then
			Preview:GetEntity(hat).Draw = false --the hat is default, hide it.
		else
			Preview:GetEntity(hat).Draw = true
			Preview:GetEntity(hat):SetModel(GetClothes()[ownedHats[hatindex]].Model)
		end
		RunConsoleCommand("sethat",ownedHats[hatindex])
	end
	
	local skinleft = vgui.Create("DButton",self)
	skinleft:SetPos(8,200)
	skinleft:SetSize(35,20)
	skinleft:SetText("<-")
	skinleft.DoClick = function()		
		skinindex = skinindex - 1
		if(skinindex == 0)then skinindex = #ownedClothes end
			
		if(ownedClothes[skinindex] == "Default")then
			Preview:GetEntity(human):SetSkin(0)
		else
			Preview:GetEntity(human):SetSkin(GetClothes()[ownedClothes[skinindex]].Skin)
		end
		RunConsoleCommand("setskin",ownedClothes[skinindex])
	end
	
	local skinright = vgui.Create("DButton",self)
	skinright:SetPos(157,200)
	skinright:SetSize(35,20)
	skinright:SetText("->")
	skinright.DoClick = function() 		
		skinindex = skinindex + 1
		if(skinindex > #ownedClothes)then skinindex = 1 end
			
		if(ownedClothes[skinindex] == "Default")then
			Preview:GetEntity(human):SetSkin(0)
		else
			Preview:GetEntity(human):SetSkin(GetClothes()[ownedClothes[skinindex]].Skin)
		end
		RunConsoleCommand("setskin",ownedClothes[skinindex])
	end
end

function CLOSET:Close()
	gui.EnableScreenClicker(false)
	self:Remove(true)
end
vgui.Register("ClosetMenu",CLOSET,"DFrame")

local function ShowClosetMenu()
	Panels["ClosetMenu"] = vgui.Create("ClosetMenu")
end
usermessage.Hook("useCloset",ShowClosetMenu)

function GetCurrentClothes(um)
	currentHat = um:ReadString()
	currentSkin = um:ReadString()
end
usermessage.Hook("getCurrentClothes",GetCurrentClothes)

function GetClothes(um)
	ownedClothes = {"Default"}
	local str = um:ReadString()
	while (str != "") do
		table.insert(ownedClothes,str)
		str = um:ReadString()
	end
	PrintTable(ownedClothes)
end
usermessage.Hook("getClothes",GetClothes)

function GetHats(um)
	ownedHats = {"Default"}
	local str = um:ReadString()
	while (str != "") do
		table.insert(ownedHats,str)
		str = um:ReadString()
	end
	PrintTable(ownedHats)
end
usermessage.Hook("getHats",GetHats)