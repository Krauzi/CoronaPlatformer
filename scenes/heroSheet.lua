local heroSheet = {}

local running_hero_options = {
	frames = {
        { x=0, y=1, width=143, height=187 },
        { x=145, y=1, width=126, height=187 },
        { x=272, y=1, width=124, height=187 },
        { x=397, y=1, width=162, height=187 },
		{ x=561, y=1, width=153, height=187 },
		{ x=717, y=1, width=126, height=187 },
		{ x=846, y=1, width=138, height=187 },
		{ x=987, y=1, width=135, height=187 }
    },
    sheetContentWidth = 1123,
    sheetContentHeight = 189
}

heroSheet.sheet_running_hero = graphics.newImageSheet( "/images/running-sprite.png", running_hero_options )

local jumping_hero_options = {
	frames = {
		{ x=1, y=1, width=130, height=187 },
		{ x=144, y=1, width=112, height=187 },
		{ x=263, y=1, width=156, height=187 },
		{ x=425, y=1, width=162, height=187 }
	},
	sheetContentWidth = 587,
	sheetContentHeight = 189
}

heroSheet.sheet_jumping_hero = graphics.newImageSheet( "/images/jump-sprite.png", jumping_hero_options )

local attack_hero_options = {
	frames = {
		{ x=58, y=12, width=120, height=204 },
		{ x=228, y=12, width=152, height=204 },
		{ x=405, y=12, width=221, height=204 },
		{ x=635, y=12, width=157, height=204 },
		{ x=802, y=12, width=118, height=204 },
		{ x=930, y=12, width=276, height=204 },
		{ x=1212, y=12, width=182, height=204 },
		{ x=1404, y=12, width=173, height=204 },
		{ x=1623, y=12, width=130, height=204 }
	},
	sheetContentWidth = 1755,
	sheetContentHeight = 217
}

heroSheet.sheet_attacking_hero = graphics.newImageSheet( "/images/attack-sprite.png", attack_hero_options)


heroSheet.sequences_hero = {
    {
        name = "run",
        start = 1,
        count = 8,
        time = 600,
        loopCount = 0,
		loopDirection = "forward",
		sheet = heroSheet.sheet_running_hero
	},
	{
        name = "jumpStart",
        frames = { 1 },
		loopCount = 0,
		sheet = heroSheet.sheet_jumping_hero
	},
	{
        name = "jumpUp",
        frames = { 2 },
		loopCount = 0,
		sheet = heroSheet.sheet_jumping_hero
	},
    {
        name = "jumpPeak",
        frames = { 3 },
		loopCount = 0,
		sheet = heroSheet.sheet_jumping_hero
	},
	{
        name = "jumpFall",
        frames = { 4 },
		loopCount = 0,
		sheet = heroSheet.sheet_jumping_hero
	},
	{
		name = "attack",
        start = 1,
        count = 9,
		time = 700,
		loopCount = 0,
		loopDirection = "forward",
		sheet = heroSheet.sheet_attacking_hero
	}
}

heroSheet.shape = { 5,-74, 52,-54, 58,20, 32,94, -16,94, -50,40, -40,-30 }

function heroSheet:getRunningSheet()
    return self.sheet_running_hero;
end

function heroSheet:getJumpingSheet()
    return self.sheet_jumping_hero;
end

function heroSheet:getAttackingSheet()
    return self.sheet_attacking_hero;
end

function heroSheet:getSequences()
    return self.sequences_hero;
end

function heroSheet:getShape()
	return self.shape;
end

return heroSheet