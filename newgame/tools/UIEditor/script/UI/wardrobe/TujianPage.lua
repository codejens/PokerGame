-- TujianPage.lua
-- created by liuguowang on 2013-12-23
-- 角色属性窗口  user_attr_win

super_class.TujianPage()

local _max_page_index = 4           -- 最大显示页数

local cur_progress = 4
local total_progress = 24

function TujianPage:change_page_index( i )
 
end
--


--
function TujianPage:create_left_panel(  )
    self.left_bgPanel = ZBasePanel:create(self.bgPanel,UIPIC_GRID_nine_grid_bg3,0, 11, 360,382, 500, 500)
    ZImage:create(self.left_bgPanel,UIResourcePath.FileLocate.wardrobe.."wardrobe_bk1.png",20,115)
    ZImage:create(self.left_bgPanel,UIResourcePath.FileLocate.wardrobe.."wardrobe_bk2.png",0,103,356,275,nil,600,600)

    ZLabel:create(self.left_bgPanel,LangGameString[2327],10,150)  --2327=图鉴进度

    -- ZImage:create(self.left_bgPanel,UIResourcePath.FileLocate.common .. "coner2.png",0,102,328,2)-- 线

    local star_num = WardrobeModel:get_star_num()
    local cur_str = WardrobeModel:need_tujian_add(star_num)
    local cur_attribute = ZDialog:create(self.left_bgPanel,cur_str,10,10,136,86) --- 攻击  物理攻击 法术防御 生命
    cur_attribute.view:setAnchorPoint(0,0)


    local next_str = WardrobeModel:need_tujian_add(star_num+1)
    local next_attribute = ZDialog:create(self.left_bgPanel,next_str,215,10,136,86)-- 攻击  物理攻击 法术防御 生命
    next_attribute.view:setAnchorPoint(0,0)

    ZImage:create(self.left_bgPanel,UIResourcePath.FileLocate.wardrobe .. "arrow.png",155,20)-- 箭头
    ZImage:create(self.left_bgPanel,UIResourcePath.FileLocate.wardrobe .. "next_stage.png",155,70)-- 下一阶字体图片

end

function TujianPage:create_right_panel(  )
    self.right_bgPanel = ZBasePanel:create(self.bgPanel,UIPIC_GRID_nine_grid_bg3,365, 11, 360,382, 500, 500)


    -- 页数指示
    local function left_but_callback()
        self:change_to_pre_page()
    end
    self.left_but = UIButton:create_button_with_name( 8, 225, -1, -1, 
        UIResourcePath.FileLocate.common .. "left_page_turn_btn_n2.png", 
        UIResourcePath.FileLocate.common .. "left_page_turn_btn_n2.png", 
        nil, "", left_but_callback )
    self.right_bgPanel:addChild( self.left_but.view )
    self.left_but.set_double_click_func( left_but_callback )
    
    local function right_but_callback()
        self:change_to_next_page()
    end
    self.right_but = UIButton:create_button_with_name( 310, 225, -1, -1, 
        UIResourcePath.FileLocate.common .. "right_page_turn_btn_n2.png",
        UIResourcePath.FileLocate.common .. "right_page_turn_btn_n2.png", 
        nil, "", right_but_callback )
    self.right_bgPanel:addChild( self.right_but.view )
    self.right_but.set_double_click_func( right_but_callback )  -- 双击


    local function circle_callback_func( page_index ) --换页 圆圈
        if page_index then
            self:change_item_page_by_index( page_index )
        end
    end
    self.show_page_circle = MUtils:create_page_circle( 90, 90, 4, 
        UIResourcePath.FileLocate.common .. "non_current_page_circle2.png",
         UIResourcePath.FileLocate.common .. "current_page_circle3.png", 
         25, 25, 50, circle_callback_func )
    self.right_bgPanel:addChild( self.show_page_circle.view )  -- 双击


    --跟窗帘差不多的框
    -- local left_frame  = ZImage:create(self.right_bgPanel,UIResourcePath.FileLocate.wardrobe .. "solt_frame.png",44,223,120,-1,nil,500)
    -- local right_frame = ZImage:create(self.right_bgPanel,UIResourcePath.FileLocate.wardrobe .. "solt_frame.png",281,223)
    -- right_frame.view:setFlipX(true)

    local function huanhua_fun(  ) -- 幻化按钮

    end
    ZImageButton:create(self.right_bgPanel,UIResourcePath.FileLocate.common .. "button2_red.png",nil,huanhua_fun,131,40)  --幻化按钮

    ZLabel:create(self.right_bgPanel,LangGameString[2328],30,15)   -- 下面的提示

end


-- 上一页
function TujianPage:change_to_pre_page(  )
    if self.current_page_index - 1 > 0 then
        self:change_item_page_by_index( self.current_page_index - 1 )
    end
end

-- 下一页
function TujianPage:change_to_next_page(  )
    if self.current_page_index < _max_page_index then
       self:change_item_page_by_index( self.current_page_index + 1 )
    end
end

-- 切换道具页，如果还没有，会创建
function TujianPage:change_item_page_by_index( page_index )
    -- 先影藏
    for key, one_page in pairs(self.item_page_t) do
        one_page.view:setIsVisible( false )
    end

    -- 创建
    if self.item_page_t[page_index] == nil then
        self.item_page_t[page_index] = self:create_one_item_page(page_index)
        self.right_bgPanel:addChild( self.item_page_t[page_index].view )
    end
    
    -- 显示
    if self.item_page_t[page_index] then
        self.item_page_t[page_index].view:setIsVisible( true )
    end

    self.current_page_index = page_index
    self.show_page_circle.change_page_index( self.current_page_index )

    -- 如果已经到了上一页，或者最后一页，就变暗
    if page_index == 1 then 
        self.left_but.view:setCurState( CLICK_STATE_DISABLE )        
        self.right_but.view:setCurState( CLICK_STATE_UP )        
    elseif page_index == _max_page_index then  
        self.left_but.view:setCurState( CLICK_STATE_UP )        
        self.right_but.view:setCurState( CLICK_STATE_DISABLE )        
    else
        self.left_but.view:setCurState( CLICK_STATE_UP )        
        self.right_but.view:setCurState( CLICK_STATE_UP )        
    end
end
-- 创建一页
local list_w = 75*3                 -- 单页的宽
local list_h = 200                 -- 单页的高
-- 参数：页号： 从1开始

function TujianPage:create_one_item_page( index )
    local item_page = {}
    item_page.view = CCBasePanel:panelWithFile( 60, 125, list_w, list_h, nil)

    -- self.show_page_circle.change_page_index( index + 1 )

    local row,ver = 3, 2
    local list = List:create( nil, 8, 8, list_w , list_h, row, ver )
    local item_panel_x = 0
    local item_panel_y = 0
    local item_slot
    for i = 1, row * ver do 
        item_panel_x = ( (i - 1) % row) * 62
        item_panel_y = ver - math.ceil( i / row ) * 62
        item_slot = self:create_item_slot( 10, 10, 48, 48, (index - 1) * row * ver + i )
        -- list 根据排列数量，计算好了每个格子大小，所以为了调坐标，这里要建个该大小的pannel
        local item_bg = CCBasePanel:panelWithFile( 0, 0, list_w / row, list_h / ver, nil);
        item_bg:addChild( item_slot.view )
        local obj = {}              -- list只显示  ***.view
        obj.view = item_bg
        list:addItem( obj )
    end

    item_page.view:addChild( list.view )
    print("item_page.view=",item_page.view)
    return item_page
end


function TujianPage:create_item_slot(x, y, width, height, index)
    print("index=",index)
    -- 如果已经创建过，就不再创建
    if self.item_slot_t[ index ] then
        return self.item_slot_t[ index ]
    end

    -- 基本的显示
    local item_obj = SlotBag(width, height);
    item_obj.view:setEnableDoubleClick(true)
    item_obj.index = index
    item_obj:set_icon_bg_texture( UIPIC_ITEMSLOT, 
     -6 ,  -6, width+10, height+10 )   -- 背框
    item_obj:setPosition (x, y);
    item_obj:set_icon_texture("");
    item_obj:set_select_effect_state( true )
    item_obj.grid_had_open = true                        -- 标记该格子是否已经开启


    -- scroll 在看不到的时候，会把slot的view销毁。这里 引用加1 ，不让销毁。但要记得要在窗口destroy的时候，release
    safe_retain(item_obj.view)
    self.item_slot_t[ index ] = item_obj
    return item_obj;
end
function TujianPage:__init( bgPanel )

    self.bgPanel = ZBasePanel:create(bgPanel,nil,42, 0, 730,392, 500, 500)

    self.item_page_t = {}             -- 存放页的表
    self.item_slot_t = {}             -- 存放所有已经创建的slot，key 对应背包位置. 这样就不用每次滑动都创建了。但要注意release
    self.current_page_index = 1       -- 当前页

    self:create_left_panel()
    self:create_right_panel()

    self:change_item_page_by_index( 1 )

    self.view = self.bgPanel

    WardrobeModel:req_huanhua_info()
end


--切换功能窗口:   1:装备   2：信息  3:buff
function TujianPage:change_page( but_index )

end

--
function TujianPage:create( texture_name )
  

end

-- 供外部调用，刷新所有数据
function TujianPage:update_win( update_type )

end

function TujianPage:create_star(num) -- 计算星星亮几颗

    local star_num = WardrobeModel:get_star_num()
    for i=1,5 do
        local function star_fun(  )
            -- body
        end
        local star_png
        if i <= star_num then
            star_png = UIResourcePath.FileLocate.wardrobe .. "star_light.png"
        else
            star_png = UIResourcePath.FileLocate.wardrobe .. "star_dark.png"
        end
        ZButton:create(self.left_bgPanel,star_png,star_fun,30 + 66* (i-1),110)
    end
end

--刷新所有属性数据
function TujianPage:update(  )
    self:create_star(total_progress)

end



-- 打开或者关闭是调用. 参数：是否激活
function TujianPage:active( show )
    print("show=",show)
    if show then 
        local equip_info = UserInfoModel:get_equi_info();
        self.showAvatar = ShowAvatar:create_user_panel_avatar( 175,197 ,equip_info)
        self.showAvatar.avatar:setAnchorPoint( CCPoint(0.5,0) )
        self.showAvatar.avatar:setScale( 1.2 )
        self.left_bgPanel:addChild( self.showAvatar.avatar, 1 )
        print("新播放魔法阵特效")
        --     -- 重新播放魔法阵特效 10, 70, 313, 269
        -- LuaEffectManager:stop_view_effect( 10012,self.view);
        -- LuaEffectManager:stop_view_effect( 10013,self.view);
        -- -- 播放魔法阵特效
        -- LuaEffectManager:play_view_effect( 10012,170 ,160,self.view,true ,0);
        -- LuaEffectManager:play_view_effect( 10013,170 ,160,self.view,true ,2);
    end
end



function TujianPage:destroy()
    Window.destroy(self)
    -- for key, page in pairs(self.all_page_t) do
    --     page:destroy()
    -- end
end

-- buff面板添加一个buff
function TujianPage:add_buff( buff )
  
end

-- buff面板删除一个buff
function TujianPage:remove_buff( buff_type ,buff_group)
   
end

function TujianPage:update_qqvip()
  
end