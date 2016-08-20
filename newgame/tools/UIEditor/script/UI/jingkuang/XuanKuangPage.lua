-- XuanKuangPage.lua
-- create by lxm on 2014-7-7
-- 选矿

super_class.XuanKuangPage()

local node_pet_tuoyin = nil;
--窗体大小
local window_width =880
local window_height = 520

--矿配置
local kuang_array = {UILH_MAINACTIVITY.kuang_1,UILH_MAINACTIVITY.kuang_2,UILH_MAINACTIVITY.kuang_3,
UILH_MAINACTIVITY.kuang_4,UILH_MAINACTIVITY.kuang_5,UILH_MAINACTIVITY.kuang_6,
UILH_MAINACTIVITY.kuang_7,UILH_MAINACTIVITY.kuang_8}

require "../data/jingkuang_config"

function XuanKuangPage:create( )

    return XuanKuangPage( "XuanKuangPage", "", true, window_width,window_height )
end


function XuanKuangPage:__init( window_name, texture_name, pos_x, pos_y, width, height)

    --下面是保存了要更新信息的控件
    -- self.tab_petinfo_view = {};
    self.cur_mubiao_image ={}  --保存选中目标的图片
    
    self.all_kuang_arr = {}

    local panel_bg = CCBasePanel:panelWithFile(0, 0, window_width, window_height, UILH_COMMON.normal_bg_v2,500,500)
    self.view = panel_bg

    local panel_bg2 = CCBasePanel:panelWithFile(15, 13, window_width-30, 495, UILH_COMMON.bottom_bg,500,500)
    panel_bg:addChild(panel_bg2)

    -- self:update_label( children )
    self:create_panel(self.view)

    self:update_cur_kuang(  )
            
    JingKuangCC:req_kuangchang_list(  )
    JingKuangCC:req_kai_kuang(  )

    
end


--刷新按钮回调
local function shuaxin_btn_fun( ... )


    local pin_zhi = JingkuangModel:get_pin_zhi( )

        print("pin_zhi",pin_zhi)
    print("_jingkuang_config[pin_zhi].huafei",_jingkuang_config[pin_zhi].huafei)


    XuanKuangPage:buy_item( _shuaxin_yuanbao[pin_zhi] ,1)
end

--开采按钮回调
local function kaicai_btn_fun( ... )
    -- local pin_zhi = JingkuangModel:get_wakuang_pinzhi( )
    local pin_zhi = JingkuangModel:get_pin_zhi( )
    print("pin_zhi",pin_zhi)
    print("_jingkuang_config[pin_zhi].huafei",_jingkuang_config[pin_zhi].huafei)
    -- XuanKuangPage:buy_item( tonumber(_jingkuang_config[pin_zhi].huafei) ,2)
    XuanKuangPage:buy_item( _jingkuang_config[pin_zhi].huafei ,2)
end

function XuanKuangPage:create_panel( panel ) 
    --刷新按钮
    self.shuaxin_btn =  ZImageButton:create(panel, UILH_COMMON.btn4_nor,"", xuankuang_btn_fun, 227, 44, -1, -1)
    self.shuaxin_btn:setTouchClickFun(shuaxin_btn_fun);
    local shuaxin_lab = UILabel:create_lable_2(LH_COLOR[2].."刷新目标",  62, 22, 14, ALIGN_CENTER )
    self.shuaxin_btn:addChild(shuaxin_lab)
    
    --开采按钮
    self.kaicai_btn =  ZImageButton:create(panel, UILH_COMMON.btn4_nor,"", xuankuang_btn_fun, 491, 44, -1, -1)
    self.kaicai_btn:setTouchClickFun(kaicai_btn_fun);
    local kaicai_lab = UILabel:create_lable_2(LH_COLOR[2].."开采目标",  62, 22, 14, ALIGN_CENTER )
    self.kaicai_btn:addChild(kaicai_lab)
    
    --今天剩余选矿次数：99
    self.shengyu_count_lab = UILabel:create_lable_2("今天剩余选矿次数：", 46, 479, 16, ALIGN_LEFT )
    panel:addChild(self.shengyu_count_lab)
    

    --消耗元宝
    self.pay_lab = UILabel:create_lable_2("消耗100元宝", 244, 30, 16, ALIGN_LEFT )
    panel:addChild(self.pay_lab)
    

    -- self.pay_lab2 = UILabel:create_lable_2("消耗1000元宝", 510, 30, 16, ALIGN_LEFT )
    -- panel:addChild(self.pay_lab2)
    
    --矿列表的背景图
    local title_bg = CCZXImage:imageWithFile( 116, 287, 600, 140, UILH_NORMAL.title_bg4, 500, 500 )
    panel:addChild(title_bg)

    local title_bg2 = CCZXImage:imageWithFile( 159, 139, 600, 140, UILH_NORMAL.title_bg4, 500, 500 )
    panel:addChild(title_bg2)

    self:create_tips(panel)
end



--当界面被UIManager:show_window, hide_window的时候调用
function XuanKuangPage:active(show)
    print(" XuanKuangPage:active(show)")
    if show then
        --PetCC:req_get_pet_history( )

    JingKuangCC:req_kuangchang_list(  )
    JingKuangCC:req_kai_kuang(  )


    end
end


function XuanKuangPage:buy_item( price ,type)
    print("花费的元宝,类型",price,type)
    local avatar = EntityManager:get_player_avatar();--角色拥有元宝
    if tonumber(avatar.yuanbao) < tonumber(price) then --如果元宝不足
        local function confirm2_func()
            GlobalFunc:chong_zhi_enter_fun()
        end
        ConfirmWin2:show( 2, 2, "",  confirm2_func)  --打开元宝不足界面
    else
        --MiscCC:req_refresh_item( 0 ) --如果元宝足 ！
        if type ==1 then
            JingKuangCC:req_shuaxin_pinzhi(  )
        else
            JingKuangCC:req_open_kuang(  )
        end
    end
end



-- 创建tips
function XuanKuangPage:create_tips(panel )
    local  pos_array = {
       [1] = {x= 100,y = 325},
       [2] = {x=260,y = 325},
       [3] = {x=420,y = 325},
       [4] = {x=580,y = 325},
       [5] = {x=215,y = 185},
       [6] = {x=215+160,y = 185},
       [7] = {x=215+2*160,y = 185},
       [8] = {x=215+3*160,y = 185}
    }
    local jiantou_pos = {

       [1] = {x= 200,y = 355},
       [2] = {x=360,y = 355},
       [3] = {x=520,y = 355},
       [4] = {x=160,y = 215},
       [5] = {x=315,y = 215},
       [6] = {x=315+160,y = 215},
       [7] = {x=315+2*160,y = 215},
       [8] = {x=315+3*160,y = 215}

    }

    for i=1,8 do

        --箭头图标
        if i ~= 8 then
           local jiantou =  ZImage:create(panel,UILH_COMMON.right_arrows,jiantou_pos[i].x,jiantou_pos[i].y,-1,-1,nil)
        end
        
        --每一个矿
        local temp = ZBasePanel:create(nil, UILH_COMMON.slot_bg, 0, 0, 88, 88, 500,500)
        temp:setPosition(pos_array[i].x,pos_array[i].y)
        panel:addChild(temp.view)

        --矿名
        temp.kuang_name =  UILabel:create_lable_2(_jingkuang_config[i].name, 9, -15, 14, ALIGN_LEFT )
        temp.view:addChild(temp.kuang_name)
        
        --图标
        temp.kuang_img = ZImage:create(temp.view,kuang_array[i],11,10,-1,-1,nil)
        
        --可获得声望
        local str = string.format("可获得声望%d",_jingkuang_config[i].shengwang)
        temp.shengwang_lab = UILabel:create_lable_2(LH_COLOR[1]..str, -10,-34, 14, ALIGN_LEFT )
        temp.view:addChild(temp.shengwang_lab)
        
        --目标矿山
        -- temp.target_kuang = UILabel:create_lable_2("目标矿山",20,80,16,ALIGN_LEFT)
        -- temp.view:addChild(temp.target_kuang)
        temp.target_kuang_bg = ZImage:create(temp.view,UILH_NORMAL.level_bg,0,90,-1,-1,nil)
        temp.target_kuang = ZImage:create(temp.target_kuang_bg,UILH_MAINACTIVITY.now_jingkuang,9,10,nil)
        
        --tip点击弹出
        local function but_1_fun(eventType,x,y)
            if eventType == TOUCH_CLICK then 

                -- %s#r开启%s需要消耗%d元宝
                local tip_str = string.format("#cd0cda2需要翅膀达到%s阶才能开%s#r开启%s#cd0cda2需要消耗%d元宝",_jingkuang_config[i].tiaojiao,_jingkuang_config[i].name,_jingkuang_config[i].name,_jingkuang_config[i].huafei)
                --"需要翅膀达到二阶才能开XXXX矿#r开启XXXX矿需要消耗5元宝"
                local _data = {}
                _data.str = tip_str
               --_data.height = 100
               -- print("---------_data:", _data)
                TipsWin:showSimpleTip( pos_array[i].x,pos_array[i].y,_data )
                -- TipsModel:show_shop_tip( 15+180*(index-1), 300, award_linggen[index].id )
                return true
            elseif eventType == TOUCH_BEGAN then
                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
        end

        temp.view:registerScriptHandler(but_1_fun)

        table.insert(self.all_kuang_arr,temp)
    end
    
end

-- 选中当前开采目标
function XuanKuangPage:select_cur_kuang( type )
    -- local children = self.children;
    -- local num  = type*2+1
    print("选取当前开采目标",type)
    -- local z_image = children[num]
    -- local temp = ZImage:create(self.all_kuang_arr[type], UIResourcePath.FileLocate.jingkuang .. "mubiao.png", 0, 0, 85, 85, 10)
    -- table.insert( self.cur_mubiao_image, temp )

    self:clear_label( )
    
    --显示目标矿山
    self.all_kuang_arr[type].target_kuang_bg.view:setIsVisible(true)
    -- self.pay_lab:setString(string.format("#cffd700消耗%d元宝",_jingkuang_config[type].huafei))
    --刷新元宝
    print("选取当前开采目标",type)
    local str = string.format("%d",_shuaxin_yuanbao[type])
    -- self.pay_lab2:setString(string.format("#cffd700消耗%d元宝",str))

    self.pay_lab:setString(string.format("#cffd700消耗%d元宝",str))

end

-- 刷新当前开采目标
function XuanKuangPage:update_cur_kuang( ... )
    -- 清除目标圈
    for i=1,#self.cur_mubiao_image do
        self.cur_mubiao_image[i].view:removeFromParentAndCleanup(true)
        self.cur_mubiao_image[i] = nil;
    end
    self.cur_mubiao_image = {}

    local pin_zhi = JingkuangModel:get_pin_zhi( )
    self:select_cur_kuang( pin_zhi )
    
    --今天剩余选矿次数：
    local shengyu_count = JingkuangModel:get_shengyu_count( )
    self.shengyu_count_lab:setString(LH_COLOR[2].."今天剩余选矿次数："..shengyu_count)  --今天剩余挖矿次数：

end

-- 清除目标矿山标志
function XuanKuangPage:clear_label( ... )
    for i=1,#self.all_kuang_arr do
        self.all_kuang_arr[i].target_kuang_bg.view:setIsVisible(false)
    end
end

function XuanKuangPage:update(update_type )

    if update_type =="all" then
        self:update_cur_kuang()
    end
    -- body
end

function XuanKuangPage:on_active()
    print("XuanKuangPage:on_active()")
    
    JingKuangCC:req_kuangchang_list(  )
    JingKuangCC:req_kai_kuang(  )
    self:update_cur_kuang()
    self:update_label()
   -- JingKuangCC:req_kaikuang_info(  )


end

-- 更新矿场说明
function XuanKuangPage:update_label(  )
    --矿场名字
    -- for i=1,8 do
    --     children[38+i].view:setString(_jingkuang_config[i].name)
    -- end

   --矿场名字
   -- for i=1,#self.all_kuang_arr do
   --     self.all_kuang_arr[i].kuang_name:setString(_jingkuang_config[i].name)
   --     local str = string.format(Lang.jingkuang.shengwang,_jingkuang_config[i].shengwang)
   --     self.all_kuang_arr[i].shengwang_lab:setString(str)
   -- end

    -- 获得声望
    -- for i=1,8 do
    --     -- #c35c3f7可获得%d声望
    --     local str = string.format(Lang.jingkuang.shengwang,_jingkuang_config[i].shengwang)
    --     -- children[22+i].view:setString(str)
    -- end

    -- 翅膀条件
    -- for i=1,8 do
    --     -- #c35c3f7可获得%d声望
    --     local str = string.format(Lang.jingkuang.tiaojiao,_jingkuang_config[i].tiaojiao)
    --     children[68+i].view:setString(str)
    -- end
end



