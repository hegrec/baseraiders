AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )


local PLAYER = {}

PLAYER.TauntCam = TauntCamera()

PLAYER.DisplayName			= "Base Raiders Class"


function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end


function PLAYER:Loadout()
end

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )


end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal() 

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end


function PLAYER:GetHandsModel()

	return { model = "models/weapons/c_arms_citizen.mdl", skin = 0, body = "000000" }
	
	
--	local cl_playermodel = self.Player:GetInfo( "cl_playermodel" )
	
	--[[for name, model in SortedPairs( player_manager.AllValidModels() ) do
		if model == self.Player:GetModel() then
			return player_manager.TranslatePlayerHands( name ) or "models/weapons/c_arms_citizen.mdl"
		end

	end
]]
end

player_manager.RegisterClass( "player_baseraiders", PLAYER, "player_default" )

player_manager.AddValidModel( "female01",		"models/darkland/human/female/darkland_female_01.mdl" )
player_manager.AddValidHands( "female01",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "female02",		"models/darkland/human/female/darkland_female_02_v2.mdl" )
player_manager.AddValidHands( "female02",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "female03",		"models/darkland/human/female/darkland_female_03_v2.mdl" )
player_manager.AddValidHands( "female03",		"models/weapons/c_arms_citizen.mdl",		1,		"0000000" )
player_manager.AddValidModel( "female04",		"models/darkland/human/female/darkland_female_03_v2.mdl" )
player_manager.AddValidHands( "female04",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "female05",		"models/darkland/human/female/darkland_female_04_v2.mdl" )
player_manager.AddValidHands( "female05",		"models/weapons/c_arms_citizen.mdl",		1,		"0000000" )
player_manager.AddValidModel( "female06",		"models/darkland/human/female/darkland_female_05_v2.mdl" )
player_manager.AddValidHands( "female06",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )

player_manager.AddValidModel( "male01",		"models/darkland/human/male/darkland_male_01.mdl" )
player_manager.AddValidHands( "male01",		"models/weapons/c_arms_citizen.mdl",		1,		"0000000" )
player_manager.AddValidModel( "male02",		"models/darkland/human/male/darkland_male_02.mdl" )
player_manager.AddValidHands( "male02",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "male03",		"models/darkland/human/male/darkland_male_03.mdl" )
player_manager.AddValidHands( "male03",		"models/weapons/c_arms_citizen.mdl",		1,		"0000000" )
player_manager.AddValidModel( "male04",		"models/darkland/human/male/darkland_male_04.mdl" )
player_manager.AddValidHands( "male04",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "male05",		"models/darkland/human/male/darkland_male_05.mdl" )
player_manager.AddValidHands( "male05",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "male06",		"models/darkland/human/male/darkland_male_06.mdl" )
player_manager.AddValidHands( "male06",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "male07",		"models/darkland/human/male/darkland_male_07.mdl" )
player_manager.AddValidHands( "male07",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "male08",		"models/darkland/human/male/darkland_male_08.mdl" )
player_manager.AddValidHands( "male08",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )
player_manager.AddValidModel( "male09",		"models/darkland/human/male/darkland_male_09.mdl" )
player_manager.AddValidHands( "male09",		"models/weapons/c_arms_citizen.mdl",		0,		"0000000" )