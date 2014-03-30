// Add rules here
local Rules = {
"1. General Rules", 
	{
"1a. Respect all admins/super admins/developers",
"1b. Do not crash the server.", 
"1c. Do not flame. (offend another player)",
"1d. No racism.(Check Definitions Tab for any definition related question!)",
"1e. Breaking New Life Rule.  You may not go back to where you just died unless",
"you are returning to your house/property, drug plants, and vehicle or you are an",
"admin and are ACTIVELY doing admin related activities. Returning for no reason",
"after you were killed will result in a ban.",
"1f. No random Death Matching (DMing) or killing for another persons weapon.",
"1g. No locking a player into a room via a rented door.",
"1h. Abusing any profession could result in a blacklist from that profession.",
"1i. Do not sell a profession or hold a profession for a friend, use it or lose it.",
"1j. Do not spam in chat, on the mic, or talk normally using the /advert command.",
"1k. Refrain from talking in CAPS in OOC.",
"1l. Any exploitation of the map, props, server, and/or anything that falls within",
"the realm of exploitation will result in a ban. Includes cheating. (examples Speed",
"Hacks, Aimbotting, Xray, ESP/Radar/Wall Hacks, and anything which gives you an",
"advantage not incorporated into the RP.)",
"1m. Use common sense. If something you do is questionable, ask an admin. If you",
"do not, then common sense applies.",
"1n. If you build any door, or structure that acts like one, a public button MUST",
"placed ON the entrance of the door, easily in view",
"1o. Lying about something can increase your ban length.",
"1p. DO NOT TAKE MATTERS INTO YOUR OWN HANDS, contact an admin or collect evidence",
"which you can then post on the forums in the ban section www.darklandservers.com",
"1q. Signs are considered props. All building rules apply to signs. Signs are to",
"be used in a proper RP manner, anything else, is bannable."
	},
"",
"2. Prop Rules", 
	{
"2a. Do not prop kill, prop block, prop surf, prop trap, prop push, prop spam, or",
"spawning exploding props in any shape or form. This includes making any prop",
"which can, will, or will function as a machine to prop trap/kill/push/etc.",
"2b. No using props or signs as shields during a raid, or any other time.",
	},
"",
"3. Mayor Rules", 
	{
"3a. Only issue valid warrants. Do not abuse. If you have to think twice, ask an",
"admin for advice before demoting or issuing warrants.",
"3b. Mayors may not demote a police officer if they are trying to get drug labs,",
"including the mayors.",
"3c. Mayors cannot be corrupt, meaning they cannot work with gangsters and mobboss",
"3d. Mayors are allowed to have drug labs, but they cannot demote police who are",
"trying to destroy them.",
"3e. Mayors are not allowed to make up rules of their own. They are allowed to call",
"a lockdown via the /broadcast command, but this only applies to the upper levels",
"of the Nexus, the lobby is always open to everyone.",
	},
"",
"4. Police (Civil Protection - CP) Rules", 
	{
"4a. You must have valid reason to request a warrant from the Mayor. Just because",
"you want in somewhere, doesnt give you the right to get a warrant.",
"4b. Only Police are allowed to protect the Mayor.",
"4c. Do not steal others property when in their homes serving a warrant.",
"4d. Can kill Mob Boss and Gangsters only for valid RP reasons when they are",
"protecting the Mayor when there is a hit issued or during lockdowns.",
"4e. Do not abuse radio/warrant commands, and/or to break NLR.",
	},
"",
"5. Mob Boss/Gangster Rules", 
	{
"5a. Can kill Police and Mayor only for valid RP reasons.", 
"5b. Only Gangsters/Mob Boss are allowed to raid a persons house/property. Any other class",
"which is raiding will be banned."
	},
"",
"6. Rules of Building (Plat and/or Builder class)", 
	{
"6a. Do not build to get on to the roofs, build on the roofs, or anything that will",
"allow yourself, or others to get on the roofs in any way.",
"6b. Do not build ANYTHING which prevents Police from doing their job, or gangsters from",
"raiding. This includes elevated houses or floating bases, ",
"doors with more than 3 moving parts controlled by buttons, and ANYTHING else which could prevent police from properly",
"serving a warrant, or a gangster raiding. Public building of bases is not allowed. There is",
"plenty of ready available real estate you can purchase within the map via a buyable door",
"then use the door lock mod to protect your house.",
"6c. Building any base which has tunnels that make you duck in any way, building",
"floating props of any kind, firing slits which are too small (1 foot is minimum), or any other",
"method to give a distinct unfair advantage. Ask the admins before or right after you build it for",
"yes/no answer",
"or any other reason. Use them to decorate, not to lag.",
"6d. Do not build in the middle of the road to obstruct normal traffic flow.", 
"6e. Do not build long mazes or complex(use common sense and is subject to an admin's discretion)",
"custom bases inside your house. If you have a base which is questionable by any ",
"admin, it may be removed without letting you know.",
"6f. If you build any prop or structure that shuts, not allowing people through easily",
"a public button MUST be placed ON the entrance of the door/wall, EASILY in view",
"6g. Do not spam props or signs. Do not block signs or cameras with props.",
"6h. No doors/props which solely requires a grav gun to get in correctly.",
"6i. No building in public areas, unless it is decorations.",
"6j. Do not build any prop which allows you to avoid fall damage",
"6k. You must be able to see the tumbler (the lock) for a combination lock",
	},
}

function CreateRulesTab()
	local RulesList = vgui.Create( "DPanelList" );
	RulesList:EnableVerticalScrollbar();
	RulesList:SetSpacing( 1 );
	RulesList:SetPadding( 7 );

	local RuleNumberOffset = 0;
	for RuleKey, RuleValue in pairs( Rules ) do
		local RuleNumber = RuleKey + RuleNumberOffset;

		if( type( RuleValue ) == "table" ) then
			// Sub rule block
			local SubRuleNumberOffset = 0;
			for SubRuleKey, SubRuleValue in pairs( RuleValue ) do
				// Sub rule
				local SubRuleNumber = SubRuleKey + SubRuleNumberOffset;

				local Text = SubRuleValue;
				if( SubRuleValue[1] == "*" && SubRuleValue[2] == ")"  ) then
					Text = "     " .. RuleNumber .. string.char( SubRuleNumber + 96 ) .. ". " .. SubRuleValue;
				else
					SubRuleNumberOffset = SubRuleNumberOffset - 1;
				end
				local NewRule = Label( Text );

				NewRule:SetWrap( true );
				RulesList:AddItem( NewRule );
			end
		else
			// Main rule
			local Text = RuleValue;
			if( RuleValue[1] == "*" && RuleValue[2] == ")" ) then
				Text = RuleNumber .. ". " .. RuleValue;
			else
				RuleNumberOffset = RuleNumberOffset - 1;
			end
			local NewRule = Label( Text );

			NewRule:SetWrap( true );
			RulesList:AddItem( NewRule );
		end
	end

	Panels["Menu"].Sheet:AddSheet( "Server Rules", RulesList, "gui/silkicons/error" );
end
hook.Add( "OnMenusCreated", "CreateRulesTab", CreateRulesTab );
