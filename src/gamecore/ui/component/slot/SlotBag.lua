-- SlotBag.lua
-- created by aXing on 2012-12-10
-- 继承自SlotItem
-- 实现一些背包和仓库里面格子的功能，例如显示上锁标志


local _BG_FRAME_LAYER_NUM   = 10     -- 背景框 层级
local _BG_NOT_OPEN_LOCK     = 20     -- 代表未开启的锁头


--!class SlotBag
SlotBag = simple_class(SlotItem)

function SlotBag:__init( width, height )
	self._icon_bg      = nil    -- icon背景。默认为一个背景框。
	self._not_open_lock = nil   -- 未开启的锁头
end

--- 创建完成，做些初始化工作
function SlotBag:viewCreateCompleted(  )
	SlotItem.viewCreateCompleted( self )
end



--- 显示默认背景框
function SlotBag:show_defualt_bg_frame(  )
	if self._icon_bg == nil then 
        self._icon_bg = GUIImg:create( _PATH_ITEM_SLOT_DEFAULST_BG )
        self._icon_bg:setPosition( SlotBase.DEFAULT_WIDTH / 2, SlotBase.DEFAULT_HEIGHT / 2 )
        self:addChild( self._icon_bg, _BG_FRAME_LAYER_NUM )
	end
	self._icon_bg:setVisible( true )
end

--- 设置为未开启状态。
function SlotBag:set_is_open( is_open )
	print("SlotBag:set_is_open ::: ", is_open)
	self:create_not_open_lock(  )
	if is_open then 
        self._not_open_lock:setVisible( false )
    else
        self._not_open_lock:setVisible( true )
	end
end

-- 显示代表是否开启的锁
function SlotBag:create_not_open_lock(  )
	if self._not_open_lock == nil then 
        self._not_open_lock = GUIImg:create( _PATH_ITEM_SLOT_NOT_OPEN_LOCK )
        self._not_open_lock:setPosition( SlotBase.DEFAULT_WIDTH / 2, SlotBase.DEFAULT_HEIGHT / 2 )
        self:addChild( self._not_open_lock, _BG_NOT_OPEN_LOCK )
	end
end