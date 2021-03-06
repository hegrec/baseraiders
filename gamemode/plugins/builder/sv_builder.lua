local NaughtyTools = {
	"dynamite",
	"ballsocket_adv",
	"ignite",
	"nocollide",
	"trails",
	"turret",
	"spawner",
	"colour",
	"rtcamera",
	"emitter",
	"material",
	"paint",
	"thruster",
	"motor",
	"wheel",
	"duplicator",
	"nail",
	"magnetise",
	"balloon",
	"leafblower",
	"rope",
	"hoverball",
	"pulley",
	"muscle",
	"slider",
	"physprop",
	"lamp",
	"light"
}

local cantool = {
	"prop_physics",
	"sign",
	"gmod_lamp",
	"gmod_light",
	"gmod_button",
	"gmod_cameraprop"
}

local buttons = {
"models/dav0r/buttons/button.mdl",
"models/dav0r/buttons/switch.mdl",
"models/props_c17/clock01.mdl",
"models/props_junk/garbage_coffeemug001a.mdl",
"models/props_junk/garbage_newspaper001a.mdl",
"models/props_lab/huladoll.mdl",
"models/props_c17/playgroundTick-tack-toe_block01a.mdl",
"models/props_c17/computer01_keyboard.mdl",
"models/props_c17/cashregister01a.mdl",
"models/props_lab/powerbox02d.mdl",
"models/props_lab/reciever01d.mdl"
}

NaugtyProps = {
"models/props_c17/oildrum001_explosive.mdl",
"models/props_canal/canal_bridge03b.mdl",
"models/props_canal/canal_bridge03a.mdl",
"models/props_canal/canal_bridge02.mdl",
"models/props_canal/canal_bridge01.mdl",
"models/props_phx/mk-82.mdl",
"models/props_phx/torpedo.mdl",
"models/props_phx/ww2bomb.mdl",
"models/props_phx/amraam.mdl",
"models/props_phx/rocket1.mdl",
"models/props_combine/Combine_Citadel001.mdl",
"models/props_junk/gascan001a.mdl",
"models/props_canal/locks_large.mdl",
"models/props_canal/locks_large_b.mdl",
"models/props_phx/misc/flakshell_big.mdl",
"models/props_phx/oildrum001_explosive.mdl",
"models/props_phx/misc/potato_launcher_explosive.mdl",
"models/props_junk/propane_tank001a.mdl",
"models/props_phx/ball.mdl",
"models/props_phx/oildrum001.mdl",
"models/props_phx/facepunch_logo.mdl",
"models/props_phx/facepunch_barrel.mdl",
"models/props_phx/cannonball.mdl",
"models/props_phx/torpedo.mdl",
"models/props/cs_inferno/bell_large.mdl",
"models/props/cs_inferno/bell_largeB.mdl",
"models/props/cs_inferno/bell_small.mdl",
"models/props/cs_inferno/bell_smallB.mdl",
"models/props_phx/huge/tower.mdl",
"models/props_phx/misc/smallcannonball.mdl",
"models/props_phx/huge/evildisc_corp.mdl",
"models/props_phx/playfield.mdl",
"models/props_phx/cannon.mdl",
"models/props_foliage/oak_tree01.mdl",
"models/props_foliage/shrub_01a.mdl",
"models/props_foliage/tree_cliff_01a.mdl",
"models/props_foliage/tree_cliff_02a.mdl",
"models/props_foliage/tree_deciduous_01a-lod.mdl",
"models/props_foliage/tree_deciduous_01a.mdl",
"models/props_foliage/tree_deciduous_02a.mdl",
"models/props_foliage/tree_deciduous_03a.mdl",
"models/props_foliage/tree_deciduous_03b.mdl",
"models/props_foliage/tree_poplar_01.mdl",
"models/props/de_nuke/coolingtank.mdl",
"models/props/de_nuke/storagetank.mdl",
"models/golf/golf.mdl",
"models/corvette/corvette.mdl",
"models/props_buildings/building_002a.mdl",
"models/props_buildings/row_corner_1_fullscale.mdl",
"models/props_buildings/row_church_fullscale.mdl",
"models/props_buildings/project_destroyedbuildings01.mdl",
"models/props_buildings/project_building03.mdl",
"models/props_buildings/project_building02.mdl",
"models/props_buildings/project_building01.mdl",
"models/props_buildings/row_res_1_fullscale.mdl",
"models/props_buildings/row_res_2_ascend_fullscale.mdl",
"models/props_buildings/watertower_001a.mdl",
"models/props_buildings/watertower_002a.mdl",
"models/props_combine/CombineTrain01a.mdl",
"models/props_combine/combine_train02a.mdl",
"models/props_combine/combine_train02b.mdl",
"models/props_trainstation/train004.mdl",
"models/props_trainstation/train003.mdl",
"models/props_trainstation/train002.mdl",
"models/props_trainstation/train001.mdl",
"models/props_trainstation/traincar_bars001.mdl",
"models/props_trainstation/traincar_bars002.mdl",
"models/props_trainstation/traincar_bars003.mdl",
"models/props_trainstation/Traintrack001c.mdl",
"models/props_trainstation/Traintrack006b.mdl",
"models/props_trainstation/Traintrack006c.mdl",
"models/props_italian/anzio_bell.mdl",
"models/props_c17/gravestone_coffinpiece001a.mdl",
"models/props_c17/gravestone_coffinpiece002a.mdl",
"models/props_explosive/explosive_butane_can.mdl",
"models/props_explosive/explosive_butane_can02.mdl",
"models/Fungi/sta_skyboxshroom2.mdl",
"models/Fungi/sta_skyboxshroom1.mdl",
"models/props_junk/flare.mdl",
"models/props_phx/huge/evildisc_corp.mdl",
"models/props_phx/huge/road_curve.mdl",
"models/props_phx/huge/road_long.mdl",
"models/props_phx/huge/road_medium.mdl",
"models/props_phx/huge/road_short.mdl",
"models/props_phx/huge/tower.mdl",
"models/hunter/blocks/cube8x8x8.mdl",
"models/hunter/blocks/cube6x6x6.mdl",
"models/hunter/blocks/cube8x8x4.mdl",
"models/hunter/blocks/cube4x6x4.mdl",
"models/hunter/blocks/cube4x4x4.mdl",
"models/hunter/blocks/cube8x8x2.mdl",
"models/props_combine/weaponstripper.mdl",
"models/props_wasteland/medbridge_strut01.mdl",
"models/props/de_nuke/clock.mdl",
"models/props/de_nuke/CoolingTower.mdl",
"models/props/de_nuke/file_cabinet1_group.mdl",
"models/props/de_nuke/fuel_cask.mdl",
"models/props_canal/generator02.mdl",
"models/props_canal/generator01.mdl",
"models/props/de_nuke/ibeams_bombsitea.mdl",
"models/props/de_nuke/ibeams_bombsitec.mdl",
"models/props/de_nuke/ibeams_ctspawna.mdl",
"models/props/de_nuke/ibeams_bombsite_d.mdl",
"models/props/de_nuke/ibeams_ctspawnc.mdl",
"models/props/de_nuke/ibeams_tspawna.mdl",
"models/props/de_nuke/ibeams_tspawnb.mdl",
"models/props/de_nuke/ibeams_tunnelb.mdl",
"models/props/de_nuke/ibeams_tunnela.mdl",
"models/props_citizen_tech/SteamEngine001a.mdl",
"models/props_citizen_tech/windmill_blade002a.mdl",
"models/props_rooftop/Dome004.mdl",
"models/props/de_nuke/ibeams_warehouseroof.mdl",
"models/props_wasteland/coolingtank01.mdl",
"models/props/de_nuke/nuklogo.mdl",
"models/props/de_nuke/pipesb_bombsite.mdl",
"models/props/de_nuke/pipesa_bombsite.mdl",
"models/props_c17/clock01.mdl",
"models/props/de_nuke/VentilationDuct02Large.mdl",
"models/props_phx/games/chess/board.mdl",
"models/props/CS_militia/fireplacechimney01.mdl",
"models/props_phx/trains/fsd-overrun2.mdl",
"models/props_phx/trains/fsd-overrun.mdl",
"models/props/CS_militia/wndw01.mdl",
"models/props/CS_militia/CoveredBridge01_Bottom.mdl",
"models/props/CS_militia/CoveredBridge01_Left.mdl",
"models/props/CS_militia/CoveredBridge01_Right.mdl",
"models/props/CS_militia/CoveredBridge01_Top.mdl",
"models/props/de_chateau/ch_staircase.mdl",
"models/props/de_piranesi/pi_apc.mdl",
"models/props/de_port/tankoil01.mdl",
"models/props/de_port/tankoil02.mdl",
"models/props/de_train/boxcar2.mdl",
"models/props/de_train/boxcar.mdl",
"models/props/de_tides/tides_brokenledge.mdl",
"models/props_industrial/oil_pipes.mdl",
"models/props_industrial/bridge.mdl",
"models/props_vehicles/apc001.mdl",
"models/props_wasteland/rockcliff_cluster03c.mdl",
"models/props_wasteland/rockcliff_cluster03a.mdl",
"models/props_wasteland/rockcliff_cluster02c.mdl",
"models/props_wasteland/rockcliff_cluster01b.mdl",
"models/props_wasteland/rockcliff_cluster02a.mdl",
"models/props_wasteland/rockcliff07e.mdlw",
"models/props_wasteland/coolingtank02.mdl",
"models/props_buildings/CollapsedBuilding01a.mdl",
"models/props_buildings/CollapsedBuilding01aWall.mdl",
"models/props_buildings/CollapsedBuilding02a.mdl",
"models/props/CS_militia/skylight_glass.mdl",
"models/Cranes/crane_frame.mdl",
"models/props_buildings/CollapsedBuilding02b.mdl",
"models/props_buildings/CollapsedBuilding02c.mdl",
"models/Cranes/crane_frame_interior.mdl",
"models/props/cs_assault/Billboard.mdl",
"models/props/de_piranesi/pi_merlon.mdl",
"models/props/de_piranesi/pi_boat.mdl",
"models/props_trainstation/train_outro_car01.mdl",
"models/Advisorpod_crash/Advisor_Pod_crash.mdl",
"models/gantry_crane/crane_beam.mdl",
"models/map12_building2/brushwood.mdl",
"models/map12_building2/ciron.mdl",
"models/map12_building2/planks3.mdl",
"models/map12_building2/planks3_lod1.mdl",
"models/map12_building2/planks2_lod1.mdl",
"models/map12_building2/planks2.mdl",
"models/map12_building2/planks1.mdl",
"models/map12_building2/ciron_lod1.mdl",
"models/map12_sawmill/beams_LOD1.mdl",
"models/map12_sawmill/beams.mdl",
"models/map12_sawmill/planks1_LOD1.mdl",
"models/map12_sawmill/planks1.mdl",
"models/mini_borealis/mini_borealis.mdl",
"models/props_docks/dock_poles_cluster.mdl",
"models/props_mining/struts_cluster03.mdl",
"models/props_mining/struts_cluster02.mdl",
"models/props_mining/struts_cluster01.mdl",
"models/props_mining/warehouse_ceiling01.mdl",
"models/seesawBridge/bridge_static_exit.mdl",
"models/seesawBridge/bridgemetal.mdl",
"models/seesawBridge/standinmainbridge.mdl",
"models/XQM/jetbody2big.mdl",
"models/XQM/jetbody2huge.mdl",
"models/XQM/jetbody2large.mdl",
"models/XQM/jetbody2.mdl",
"models/XQM/jetbody2medium.mdl",
"models/XQM/jetwing2sizable.mdl",
"models/XQM/jetwing2large.mdl",
"models/striderBusterVendor1/roofwood.mdl",
"models/striderBusterVendor1/roofwood_lod1.mdl",
"models/XQM/jetbody3.mdl",
"models/XQM/jetbody3_s2.mdl",
"models/XQM/jetbody3_s3.mdl",
"models/XQM/jetbody3_s4.mdl",
"models/XQM/jetbody3_s5.mdl",
"models/hunter/plates/plate32x32.mdl",
"models/hunter/plates/plate24x32.mdl",
"models/hunter/plates/plate24x24.mdl",
"models/hunter/plates/plate16x32.mdl",
"models/hunter/plates/plate16x24.mdl",
"models/hunter/plates/plate16x16.mdl",
"models/hunter/plates/plate8x32.mdl",
"models/hunter/plates/plate4x16.mdl",
"models/hunter/plates/plate3x32.mdl",
"models/hunter/plates/plate3x24.mdl",
"models/hunter/plates/plate3x16.mdl",
"models/hunter/plates/plate4x24.mdl",
"models/hunter/plates/plate4x32.mdl",
"models/hunter/plates/plate5x24.mdl",
"models/hunter/plates/plate5x16.mdl",
"models/hunter/plates/plate6x16.mdl",
"models/hunter/plates/plate5x32.mdl",
"models/hunter/plates/plate7x16.mdl",
"models/hunter/plates/plate6x32.mdl",
"models/hunter/plates/plate6x24.mdl",
"models/hunter/plates/plate8x24.mdl",
"models/hunter/plates/plate8x16.mdl",
"models/hunter/plates/plate7x32.mdl",
"models/hunter/plates/plate7x24.mdl",
"models/env/misc/bank_atm/bank_atm.mdl",
"models/env/furniture/ensuite1_toilet/ensuite1_toilet.mdl",
"models/props_buildings/watertower_001c.mdl",
"models/props_buildings/short_building001a.mdl",
"models/props_buildings/row_res_2_fullscale.mdl",
"models/props_buildings/project_building03_skybox.mdl",
"models/props_buildings/project_building02_skybox.mdl",
"models/props_buildings/project_building01_skybox.mdl",
"models/props_buildings/factory_skybox001a.mdl",
"models/props_rooftop/end_parliament_dome.mdl",
"models/hunter/plates/plate075x24.mdl",
"models/hunter/plates/plate075x32.mdl",
"models/hunter/plates/plate1x16.mdl",
"models/hunter/plates/plate1x24.mdl",
"models/hunter/plates/plate2x32.mdl",
"models/hunter/plates/plate2x24.mdl",
"models/hunter/plates/plate2x16.mdl",
"models/hunter/plates/plate1x32.mdl",
"models/hunter/plates/plate075x16.mdl",
"models/hunter/plates/plate025x32.mdl",
"models/props_c17/column02a.mdl",
"models/props_combine/prison01.mdl",
"models/props_combine/prison01b.mdl",
"models/props_combine/prison01c.mdl",
"models/props_combine/breen_tube.mdl",
"models/props_canal/canal_bridge02.mdl",
"models/props_canal/canal_bridge03c.mdl",
"models/props_wasteland/bridge_middle.mdl",
"models/props_wasteland/bridge_side01-other.mdl",
"models/props_wasteland/bridge_railing.mdl",
"models/props_wasteland/bridge_side01.mdl",
"models/props_wasteland/bridge_side02.mdl",
"models/props_wasteland/bridge_side02-other.mdl",
"models/props_wasteland/bridge_side03-other.mdl",
"models/props_wasteland/bridge_side03.mdl",
"models/props_wasteland/medbridge_arch01.mdl",
"models/props_wasteland/medbridge_base01.mdl",
"models/seesawBridge/bridge_standin.mdl",
"models/seesawBridge/bridge_static.mdl",
"models/env/furniture/bed_naronic/bed_naronic-1st.mdl",
"models/props/CS_militia/bathroomwallhole01_tile.mdl",
"models/props/CS_militia/bathroomwallhole01_wood_broken.mdl",
"models/props/de_tides/gate_large.mdl",
"models/props_borealis/mooring_cleat01.mdl",
"models/env/furniture/bed_naronic/bed_naronic_1st.mdl",
"models/env/furniture/ensuite1_sink/ensuite1_sink.mdl",
"models/env/furniture/square_sink/sink_double.mdl",
"models/env/furniture/showerbase/showerbase.mdl",
"models/env/furniture/bed_secondclass/beddouble_group.mdl",
"models/props/de_inferno/infsteps01.mdl",
"models/props/de_tides/tides_sign_C.mdl",
"models/props/CS_militia/tv_console.mdl",
"models/props/CS_militia/fireplace01.mdl",
"models/props/de_nuke/catwalk_support_b.mdl",
"models/props/CS_militia/silo_01.mdl",
"models/props/de_nuke/containmentbuilding.mdl",
"models/props/cs_office/Light_ceiling.mdl",
"models/props/de_nuke/car_nuke_glass.mdl",
"models/props_lab/HEV_case.mdl",
"models/props_canal/refinery_05.mdl",
"models/props/CS_militia/roofholeboards.mdl",
"models/props/CS_militia/roofholeboards_p1.mdl",
"models/props/CS_militia/gun_cabinet_glass.mdl",
"models/props/CS_militia/militiawindow02_breakable.mdl",
"models/props/CS_militia/2x4walls01.mdl",
"models/props/CS_militia/bunkbed2.mdl",
"models/props/CS_militia/stove01.mdl",
"models/props/CS_militia/couch.mdl",
"models/props/CS_militia/bunkbed.mdl",
"models/props/CS_militia/wallconcretehole.mdl",
"models/props/CS_militia/furnace01.mdl",
"models/props/cs_italy/it_wndx1open.mdl",
"models/props_building_details/Storefront_Template001a_Bars.mdl",
"models/props/cs_assault/TicketMachine.mdl",
"models/props/de_inferno/de_inferno_boulder_03.mdl",
"models/props/de_inferno/WindowBreakable_02.mdl",
"models/props/de_inferno/WindowBreakable.mdl",
"models/props/de_inferno/logpile.mdl",
"models/props/de_inferno/inftowertop.mdl",
"models/props/de_inferno/brickpillarb.mdl",
"models/props/de_prodigy/wall_console1.mdl",
"models/props/de_prodigy/wall_console2.mdl",
"models/props/de_prodigy/wall_console3.mdl",
"models/props/de_tides/menu_stand.mdl",
"models/props/de_tides/gate_low.mdl",
"models/props/de_train/train_wheels.mdl",
"models/props/de_train/BiohazardTank.mdl",
"models/props/de_train/BiohazardTank_DM_01.mdl",
"models/props/de_train/tanker.mdl",
"models/props/de_train/RailRoadTracks256.mdl",
"models/props/de_train/RailRoadTracks128.mdl",
"models/props/de_train/FlatCar.mdl",
"models/props/de_train/diesel.mdl",
"models/props_rooftop/rooftop_Set01b.mdl",
"models/props_rooftop/dome_copper.mdl",
"models/props_rooftop/dome_terminal_02.mdl",
"models/props_rooftop/large_parliament_dome.mdl",
"models/props_rooftop/parliament_dome_destroyed_exterior.mdl",
"models/props_rooftop/parliament_dome_destroyed_interior.mdl",
"models/props_rooftop/small_parliament_dome.mdl",
"models/props_wasteland/cargo_container01.mdl",
"models/props_wasteland/rockcliff_cluster01a.mdl",
"models/props_wasteland/rockcliff07e.mdl",
"models/props_junk/TrashDumpster02.mdl",
"models/props_canal/canal_bridge04.mdl",
"models/props_junk/terracotta01.mdl",
"models/props_interiors/VendingMachineSoda01a.mdl",
"models/props_wasteland/cargo_container01c.mdl",
"models/props_wasteland/cargo_container01b.mdl",
"models/props_wasteland/depot.mdl",
"models/props_c17/gravestone_cross001a.mdl",
"models/props_c17/gravestone_cross001b.mdl",
"models/props_docks/dock01_cleat01a.mdl",
"models/props_c17/gravestone003a.mdl",
"models/props_combine/CombineInnerwallCluster1024_001a.mdl",
"models/props_combine/CombineInnerwallCluster1024_002a.mdl",
"models/props_combine/CombineInnerwallCluster1024_003a.mdl"
}

local maxwidth = 300
local maxheight = 300
local maxlength = 300

local elastic = constraint.Elastic
function constraint.Elastic(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly)
	width = math.Clamp(width,.1,200)
	return elastic(Ent1, Ent2, Bone1, Bone2, LPos1, LPos2, constant, damping, rdamping, material, width, stretchonly)
end

local class
function GM:CanTool( ply, trace, mode )
	if trace.Entity:GetOwn() != ply and !ply:IsBuddy(trace.Entity:GetOwn()) and !ply:IsAdmin() then ply:SendNotify("This is not your prop","NOTIFY_ERROR",4)  return false end
	if table.HasValue(NaughtyTools,mode) then ply:SendNotify("You can not use that tool","NOTIFY_ERROR",4) return false end
	class = trace.Entity:GetClass()
	if (class == "prop_vehicle_jeep" or class == "sign") and ply:IsAdmin() then return true end
	if !table.HasValue(cantool,class) then return false end
	if trace.Entity:GetOwn() != ply and !ply:IsBuddy(trace.Entity:GetOwn()) and !ply:IsAdmin() then ply:SendNotify("This is not your prop","NOTIFY_ERROR",4)  return false end
	
	if(mode == "button")then return table.HasValue(buttons,ply:GetInfo("button_model")) end
	
	return self.BaseClass:CanTool(ply,trace,mode)
end 

function GM:PlayerSpawnProp( ply, model )
	if !self.BaseClass:PlayerSpawnProp( ply, model ) then return false end
	if(ply:InVehicle())then return false end
	
	local realpropcost = PROP_COST
	if ply:IsVIP() then
		realpropcost = realpropcost *0.5
	end
	
	print(realpropcost)
	if ply:GetMoney() < realpropcost then ply:SendNotify("You can not afford this","NOTIFY_ERROR",3) return false end
	
	if(table.HasValue(NaugtyProps,string.Replace(model,[[\]],[[]])))then return false end	

	ply:AddMoney(realpropcost*-1)
	return true
end

function GM:PlayerSpawnedProp(ply, model, ent)
	local size = ent:OBBMaxs() - ent:OBBMins()
	if(size.x > maxwidth or size.y > maxlength or size.z > maxheight)then
		--filex.Append("largeprops.txt",model)
		ent:Remove()
		local realpropcost = PROP_COST
		if ply:IsVIP() then
			realpropcost = realpropcost *0.5
		end
		ply:AddMoney(realpropcost)
	
	end
	ent:SetNWInt("Health",MAX_PROP_HEALTH)
	ply:AddCount( "props", ent )
end

function GM:PlayerSpawnEffect(ply, model)
	return false
end 

local meta = FindMetaTable("Player")
local plyaddclean = meta.AddCleanup
function meta:AddCleanup(cat,ent)
	if(cat == "cameras" or cat == "lamps" or cat == "buttons" or cat == "lights")then
		self:GiveObject(ent)
	end
	plyaddclean(self,cat,ent)
end 

concommand.Add("rp_makebuddy",function(pl,cmd,args)
	if !args[1] then return end
	pl.Buddies = pl.Buddies || {}
	if pl.Buddies[args[1]] then
		pl.Buddies[args[1]] = nil
	else
		pl.Buddies[args[1]] = 1
	end
end)