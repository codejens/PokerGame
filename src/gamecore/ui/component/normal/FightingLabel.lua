-----------------------------------------------------------------------------
-- 战斗力组件
-- @author liubo
-- @release 1
-----------------------------------------------------------------------------

--!class FightingLabel
FightingLabel = simple_class(GUIWidget)

--- 创建函数
-- @param text 文本内容，可选
-- @param bg_path 背景路径，可选
-- @param fnt_path FNT文件路径，可选
function FightingLabel:create(text, bg_path, fnt_path)
	if not text then
		text = ""
	end
	if not bg_path then
		bg_path = _PATH_MAIN_PANEL_FIGHTING_BG
	end
	if not fnt_path then
		fnt_path = _PATH_MAIN_PANEL_FIGHTING_FNT
	end
	local fl = FightingLabel(ccui.Widget:create())
	fl:init(text, bg_path, fnt_path)
	return fl
end

--- 构造函数
-- @param text  文本内容
-- @param bg_path 背景路径
-- @param fnt_path FNT文件路径
function FightingLabel:__init(view)

end

--- 初始化
-- @param text  文本内容
-- @param bg_path 背景路径
-- @param fnt_path FNT文件路径
function FightingLabel:init(text, bg_path, fnt_path)	
	self.bg = GUIImg:create(bg_path)
	self.bmfont = GUIBMFont:create(text, fnt_path)
	self:setBgAnchorPoint(0, 0.5)
	self:setBMFontAnchorPoint(0, 0.5)
	self:setBMFontPosition(60, 16)
	self.bg:addChild(self.bmfont)
	self:addChild(self.bg)
end

--- 设置战斗力
-- @param value 战斗力值
function FightingLabel:setString(value)
	self.bmfont:setString(value)
end

--- 设置战斗力字体
-- @param filename 战斗力字体
function FightingLabel:setFntFile(filename)
	self.bmfont:setFntFile(filename)
end

--- 设置战斗力位置
-- @param pos_x x轴坐标
-- @param pos_y y轴坐标
function FightingLabel:setBMFontPosition(pos_x, pos_y)
	self.bmfont:setPosition(pos_x, pos_y)
end

--- 设置战斗力锚点
-- @param point_x
-- @param point_y
function FightingLabel:setBMFontAnchorPoint(point_x, point_y)
	self.bmfont:setAnchorPoint(point_x, point_y)
end

--- 设置背景位置
-- @param pos_x x轴坐标
-- @param pos_y y轴坐标
function FightingLabel:setBgPosition(pos_x, pos_y)
	self.bg:setPosition(pos_x, pos_y)
end

--- 设置背景锚点
-- @param point_x
-- @param point_y
function FightingLabel:setBgAnchorPoint(point_x, point_y)
	self.bg:setAnchorPoint(point_x, point_y)
end