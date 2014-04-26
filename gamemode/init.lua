//testing
//test


function resource.AddModel(path)
	resource.AddFile(path..".mdl")
	resource.AddFile(path..".sw.vtx")
	resource.AddFile(path..".dx90.vtx")
	resource.AddFile(path..".dx80.vtx")
	resource.AddFile(path..".vvd")
end

function resource.AddMaterial(path)
	resource.AddFile(path..".vtf")
	resource.AddFile(path..".vmt")
end

function resource.AddFolder(path)
     if path[#path] != '/' then path = path..'/' end
   
     local fs, ds = file.Find(path.."*","GAME")
     for k, v in pairs(fs) do
          resource.AddFile(path..v)
     end
end

resource.AddFile("sound/darklandrp/heartbeat.wav")
resource.AddFile("materials/models/baseraiders/log.vtf")
resource.AddFile("materials/models/baseraiders/log_lod0.vmt")
resource.AddFile("materials/models/baseraiders/log_lod1.vmt")
resource.AddFile("materials/models/baseraiders/log_NRM.vtf")

resource.AddMaterial("materials/gui/silkicons/error")
resource.AddMaterial("materials/gui/silkicons/pill")

resource.AddMaterial("materials/katharsmodels/contraband/contraband_one")
resource.AddMaterial("materials/katharsmodels/contraband/contraband_two")
resource.AddMaterial("materials/katharsmodels/contraband/contraband_normal")

resource.AddModel("models/katharsmodels/contraband/zak_wiet/zak_wiet")
resource.AddModel("models/baseraiders/log")

resource.AddModel("models/nater/weedplant_pot")
resource.AddModel("models/nater/weedplant_pot_dirt")
resource.AddModel("models/nater/weedplant_pot_growing1")
resource.AddModel("models/nater/weedplant_pot_growing2")
resource.AddModel("models/nater/weedplant_pot_growing3")
resource.AddModel("models/nater/weedplant_pot_growing4")
resource.AddModel("models/nater/weedplant_pot_growing5")
resource.AddModel("models/nater/weedplant_pot_growing6")
resource.AddModel("models/nater/weedplant_pot_growing7")
resource.AddModel("models/nater/weedplant_pot_leaf")
resource.AddModel("models/nater/weedplant_pot_planted")
resource.AddMaterial("materials/models/nater/weedplant_bud")
resource.AddMaterial("materials/models/nater/weedplant_bud_bump")
resource.AddMaterial("materials/models/nater/weedplant_dirt")
resource.AddMaterial("materials/models/nater/weedplant_dirt_bump")
resource.AddMaterial("materials/models/nater/weedplant_leaf_new")
resource.AddMaterial("materials/models/nater/weedplant_leaf_new_bump")
resource.AddMaterial("materials/models/nater/weedplant_leaf_texture")
resource.AddMaterial("materials/models/nater/weedplant_texture")
resource.AddMaterial("materials/models/nater/weedplant_texture_bump")

resource.AddMaterial("materials/baseraiders/minimap")


resource.AddModel("models/darkland/human/male/darkland_male_01")
resource.AddModel("models/darkland/human/male/darkland_male_02")
resource.AddModel("models/darkland/human/male/darkland_male_03")
resource.AddModel("models/darkland/human/male/darkland_male_04")
resource.AddModel("models/darkland/human/male/darkland_male_05")
resource.AddModel("models/darkland/human/male/darkland_male_06")
resource.AddModel("models/darkland/human/male/darkland_male_07")
resource.AddModel("models/darkland/human/male/darkland_male_08")
resource.AddModel("models/darkland/human/male/darkland_male_09")
resource.AddFolder("materials/models/darkland/human/male/")
resource.AddModel("models/darkland/human/female/darkland_female_01")
resource.AddModel("models/darkland/human/female/darkland_female_02_v2")
resource.AddModel("models/darkland/human/female/darkland_female_03_v2")
resource.AddModel("models/darkland/human/female/darkland_female_04_v2")
resource.AddModel("models/darkland/human/female/darkland_female_05_v2")
resource.AddModel("models/darkland/human/female/darkland_female_06_v2")
resource.AddFolder("materials/models/darkland/human/female/")
resource.AddFolder("materials/models/darkland/human/")
--We include the needed files
include("chat.lua")

include("mapsetup.lua")
include("commands.lua")
include("saveload.lua")
include("shared.lua")
include("player.lua")

include("obj_player_extend.lua")
include("obj_entity_extend.lua")
include("items/sh_itemdefines.lua")
include("items/sv_items.lua")
include("perks/sh_perks.lua")
include("perks/sv_perks.lua")
include("npcchat/sv_conversation.lua")

AddCSLuaFile("cl_notify.lua")
AddCSLuaFile("npcchat/cl_conversation.lua")
AddCSLuaFile("obj_player_extend.lua")
AddCSLuaFile("obj_entity_extend.lua")
AddCSLuaFile("vgui/DColorMixerNoAlpha.lua")
AddCSLuaFile("vgui/DMultiModelPanel.lua")
AddCSLuaFile("vgui/DHorizontalScroller2.lua")
AddCSLuaFile("vgui/DPropertySheet2.lua")
AddCSLuaFile("vgui/DScrollPanel2.lua")
AddCSLuaFile("vgui/DCategoryCollapse2.lua")
AddCSLuaFile("perks/sh_perks.lua")
AddCSLuaFile("perks/cl_perks.lua")
AddCSLuaFile("items/sh_itemdefines.lua")
AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_inventory.lua")
AddCSLuaFile( "cl_scoreboard2.lua" )
AddCSLuaFile( "scoreboard/admin_buttons.lua" )
AddCSLuaFile( "scoreboard/player_frame.lua" )
AddCSLuaFile( "scoreboard/player_infocard.lua" )
AddCSLuaFile( "scoreboard/player_row.lua" )
AddCSLuaFile( "scoreboard/scoreboard.lua" )
AddCSLuaFile( "scoreboard/vote_button.lua" )
AddCSLuaFile( "scoreboard/leaderboard.lua" )

--remove ratings from getting sent to clinets

hook.Remove("PlayerInitialSpawn", "PlayerRatingsRestore")
concommand.Remove("rateuser")		

function PlayerDataUpdate(ply) --overwrite this sandbox function...i dont give a rats ass about ur xfire

end

function DBClean(s)
	return escape(s);
end
function GM:Initialize()
	hook.Add("PlayerSpawnedProp","PropSpawnProtect",function(ply,model,ent) ply:GiveObject(ent) end)

	hook.Add("EntityRemoved","RemoveFromTheTable",
	function(ent)
		local pl = ent:GetOwn()
		if !IsValid(pl) || ent:IsWorld() then return end
		RemoveObject(ent)
	end)
end
function GM:CanProperty(name,arg)
	return false;
end
function GM:ShowSpare1(pl) --f3
	pl:ConCommand("rp_doorstuff")
end
 
function GM:ShowSpare2(pl) --f4

end

function GM:OnHatchet(pl,tr)
	if math.random() < 0.5 then
		pl.harvestents = pl.harvestents or {}
		local ent = SpawnRoleplayItem("Wood",tr.HitPos+tr.HitNormal*10)
		
		local i = 1
		while (i<#pl.harvestents) do
			if (!pl.harvestents[i]:IsValid()) then
				table.remove(pl.harvestents,i)
			else
				i = i + 1
			end
			
		end
		while (#pl.harvestents>=5) do
			pl.harvestents[1]:Remove()
			table.remove(pl.harvestents,1)
		end
		table.insert(pl.harvestents,ent)
		
		timer.Simple(30, function()
			if ent:IsValid() then
				ent:Remove()
			end
		end)
		
		umsg.Start("experienceUp")
			umsg.Vector(ent:GetPos())
			umsg.Short(1)
			umsg.Bool(pl:IsVIP())
		umsg.End()
		pl:AddExperience(1)
	end
end

function GM:OnPickaxe(pl,tr)
	if math.random() < 0.8 then
		pl.harvestents = pl.harvestents or {}
		local ent = SpawnRoleplayItem("Ore",tr.HitPos+tr.HitNormal*10)
		
		local i = 1
		while (i<#pl.harvestents) do
			if (!pl.harvestents[i]:IsValid()) then
				table.remove(pl.harvestents,i)
			else
				i = i + 1
			end
		end
		while (#pl.harvestents>=5) do
			pl.harvestents[1]:Remove()
			table.remove(pl.harvestents,1)
		end
		table.insert(pl.harvestents,ent)
		
		timer.Simple(30, function()
			if ent:IsValid() then
				ent:Remove()
			end
		end)
		
		umsg.Start("experienceUp")
			umsg.Vector(ent:GetPos())
			umsg.Short(1)
			umsg.Bool(pl:IsVIP())
		umsg.End()
		pl:AddExperience(1)
	end
end

function GM:OnShovel(pl,tr)
	if math.random() < 0.8 then
		local i = math.random(10)
		pl.harvestents = pl.harvestents or {}
		local ent
		if i>6 then
			ent = SpawnRoleplayItem("Sand",tr.HitPos+tr.HitNormal*10)
		umsg.Start("experienceUp")
			umsg.Vector(ent:GetPos())
			umsg.Short(1)
			umsg.Bool(pl:IsVIP())
		umsg.End()
		pl:AddExperience(1)
		elseif i>3 then
			ent = SpawnRoleplayItem("Clay",tr.HitPos+tr.HitNormal*10)
		umsg.Start("experienceUp")
			umsg.Vector(ent:GetPos())
			umsg.Short(2)
			umsg.Bool(pl:IsVIP())
		umsg.End()
		pl:AddExperience(2)
		elseif i==1 then
			ent = SpawnRoleplayItem("Marijuana Seed",tr.HitPos+tr.HitNormal*10)
			umsg.Start("experienceUp")
				umsg.Vector(ent:GetPos())
				umsg.Short(3)
				umsg.Bool(pl:IsVIP())
			umsg.End()
			pl:AddExperience(3)
		end
		
		pl.harvestents = pl.harvestents or {}
		local i = 1
		while (i<#pl.harvestents) do
			if (!pl.harvestents[i]:IsValid()) then
				table.remove(pl.harvestents,i)
			else
				i = i + 1
			end
		end
		while (#pl.harvestents>=5) do
			pl.harvestents[1]:Remove()
				table.remove(pl.harvestents,1)
		end
		table.insert(pl.harvestents,ent)
		
		timer.Simple(30, function()
			if ent:IsValid() then
				ent:Remove()
			end
		end)
		
	end
end

function GM:PlayerInitialSpawn(pl)
	GAMEMODE:SetPlayerSpeed(pl,WALK_SPEED,RUN_SPEED)
	pl:SetTeam(TEAM_CITIZENS)
	local id = pl:UserID();
	timer.Create("plyhpregen_"..id,10,0,function() 
		if IsValid(pl) then 
			pl:SetHealth(math.min(pl:Health()+1,100)) 
		else 
			timer.Destroy("plyhpregen_"..id) 
		end
	end)
end

function GM:PlayerSpawn(pl)
	GAMEMODE:PlayerSetModel(pl)
	GAMEMODE:PlayerLoadout(pl)
end
function PlayerReady(pl)
	hook.Call("OnPlayerReady",GAMEMODE,pl)
end
concommand.Add("player_ready",PlayerReady)
function GM:GetFallDamage(ply,speed)
	speed = speed - 580
	return speed * (100/444)
end

local model
function GM:PlayerSetModel(pl)
	if !pl.Model then
		pl:SetModel("models/darkland/human/male/darkland_male_01.mdl")
	else
		pl:SetModel(pl.Model)
		if GetClothes()[pl.CurrentClothing.Clothes] then
			pl:SetSkin(GetClothes()[pl.CurrentClothing.Clothes].Skin)
		end
	end
end

local tbl
local w
function GM:PlayerLoadout(pl)
	pl:StripWeapons()
	pl:Give("hands")
	pl:Give("weapon_physcannon")
	pl:Give("keys")
	pl:Give("weapon_physgun") 
	pl:Give("gmod_tool") 
	w = pl:GetWeapon("gmod_tool");
	if IsValid(w) then
		w.OldSecondaryAttack = w.SecondaryAttack;
		w.SecondaryAttack = FixedSecondaryToolAttack;
	end
end
function GM:EntityTakeDamage(target, dmginfo) 
	local amt = dmginfo:GetDamage()
	if (target:GetClass() == "prop_physics") then
		target:SetNWInt("Health",target:GetNWInt("Health")-amt)
		if (target:GetNWInt("Health")<=0) then
		
			local vPoint = target:GetPos()
			local effectdata = EffectData()
			effectdata:SetStart( vPoint ) -- not sure if ( we need a start and origin ( endpoint ) for this effect, but whatever
			effectdata:SetOrigin( vPoint )
			effectdata:SetScale( 1 )
			util.Effect( "HelicopterMegaBomb", effectdata )
			target:EmitSound("ambient/explosions/explode_4.wav")
			target:Remove()
		end
	elseif target:IsPlayer() then
		local attacker = dmginfo:GetAttacker()
		if attacker:IsPlayer() then
			attacker:SetHostileTo(target)
		end
	end
end

local BadRightClicks = {"slider","hydraulic","muscle","winch"};
function FixedSecondaryToolAttack(self)
	if table.HasValue(BadRightClicks,self:GetMode()) then return end
	self.OldSecondaryAttack(self)
end
function GM:PlayerSay(pl,txt,public)
	if string.find(txt,"//") == 1 then
		return string.sub(txt,3)
	elseif string.find(txt,"/") == 1 then
		return RunChatCommand(pl,txt) or "";
	end
 	
	return txt
end

function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	if pTalker:HasLineOfSight(pListener) and pTalker:GetPos():Distance(pListener:GetPos()) < 300 then 
		return true
	else 
		return false
	end
end

function GetLocalPlayers(pl,dist)
	local t = {}
	for i,v in pairs(player.GetAll()) do
		if v:GetPos():Distance(pl:GetPos()) <= dist then
			table.insert(t,v)
		end
	end
	return t
end

function GM:GravGunPickupAllowed(ply,ent)
	if !IsValid(ent) then return end
	return true
end

function GM:OnPhysgunReload( weapon, ply )
	--ply:PhysgunUnfreeze( weapon )
	return false
end

function GM:ShowHelp(pl)
	pl:ConCommand("show_main")
end

--If hooks from plugins let it fall to this then just let them use the job
function GM:CanUseJob(pl,job)
	return true
end

function CheckIfConnected(id)
	for k,v in pairs(player.GetAll()) do
		if(v:SteamID() == id) then return end --they are connected
	end
	if(!Owned[id])then return end
	for k,v in pairs(Owned[id])do
		RemoveObject(k)
	end
	--TODO: Make it tell everyone you sold everything
end

function GM:PlayerDisconnected(ply)
	timer.Create("PlyDisconnect_"..ply:SteamID(),180,1,CheckIfConnected,ply:SteamID())
	MsgAdmin(ply:Name() .. " ("..ply:SteamID()..") has disconnected",6)
end

function GM:PlayerAuthed(ply,steam)
	--MsgAdmin(ply:Name() .. " ("..steam..") has connected",6)
end

function GM:PlayerSpawnSENT(pl,ent)
	return false
end

function GM:PlayerSpawnSWEP(pl,swep)
	return false
end

function GM:PlayerGiveSWEP(pl,swep)
	return false
end

function GM:PlayerSpawnVehicle(Player, Model, VName, VTable )
	return DEVMODE
end

function NotifyAll(msg, kind, length)
	for k,v in pairs(player.GetAll())do
		v:SendNotify(msg,kind,length)
	end
end

function player.FindNameMatch(str)
	if !str then return end
	str = string.lower(str)
	for i,v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()),str) then return v end
	end
end

function GM:ShutDown()
	for i,v in pairs(player.GetAll()) do SaveRPAccount(v) end
end

function MsgAdmin(str,mode)
	local str = str
	for k,v in pairs(player.GetAll())do
		if(v:IsStaff())then
			v:SendLua("AddLogEntry(\""..str.."\",\""..mode.."\",\""..os.time().."\")")
			hook.Call("MsgAdminAdded", GAMEMODE, {str, mode, os.time(), v});
		end
	end
end

function GM:CanPlayerSuicide(pl)
	return false
end

local respawnTime
function GM:PlayerDeath( Victim, Inflictor, Attacker )
	respawnTime = BASE_RESPAWN_TIME
	if(Victim:Frags() > Victim:Deaths())then
		--respawn Time = 0.115x^2 + 1.947x - 0.0737
		local x = math.Clamp(Victim:Frags() - Victim:Deaths(),0,15)
		respawnTime = respawnTime + math.Round(0.115*(x*x) + 1.947*x - 0.0737)
	end
	Victim.NextSpawnTime = CurTime() + respawnTime
	Victim:SendNotify('You will be able to spawn in '..Victim.NextSpawnTime-CurTime()..' seconds',"NOTIFY_GENERIC",5)
	for k,v in pairs(Victim:GetWeapons())do
		if(DROP_GUNS_ON_DEATH)then
			SpawnRoleplayItem(v.WepType,Victim:GetPos())
			Victim:TakeItem(v.WepType)
		end			
	end


	--noteriety


	
	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then
		Inflictor = Inflictor:GetActiveWeapon()
		if ( !Inflictor || Inflictor == NULL ) then Inflictor = Attacker end
	end
	
	if (Attacker == Victim) then
		MsgAdmin( Attacker:Name() .. " suicided!" ,1)
	return end

	if ( Attacker:IsPlayer() ) then
		MsgAdmin( Attacker:Name() .. " killed " .. Victim:Name() .. " using " .. Inflictor:GetClass(),1)

		if !Victim:IsHostileTo(Attacker) then
			local innocent_gain = 200
			if (Victim:GetGangID() == 0) then
				innocent_gain = 300
			end
			if Victim:GetNoteriety() < 50 then
				Attacker:AddNoteriety(innocent_gain)
			elseif Victim:GetNoteriety() < 250 then
				Attacker:AddNoteriety(125)
			else
				Attacker:AddNoteriety(50)
			end
		else
			Attacker:SendNotify("You killed a hostile aggressor.","NOTIFY_GENERIC",5)
		end



	return end

	Victim:ClearHostility()

	
	if(Attacker:IsVehicle())then
		local driver = Attacker:GetDriver()
		if !IsValid(driver) then
			driver = "Nobody"
		else
			driver = driver:Name()
		end
		
		MsgAdmin( Victim:Name() .. " was killed by " .. Attacker:GetClass() .. " driven by "..driver,1)
		return 
	end
	
	if(Attacker:GetClass() == "prop_physics")then
			
		if(Attacker:GetNWString("Owner"))then
			MsgAdmin( Victim:Name() .. " was killed by " .. Attacker:GetClass() .. " owned by "..player.GetBySteamID(Attacker:GetNWString("Owner")):Name(),1)
		return end
	end
	MsgAdmin( Victim:Name() .. " was killed by " .. Attacker:GetClass(),1)
end

function GM:DoPlayerDeath(ply, attacker, dmginfo) 
	ply:CreateRagdoll() 
	ply:AddDeaths(1) 
	 
	if(attacker:IsValid() && attacker:IsPlayer())then 
		if(attacker != ply)then 
			attacker:AddFrags(1) 
		end 
	end 
end 

function GM:AFK(ply)
	if(ply:IsAdmin())then return end
	if(ply:InVehicle())then
		ply:ExitVehicle()
	end
	--game.ConsoleCommand( Format( "kickid %i %s\n", ply:UserID(), "AFK for 300 seconds" ) )
end

function RequestModel(pl)
	umsg.Start("getModel",pl)
	umsg.End()
end

util.AddNetworkString("addStoreItem")
function ViewStore(pl,ent,store)
	umsg.Start("showStore",pl)
	umsg.Short(ent:EntIndex())
	umsg.String(store.Title)
	umsg.End()
	
	
	for i,v in pairs(store.items) do
		print(i,v)
		net.Start("addStoreItem")
		net.WriteString(i)
		net.WriteInt(v,8)
		net.Send(pl)
	end
end

function BuyFromStore(pl,cmd,args)

	local ent = ents.GetByIndex(tonumber(args[1]))
	if !IsValid(ent) then return end
	if !pl:FacingNPC(ent) then return end
	local store = ent.store
	local item = args[2]
	if !store.items[item] then return end

	if pl:GetMoney() < store.items[item] then pl:SendNotify("You can not afford this","NOTIFY_ERROR",4) return end
	if store.CanBuy and !store.CanBuy(pl,item) then return end
	if pl:GiveItem(item) then
		pl:AddMoney(store.items[item]*-1)
		pl:SendNotify("You bought an item ("..item..")","NOTIFY_GENERIC",6)
		if store.OnBuy then store.OnBuy(pl,item) end
	end

end
concommand.Add("buystore",BuyFromStore)

function SetModel(pl,cmd,args)
	if(pl.Model and pl.Model != "")then return end --a model already exists, they are trying to change it
	
	if(!tonumber(args[1]))then RequestModel(pl) return end --a number was not sent
	local mdl = CitizenModels[tonumber(args[1])]
	
	if(!mdl)then RequestModel(pl) return end --they sent a number not in the citizenmodel table
	pl.Model = mdl
	pl:SetModel(mdl)
	pl:SetSkin(tonumber(args[1])%9)
	SendModel(pl)
	SaveRPAccount(pl)
end
concommand.Add("setmodel",SetModel)



function sendLeaderboard(ply,cmd,args)

	Query("SELECT Name,Experience FROM rp_gangdata ORDER BY Experience DESC LIMIT 5",function(res,stat,err)
		

		umsg.Start("sendLeaderboard",ply)
			umsg.Char(#res)
			for i,v in pairs(res) do
				umsg.String(v.Name)
				umsg.Long(v.Experience)
			end
		umsg.End()
	end)

end
concommand.Add("load_leaderboard",sendLeaderboard)


local meta = FindMetaTable("Entity")
function meta:SetItemName(s)
	return self:SetDTString(1,s)
end


function heheanticheat(ply,cmd,args)
	if(DEVMODE)then return end
	if(!IsValid(ply))then return end
	filex.Append("suspectcheaters.txt",os.date("%x - %I:%M:%S %p",os.time()).." "..ply:Name() .. " " .. ply:SteamID().."\n")
	game.ConsoleCommand("kickid "..ply:UserID().." SteamID authentication failed\n")
end
concommand.Add("sync", heheanticheat)
include("plugins.lua") //Load last