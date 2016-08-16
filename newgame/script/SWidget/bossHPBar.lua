super_class.bossHPBar()

local bloodImagePath = {
	[1] = "nopack/bossBlood/green.png", 
	[2] = "nopack/bossBlood/yellow.png",	
	[3] = "nopack/bossBlood/puple.png",	
	[4] = "nopack/bossBlood/blueBlood.png",	
	[5] = "nopack/bossBlood/red.png",	
}

local bloodBgPath = {
	[1] = "nopack/bossBlood/green01.png",
	[2] = "nopack/bossBlood/yellow01.png",
	[3] = "nopack/bossBlood/puple01.png",
	[4] = "nopack/bossBlood/blueBlood01.png",
	[5] = "nopack/bossBlood/red01.png",

}

local hp_rate = 1
local BLOOD_LAYER_NUM = 5


function bossHPBar:__init(parent, x, y, width, height)
	self.view = CCBasePanel:panelWithFile( x, y, 300, 67,"",100,100,0,0);
	parent:addChild(self.view)
	-- 血条的层数，默认五层
	self.bloodLayerNum = 5

	local name_bg = SImage:create("sui/mainUI/nameBg.png")
	name_bg:setPosition(55, 30)
	self.view:addChild(name_bg.view)

	if not width then
		self.hp_width = 116
	else
		self.hp_width = width
	end
	
	if not height then
		self.hp_height = 12
	else
		self.hp_height = height
	end

	-- self.totalBloodNum = 0
	self.maxHp = 0
	self.bloodTable = {}
	self.whiteProgressTable = {}

	self.singleLeftBlood = nil

	-- 表示当前操作的血条索引（即当前进行扣血，加血的操作的血条）
	self.curBloodIndex = 1
	self.bloodBgIndex = 1


	self.bloodBg = SImage:create("sui/mainUI/bossBloodBg.png",false)
	self.bloodBg:setPosition(30, 9)
	self.view:addChild(self.bloodBg.view)

	self:init_blood_by_num()

	local head = SImage:create("sui/mainUI/bossMonster.png")
	head:setPosition(-30,-15)
	self.bloodBg.view:addChild(head.view, 100)

	-- local size = self.bloodTable[1].view:getContentSize()
	-- printc("bossHPBar:__init", width, height ,13)

	self.minusSpeed = 4000

	self.name = SLabel:create("", 16)
	self.name:setPosition(50, 33)
	self.bloodBg:addChild(self.name.view)

	-- 血条数
	self.bloodNum = SLabel:create("#cff2400X2", 22,2)
	self.bloodNum:setPosition(175, 10)
	self.bloodBg:addChild(self.bloodNum.view)
	return self
end

-- 设置血条层数，默认五层
function bossHPBar:setBloodLayerNum()

end

function bossHPBar:setName(name)
	self.name:setText(name)
end


function bossHPBar:set_hp(hp, maxHp, notChange)
	if not notChange then

		if hp > maxHp then
			self.maxHp = hp
			self.curHp = hp
		else
			self.maxHp = maxHp
			self.curHp = hp
		end
		-- 每一个血条都有多少血
		self.singleBlood = self.maxHp / 5
		-- TaskModel:printc("做了bossHPBar:set_hp"..tostring(self.maxHp))
		-- 上一次剩余多少血量
		self.lastLeftBlood = self.singleBlood
	end
end

function bossHPBar:init_blood_by_num()
	for k = self.bloodLayerNum, 1, -1 do

		local whiteProgress = MUtils:create_sprite(self.bloodBg, bloodBgPath[k], 45, 17, 1)
		whiteProgress:setAnchorPoint(CCPoint(0, 0))
		self.whiteProgressTable[k] = whiteProgress

		local blood = MUtils:create_sprite(self.bloodBg, bloodImagePath[k],45,17, 1)
		-- printc("bossHPBar", self.hp_width, hp_height, 13)
		blood:setAnchorPoint(CCPoint(0, 0))
		self.bloodTable[k] = blood
	end
end

function bossHPBar:update_blood(changeHp, hp, maxHp)
	if hp > maxHp then
		return
	end
	-- 更改扣血速度
	-- if self.lastLeftBlood ~= self.singleLeftBlood then
	-- 	self.minusSpeed = math.abs(self.lastLeftBlood - self.singleLeftBlood) / 2
	-- end
	-- printc("")

	hp_rate = self:calculate_hp_rate(hp, maxHp)
	local index = self:get_handle_blood_index(hp, maxHp)

	self.bloodNum:setText(string.format('#cff2400X%d', 5-index+1))

	if self.lastLeftBlood ~= self.singleLeftBlood then
		self.minusSpeed = math.abs(self.lastLeftBlood - self.singleLeftBlood) / 20
	end

	-- printc("做了更新血sdf条",self.bloodBgIndex, index, self.lastLeftBlood, self.singleLeftBlood,self.minusSpeed, 13)


	-- 伤害在同一个血条内
	if self.bloodBgIndex == index then
		for k = 1, self.bloodBgIndex - 1 do
			if self.bloodTable[k] then
				self.bloodTable[k]:setTextureRect(CCRect(0, 0, 0, 0));
			end
		end
		if self.bloodTable[index] then
			-- printc("self.bloodTable:setTextureRect111111111", self.singleLeftBlood, 13)
			-- self.bloodTable[index]:setTextureRect(CCRect(0, 0,self.singleLeftBlood, self.hp_height));
			
			if self.hp_width * hp_rate > 0 then
				self.bloodTable[index]:setTextureRect(CCRect(0, 0,self.hp_width * hp_rate, self.hp_height));
			else
				self.bloodTable[index]:setTextureRect(CCRect(0, 0,0, self.hp_height));
			end
		end
	else
		-- 伤害在下一个血条内
		-- printc("222222222222222222", index, self.bloodBgIndex, 13)
		if self.bloodBgIndex < index then
			if index >= BLOOD_LAYER_NUM then
				index = BLOOD_LAYER_NUM
			end
			for k = 1, index - 1 do
				if self.bloodTable[k] then
					self.bloodTable[k]:setTextureRect(CCRect(0, 0, 0, 0));
				end
			end
			if self.bloodTable[index] then
				-- printc("self.bloodTable:setTextureRect2222222", self.singleLeftBlood, 13)
				if self.hp_width * hp_rate > 0 then
					self.bloodTable[index]:setTextureRect(CCRect(0, 0, self.hp_width * hp_rate, self.hp_height));
				else
					self.bloodTable[index]:setTextureRect(CCRect(0, 0, 0, self.hp_height));
				end
			end
		else

		end
	end

	--先注释掉的，之后要打开
	local function cb()
		-- printc("self.bloodBgIndex===>>>", self.bloodBgIndex, 14)
		if self.bloodBgIndex >= 6 or self.bloodBgIndex <= 0 then
			if self.bloodBgIndex >= 6 then
				self.bloodBgIndex = 5 
				self.curBloodIndex = 5
			end
			if self.bloodBgIndex <=0 then
				self.bloodBgIndex = 1
				self.curBloodIndex = 1
			end
			self.setBloodTimer:stop()
			self.setBloodTimer = nil
			return
		end
		-- TaskModel:printc("-=-=-=-=-"..tostring(self.bloodBgIndex).."  "..tostring(self.curBloodIndex))

		-- 如果最终到达的血条和当前处理的血条是同一个索引，则直接减血条
		if self.bloodBgIndex == self.curBloodIndex then
			if self.lastLeftBlood < self.singleLeftBlood then
				self.lastLeftBlood = self.singleLeftBlood
			end
			self.lastLeftBlood = self.lastLeftBlood - self.minusSpeed
			self.whiteLeftBlood = self.lastLeftBlood
			-- printc("做了直接赋值给self,.whiteLeftBlood",self.whiteProgressTable[self.bloodBgIndex], self.bloodBgIndex, self.hp_width,self.lastLeftBlood, self.whiteLeftBlood, self.singleLeftBlood, self.minusSpeed, self.singleBlood,self.hp_height,14)
			
			if self.hp_width * (self.whiteLeftBlood / self.singleBlood) > 0 then
				self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0, self.hp_width * (self.whiteLeftBlood / self.singleBlood), self.hp_height));
			else
				self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0, 0, self.hp_height));
			end

		else
			-- 如果最终的血条和当前处理的血条不是同一个索引，需要先判断之前的是否已经扣完，
			-- 如果已经self.whiteLeftBlood > 0，则继续扣，如果 < 0则重置
			self.lastLeftBlood = self.lastLeftBlood - self.minusSpeed * 3
			self.whiteLeftBlood = self.lastLeftBlood
			-- printc("更改了self.whiteLeftBlood值 ", self.whiteLeftBlood, 13)
			if self.whiteLeftBlood > 0 then
				self.lastLeftBlood = self.lastLeftBlood - self.minusSpeed * 2
				self.whiteLeftBlood = self.lastLeftBlood
			else
				self.lastLeftBlood = self.singleBlood
				self.lastLeftBlood = self.lastLeftBlood - self.minusSpeed

				-- printc("做了这里~~~~~",13)
				if self.whiteLeftBlood <= 5 then
					
					self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0,0, self.hp_height));
					
					self.bloodBgIndex = self.bloodBgIndex + 1
					self.whiteLeftBlood = self.singleBlood
				else

				end
			end
		end

		-- printc("判断条件", self.whiteLeftBlood, self.singleLeftBlood, self.lastLeftBlood, self.bloodBgIndex, self.curBloodIndex, self.singleBlood, 8)
		if self.whiteLeftBlood <= self.singleLeftBlood and self.bloodBgIndex == self.curBloodIndex then
			-- printc("停止了背景浅色血条移动", self.whiteLeftBlood, self.singleLeftBlood, self.lastLeftBlood, self.bloodBgIndex, self.curBloodIndex, 3)
			self.whiteLeftBlood = self.singleLeftBlood

			-- if self.bloodBgIndex < index then
	 			if self.whiteProgressTable[self.bloodBgIndex] then
					-- self.whiteProgressTable[index]:setTextureRect(CCRect(0, 0,self.hp_width * hp_rate, self.hp_height));
					if self.hp_width * (self.whiteLeftBlood / self.singleBlood) > 0 then
						self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0, self.hp_width * (self.whiteLeftBlood / self.singleBlood), self.hp_height));
					else
						self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0, 0, self.hp_height));
					end
				end
			-- end

			self.setBloodTimer:stop()
			self.setBloodTimer = nil
			return 
		end

		-- print("self.bloodBgIndex", self.bloodBgIndex, self.curBloodIndex)

		if self.bloodBgIndex == self.curBloodIndex then
			-- for k = 1, self.bloodBgIndex - 1 do
			-- 	if self.whiteProgressTable[k] then
			-- 		self.whiteProgressTable[k]:setTextureRect(CCRect(0, 0, 0, 0));
			-- 		-- self.whiteProgressTable[k]:setTextureRect(CCRect(0, 0, 0, 0))
			-- 	end
			-- end
			-- printc("11111111111111", self.curBloodIndex, self.whiteLeftBlood, self.bloodBgIndex,13)
			if self.whiteProgressTable[self.bloodBgIndex] then
				if self.whiteLeftBlood <= 0 then
					self.whiteLeftBlood = 0
				end

				if self.hp_width * (self.whiteLeftBlood / self.singleBlood) > 0 then
					self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0, self.hp_width * (self.whiteLeftBlood / self.singleBlood), self.hp_height));
				else
					self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0, 0, self.hp_height));
				end
				-- self.whiteProgressTable[self.curBloodIndex]:setTextureRect(CCRect(0, 0,self.whiteLeftBlood, self.hp_height));
			end
		else
			-- printc("3333333333333333", self.bloodBgIndex, self.curBloodIndex, self.whiteLeftBlood, 13)
			if self.bloodBgIndex < self.curBloodIndex then
				if self.whiteProgressTable[self.bloodBgIndex] then
					if self.whiteLeftBlood <= 0 then
						self.whiteLeftBlood = 0
					end
					
					if self.hp_width * (self.whiteLeftBlood / self.singleBlood) > 0 then
						self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0,self.hp_width * (self.whiteLeftBlood / self.singleBlood), self.hp_height));
					else
						self.whiteProgressTable[self.bloodBgIndex]:setTextureRect(CCRect(0, 0, 0, self.hp_height));
					end

					-- if self.whiteLeftBlood <= 5 then
					-- 	self.whiteProgressTable[index]:setTextureRect(CCRect(0, 0,0, self.hp_height));
					-- 	self.bloodBgIndex = self.bloodBgIndex + 1
					-- 	self.whiteLeftBlood = self.singleBlood
					-- end
				end
			end
		end
	end

	-- xprint("=-=-=-=-=-=-=-=-=-=-")

	-- printc("self.setBloodTimer===>>>> ", self.setBloodTimer, 3)
	if not self.setBloodTimer then
		self.setBloodTimer = timer()
		self.setBloodTimer:start(0.02, cb)
	end

end

-- 计算这一下砍下去，耗血的那个最终进度条
function bossHPBar:get_handle_blood_index(hp, maxHp)
	-- printc("self.singleBlood", self.singleBlood, 14)
	-- local index = 0
	-- if hp >= maxHp then
	-- 	index = BLOOD_LAYER_NUM
	-- 	self.singleLeftBlood = 0
	-- else

	local maxhp2= 0
	local hp2 = 0
	if hp > maxHp then
		maxhp2 = hp
		hp2 = hp
	else
		maxhp2 = maxHp
		hp2 = hp
	end

	-- 获得当前操作的血条的索引
		local index = math.abs(math.floor((maxhp2 - hp2) / self.singleBlood)) + 1
		self.singleLeftBlood = self.singleBlood - ((maxhp2 - hp2) - self.singleBlood * (index - 1))
		-- printc(" bossHPBar:get_handle_blood_index=======>>>>", hp2, maxhp2, self.singleBlood, self.curBloodIndex, self.singleLeftBlood, index, 13)

	-- end

	-- if hp <= 0 then
	-- 	self.singleLeftBlood = 0
	-- 	return BLOOD_LAYER_NUM
	-- end

	return index, self.singleLeftBlood
end

function bossHPBar:calculate_hp_rate(hp, maxHp)
	if hp <= 0 then
		self.curBloodIndex = 5
	end

	local rate = 1
	local dif = maxHp - hp

	-- 如果是第一次受攻击的情况
	if not self.singleLeftBlood then
		local count = math.floor(dif / self.singleBlood)
		-- 获得当前操作的血条的索引
		self.curBloodIndex = count + 1
		dif = dif - count * self.singleBlood
		if dif < self.singleBlood then
			rate = ( (self.singleBlood - dif) / self.singleBlood)

		end
	else
		local count = math.floor(dif / self.singleBlood)
		-- 获得当前操作的血条的索引
		self.curBloodIndex = count + 1
		dif = dif - count * self.singleBlood
		if dif < self.singleBlood then
			rate = ( (self.singleBlood - dif) / self.singleBlood)
		end
	end
	return rate
end

function bossHPBar:destroy()
	hp_rate = 1
	self.bloodTable = {}
	self.whiteProgressTable = {}
	self.singleLeftBlood = nil
	-- 表示当前操作的血条索引（即当前进行扣血，加血的操作的血条）
	self.curBloodIndex = 1
	self.bloodBgIndex = 1
end

-- 因为boss的血条是多层的，所以需要根据当前血量和最大血量去设置层数

function bossHPBar:set_hp_bar_by_value(hp, maxhp, notChange)
	if not notChange then 
		local index, leftBlood = self:get_handle_blood_index(hp, maxhp)
		self.bloodBgIndex = index
		self.lastLeftBlood = leftBlood
		-- printc("set_hp_bar_by_value====>>>>", self.bloodBgIndex, hp, maxhp,14)
		self.bloodNum:setText(string.format('#cff2400X%d', 5-index+1))

		for k = 1, 5 do
			self.bloodTable[k]:setTextureRect(CCRect(0, 0, 0,self.hp_height))
			self.whiteProgressTable[k]:setTextureRect(CCRect(0, 0, 0,self.hp_height))
		end 

		-- printc("index===leftBlood", index, leftBlood, 13)

		for k = 5, index, -1 do
			if k > index then
				if self.hp_width > 0 then
					-- print("self.bloodTable[k]",self.bloodTable[k])
					if self.bloodTable[k] then
						self.bloodTable[k]:setTextureRect(CCRect(0, 0, self.hp_width,self.hp_height))
					end
					if self.whiteProgressTable[k] then
						self.whiteProgressTable[k]:setTextureRect(CCRect(0, 0, self.hp_width,self.hp_height))
					end
				else
					if self.bloodTable[k] then
					   self.bloodTable[k]:setTextureRect(CCRect(0, 0, 0,self.hp_height))
				    end
				    if self.whiteProgressTable[k] then
					   self.whiteProgressTable[k]:setTextureRect(CCRect(0, 0, 0,self.hp_height))
				    end
				end
			else
				if self.hp_width * (leftBlood / self.singleBlood) > 0 then
					-- print("33333333333 === >>>", self.hp_width * (leftBlood / self.singleBlood))
					if self.bloodTable[k] then
						self.bloodTable[k]:setTextureRect(CCRect(0, 0, self.hp_width * (leftBlood / self.singleBlood), self.hp_height))
				    end
				    if self.whiteProgressTable[k] then
					   self.whiteProgressTable[k]:setTextureRect(CCRect(0, 0, self.hp_width * (leftBlood / self.singleBlood), self.hp_height))
				    end
				else
					if self.bloodTable[k] then
						self.bloodTable[k]:setTextureRect(CCRect(0, 0, 0, self.hp_height))
					end
					if  self.whiteProgressTable[k] then
						self.whiteProgressTable[k]:setTextureRect(CCRect(0, 0, 0, self.hp_height))
					end
					
				end
			end
		end
	end
end

function bossHPBar:setIsVisible(bool)
	self.view:setIsVisible(bool)
	if self.setBloodTimer then
		self.setBloodTimer:stop()
		self.setBloodTimer = nil
	end
end