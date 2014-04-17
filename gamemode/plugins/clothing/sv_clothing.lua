resource.AddFile("materials/americahat.vtf")
resource.AddFile("materials/beerhat.vtf")
resource.AddFile("materials/bunnyears.vtf")
resource.AddFile("materials/captainshat.vtf")
resource.AddFile("materials/highhat.vtf")
resource.AddFile("materials/mariohat.vtf")
resource.AddFile("materials/paperbag.vtf")

resource.AddFolder("materials/models/americahat/")
resource.AddFolder("materials/models/beerhat/")
resource.AddFolder("materials/models/bunnyears/")
resource.AddFolder("materials/models/captainshat/")
resource.AddFolder("materials/models/highhat/")
resource.AddFolder("materials/models/mariohat/")
resource.AddFolder("materials/models/paperbag/")

resource.AddFolder("models/americahat/")
resource.AddFolder("models/beerhat/")
resource.AddFolder("models/bunnyears/")
resource.AddFolder("models/captainshat/")
resource.AddFolder("models/highhat/")
resource.AddFolder("models/mariohat/")
resource.AddFolder("models/paperbag/")

local hats = {}
hats.seller = nil

function hats.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if(!hats.seller)then 
		hats.seller =  ents.Create("npc_generic")
		hats.seller:Spawn()
	end 
	
	hats.seller:SetModel("models/mossman.mdl")
	hats.seller:SetNPCName("Hat Seller")
	hats.seller:SetPos(ply:GetPos())
	hats.seller:SetAngles(ply:GetAngles())
	hats.seller:EnableChat()
	local vec = ply:GetPos()
	local ang = ply:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/clothing/hatseller/"..game.GetMap()..".txt",str)
end
AddChatCommand("sethatseller",hats.SetSeller)

function hats.LoadSeller()
	if file.Exists("darklandrp/clothing/hatseller/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/clothing/hatseller/"..game.GetMap()..".txt", "DATA")
		local tbl = string.Explode(" ",str)
		hats.seller =  ents.Create("npc_generic")
		
		hats.seller:SetModel("models/mossman.mdl")
		hats.seller:SetNPCName("Hat Seller")
		
		hats.seller:SetPos(Vector(tbl[1],tbl[2],tbl[3]))
		hats.seller:SetAngles(Angle(tbl[4],tbl[5],tbl[6]))
		hats.seller:EnableChat()
		hats.seller:Spawn()
	end
end
hook.Add("InitPostEntity","LoadHatSeller1",hats.LoadSeller)

local meta = FindMetaTable("Player")
function meta:GiveHat(id)

	local eyes = self:LookupAttachment( 'anim_attachment_head' );
	
	if ( eyes == 0 ) then return; end
	
	local hat = GetClothes()[id]
	if !hat then return end
	if IsValid(self.hat) then self.hat:Remove() end
	self.hat = ents.Create( 'hat' )
	self.hat:SetModel(hat.Model)

	self.hat:SetParent( self )
	self.hat:SetOwner(self)
	
	local attachment = self:GetAttachment( eyes )

	local pos = attachment.Pos + ( attachment.Ang:Up( ) * hat.UpOffset)
	local pos = pos + ( attachment.Ang:Right( ) * hat.RightOffset )
	self.hat:SetPos( pos );
	

	self.hat:Spawn( );
	self.hat:Activate( );
	
	self.hat:Fire( "setparentattachmentmaintainoffset ","anim_attachment_head", 0.01 );
end

function BuyHat(pl,cmd,args)
	local hatID = args[1]
	local hatTBL = GetClothes()[hatID]
	if !hatTBL || hatTBL.Type != "Hat" || !pl:CanReach(pl.lastTalkEnt) || pl.lastTalkEnt:GetName() != "Hat Seller" then return end --no putting non hat items on your head or buying hats from anywhere in game
	if hatTBL.Price > pl:GetMoney() then pl:SendNotify("You can not afford that hat!","NOTIFY_ERROR",4) return end
	if pl.Clothing.hatID then return end --already owned
	pl:AddMoney(hatTBL.Price * -1)
	pl:GiveHat(hatID)
	
	pl.Clothing[hatID] = 1
	Query("UPDATE rp_playerdata SET CurrentHat='"..hatID.."' WHERE SteamID='"..pl:SteamID().."'")
	umsg.Start("boughtHat",pl)
	umsg.String(hatID)
	umsg.End()
	SaveRPAccount(pl)
end
concommand.Add("buyhat",BuyHat)

function BuyClothes(pl,cmd,args)
	local clothesID = args[1]
	local clothesTBL = GetClothes()[clothesID]
	if !clothesTBL || (clothesTBL.Type != "FemaleClothes" && clothesTBL.Type != "MaleClothes") || !pl:CanReach(pl.lastTalkEnt) || pl.lastTalkEnt:GetName() != "Clothes Seller" then return end --no putting non hat items on your head or buying hats from anywhere in game
	if clothesTBL.Price > pl:GetMoney() then pl:SendNotify("You can not afford that pair of clothes!","NOTIFY_ERROR",4) return end
	if pl.Clothing.clothesID then return end --already owned
	pl:AddMoney(clothesTBL.Price * -1)
	pl:SetSkin(clothesTBL.Skin)
	
	pl.Clothing[clothesID] = 1
	Query("UPDATE rp_playerdata SET CurrentSkin='"..clothesID.."' WHERE SteamID='"..pl:SteamID().."'")
	umsg.Start("boughtClothes",pl)
	umsg.String(clothesID)
	umsg.End()
	SaveRPAccount(pl)
end
concommand.Add("buyskin",BuyClothes)

function OpenHatMenu(pl)
	SendClothing(pl)
	umsg.Start("hatMenu",pl)
	umsg.End()
end

function OpenClothesMenu(pl)
	SendClothing(pl)
	umsg.Start("clothesMenu",pl)
	umsg.End()
end

local closets = {}
closets.closets = {}

function closets.Add(ply,args)
	if !ply:IsSuperAdmin() then return end
	local ent =  ents.Create("closet")

	ent:Spawn()
	local vecZ = Vector(0,0,ent:OBBMaxs().z)
	ent:SetPos(ply:GetPos()+vecZ)
	ent:SetAngles(ply:GetAngles())
	table.insert(closets.closets,ent)
	closets.Save()
end
AddChatCommand("addcloset",closets.Add)

function closets.Save()
	local tbl = {}
	for i,v in pairs(closets.closets) do
		local vec = v:GetPos()
		local ang = v:GetAngles()
		local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
		table.insert(tbl,str)
	end
	local str = util.TableToKeyValues(tbl)
	file.Write("darklandrp/clothing/closets/"..game.GetMap()..".txt",str)
end

function closets.Load()
	if file.Exists("darklandrp/clothing/closets/"..game.GetMap()..".txt", "DATA") then

		local str = file.Read("darklandrp/clothing/closets/"..game.GetMap()..".txt", "DATA")
		local tbl = util.KeyValuesToTable(str)
		
		for i,v in pairs(tbl) do
			local t = string.Explode(" ",v)
			local ent = ents.Create("closet")
			ent:SetPos(Vector(t[1],t[2],t[3]))
			ent:SetAngles(Angle(tonumber(t[4]),tonumber(t[5]),tonumber(t[6])))
			ent:Spawn()
			table.insert(closets.closets,ent)
		end
		
	end
end
hook.Add("InitPostEntity","LoadClosets",closets.Load)

function UseCloset(pl) --guaranteed you are not using across map but freeze and stuff here
	SendClothing(pl)
	SendCurrentClothing(pl)
	umsg.Start("useCloset",pl)
	umsg.End()
end
hook.Add("OnUseCloset","PlayerClosetUse",UseCloset)

function LoadClothing(pl,str,hat,skin)
	pl.CurrentClothing["Hat"] = hat
	pl.CurrentClothing["Clothes"] = skin
	local t = table.ToLoad(str)
	pl.Clothing = t
	if hat != "Default" then
		pl:GiveHat(hat)
	end
	if skin != "Default" && GetClothes()[skin] then
		pl:SetSkin(GetClothes()[skin].Skin)
	end
end
hook.Add("OnLoadClothing","ClothingLoaded",LoadClothing)

function SendClothing(pl)
	umsg.Start("getClothes",pl)
		for i,v in pairs(pl.Clothing) do
			if(!IsHat(i))then
				umsg.String(i)
			end
		end
	umsg.End()
	
	umsg.Start("getHats",pl)
		for i,v in pairs(pl.Clothing) do
			if(IsHat(i))then
				umsg.String(i)
			end
		end
	umsg.End()
end

function SendCurrentClothing(pl)
	umsg.Start("getCurrentClothes",pl)
		umsg.String(pl.CurrentClothing.Hat or "None")
		umsg.String(pl.CurrentClothing.Clothes or "Default")
	umsg.End()
end

local clothes = {}
clothes.seller = nil

function clothes.SetSeller(ply,args)
	if !ply:IsSuperAdmin() then return end
	if(!clothes.seller)then 
		clothes.seller =  ents.Create("npc_generic")
		clothes.seller:Spawn()
	end 
	
	clothes.seller:SetModel("models/mossman.mdl")
	clothes.seller:SetNPCName("Clothes Seller")
	clothes.seller:SetPos(ply:GetPos())
	clothes.seller:SetAngles(ply:GetAngles())
	clothes.seller:EnableChat()
	local vec = ply:GetPos()
	local ang = ply:GetAngles()
	local str = vec.x .. " " .. vec.y .. " " .. vec.z .. " " .. ang.pitch .. " " .. ang.yaw .. " " .. ang.roll
	file.Write("darklandrp/clothing/skinseller/"..game.GetMap()..".txt",str)
end
AddChatCommand("setskinseller",clothes.SetSeller)

function clothes.LoadSeller()
	if file.Exists("darklandrp/clothing/skinseller/"..game.GetMap()..".txt", "DATA") then
		local str = file.Read("darklandrp/clothing/skinseller/"..game.GetMap()..".txt", "DATA")
		local tbl = string.Explode(" ",str)
		clothes.seller =  ents.Create("npc_generic")
		
		clothes.seller:SetModel("models/mossman.mdl")
		clothes.seller:SetNPCName("Clothes Seller")
		
		clothes.seller:SetPos(Vector(tbl[1],tbl[2],tbl[3]))
		clothes.seller:SetAngles(Angle(tbl[4],tbl[5],tbl[6]))
		clothes.seller:EnableChat()
		clothes.seller:Spawn()
	end
end
hook.Add("InitPostEntity","Loadclotheseller1",clothes.LoadSeller)

function SetHat(pl,cmd,args)
	local hatID = args[1]
	if hatID != "Default" && !pl.Clothing[hatID] then return end
	if hatID == "Default" then
		if IsValid(pl.hat) then pl.hat:Remove() end
	else
		pl:GiveHat(hatID)
	end
	pl.CurrentClothing.Hat = hatID
	Query("UPDATE rp_playerdata set CurrentHat='"..hatID.."' WHERE SteamID='"..pl:SteamID().."'")
end
concommand.Add("sethat",SetHat)

function SetSkin(pl,cmd,args)
	local skinID = args[1]
	if skinID != "Default" && !pl.Clothing[skinID] then return end
	if skinID == "Default" then
		pl:SetSkin(0)
	else
		pl:SetSkin(GetClothes()[skinID].Skin)
	end
	pl.CurrentClothing.Clothes = skinID
	Query("UPDATE rp_playerdata set CurrentSkin='"..skinID.."' WHERE SteamID='"..pl:SteamID().."'")
end
concommand.Add("setskin",SetSkin)