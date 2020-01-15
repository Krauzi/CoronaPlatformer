local barbarianSheet = {}

local running_barbarian_options = {
	frames = {
		{ x=1, y=0, width=127, height=183 },
		{ x=131, y=0, width=128, height=183 },
		{ x=263, y=0, width=164, height=183 },
        { x=433, y=0, width=155, height=183 },
		{ x=591, y=0, width=142, height=183 },
		{ x=738, y=0, width=144, height=183 },
		{ x=885, y=0, width=138, height=183 },
		{ x=1026, y=0, width=144, height=183 }
    },
    sheetContentWidth = 1200,
    sheetContentHeight = 184
}

barbarianSheet.sheet_running_barbarian = graphics.newImageSheet( "/images/barbarian-running.png", running_barbarian_options )

local death_barbarian_options = {
	frames = {
		{ x=2, y=1, width=161, height=183 },
		{ x=165, y=1, width=187, height=183 },
		{ x=355, y=1, width=143, height=183 },
        { x=502, y=1, width=167, height=183 },
        { x=678, y=1, width=185, height=183 },
		{ x=867, y=1, width=197, height=183 }
	},
    sheetContentWidth = 1158,
    sheetContentHeight = 184
}

barbarianSheet.sheet_death_barbarian = graphics.newImageSheet( "/images/barbarian-death.png", death_barbarian_options )

barbarianSheet.sequences_barbarian = {
    {
        name = "run",
        start = 1,
        count = 8,
        time = 600,
        loopCount = 0,
		loopDirection = "forward",
		sheet = barbarianSheet.sheet_running_barbarian
	},
	{
		name = "death",
        start = 1,
        count = 6,
		time = 700,
		loopCount = 1,
		loopDirection = "forward",
		sheet = barbarianSheet.sheet_death_barbarian
	}
}

barbarianSheet.shape = { -56,-48, -6,-64, 40,-12, 42,92, -28,92, -62,20, -42,-24 }

function barbarianSheet:getRunningSheet()
    return self.sheet_running_barbarian;
end

function barbarianSheet:getSequences()
    return self.sequences_barbarian;
end

function barbarianSheet:getShape()
	return self.shape;
end

return barbarianSheet