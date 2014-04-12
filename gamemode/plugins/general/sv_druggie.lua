resource.AddModel("models/Fungi/sta_skyboxshroom2")
resource.AddMaterial("materials/models/Fungi/msh_tex_shroom2")
resource.AddMaterial("materials/models/Fungi/msh_tex_shroom2b")
resource.AddMaterial("materials/models/Fungi/msh_tex_shroom2c")
resource.AddMaterial("materials/models/Fungi/msh_tex_shroom2d")
resource.AddMaterial("materials/models/Fungi/msh_tex_shroom2e")
resource.AddMaterial("materials/models/Fungi/msh_tex_shroom2f")


druggie = {}
druggie.seller = nil
function druggie.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if(!druggie.seller)then 
		druggie.seller =  ents.Create("npc_generic")
		druggie.seller:SetNPCName("Drug Dealer")
		druggie.seller:SetModel("models/gman.mdl")
		
		druggie.seller:Spawn()
		druggie.seller:EnableChat()
	end 
	druggie.seller:SetPos(ply:GetPos())
	druggie.seller:SetAngles(ply:GetAngles())
	local vec = ply:GetPos()
	local ang = ply:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/druglabs/seller/"..game.GetMap()..".txt",str)
end
AddChatCommand("setdrugnpc",druggie.SetSeller)

function druggie.LoadSeller()
	if file.Exists("darklandrp/druglabs/seller/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/druglabs/seller/"..game.GetMap()..".txt", "DATA")
		local tbl = string.Explode(" ",str)
		druggie.seller =  ents.Create("npc_generic")
		
		druggie.seller:SetPos(Vector(tbl[1],tbl[2],tbl[3]))
		druggie.seller:SetNPCName("Drug Dealer")
		druggie.seller:SetModel("models/gman.mdl")
		druggie.seller:SetAngles(Angle(tbl[4],tbl[5],tbl[6])) //It is an AimVector
		druggie.seller:Spawn()
		druggie.seller:EnableChat()
	end
end
hook.Add("InitPostEntity","LoadDrugSeller",druggie.LoadSeller)

function UseDrug(pl,cmd,args)

	local itemID = args[1]
	if GetItems()[itemID].Group != "Drugs" || !pl:HasItem(itemID) then return end
	pl:TakeItem(itemID)
	umsg.Start("usedDrug",pl)
		umsg.String(itemID)
	umsg.End()
	GetItems()[itemID].OnUse(pl)
end
concommand.Add("use_drug",UseDrug)