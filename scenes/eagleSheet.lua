local eagleSheet = {}

local flying_eagle_options = {
	frames = {
		{ x=1, y=7, width=146, height=112 },
		{ x=154, y=7, width=136, height=112 },
		{ x=298, y=7, width=94, height=112 },
        { x=415, y=7, width=77, height=112 },
		{ x=499, y=7, width=65, height=112 },
		{ x=565, y=7, width=102, height=112 },
		{ x=672, y=7, width=84, height=112 },
        { x=758, y=7, width=111, height=112 },
        { x=872, y=7, width=128, height=112 }
    },
    sheetContentWidth = 1000,
    sheetContentHeight = 120
}

eagleSheet.flying_eagle_options = graphics.newImageSheet( "/images/eagle.png", flying_eagle_options)

eagleSheet.sequences_eagle = {
    {
        name = "fly",
        start = 1,
        count = 9,
        time = 650,
        loopCount = 0,
		loopDirection = "forward",
		sheet = eagleSheet.flying_eagle_options
	},
}

eagleSheet.shape = { -48,-26, 40,-16, 54,16, 36,40, -28,36, -62,10 }

function eagleSheet:getFlyingSheet()
    return self.flying_eagle_options;
end

function eagleSheet:getSequences()
    return self.sequences_eagle;
end

function eagleSheet:getShape()
	return self.shape;
end

return eagleSheet