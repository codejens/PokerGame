-----------------------------------------------------------------------------
-- 进度条拓展组件
-- @author liubo
-- @release 2
-----------------------------------------------------------------------------

--!class ProgressExpand
ProgressExpand = simple_class(GUIWidget)

--- 创建函数
-- @param texture 进度条纹理
-- @param progress_type 类型 扇形：cc.PROGRESS_TIMER_TYPE_RADIAL 水平：cc.PROGRESS_TIMER_TYPE_BAR
-- @param is_reverse 是否反方向旋转 布尔值
-- @param value 进度值 默认0 可选
-- @param mp_x, mp_y 中点坐标 默认 （0, 0）可选
-- @param bcr_x, bcr_y 条形模式进度条非变化方向显示的比例 默认（1, 0）可选
-- @param ap_x, ap_y 进度条锚点 默认（0, 0）可选
function ProgressExpand:create(texture, progress_type, is_reverse, value, mp_x, mp_y, bcr_x, bcr_y, ap_x, ap_y)
	local pe = self(ccui.Widget:create())
	pe:init(texture, progress_type, is_reverse, value, mp_x, mp_y, bcr_x, bcr_y, ap_x, ap_y)
	return pe
end

--- 构造函数
-- @param text  文本内容
-- @param bg_path 背景路径
-- @param fnt_path FNT文件路径
function ProgressExpand:__init(view)

end

--- 初始化
-- @param texture 进度条纹理
-- @param progress_type 类型 扇形：cc.PROGRESS_TIMER_TYPE_RADIAL 水平：cc.PROGRESS_TIMER_TYPE_BAR
-- @param is_reverse 是否反方向旋转 布尔值
-- @param value 进度值 默认0 可选
-- @param mp_x, mp_y 中点坐标 默认 （0, 0）可选
-- @param bcr_x, bcr_y 条形模式进度条非变化方向显示的比例 默认（1, 0）可选
-- @param ap_x, ap_y 进度条锚点 默认（0, 0）可选
function ProgressExpand:init(texture, progress_type, is_reverse, value, mp_x, mp_y, bcr_x, bcr_y, ap_x, ap_y)
	self.sprite = cc.Sprite:create(texture)
    self.progress_timer = cc.ProgressTimer:create(self.sprite) 
    self:setType(progress_type)
    self:setReverseDirection(is_reverse) 
    self:setMidpoint(mp_x or 0, mp_y or 0)
    self:setBarChangeRate(bcr_x or 1, bcr_y or 0)
    self:setAnchorPoint(ap_x or 0, ap_y or 0)
    self:setPercentage(value or 0)
    self:addChild(self.progress_timer)
end

--- 设置进度条显示的百分比
-- @param percentage 进度值
function ProgressExpand:setPercentage(percentage)
	self.progress_timer:setPercentage(percentage)
end

--- 设置动作进度值
-- @param time 动作时间
-- @param percentage 进度值
function ProgressExpand:setActionPercentage(time, percentage)
	local action = cc.ProgressTo:create(time, percentage)
	self.progress_timer:runAction(action)
end

--- 设置动作
-- @param action 动作
function ProgressExpand:runAction(action)
	self.progress_timer:runAction(action)
end

--- 设置位置
-- @param pos_x
-- @param pos_y
function ProgressExpand:setPosition(pos_x, pos_y)
	self.progress_timer:setPosition(pos_x,pos_y)
end

--- 设置锚点
-- @param p_x
-- @param p_y
function ProgressExpand:setAnchorPoint(p_x, p_y)
	self.progress_timer:setAnchorPoint(p_x,p_y)
end

--- 设置类型
-- @param progress_type 类型 扇形：cc.PROGRESS_TIMER_TYPE_RADIAL 水平：cc.PROGRESS_TIMER_TYPE_BAR
function ProgressExpand:setType(progress_type)
	self.progress_timer:setType(progress_type)
end 

--- 设置是否反方向旋转
-- @param is_reverse 布尔值
function ProgressExpand:setReverseDirection(is_reverse)
	self.progress_timer:setReverseDirection(is_reverse)
end 

--- 设置进度条变化的起始位置(进度条的走向,即若为水平方向控制从左到右还是从右到左，若为垂直方向控制从上到下还是从下到上)
-- @param p_x, p_y 坐标
-- 如果进度条是径向模式，中点代表圆心位置;如果进度条是条形模式，中点代表着进度条展开的方向。
-- 进度条从中心位置向两边展开，因此：进度条是从左往右展开时，设置中点（Midpoint）为Vec2(0,y); 
-- 进度条是从右往左展开时，设置中点（Midpoint）为Vec2(1,y); 
-- 进度条是从下往上展开时，设置中点（Midpoint）为Vec2(x,0); 
-- 进度条是从上往下展开时，设置中点（Midpoint）为Vec2(x,1)
-- @usage setMidpoint(0,0)
function ProgressExpand:setMidpoint(p_x, p_y)
	self.progress_timer:setMidpoint(cc.p(p_x, p_y))
end 

--- 设置条形模式进度条非变化方向显示的比例
-- @param p_x, p_y 坐标 如果不用变化的方向，则设置该方向为0，否则设置为1 （1,0）表示水平方向，（0,1）表示垂直方向
function ProgressExpand:setBarChangeRate(p_x,p_y)
	self.progress_timer:setBarChangeRate(cc.p(p_x, p_y))
end

-- 设置进度条x轴的绽放比例
function ProgressExpand:setScaleX(scaleX)
	self.progress_timer:setScaleX(scaleX)
end

-- 设置进度条y轴的绽放比例
function ProgressExpand:setScaleY(scaleY)
	self.progress_timer:setScaleY(scaleY)
end

-- 获取进度条变化的起始位置
function ProgressExpand:getMidpoint()
	return self.progress_timer:getMidpoint()
end

-- 获取条形模式进度条非变化方向显示的比例
function ProgressExpand:getBarChangeRate()
	return self.progress_timer:getBarChangeRate()
end

-- 获取进度条的类型
function ProgressExpand:getType()
	return self.progress_timer:getType()
end

-- 获取进度条的显示的百分比
function ProgressExpand:getPercentage()
	return self.progress_timer:getPercentage()
end

-- 获取用来显示进度条比例的Sprite对象，已retain 
function ProgressExpand:getSprite()
	return self.progress_timer:getSprite()
end