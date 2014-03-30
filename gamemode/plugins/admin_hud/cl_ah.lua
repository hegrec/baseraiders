local notifications = {};
local allowedModes = {1, 2, 5, 6 };
/*
	1 = Kills
	2 = Adverts
	3 = Requests - No
	4 = Radio 	 - No
	5 = Mayor Stuffs
	6 = Join/Leave
	7 = Gang	 - No
	TODO: Add kick/ban & teleport modes
*/

local panel = nil;
local function createAdminHud()
	if (IsValid(panel)) then return end
	panel = vgui.Create("DScrollPanel2");	// it's ugly how garry made the scroll bar on teh right. this one is on the left
	panel:SetSize(600, 100);
	panel:SetPos(25, 5);
	
end

local function prettyTime(time)
	if (!time) then return false; end
	
	local pretty = os.date("%I:%M:%S %p", time);
	return pretty;
end

local function updateHud()
	if (panel == nil) then createAdminHud() end // make sure the panel is active
	
	panel:Clear(); // clear the panel, we don't want stuff overwriting each other D:
	
	local notifications = table.Reverse(notifications); //reverse the table, so newest things are shown first
	
	for k,v in ipairs(notifications) do
		local event = v[1];
		local time = prettyTime(v[2]);
		local mode = tonumber(v[3]);

		if (!table.HasValue(allowedModes, mode)) then return; end
		
		local l = vgui.Create("DLabel");
		l:SetParent(panel);
		l:SetPos(0, 20*k);
		l:SetText("        "..time.." | "..event);
		l:SetColor(Color(255, 255, 255, 255));
		l:SizeToContents();
	end
end

net.Receive("addAdminHUDLog", function(len, client)
	local str = net.ReadString();
	local time = net.ReadString();
	local mode = net.ReadString();
	
	if (#notifications > 40) then
		table.Empty(notifications);
	end
	
	table.insert(notifications, {str, time, mode});
	updateHud();
end)