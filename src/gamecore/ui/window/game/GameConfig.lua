GameConfig = {}

function GameConfig:init()
	self.QUICK_GAME = 1
	self.FREE_GAME = 2
	self.SPORT_GAME = 3
	self.POS = {
	[1] = { 227, 522 },
	[2] = { 713, 522 },
	[3] = { 842, 325 },
	[4] = { 713, 167 },
	[5] = { 468, 167 },
	[6] = { 227, 167 },
	[7] = { 80,  325 },
	}
end

GameConfig:init()