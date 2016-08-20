-- StarPage.lua
-- created by liuguowang on 2013-12-23
-- 角色属性窗口  user_attr_win

super_class.StarPage()

-- 美术坐标，
local point_solts = {
--由里到外
    --第一圈
    {x = 156,y= 187},
    {x = 156+253,y= 187},

    --第二圈
    {x = 200,y= 290},
    {x = 360,y= 290},
    {x = 200,y= 290-194},
    {x = 360,y= 290-194},

    --第三圈
    {x = 200-75,y= 290+18},
    {x = 200+80,y= 290+51},
    {x = 360+75,y= 290+18},
    {x = 39,y= 187},
    {x = 39+474,y= 187},
    {x = 200-75,y= 290+18-240},
    {x = 200+80,y= 290+51-309},
    {x = 360+75,y= 290+18-240},
}

function StarPage:change_page_index()
    
end

function  StarPage:scroll_create_fun( index)
        print("!!~~index=",index)

        local base_panel = ZBasePanel:create( nil, nil, 0, 0, 118, 300/4)

        local line = ZImage:create( nil, UIResourcePath.FileLocate.common .. "fenge_bg.png" , 0, 0, 118, 2)
        base_panel.view:addChild( line.view )

        local item_date = ItemModel:get_fashion_item_by_position( index+1 ) --获得时装的
        if item_date then
            local slotItem = MUtils:create_one_slotItem(item_date.item_id,28,15,48,48)
                -- 单击回调
            local function item_click_fun ()
                print("item_date",item_date)
                if item_date then       -- item_date 会在设置数据的时候设置上去
                    ItemModel:show_bag_tips(item_date)
                end
            end
            slotItem:set_click_event( item_click_fun )
-----------------------------------------------------------------------

                -- 拖动slot的回调函数
            local function drag_out( self_item )
                print("拖动slot的回调函数   drag_out~!!!!")
            end
            slotItem:set_drag_out_event(drag_out)
-----------------------------------------------------------------------

            -- 物品拖进来
            local function drag_in( source_item )
                print("拖动slot的回调函数  drag_in!!!! ", source_item.win, source_item.obj_data)
                local source_win = source_item.win         -- 源窗口的名称
                -- 在本窗口内拖动， 就直接在dragin方法中给处理。直接改变两个slot的显示(如果是同一类物品，就发送刚合并请求)
                if source_win == _win_name then 
                    local slotitem_source = self:get_slot_by_series( source_item.obj_data.series )   
                    if slotitem_source and slotItem.grid_had_open then                                     -- 如果是窗口内拖动，就交换位置. 源必须有物品，否则就不会有任何交换
                        BagModel:do_drag_in_bag_win( source_item, slotItem )
                    end 
                elseif source_win == "cangku_win" then                          -- 仓库窗口拖进来的
                    BagModel:do_drag_in_from_cangku( source_item, slotItem )
                elseif source_win == "user_equip_win" then
                    print("人物属性")
                    BagModel:do_drag_in_from_userinfo( source_item )
                end
            end
            slotItem:set_drag_in_event(drag_in)

            base_panel.view:addChild(slotItem.view)
        end

        -- local fashion_solt = MUtils:create_one_slotItem( 11101, 40, 10,48,48 )
        return base_panel
end

function StarPage:create_left_panel( )
    self.left_bgPanel = ZBasePanel:create(self.bgPanel,UIPIC_GRID_nine_grid_bg3,0, 11, 553,377, 500, 500)
    ZImage:create(self.left_bgPanel,UIResourcePath.FileLocate.wardrobe.."star_change.png",0,0)
    for i=1,14 do
        print("i=",i)
        print("point_solts[i].x=",point_solts[i].x)
        print("point_solts[i].y=",point_solts[i].y)
        local solt_item = MUtils:create_one_slotItem(nil,point_solts[i].x,point_solts[i].y,48,48)
        solt_item.view:setAnchorPoint(0.5,0.5)
        self.left_bgPanel:addChild(solt_item.view)
    end
end


function StarPage:create_right_panel( )
    
    self.right_bgPanel = ZBasePanel:create(self.bgPanel,UIPIC_GRID_nine_grid_bg3,557, 11, 140+24+3,377, 500, 500)
    local test_bg = ZImage:create(self.right_bgPanel,UIResourcePath.FileLocate.common.."test_bg.png",4,330+12,150,-1) 
    ZLabel:create(test_bg,LangGameString[1001],60,5)-- 1001 背包

    self.scroll = ZScroll:create( nil, nil, 20, 10 , 140,320, 30, TYPE_HORIZONTAL )
    self.scroll:setScrollCreatFunction(StarPage.scroll_create_fun )

    self.right_bgPanel:addChild( self.scroll.view )
end



function StarPage:__init( bgPanel )

    self.bgPanel = ZBasePanel:create(bgPanel,nil,42, 0, 720,390, 500, 500)
    self:create_left_panel()
    self:create_right_panel()

    self.view = self.bgPanel
end


--切换功能窗口:   1:装备   2：信息  3:buff
function StarPage:change_page( but_index )

end

--
function StarPage:create( texture_name )
  

end

-- 供外部调用，刷新所有数据
function StarPage:update_win( update_type )

end

--刷新所有属性数据
function StarPage:update( update_type )
 
end



-- 打开或者关闭是调用. 参数：是否激活
function StarPage:active( show )
    if show then
        local num = ItemModel:get_fashion_item_num( )
        print("num = ",num)
        self.scroll:setMaxNum(num)
        self.scroll.view:reinitScroll()
        self.scroll:refresh()
    end
end



function StarPage:destroy()
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end
end

-- buff面板添加一个buff
function StarPage:add_buff( buff )
  
end

-- buff面板删除一个buff
function StarPage:remove_buff( buff_type ,buff_group)
   
end

function StarPage:update_qqvip()
  
end