--UserBagBlock.lua
--created by lyl on 2015-05-11
-- 背包窗口

UserBagBlock = simple_class(GUIPanel)


local _BAG_COLUNM_NUM = 5 -- 背包列数
local _ROW_HEIGHT = 76    -- 背包列表行的高度
local _ROW_WEIGHT = 390   -- 背包列表行的宽度
local _SLOT_INTERVAL_X = 78 -- slot横坐标间隔
local _SLOT_BEGIN_X = 40  -- slot开始的坐标
local _SLOT_BEGIN_Y = 40  -- 


-- 出售按钮回调
local function chushou_butt_cb(  )
	print('出售按钮回调 todo')
end

-- 整理按钮回调
local function zhengli_butt_cb( ... )
	print("整理按钮回调 todo")
end

-- slot的点击事件
local function slotitem_cb( slot_index )
	print("slot的点击事件 :::: ", slot_index)
end




function UserBagBlock:__init( view )
	self.yinliang_label = cocosHelper.findWidgetByName( self.view, "yingliang" )    -- 银两 
	self.yuanbao_label  = cocosHelper.findWidgetByName( self.view, "yuanbao" )    -- 元宝
	self.xianbi_label   = cocosHelper.findWidgetByName( self.view, "xianbi" )    -- 仙币
    self.chushou_butt   = cocosHelper.findWidgetByName( self.view, "chushou" )    -- 出售按钮
    self.zhengli_butt   = cocosHelper.findWidgetByName( self.view, "zhengli" )    -- 整理按钮
    self.bag_list       = cocosHelper.findWidgetByName( self.view, "baglist" ) -- 背包list	

    self:register_listener()
end



-- 注册事件回调
function UserBagBlock:register_listener( ... )
	-- 出售按钮
    cocosEventHelper.registerWidgetLisnter( self.chushou_butt, chushou_butt_cb, ccui.TouchEventType.ended )

    -- 整理按钮
    cocosEventHelper.registerWidgetLisnter( self.zhengli_butt, zhengli_butt_cb, ccui.TouchEventType.ended )    
end

-- 更新背包列表
-- data 结构： UserItem类型的table。 
--[[
{
	itemListData = {}  -- UserItem类型的table。 中间可以是空
    openNum      = 10  -- 开启数量
    maxNum       = 100 -- 最大格子数
}
]]
function UserBagBlock:update_bag( data )
	print('update_bag :: ', data, data.maxNum , data.openNum )
	if data == nil then 
        return 
	end
	self.bag_list:removeAllItems()
	local maxNum  = data.maxNum              
	local openNum = data.openNum
	local item_t  = data.itemListData or {}
	local row_num = math.ceil( maxNum / _BAG_COLUNM_NUM )

	local slot_x = 0   -- 临时坐标
	local slot_y = 0   

	for i = 1, row_num do 
		-- 行node
		local row_bg = GUIWidget:create()
		row_bg:setContentSize( _ROW_WEIGHT, _ROW_HEIGHT )
        -- 把slot加入行
		for j = 1, _BAG_COLUNM_NUM do 
            local item_index = ( i - 1) * _BAG_COLUNM_NUM + j
            local userItem = item_t[ item_index ]

	        local slot = SlotBag:create_by_item_data( userItem )
	        slot:show_defualt_bg_frame( )    -- 加背景
            
            -- 在行中的坐标
            slot_x =  ( j - 1) * _SLOT_INTERVAL_X + _SLOT_BEGIN_X
            slot_y = _SLOT_BEGIN_Y
            slot:setPosition( slot_x, slot_y )
            row_bg:addChild( slot )

            -- 如果大于开启格子数，就设置为未开启
            if item_index > tonumber(openNum) then 
                slot:set_is_open( false )
            else
            	local function slot_cb(  )
            		slotitem_cb( item_index )
            	end
            	slot:set_click_event( slot_cb )
            	slot:set_drag_info( SlotDrugMode.ITEM, userItem, "bagwin" )

            	-- 拖拽开始和结束  拖拽时间过程中，不能滚动list
                local function drag_start_cb( ... )
                	self.bag_list:setDirection( 0 ) 
                end
                local function drag_end_cb( ... )
                	self.bag_list:setDirection( 1 ) 
                end
                slot:set_drag_start_cb( drag_start_cb )
                slot:set_drag_end_cb( drag_end_cb )
            end
		end
        self.bag_list:insertCustomItem( row_bg.view, i-1 )
	end
end


-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function UserBagBlock:update( update_type, data )
	print("UserBagBlock:update ::: ", update_type, data)
	if update_type == UPDATE_BAG_ITEMLIST then 
        self:update_bag( data )
    else

	end
end

--- 变成激活（显示）情况调用
function UserBagBlock:active(  )
	print("UserBagBlock:active :: ")
    notifySystem:postNotify( NOTICE_V_BAG_ACTIVE )
end

-- 变成 非激活
function UserBagBlock:unActive(  )
    
end