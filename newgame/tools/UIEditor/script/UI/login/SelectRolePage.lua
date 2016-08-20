-- SelectRolePage.lua
-- created by lyl on 2012-11-28
-- 角色选择窗口  select_role

require "UI/component/Window"
super_class.SelectRolePage(Window)

require "model/RoleModel"

RoleCard = simple_class()

local _create2Flow = effectCreator.create2Flow

local JOB_HEAD = 
{
    [1] = { 'nopack/body/10.png', x = 360, y = 324,
            body_scale = 0.91,
            title = "ui2/role/lh_name_1.png",
            job_1   = 'ui2/role/card_10_s.png',
            desc  = 'ui2/role/desc_0.png',
            intro_desc = Lang.Login.intro_desc[1],
            sex_id = 0,  -- 男
            job_id = 1,  -- 职业
            six_wei = {[1]="ui2/role/lh_attr_1.png", [2]= {x=48, y=70} },-- 6维图
            effect_path = "frame/effect/login/11030",

            effect2 = {path = "frame/effect/login/11040",x = 190, y = 390, frames = 6,scale = 2}
          },  

    [2] = { 'nopack/body/21.png', x = 480, y = 370,
            body_scale = 0.91,
            title = "ui2/role/lh_name_2.png",
            job_1 = 'ui2/role/card_21_s.png',
            desc  = 'ui2/role/desc_0.png',
            intro_desc = Lang.Login.intro_desc[2],
            sex_id = 1,
            job_id = 2,
            six_wei = {[1]="ui2/role/lh_attr_2.png", [2]= {x=65, y=75}},-- 6维图
            effect_path = "frame/effect/login/11031",

            effect2 = {path = "frame/effect/login/11044",x = 480, y = 247, frames = 8,scale = 2}
          },

    [3] = { 'nopack/body/31.png', x = 466, y = 405,
            body_scale = 0.91,
            title = "ui2/role/lh_name_3.png",
            job_1 = 'ui2/role/card_31_s.png',
            desc  = 'ui2/role/desc_1.png',
            intro_desc = Lang.Login.intro_desc[3],
            sex_id = 1,
            job_id = 3,
            six_wei = {[1]="ui2/role/lh_attr_3.png", [2]= {x=78, y=38}},-- 6维图
            effect_path = "frame/effect/login/11032",

            effect2 = {path = "frame/effect/login/11046",x = 395, y = 533, frames = 8,scale = 2}
          },

    [4] = { 'nopack/body/40.png', x = 485, y = 324,
            body_scale = 0.88,
            title = "ui2/role/lh_name_4.png",
            job_1 = "ui2/role/card_40_s.png",
            desc  = 'ui2/role/desc_1.png',
            intro_desc = Lang.Login.intro_desc[4],
            sex_id = 0,
            job_id = 4,
            six_wei = {[1]="ui2/role/lh_attr_4.png", [2]= {x=84, y=77}},-- 6维图
            effect_path = "frame/effect/login/11033",

            effect2 = {path = "frame/effect/login/11043",x = 300, y = 575, frames = 8,scale = 1}
          },    
}

-- 阵营图标
local camp_ui = {
    [1] = { "ui2/role/lh_camp_1.png", "ui2/role/lh_camp_1_s.png" },
    [2] = { "ui2/role/lh_camp_2.png", "ui2/role/lh_camp_2_s.png" },
    [3] = { "ui2/role/lh_camp_3.png", "ui2/role/lh_camp_3_s.png" }
}

local _math_sin = math.sin
local _screen_height = GameScreenConfig.ui_screen_height
local _card_start_x = 240
local _card_start_y = 63
local _card_gap = 103
local _card_half_height = 53
local _card_focus_pos_y = 0
local _math_abs = math.abs
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _rx = UIScreenPos.designToRelativeWidth
local _ry = UIScreenPos.designToRelativeHeight

function _sinOfScreenHeight(y)
    return _math_sin(3.14159625*(y/_screen_height)) * -90
end

-- 初始化
function SelectRolePage:__init( window_name, texture_name, is_grid, width, height )
    self.sex = 0       -- 选择的性别，默认为0（男）
    self.old_sex = 0   -- 原来的性别。用来判断是否要重新申请名称
    self.job = 0       -- 职业
    self.camp = 0      -- 阵营
    self.focus_index = 3
    local headInfo = JOB_HEAD[1]

    -- 六位图
    self.six_wei_sld = nil

    -- 渐变背景(黑圆)
    self.bg_left = CCBasePanel:panelWithFile( 480, 0, _refWidth(1.0), _refHeight(1.0), "nopack/lh_black_bg.png" )
    self.bg_left:setFlipX( true )
    self.bg_left:setAnchorPoint(1, 0)
    self.view:addChild( self.bg_left )
    self.bg_right = CCBasePanel:panelWithFile( 480, 0, _refWidth(1.0), _refHeight(1.0), "nopack/lh_black_bg.png" )
    self.bg_right:setAnchorPoint(0, 0)
    self.view:addChild( self.bg_right )

    -- 角色选中框
    self.slt_blacks = {}
    self.slt_lights = {}
    self.job_name_sld = {}

    -- 角色预览( 全身化形 )
    local body = CCSprite:spriteWithFile(JOB_HEAD[1][1]);
    body:setScale(JOB_HEAD[1].body_scale)
    self.view:addChild(body)
    body:setPosition(CCPointMake(_rx(500),324))
    body:setTag(0)
    self.body = body

    -- 添加放大缩小的效果
    local act_1 = CCScaleTo:actionWithDuration(1.5, JOB_HEAD[1].body_scale)
    local act_2 = CCScaleTo:actionWithDuration(1.5, JOB_HEAD[1].body_scale-0.1)
    local array = CCArray:array();
    array:addObject(act_1);
    array:addObject(act_2);
    local seq = CCSequence:actionsWithArray(array);
    local act_repeat = CCRepeatForever:actionWithAction(seq);
    self.body:runAction(act_repeat)
    
    self:create_select_camp_list(  )            -- 阵营选择列表
    -- self:create_new_cards( self.view )          -- 天将雄狮角色选择
    self:create_name_enter(  )                  -- 改名(名称输入)

    RoleModel:apply_random_name( 0 )    -- 申请随机名称

    -- 底部部分
    self.panel_bottom = CCBasePanel:panelWithFile(_rx(480), 0, 960, 200, "")
    self.panel_bottom:setAnchorPoint(0.5, 0)
    self.view:addChild( self.panel_bottom)

    -- 大底图
    self.big_bottom_l = CCZXImage:imageWithFile( 480, 0 , -1, -1, "ui2/role/lh_half_bttm.png" )
    self.panel_bottom:addChild( self.big_bottom_l )
    self.big_bottom_l:setAnchorPoint(1, 0)
    self.big_bottom_r = CCZXImage:imageWithFile( 480, 0, -1, -1, "ui2/role/lh_half_bttm.png" )
    self.big_bottom_r:setFlipX( true ) 
    self.big_bottom_r:setAnchorPoint(0, 0)
    self.panel_bottom:addChild( self.big_bottom_r )
    -- 宝石
    self.gem = CCZXImage:imageWithFile( 480, 88, -1, -1, "ui2/role/lh_blue_gem.png" )
    self.gem:setAnchorPoint( 0.5, 0 )
    self.panel_bottom:addChild( self.gem )
    -- 宝石的边框
    self.gem_frame_l = CCZXImage:imageWithFile( 480-5, 78, -1, -1, "ui2/role/lh_gem_frame.png" )
    self.gem_frame_l:setAnchorPoint( 1, 0)
    self.panel_bottom:addChild( self.gem_frame_l )
    self.gem_frame_r = CCZXImage:imageWithFile( 480+5, 78, -1, -1, "ui2/role/lh_gem_frame.png" )
    self.gem_frame_r:setAnchorPoint(0, 0)
    self.gem_frame_r:setFlipX( true )
    self.panel_bottom:addChild( self.gem_frame_r )


    -- 创建4个选角btn-- 天将雄狮角色选择
    local pos_temp = { {204, 57} , {313, 78}, {550, 78}, {664, 57} }
    for i=1, 4 do
        self:create_role_slt_btn(self.panel_bottom, pos_temp[i][1], pos_temp[i][2], -1, -1, JOB_HEAD[i].job_1, i)
    end

    -- 龙2
    local long1 = CCZXImage:imageWithFile( _rx(0), 0 , -1, -1, 'ui2/role/lh_dragon_2.png', -1, -1 )
    self.view:addChild( long1 )
    long1:setAnchorPoint( 0, 0)
    long1:setFlipX( true)
    long1:setScale(0.8)
    local long2 = CCZXImage:imageWithFile( _rx(960), 0 , -1, -1, 'ui2/role/lh_dragon_2.png', -1, -1 )
    self.view:addChild( long2 )
    long2:setAnchorPoint( 1, 0)

    -- 职业介绍 ==========================================================
    self.panel_intro = CCBasePanel:panelWithFile( _rx(675), _ry(243), 270, 420, "" )
    self.view:addChild( self.panel_intro )

    -- 职业介绍模糊背景
    local smooth_bg = CCBasePanel:panelWithFile( 8, 14, -1, -1, "ui2/role/lh_intro_bg.png")
    self.panel_intro:addChild(smooth_bg)

    -- 115, 25
    local intro_up_left = CCZXImage:imageWithFile( 0, 315, -1, -1, "ui2/role/lh_split_u.png" )
    intro_up_left:setFlipX(true)
    self.panel_intro:addChild( intro_up_left )
    local intro_up_right = CCZXImage:imageWithFile( 270-115, 315, -1, -1, "ui2/role/lh_split_u.png" )
    self.panel_intro:addChild( intro_up_right )

    local intro_middle = CCZXImage:imageWithFile( 0, 315-85, -1, -1, "ui2/role/lh_split_m.png" )
    self.panel_intro:addChild( intro_middle )

    local intro_bttm = CCZXImage:imageWithFile( 42, 0, -1, -1, "ui2/role/lh_split_b.png" )
    self.panel_intro:addChild( intro_bttm )

    -- 职业介绍标题（改为 “刀”）(73,73)
    self.intro_title = CCZXImage:imageWithFile( 272*0.5, 305, -1, -1, "ui2/role/lh_name_1.png" )
    self.intro_title:setAnchorPoint(0.5, 0)
    self.panel_intro:addChild( self.intro_title )

    -- ("刀"上的特效)
    self.effect_sprite = effectCreator.createEffect_animation(JOB_HEAD[1].effect_path, 0.125,-1, -1)
    self.effect_sprite:setPosition(73*0.5, 73*0.5)
    self.intro_title:addChild(self.effect_sprite)
    -- LuaEffectManager:play_view_effect( 30002,0,0,self.intro_title,true,-1 )

    if JOB_HEAD[1].effect2 then
        self.effect_sprite2 = effectCreator.createEffect_animation(JOB_HEAD[1].effect2.path, 1.0/JOB_HEAD[1].effect2.frames,-1,-1)
        self.effect_sprite2:setPosition(JOB_HEAD[1].effect2.x, JOB_HEAD[1].effect2.y)
        self.effect_sprite2:setScale(JOB_HEAD[1].effect2.scale)
        self.body:addChild(self.effect_sprite2)
    end

    -- 职业介绍说明
    self.intro_desc_1 = UILabel:create_lable_2( LH_COLOR[5] .. JOB_HEAD[1].intro_desc[1], 272*0.5, 282, 16, ALIGN_CENTER ) 
    self.panel_intro:addChild( self.intro_desc_1 )

    self.intro_desc_2 = UILabel:create_lable_2( LH_COLOR[5] .. JOB_HEAD[1].intro_desc[2], 272*0.5, 258, 16, ALIGN_CENTER ) 
    self.panel_intro:addChild( self.intro_desc_2 )

    -- self.intro_desc_3 = UILabel:create_lable_2( LH_COLOR[5] .. JOB_HEAD[1].intro_desc[3], 214*0.5-7, 255-135, 16, ALIGN_CENTER ) 
    -- self.panel_intro:addChild( self.intro_desc_3 )

    -- 六位图 210, 210
    self.six_wei = CCBasePanel:panelWithFile(33, 21, -1, -1, "ui2/role/lh_attr_bg.png")
    self.panel_intro:addChild(self.six_wei)

    self.six_wei_cont = CCBasePanel:panelWithFile(105, 105, 210, 210, "")
    self.six_wei:addChild(self.six_wei_cont)
    self.six_wei_cont:setAnchorPoint(0.5,0.5)
    self.six_wei_sld = CCBasePanel:panelWithFile(JOB_HEAD[1].six_wei[2].x, JOB_HEAD[1].six_wei[2].y, -1, -1, JOB_HEAD[1].six_wei[1])
    self.six_wei_cont:addChild(self.six_wei_sld)

    -- 最后
    -- self.intro_desc = CCDialogEx:dialogWithFile( 90, 310, 110, 40, 15, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    -- self.intro_desc:setAnchorPoint(0,1);
    -- self.intro_desc:setFontSize(15);
    -- self.intro_desc:setText( LH_COLOR[5] .. JOB_HEAD[1].intro_desc[4] );  
    -- self.intro_desc:setTag(0)
    -- self.intro_desc:setLineEmptySpace (5)
    -- self.panel_intro:addChild(self.intro_desc)


    -- 返回登录 按钮事件 (选择服务器)
    local function select_server_but_CB(  )
        local login_info = RoleModel:get_login_info(  );
        SelectRoleCC:req_exit( login_info.server_id,login_info.user_name )
        RoleModel:back_to_select_server(  )
        RoleModel:update_role_win( "server_list" )

    end
    local left_bottom_but = ZImageButton:create( self.view, 'ui2/role/lh_start.png',
                                                  "", select_server_but_CB, 2, 0 )
    left_bottom_but.view:setFlipX( true)
    left_bottom_but.view:setScale( 0.8)
    local img_back_word = CCBasePanel:panelWithFile(55, 20, -1, -1, "ui2/role/role_back.png")
    left_bottom_but:addChild( img_back_word)

    -- 开始游戏事件
    local function begin_but_CB(  )
        if BISystem.actor_choice then
            BISystem:actor_choice()
        end
        local name = self.name_edit:getText()
        if name == nil or name == "" then
            PopupNotify(ZXLogicScene:sharedScene():getUINode(), 
                1024,  { Lang.Login.null_name },  -- [1351]="输入了非法字符"
                LangGameString[793], nil, -- [793]="确定"
                 1, 
                 function() end )
            return
        end        
        if ChatModel:safe_check_sharp(name) == true then
            PopupNotify(ZXLogicScene:sharedScene():getUINode(), 
                1024,  { LangGameString[1351] },  -- [1351]="输入了非法字符"
                LangGameString[793], nil, -- [793]="确定"
                 1, 
                 function() self.name_edit:setText("") end )
        else
            print('create char',self.sex,self.job)
            RoleModel:apply_create_one_role( name, self.sex, self.job, 1, self.camp )
        end
    end
    local btn = ZButton:create( self.view, 'ui2/role/lh_start.png', 
                                    begin_but_CB, 
                                    _rx(960), 0)
    btn:setAnchorPoint(1.0,0)
    local img_start_word = CCBasePanel:panelWithFile(75, 25, -1, -1, "ui2/role/role_start.png")
    btn.view:addChild( img_start_word)

    --给开始按钮添加特效
    btn.effect_light = effectCreator.createEffect_animation( "frame/effect/login/11047", 0.125, -1, -1)
    btn.effect_light:setPosition(210*0.5, 78*0.5)
    -- btn.effect_light:setScale(1)
    btn.view:addChild( btn.effect_light)

    local function self_view_func( eventType )
        self:hide_keyboard()
        return true
    end
    self.view:registerScriptHandler(self_view_func)
end

-- 阵营选择
function SelectRolePage:create_select_camp_list(  )
    -- 阵营选择标志
    -- self.camp_slt_signs = {}

    -- 阵营图片名字
    self.camp_name_not_t = {}
    self.camp_name_sld_t = {}

    -- 坐标
    local radio_x     = 30              -- 全部单选区域坐标
    local but_beg_y   = 215              -- 按钮起始y坐标
    local but_int_x   = 35              -- 按钮x坐标间隔
    self.panel_camp_slt = CCBasePanel:panelWithFile( radio_x, but_beg_y, 270, 400, "")
    self.view:addChild( self.panel_camp_slt,20)

    -- 添加阵营title
    self.camp_title = CCBasePanel:panelWithFile( 75, 380, -1, -1, "ui2/role/title_zhenying.png" )
    self.panel_camp_slt:addChild(self.camp_title)

    -- 分割线
    local line_1 = CCZXImage:imageWithFile( 27, 360, -1, -1, "ui2/role/lh_introduce_up.png" )
    self.panel_camp_slt:addChild(line_1)

    local line_2 = CCZXImage:imageWithFile( 58, 155, -1, -1, "ui2/role/lh_introduce_bttm.png" )
    self.panel_camp_slt:addChild(line_2)

    local x_t = { 00, 180, 95 }
    local y_t = { 250, 250, 175 }
    local x_t_s = { -13, -14, -13}
    local y_t_s = { -13, -14, -14}
    local btn_w = 100
    for i = 1, 3 do         -- 3个阵营
        local btn_camp = CCBasePanel:panelWithFile( x_t[i], y_t[i], btn_w, 100, "" )
        self.panel_camp_slt:addChild( btn_camp )
        local function select_fun_2(eventType,x,y)
            if eventType == TOUCH_BEGAN then
                return true
            elseif eventType == TOUCH_CLICK then
                self:select_but_callback_func( 100 + 4 - i )
                return true
            elseif eventType == TOUCH_ENDED then
                return true
            end
        end
        btn_camp:registerScriptHandler( select_fun_2 )

        -- 阵营图片名称 (66, 21) (161, 40)
        local camp_name_not = CCZXImage:imageWithFile( 0, 0, -1, -1, camp_ui[i][1] )
        btn_camp:addChild( camp_name_not )
        self.camp_name_not_t[i] = camp_name_not
        local camp_name_sld = CCZXImage:imageWithFile( x_t_s[i], y_t_s[i], -1, -1, camp_ui[i][2] )
        btn_camp:addChild( camp_name_sld )
        self.camp_name_sld_t[i] = camp_name_sld

        -- -- 添加选择标志
        -- local camp_path = "ui2/role/lh_camp_bg_1.png"
        -- if i == 3 then
        --     camp_path = "ui2/role/lh_camp_bg_1.png"
        -- elseif i == 2 then
        --     camp_path = "ui2/role/lh_camp_bg_2.png"
        -- elseif i == 1 then
        --     camp_path = "ui2/role/lh_camp_bg_3.png"
        -- end
        -- local slt_sign = CCZXImage:imageWithFile( btn_w*0.5-63.5, 2, -1, -1, camp_path )
        -- btn_camp:addChild( slt_sign, -2 )
        -- self.camp_slt_signs[i] = slt_sign

        -- 阵营诗句
        self.camp_words = {}
    end    
end

-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，序列号（用于触发事件判断调用的方法）
function SelectRolePage:create_role_slt_btn(panel, pos_x, pos_y, size_w, size_h, image_n, but_index)

    local role_btn = CCBasePanel:panelWithFile( pos_x, pos_y, size_w, size_h, "ui2/role/lh_actor_frame.png" )
    if image_n ~= nil then
        local role_portrait = CCZXImage:imageWithFile( 15, 12 , -1, -1, image_n )
        role_portrait:setScale(0.9)
        role_btn:addChild( role_portrait )
    end
    local role_light = CCZXImage:imageWithFile( 14, 13, -1, -1, "ui2/role/lh_actor_slt.png" )
    role_btn:addChild( role_light )
    local role_black = CCZXImage:imageWithFile( 12, 13, -1, -1, "ui2/role/lh_actor_black.png")
    role_black:setScale(0.37)
    role_btn:addChild( role_black )
    self.slt_blacks[but_index] = role_black

    self.slt_lights[but_index] = CCZXImage:imageWithFile( -4, -6, -1, -1, "ui2/role/slt_light.png" )
    role_btn:addChild( self.slt_lights[but_index] )

    self.job_name_sld[but_index] = CCZXImage:imageWithFile( 5, -5, -1, -1, "ui2/role/job_name_" .. but_index .. ".png")
    role_btn:addChild(self.job_name_sld[but_index])

    local function slt_role_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            --根据序列号来调用方法
            -- local job_id = 1
            self:select_job( but_index )
            return true
        elseif eventType == TOUCH_CLICK then
            return true;
        end
        return true;
    end

    role_btn:registerScriptHandler( slt_role_btn_fun )  --注册
    panel:addChild( role_btn, 2 )

    return role_btn
end

function SelectRolePage:update_role_btn_sld( but_index )
    for i=1, #self.slt_blacks do
        self.slt_blacks[i]:setIsVisible(true)
    end
    self.slt_blacks[but_index]:setIsVisible(false)

    for i=1, #self.slt_lights do
        self.slt_lights[i]:setIsVisible(false)
    end
    self.slt_lights[but_index]:setIsVisible(true)

    for i=1, #self.job_name_sld do
        self.job_name_sld[i]:setTexture("ui2/role/job_name_" .. i .. ".png")
    end
    self.job_name_sld[but_index]:setTexture("ui2/role/job_name_" .. but_index .. "_s.png")
end
-- 角色选择 end
-- =====================================

function SelectRolePage:change_role_model_and_info( but_index )
    self.body:replaceTexture( JOB_HEAD[but_index][1] )
    self.body:setScale(JOB_HEAD[but_index].body_scale)
    self.body:setPosition( CCPointMake(_rx(JOB_HEAD[but_index].x), JOB_HEAD[but_index].y) )
    -- self.desc:replaceTexture( JOB_HEAD[but_index].desc )
    self.intro_title:setTexture( JOB_HEAD[but_index].title )
    self.intro_desc_1:setString( LH_COLOR[5] .. JOB_HEAD[but_index].intro_desc[1] ) 
    self.intro_desc_2:setString( LH_COLOR[5] .. JOB_HEAD[but_index].intro_desc[2] ) 
    -- self.intro_desc_3:setString( LH_COLOR[5] .. JOB_HEAD[but_index].intro_desc[3] ) 
    -- self.intro_desc:setText( LH_COLOR[5] .. JOB_HEAD[but_index].intro_desc[4] )
    -- 6维图
    if self.six_wei_sld then
        self.six_wei_sld:removeFromParentAndCleanup(true)
        self.six_wei_sld = nil
        self.six_wei_cont:removeFromParentAndCleanup(true)
        self.six_wei_cont = nil
    end
    self.six_wei_cont = CCBasePanel:panelWithFile(105, 105, 210, 210, "")
    self.six_wei_cont:setAnchorPoint(0.5, 0.5)
    self.six_wei:addChild(self.six_wei_cont)
    self.six_wei_sld = CCBasePanel:panelWithFile(JOB_HEAD[but_index].six_wei[2].x, JOB_HEAD[but_index].six_wei[2].y, -1, -1, JOB_HEAD[but_index].six_wei[1])
    self.six_wei_cont:addChild(self.six_wei_sld)
    self.six_wei_cont:setScale(0.1)
    local scale_action = CCScaleTo:actionWithDuration(0.5,1.0)
    self.six_wei_cont:runAction(scale_action)

    -- 特效("刀"上的特效)
    if self.effect_sprite then
        self.effect_sprite:removeFromParentAndCleanup(true)
        self.effect_sprite = nil
    end
    self.effect_sprite = effectCreator.createEffect_animation(JOB_HEAD[but_index].effect_path, 0.125,-1, -1)
    self.effect_sprite:setPosition(73*0.5, 73*0.5)
    self.intro_title:addChild(self.effect_sprite)

    if self.effect_sprite2 then
        self.effect_sprite2:removeFromParentAndCleanup(true)
        self.effect_sprite2 = nil
    end
    if JOB_HEAD[but_index].effect2 then
        self.effect_sprite2 = effectCreator.createEffect_animation(JOB_HEAD[but_index].effect2.path, 1.0/JOB_HEAD[but_index].effect2.frames,-1,-1)
        self.effect_sprite2:setPosition(JOB_HEAD[but_index].effect2.x, JOB_HEAD[but_index].effect2.y)
        self.effect_sprite2:setScale(JOB_HEAD[but_index].effect2.scale)
        self.body:addChild(self.effect_sprite2)
    end
end

-- 创建名称输入
function SelectRolePage:create_name_enter(  )

    -- 玩家昵称title
    local mini_name = CCZXImage:imageWithFile( _rx(410), 28, -1, -1, 'ui2/role/lh_name_title.png' )
    self.view:addChild( mini_name, 1 )
    mini_name:setAnchorPoint(1.0, 0)

    -- 输入框
    local input_bg = CCBasePanel:panelWithFile(_rx(425), 24, -1, -1, 'ui2/role/lh_name_input.png')
    --CCZXImage:imageWithFile( _rx(373), 24 , -1, -1, 'ui2/role/role_name_frame.png', -1, -1 )
    self.view:addChild( input_bg , 100)

    self.name_edit = CCZXEditBox:editWithFile( 10, 5, 165, 32, "", 6, 20, EDITBOX_TYPE_NORMAL, 500, 500)
    input_bg:addChild( self.name_edit)
    local function edit_box_function(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return true
        end
        if eventType == KEYBOARD_CONTENT_TEXT then
            
        elseif eventType == KEYBOARD_FINISH_INSERT then
            self:hide_keyboard()
        elseif eventType == TOUCH_BEGAN then
            -- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
        elseif eventType == KEYBOARD_WILL_SHOW then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_show( keyboard_width, keyboard_height ); 
        elseif eventType == KEYBOARD_WILL_HIDE then
            local temparg = Utils:Split(arg,":");
            local keyboard_width = tonumber(temparg[1])
            local keyboard_height = tonumber(temparg[2])
            self:keyboard_will_hide( keyboard_width, keyboard_height );
        end
        return true
    end
    self.name_edit:registerScriptHandler(edit_box_function)
    -- 骰子
    local function dice_but_CB(  )
        RoleModel:apply_random_name( self.sex )
    end
    
    local btn = ZButton:create( self.view, 'ui2/role/lh_dice.png', 
                                dice_but_CB, 
                                _rx(425)+185, _rx(24), -1, -1, 1)

    local function f1(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_CLICK then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        end
    end
    input_bg:registerScriptHandler(f1)
end

-- 选择按钮的回调
-- sex 1:女, 2:男 job:1(天雷),2(蜀山),3(圆月),4(云华)
function SelectRolePage:select_but_callback_func( index )
    if index > 0 and index < 5 then
        self:set_sex( JOB_HEAD[index].sex_id )
        self:set_job( JOB_HEAD[index].job_id )
        return
    end

    if index > 100 then
        for j=1, 3 do
            -- self.camp_slt_signs[j]:setIsVisible(false)
            self.camp_name_not_t[j]:setIsVisible(true)
            self.camp_name_sld_t[j]:setIsVisible(false)
        end
        -- self.camp_slt_signs[104-index]:setIsVisible(true)
        self.camp_name_not_t[104-index]:setIsVisible(false)
        self.camp_name_sld_t[104-index]:setIsVisible(true)

        if index == 101 then         -- 逍鸿儒
            self:set_camp( 1 )
            print("-------------1---神武")
        elseif index == 102 then     -- 天机
            self:set_camp( 2 )
            print("-------------2---天机")
        elseif index == 103 then     -- 神武
            self:set_camp( 3 )
            print("-------------3---鸿儒")
        elseif index == 104 then     
            self:set_camp( 4 )
        end
    end

    -- 诗句特效
    self:create_words_effect(index-100)
   
end

-- 诗句特效
function SelectRolePage:create_words_effect( camp_id )
    if self.timer_camp then
        self.timer_camp:stop()
        self.timer_camp = nil
    end
    for i=1, #self.camp_words do
        if self.camp_words[i] then
            self.camp_words[i]:removeFromParentAndCleanup(true)
            self.camp_words[i] = nil
        end
    end
    local word_path = "ui2/role/han_"
    if camp_id == 1 then
        word_path = "ui2/role/han_"
    elseif camp_id == 2 then
        word_path = "ui2/role/luo_"
    elseif camp_id == 3 then
        word_path = "ui2/role/xiong_"
    end

    self.timer_camp = timer()
    local i = 0;
    local function timer_camp_func( )
        i = i+1
        -- self.camp_words[i] = CCZXImage:imageWithFile( 0, 190-i*35 , -1, -1, word_path .. i .. ".png" )
        self.camp_words[i] = MUtils:create_sprite( self.panel_camp_slt, word_path .. i .. ".png", 270*0.5, 170-i*40 )
        -- self.panel_camp_slt:addChild(self.camp_words[i])
        self.camp_words[i]:setOpacity(0)
        local fadeIn = CCFadeIn:actionWithDuration(1.0)
        self.camp_words[i]:runAction( fadeIn )
        if i == 4 then
            self.timer_camp:stop()
            self.timer_camp = nil
        end
    end
    timer_camp_func()
    self.timer_camp:start(0.5, timer_camp_func)
end

-- 设置性别  0 ： 男   1 女
function SelectRolePage:set_sex( sex_index )
    -- 如果性别改变了，重新申请名称
    if self.old_sex ~= sex_index then
        RoleModel:apply_random_name( sex_index )
    end
    self.sex = sex_index
    self.old_sex = self.sex
end

-- 设置职业  0:通用、1：天雷、2：蜀山、3： 圆月 、4：云华
function SelectRolePage:set_job( job_index )
    self.job = job_index
end

-- 设置阵营   1 逍遥 2 星辰  3  逸仙
function SelectRolePage:set_camp( camp_index )
    self.camp = camp_index
end

-- 初始化选择
function SelectRolePage:select_job( job_id )
    self:update_role_btn_sld( job_id )
    self:select_but_callback_func( job_id )
    self:change_role_model_and_info( job_id )
end

-- function SelectRolePage:select_camp( btn_id )
--      self:select_but_callback_func( btn_id )
-- end

-- 更新
function SelectRolePage:update( update_type )
    if update_type == "name" then
        self:update_name(  )
    elseif update_type == "random_role" then
        local job_id = RoleModel:get_random_job(  )
        -- local job_id = 1;
        self:select_job( job_id )
    elseif update_type == "random_camp" then
        local camp_id = RoleModel:get_random_camp()
        -- self.camp_radio_group:selectItem( camp_id-1 )
        self:select_but_callback_func( 100 + camp_id )
    elseif update_type == "all" then
        -- 初始化为0，控制第一次的时候请求
        if self.job == 0 then
            RoleModel:apply_random_job()
        else
            -- 重置并更新ui
            self:select_job( self.job )                 
        end
        print("-self.camp:", self.camp)
        if self.camp == 0 then
            RoleModel:apply_random_camp(  )
        else
            -- 重置并更新ui
            self:select_but_callback_func( 100 + self.camp )  
        end
    end
end

-- 更新名称
function SelectRolePage:update_name(  )
    local random_name = RoleModel:get_random_name(  )
    self.name_edit:setText( random_name )
end

-- 隐藏  
function SelectRolePage:hide_to_left( show_type )
    self.view:setIsVisible(false)
end

-- 显示
function SelectRolePage:show_to_center( show_type )
    --xprint('SelectRolePage:show_to_center')
    LoginWin.whiteSpotAnimation(self.view:getParent())

    self.view:setIsVisible(false)
    local delay = CCDelayTime:actionWithDuration(1.0)
    local array = CCArray:array();
    array:addObject(delay)
    array:addObject(CCShow:action());
    local seq = CCSequence:actionsWithArray(array);
    self.view:runAction(seq)
end

function SelectRolePage:TouchBegin( x, y )
    self.touchbegin_x = x
    self.touchbegin_y = y
    self.last_x = x
    self.last_y = y
    self.move_timer:stop()
    self.gravity_timer:stop()
    self.touchclock = os.clock()
    self.touch_panel:setEnableHitTest(true)
    return true
end

function SelectRolePage:TouchMove( x, y )
    local dy = y - self.last_y
    self.last_y = y

    local max_dist = 15
    if dy >= max_dist then
        dy = max_dist
    elseif dy <= -max_dist then
        dy = -max_dist
    end
    self:_move(dy)
    self.touch_panel:setEnableHitTest(false)
    self.last_dy = dy
    return true
end

function SelectRolePage:TouchEnd( x, y )
    self.touch_panel:setEnableHitTest(true)
    -- 获取加速度
    -- 修正结果
    local movement = 0
    local touchtime = 0
    if self.touchbegin_y then
        movement = y - self.touchbegin_y
    end
    if self.touchclock then
        touchtime = os.clock() - self.touchclock
    end
    local dst = math.abs(movement)
    if touchtime < 0.5 and dst > 64 then
        --print(movement)
        local timepassed = 0
        touchtime = touchtime * 3.0
        self.gravity_timer:start(0,
        function(dt) 
            timepassed = timepassed + dt
            local t = math.min(1.0,timepassed / touchtime)
            if t == 1.0 then
                self.gravity_timer:stop()
                --self:correct_card_position()
            else 
                local _tc = math.cos(math.pi * 0.5 * t)
                --print()
                self:_move( _tc * self.last_dy )
            end
        end)
    else
        --self:correct_card_position()
    end
    return true
end

-- 销毁
function SelectRolePage:destroy(  )
    print("SelectRolePage:destroy(  )......................")
    if self.timer_camp then
        self.timer_camp:stop()
        self.timer_camp = nil
    end
    self:hide_keyboard()
    if self.move_timer then
        self.move_timer:stop()
    end
    if self.gravity_timer then
        self.gravity_timer:stop()
    end

    Window.destroy(self)
end


------------------弹出/关闭 键盘时将整个chatWin的y坐标的调整
-- 键盘的事件
function SelectRolePage:keyboard_will_show( keyboard_w, keyboard_h )
    self.keyboard_visible=true
    local pos = self.view:getPositionS()
    if pos.x == 0 then
        if keyboard_h == 162 then
            self.view:setPosition(pos.x, 310)
            
        elseif keyboard_h == 198 then
            self.view:setPosition(pos.x, 310+42)

        elseif keyboard_h == 352 then 
            self.view:setPosition(pos.x, 310)

        elseif keyboard_h == 406 then 
            self.view:setPosition(pos.x, 310+42)

        end
    end
end

function SelectRolePage:keyboard_will_hide( keyboard_w, keyboard_h )
    self.keyboard_visible=false
    local pos = self.view:getPositionS()
    if pos.x == 0 then
        self.view:setPosition(pos.x,0)
    end
end

function SelectRolePage:hide_keyboard(  )
    if self.name_edit and self.keyboard_visible then
        self.name_edit:detachWithIME();
    end
end
