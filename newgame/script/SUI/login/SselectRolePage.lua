-- SelectRolePage.lua
-- created by lyl on 2012-11-28
-- 角色选择窗口  select_role

require "UI/component/Window"
super_class.SelectRolePage(Window)

require "model/RoleModel"

require "SUI/login/SIntroducePanel"

RoleCard = simple_class()

local _create2Flow = effectCreator.create2Flow

-- 是否开启过珊彤
local guoshengtong = true

local job_desc_tab = {
    [1] = {
        [1] = "#cf6ebd6枪若游龙",
        [2] = "#cf6ebd6高攻高血爆发强",
    },
    [2] = {
        [1] = "#cf6ebd6剑若翩鸿",
        [2] = "#cf6ebd6攻防兼具灵活强",
    },
    [4] = {
        [1] = "#cf6ebd6扇影曼舞",
        [2] = "#cf6ebd6华丽飘逸群伤高",
    }
}



local JOB_HEAD = 
{
    [1] = { 
            'nopack/role/job1.png', 
            x = 131, y = 51,
            job_head =  'nopack/role/head1.png', 
            job_head_unselect = 'nopack/role/head1_unselect.png',
            job_name2 = 'sui/selectRole/name1.png',
            desc  = 'ui2/role/desc_0.png',
            sex_id = 0,  -- 男
            job_id = 1,  -- 职业
            actor_name = "刘秀",
          },  

    [2] = { --'nopack/body/21.png',
            'nopack/role/job2.png', 
            x = 250, y = 370,
            job_head =  'nopack/role/head2.png', 
            job_head_unselect = 'nopack/role/head2_unselect.png',
            job_name2 = 'sui/selectRole/name1.png',            
            desc  = 'ui2/role/desc_0.png',
            sex_id = 1,
            job_id = 2,
            actor_name = "阴丽华",
          },

    [3] = { --'nopack/body/31.png',
                'nopack/role/job2.png', 
            x = 250, y = 405,
            job_head =  'nopack/role/head1.png', 
            job_head_unselect = 'nopack/role/head1_unselect.png',
            job_name2 = 'sui/selectRole/name1.png',            
            desc  = 'ui2/role/desc_1.png',
            sex_id = 1,
            job_id = 3,
            actor_name = "阴丽华",
          },

    [4] = { --'nopack/body/40.png', 
                'nopack/role/job4.png', 
            x = 250, y = 324,
            job_head = 'nopack/role/head4.png',                                        
            job_name2 = 'sui/selectRole/name1.png',       
            job_head_unselect = 'nopack/role/head4_unselect.png',           
            desc  = 'ui2/role/desc_1.png',
            sex_id = 1,
            job_id = 4,
            actor_name = "过珊彤",
          },    






-- 未开放的过珊彤
 [5] = { --'nopack/body/40.png', 
                'nopack/role/job4.png', 
            x = 250, y = 324,
            job_head = 'nopack/role/head4_.png',                                        
            job_name2 = 'sui/selectRole/name1.png',       
            job_head_unselect = 'nopack/role/head4_unselect_.png',           
            desc  = 'ui2/role/desc_1.png',
            sex_id = 1,
            job_id = 4,
            actor_name = "敬请期待",
          },    





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

local _role_soundID = nil

local call_play_sound = nil

local curJobIndex = 1

function _sinOfScreenHeight(y)
    return _math_sin(3.14159625*(y/_screen_height)) * -90
end

function SelectRolePage:isVisible(if_show)
    self.view:setIsVisible(if_show)
end

-- 初始化
function SelectRolePage:__init( window_name, texture_name, is_grid, width, height )
    self.sex = 0       -- 选择的性别，默认为0（男）
    self.old_sex = 0   -- 原来的性别。用来判断是否要重新申请名称
    self.job = 0       -- 职业
    self.camp = 1      -- 阵营(当前已经没有了阵营这么个东西，但是给一个初始值，不然创建不了角色)
    self.focus_index = 3
    self.tipsCount = 0
    local headInfo = JOB_HEAD[1]

    self:create_bg()

    -- 角色选中框
    self.slt_blacks = {}
    self.slt_lights = {}
    self.slt_effect = {}
    self.job_name_sld = {}
    self.job_sname_sld = {}
    self.job_name_frame = {}
    self.job_name_frame2 = {}
    self.job_name_frame_select = {}
    self.job_name_bg = {}
    self.job_name_bg_select = {}
    self.job_head_grp = {}
    self.job_head_grp2 = {}
    self.job_name_bg2 = {}
    -- 过珊彤特效
    self.guo_effect_tab = {}


    -- 角色预览( 全身化形 )
    local body = CCSprite:spriteWithFile(JOB_HEAD[1][1])
    body:setAnchorPoint(CCPointMake(0, 0))
    self.view:addChild(body,100)
    -- body:setPosition(CCPointMake(_rx(280),340))
    body:setPosition(CCPointMake(_refWidth(0.5)-150,320))
    body:setScale(0.85)
    body:setTag(0)
    self.body = body

  


   self.ylh_p = {}
    --粒子特效 阴丽华背景
    local p1 = CCParticleSystemQuad:particleWithFile('particle/ylh_bg.plist')
    p1:setPosition(CCPointMake(200,500))
    self.view:addChild(p1)
    p1:setScale(2)
    self.ylh_p[1] = p1
    --粒子特效 阴丽华身后
    local p1 = CCParticleSystemQuad:particleWithFile('particle/ylh_houmian.plist')
    p1:setPosition(CCPointMake(_refWidth(0.5)-100,300))
    p1:setScale(1.5)
    self.view:addChild(p1)
    self.ylh_p[2] = p1
    --粒子特效 阴丽华身上
    local p1 = CCParticleSystemQuad:particleWithFile('particle/ylh_body.plist')
    p1:setPosition(CCPointMake(350,230))
    p1:setScale(1.5)
    self.body:addChild(p1,100)
    self.ylh_p[3] = p1


     self.lx_p = {}
    --粒子特效 刘秀背景
    local p1 = CCParticleSystemQuad:particleWithFile('particle/lx_bg.plist')
    p1:setPosition(CCPointMake(_refWidth(0.5),200))
    self.view:addChild(p1)
    -- self.body:addChild(p1)
    p1:setScale(1.5)
    self.lx_p[1] = p1
    --粒子特效 刘秀身上
    local p1 = CCParticleSystemQuad:particleWithFile('particle/lx_body.plist')
    p1:setPosition(CCPointMake(350,230))
    p1:setScale(1.5)
    self.body:addChild(p1,100)
    self.lx_p[2] = p1



   -- self:create_guoshengtong_effect()


    -- self:create_name_enter( role_bg )                  -- 改名(名称输入)
    self:create_name_enter(self.view)                  -- 改名(名称输入)


    RoleModel:apply_random_name( 0 )    -- 申请随机名称
    RoleModel:apply_random_job(  )   -- 申请随机名称

    --右边背景
    -- sui/selectRole/bg.png
    local right_bg = CCBasePanel:panelWithFile( _rx(960), 0 , 400, GameScreenConfig.ui_screen_height, "",500,500 )
    right_bg:setAnchorPoint(1.0,0)
    self.view:addChild(right_bg)

    -- 弧线~~
    local huxian = SImage:create("sui/selectRole/hudu.png")
    huxian.view:setPosition(CCPointMake(180 + 53, 15))
    right_bg:addChild(huxian.view)

    local win_height = GameScreenConfig.ui_screen_height
    -- local x = {620,640,640,620}
    local x = {185 + 40,15 + 120,640,185 + 40}
    local y = {3 / 4, 16 / 32, 1, 16 / 64}

    -- local y = win_width/2 + 230
    self.role_btn = {}
    for i=1, 4 do
        -- y = y - 120
        -- if i == 4 then
        --    y = win_width/2 + 230 - 380
        -- end
        local y_ = win_height * y[i] - 20
        -- self:create_role_slt_btn(right_bg,x[i]-580,y , 95,103, "", i)
       self.role_btn[i]= self:create_role_slt_btn(right_bg,x[i],y_ , 95,103, "", i)

    end
    local x = ((_rx(960) - 200) - (_refWidth(0.5)-150 ))/2 +_refWidth(0.5)-150 + 30
   self.jobdest_bg = SImage:create("sui/selectRole/renwushuoming.png")
    self.jobdest_bg:setAnchorPoint(0.5,0)
   self.jobdest_bg.view:setPosition(CCPointMake(x, 180))
   self.view:addChild(self.jobdest_bg.view,200)

    -- _rx(760) - _rx(640)
    -- -- 角色名字，竖起来的那个
    self.jobdest = SImage:create("sui/selectRole/job1.png")
    self.jobdest.view:setAnchorPoint(1, 0.5)
    -- self.jobdest.view:setPosition(CCPointMake(_rx(180), 280))
    self.jobdest.view:setPosition(CCPointMake(195, 280))
    self.jobdest_bg:addChild(self.jobdest.view)

    self.job_desc1 = SLabel:create(job_desc_tab[1][1], nil, nil, 2)
    self.job_desc1.view:setAnchorPoint(CCPointMake(0, 1))
    self.job_desc1.view:setPosition(109, 343)
    self.jobdest_bg:addChild(self.job_desc1.view)

    self.job_desc2 = SLabel:create(job_desc_tab[1][2], nil, nil, 2)
    self.job_desc2.view:setAnchorPoint(CCPointMake(0, 1))
    self.job_desc2.view:setPosition(73, 323)
    self.jobdest_bg:addChild(self.job_desc2.view)

    -- 返回登录 按钮事件 (选择服务器)
    local function select_server_but_CB(  )
        SoundManager:play_ui_effect( 4,false)        
        local login_info = RoleModel:get_login_info(  )
        SelectRoleCC:req_exit( login_info.server_id,login_info.user_name )
        --RoleModel:change_login_page("select_server")
        RoleModel:change_login_page("new_select_server_page")
        self:hide_to_left()
        if _role_soundID then
            AudioManager:stopEffect(_role_soundID)
            _role_soundID = nil
        end
        if call_play_sound then
            call_play_sound:cancel()
        end
    end

    local left_bottom_but = ZImageButton:create( self.view, 'sui/selectRole/back.png',
                                                  "", select_server_but_CB, 10, _ry(630) )
    left_bottom_but:setAnchorPoint(0,1)


    -- 开始游戏事件
    local function begin_but_CB(  )
        if not guoshengtong then
            if self.job == 4 then
                return
            end
        end

        --上次兼容很大问题加下log
        --print("响应按钮 开始游戏")
        SoundManager:play_ui_effect( 4,false)        
        local name = self.name_edit:getText()
        if self.name_edit:getCurTextNum() < 1 then
            ----print("字数少于3")  
            RoleModel:show_notice("#c4d2308名称字数少于1，请重新输入")
            return 
        end

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
            ----print('create char',name ,self.sex,self.job, self.camp)
            -- print("申请创建角色",name, self.sex, self.job, 1, self.camp)
            RoleModel:apply_create_one_role( name, self.sex, self.job, 1, self.camp )
        end

        if BISystem.actor_choice then
            BISystem:actor_choice()
        end
        if _role_soundID then
            AudioManager:stopEffect(_role_soundID)
            _role_soundID = nil
        end
        if call_play_sound then
            call_play_sound:cancel()
        end
    end
    local btn = ZButton:create( self.view, 'sui/selectRole/startBtn.png', 
                                    begin_but_CB, 
                                    _rx(792), 4)
    btn:setAnchorPoint(1.0,0)

    local spr = SEffectBuilder:create_a_effect( 74,-1,0 )
    spr:setPosition(78 ,75 - 2)
    spr:setScale(0.9)
    btn:addChild(spr)

    --粒子特效 头像按钮
    local p1 = CCParticleSystemQuad:particleWithFile('particle/select_role_head.plist')
    p1:setPosition(CCPointMake(500,300))
    right_bg:addChild(p1,100)
    self.head_p = p1

    --粒子特效
    -- local p1 = CCParticleSystemQuad:particleWithFile('particle/tianshangdexing.plist')
    -- p1:setPosition(CCPointMake(500,300))
    -- self.view:addChild(p1,100)

 


    local function cb()
        self:createIntroFunc()
    end

    -- local btnBg = SImage:create("sui/selectRole/introBtn.png")
    -- btnBg.view:setAnchorPoint(0.5, 1)
    -- btnBg.view:setPosition(_refWidth(0.35), _refHeight(1))
    -- -- btnBg:set_click_func(cb)
    -- self.view:addChild(btnBg.view)

    -- local posx = btnBg.view:getPositionX()

    self.introBtn = SButton:create("sui/selectRole/sanjiaoxing.png")
    self.introBtn.view:setAnchorPoint(0.5, 1)
    self.introBtn.view:setPosition(_refWidth(0.5)-110, _refHeight(1) + 7)
    self.introBtn:set_click_func(cb)
    -- self.view:addChild(self.introBtn.view)
    self.view:addChild(self.introBtn.view)

    --  不再发送255， 7（获取最少被创建的角色），默认选择职业一
    local job_index_tab = {[1] = 1, [2] = 2, [3] = 4}
    math.randomseed(os.time())
    local random = 1
    for k = 1, 5 do
        random = math.random() * 4
        if random < 1 then
            random = 1
        end
    end
    if job_index_tab[math.floor(random)] then
        self:select_job(job_index_tab[math.floor(random)])
    else
        self:select_job(job_index_tab[3])
    end

    -- self.image
end

-- 职业简介面板
function SelectRolePage:createIntroFunc()
    -- if curJobIndex == 1 then

    -- elseif curJobIndex == 2 then

    -- else

    -- end
    if not self.SIntroducePanel then
        self.SIntroducePanel = SIntroducePanel("intro_win", nil, nil, panelWidth, panelHeight, nil, "intro_win", curJobIndex)
        self.SIntroducePanel:update(curJobIndex)
        self.view:addChild(self.SIntroducePanel.view, 100000)
        self.SIntroducePanel:setSize(_refWidth(1) + 500, _refHeight(1))
        self.SIntroducePanel:action()
    else
        self.SIntroducePanel:update(curJobIndex)
        self.SIntroducePanel.view:setIsVisible(true)
        -- printc("curJobIndex==========", curJobIndex, 14)
        self.SIntroducePanel:action()
    end
    

end

--创建背景并适配
function SelectRolePage:create_bg()
    local panelWidth  = _refWidth(1.0)
    local panelHeight = _refHeight(1.0)

    self.bg = CCBasePanel:panelWithFile(panelWidth/2, panelHeight/2, -1, -1, "nopack/selectRoleBg1.jpg", 0, 0)
    self.bg:setAnchorPoint(0.5, 0.5)
    local size   = self.bg:getSize()
    local scalex = panelWidth/size.width
    local scaley = panelHeight/size.height
    local scale  = math.max(scalex, scaley)
    self.bg:setScale(scale)

    self.view:addChild(self.bg)
end



-- 创建一个按钮:参数： 要加入的panel， 坐标和长宽，按钮两种状态背景图，序列号（用于触发事件判断调用的方法）
function SelectRolePage:create_role_slt_btn(panel, pos_x, pos_y, size_w, size_h, image_n, but_index)
    -- if but_index

    -- if but_index then
    --     return
    -- end

    if not guoshengtong and but_index == 4 then
        but_index = 5
    end



    local role_btn = CCBasePanel:panelWithFile( pos_x, pos_y, size_w, size_h, image_n)
    
    -- local role_light = CCZXImage:imageWithFile( 14, 13, -1, -1, "ui2/role/lh_actor_slt.png" )
    -- role_btn:addChild( role_light )
  

    -- local role_black = CCZXImage:imageWithFile( 12, 13, -1, -1, "ui2/role/lh_actor_black.png")
    -- role_black:setScale(0.37)
    -- role_btn:addChild( role_black )
    -- self.slt_blacks[but_index] = role_black

    -- 创建名字背景

    self.job_name_bg[but_index] = CCZXImage:imageWithFile( 47, 63, -1, -1, "sui/selectRole/name.png")
    self.job_name_bg[but_index]:setAnchorPoint(0.5, 0.5)
    role_btn:addChild(self.job_name_bg[but_index])

    self.job_name_bg2[but_index] = CCZXImage:imageWithFile( 47, 63, -1, -1, "sui/selectRole/name.png")
    self.job_name_bg2[but_index]:setAnchorPoint(0.5, 0.5)
    role_btn:addChild(self.job_name_bg2[but_index])


    self.job_name_bg_select[but_index] = CCZXImage:imageWithFile( 47, 63, -1, -1, "sui/selectRole/select_name.png")
    self.job_name_bg_select[but_index]:setPositionX(67)
    self.job_name_bg_select[but_index]:setAnchorPoint(0.5, 0.5)
    role_btn:addChild(self.job_name_bg_select[but_index])

 -- self.job_head_grp2[i]:setScale(0.75)

    -- -- 角色选中框
    -- self.slt_lights[but_index] = CCZXImage:imageWithFile( -78, -16, -1, -1, "sui/selectRole/jobSelect.png" )
    -- name_bg:addChild( self.slt_lights[but_index] )
    -- print("做了create_role_slt_btn的粒子效果")
    -- --粒子特效
    -- self.slt_effect[but_index] = CCParticleSystemQuad:particleWithFile('particle/head.plist')
    -- self.slt_effect[but_index]:setPosition(CCPointMake(100,50))
    -- name_bg:addChild( self.slt_effect[but_index],100 )
    


    -- local namebg = SImage:create("sui/selectRole/unselect_namebg.png")


    -- -- self.job_sname_sld[but_index] = SImage:create(string.format("sui/selectRole/sname%d.png",but_index))
    -- self.job_sname_sld[but_index] = SLabel:create(JOB_HEAD[but_index].actor_name, 20, 3)
    -- self.job_sname_sld[but_index]:setPosition(50, 20)
    -- name_bg:addChild(self.job_sname_sld[but_index].view)

    -- self.job_name_sld[but_index] = CCZXImage:imageWithFile( 5, -5, -1, -1, "ui2/role/job_name_" .. but_index .. ".png")
    -- role_btn:addChild(self.job_name_sld[but_index])

    local posx, posy = self.job_name_bg[but_index]:getPosition()
    self.job_head_grp2[but_index] = CCZXImage:imageWithFile( 25,10, -1, -1, JOB_HEAD[but_index].job_head)
    self.job_head_grp2[but_index]:setAnchorPoint(0.5, 0.35)
    self.job_head_grp2[but_index]:setScale(0.75)
    self.job_head_grp2[but_index]:setPosition(posx + 5, posy)
    role_btn:addChild(self.job_head_grp2[but_index])


    -- 创建角色头像
    self.job_head_grp[but_index] = CCZXImage:imageWithFile( 25,10, -1, -1, JOB_HEAD[but_index].job_head_unselect)
    self.job_head_grp[but_index]:setAnchorPoint(0.5, 0.35)
    self.job_head_grp[but_index]:setScale(0.75)
    self.job_head_grp[but_index]:setPosition(posx + 5, posy)
    role_btn:addChild(self.job_head_grp[but_index])

    if but_index == 5 and not guoshengtong then
        local quest = SImage:create("sui/selectRole/quest.png")
        quest:setPosition(93, 53)
        self.job_head_grp[but_index]:addChild(quest.view)
    end


    self.job_name_frame[but_index] = SImage:create("sui/selectRole/unselect_namebg.png")
    self.job_name_frame[but_index].view:setAnchorPoint(0.5, 0.5)
    self.job_name_frame[but_index]:setPosition(110 - 7, 10)
    -- self.job_name_frame[but_index]:setPosition(0, 0)

    self.job_head_grp[but_index]:addChild(self.job_name_frame[but_index].view)


    -- self.job_name_frame2[but_index] = SImage:create("sui/selectRole/unselect_namebg.png")
    -- self.job_name_frame2[but_index].view:setAnchorPoint(0.5, 0.5)
    -- self.job_name_frame2[but_index]:setPosition(110, 10)
    -- self.job_head_grp[but_index]:addChild(self.job_name_frame2[but_index].view)


    self.job_name_frame_select[but_index] = SImage:create("sui/selectRole/select_namebg.png")
    self.job_name_frame_select[but_index].view:setAnchorPoint(0.5, 0.5)
    self.job_name_frame_select[but_index]:setPosition(105, 13 + 10)
    self.job_name_frame_select[but_index]:setIsVisible(false)
    self.job_head_grp2[but_index]:addChild(self.job_name_frame_select[but_index].view)



    -- 角色名称, 按钮上面横着的
    -- self.job_name_sld[but_index] = SImage:create(string.format("sui/selectRole/name%d.png",but_index))
    self.job_name_sld[but_index] =  SLabel:create(JOB_HEAD[but_index].actor_name, 20, 2)
    -- self.job_name_sld[but_index].view:setAnchorPoint(CCPointMake(0.5, 0.5))
    self.job_name_sld[but_index]:setPosition(50 - 2, 5 + 1)
    -- self.job_name_frame[but_index]:addChild(self.job_name_sld[but_index].view)
    role_btn:addChild(self.job_name_sld[but_index].view)

    if but_index == 5 and not guoshengtong then

        self.job_name_sld[but_index]:setScale(0.72)
        self.job_name_sld[but_index]:setPosition(46 - 1, 9)
          but_index = 4
    end


    -- printc("ddddddddddddddddd", JOB_HEAD[but_index].actor_name, but_index, 3)

  -- 刚开始的时候显示角色1的选中框，把其他的选中框隐藏掉
    if but_index ~= 1 then
        -- self.slt_lights[but_index]:setIsVisible(false)
        -- self.slt_effect[but_index]:setIsVisible(false)
        -- self.job_sname_sld[but_index]:setIsVisible(false)
    else
        -- self.job_name_sld[but_index]:setIsVisible(false)
    end

    local function slt_role_btn_fun(eventType, arg, msgid, selfitem)
        if eventType == nil or arg == nil or msgid == nil or selfitem == nil then
            return
        end
        if eventType == TOUCH_BEGAN then
            --根据序列号来调用方法
            -- local job_id = 1
            -- printc("but_index", curJobIndex, 13)
            if but_index == curJobIndex then
                return true
            end

            if not guoshengtong then
                if but_index ~= 4 then
                    SoundManager:play_ui_effect( 4,false)
                    self:select_job( but_index)
                end
            else
                SoundManager:play_ui_effect( 4,false)
                self:select_job( but_index)
            end

            return true
        elseif eventType == TOUCH_CLICK then
            return true
        end
        return true
    end

    role_btn:registerScriptHandler( slt_role_btn_fun )  --注册
    panel:addChild( role_btn, 20 )


    -- 只有三个职业，注释第三个
    if but_index == 3 then
        role_btn:setIsVisible(false)
    end


    return role_btn
end



function SelectRolePage:update_role_btn_sld( but_index )
  
    -- print("做了SelectRolePage:update_role_btn_sld", but_index)

    -- if but_index == curJobIndex then
    --     return
    -- end


    local serverId = RoleModel:get_log_server_id()
    local job = nil
    if but_index == 1 then
        job = "刘秀"
    elseif but_index == 2 then
        job = "阴丽华"
    elseif but_index == 3 then
        job = "灵狐"
    else
        job = "过珊彤"
    end

   
    -- self.server_name:setText("当前选区："..tostring(serverId).."-"..job)

    for i=1, #self.job_name_sld do
    --     self.slt_lights[i]:setIsVisible(false)
    --     self.slt_effect[i]:setIsVisible(false)
        self.job_name_sld[i]:setText("#cf3d579"..JOB_HEAD[i].actor_name)
        self.job_name_sld[i]:setFontSize(20)
    
        self.job_name_bg[i]:setIsVisible(true)
        self.job_name_bg_select[i]:setIsVisible(false)
        -- self.job_name_frame_select[i]:setIsVisible(false)

        -- self.job_name_bg[but_index]:setIsVisible(false)
        -- self.job_name_bg_select[but_index]:setIsVisible(true)

        self.job_name_frame[i]:setIsVisible(true)
        -- self.job_name_frame2[i]:setIsVisible(true)
        -- self.job_name_frame2[i].view:setColor( 0xc0010101)
        self.job_name_frame_select[i]:setIsVisible(false)

        -- self.job_name_bg[i]:setTexture("sui/selectRole/name.png")
        -- self.job_name_frame[i]:setTexture("sui/selectRole/unselect_namebg.png")
        -- self.job_name_frame[i]:setIsVisible(false)

        self.job_head_grp2[i]:setScale(0.75)
        self.job_head_grp2[i]:setIsVisible(true)
        
        self.job_head_grp[i]:setScale(0.75)
        -- self.job_head_grp[i]:setColor( 0xc0000000)
        self.job_head_grp[i]:setIsVisible(true)




        -- self.job_name_bg2[i]:setIsVisible(true)
        -- self.job_name_bg2[i]:setColor( 0xc0010101)

        -- self.job_sname_sld[i]:setIsVisible(false)
    end
    -- self.slt_lights[but_index]:setIsVisible(true)
    -- self.slt_effect[but_index]:setIsVisible(true)
    -- self.job_sname_sld[but_index]:setIsVisible(true)
    self.job_name_sld[but_index]:setText("#cffffff"..JOB_HEAD[but_index].actor_name)
    local x, y = self.job_name_sld[but_index].view:getPosition()
    self.job_name_sld[but_index].view:setPositionX(48 - 3)
    self.job_name_sld[but_index]:setFontSize(24)

    -- self.job_name_frame[but_index]:setTexture("sui/selectRole/select_namebg.png")
    self.job_name_frame[but_index]:setIsVisible(false)
    -- self.job_name_frame2[but_index]:setIsVisible(false)
    self.job_name_frame_select[but_index]:setIsVisible(true)

    self.job_name_bg[but_index]:setIsVisible(false)
    self.job_name_bg2[but_index]:setIsVisible(false)
    self.job_name_bg_select[but_index]:setIsVisible(true)
    self.job_head_grp[but_index]:setScale(0.85)

    self.job_head_grp2[but_index]:setScale(0.85)
    self.job_head_grp[but_index]:setIsVisible(false)


    self.job_desc1:setText(job_desc_tab[but_index][1])
    self.job_desc2:setText(job_desc_tab[but_index][2])

    self.bg:setTexture(string.format("nopack/selectRoleBg%d.jpg", but_index))


     local p_x,p_y = self.role_btn[but_index]:getPosition()
     self.head_p:setPosition(p_x+40, p_y+20 )
end
-- 角色选择 end
-- =====================================

function SelectRolePage:change_role_model_and_info( but_index )
    self.body:replaceTexture( JOB_HEAD[but_index][1] )
   
    for i=1,#self.ylh_p do
        self.ylh_p[i]:setIsVisible(false)
    end
    for i=1,#self.lx_p do
        self.lx_p[i]:setIsVisible(false)
    end
    for k, v in pairs(self.guo_effect_tab) do
        v:setIsVisible(false)
    end
    if self.wuqi_effect then
        self.wuqi_effect:setIsVisible(false)
    end
    if self.wuqi_effect_lx then
        self.wuqi_effect_lx:setIsVisible(false)
    end
    if self.bianzhi_effect then
        self.bianzhi_effect:setIsVisible(false)
    end
     if self.yaodai_effect then
        self.yaodai_effect:setIsVisible(false)
    end

    self.body:setPosition(CCPointMake(0,320))
    self.body:stopAllActions()
    local moveTo1 = CCMoveTo:actionWithDuration(0.3, CCPointMake(_refWidth(0.5)-150,320) ) -- -334.5
    self.body:runAction(moveTo1)
    
    if but_index == 1 then
       if not self.wuqi_effect_lx then
            --刘秀特效
            local spr4 = SEffectBuilder:create_a_effect(79,-1,0)
            spr4:setPosition(158,188)
            spr4:setScale(0.85)
            self.body:addChild(spr4)
            self.wuqi_effect_lx = spr4
            self.wuqi_effect_lx:setIsVisible(false)
             printc("but_index", but_index, spr4, 13)
            -- self.body:setPosition( CCPointMake(_rx(280), 340) )
            -- self.body:stopAllActions()

            -- local function cb()
            --     local repeatAction = self:get_float_action()
            --     self.body:stopAllActions()
            --     self.body:runAction(repeatAction)
            --     self.timer:stop()
            --     self.timer = nil
            -- end

            -- if self.timer then
            --     self.timer:stop()
            --     self.timer = nil
            -- end
            -- self.timer = timer()
            -- self.timer:start(0.3, cb)
           
            for i=1,#self.lx_p do
                self.lx_p[i]:setIsVisible(true)
            end
            self.wuqi_effect_lx:setIsVisible(true)
        else
            self:setEffectVisible(1)
        end

        local function cb()
            local repeatAction = self:get_float_action()
            self.body:stopAllActions()
            self.body:runAction(repeatAction)
            self.timer:stop()
            self.timer = nil
        end

        if self.timer then
            self.timer:stop()
            self.timer = nil
        end
        self.timer = timer()
        self.timer:start(0.3, cb)
    else
        -- self.body:stopAllActions()
        --阴丽华特效
        if but_index == 2 then
            printc("but_index", but_index, 13)
            -- --阴丽华特效
            -- local spr1 = SEffectBuilder:create_a_effect(75,-1,0)
            -- spr1:setPosition(167,332)
            -- self.body:addChild(spr1)
            -- self.wuqi_effect = spr1
            -- self.wuqi_effect:setIsVisible(false)
            -- local spr2 = SEffectBuilder:create_a_effect(77,-1,0)
            -- spr2:setPosition(233,345)
            -- self.body:addChild(spr2)
            -- self.bianzhi_effect = spr2
            -- self.bianzhi_effect:setIsVisible(false)
            -- local spr3 = SEffectBuilder:create_a_effect(78,-1,0)
            -- spr3:setPosition(205,213)
            -- self.body:addChild(spr3)
            -- self.yaodai_effect = spr3
            -- self.yaodai_effect:setIsVisible(false)


            -- self.wuqi_effect:setIsVisible(true)
            -- self.bianzhi_effect:setIsVisible(true)
            -- self.yaodai_effect:setIsVisible(true)
            -- for i=1,#self.ylh_p do
            --     self.ylh_p[i]:setIsVisible(true)
            -- end
            if not self.bianzhi_effect then
                self:create_female_effect()
            else
                self:setEffectVisible(2)
            end
        else
            printc("but_index", but_index, 13)
            -- for i=1,#self.ylh_p do
            --     self.ylh_p[i]:setIsVisible(true)
            -- end
            if not self.guo_left_curtains_l then
                self:create_guoshengtong_effect()
            else
                self:setEffectVisible(4)
            end
        end
        -- local float_action = self:get_float_action()
        -- local sequence = CCSequence:actionOneTwo(action, float_action)
        -- self.body:runAction(sequence)



        local function cb()
            local repeatAction = self:get_float_action()
            self.body:stopAllActions()
            self.body:runAction(repeatAction)
            self.timer:stop()
            self.timer = nil
        end

        if self.timer then
            self.timer:stop()
            self.timer = nil
        end
        self.timer = timer()
        self.timer:start(0.3, cb)



    end

    self.jobdest:setTexture(string.format("sui/selectRole/job%d.png",but_index))
end

function SelectRolePage:create_female_effect()
    --阴丽华特效
    local spr1 = SEffectBuilder:create_a_effect(75,-1,0)
    spr1:setPosition(167,332)
    self.body:addChild(spr1)
    self.wuqi_effect = spr1
    self.wuqi_effect:setIsVisible(false)
    local spr2 = SEffectBuilder:create_a_effect(77,-1,0)
    spr2:setPosition(233,345)
    self.body:addChild(spr2)
    self.bianzhi_effect = spr2
    self.bianzhi_effect:setIsVisible(false)
    local spr3 = SEffectBuilder:create_a_effect(78,-1,0)
    spr3:setPosition(205,213)
    self.body:addChild(spr3)
    self.yaodai_effect = spr3
    self.yaodai_effect:setIsVisible(false)


    self.wuqi_effect:setIsVisible(true)
    self.bianzhi_effect:setIsVisible(true)
    self.yaodai_effect:setIsVisible(true)
    for i=1,#self.ylh_p do
        self.ylh_p[i]:setIsVisible(true)
    end
end

-- 创建名称输入
function SelectRolePage:create_name_enter( role_bg )

  
    local input_bg = CCBasePanel:panelWithFile(_refWidth(0.5)-380, 32, 405, -1, 'sui/selectRole/input.png',500,500)   
    -- local input_bg = CCBasePanel:panelWithFile(137, 32, 405, -1, 'sui/selectRole/input.png',500,500)   
    input_bg:setFlipX(true)
    role_bg:addChild( input_bg )

    self.name_edit = CCZXAnalyzeEditBox:editWithFile( _refWidth(0.5)-350, 32, 405, 45, "", 6, 24, EDITBOX_TYPE_NORMAL, 500, 500)
    self.name_edit:setInputColor("#cfff2dc")
    role_bg:addChild( self.name_edit,1)
    self.name_edit:setCenter(true)
    local function edit_box_function(eventType, arg, msgid)
        if eventType == nil or arg == nil or msgid == nil then
            return true
        end
        if eventType == KEYBOARD_CONTENT_TEXT then
            printc("1", 3)
        elseif eventType == KEYBOARD_FINISH_INSERT then
            KeyBoardModel:hide_keyboard()
        elseif eventType == TOUCH_BEGAN then
                        printc("3", 3)
        elseif eventType == KEYBOARD_ENTER then
                printc("aa", 3)
        elseif eventType == KEYBOARD_ATTACH then
            printc("bb", 3)
            -- ZXLuaUtils:SendRemoteDebugMessage(self.edit_box:getText())
        elseif eventType == KEYBOARD_CLICK then
            -- printc("cc", 3)
            local name = self.name_edit:getText( )
            local flag = string.find(name,"~")
            if flag ~=nil then
                 name = string.gsub(name,"~","")
                 self.name_edit:setText(name )
                 self:create_notice(2)
            end
            printc("当前字数", self.name_edit:getCurTextNum(),name, 14)
            if tonumber(self.name_edit:getCurTextNum()) >= 6 then
                printc("给了提示", 14)
                -- GlobalFunc:create_screen_notic("最多只能输入6个中文字符"); -- 
                -- RoleModel:show_notice("最多只能输入6个中文字符")
                self:create_notice(1)
            end
        elseif eventType == KEYBOARD_WILL_SHOW then
            -- local temparg = Utils:Split(arg,":")
            -- local keyboard_width = tonumber(temparg[1])
            -- local keyboard_height = tonumber(temparg[2])
            -- self:keyboard_will_show( keyboard_width, keyboard_height ) 
        elseif eventType == KEYBOARD_WILL_HIDE then
            -- local temparg = Utils:Split(arg,":")
            -- local keyboard_width = tonumber(temparg[1])
            -- local keyboard_height = tonumber(temparg[2])
            -- self:keyboard_will_hide( keyboard_width, keyboard_height )
        end
        return true
    end

    self.name_edit:registerScriptHandler(edit_box_function)
    local function dice_but_CB(  )
        SoundManager:play_ui_effect( 4,false)        
        RoleModel:apply_random_name( self.sex )
    end
    
    local btn = ZButton:create( role_bg, 'sui/selectRole/touzi.png', 
                                dice_but_CB, 
                                _refWidth(0.5)-362, 22, -1, -1, 1)

end

-- 选择按钮的回调
-- sex 1:女, 2:男 job:1(天雷),2(蜀山),3(圆月),4(云华)
function SelectRolePage:select_but_callback_func( index )
    if index > 0 and index < 5 then
        self:set_sex( JOB_HEAD[index].sex_id )
        self:set_job( JOB_HEAD[index].job_id )
        return
    end
   
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
    curJobIndex = job_id

    self:update_role_btn_sld( job_id )  -- UI
    self:select_but_callback_func( job_id )
    self:change_role_model_and_info( job_id )

    ----------------音效----------------------
    if call_play_sound then
        call_play_sound:cancel()
    end
    call_play_sound = callback:new()
    local function play_sound_func()
        self:play_sound_effect()
    end
    call_play_sound:start(0.3, play_sound_func)
end

-- 更新
function SelectRolePage:play_sound_effect()
    if _role_soundID then
        AudioManager:stopEffect(_role_soundID)
        _role_soundID = nil
    end
    local indx = math.random(1,2)
    _role_soundID = SoundManager:play_role_effect(curJobIndex, indx, false)  
end

-- 更新
function SelectRolePage:update( update_type )   

    if update_type == "name" then
        self:update_name(  )
    elseif update_type == "random_role" then
        local job_id = RoleModel:get_random_job(  )
        -- local job_id = 1
        if self.job ~= job_id then
            self:select_job( job_id )
        end
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
        ----print("-self.camp:", self.camp)
        -- if self.camp == 0 then
        --     RoleModel:apply_random_camp(  )
        -- else
        --     -- 重置并更新ui
        --     self:select_but_callback_func( 100 + self.camp )  
        -- end
    end
end

-- 更新名称
function SelectRolePage:update_name(  )
    local random_name = RoleModel:get_random_name(  )
    random_name = string.gsub(random_name,"~","")
    self.name_edit:setText( random_name )
end

-- 隐藏  
function SelectRolePage:hide_to_left( show_type )
    self.view:setIsVisible(false)
end

-- 显示
function SelectRolePage:show_to_center( show_type )
    ----x--print('SelectRolePage:show_to_center')
    LoginWin.whiteSpotAnimation(self.view:getParent())

    self.view:setIsVisible(false)
    local delay = CCDelayTime:actionWithDuration(1.0)
    local array = CCArray:array()
    array:addObject(delay)
    array:addObject(CCShow:action())
    local seq = CCSequence:actionsWithArray(array)
    self.view:runAction(seq)
end



-- 销毁
function SelectRolePage:destroy(  )
    ----print("SelectRolePage:destroy(  )......................")
    if self.timer_camp then
        self.timer_camp:stop()
        self.timer_camp = nil
    end
    if self.timer then
        self.timer:stop()
        self.timer = nil
    end
    self:hide_keyboard()
    if self.move_timer then
        self.move_timer:stop()
    end
    if self.gravity_timer then
        self.gravity_timer:stop()
    end
    Window.destroy(self)

    curJobIndex = 1
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
        self.name_edit:detachWithIME()
    end
end

function SelectRolePage:change_serverId(serverId)
    -- for k = 1, 10 do
    --     printc("sssssss", 13)
    -- end
    -- self.server_name:setText("当前选区："..tostring(serverId).."-刘秀剑霜")
end

function SelectRolePage:get_float_action()
  -- 测试浮动需求
    local moveTo1 = CCMoveBy:actionWithDuration(0.95, CCPointMake(0, 10) ) -- -334.5
    local act_eas_ltt1 = CCEaseSineIn:actionWithAction(moveTo1)
    -- local act_eas_ltt1 = CCEaseBackInOut:actionWithAction(moveTo1)
    
    local moveTo2 = CCMoveBy:actionWithDuration(0.95, CCPointMake(0, -10) )
    local act_eas_ltt2 = CCEaseSineIn:actionWithAction(moveTo2)
    -- local act_eas_ltt2 = CCEaseBackInOut:actionWithAction(moveTo2)

    local sequence = CCSequence:actionOneTwo(act_eas_ltt1, act_eas_ltt2)
    local repeatAction = CCRepeatForever:actionWithAction(sequence)

    return repeatAction
end

function SelectRolePage:create_notice(type)
    self.tipsCount = self.tipsCount + 1
    local winSize = ZXgetWinSize()
    local panel = SPanel:create("sui/common/diwen.png",300,25 )
    panel.view:setAnchorPoint(0.5, 0)
    panel.view:setPosition(winSize.width / 2, 200)
    self.view:addChild(panel.view, 1000)
    local label = nil
    if type ==1 then
        label = SLabel:create("最多只能输入6个中文字符", 16, 2)
    else
        label = SLabel:create("不能使用非法字符", 16, 2)
    end
        label.view:setPosition(150, 3)
        panel:addChild(label.view)
    local move = CCMoveBy:actionWithDuration( 2 ,CCPoint(0,200) );
    panel.view:runAction(move)

    local function cb()
        panel:removeFromParentAndCleanup(true)
    end

    -- local timer = timer()
    -- timer:start(self.gatherTime +1, dismiss)

    local delay = CCDelayTime:actionWithDuration(2)
    local arr = CCArray:array()
    local callfunc = CocosUtils.createCCCallFunc(cb)
    arr:addObject(delay)
    arr:addObject(callfunc)
    local seq = CCSequence:actionsWithArray(arr)
    panel:runAction(seq)
end

function SelectRolePage:create_guoshengtong_effect()
    -- 过珊彤页面的所有特效

    local bgSize = self.bg:getSize()

    -- 过珊彤背景窗帘特效
    self.guo_left_curtains_l = SEffectBuilder:create_a_effect(86,-1,0)
    self.guo_left_curtains_l:setAnchorPoint(CCPointMake(0, 1))
    self.guo_left_curtains_l:setFlipX(true)
    self.guo_left_curtains_l:setPosition(_refWidth(0.0), _refHeight(1.05))
    self.bg:addChild(self.guo_left_curtains_l)
    -- self.guo_left_curtains_l:setIsVisible(false)
    self.guo_effect_tab[1] = self.guo_left_curtains_l

    self.guo_left_curtains_b = SEffectBuilder:create_a_effect(85,-1,0)
    self.guo_left_curtains_b:setAnchorPoint(CCPointMake(0, 1))
    self.guo_left_curtains_b:setFlipX(true)
    self.guo_left_curtains_b:setPosition(_refWidth(0.0), _refHeight(1.05))
    self.bg:addChild(self.guo_left_curtains_b)
    -- self.guo_left_curtains_b:setIsVisible(false)
    self.guo_effect_tab[2] = self.guo_left_curtains_b


    self.guo_right_curtains_l = SEffectBuilder:create_a_effect(86,-1,0)
    self.guo_right_curtains_l:setAnchorPoint(CCPointMake(0, 1))
    self.guo_right_curtains_l:setPosition(_refWidth(0.9), _refHeight(1.05))
    self.bg:addChild(self.guo_right_curtains_l)
    self.guo_effect_tab[3] = self.guo_right_curtains_l

    -- self.guo_right_curtains_l:setIsVisible(false)


    self.guo_right_curtains_b = SEffectBuilder:create_a_effect(85,-1,0)
    self.guo_right_curtains_b:setAnchorPoint(CCPointMake(0, 1))
    self.guo_right_curtains_b:setPosition(_refWidth(0.75), _refHeight(1.05))
    self.bg:addChild(self.guo_right_curtains_b)
    self.guo_effect_tab[4] = self.guo_right_curtains_b

    -- self.guo_right_curtains_b:setIsVisible(false)


    self.guo_denglong_left = SEffectBuilder:create_a_effect(87,-1,0)
    self.guo_denglong_left:setAnchorPoint(CCPointMake(0, 1))
    self.guo_denglong_left:setPosition(bgSize.width * 0.095, bgSize.height * 0.97)
    self.bg:addChild(self.guo_denglong_left)
    self.guo_effect_tab[5] = self.guo_denglong_left

    -- self.guo_denglong_left:setIsVisible(false)


    self.guo_denglong_right = SEffectBuilder:create_a_effect(87,-1,0)
    self.guo_denglong_right:setAnchorPoint(CCPointMake(0, 1))
    self.guo_denglong_right:setPosition(bgSize.width * 0.92, bgSize.height * 0.97)
    self.bg:addChild(self.guo_denglong_right)
    self.guo_effect_tab[6] = self.guo_denglong_right

    -- self.guo_denglong_right:setIsVisible(false)


    local bodySize = self.body:getContentSize()

    self.guo_shanzi_left = SEffectBuilder:create_a_effect(89,-1,0)
    self.guo_shanzi_left:setAnchorPoint(CCPointMake(0, 1))
    self.guo_shanzi_left:setPosition(bodySize.width * 0.0, bodySize.height * 0.63)
    self.body:addChild(self.guo_shanzi_left)
    self.guo_effect_tab[7] = self.guo_shanzi_left

    -- self.guo_shanzi_left:setIsVisible(false)


    self.guo_shanzi_right = SEffectBuilder:create_a_effect(88,-1,0)
    self.guo_shanzi_right:setAnchorPoint(CCPointMake(0, 1))
    self.guo_shanzi_right:setPosition(bodySize.width * 0.67, bodySize.height * 0.75)
    self.body:addChild(self.guo_shanzi_right)
    self.guo_effect_tab[8] = self.guo_shanzi_right

    -- self.guo_shanzi_right:setIsVisible(false)


    self.guo_lizi_effect = CCParticleSystemQuad:particleWithFile('particle/guo_lizi_effect.plist')
    self.guo_lizi_effect:setPosition(CCPointMake(bodySize.width * 0.5,bodySize.height * 0.5))
    self.body:addChild(self.guo_lizi_effect,100)
    self.guo_effect_tab[9] = self.guo_lizi_effect

    self.ylh_p[1]:setIsVisible(true)
    -- self.guo_lizi_effect:setIsVisible(false)
end

function SelectRolePage:setEffectVisible(index)
    for k, v in pairs(self.guo_effect_tab) do
        v:setIsVisible(false)
    end
    for i=1,#self.ylh_p do
        self.ylh_p[i]:setIsVisible(false)
    end
    for i=1,#self.lx_p do
        self.lx_p[i]:setIsVisible(false)
    end
    if self.wuqi_effect then
        self.wuqi_effect:setIsVisible(false)
    end
    if self.wuqi_effect_lx then
        self.wuqi_effect_lx:setIsVisible(false)
    end
    if self.bianzhi_effect then
        self.bianzhi_effect:setIsVisible(false)
    end
     if self.yaodai_effect then
        self.yaodai_effect:setIsVisible(false)
    end

    -- if self.guo_shanzi_left then
    --     self.guo_shanzi_left:setIsVisible(false)
    -- end

    if index == 1 then
        for i=1,#self.lx_p do
            self.lx_p[i]:setIsVisible(true)
        end
        if self.wuqi_effect_lx then
            self.wuqi_effect_lx:setIsVisible(true)
        end
    elseif index == 2 then
        for i=1,#self.ylh_p do
            self.ylh_p[i]:setIsVisible(true)
        end
        if self.wuqi_effect then
            self.wuqi_effect:setIsVisible(true)
        end
        if self.bianzhi_effect then
            self.bianzhi_effect:setIsVisible(true)
        end
         if self.yaodai_effect then
            self.yaodai_effect:setIsVisible(true)
        end
    else
        for k, v in pairs(self.guo_effect_tab) do
            v:setIsVisible(true)
        end
        self.ylh_p[1]:setIsVisible(true)
    end
end