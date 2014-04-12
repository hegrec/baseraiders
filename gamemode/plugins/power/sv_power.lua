
power.sockets = {}
function power.AddSocket(ply,args)
	if !ply:IsSuperAdmin() then return end

	local tr = ply:GetEyeTrace()
	
	
	local ent = ents.Create("power_socket")
	ent:SetPos(tr.HitPos+tr.HitNormal*5)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Spawn()

	table.insert(power.sockets,ent)
	power.SaveSockets()
end
AddChatCommand("addsocket",power.AddSocket)


function power.SaveSockets()
	local tbl = {}
	for i,v in pairs(power.sockets) do
		local s = v:GetPos().x.." "..v:GetPos().y.." "..v:GetPos().z.." "..v:GetAngles().pitch.." "..v:GetAngles().yaw.." "..v:GetAngles().roll
		table.insert(tbl,s)
	end
	local str = util.TableToKeyValues(tbl)
	file.Write("darklandrp/sockets/"..game.GetMap()..".txt",str)
end
function power.LoadSockets()
	if file.Exists("darklandrp/sockets/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/sockets/"..game.GetMap()..".txt", "DATA")	
		local t = util.KeyValuesToTable(str)
		for i,v in pairs(t) do

			local v = string.Explode(" ",v)
			local ent = ents.Create("power_socket")
			local ang = Angle(tonumber(v[4]),tonumber(v[5]),tonumber(v[6]))
			ent:SetPos(Vector(v[1],v[2],v[3]))
			ent:Spawn()
			ent:SetAngles(ang)
			table.insert(power.sockets,ent)
		end
	end
end
hook.Add("InitPostEntity","LoadSockets",power.LoadSockets)
