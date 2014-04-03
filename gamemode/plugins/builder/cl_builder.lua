NaughtyTools = {
	"material",
	"paint"
}

function GM:CanTool( ply, trace, mode )
	local bool = !table.HasValue(NaughtyTools,mode)	
	if !bool  then return false end
	return self.BaseClass:CanTool(ply,trace,mode)
end 

local buddypanel = nil
Buddies = {}
function BuddyPanel(Panel)
	if !buddypanel then
		buddypanel = Panel
	end
	Panel:ClearControls()
		
	Panel:Help("Buddies are able to move your props and toolgun them as well")

	for i,v in pairs(player.GetAll()) do
		if v != Me then
			
			local c = Panel:CheckBox(v:Name())
			
			c.OnChange = function(b) if (c:GetChecked() && !Buddies[v:SteamID()]) || !c:GetChecked() then RunConsoleCommand("rp_makebuddy",v:SteamID()) if Buddies[v:SteamID()] then Buddies[v:SteamID()] = nil	else Buddies[v:SteamID()] = 1 end end end
			if Buddies[v:SteamID()] then c:SetValue( true ) end
		end
	end
end
hook.Add("SpawnMenuOpen","RedoBuddy",function() if buddypanel then BuddyPanel(buddypanel) end end)

local function MakeBuddyMenu()
	spawnmenu.AddToolMenuOption("Utilities", "Baseraiders", "My Buddies", "My Buddies", "", "", BuddyPanel)
end
hook.Add("PopulateToolMenu", "MakeBuddyMenu", MakeBuddyMenu)

