local creategangtext = [[
Gangs run the city. Literally!
Create your own gang to get in on the action and capture territory.

Territories are always under threat of attack but the rewards for holding one are great.

Each territory will automatically produce resources for the gang that has captured it.
Gangs also have their own bank which can only be accessed when at least one territory is captured.

Plant your gang hub down at each territory to contest or take control!

See how long you can hold the entire city!
]]

local GANGTAB = {}
function GANGTAB:Init()
	if (LocalPlayer():GetNWBool("HasGang")) then
		self:ShowMyGang()
	else
		self:ShowCreateGang()
	end
end
function GANGTAB:ShowCreateGang()
	local helptext = vgui.Create("DLabel",self)
	helptext:SetPos(5,5)
	helptext:SetText(creategangtext)
	helptext:SizeToContents()
	
	local costtext = vgui.Create("DLabel",self)
	costtext:SetPos(5,5+helptext:GetTall()+5)
	costtext:SetText("It costs $"..GANG_CREATION_COST.." to create a gang")
	costtext:SizeToContents()
	local costx,costy = costtext:GetPos()
	local createbutton = vgui.Create("DButton",self)
	createbutton:SetPos(5,costy + costtext:GetTall()+5)
	createbutton:SetText("Create a Gang")
	createbutton:SetSize(200,30)
	createbutton.DoClick = function() ShowCreateGang() end
end
function GANGTAB:Paint()

end
vgui.Register("GangTab",GANGTAB,"DPanel")


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
	submit.DoClick = function() RunConsoleCommand("createGang",textName:GetText()) end

end

function gangHubStuff(ent,pos,alpha)
	local name = "Loading..."
	local gangname = ent:GetGangName()
	if territories[ent:GetNWInt("TerritoryID")] then
		name = territories[ent:GetNWInt("TerritoryID")].Name
	end
	if GetGlobalInt("t_contester_id_"..ent:GetNWInt("TerritoryID")) != 0 then
		local charge_per = ent:GetNWInt("ChargePercentage")/100
		draw.RoundedBox(0,pos.x-100,pos.y-60,200,24,Color(0,0,0,alpha))
		draw.RoundedBox(0,pos.x-98,pos.y-58,charge_per*(200-4),24-4,Color(50,200,50,alpha))
		
	end
	draw.SimpleTextOutlined(gangname.."'s Gang Hub","HUDBars",pos.x,pos.y-20,Color(255,255,255,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))
	if GetGlobalInt("t_contester_id_"..ent:GetNWInt("TerritoryID")) != 0 then
		draw.SimpleTextOutlined("Contested Territory!","HUDBars",pos.x,pos.y-40,Color(255,255,255,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))
	else
		draw.SimpleTextOutlined("Controlling: "..name,"HUDBars",pos.x,pos.y-40,Color(255,255,255,alpha),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,alpha))
	end
	
	
	
	
end
AddCustomHUD("planted_gang_hub",gangHubStuff)

function CreateGangTab()
	local store = vgui.Create("GangTab")
	Panels["Menu"].Sheet:AddSheet("Gang",store,"gui/silkicons/application_view_tile",nil,nil,nil,2)
end
hook.Add("OnMenusCreated","GangTab",CreateGangTab)



function territorieshud()
	local width = 150
	local height = 60
	
	for i,v in pairs(territories) do
	
		local color = Color(200,200,200,255)
		if GetGlobalInt("t_owner_id_"..i) == 0 then
			color = Color(200,200,200,255)
		elseif (GetGlobalInt("t_owner_id_"..i) == LocalPlayer():GetNWInt("GangID")) then
			color = Color(0,200,0,255)
		elseif (GetGlobalInt("t_contester_id_"..i) != 0) then
			color = Color(200,200,0,255)
		elseif (GetGlobalInt("t_owner_id_"..i) != 0) then
			color = Color(200,0,0,255)
		end
		draw.RoundedBox(0,5+(i-1)*(width+10),5,width,height,color)
		draw.RoundedBox(0,2+(5+(i-1)*(width+10)),7,width-4,height-4,Color(50,50,50,255))
		draw.SimpleTextOutlined(v.Name,"HUDBars",10+(i-1)*(width+10),10,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		
		local str = "Not Captured"
		local held_for = "N/A"
		if (GetGlobalString("t_owner_"..i) != "") then
			str = GetGlobalString("t_owner_"..i)
			
			
		end
		if GetGlobalInt("t_holdstart_"..i) != 0 then
			held_for = string.ToMinutesSeconds(CurTime()-GetGlobalInt("t_holdstart_"..i))
		end
		
		
		draw.SimpleTextOutlined(str,"Default",10+(i-1)*(width+10),30,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
		draw.SimpleTextOutlined("Held For: "..held_for,"Default",10+(i-1)*(width+10),45,Color(255,255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM,1,Color(0,0,0,255))
	end
	if (LocalPlayer():GetNWString("GangName") != "") then
		draw.SimpleTextOutlined("Gang: "..LocalPlayer():GetNWString("GangName"),"g_Logo",ScrW()-5,ScrH()-60,Color(200,200,200,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,3,Color(0,0,0,255))
	end
	if LocalPlayer():GetNWInt("TerritoryID") != 0 then
		local name = territories[LocalPlayer():GetNWInt("TerritoryID")].Name
		draw.SimpleTextOutlined(name,"g_Logo",ScrW()-5,ScrH()-100,Color(200,200,200,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,3,Color(0,0,0,255))
	else
		draw.SimpleTextOutlined("Public","g_Logo",ScrW()-5,ScrH()-100,Color(200,200,200,255),TEXT_ALIGN_RIGHT,TEXT_ALIGN_TOP,3,Color(0,0,0,255))
	end
end
hook.Add("HUDPaint","territorieshud",territorieshud)