GameConfig = {}

function GameConfig:init()
	self.QUICK_GAME = 1
	self.FREE_GAME = 2
	self.SPORT_GAME = 3
	self._POS = {
	[1] = { 468, 167 },
	[2] = { 713, 522 },
	[3] = { 842, 325 },
	[4] = { 713, 167 },
	[5] = { 468, 167 },
	[6] = { 227, 167 },
	[7] = { 80,  325 },
	[8] = { 227, 522 },
	}

	self._have_pos = {5,1,3,4,6,8,7,9}
end

function GameConfig:get_pos(index)
	return self._POS[index]
end

function GameConfig:get_have_pos(index)
	return self._have_pos[index]
end

function 

GameConfig:init()