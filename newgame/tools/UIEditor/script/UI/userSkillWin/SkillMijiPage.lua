
--SkillMijiPage.lua
--create by guozhinan on 2015.3.25
--技能秘籍。主要移植灭天的，背包panel是斩仙风格。

local _miji_skill_pos = {
    {160,355}, --单体技能
    -- {0,0},    --2,5号技能是页游的 手游没有
    {335,355}, --群体技能
    {335,252}, --控制技能
    -- {0,0},
    {160,252}, --辅助技能
    {160,140},
    {335,140},
}

local _skill_pos = {
    {45,-10},
    -- {0,0},    --2,5号技能是页游的 手游没有
    {45,-10},
    {-20,-10},
    -- {0,0},
    {-20,-10},
    {-20,-10},
    {45,-10},
}

local slotw,sloth = 64,64
local ITEM_NUM_PER_PAGE = 8

--按钮名字
local _btn_name = {
    "装备",
    "升级",
    "修炼",
}

--帮助说明配置
local help = {
    "fudaiRule","fudaiRule","shengjiRule","hechengRule",
}

--数字转换文字
local _num_text = {
    "一重","二重","三重","四重","五重","六重","七重","八重","九重",
}

--当前秘籍是否已装备
local _curr_miji_is_zb = false
--当前tab按钮选择的索引
local _curr_tab_btn_index = 1
--背包每行个数
local NOE_ROW_NUM = 5
--每行高度
local NOE_ROW_HITH = 65


super_class.SkillMijiPage()

-----------------按钮回调提供外界------------------
--左边每个秘籍点击回调
local function miji_click_cb_func( index )
    SkillMiJiModel:miji_click_cb_func( index )
end
--右边tab按钮回调
local function tab_btn_click_cb_fun( index )
    SkillMiJiModel:tab_btn_click_cb_fun( index )
end 
--背包中物品使用回调
local function user_cb_func(item_date)

end
--升级 添加预道具
local function additem_cb_func( items )
    SkillMiJiModel:add_items( items )
end
--修炼 添加预道具
local function xl_additem_cb_func( items )
    SkillMiJiModel:xiulian_add_items( items )
end

-----------------更新操作提供给外界----------------

--更新左侧秘籍
function SkillMijiPage:update_left_panel(date,fight)

    --秘籍战力
    if fight then
        self.fight:set_number(fight);
    end
    local job_skill_t = UserSkillModel:get_player_skills()
    local mijidate = nil 
    local item_id = 1
    local is_have_miji = false
    local x = 1
    local y = 1
  
    for i=1,6 do
        LuaEffectManager:stop_view_effect( 20085,self.left_panel )
        --LuaEffectManager:stop_view_effect( 20077,self.left_panel )
    end

    for i=1,6 do
         -- if i ~= 2 and i ~= 5 then
            is_have_miji = false
            for j=1,#date do
                mijidate = date[j]
                if job_skill_t[i].id == mijidate.skill_id then
                    item_id = mijidate.userItem.item_id
                    self.miji_skill_item[i].set_base_date(item_id)
                    is_have_miji = true
                    --橙色特效
                    if mijidate.userItem.quality == 4 then
                        x=_miji_skill_pos[i][1]+280
                        y=_miji_skill_pos[i][2]-150
                       -- LuaEffectManager:play_view_effect( 20085,x,y,self.left_panel,true,99)
                    else
                    end
                end
            end
            if not is_have_miji then
                self.miji_skill_item[i]:set_icon_ex()
                --LuaEffectManager:stop_view_effect( 20085,self.miji_skill_item[i].view )
            end
         -- end 
    end

end
--更新背包(max_num没在用了，有时候会传nil值,现在仅用来判断是model层调用还是view层调用)
function SkillMijiPage:update_beibao(max_num)
    if max_num ~= nil then
        self:clear_beibao_slot_state(  )
    end

    local beibao_data = SkillMiJiModel:get_miji_beibao_date(  )
    --根据背包页数 确定显示道具的开始和结尾  0起，+i
    local start_index = (self.curr_bag_item_page-1)*#self.item_slot_t
    for i=1,#self.item_slot_t do
        if beibao_data[start_index+i] ~= nil then
            self.item_slot_t[i]:set_icon_ex(beibao_data[start_index+i].item_id)
            self.item_slot_t[i]:set_color_frame(beibao_data[start_index+i].item_id,-2,-2,68,68)
            self.item_slot_t[i]:set_item_count( beibao_data[start_index+i].count )
            local lock_state = false
            if beibao_data[start_index+i].flag == 1 then 
                lock_state = true
            end
            self.item_slot_t[i]:set_lock( lock_state )
            self.item_slot_t[i].item_data = beibao_data[start_index+i]

            -- 刷新置灰状态
            self:set_beibao_item_Lock_state(start_index+i)
        else
            self.item_slot_t[i]:set_item_count(0)
            self.item_slot_t[i]:set_lock( false )
            self.item_slot_t[i]:set_icon_ex(nil)
            self.item_slot_t[i].item_data = nil
        end
    end
    -- 根据背包道具及当前道具页数决定左右翻页按钮状态
    local max_page = math.ceil(#beibao_data/#self.item_slot_t)
    if max_page <= 1 then
        self.left_bag_btn.view:setCurState(CLICK_STATE_DISABLE)
        self.right_bag_btn.view:setCurState(CLICK_STATE_DISABLE)
    else
        if self.curr_bag_item_page <= 1 then
            self.left_bag_btn.view:setCurState(CLICK_STATE_DISABLE)
        else
            self.left_bag_btn.view:setCurState(CLICK_STATE_UP)
        end
        if self.curr_bag_item_page >= max_page then
            self.right_bag_btn.view:setCurState(CLICK_STATE_DISABLE)
        else
            self.right_bag_btn.view:setCurState(CLICK_STATE_UP)
        end
    end

     -- self.beibao_scroll:clear()
     -- max_num =math.ceil(max_num/NOE_ROW_NUM)
     -- self.beibao_scroll:setMaxNum( max_num )
     -- self.beibao_scroll:refresh()

     -- if max_num and max_num == 0 then
     --    local  str = ""
     --    if _curr_tab_btn_index == 2 then
     --        str = Lang.Miji.MijiTips2
     --    else
     --        str = Lang.Miji.MijiTips1 
     --    end
       
     --    self.null_beibao_lab:setText(str)
     -- else
     --    self.null_beibao_lab:setText("")
     -- end
end

----更新秘籍左下角说明
function SkillMijiPage:update_miji_left_down( is_zhuangbei,miji_id,str)
   if is_zhuangbei then
        -- self.ld_can_panel:setIsVisible(false)
        -- self.ld_jp_panel:setIsVisible(true)
        self.left_ccdialogEx:setText(str)

        -- ld_can_panel改为一直存在，所以刷新一下数据
        for i=1,4 do
            self.show_slot_item[i].set_base_date(miji_id[i])
            self.show_slot_item[i].date.item_id = miji_id[i]
        end
        local name = ItemConfig:get_item_name_by_item_id( miji_id[5] )
        self.miji_name_lab:setText("#c38ff33"..name)
   else
        self.ld_jp_panel:setIsVisible(false)
        self.ld_can_panel:setIsVisible(true)
        -- self.ld_can_panel.update(miji_id)
        for i=1,4 do
            self.show_slot_item[i].set_base_date(miji_id[i])
            self.show_slot_item[i].date.item_id = miji_id[i]
        end
        local name = ItemConfig:get_item_name_by_item_id( miji_id[5] )
        self.miji_name_lab:setText("#c38ff33"..name)
   end
end

--更新装备页未装备页切换
function SkillMijiPage:set_curr_page( is_miji ,date)
    self.curr_rt_page:setIsVisible(false)
    if is_miji then
        self.curr_rt_page = self.rt_zhuanbei_page.view
        -- self.rt_zhuanbei_page.update(date)
        self.equipping_slot_item:set_icon(date.id)
        self.skill_name_lab:setText(date.name.." #cffffffLV."..date.level)
        self.miji_explain_dialog:setText(date.desc)
    else
        self.curr_rt_page = self.rt_not_zhuanbei_page.view
    end
    self.curr_rt_page:setIsVisible(true)
end

--更新右上角界面
function SkillMijiPage:update_rt_page( btn_index,is_miji,date)
    _curr_miji_is_zb = is_miji
   if btn_index == 1 then
        self:set_curr_page( is_miji ,date)
   elseif btn_index == 2 then
        self.rt_sj_page.update_all(is_miji,date)
    elseif btn_index == 3 then
        self.rt_xl_page.update_all(is_miji,date)
   end
end

-- 播放升级 装备 修炼成功特性的
function SkillMijiPage:player_successed_effect( index )
   -- print("-- 播放升级 装备 修炼成功特性的")
    local  x=_miji_skill_pos[index][1]+280
    local y=_miji_skill_pos[index][2]-150
    -- LuaEffectManager:play_view_effect( 20077,x,y,self.left_panel,false)
end

--升级 修炼 添加预道具后 更新
function SkillMijiPage:update_exp_money_level( btn_index,date )
    --print("--升级 修炼 添加预道具后 更新")
   if btn_index == 2 then
        self.rt_sj_page.update_exp_money_level(date)
    elseif btn_index == 3 then
        self.rt_xl_page.update_exp_money_level(date)
    end
end

--激活窗口后 删除特效
function SkillMijiPage:delete_effect(  )
   for i=1,6 do
    LuaEffectManager:stop_view_effect( 20085,self.left_panel )
    LuaEffectManager:stop_view_effect( 20077,self.left_panel )
   end
end
function SkillMijiPage:destroy()
    for i=1,6 do
        -- if i ~= 2  or i ~= 5 then
            if self.miji_skill_item and self.miji_skill_item[i] and self.miji_skill_item[i].view then
                LuaEffectManager:stop_view_effect( 20085,self.miji_skill_item[i].view )
                LuaEffectManager:stop_view_effect( 20077,self.miji_skill_item[i].view )
            end
        -- end
    end
     _curr_miji_is_zb = false
     _curr_tab_btn_index = 1
    self:clear_beibao_slot_state(  )
end

function SkillMijiPage:__init(  )

    --保存秘籍技能
    self.miji_skill_item = {}
    --秘籍背包道具
    self.beibao_slot_item = {}
    self.beibao_slot_state = {}
    --保存当前右上角page
    self.curr_rt_page = nil

    _curr_tab_btn_index = 1
    self.curr_bag_item_page = 1 --默认背包道具显示的页
    --保存背包道具
    self.beibao_item = {}

	local  path =  UILH_COMMON.normal_bg_v2
    local miji_page = CCBasePanel:panelWithFile( 0, 0, 880, 521, UILH_COMMON.normal_bg_v2,500,500)
    self.view = miji_page
    -- miji_page:setAnchorPoint(0.5,0.5)
    -- miji_page:setIsVisible(false)

    --创建左边界面
    self.left_panel = self:create_miji_left()
    miji_page:addChild(self.left_panel)

    -- 创建右边背景
    local right_bg = CCZXImage:imageWithFile(443,12,425,450,UILH_COMMON.bottom_bg,500,500)
    miji_page:addChild(right_bg)

    --创建右边上界面
    local rigth_top_panel = self:create_miji_rigth_top()
    miji_page:addChild(rigth_top_panel)
    --创建右边下界面
  local rigth_down_panel = self:create_miji_rigth_down()
   miji_page:addChild(rigth_down_panel)

end

--创建左边界面
function SkillMijiPage:create_miji_left()
    local left_panel = CCBasePanel:panelWithFile( 12, 12, 430, 497,UILH_COMMON.bottom_bg ,500,500)

    -- 战斗力美术字
    local power_title = CCZXImage:imageWithFile(120,450,-1,-1,UILH_MOUNT.zhandouli)
    left_panel:addChild(power_title)
    -- 战斗力值
    local function get_num_ima( one_num )
        return string.format("ui/lh_other/number2_%d.png",one_num);
    end
    self.fight = ImageNumberEx:create("0",get_num_ima,16)
    self.fight.view:setPosition(CCPointMake(120+90,450+15))
    left_panel:addChild( self.fight.view )

    -- 两个背景和背景标题
    local bg1 = MUtils:create_zximg(left_panel,UILH_COMMON.bg_10,8,232,413,210)
    local text_bg1 = MUtils:create_zximg(bg1,UILH_NORMAL.bg_red,4,205,200,36,0,0)
    text_bg1:setRotation(90)
    MUtils:create_zximg(bg1,UILH_SKILL.zhudongmiji,4,57,-1,-1)

    local bg2 = MUtils:create_zximg(left_panel,UILH_COMMON.bg_10,8,118,413,110)
    local text_bg2 = MUtils:create_zximg(bg2,UILH_NORMAL.bg_red,3,110,110,36,0,0)
    text_bg2:setRotation(90)
    MUtils:create_zximg(bg2,UILH_SKILL.beidongmiji,4,2,-1,-1)

    -- 分割线
    local line = CCZXImage:imageWithFile( 15, 108, 400, 3, UILH_COMMON.split_line)
    left_panel:addChild(line)

    local job_skill_t = UserSkillModel:get_player_skills()
    local item_bg_path = UILH_NORMAL.item_bg4

    --选中图片
    local selected_path = UILH_COMMON.slot_focus
    local selected_img = MUtils:create_zximg(left_panel,selected_path,_miji_skill_pos[1][1]-9.5,_miji_skill_pos[1][2]-9.5,84,84,0,0,10)
    --selected_img:setIsVisible(false)
    local x = 1
    local y = 1
    for i=1,6 do
        -- if i ~= 2 and i ~= 5 then
            x = _miji_skill_pos[i][1]
            y = _miji_skill_pos[i][2]

            local function miji_cb_func(  )
                --处理选中效果
                selected_img:setIsVisible(true)
                selected_img:setPosition(_miji_skill_pos[i][1]-9.5,_miji_skill_pos[i][2]-9.5)
                -- 重置背包页数
                self.curr_bag_item_page = 1
                --处理；逻辑
                miji_click_cb_func(job_skill_t[i].id )
                self:clear_beibao_slot_state(  )
            end
            self.miji_skill_item[i] = MUtils:create_one_slotItem( nil,x, y, 64, 64)
            self.miji_skill_item[i]:set_icon_bg_texture(item_bg_path)
            left_panel:addChild(self.miji_skill_item[i].view)
            self.miji_skill_item[i]:set_click_event( miji_cb_func )
            --local bg_panel = CCBasePanel:panelWithFile( 40, 12, 381, 367, UIResourcePath.FileLocate.common .. "nine_grid_bg.png",500,500)

             --MUtils:create_slot_item(left_panel,item_bg_path,x, y, 59, 59,nil,miji_cb_func);
             -- local bg_panel = CCBasePanel:panelWithFile( 40, 12, 381, 367, UILH_COMMON.bottom_bg,500,500)
            --技能图标背景
            local skill_slot_bg = CCZXImage:imageWithFile( -80, 3, -1, -1, UILH_SKILL.skill_bg)
            self.miji_skill_item[i].view:addChild(skill_slot_bg,10)

            --技能图标
            local skill_base = SkillConfig:get_skill_by_id( job_skill_t[i].id )  -- 技能的静态数据
            local skill_slot = SlotSkill(46, 46)
            skill_slot:set_icon( skill_base.id )
            skill_slot:setPosition(-73,9)
            self.miji_skill_item[i].view:addChild(skill_slot.view,10)
        -- end
    end


    --可装备道具
    self.ld_can_panel = CCBasePanel:panelWithFile( 5, 5, 420, 90, nil,500,500)
    left_panel:addChild(self.ld_can_panel)
    -- MUtils:create_sprite(self.ld_can_panel, UIResourcePath.FileLocate.skill.."text_can_zb.png",53,105)
    local name_lab1 = UILabel:create_lable_2( "附带秘籍:", 5, 55,14,1)
    self.ld_can_panel:addChild(name_lab1)
    local name_lab = UILabel:create_lable_2( "秘籍名称是", 5, 35,14,1)
    self.miji_name_lab = name_lab
    self.ld_can_panel:addChild(name_lab)
    local slot_item = {}
    for i=1,4 do
        x= i *80+15
        y = 18
        local function slot_cb_func(  )
            -- 指针拷贝，其实fix_data就是slot_item[i].date
            local fix_data = slot_item[i].date
            fix_data.open_from_skill_page = true
            TipsWin:showTip( 300,250, fix_data,nil,nil, nil)
        end
        slot_item[i] = MUtils:create_one_slotItem( nil,x, y, 58, 58)
        slot_item[i]:set_click_event( slot_cb_func )
        slot_item[i].date = {item_id = nil,quality =i,}
        slot_item[i].date.void_bytes_tab = {[2]=0,[7]=0,[3]=0}
        --local bg_panel = CCBasePanel:panelWithFile( x, y, 63, 63, path)
        self.ld_can_panel:addChild(slot_item[i].view)
    end
    -- self.ld_can_panel.update = function ( miji_id,name )
    --     for i=1,4 do
    --         slot_item[i].set_base_date(miji_id[i])
    --         slot_item[i].date.item_id = miji_id[i]
    --     end
    --     local name = ItemConfig:get_item_name_by_item_id( miji_id[5] )
    --     name_lab:setText("#c38ff33"..name)
    -- end
    self.show_slot_item = slot_item;    -- 四个展示秘籍icon的slot
    --极品预览
    self.ld_jp_panel = CCBasePanel:panelWithFile( 5, 5, 350, 85, "",500,500)
    left_panel:addChild(  self.ld_jp_panel)
    
    -- MUtils:create_sprite(self.ld_jp_panel, UIResourcePath.FileLocate.skill.."text_jipin.png",53,105)
    local str = "极品预览：#r技能秘籍：#r修炼属性：#r特殊属性："
    self.left_ccdialogEx = MUtils:create_ccdialogEx(self.ld_jp_panel,str,8,4,400,80,10,16)
    self.ld_jp_panel:setIsVisible(false)

    return left_panel
end

--创建右边上界面
function SkillMijiPage:create_miji_rigth_top()
    self.rigth_top_panel = CCBasePanel:panelWithFile( 443, 260, 430, 250, nil,500,500)

    local raido_btn_group = self:create_tab_btn(  )
    self.rigth_top_panel:addChild(raido_btn_group)


    --装备页 未装备
    self:create_rt_not_zhuangbei_page()
    self.curr_rt_page  = self.rt_not_zhuanbei_page.view
    --已装备
    self:create_rt_zhuangbei_page()
    --升级
    self:create_rt_shengji_page()

    --修炼
    self:create_rt_xiulian_page()

    return  self.rigth_top_panel
end

--创建右上角未装备界面
function SkillMijiPage:create_rt_not_zhuangbei_page()
    self.rt_not_zhuanbei_page = {}
    local  path =  UILH_COMMON.bottom_bg
    self.zb_not_panel = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
    self.rigth_top_panel:addChild(self.zb_not_panel)
    self.rt_not_zhuanbei_page.view = self.zb_not_panel
    local slot_item = MUtils:create_one_slotItem(nil, 20, 110 )
    self.zb_not_panel:addChild(slot_item.view)

    local ts_lab1 = UILabel:create_lable_2( "当前没有为此技能附带秘籍,", 430/2, 60,16,2)
    self.zb_not_panel:addChild(ts_lab1)
    local ts_lab2 = UILabel:create_lable_2( "可双击背包中的秘籍完成附带", 430/2, 37,16,2)
    self.zb_not_panel:addChild(ts_lab2)

    self.zb_not_panel:setIsVisible(false)

    --说明按钮
    local btn = self:create_help_btn( self.zb_not_panel,1 )

    -- self.rt_not_zhuanbei_page.update = function(  )

    -- end
end

--创建右上角装备界面
function SkillMijiPage:create_rt_zhuangbei_page()
    self.rt_zhuanbei_page = {}
    local  path =  UILH_COMMON.bottom_bg
    local zb_panel = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
    self.rigth_top_panel:addChild(zb_panel)
    self.rt_zhuanbei_page.view = zb_panel

    --秘籍类型
    local skill_name_lab = UILabel:create_lable_2( "#c38fe35某某某技能秘籍", 99, 162,16,1)
    self.skill_name_lab = skill_name_lab
    zb_panel:addChild(skill_name_lab)

    -- local level_lab = UILabel:create_lable_2( "#c38fe35某某某技能秘籍", 140, 145,14,1)
    -- zb_panel:addChild(level_lab)

    --技能图标
    local slot_item = MUtils:create_one_slotItem( nil,20, 115, 64, 64);
    self.equipping_slot_item = slot_item
    -- slot_item:set_icon_bg_texture("")
    zb_panel:addChild(slot_item.view)
    -- slot_item.view:setScale(0.5)
    --秘籍介绍
    local str = "#cfff000某某某技能秘籍 #cfffffflv.99#r修炼属性：啧啧啧啧啧啧啧啧啧在灌灌灌灌灌灌灌灌灌灌灌灌灌灌灌灌灌"
    local ccdialogEx = MUtils:create_ccdialogEx(zb_panel,str,10,106,400,80,10,15)
    self.miji_explain_dialog = ccdialogEx
    ccdialogEx:setAnchorPoint(0,1)
    --卸下按钮
    local function cb_func(  )
        -- if KuaFuModel:FUNC_use_access_tip(1) == KuaFuModel.FUNC_FORBID_USE then
        --     return 
        -- end
        SkillMiJiModel:req_xiexia_miji(  )
        return true
    end

    local btn = ZButton:create( zb_panel, {UILH_COMMON.button8,UILH_COMMON.button8}, cb_func, 100, 107, 95, 40 )
    MUtils:create_zxfont(btn,"放入背包",95/2,14,2,15);

    --铜币消耗
    local need_lab = UILabel:create_lable_2( "消耗铜币：#cfff0002000", 95, 15,14,1)
    btn:addChild(need_lab)

        --说明按钮
    local btn = self:create_help_btn( zb_panel,2 )

    -- self.rt_zhuanbei_page.update = function( date)
    --     slot_item:set_icon(date.id)
    --     skill_name_lab:setText(date.name.." #cffffffLV."..date.level)
    --     ccdialogEx:setText(date.desc)
    -- end
 
    zb_panel:setIsVisible(false)
end

--创建右上角升级界面
function SkillMijiPage:create_rt_shengji_page()
    self.rt_sj_page = {}
    local  path =  UILH_COMMON.bottom_bg
    local sj_panel = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
    local sj_panel_not_miji = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
    self.rt_sj_page.view = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
    self.rt_sj_page.view:addChild(sj_panel)
    self.rt_sj_page.view:addChild(sj_panel_not_miji)
    self.rigth_top_panel:addChild(self.rt_sj_page.view)

    --技能图标
    local slot_item = MUtils:create_one_slotItem( nil,20, 110, 64, 64);
    local function slot_cb_func(  )
        if slot_item.item_id  then
           SkillMiJiModel:slot_click_cb_func(  )
        end
    end
    slot_item:set_click_event( slot_cb_func )
    sj_panel:addChild(slot_item.view)

    local sj_name_lab = UILabel:create_lable_2( "某某技能", 99, 170,16,1)
    sj_panel:addChild(sj_name_lab)

    local level_lab1 = UILabel:create_lable_2( "#cfff000LV.88", 120, 140,14,2)
    sj_panel:addChild(level_lab1)

    MUtils:create_sprite(sj_panel, UILH_COMMON.right_arrows,163,145)

    local level_lab2 = UILabel:create_lable_2( "#cfff000LV.89", 207, 140,14,2)
    sj_panel:addChild(level_lab2)

    local material_lab = UILabel:create_lable_2( "消耗材料：", 10, 45,15,1)
    sj_panel:addChild(material_lab)

    local money_lab = UILabel:create_lable_2( Lang.Miji[27], 368, 3,14,2)
    sj_panel:addChild(money_lab)

    --进度条
    local img_bg = UILH_NORMAL.progress_bg
    local img = UILH_NORMAL.progress_bar
    local recharge_bar = MUtils:create_progress_bar( 95, 105,180 , 23, img_bg,img,  200, {12,nil}, {12,11,5.5,5.5}, true)
    sj_panel:addChild( recharge_bar.view )
    recharge_bar.set_current_value(100)
    local slot_date = {}
    for i=1,3 do
        slot_date[i] = {}
        local function delete_item_cb_func(  )
            slot_date[i].slot_item:set_icon_ex()
            slot_date[i].slot_item:set_item_count(1)
            slot_date[i].guid = nil
            slot_date[i].count = nil
            slot_date[i].item_date = nil
            if slot_date[i].index then
                self.beibao_slot_state[slot_date[i].index] = false
                self:set_beibao_item_Lock_state(slot_date[i].index)
                slot_date[i].index = nil
            end
            additem_cb_func(slot_date)
        end
        slot_date[i].slot_item = MUtils:create_one_slotItem( nil, 105+(i-1)*70, 25,48, 48)
        slot_date[i].slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -9, -9, 83, 83)
        sj_panel:addChild(slot_date[i].slot_item.view)
        slot_date[i].guid = nil
        slot_date[i].count = nil
        slot_date[i].item_date = nil
        slot_date[i].slot_item:set_click_event(delete_item_cb_func)
    end

        --升级按钮
    local function cb_func(  )
        -- if KuaFuModel:FUNC_use_access_tip(1) == KuaFuModel.FUNC_FORBID_USE then
        --     return true
        -- end
        SkillMiJiModel:req_shengji_miji( slot_date )
         self:clear_beibao_slot_state(  )
         return true;
    end
    local btn = ZButton:create( sj_panel, {UILH_COMMON.button8,UILH_COMMON.button8}, cb_func, 321, 29, 95, 40 )
    MUtils:create_zxfont(btn,"升级",95/2,14,2,15);

        --获取材料按钮
    -- local function cb_func(  )
        -- if KuaFuModel:FUNC_use_access_tip(1) == KuaFuModel.FUNC_FORBID_USE then
        --     return true
        -- end
    --     MysticalShopModel:open_shop_win_by_type( MysticalShopModel.ZYT_SHOP,"user_skill_win" )
    --      return true;
    -- end

    -- local btn = ZButton:create( sj_panel, {UILH_COMMON.button8,UILH_COMMON.button8}, cb_func, 170, 5, 95, 40 )
    -- MUtils:create_zxfont(btn,"获取材料",95/2,14,2,15);

        --说明按钮
    local btn = self:create_help_btn( self.rt_sj_page.view,3 )

    local not_miji_lab = UILabel:create_lable_2( "请先装备秘籍", 430/2, 85,16,2)
    sj_panel_not_miji:addChild(not_miji_lab)

    --添加道具
    self.rt_sj_page.add_item= function(item_date,num,index)
        for i=1,3 do
          if not slot_date[i].guid then
             slot_date[i].slot_item:set_icon(item_date.item_id)
             if not num then
                slot_date[i].slot_item:set_item_count(item_date.count)
                slot_date[i].count = item_date.count
             else
                slot_date[i].slot_item:set_item_count(num)
                 slot_date[i].count = num
             end
             if index then
                slot_date[i].index = index
             end
             self.beibao_slot_state[index] = true
             slot_date[i].guid = item_date.series
             slot_date[i].item_date = item_date
             additem_cb_func(slot_date)
             return
          end
        end
        --已满 直接替换第三个
        GlobalFunc:create_screen_notic( "材料已满", 16, 300, 250 )
        -- slot_date[3].slot_item:set_icon(item_date.item_id)
        -- slot_date[3].slot_item:set_item_count(item_date.count)
        -- slot_date[3].guid = item_date.series
        -- slot_date[3].count = item_date.count
        -- additem_cb_func(slot_date)
    end

    --清空道具
    self.rt_sj_page.clear_items = function()
        for i=1,3 do
             slot_date[i].slot_item:set_icon_ex()
             slot_date[i].slot_item:set_item_count(1)
             slot_date[i].guid = nil
             slot_date[i].count = nil
             slot_date[i].item_date = nil
        end
    end

    --未装备隐藏所有控件
    self.rt_sj_page.update_all = function(is_have_miji,date)
        if not is_have_miji then
            sj_panel:setIsVisible(false)
            sj_panel_not_miji:setIsVisible(true)
        else
            sj_panel:setIsVisible(true)
            sj_panel_not_miji:setIsVisible(false)
            level_lab1:setText("#cfff000LV."..date.level) --等级
            level_lab2:setText("#cfff000LV."..(date.level+1))
            sj_name_lab:setText(date.name)
            slot_item.set_base_date(date.id)
            if date.maxexp and date.last_maxexp then
                -- 经验值只显示本级升级需要的经验值
                recharge_bar.set_max_value(date.maxexp-date.last_maxexp)
            end
            if date.curexp and date.last_maxexp then
                recharge_bar.set_current_value(date.curexp-date.last_maxexp)
            end
        end
        self.rt_sj_page.clear_items()
    end

    --更新经验 消耗铜币  等级
    self.rt_sj_page.update_exp_money_level = function(date)
        -- 预防报错 
        if date.exp-date.last_maxexp>0 then
            recharge_bar.set_current_value(date.exp-date.last_maxexp)
        else
            recharge_bar.set_current_value(date.exp)
        end
        level_lab2:setText("#cfff000LV."..(date.level))
        local need_money = math.floor(date.new_exp/10)
        money_lab:setText("铜币：#cfff000"..need_money)
    end
    self.rt_sj_page.view:setIsVisible(false)
    -- sj_panel_not_miji:setIsVisible(false)
    -- sj_panel:setIsVisible(false)
end

--创建右上角修炼界面
function SkillMijiPage:create_rt_xiulian_page()
    self.rt_xl_page = {}
     local  path =  UILH_COMMON.bottom_bg
    local xl_panel = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
    local xl_panel_not_miji = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
    self.rt_xl_page.view = CCBasePanel:panelWithFile( 0, 0, 430, 200, nil,500,500)
     self.rt_xl_page.view:addChild(xl_panel)
      self.rt_xl_page.view:addChild(xl_panel_not_miji)
    self.rigth_top_panel:addChild(self.rt_xl_page.view)

    --技能图标
    local slot_item = MUtils:create_one_slotItem( nil,20, 110, 64, 64)
    local function slot_cb_func(  )
        if slot_item.item_id  then
           SkillMiJiModel:slot_click_cb_func(  )
        end
    end
    slot_item:set_click_event( slot_cb_func )
    xl_panel:addChild(slot_item.view)

    local name_lab = UILabel:create_lable_2( "#cfff000名称", 99, 170,16,1)
    xl_panel:addChild(name_lab)

    local level_lab1 = UILabel:create_lable_2( "一重", 120, 140,14,2)
    xl_panel:addChild(level_lab1)

    MUtils:create_sprite(xl_panel, UILH_COMMON.right_arrows,163,145)

    local level_lab2 = UILabel:create_lable_2( "二重", 207, 140,14,2)
    xl_panel:addChild(level_lab2)

    local material_lab = UILabel:create_lable_2( "消耗材料：", 10, 45,15,1)
    xl_panel:addChild(material_lab)

    --进度条
    local img_bg = UILH_NORMAL.progress_bg
    local img = UILH_NORMAL.progress_bar
    local recharge_bar = MUtils:create_progress_bar( 95, 105,180 , 23, img_bg,img,  200, {12,nil}, {12,11,5.5,5.5}, true)
    xl_panel:addChild( recharge_bar.view )
    recharge_bar.set_current_value(100)

    local slot_date = {}
    for i=1,3 do
        slot_date[i] = {}
        local function delete_item_cb_func(  )
            slot_date[i].slot_item:set_icon_ex()
            slot_date[i].slot_item:set_item_count(0)
            slot_date[i].guid = nil
            slot_date[i].count = nil
            slot_date[i].item_date = nil
            if slot_date[i].index then
                self.beibao_slot_state[slot_date[i].index] = false
                self:set_beibao_item_Lock_state(slot_date[i].index)
                slot_date[i].index = nil
            end

            xl_additem_cb_func(slot_date)
        end
        slot_date[i].slot_item = MUtils:create_one_slotItem( nil, 105+(i-1)*70, 25,48, 48)
        slot_date[i].slot_item:set_icon_bg_texture( UILH_COMMON.slot_bg, -9, -9, 83, 83)
        xl_panel:addChild(slot_date[i].slot_item.view)
        slot_date[i].guid = nil
        slot_date[i].count = nil
        slot_date[i].slot_item:set_click_event(delete_item_cb_func)

    end

        --升级按钮
    local function cb_func(  )
        -- if KuaFuModel:FUNC_use_access_tip(1) == KuaFuModel.FUNC_FORBID_USE then
        --     return true
        -- end
        SkillMiJiModel:req_hecheng_miji( slot_date )
        self:clear_beibao_slot_state(  )
    end
    local btn = ZButton:create( xl_panel, {UILH_COMMON.button8,UILH_COMMON.button8}, cb_func,321, 30, 95, 40 )
    MUtils:create_zxfont(btn,"修炼",95/2,14,2,15);

        --说明按钮
    local btn = self:create_help_btn(  self.rt_xl_page.view ,4 )

    local not_miji_lab = UILabel:create_lable_2( "请先装备橙色秘籍", 430/2, 85,16,2)
    xl_panel_not_miji:addChild(not_miji_lab)

        --添加道具
    self.rt_xl_page.add_item= function(item_date,max_num,index)
        for i=1,3 do
          if not slot_date[i].guid then
             slot_date[i].slot_item:set_icon(item_date.item_id)
             slot_date[i].slot_item:set_item_count(item_date.count)
             slot_date[i].guid = item_date.series
             slot_date[i].count = item_date.count
             slot_date[i].index = index
             slot_date[i].item_date = item_date
             self.beibao_slot_state[index] = true
             xl_additem_cb_func(slot_date)

             return
          end
        end
        --已满 直接替换第三个
        GlobalFunc:create_screen_notic( "材料已满", 16, 300, 250 )
        -- slot_date[3].slot_item:set_icon(item_date.item_id)
        -- slot_date[3].slot_item:set_item_count(item_date.count)
        -- slot_date[3].guid = item_date.series
        -- slot_date[3].count = item_date.count
        -- slot_date[3].index = index
        --  slot_date[3].item_date = item_date
        -- xl_additem_cb_func(slot_date)
    end

    --清空道具
    self.rt_xl_page.clear_items = function(item_date)
        for i=1,3 do
             slot_date[i].slot_item:set_icon_ex()
             slot_date[i].slot_item:set_item_count(0)
             slot_date[i].guid =  nil
             slot_date[i].count = nil
             slot_date[i].index = nil
            slot_date[i].item_date = nil
        end
    end

    --未装备隐藏所有控件
    self.rt_xl_page.update_all = function(is_have_miji,date)
        --判断是否是顶级的
        local quality  = 1
        if date then
             quality = date.quality
        end
        if not is_have_miji or quality ~= 4 then
            xl_panel:setIsVisible(false)

            xl_panel_not_miji:setIsVisible(true)
        else
            xl_panel:setIsVisible(true)
            xl_panel_not_miji:setIsVisible(false)
            name_lab:setText(date.name)
            local chong_str = _num_text[date.chong]
            local ceng_str = nil
            if date.chong >= 9 then
                ceng_str = _num_text[date.chong]
            else
                ceng_str = _num_text[date.chong+1]
            end
            level_lab1:setText(chong_str)
            level_lab2:setText(ceng_str)
            recharge_bar.set_max_value(date.chong)
            recharge_bar.set_current_value(date.ceng)
            slot_item.set_base_date(date.id)
        end
        self.rt_xl_page.clear_items()
    end

        --更新经验 消耗铜币  等级
    self.rt_xl_page.update_exp_money_level = function(date)
        recharge_bar.set_current_value(date.value)
        local chong_str = _num_text[date.chong]
        level_lab2:setText(chong_str)
    end

    self.rt_xl_page.view:setIsVisible(false)
end

--切换背包显示页  
--num +1=下一页 或者 -1=上一页
local function change_bag_page( self,num)
    self.curr_bag_item_page = self.curr_bag_item_page + num
    self:update_beibao()
    -- update_bag( self,self.select_cheat,self.curr_page,self.curr_bag_item_page )
    -- check_bag_item_added(self,self.pages_t[self.curr_page])
end

--创建右边边下界面背包
function SkillMijiPage:create_miji_rigth_down()
    local  path =  UILH_COMMON.bottom_bg
    local rigth_down_panel = CCBasePanel:panelWithFile( 444, 13, 425, 245, nil,500,500)

    MUtils:create_zximg(rigth_down_panel,UILH_COMMON.bg_10,48,10,328,182)

    -- 标题
    local beibao_title = CCBasePanel:panelWithFile( 35, 245-49, 356, 49, UILH_NORMAL.title_bg7 )
    rigth_down_panel:addChild( beibao_title )
    MUtils:create_zxfont(beibao_title,Lang.bagInfo.beibao,356/2,18,2,16);  -- [18]="背包"

    --背包道具的左右翻页按钮
    self.left_bag_btn  = ZButton:create(rigth_down_panel, UILH_COMMON.page, bind(change_bag_page,self,-1), 0, 79)
    self.left_bag_btn:addImage(CLICK_STATE_DISABLE, UILH_COMMON.page_disable)
    self.right_bag_btn = ZButton:create(rigth_down_panel, UILH_COMMON.page, bind(change_bag_page,self,1),365, 79)
    self.right_bag_btn:addImage(CLICK_STATE_DISABLE, UILH_COMMON.page_disable)
    self.right_bag_btn.view:setFlipX(true)

    -- 背包道具格 
    self.item_slot_t = {}

    --格子的单击事件
    local function item_one_clicked ( slot_obj,a, b, arg )
        local click_pos = Utils:Split(arg, ":")
        local world_pos = slot_obj.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
        TipsModel:show_tip( world_pos.x, world_pos.y,slot_obj.item_data)
    end

    -- 背包物品格子的双击事件
    local function item_double_clicked ( self,i )
        if not SkillMiJiModel:user_item_cb_func(_curr_tab_btn_index) then
            return
        end

        if self.item_slot_t[i].item_data and self.item_slot_t[i].item_data.series then
            local item_index = (self.curr_bag_item_page-1)*ITEM_NUM_PER_PAGE+i
            if _curr_tab_btn_index == 1 then
                SkillMiJiModel:req_fudai_miji( self.item_slot_t[i].item_data.series )
            elseif _curr_tab_btn_index == 2 then
                self.rt_sj_page.add_item(self.item_slot_t[i].item_data,nil,item_index)
                self:set_beibao_item_Lock_state( item_index)
                -- page2_add_mater(self,i)
            elseif _curr_tab_btn_index == 3 then
                self.rt_xl_page.add_item(self.item_slot_t[i].item_data,nil,item_index)
                self:set_beibao_item_Lock_state( item_index)
                -- page3_add_mater(self,i)
            end
        else
            -- print("没道具")
        end
    end

    -- 起始坐标 列距 行距 
    local sx,sy,spx,spy = 63,110,14,20
    for i=1,ITEM_NUM_PER_PAGE do
        local temp_x = 0
        local temp_y = 0
        if i <= ITEM_NUM_PER_PAGE/2 then
            temp_x = sx + (i-1)*(spx+slotw)
            temp_y = sy 
        else
            temp_x = sx + (i-ITEM_NUM_PER_PAGE/2-1)*(spx+slotw)
            temp_y = sy - spy - sloth
        end
        self.item_slot_t[i] = MUtils:create_one_slotItem( nil, temp_x, temp_y,slotw,sloth)
        self.item_slot_t[i]:set_icon_bg_texture(UILH_COMMON.slot_bg,-8,-8,80,80)
        rigth_down_panel:addChild(self.item_slot_t[i].view)
        --这个类型就是 SlotItem
        self.item_slot_t[i]:set_click_event( bind(item_one_clicked,self.item_slot_t[i]) )
        -- self.item_slot_t[i].view:setEnableDoubleClick(true)
        self.item_slot_t[i]:set_double_click_event( bind(item_double_clicked,self,i) );
    end

    -- local function scroll_callback( index )
        -- return self:create_row_scroll_func(index)
    -- end

    -- self.beibao_scroll = MUtils:create_one_scroll(0, 20, 340, 125, 3, "", TYPE_HORIZONTAL, scroll_callback)
    -- rigth_down_panel:addChild(self.beibao_scroll)

    -- 背包没有道具时的提示
    -- self.null_beibao_lab = UILabel:create_lable_2( "", 215, 80,16,2)
    -- rigth_down_panel:addChild(self.null_beibao_lab)
    return rigth_down_panel
end

--创建scroll
function SkillMijiPage:create_row_scroll_func( index  )
    local  path =  UILH_COMMON.bottom_bg
    local scroll_panel = CCBasePanel:panelWithFile( 0, 5, 300, NOE_ROW_HITH, nil,500,500)
    local item_date_table = SkillMiJiModel:get_miji_beibao_date(  )

    local x = 1
    local y = 13

    for i=1,NOE_ROW_NUM do
        x = 23+(i-1)*60

        local item_index = (index-1)*NOE_ROW_NUM+ i
        local item_date = item_date_table[item_index]
        if item_date then

            local function user_item_cb_func(  )

                if not SkillMiJiModel:user_item_cb_func(_curr_tab_btn_index) then
                    return
                end
                if _curr_tab_btn_index == 1 then
                    SkillMiJiModel:req_fudai_miji( item_date.series )
                elseif _curr_tab_btn_index == 2 then
                    self.rt_sj_page.add_item(item_date,nil,item_index)
                    self:set_beibao_item_Lock_state( item_index)
                elseif _curr_tab_btn_index == 3 then
                    self.rt_xl_page.add_item(item_date,nil,item_index)
                    self:set_beibao_item_Lock_state( item_index)
                end

            end
            local function user_count_cb_func(  )
                num = 1
                -- local function split_cb_func(num)
                    self.rt_sj_page.add_item(item_date,num,item_index)
                    self.beibao_slot_state[item_index] = true
                    self:set_beibao_item_Lock_state( item_index)
                -- end
                -- SplitKeyboardWin:show( split_cb_func, item_date.count , nil )
            end 
            --单击回调
            local function click_cb_func(  )
                if _curr_tab_btn_index == 1 then
                    if  _curr_miji_is_zb then
                        TipsWin:showTip( 300,250,item_date,user_item_cb_func,nil, nil,nil,"替换")
                    else
                        TipsWin:showTip( 300,250,item_date,user_item_cb_func,nil, nil,nil,"装备")
                    end
                else
                    if item_date.count >1 then
                        TipsWin:showTip( 300,250,item_date,user_count_cb_func,nil, user_item_cb_func,nil,"使用","","使用全部")
                    else
                        TipsWin:showTip( 300,250,item_date,user_item_cb_func,nil, nil,nil,"使用")
                    end
                end
            end 
            --双击回调
            local function double_click_event( )
                -- if KuaFuModel:FUNC_use_access_tip(1) == KuaFuModel.FUNC_FORBID_USE then
                --     return 
                -- end
                user_item_cb_func()
            end

            self.beibao_slot_item[item_index] = MUtils:create_one_slotItem( item_date.item_id, x, y,45,45)
            self.beibao_slot_item[item_index]:set_item_count(item_date.count)
            scroll_panel:addChild( self.beibao_slot_item[item_index].view)
            self.beibao_slot_item[item_index]:set_click_event(click_cb_func)
            self.beibao_slot_item[item_index]:set_double_click_event( double_click_event )
            self:set_beibao_item_Lock_state( item_index )
        else
            break
        end
    end
    return scroll_panel
end

--锁定背包某个道具(index为某个道具在所有道具中的序号，有可能超过ITEM_NUM_PER_PAGE)
function SkillMijiPage:set_beibao_item_Lock_state( index )
    local page_index = index%ITEM_NUM_PER_PAGE;
    if page_index == 0 then
        page_index = 8;
    end
    if self.beibao_slot_state[index] then
        self.item_slot_t[page_index]:set_slot_disable(  )
        -- self.beibao_slot_item[index]:set_slot_disable(  )
    else
        self.item_slot_t[page_index]:set_slot_enable(  )
        -- self.beibao_slot_item[index]:set_slot_enable(  )
    end
end

--说明按钮创建
function SkillMijiPage:create_help_btn( parent,index )
       --说明按钮
    -- local function cb_func( eventType,x,y )
    --     if eventType == TOUCH_CLICK then
    --         local str = Lang.Miji[help[index]]
    --         local t_help_win = HelpPanel:show( 3, UILH_NORMAL.title_tips, str )
    --         t_help_win.exit_btn.view:setIsVisible(false)
    --     end
    --     return true
    -- end 
    -- MUtils:create_btn(parent,UILH_NORMAL.wenhao,
    --     UILH_NORMAL.wenhao,cb_func,245,140,-1,-1);


    --说明按钮
    local function help_btn_callback( ... )
        local str = Lang.Miji[help[index]]
        local t_help_win = HelpPanel:show( 3, UILH_NORMAL.title_tips, str )
        t_help_win.exit_btn.view:setIsVisible(false)
    end
    local help_panel = ZBasePanel:create( parent, "", 340, 154, 80, 40 )
    help_panel:setTouchClickFun(help_btn_callback)

    local help_btn = ZButton:create(help_panel, UILH_NORMAL.wenhao, help_btn_callback, 0, 0, -1, -1)
    local help_btn_size = help_btn:getSize()
    local help_img = ZImage:create(help_btn, UILH_NORMAL.shuoming, 0, 0, -1, -1 )
    local help_img_size = help_img:getSize()
    help_img:setPosition( help_btn_size.width, ( help_btn_size.height - help_img_size.height ) / 2 )
end

--创建切换按钮
function SkillMijiPage:create_tab_btn(  )
       -- tab 按钮
    local raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(0, 199, 325, 55,nil);
    -- MUtils:create_sprite(raido_btn_group,"ui/shenqi/shuxian.png", 88 , 15);
    -- MUtils:create_sprite(raido_btn_group,"ui/shenqi/shuxian.png", 177 , 15);

    self.tab_button_images = {}
    self.tab_button_images_light = {UILH_SKILL.fudai,UILH_SKILL.shengji,UILH_SKILL.xiulian}
    self.tab_button_images_gray = {UILH_SKILL.fudai_d,UILH_SKILL.shengji_d,UILH_SKILL.xiulian_d}
    for i=1,3 do
        local function btn_fun(eventType,args,msg_id)
            if eventType == TOUCH_CLICK then
                -- 刷新美术字状态
                if _curr_tab_btn_index ~= i then
                    for t=1,3 do
                        if t == i then
                            self.tab_button_images[t]:setTexture(self.tab_button_images_light[t])
                        else
                            self.tab_button_images[t]:setTexture(self.tab_button_images_gray[t])
                        end
                    end
                end

                -- 重置背包页数
                self.curr_bag_item_page = 1
                self:do_tab_button_method(i);
                self:clear_beibao_slot_state(  )
            end
            return true
        end
        local x = 110*(i-1);
        local y = 0;
    
        local btn = MUtils:create_radio_button(raido_btn_group,UILH_COMMON.button3,UILH_COMMON.button3_d,btn_fun,x,y,105,50,false)
        if i == 1 then
            self.tab_button_images[i] = CCZXImage:imageWithFile( 105/2, 50/2, -1, -1, self.tab_button_images_light[i] )
        else
            self.tab_button_images[i] = CCZXImage:imageWithFile( 105/2, 50/2, -1, -1, self.tab_button_images_gray[i] )
        end
        self.tab_button_images[i]:setAnchorPoint(0.5,0.5)
        btn:addChild(self.tab_button_images[i])
    end 

    return raido_btn_group
end

--页的切换
function SkillMijiPage:do_tab_button_method( index )
    
    _curr_tab_btn_index = index
    self.curr_rt_page:setIsVisible(false)
    --清楚背包选中状态
    self:clear_beibao_slot_state(  )

    if index == 1 then
        if _curr_miji_is_zb then
            self.curr_rt_page = self.rt_zhuanbei_page.view
        else
            self.curr_rt_page = self.rt_not_zhuanbei_page.view
        end
    elseif index == 2 then
        self.curr_rt_page = self.rt_sj_page.view
    elseif index == 3 then
        self.curr_rt_page =  self.rt_xl_page.view
    end
    self.curr_rt_page:setIsVisible(true)

    tab_btn_click_cb_fun(index)


end

--清空背包道具状态
function SkillMijiPage:clear_beibao_slot_state(  )
    self.beibao_slot_state = {}
end