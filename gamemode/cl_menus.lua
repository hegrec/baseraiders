local MODEL = {}
function MODEL:Init()
	if(Panels["Menu"])then Panels["Menu"]:SetVisible(false) end
	gui.EnableScreenClicker(true)
	self:SetSize(300,300)
	self:ShowCloseButton(false) 
 	self:SetBackgroundBlur(true) 
	self:Center()
	self:SetDeleteOnClose(true)
	self:SetZPos(1000)
	local list = vgui.Create("DPanelList",self)
	list:StretchToParent(5,25,5,5)
	list:EnableHorizontal(true)
	list:EnableVerticalScrollbar()
	self:SetTitle("Select a Model")
	for k,v in pairs(CitizenModels)do
		local icon = vgui.Create("SpawnIcon",pan)
		icon:SetModel(v)
		icon:InvalidateLayout(true)
		icon:SetPos(5,5)
		--icon:RebuildSpawnIcon()
		icon.OnCursorEntered = function() end
		icon.OnCursorExited = function() end
		icon.OnMousePressed = function() 
				surface.PlaySound("ui/buttonclickrelease.wav") 
				RunConsoleCommand("setmodel",k) 
				gui.EnableScreenClicker(false)
				self:Close()
				if(Panels["Menu"])then Panels["Menu"]:SetVisible(true) end
			end
		icon:SetToolTip(nil)
		list:AddItem(icon)
	end
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
	print("showing main")
	if(ValidPanel(Panels["Menu"]))then
		Panels["Menu"]:Remove()
	end
	Panels["Menu"] = vgui.Create("Menu")
	hook.Call("OnMenusCreated",GAMEMODE)
end
concommand.Add("show_main",ShowMain)

	
	