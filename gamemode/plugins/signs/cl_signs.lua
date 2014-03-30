local PANEL = {}
local currSign = nil
function PANEL:Init()
	self:SetSize(300,100)
	self:Center()
	self:SetTitle("Sign Info")
	local form = vgui.Create("DForm",self)
	
	form:SetName("Sign Information");
	form:StretchToParent(5,25,5,5)
	
	local text = form:TextEntry("Sign Text");
	local b = form:Button("Set Text")
	b.DoClick = function() RunConsoleCommand("setSign",currSign,text:GetValue()) self:Remove() Panels["Signs"] = nil end
	self:MakePopup()
end
vgui.Register("SignMenu",PANEL,"DFrame");


function OpenSignMenu(id)
	currSign = id;
	Panels["Signs"] = vgui.Create("SignMenu")
end

