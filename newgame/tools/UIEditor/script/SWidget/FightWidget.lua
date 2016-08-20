--FightWidget.lua
--战斗力控件

super_class.FightWidget()

local p_x = 108
local p_y = 23

local function get_num_img(num)
	return string.format("ui/fonteffect/0%s.png", tostring(num))
end

local function get_num_len(num)
    local a = num
    local count = 0
    while a >= 10 do
        count = count + 1
        a = a/10
    end
    return count+1
end

--构造函数
function FightWidget:__init(parent, x, y, fightNum, iscenter, zOrder)
	if not parent then
		return nil
	end
    if not zOrder then zOrder = 1 end
    self.view_scale = 1
	self.parent     = parent
	self.x          = x or 0
	self.y          = y or 0
	self.fight_num  = fightNum or 0
    self.iscenter   = iscenter
    self.view_width = 186+get_num_len(self.fight_num/100)*28

	self.view = CCBasePanel:panelWithFile(self.x, self.y, -1, -1, "sui/mainUI/fightGrp.png", 125, 35, 50, 35, 125, 35, 50, 35)
    self.view:setSize(self.view_width, 71)
	self.parent:addChild(self.view, zOrder)

    self.fightValueLabel = ImageNumberEx:create(self.fight_num, get_num_img, 28)
    self.fightValueLabel.view:setPosition(self.x+p_x, self.y+p_y)
    self.parent:addChild(self.fightValueLabel.view, zOrder+1)

    if self.iscenter == true then
        self.view:setAnchorPoint(0.5, 0)
        self.fightValueLabel.view:setPosition((self.x-self.view_width/2)+p_x, self.y+p_y)
    end
end

function FightWidget:setNumber(num)
    self.fight_num  = num
    self.view_width = 186+get_num_len(self.fight_num/100)*28
	self.fightValueLabel:set_number(self.fight_num)
    self.view:setSize(self.view_width, 71)
    if self.iscenter == true then
        self.fightValueLabel.view:setPosition((self.x-self.view_width/2*self.view_scale)+p_x*self.view_scale, self.y+p_y*self.view_scale)
    end
end

function FightWidget:setPosition(x, y)
    self.x = x
    self.y = y
	self.view:setPosition(self.x, self.y)
    if self.iscenter == true then
        self.fightValueLabel.view:setPosition((self.x-self.view_width/2*self.view_scale)+p_x*self.view_scale, self.y+p_y*self.view_scale)
    else
        self.fightValueLabel.view:setPosition(self.x+p_x*self.view_scale, self.y+p_y*self.view_scale)
    end
end

function FightWidget:setScale(scale)
    self.view_scale = scale
    self.view:setScale(self.view_scale)
    self.fightValueLabel.view:setScale(self.view_scale)
    if self.iscenter == true then
        self.fightValueLabel.view:setPosition((self.x-self.view_width/2*self.view_scale)+p_x*self.view_scale, self.y+p_y*self.view_scale)
    else
        self.fightValueLabel.view:setPosition(self.x+p_x*self.view_scale, self.y+p_y*self.view_scale)
    end
end

function FightWidget:setIsVisible(bool)
	self.view:setIsVisible(bool)
    self.fightValueLabel.view:setIsVisible(bool)
end