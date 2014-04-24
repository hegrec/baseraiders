
function ViewModelHandsFix(ply)
	// Set their playerclass for viewmodel hands
	player_manager.SetPlayerClass( ply, "player_baseraiders" )
	player_manager.RunClass( ply, "Spawn" )
	
	ply:SetupHands()
end
hook.Add("PlayerSpawn","viewmodelhands_plyspawn",ViewModelHandsFix)