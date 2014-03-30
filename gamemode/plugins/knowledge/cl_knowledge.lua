local PANEL = {}

function PANEL:Init()
	self:MakePopup()
	self:SetDraggable(false)
	self:SetTitle("The Book Store")
	self:SetSize(700,500)
	self:SetPos(ScrW() / 2 - 250,  ScrH() / 2 - 200)
	self.list = vgui.Create("DPanelList",self)
	self.list:SetPadding(3)
	self.list:SetSpacing(1)
	self.list:EnableVerticalScrollbar()
	self.list:StretchToParent(5,25,5,5)
	for i,v in pairs(GetItems()) do
		if v.NoBuy and v.Group == "Books" then
			local pan = vgui.Create("DPanel")
			pan:SetTall(74)	
			local panel = vgui.Create("DModelPanel",pan)
			panel:SetModel(v.Model)
			panel:SetSize(74,74)
			panel:SetCamPos(v.CamPos)
			panel:SetLookAt(Vector(0,0,0))
			local smallpan = vgui.Create("DPanel",pan)
			smallpan:SetPos(74,5)
			smallpan:SetSize(200,64)
			smallpan.Paint = 
			function()
				local name = i
				draw.SimpleTextOutlined(name,"ScoreboardSub",5,10,Color(50,180,255,255),0,1,1,Color(29,128,156,255))
				draw.SimpleText(v.Description,"Default",5,25,Color(0,0,0,255),0,1)
				local mcol = Color(20,20,130,255)
				if GetMoney() < v.BulkPrice then mcol = Color(205,50,50,255) end
				draw.SimpleText("Cost: $"..v.BulkPrice,"HUDBars",5,50,mcol,0,1)
			end
			local butt = vgui.Create("DButton",pan)
			butt:SetPos(620,44)
			butt:SetSize(60,20)
			butt:SetText("Buy")
			butt.DoClick = function() RunConsoleCommand("buybook",i) end
			butt.Think = function() end
			self.list:AddItem(pan)
		end
	end
	
end
vgui.Register("BookMenu",PANEL,"DFrame")

function ShowBookMenu()
	Panels["BookMenu"] = vgui.Create("BookMenu")
end 
usermessage.Hook("bookMenu",ShowBookMenu)