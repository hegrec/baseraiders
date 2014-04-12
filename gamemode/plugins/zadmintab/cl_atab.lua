--0 - all
--1 - kills
--2 - advert
--3 - request
--4 - radio
--7 - gang
--5 - mayor stuff
--6 - join leave

local logtbl = {}
local mode = 0
local logview 
function CreateAdminTab()
	local atab = vgui.Create("DPanelList")
	atab:SetPadding(6)
	atab:SetSpacing(4)
	atab:EnableVerticalScrollbar()

	local catpan = vgui.Create("DPanel")
	catpan:SetTall(47)

	local catpanhelp = vgui.Create("DLabel",catpan)
	catpanhelp:SetText("Select a category of the admin log you would like to display below")
	catpanhelp:SizeToContents()
	catpanhelp:SetPos(5,5)

	local allbtn = vgui.Create("DButton",catpan)
	allbtn:SetText("All")
	allbtn:SetWide(50)
	allbtn:SetPos(5,22)
	allbtn.DoClick = function()
						mode = 0
						populateLog()
					end
					
	local killsbtn = vgui.Create("DButton",catpan)
	killsbtn:SetText("Kills")
	killsbtn:SetWide(50)
	killsbtn:SetPos(65,22)
	killsbtn.DoClick = function()
						mode = 1
						populateLog()
					end

	local advetbtn = vgui.Create("DButton",catpan)
	advetbtn:SetText("Advert")
	advetbtn:SetWide(50)
	advetbtn:SetPos(125,22)
	advetbtn.DoClick = function()
						mode = 2
						populateLog()
					end

	local reqbtn = vgui.Create("DButton",catpan)
	reqbtn:SetText("Request")
	reqbtn:SetWide(50)
	reqbtn:SetPos(185,22)
	reqbtn.DoClick = function()
						mode = 3
						populateLog()
					end

	local radiobtn = vgui.Create("DButton",catpan)
	radiobtn:SetText("Radio")
	radiobtn:SetWide(50)
	radiobtn:SetPos(245,22)
	radiobtn.DoClick = function()
						mode = 4
						populateLog()
					end			
					
	local radiobtn = vgui.Create("DButton",catpan)
	radiobtn:SetText("Gang")
	radiobtn:SetWide(50)
	radiobtn:SetPos(305,22)
	radiobtn.DoClick = function()
						mode = 7
						populateLog()
					end		

	local mayorbtn = vgui.Create("DButton",catpan)
	mayorbtn:SetText("Mayor")
	mayorbtn:SetWide(50)
	mayorbtn:SetPos(365,22)
	mayorbtn.DoClick = function()
						mode = 5
						populateLog()
					end						
					
	local joinbtn = vgui.Create("DButton",catpan)
	joinbtn:SetText("Join/Leave")
	joinbtn:SetWide(50)
	joinbtn:SetPos(425,22)
	joinbtn.DoClick = function()
						mode = 6
						populateLog()
					end						
	
	local radiobtn = vgui.Create("DButton",catpan)
	radiobtn:SetText("Clear Log")
	radiobtn:SetWide(50)
	radiobtn:SetPos(485,22)
	radiobtn.DoClick = function()
						logtbl = {}
						populateLog()
					end								
	
	atab:AddItem(catpan)
		
	logview = vgui.Create("DListView")
	
	logview.OnRowRightClick = function(self, lineID, line)
		local menu = DermaMenu()	 
 		menu:AddOption("Copy to Clipboard", function() SetClipboardText(line:GetColumnText(1).." - "..line:GetColumnText(2)) end) 
		menu:Open()
	end
	
	local timecol = logview:AddColumn( "Time" ) 
	local entrycol = logview:AddColumn( "Entry" ) 
	
	timecol:SetMaxWidth(150)
	logview:SetHeight(370)
	atab:AddItem(logview)

	populateLog()
	if (LocalPlayer():IsSubAdmin()) then
		Panels["Menu"].Sheet:AddSheet("Admin Tab",atab,"gui/silkicons/wrench",nil,nil,nil,16) 
	end
end
hook.Add("OnMenusCreated","ZCreateAdminTab",CreateAdminTab)

function populateLog()
	if(!ValidPanel(logview))then return end

	logview:Clear() 
	for k,v in pairs(logtbl)do
		if(mode > 0)then
			if(v.Mode == mode)then
				logview:AddLine(v.Time,v.Event)
			end
		else
			logview:AddLine(v.Time,v.Event)
		end
	end
end 

function AddLogEntry(str,amode,timestamp)
	local temp = {}
	temp.Time = os.date("%x - %I:%M:%S %p",timestamp)
	temp.Event = str
	temp.Mode = tonumber(amode)
	
	table.insert(logtbl,temp)
	populateLog()
end