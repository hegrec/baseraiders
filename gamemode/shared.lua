GM.DarklandID = 2
GM.Name = "Base Raiders";

GM.Author = "Darkspider";
DeriveGamemode("sandbox")

function GetBySteamID( steamID )

        --      Get all players
        local players = player.GetAll()
        
        --      Loop players
        for i,ply in ipairs(players) do
        
                --      Check if the player's steam ID is the same as the given one
                if ply:GetNWString("SteamID") == steamID then
                        return ply
                end
        end
        
        --      If not found, return false
        return false
end
function GM:PlayerNoClip(pl)
	return DEVMODE or false
end
function string.SecondsToHours(seconds)
	local min = seconds*60;
	return min*60; //hours
end
BASE_RESPAWN_TIME = 6
WALK_SPEED = 100
RUN_SPEED = 175
PAYDAY_INTERVAL = 120
MAX_INTERACT_DIST = 100
DEFAULT_DOOR_PRICE = 100
DEFAULT_CASH = 6000
DEFAULT_JOB = "Citizen"
CHAT_DIST = 400
YELL_DIST = 650
WHISPER_DIST = 100
INV_X = 10
INV_Y = 10
INV_TILE_SIZE=40
DEFAULT_DOOR_TITLE = "For Rent"
DEFAULT_DOOR_COST = 100
MAX_INVENTORY = 50
JOB_SELECT_DELAY = 120
POWER_DISTANCE = 175
TEAM_CITIZENS = 1
DROP_GUNS_ON_DEATH = true

team.SetUp(TEAM_CITIZENS, "Citizens", Color(0, 155, 0, 255))

function GM:GravGunPunt(ply,ent)
	return false
end

function GM:PhysgunPickup(ply,ent)
	if(SERVER)then
		ent.LastPickedUp = ply
	end
	return hook.Call("CanPickup",GAMEMODE,ply,ent)
end

function GM:CanPickup(ply,ent)
	return true
end

Dialog = {}
Replies = {}

CitizenModels = {}

CitizenModels[1] = "models/darkland/human/male/darkland_male_01.mdl"
CitizenModels[2] = "models/darkland/human/male/darkland_male_02.mdl"
CitizenModels[3] = "models/darkland/human/male/darkland_male_03.mdl"
CitizenModels[4] = "models/darkland/human/male/darkland_male_04.mdl"
CitizenModels[5] = "models/darkland/human/male/darkland_male_05.mdl"
CitizenModels[6] = "models/darkland/human/male/darkland_male_06.mdl"
CitizenModels[7] = "models/darkland/human/male/darkland_male_07.mdl"
CitizenModels[8] = "models/darkland/human/male/darkland_male_08.mdl"
CitizenModels[9] = "models/darkland/human/male/darkland_male_09.mdl"
CitizenModels[10] = "models/darkland/human/female/darkland_female_01.mdl"
CitizenModels[11] = "models/darkland/human/female/darkland_female_02_v2.mdl"
CitizenModels[12] = "models/darkland/human/female/darkland_female_03_v2.mdl"
CitizenModels[13] = "models/darkland/human/female/darkland_female_04_v2.mdl"
CitizenModels[14] = "models/darkland/human/female/darkland_female_05_v2.mdl"
CitizenModels[15] = "models/darkland/human/female/darkland_female_06_v2.mdl"

for k,v in pairs(CitizenModels)do 
	util.PrecacheModel(v)
end
function string.ToMinutesSecondsBigTime(int)

	local secs = math.floor(int % 60)
	local mins = math.floor(int / 60 % 60)
	local hrs = math.floor(int / 3600)
	
	local out = ""
	if hrs>0 then
		out = out .. hrs.."H "
	end
	out = out .. mins.."M "
	out = out .. secs.."S"
	return out
end
function IsFemale(mdl)
	mdl = string.Explode("/",mdl)[5]
	return (string.sub(mdl,1,15) == "darkland_female")
end

function GetUser(Nick)
	for k,v in pairs(player.GetAll()) do
		if (v:Nick() == Nick) then
			return v;
		end
	end
	return false;
end