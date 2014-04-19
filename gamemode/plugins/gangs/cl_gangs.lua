local creategangtext = [[
Gangs run the city. Literally!
Create your own gang to get in on the action and capture territory.

Territories are always under threat of attack but the rewards for holding one are great.

Each territory will automatically produce resources for the gang that has captured it.
Gangs also have their own bank which can only be accessed when at least one territory is captured.

Plant your gang hub down at each territory to contest or take control!

See how long you can hold the entire city!
]]
local myGang = {}
local gangSheet = 0
local GANGTAB = {}
function GANGTAB:Init()
	
	if LocalPlayer():GetGangID() == 0 then
		self:ShowCreateGang()
	end
	RunConsoleCommand("load_gang_info")
end
function GANGTAB:ShowMyGang()
	if ValidPanel(self.createPanel) then self.createPanel:Remove() end
	self.infoPanel = vgui.Create("Panel",self)
	self.infoPanel:StretchToParent(0,0,0,0)
	local helptext = vgui.Create("DLabel",self.infoPanel)
	helptext:SetPos(5,5)
	helptext:SetText(myGang.Name)
	helptext:SetFont("HUDBars")
	helptext:SetTextColor(Color(0,0,0,255))
	helptext:SizeToContents()
	
	local helptext = vgui.Create("DLabel",self.infoPanel)
	helptext:SetPos(205,5)
	helptext:SetText("Invite your friends with /invitegang <player_name>")
	helptext:SetFont("HUDBars")
	helptext:SetTextColor(Color(0,0,0,255))
	helptext:SizeToContents()
	
		self.disbandbtn = vgui.Create("DButton",self.infoPanel)
		self.disbandbtn:SetPos(210,40)
		self.disbandbtn:SetSize(120,30)
		self.disbandbtn:SetText("Disband Gang")
		self.disbandbtn.DoClick = function() EnsureAndGo("Are you sure you want to disband your gang? This is an irreversible action and your gang data will be destroyed.","disbandgang",{}) end

		self.leavebtn = vgui.Create("DButton",self.infoPanel)
		self.leavebtn:SetPos(210,90)
		self.leavebtn:SetSize(120,30)
		self.leavebtn:SetText("Leave Gang")
		self.leavebtn.DoClick = function() EnsureAndGo("Are you sure you want to leave your gang?","leavegang",{}) end

	
	
	local helptext = vgui.Create("DLabel",self.infoPanel)
	helptext:SetPos(5,30)
	helptext:SetText("Leader: "..myGang.OwnerName)
	helptext:SetTextColor(Color(0,0,0,255))
	helptext:SetFont("HUDBars")
	helptext:SizeToContents()
	
	self.members = vgui.Create("DLabel",self.infoPanel)
	self.members:SetPos(5,55)
	self.members:SetTextColor(Color(0,0,0,255))


	self.members:SetText(#myGang.Members.."/"..GetMaxGangMembers(myGang.Experience).." Members")
	self.members:SetFont("HUDBars")
	self.members:SizeToContents()
	
	local helptext = vgui.Create("DLabel",self.infoPanel)
	helptext:SetPos(210,380)
	helptext:SetText("Gang Level: "..myGang.Level)
	helptext:SetTextColor(Color(0,0,0,255))
	helptext:SetFont("HUDBars")
	helptext:SizeToContents()
	
	local helptext = vgui.Create("DPanel",self.infoPanel)
	helptext:SetPos(210,400)
	helptext:SetSize(300,30)
	
	helptext.Paint = function(s)
		local level = CalculateLevel(myGang.Experience)
		local frac = CalculateExperienceThisLevel(myGang.Experience)/level_experience[level+1]
		draw.RoundedBox(0,0,0,s:GetWide(),s:GetTall(),Color(0,0,0,255))
		draw.RoundedBox(0,1,1,frac*(s:GetWide()-2),s:GetTall()-2,Color(0,255,0,255))
	end
	self.memberList = vgui.Create("DPanelList",self.infoPanel)
	self.memberList:SetPos(5,80)
	self.memberList:SetWide(200)
	self.memberList:SetTall(400)
	self.memberList:EnableVerticalScrollbar()
	self.memberList.Paint = function(s)
		draw.RoundedBox(2,0,0,s:GetWide(),s:GetTall(),Color(50,50,50,255))
	end
	for i,v in pairs(myGang.Members) do
		local pnl = vgui.Create("DLabel")
		pnl:SetText(v.Name)
		pnl.DoClick = function(s) local menu = DermaMenu()
			if LocalPlayer():GetGangLeader() then
				menu:AddOption("Kick",function() EnsureAndGo("Are you sure you want to kick "..v.Name.." from your gang?","gangkick",{v.SteamID}) end)
				menu:AddOption("Make Leader",function() EnsureAndGo("Are you sure you want to make "..v.Name.." the gang leader?","gangpromote",{v.SteamID}) end)
				
			end
			menu:Open()
		end
		pnl:SetFont("HUDBars")
		self.memberList:AddItem(pnl)
	end
end
function GANGTAB:AddGangMember(memberInfo)
			
	local pnl = vgui.Create("DLabel")
	pnl:SetText(memberInfo.Name)
	pnl.DoClick = function(s) local menu = DermaMenu()
		if LocalPlayer():GetGangLeader() then
			menu:AddOption("Kick",function() EnsureAndGo("Are you sure you want to kick "..memberInfo.Name.." from your gang?","gang_kick",{memberInfo.SteamID}) end)
			menu:AddOption("Make Leader",function() EnsureAndGo("Are you sure you want to make "..memberInfo.Name.." the gang leader?","gang_promote",{memberInfo.SteamID}) end)
			
		end
		menu:Open()
	end
	pnl:SetFont("HUDBars")
	self.memberList:AddItem(pnl)
	self.members:SetText(#myGang.Members.."/"..GetMaxGangMembers(myGang.Experience).." Members")
	self.members:SizeToContents()
end
function GANGTAB:Think()
	if (LocalPlayer():GetGangLeader()) then
		if ValidPanel(self.leavebtn) then
			self.leavebtn:SetVisible(false)
		end
		if ValidPanel(self.disbandbtn) then
		self.disbandbtn:SetVisible(true)
		end
	else
		if ValidPanel(self.leavebtn) then
			self.leavebtn:SetVisible(true)
		end
		if ValidPanel(self.disbandbtn) then
		self.disbandbtn:SetVisible(false)
		end
	end
end
function GANGTAB:PerformLayout()
	if ValidPanel(self.infoPanel) then self.infoPanel:StretchToParent(0,0,0,0) end
	if ValidPanel(self.createPanel) then self.createPanel:StretchToParent(0,0,0,0) end


end
function GANGTAB:ShowCreateGang()
	if ValidPanel(self.infoPanel) then self.infoPanel:Remove() end
	self.createPanel = vgui.Create("Panel",self)
	self.createPanel:StretchToParent(0,0,0,0)
	local helptext = vgui.Create("DLabel",self.createPanel)
	helptext:SetPos(5,5)
	helptext:SetText(creategangtext)
	helptext:SizeToContents()
	
	local costtext = vgui.Create("DLabel",self.createPanel)
	costtext:SetPos(5,5+helptext:GetTall()+5)
	costtext:SetText("It costs $"..GANG_CREATION_COST.." to create a gang")
	costtext:SizeToContents()
	local costx,costy = costtext:GetPos()
	local createbutton = vgui.Create("DButton",self.createPanel)
	createbutton:SetPos(5,costy + costtext:GetTall()+5)
	createbutton:SetText("Create a Gang")
	createbutton:SetSize(200,30)
	createbutton.DoClick = function() ShowCreateGang() end
end
function GANGTAB:Paint()

end
vgui.Register("GangTab",GANGTAB,"DPanel")


function receiveGangInfo(um)
	myGang = myGang or {}
	myGang.Name = um:ReadString()
	myGang.OwnerName = um:ReadString()
	myGang.Experience = um:ReadLong()
	myGang.Level = CalculateLevel(myGang.Experience)
	myGang.Members = {}
	gangSheet:ShowMyGang()

end
usermessage.Hook("sendGangInfo",receiveGangInfo)

function receiveGangMember(um)
	myGang = myGang or {}
	myGang.Members = myGang.Members or {}
	table.insert(myGang.Members,{Name=um:ReadString(),SteamID=um:ReadString()})
	gangSheet:AddGangMember(myGang.Members[#myGang.Members])
end
usermessage.Hook("sendGangMember",receiveGangMember)

function EnsureAndGo(msg,cmd,argg)


	Derma_Query( msg, "Confirmation!",
							"Yes", 	function() RunConsoleCommand(cmd,unpack(argg)) end, 
							"No", 	function() end)



end

function gangDisbanded(um)
	if !ValidPanel(gangSheet) then return end
	gangSheet:ShowCreateGang()
end
usermessage.Hook("gangDisbanded",gangDisbanded)
function ShowCreateGang()
	local menu = vgui.Create("DFrame")
	menu:SetTitle("Create A Gang")
	menu:SetSize(200,300)
	local form = vgui.Create("DForm",menu)
	form:SetName("Create Gang")
	form:StretchToParent(5,25,5,5)
	local textName = form:TextEntry("Gang Name");
	local submit = form:Button("Create Gang");
	form:InvalidateLayout()
	menu:Center()
	menu:MakePopup()
	submit.DoClick = function() menu:Remove() RunConsoleCommand("createGang",textName:GetText()) end

end
function invitedToGang( um )
	local name = um:ReadString()
	local gang_id = um:ReadShort()
	local menu = vgui.Create("DFrame")
	menu:ShowCloseButton(false)
	menu:SetTitle("Gang Invite")
	menu:SetSize(200,300)
	local form = vgui.Create("DForm",menu)
	form:SetName("Gang Invite")
	form:StretchToParent(5,25,5,5)
	local submit = form:Help("You were invited to join "..name);
	local submit = form:Button("Accept Invite");
	local decline = form:Button("Decline Invite");
	form:InvalidateLayout()
	menu:Center()
	menu:MakePopup()
	submit.DoClick = function() menu:Remove() RunConsoleCommand("join_gang",gang_id) end
	decline.DoClick = function() menu:Remove() RunConsoleCommand("decline_gang",gang_id) end
end
usermessage.Hook("invitedToGang",invitedToGang)


myGangBank = {}
local gangBankPanel
function ShowGangBank( um )
	local name = um:ReadString()
	gangBankPanel = vgui.Create("DFrame")
	gangBankPanel:SetTitle("Gang Vault")
	gangBankPanel:SetSize(300,600)
	local lblName = vgui.Create("DLabel",gangBankPanel)
	lblName:SetText(name.."'s Gang Vault")
	lblName:SetFont("HUDBars")
	lblName:SizeToContents()
	lblName:SetPos(5,25)
	
	gangBankPanel.list = vgui.Create("DPanelList",gangBankPanel)
	gangBankPanel.list:StretchToParent(5,50,5,5)
	gangBankPanel.list:EnableVerticalScrollbar(true)
	gangBankPanel:Center()
	gangBankPanel:MakePopup()
	ShowInv()
	gangBankPanel.Close = function(p) p:Remove() HideInv() end

end
usermessage.Hook("sendGangBank",ShowGangBank)

function UpdateGangBankItem(um)
	
	local name = um:ReadString()
	local current_amt = um:ReadShort()
	
		

	myGangBank = myGangBank or {}
	if current_amt == 0 then
		myGangBank[name] = nil
	else
		myGangBank[name] = current_amt
	end
	local alt = false
	if ValidPanel(gangBankPanel) then
		gangBankPanel.list:Clear()
		
		for i,v in pairs(myGangBank) do
			
			local name = i
			tbl = GetItems()[name]

			local pnl = vgui.Create("DPanel")
			pnl:SetTall(32)
			
			local lblName = vgui.Create("DLabel",pnl)
			lblName:SetPos(5,5)
			lblName:SetText(name)
			lblName:SetFont("HUDBars")
			lblName:SizeToContents()
			lblName:SetTextColor(Color(0,0,0,255))
			local lblAmt = vgui.Create("DLabel",pnl)
			lblAmt:SetPos(5+lblName:GetWide()+5,5)
			lblAmt:SetText("("..v..")")
			lblAmt:SetFont("HUDBars")
			lblAmt:SizeToContents()
			lblAmt:SetTextColor(Color(0,0,0,255))
			
			alt = !alt
			
			local color = Color(200,200,200,255)
			if (!alt) then
				color = Color(170,170,170,255)
			end
			pnl.Paint = function(s)
				draw.RoundedBox(0,0,0,s:GetWide(),s:GetTall(),color)
			end
			
			local create = vgui.Create("DButton",pnl)
			
			pnl:SetToolTip(tbl.Description)
			create:SetSize(50,25)
			pnl:SizeToContents()
			create:SetText("Take")
			create.DoClick = function() RunConsoleCommand("hub_to_inv",name) end
			create:SetPos(200,5)
			pnl.PerformLayout = function(p) create:SetPos(p:GetWide()-55,5) end
			gangBankPanel.list:AddItem(pnl)
	
	
		end
	end

end
usermessage.Hook("sendGangBankItem",UpdateGangBankItem)



function gangHubStuff(ent,pos,alpha)
	local name = "Loading..."
	local gangname = ent:GetGangName()
	if territories[ent:GetNWInt("TerritoryID")] then
		name = territories[ent:GetNWInt("TerritoryID")].Name
	
		draw.SimpleTextOutlined(gangname.."'s Gang Hub","HUDBars",pos.x,pos.y-20,Color(255,255,255,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))
		if territories[ent:GetNWInt("TerritoryID")].ContestingGangName and territories[ent:GetNWInt("TerritoryID")].ContestingGangName != "" then
			local charge_per = ent:GetNWInt("ChargePercentage")/100
			draw.RoundedBox(0,pos.x-100,pos.y-60,200,24,Color(0,0,0,alpha))
			draw.RoundedBox(0,pos.x-98,pos.y-58,charge_per*(200-4),24-4,Color(50,200,50,alpha))
			draw.SimpleTextOutlined("Contested Territory!","HUDBars",pos.x,pos.y-40,Color(255,255,255,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))
		else
			draw.SimpleTextOutlined("Controlling: "..name,"HUDBars",pos.x,pos.y-40,Color(255,255,255,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))
		end
	
	end

end
AddCustomHUD("planted_gang_hub",gangHubStuff)

function gangVaultHud(ent,pos,alpha)
	local name = "Loading..."
	if ent:GetGangID() != 0 then
		local gangname = ent:GetGangName()

		draw.SimpleTextOutlined(gangname,"HUDBars",pos.x,pos.y-40,Color(0,255,0,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))
	else
		draw.SimpleTextOutlined("Unlinked","HUDBars",pos.x,pos.y-40,Color(255,0,0,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))

	end
end
AddCustomHUD("gang_vault",gangVaultHud)

function receiveTerritoryInfo(um)
	local territoryID = um:ReadChar()
	local isCaptured = um:ReadBool()
	if isCaptured then
		territories[territoryID].OwnerGangName = um:ReadString()
		territories[territoryID].OwnerGangID = um:ReadShort()
		territories[territoryID].CaptureTime = um:ReadLong()
		local isContested = um:ReadBool()
		if isContested then
			territories[territoryID].ContestingGangName = um:ReadString()
			territories[territoryID].ContestingGangID = um:ReadShort()
		else
			territories[territoryID].ContestingGangName = nil
			territories[territoryID].ContestingGangID = nil
		end
	else
		territories[territoryID].OwnerGangName = nil
		territories[territoryID].OwnerGangID = nil
		territories[territoryID].CaptureTime = nil
	end
end
usermessage.Hook("sendTerritoryInfo",receiveTerritoryInfo)

function CreateGangTab()
	gangSheet = vgui.Create("GangTab")
	Panels["Menu"].Sheet:AddSheet("Gang",gangSheet,"gui/silkicons/application_view_tile",nil,nil,nil,2)
end
hook.Add("OnMenusCreated","GangTab",CreateGangTab)



function territorieshud()
	local width = 150
	local height = 60
	
	for i,v in pairs(territories) do
	
		local color = Color(200,200,200,255)
		if territories[i].OwnerGangID == 0 then
			color = Color(200,200,200,255)
		elseif (territories[i].OwnerGangID == LocalPlayer():GetGangID()) then
			color = Color(0,200,0,255)
		elseif (territories[i].ContestingGangName) then
			color = Color(200,200,0,255)
		elseif (territories[i].OwnerGangID) then
			color = Color(200,0,0,255)
		end
		draw.RoundedBox(0,5+(i-1)*(width+10),5,width,height,color)
		draw.RoundedBox(0,2+(5+(i-1)*(width+10)),7,width-4,height-4,Color(50,50,50,255))
		draw.SimpleTextOutlined(v.Name,"HUDBars",10+(i-1)*(width+10),10,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		
		local str = "Not Captured"
		local held_for = "N/A"
		if (territories[i].OwnerGangID) then
			str = territories[i].OwnerGangName
			
			
		end
		if territories[i].CaptureTime then
			held_for = string.ToMinutesSecondsBigTime(CurTime()-territories[i].CaptureTime)
		end
		
		
		draw.SimpleTextOutlined(str,"Default",10+(i-1)*(width+10),30,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("Held For: "..held_for,"Default",10+(i-1)*(width+10),45,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
	end
	if (LocalPlayer():GetGangName() != "") then
		draw.SimpleTextOutlined("Gang: "..LocalPlayer():GetGangName(),"HUDBars",215,ScrH()-50,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	end
	if LocalPlayer():GetNWInt("TerritoryID") != 0 then
		local name = territories[LocalPlayer():GetNWInt("TerritoryID")].Name
		draw.SimpleTextOutlined(name,"HUDBars",215,ScrH()-80,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	else
		draw.SimpleTextOutlined("Public","HUDBars",215,ScrH()-80,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
	end
		draw.SimpleTextOutlined("Level: "..LocalPlayer():GetLevel(),"HUDBars",215,ScrH()-110,Color(200,200,200,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,2,Color(0,0,0,255))
end
hook.Add("HUDPaint","territorieshud",territorieshud)