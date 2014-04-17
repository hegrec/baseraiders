local myDoors = {}

local upgradecosts = {0,1000,1500,2000,2500}

Me = LocalPlayer();

function DoorBuy(ply, cmd, args)
	local tr = Me:EyeTrace(50)
	local door = tr.Entity

	if !IsValid(door) or !door:IsDoor() or door:GetNWInt("Territory") != 0 or (door:GetNWBool("Unownable") && !door:GetNWBool("Property")) then return end
	if !door:GetNWBool("Bought") then
		local str = "door"
		if door:GetNWBool("Property") then str = "property" end
		
		local cost = door:GetNWInt("Cost")
		if cost == 0 then cost = DEFAULT_DOOR_COST end
		
		Derma_Query( "Would you like to buy this "..str.." for "..cost.."?", "Confirmation!",
							"Yes", 	function() RunConsoleCommand("buydoor",door:EntIndex()) gui.EnableScreenClicker(false) end, 
							"No", 	function() gui.EnableScreenClicker(false) end)
														
		gui.EnableScreenClicker(true)	
	elseif myDoors[door:EntIndex()] or Me == player.GetBySteamID(door:GetNWInt("Owner"))then
		DoorProperties(door:EntIndex())
		RunConsoleCommand("reqMates",door:EntIndex())
	end
end
concommand.Add("rp_doorstuff",DoorBuy)

usermessage.Hook("boughtDoor",
function (um)
	myDoors[um:ReadShort()] = true
end)

usermessage.Hook("soldDoor",
function (um)
	myDoors[um:ReadShort()] = nil
end)

local DOORPROP = {}
local doornum = nil
function DOORPROP:Init()
	if(!doornum)then return end
	self:SetSize(250,380)
	self:MakePopup()
	self:Center()
	self:SetDeleteOnClose(true)
	self:SetDraggable(false)
	self:ShowCloseButton(true)
	self:SetTitle("Door Properties")
	
	self.Players = vgui.Create("DLabel",self)
	self.Players:SetText("Players")
	self.Players:SizeToContents()
	self.Players:SetPos(5,25)
	
	self.Plys = vgui.Create("DListView",self)
	local PlysCol1 = self.Plys:AddColumn("Name")
	self.Plys:SetSize(100,200)
	self.Plys:SetPos(5,40)
	self.Plys:SetMultiSelect(false) 
	
	self.Roomates = vgui.Create("DLabel",self)
	self.Roomates:SetText("Roommates")
	self.Roomates:SizeToContents()
	self.Roomates:SetPos(145,25)
	
	self.Rms = vgui.Create("DListView",self)
	local RmsCol1 = self.Rms:AddColumn("Name")
	self.Rms:SetSize(100,200)
	self.Rms:SetPos(145,40)
	self.Rms:SetMultiSelect(false) 
	
	self.BtnAdd = vgui.Create("DButton",self)
	self.BtnAdd:SetText("->")
	self.BtnAdd:SetWide(20)
	self.BtnAdd:SetPos(115,110)
	self.BtnAdd.DoClick = function() 
						if(#self.Plys:GetSelected() > 0)then
							RunConsoleCommand("addroommate",doornum,self.Plys:GetSelected()[1].Steam)
						end
					   end
					   
	self.BtnRemove = vgui.Create("DButton",self)
	self.BtnRemove:SetText("<-")
	self.BtnRemove:SetWide(20)
	self.BtnRemove:SetPos(115,150)
	self.BtnRemove.DoClick = function() 
						if(#self.Rms:GetSelected() > 0)then
							RunConsoleCommand("removeroommate",doornum,self.Plys:GetSelected()[1].Steam)
						end
					   end
	
	self.Divider = vgui.Create("DPanel",self)
	self.Divider:SetSize(self:GetWide(),2)
	self.Divider:SetPos(0,250)
	
	local doorlvl = ents.GetByIndex(doornum):GetDoorLevel()
	self.DoorLvlLab = vgui.Create("DLabel",self)
	self.DoorLvlLab:SetText("Current door level: "..doorlvl)
	self.DoorLvlLab:SizeToContents()
	self.DoorLvlLab:SetPos(5,260)
	
	self.BtnUpgrade = vgui.Create("DButton",self)
	if(doorlvl < 5)then
		self.BtnUpgrade:SetText("Upgrade door - $"..upgradecosts[doorlvl + 1])
		self.BtnUpgrade:SetDisabled(false)
	else
		self.BtnUpgrade:SetText("Fully upgraded")
		self.BtnUpgrade:SetDisabled(true)
	end
	self.BtnUpgrade:SizeToContents()
	self.BtnUpgrade:SetWide(120)
	self.BtnUpgrade:SetTall(20)
	self.BtnUpgrade:SetPos(120,257)
	self.BtnUpgrade.DoClick = function() 
									RunConsoleCommand("upgradedoor",doornum)
								end
	
	self.Divider = vgui.Create("DPanel",self)
	self.Divider:SetSize(self:GetWide(),2)
	self.Divider:SetPos(0,280)
	if !ents.GetByIndex(doornum):GetNWBool("Property") then
		self.DoorNameLbl = vgui.Create("DLabel",self)
		self.DoorNameLbl:SetText("Set Door Name")
		self.DoorNameLbl:SizeToContents()
		self.DoorNameLbl:SetPos(5,290)
		
		self.DoorName = vgui.Create("DTextEntry",self)
		self.DoorName:SetPos(5,305)
		self.DoorName:SetText(ents.GetByIndex(doornum):GetNWString("Title")) 
		self.DoorName:SetWide(150) 

		self.DoorName.OnEnter = function(self) RunConsoleCommand("changedoorname",doornum,self:GetValue())end 

		self.BtnApply = vgui.Create("DButton",self)
		self.BtnApply:SetText("Apply")
		self.BtnApply:SetWide(50)
		self.BtnApply:SetTall(20)
		self.BtnApply:SetPos(160,305)
		self.BtnApply.DoClick = function() 
									RunConsoleCommand("changedoorname",doornum,self.DoorName:GetValue())
								end
	end
	self.Divider2 = vgui.Create("DPanel",self)
	self.Divider2:SetSize(self:GetWide(),2)
	self.Divider2:SetPos(0,335)
	
	self.BtnSell = vgui.Create("DButton",self)
	self.BtnSell:SetText("Sell Door")
	self.BtnSell:SetSize(100,20)
	self.BtnSell:SetPos(75,350)
	self.BtnSell.DoClick = function()
						local cost = ents.GetByIndex(doornum):GetNWInt("Cost")
						if cost == 0 then cost = DEFAULT_DOOR_PRICE end
						Derma_Query( "Are you sure you want to sell this for ".. cost/2 .."?", "Confirmation!",
						"Yes", 	function() RunConsoleCommand("selldoor",doornum) self:Remove() gui.EnableScreenClicker(false) end, 
						"No", 	function() gui.EnableScreenClicker(false) end)	
							end
	
	for k,v in pairs(player.GetAll())do
		self.Plys:AddLine(v:Name()).Steam = v:SteamID();
	end
end

usermessage.Hook("loseRoommate",
function( um )
	local uid = um:ReadLong();
	local pl = player.GetByUserID(uid);
	if !pl then return end
	for i,v in pairs(Panels["DoorProperties"].Rms:GetLines()) do
		if v.UserID == uid then
			Panels["DoorProperties"].Rms:RemoveLine(i);
			Panels["DoorProperties"].Plys:AddLine(pl:Name()).UserID = pl:UserID();
		end
	end
end)

usermessage.Hook("getRoommate",
function( um )
	local uid = um:ReadLong();
	local pl = player.GetByUserID(uid)
	if !pl then return end
	for i,v in pairs(Panels["DoorProperties"].Plys:GetLines()) do
		if v.UserID == uid then
			Panels["DoorProperties"].Plys:RemoveLine(i);
			Panels["DoorProperties"].Rms:AddLine(pl:Name()).UserID = pl:UserID();
		end
	end
end)

function DOORPROP:Close()
	self:Remove()
	doornum = nil
	Panels["DoorProperties"] = nil
end
vgui.Register("DoorProperties",DOORPROP,"DFrame")

function DoorProperties(door)
	if ValidPanel(Panels["DoorProperties"]) then return	end
	doornum = door
	Panels["DoorProperties"] = vgui.Create("DoorProperties")
end
 
hook.Add("PostDrawTranslucentRenderables","doorHUDStuff",function()
	if !Me then return end
	local eee = ents.FindInSphere(Me:GetPos(),300)
	for i,v in pairs(eee) do
		if v:IsDoor() then
			local tr = {}
			tr.start = Me:GetShootPos()
			tr.endpos = v:LocalToWorld(v:OBBCenter())
			tr.filter = Me
			tr = util.TraceLine(tr)
			
			
			if tr.Entity == v then --convert this to HUDMessage shit
				cam.Start3D2D(tr.HitPos, tr.HitNormal:Angle()+Angle(0,90,90), 0.2)
				local unownable		= tr.Entity:GetNWBool("Unownable")
				local title 		= tr.Entity:GetNWString("Title")
				local territory		= tr.Entity:GetNWInt("Territory")
				local property 		= tr.Entity:GetNWBool("Property")
				local buyable 		= !tr.Entity:GetNWBool("Bought")
				local col = Color(255,255,20,255)
				if(title == "")then title = DEFAULT_DOOR_TITLE end
				if property && buyable then
					draw.SimpleTextOutlined("Property Available","ScoreboardSub",0,0,Color(20,0,20,255),1,1,1,Color(20,200,20,255))
				elseif territory != 0 then
					local t = territories[territory].Name
					draw.SimpleTextOutlined(t,"ScoreboardSub",0,0,Color(20,0,20,255),1,1,1,col)
				end
				if territory == 0 then
					draw.SimpleTextOutlined(title,"ScoreboardSub",0,0,Color(20,0,20,255),1,1,1,col)
					if buyable && !unownable then
						draw.SimpleTextOutlined("Press F3","ScoreboardSub",0,25,Color(20,0,20,255),1,1,1,col)
					end
				end	
				cam.End3D2D()
			end
			
		end
	end
end
)



