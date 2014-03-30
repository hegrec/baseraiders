function CreateRolePlayMoney(pl,amt)
	local trace = pl:EyeTrace(MAX_INTERACT_DIST)
	local ent = ents.Create("money")
	ent:SetModel("models/props/cs_assault/Money.mdl")
	ent:SetPos(Vector(trace.HitPos.x,trace.HitPos.y,trace.HitPos.z+16))
	ent:SetNWInt("amount",amt)
	ent:Spawn()
end