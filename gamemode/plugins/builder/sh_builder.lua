PROP_COST = 100
SPAWN_DELAY = 1

local CanPickUpEnts = {
"prop_physics",
"sign",
"gmod_lamp",
"gmod_light"
}

function GM:PlayerSpawnObject( ply )
	if ply.NextPropSpawn && ply.NextPropSpawn > CurTime() then ply:SendNotify("Not so fast you prop spamming noob!","NOTIFY_ERROR",4) return false end
	ply.NextPropSpawn = CurTime() + SPAWN_DELAY
	return true
end

local meta = FindMetaTable("Entity")
function CanPickup(pl,ent)
	if !table.HasValue(CanPickUpEnts,ent:GetClass()) || (ent:GetOwn() != pl && !pl:IsBuddy(ent:GetOwn()) && !pl:IsAdmin()) then return false end
end
hook.Add("CanPickup","CheckCanI",CanPickup)

local meta = FindMetaTable("Player")
function meta:IsBuddy(pl)
	if !pl then return end
	if !pl.Buddies then return end
	for i,v in pairs(pl.Buddies) do
		if i == self:SteamID() then return true end
	end
end 