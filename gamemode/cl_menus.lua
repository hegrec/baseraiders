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

	
	