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




function CreateGangTab()
	local store = vgui.Create("GangTab")
	Panels["Menu"].Sheet:AddSheet("Gang",store,"gui/silkicons/application_view_tile",nil,nil,nil,2)
end
hook.Add("OnMenusCreated","GangTab",CreateGangTab)