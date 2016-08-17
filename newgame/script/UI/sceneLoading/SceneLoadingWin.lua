--SceneLoading.lua
--过场景加载界面

require "UI/component/Window"
require "utils/UI/UILabel"

super_class.SceneLoadingWin(Window)

local loadingsteps  = {}
local _instance     = nil   --单例
local _need_call    = false --是否需要回调通知场景管理
local _screenWidth  = GameScreenConfig.ui_screen_width
local _screenHeight = GameScreenConfig.ui_screen_height
local list_desc = {
-- [0 ] = {"正在初始化引擎..."},
-- [5 ] = {"正在预加载UI..."},
-- [12] = {"正在构建地图..."},
-- [35] = {"正在加载角色..."},
-- [44] = {"正在加载武器换装..."},
-- [57] = {"正在加载技能特效..."},
-- [64] = {"正在加载坐骑..."},
-- [72] = {"正在加载宠物..."},
-- [77] = {"正在适配图像表现..."},
-- [85] = {"正在加载任务数据..."},
-- [89] = {"正在加载背包数据..."},
-- [94] = {"正在加载社交数据..."},
-- [98] = {"清理过期缓存..."},
[0 ] = {"正在初始化引擎"},
[50 ] = {"正在预加载UI"},
[98] = {"清理过期缓存"},
}

function SceneLoadingWin:__init(window_name, textrue)
    local max_width = 1366
    local centre_h = GameScreenConfig.ui_screen_height-99
    local centre_w = centre_h/541*max_width
    local down_h   = 99
    local add_h    = 0
    if GameScreenConfig.ui_screen_width/centre_w < 960/max_width then
        centre_w = GameScreenConfig.ui_screen_width/(960/max_width)
        centre_h = centre_w/max_width*541
        down_h   = GameScreenConfig.ui_screen_height-centre_h
        add_h    = down_h-99
    end
    print("centre_w=",centre_w)
    -- local num   = self:get_random()
    self.centre = CCBasePanel:panelWithFile(_screenWidth/2, down_h, centre_w, centre_h, "nopack/sceneloading.jpg")
    self.centre:setAnchorPoint(0.5, 0)
    self.view:addChild(self.centre)

    -- self.bg_down1 = CCBasePanel:panelWithFile(0, 0, _screenWidth/2+1, down_h+19, "ui2/update/down_bg.png", 500, 500)
    -- self.bg_down1:setAnchorPoint(0, 0)
    -- self.view:addChild(self.bg_down1)

    -- self.bg_down2 = CCBasePanel:panelWithFile(_screenWidth/2, 0, _screenWidth/2+1, down_h+19, "ui2/update/down_bg.png", 500, 500)
    -- self.bg_down2:setAnchorPoint(0, 0)
    -- self.bg_down2:setFlipX(true)
    -- self.view:addChild(self.bg_down2)

    -- self.down_huawen1 = CCZXImage:imageWithFile(0, 0, -1, -1, "ui2/update/down_huawen.png")
    -- self.down_huawen1:setAnchorPoint(0, 0)
    -- self.down_huawen1:setScale(0.85)
    -- self.view:addChild(self.down_huawen1)
    -- self.down_huawen2 = CCZXImage:imageWithFile(_screenWidth, 0, -1, -1, "ui2/update/down_huawen.png")
    -- self.down_huawen2:setAnchorPoint(1, 0)
    -- self.down_huawen2:setScale(0.85)
    -- self.down_huawen2:setFlipX(true)
    -- self.view:addChild(self.down_huawen2)

    self.download_bar = self:create_progress_bar(_screenWidth/2, 24+(add_h/2), 842, 18, "ui2/update/common_progress_bg.png", "ui2/update/common_progress.png", 100)
    self.download_bar.view:setAnchorPoint(0.5, 0.0)

    self.callback = callback:new()

    local tips_str          = SceneLoadingWin:get_random_str()
    self.label_loading_name = UILabel:create_lable_2(tips_str, 842/2, 27+(add_h/5), 16, ALIGN_CENTER)
    self.download_bar.view:addChild(self.label_loading_name)

    -- local label_size = self.label_loading_name:getSize()
    -- self.label_bg1   = CCZXImage:imageWithFile(-label_size.width/2-6, label_size.height/2, -1, -1, "ui2/update/huawen.png")
    -- self.label_bg1:setAnchorPoint(1, 0.5)
    -- self.label_loading_name:addChild(self.label_bg1)
    -- self.label_bg2   = CCZXImage:imageWithFile(label_size.width/2+6, label_size.height/2, -1, -1, "ui2/update/huawen.png")
    -- self.label_bg2:setAnchorPoint(0, 0.5)
    -- self.label_bg2:setFlipX(true)
    -- self.label_loading_name:addChild(self.label_bg2)

    self.label_loading_desc = UILabel:create_lable_2("", 842/2-57, -20-(add_h/5), 14, ALIGN_LEFT)
    self.download_bar.view:addChild(self.label_loading_desc, 99)

    self.view:addChild(self.download_bar.view)
    self.download_bar.set_current_value(0)

    -- self.tips_bg = CCZXImage:imageWithFile(_screenWidth/2, 92+add_h, -1, -1, "ui2/update/title.png")
    -- self.tips_bg:setAnchorPoint(0.5, 0.5)
    -- self.view:addChild(self.tips_bg)

    self.last_desc = ""
    self.last_num  = 0
end

function SceneLoadingWin:set_loading_label(name, max_num, curr_num,is_show_desc)
    if _instance == nil then
        return
    end
	local down_percent_value = math.floor(curr_num/max_num*100)
    if max_num and curr_num then
        _instance.download_bar.set_max_value(max_num)
        _instance.download_bar.set_current_value(curr_num)
    else
        _instance.download_bar.set_max_value(0)
        _instance.download_bar.set_current_value(0)
    end


    -- print("down_percent_value=",down_percent_value)
    if is_show_desc == true then
        local cur_desc_list = list_desc[down_percent_value]
        if cur_desc_list then
            _instance.label_loading_desc:setString(cur_desc_list[1])
            _instance.last_desc = cur_desc_list[1]
            _instance.last_num = 0
        else
            _instance.last_num = _instance.last_num + 1
            if _instance.last_num >= 12 then
                _instance.last_num = 1
            end
            if _instance.last_num%3 == 0 then
                local str = ""
                for i = 1 , _instance.last_num,3 do
                    str = str .. "."
                end
                _instance.label_loading_desc:setString(_instance.last_desc .. str)
            end
        end
    end
end

function SceneLoadingWin:show_instance(timeout, max_num, curr_num)
	if _instance == nil then
		_instance = SceneLoadingWin("SceneLoadingWin", "", true)
	end

	if _instance.view:getParent() == nil then
		local root = GameStateManager:get_game_root():getUINode()
		root:addChild(_instance.view, 80001)
        _instance:active(true)	
	end

	if timeout ~= nil and _instance.callback:isIdle() then
		_instance.callback:start(timeout, _instance.destroy_instance)
	end

	if max_num and curr_num then
		_instance.download_bar.set_max_value(max_num)
    	_instance.download_bar.set_current_value(curr_num)
	else
		_instance.download_bar.set_max_value(0)
    	_instance.download_bar.set_current_value(0)
	end
	return _instance
end

function SceneLoadingWin:destroy_instance()
	if _instance ~= nil then
        for i, v in ipairs(loadingsteps) do
            v:cancel()
        end
        loadingsteps = {}

		if not _instance.callback:isIdle() then
			_instance.callback:cancel()
		end
		_instance.view:removeFromParentAndCleanup(true)
		_instance:destroy()
		_instance = nil
	end

    if EventSystem then
        EventSystem.postEvent("loadingEnd", nil)
    end

    --结束回调
    if SFuBenModel then
        local nld   = SFuBenModel:get_need_load_done()
        local fb_id = SFuBenModel:get_fuben_id()
        if fb_id == SFuBenModel.FB_WJMIZANG_ID and nld then
            -- 无尽秘藏
            FubenExtCC:req_fuben_multi(SFuBenModel.FB_WJMIZANG, SFuBenModel.PROTOCAL_1)
            SFuBenModel:set_need_load_done(false)
        elseif fb_id == SFuBenModel.FB_LINGCHONG_ID and nld then
            -- 开始播放昆仑讹兽卡牌动画
            SFuBenModel:es_play_first_action()
            SFuBenModel:set_need_load_done(false)
        elseif fb_id == SFuBenModel.FB_TONGTIAN_ID and nld then
            -- 播放特效 & 请求创怪
            -- effect
            FubenExtCC:req_fuben_multi(SFuBenModel.FB_TONGTIAN, SFuBenModel.PROTOCAL_6)
            SFuBenModel:set_need_load_done(false)
        elseif fb_id == SFuBenModel.FB_ZYZ_ID and nld then
            CampBattleModel:enter_fb_finish()
            SFuBenModel:set_need_load_done(false)
        elseif fb_id == SFuBenModel.FB_WJMZBOSS_ID then
            -- FubenExtCC:req_fuben_multi(SFuBenModel.FB_WJMZBOSS, SFuBenModel.PROTOCAL_1)
            local cur_floor, all_floor, is_boss_exit = SFuBenModel:get_wjmzboss_floor()
            if is_boss_exit == 0 then  -- 0表示没有boss, 1表示有boss
                if cur_floor > 1 then -- 表示1层以上
                    SFuBenModel:show_wjmzboss_effect_and_toserver( 5) -- true:表示进入副本第一通知(调用的协议不一样)
                else 
                    SFuBenModel:show_wjmzboss_effect_and_toserver( 5, true)-- 赶紧入副本
                end
            end
            SFuBenModel:set_need_load_done(false)
        elseif fb_id == 0 then
            DrttModel:check_do_again()  -- 单人天梯再次匹配
            SZdttModel:check_do_again() -- 组队天梯再次匹配
        end
    end
    
    --通知场景管理过渡结束
    if _need_call == true then
        _need_call = false
        SceneManager:load_finish()
    end

    --检查是否可以执行引导，可以则执行
    -- SGuidePanel:check_after_run_guide()
end

function SceneLoadingWin:get_instance()
	return _instance
end

function SceneLoadingWin:enterGameWorld()
    -- 先显示loading界面，盖住地图
    SceneLoadingWin:show_instance(nil, 100, 0)
    if BISystem.enter_game_scene then
        BISystem:enter_game_scene()
    end

    for i, v in ipairs(loadingsteps) do
        v:cancel()
    end

    local step = callback:new()
    step:start(0.1,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1820],100,10)  end)
    loadingsteps[#loadingsteps+1] = step

    local step = callback:new()
    step:start(0.5,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1821],100,30)  end)
    loadingsteps[#loadingsteps+1] = step

    local step = callback:new()
    step:start(0.7,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1822],100,50)  end)
    loadingsteps[#loadingsteps+1] = step
end

function SceneLoadingWin:enterScene()
    for i, v in ipairs(loadingsteps) do
        v:cancel()
    end
    _need_call = true
    SceneLoadingWin:show_instance(0, 100, 0)
    SceneLoadingWin:set_loading_label(LangGameString[1822],100,50)

    local step = callback:new()
    step:start(0.75,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1823],100,75)  end) -- [1823]="实体"
    loadingsteps[#loadingsteps+1] = step

    local step = callback:new()
    step:start(1.4,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1824],100,100)  end) -- [1824]="场景"
    loadingsteps[#loadingsteps+1] = step
end

function SceneLoadingWin:set_loading_tip()
    local tishi_str  = SceneLoadingWin:get_random_str()
    _instance.loading_tip:setText(tishi_str)
    _instance.label_loading_tip:setString(tishi_str)
    local label_size = _instance.loading_tip:getSize()
    local is_show    = label_size.width > 380
    _instance.loading_tip:setIsVisible(not is_show)
    _instance.label_loading_tip:setIsVisible(is_show)
end

function SceneLoadingWin:get_random_str()
    --随机一个提示文字
    require "../data/client/loading_tips"
    local str_tab = loading_tips
    local ran_num = math.random(1,#str_tab)
    ran_num = math.random(1,#str_tab)
    return str_tab[ran_num]
end

function SceneLoadingWin:get_random()
    --八张背景图从中选一张
    math.randomseed(os.time())
    local ran_num = math.random(1,3)
    -- print(ran_num)
    ran_num = math.random(1,3)
    -- print(ran_num)
    return ran_num
end

--创建进度条
function SceneLoadingWin:create_progress_bar(x, y, w, h, image_bg, image_pro, max_value)
    local progress_bar = {}
    progress_bar.view  = CCBasePanel:panelWithFile(x, y, w, h, "")
    --进度条底
    progress_bar.loading_bg = CCZXImage:imageWithFile(3, 1, w-6, h-4, image_bg, 500, 500)
    progress_bar.view:addChild(progress_bar.loading_bg)
    --进度条值
    progress_bar.max_value     = max_value or 100
    progress_bar.current_value = 0
    --进度条
    progress_bar.loading_bar = CCProgressTimer:progressWithFile(image_pro)
    progress_bar.loading_bar:setContentSize(CCSizeMake(w, h))
    progress_bar.loading_bar:setPosition(CCPoint(0, 0))
    progress_bar.loading_bar:setAnchorPoint(CCPoint(0, 0))
    progress_bar.loading_bar:setPercentage(0)
    progress_bar.loading_bar:setType(kCCProgressTimerTypeHorizontalBarLR)
    progress_bar.view:addChild(progress_bar.loading_bar, 5)
    --发光边
    -- ZXResMgr:sharedManager():loadFrame("frame/uieffect/38/381.frame")
    -- local light   = {}
    -- light.view    = effectCreator.createEffect_animation("frame/uieffect/38", 0.125, -1, 0, 0, 5)
    -- local s_light = light.view:getContentSize()
    -- light.view:setPosition(-s_light.width*0.36, 13)
    -- light.view:setIsVisible(false)
    -- progress_bar.loading_bar:addChild(light.view, 6)
    -- progress_bar.light = light
    --设置进度条长度
    local function set_image_front_width()
        local percentage = 0
        if progress_bar.current_value > 0 and progress_bar.max_value > 0 then
            percentage = progress_bar.current_value/progress_bar.max_value
            progress_bar.loading_bar:setPercentage(percentage*100) 
        else
            progress_bar.loading_bar:setPercentage(percentage)
        end
        -- if percentage*w > s_light.width/4 then
            -- light.view:setIsVisible(true)
            -- light.view:setPosition(percentage*w-s_light.width*0.36, 13)
        -- else
            -- light.view:setIsVisible(false)
        -- end
    end
    --设置当前值
    progress_bar.set_current_value = function(value)
        if value > progress_bar.max_value then
            value = progress_bar.max_value
        elseif value < 0 then
            value = 0
        end
        progress_bar.current_value = value
        set_image_front_width()
    end
    --设置最大值
    progress_bar.set_max_value = function(max_value)
        if max_value <= 0 then
            max_value = 0.01
        end
        if progress_bar.current_value > max_value then
            progress_bar.current_value = max_value
        end
        progress_bar.max_value = max_value
        set_image_front_width()
    end
    return progress_bar
end