-- SlotMoveDelegate.lua
-- created by aXing on 2014-5-5
-- 格子移动逻辑执行代理类

SlotMoveDelegate = {}

-- 定义格子类型
SlotMoveDelegate.SLOT_TYPE_ITEM		= 1		-- 道具
SlotMoveDelegate.SLOT_TYPE_SKILL	= 2 	-- 技能

-- 定义格子位子
SlotMoveDelegate.SLOT_LOCATION_BAG		= 1		-- 背包
SlotMoveDelegate.SLOT_LOCATION_CANGKU	= 2 	-- 仓库

-- 初始化
function SlotMoveDelegate:init()
	self.source		= nil				-- 注册格子来源
	self.target		= nil				-- 注册格子目标
	self.slot_data 	= {}				-- 注册格子信息id
	self.slot_type 	= nil				-- 注册格子类型
end

-- 析构
function SlotMoveDelegate:fini(  )
	self:cancel_delegate()
end

---------------------------------------------
--
--  私有方法
--
---------------------------------------------

-- 背包移动到仓库
local function bag_to_cangku( ... )
	-- body
end

-- 仓库移动到背包
local function cangku_to_bag( ... )
	-- body
end


-- 注册移动格子信息
local function register( location, slot_id, slot_type )
	self.source 	= location
	self.slot_id	= slot_id
	self.slot_type 	= slot_type

end

-- 执行逻辑
local function execute( location, slot_id, slot_type )
	
	self.target		= location

	if self.source == SlotMoveDelegate.SLOT_LOCATION_BAG and 
		self.target == SlotMoveDelegate.SLOT_LOCATION_CANGKU then
		bag_to_cangku()

	elseif self.source == SlotMoveDelegate.SLOT_LOCATION_CANGKU and
		self.target == SlotMoveDelegate.SLOT_LOCATION_BAG then
		cangku_to_bag()
	end
end

---------------------------------------------
--
--  公有方法
--
---------------------------------------------

-- 代理格子信息
function SlotMoveDelegate:delegate( location, slot_id, slot_type )

	slot_type = slot_type or SlotMoveDelegate.SLOT_TYPE_ITEM	-- 默认是道具

	local is_registered = self:is_register()
	
	if is_registered then
		-- 如果没有注册，就注册
		register(location, slot_id, slot_type)
	else
		-- 如果已经有注册，就执行
		execute(location, slot_id, slot_type)
		self:cancel_delegate()
	end
end

-- 取消注册
function SlotMoveDelegate:cancel_delegate(  )
	local is_registered = self:is_register()
	if is_registered then
		self.source		= nil				-- 注册格子来源
		self.target		= nil				-- 注册格子目标
		self.slot_id 	= nil				-- 注册格子信息id
		self.slot_type 	= nil				-- 注册格子类型
	end
end

-- 是否已经有格子信息注册了
function SlotMoveDelegate:is_register(  )

	if self.slot_id ~= nil then
		return true
	end

	return false
end


