include("sh_perks.lua")
function GM:OnLoadPerks(pl,perks)
	pl.Perks = {}
	if perks == "" then
		return
	end
	pl.Perks = baseraiders.util.Deserialize(perks)
end

local meta = FindMetaTable("Player")
function meta:GivePerk(perk)
	self.Perks[perk] = true
	SaveRPAccount(self)
end
