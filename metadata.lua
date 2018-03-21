return PlaceObj('ModDef', {
	'title', "The Red Sandbox",
	'description', 'Adds Disaster control workshifts for electricity and heat providers.\r\nAdds advanced researches at 2000 costs for try to breakthrough.\r\nBreakthrough will be randomly chosen between a list.\r\nIf a breakthrough was already discovered - you will receive following:\r\n- 2.5% less food consumption for biotech\r\n- 5% automated performance bonus for robotics\r\n- engineering grants researched "Superconducting Computing" and increases research output from surplus energy\r\n- @todo: physics, at this moment receives 5% funding\r\n- 5% funding for social.\r\nThe more you\'ve discovered in category - the less is the chance to discover new.\r\nThis sandbox mode allows you to have all non-mystery breakthroughs in game so you can research all.',
	'tags', "research, breakthrough",
	'image', "Images/redbox.tga",
	'id', "RSB",
	'steam_id', "1334868594",
	'author', "Vo1",
	'version', 283,
	'lua_revision', 228003,
	'code', {
		"Code/Breakthrough.lua",
		"Code/Logging.lua",
		"Code/RSBDisasterControl.lua",
		"Code/TechMap.lua",
	},
	'saved', 1521590877,
})