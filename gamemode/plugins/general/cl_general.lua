local PANEL = {}

local Me = LocalPlayer();

function PANEL:Init()
	self:MakePopup()
	self:SetDraggable(false)
	self:SetTitle("The Weapon Store")
	self:SetSize(700,380)
	self:SetPos(ScrW()*0.5-350,ScrH()-400)
	self.list = vgui.Create("DPanelList",self)
	self.list:SetPadding(3)
	self.list:SetSpacing(1)
	self.list:EnableVerticalScrollbar()
	self.list:StretchToParent(5,25,5,5)
	for i,v in pairs(GetItems()) do
		if v.Group == "Weapons" || v.Group == "Ammo" then
			local pan = vgui.Create("DPanel")
			pan:SetTall(74)
			
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
				if GetMoney() < v.BulkPrice then mcol = Color(205,50,50,255) end
				draw.SimpleText("Cost: $"..v.BulkPrice,"HUDBars",5,50,mcol,0,1)
			end
			local butt = vgui.Create("DButton",pan)
			butt:SetPos(620,44)
			butt:SetSize(60,20)
			butt:SetText("Buy")
			butt.DoClick = function() RunConsoleCommand("buygun",i) end
			butt.Think = function() end
			self.list:AddItem(pan)
		end
	end
	
end
vgui.Register("WeaponMenu",PANEL,"DFrame")

function ShowWeaponMenu()
	Panels["WeaponMenu"] = vgui.Create("WeaponMenu")
end 
usermessage.Hook("weaponMenu",ShowWeaponMenu)

































function DrawDrugLab()
	if(!LocalPlayer())then return end
	local tr = LocalPlayer():EyeTrace(MAX_INTERACT_DIST*2)
	local charges = tr.Entity:GetNWInt("Charges")
	if(tr.Entity:IsValid() and tr.Entity:GetClass() == "weed_plant") then --convert this to HUDMessage shit
		local pos = tr.Entity:LocalToWorld(tr.Entity:OBBCenter()+Vector(0,0,5)):ToScreen()
		draw.SimpleTextOutlined("Marijuana Plant","ScoreboardSub",pos.x,pos.y - 20,Color(20,0,20,255),1,1,1,Color(20,255,20,255))
		if(tr.Entity:NeedsWater())then
			draw.SimpleTextOutlined("Wilted","Default",pos.x,pos.y,Color(20,0,20,255),1,1,1,Color(20,255,20,255))
		else
			draw.SimpleTextOutlined("Growth: "..(tr.Entity:GetCharges()/tr.Entity.MaxGrow*100).."%","Default",pos.x,pos.y,Color(20,0,20,255),1,1,1,Color(20,255,20,255))
		end
	elseif tr.Entity:IsValid() and tr.Entity:GetClass() == "mushroom_plant" then --convert this to HUDMessage shit
		local pos = tr.Entity:LocalToWorld(tr.Entity:OBBCenter()+Vector(0,0,5)):ToScreen()
		draw.SimpleTextOutlined("Mushrooms","ScoreboardSub",pos.x,pos.y - 20,Color(20,0,20,255),1,1,1,Color(20,255,20,255))
		if(tr.Entity:NeedsWater())then
			draw.SimpleTextOutlined("Wilted","Default",pos.x,pos.y,Color(20,0,20,255),1,1,1,Color(20,255,20,255))
		else
			draw.SimpleTextOutlined("Growth: "..(tr.Entity:GetCharges()/tr.Entity.MaxGrow*100).."%","Default",pos.x,pos.y,Color(20,0,20,255),1,1,1,Color(20,255,20,255))
		end
	end
end
--hook.Add("HUDPaint","druglabdraw",DrawDrugLab)




