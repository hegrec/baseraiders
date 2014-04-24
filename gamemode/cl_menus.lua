local MODEL = {}
function MODEL:Init()
	
	self:SetSize(1024,1024)
	self:ShowCloseButton(false)
	self:SetTitle("")
 	self:SetBackgroundBlur(true) 
	self:Center()
	self:SetZPos(1000)
	local list = vgui.Create("DPanelList",self)
	list:StretchToParent(5,25,5,5)
	list:EnableHorizontal(true)
	
	
	
	
	for k,v in pairs(CitizenModels)do
		local icon = vgui.Create("DModelPanel")
		icon:SetSize(200,200)
		icon:SetModel(v)
		icon.Entity:SetSkin((k%9)-1)
		icon:SetCamPos(Vector(40,10,60))
		icon:SetLookAt(Vector(0,0,60))
		icon:InvalidateLayout(true)
		local idle = icon.Entity:GetSequence()
		icon.LayoutEntity = function(s,ent) s:RunAnimation()  end
		icon.OnCursorEntered = function() icon.Entity:SetSequence(10)
				if k == 3 then
					icon.Entity:SetSequence(13)
				end end
		icon.OnCursorExited = function() icon.Entity:SetSequence(idle)
				
				end
		icon.DoClick = function() 
				surface.PlaySound("ui/buttonclickrelease.wav") 
				RunConsoleCommand("setmodel",k) 
				gui.EnableScreenClicker(false)
				self:Remove()
				
				ShowMain(LocalPlayer())
			end
		icon:SetToolTip(nil)
		list:AddItem(icon)
	end
	self:MakePopup()
end
function MODEL:Paint()
	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	draw.SimpleTextOutlined("Select Your Model","TerritoryTitle",500,30,Color(255,255,255,255),1,1,2,Color(0,0,0,255))
end
vgui.Register("ModelSelect",MODEL,"DFrame")

usermessage.Hook("getModel",function() Panels["ModelSelect"] = vgui.Create("ModelSelect") end)




local MAIN = {}
function MAIN:Init()
	self:SetSize(660,500)
	self:SetZPos(100)
	self:Center()
	self:MakePopup()
	self:SetDeleteOnClose(true)
	self:SetDraggable(false)
	self:ShowCloseButton(true)
	self:SetTitle("Main Menu")
	self.Sheet = vgui.Create("DPropertySheet2",self)
	--self.Sheet:SetDrawBackground(false)
	self.Sheet:StretchToParent(5,25,5,5)
	
end

function MAIN:Close()
	self:SetVisible(false)
	//gui.EnableScreenClicker(false)
end
vgui.Register("Menu",MAIN,"DFrame")

function ShowMain(pl,cmd,args)
	if(ValidPanel(Panels["Menu"]))then
		Panels["Menu"]:Remove()
	end
	if (ValidPanel(Panels["ModelSelect"])) then return end
	Panels["Menu"] = vgui.Create("Menu")
	hook.Call("OnMenusCreated",GAMEMODE)
end
concommand.Add("show_main",ShowMain)

	
	local PANEL = {}

local Me = LocalPlayer();

function PANEL:Init()
	self:MakePopup()
	self:SetDraggable(false)
	self:SetSize(700,380)
	self:SetPos(ScrW()*0.5-350,ScrH()-400)
	self.list = vgui.Create("DPanelList",self)
	self.list:SetPadding(3)
	self.list:SetSpacing(1)
	self.list:EnableVerticalScrollbar()
	self.list:StretchToParent(5,25,5,5)
	
end
function PANEL:AddItem(item,price)
	local tbl = GetItems()[item]
	if !tbl then return end
	local pan = vgui.Create("DPanel")
	pan:SetTall(74)
	
	local panel = vgui.Create("DModelPanel",pan)
	panel:SetModel(tbl.Model)
	panel:SetSize(74,74)
	panel:SetCamPos(Vector(10,20,10))
	panel:SetLookAt(Vector(0,0,0))
	local smallpan = vgui.Create("DPanel",pan)
	smallpan:SetPos(74,5)
	smallpan:SetSize(200,64)
	smallpan.Paint = 
	function()
		draw.SimpleTextOutlined(item,"ScoreboardSub",5,10,Color(14,53,65,255),0,1,1,Color(29,128,156,255))
		
		draw.SimpleText(tbl.Description,"Default",5,25,Color(0,0,0,255),0,1)
		local mcol = Color(100,255,100,255)
		if GetMoney() < price then mcol = Color(205,50,50,255) end
		draw.SimpleText("Cost: $"..price,"HUDBars",5,50,mcol,0,1)
	end
	local butt = vgui.Create("DButton",pan)
	butt:SetPos(620,44)
	butt:SetSize(60,20)
	butt:SetText("Buy")
	butt.DoClick = function() RunConsoleCommand("buystore",Panels["ActiveStore"].NPCIndex,item) end
	butt.Think = function() end
	self.list:AddItem(pan)
end
vgui.Register("Store",PANEL,"DFrame")

function ShowActiveStore(um)
	if !ValidPanel(Panels["ActiveStore"]) then
		Panels["ActiveStore"] = vgui.Create("Store")
	end
	Panels["ActiveStore"].NPCIndex = um:ReadShort()
	Panels["ActiveStore"]:SetTitle(um:ReadString())
end 
usermessage.Hook("showStore",ShowActiveStore)


function addStoreItem(um)
	if !ValidPanel(Panels["ActiveStore"]) then
		Panels["ActiveStore"] = vgui.Create("Store")
	end
	Panels["ActiveStore"]:AddItem(net.ReadString(),net.ReadInt(8))
end 
net.Receive("addStoreItem",addStoreItem)