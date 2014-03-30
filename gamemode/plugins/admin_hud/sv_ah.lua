util.AddNetworkString("addAdminHUDLog");

local function InsertEntry(str, time, mode, ply) // the player already should be an admin if the hook was called
	if (!ply:IsStaff()) then return; end
	net.Start("addAdminHUDLog");
		net.WriteString(str);
		net.WriteString(time);
		net.WriteString(mode);
	net.Send(ply);
end

hook.Add("MsgAdminAdded", "AddLogEntry", function(tbl)
	
	local str = tbl[1];		// The string to add
	local mode = tbl[2];	// Some mode thing idk
	local time = tbl[3];	// The time this was added
	local ply = tbl[4];
	
	InsertEntry(str, time, mode, ply);	
end)