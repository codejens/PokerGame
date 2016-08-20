-- SceneLoading.lua
-- created by aXing on 2013-3-23
-- 过场景的时候加载界面

require "UI/component/Window"
require "utils/UI/UILabel"

super_class.SceneLoadingWin(Window)

local loadingsteps = {}
local _instance = nil   -- 一个用于主游戏加载时的单例
local _screenWidth =  GameScreenConfig.ui_screen_width
local _screenHeight = GameScreenConfig.ui_screen_height
local _note_path = 'ui2/update/lh_loading_sign.png'

function SceneLoadingWin:__init(window_name, textrue)
    self.download_bar = self:create_progress_bar(
        _screenWidth/2, 30, -1, -1, 
        "ui2/update/common_progress_bg.png",
        "ui2/update/common_progress.png"
    )
    self.download_bar.view:setAnchorPoint(0.5,0.0)
    self.callback = callback:new()

    self.view:addChild(self.download_bar.view)
    self.download_bar.set_current_value(0)
end

function SceneLoadingWin:set_loading_label(name, max_num, curr_num)
    if _instance == nil then
        return
    end
    if max_num and curr_num then
        _instance.download_bar.set_max_value(max_num)       -- 设置最大值
        _instance.download_bar.set_current_value(curr_num)  -- 设置当前值
    else
        _instance.download_bar.set_max_value(0)      -- 设置最大值
        _instance.download_bar.set_current_value(0)  -- 设置当前值
    end
end

function SceneLoadingWin:show_instance(timeout, max_num, curr_num)
    if _instance == nil then
        _instance =  SceneLoadingWin("SceneLoadingWin", "", true)
    end

    if _instance.view:getParent() == nil then
        local root = GameStateManager:get_game_root():getUINode()
        root:addChild(_instance.view, 80001) -- loading 图深度,斩仙的深度是65536，现在改成了80001,主要是为了解决场景跳转的时候点击了退出游戏的确定按钮，游戏卡死在loading界面问题，退出游戏弹框深度80000，这里直接盖过+1。
        _instance:active(true)  
    end

    if timeout ~= nil and _instance.callback:isIdle() then
        _instance.callback:start(timeout, _instance.destroy_instance)
    end
    if max_num and curr_num then
        _instance.download_bar.set_max_value(max_num)       -- 设置最大值
        _instance.download_bar.set_current_value(curr_num)  -- 设置当前值
    else
        _instance.download_bar.set_max_value(0)             -- 设置最大值
        _instance.download_bar.set_current_value(0)         -- 设置当前值
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
        EventSystem.postEvent('loadingEnd', nil)
    end
end

function SceneLoadingWin:get_instance()
    return _instance
end

-- function SceneLoadingWin:enterGameWorld()
--     -- 先显示loading界面，盖住地图
--     SceneLoadingWin:show_instance()
--     if BISystem.enter_game_scene then
--         BISystem:enter_game_scene()
--     end

--     for i, v in ipairs(loadingsteps) do
--         v:cancel()
--     end

--     local step = callback:new()
--     step:start(0.1,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1820],100,10)  end) -- [1820]='网络'
--     loadingsteps[#loadingsteps+1] = step

--     local step = callback:new()
--     step:start(0.5,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1821],100,30)  end) -- [1821]='界面'
--     loadingsteps[#loadingsteps+1] = step

--     local step = callback:new()
--     step:start(0.7,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1822],100,50)  end) -- [1822]='配置表'
--     loadingsteps[#loadingsteps+1] = step
-- end

-- function SceneLoadingWin:enterScene()
--     for i, v in ipairs(loadingsteps) do
--         v:cancel()
--     end
--     SceneLoadingWin:show_instance(1.5)
--     SceneLoadingWin:set_loading_label(LangGameString[1822],100,50) -- [1822]='配置表'

--     local step = callback:new()
--     step:start(0.75,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1823],100,75)  end) -- [1823]='实体'
--     loadingsteps[#loadingsteps+1] = step

--     local step = callback:new()
--     step:start(1.4,function(dt) SceneLoadingWin:set_loading_label(LangGameString[1824],100,100)  end) -- [1824]='场景'
--     loadingsteps[#loadingsteps+1] = step
-- end

function SceneLoadingWin:set_loading_tip()
    _instance.label_loading_tip:setString(SceneLoadingWin:get_random_str())
end

function SceneLoadingWin:get_random_str()
    -- 随机一个提示文字
    local str_tab = Lang.loading_tip
    local ran_num = math.random(1,#str_tab)
    ran_num = math.random(1,#str_tab)
    return str_tab[ran_num]
end

-- ===========================================
-- 进度条（同样适用血量、经验等）      by lyl
-- x, y, w, h  整个进度条的坐标 ，宽高
-- image_bg： 进度条背景图片路径
-- image_front： 进度条显示
-- max_value： 最大值
-- font_info: table类型，文字显示的参数：size  color     （注意要按顺序）
-- margin_t : table类型，前面显示条，与 左 右 上 下 的距离(注意要按顺序) ,  可以为nil
-- if_show_value: 是否隐藏数值
-- ===========================================
function SceneLoadingWin:create_progress_bar(x, y, w, h, image_bg, image_front, max_value, font_info, margin_t, if_show_value)
    local progress_bar = {} -- 进度条对象

    -- 进度条背景
    progress_bar.view = CCZXImage:imageWithFile(x, y, w, h, image_bg, 500, 500)
    progress_bar.max_value = max_value or 100           -- 表示的最大值
    progress_bar.current_value = max_value or 100       -- 当前值
    progress_bar.if_show_value = if_show_value          -- 是否显示数值

    -- new tjxs
    progress_bar.loading_bar = CCProgressTimer:progressWithFile(image_front)
    progress_bar.loading_bar:setPosition(CCPoint(-3,-1))
    progress_bar.loading_bar:setAnchorPoint(CCPoint(0,0))
    progress_bar.loading_bar:setPercentage(0)
    progress_bar.loading_bar:setType(kCCProgressTimerTypeHorizontalBarLR)
    progress_bar.view:addChild(progress_bar.loading_bar,5)

    -- 设置前部条的长度
    local function set_image_front_width()
        if  progress_bar.current_value > 0 and progress_bar.max_value > 0 then
            local percentage = progress_bar.current_value / progress_bar.max_value
            progress_bar.loading_bar:setPercentage(percentage*100)
        end
    end

    -- 设置当前值 的方法
    progress_bar.set_current_value = function(value)
        if value > progress_bar.max_value then
            value = progress_bar.max_value
        elseif value < 0 then
            value = 0
        end
        progress_bar.current_value = value
        set_image_front_width()
    end

    -- 设置最大值 的方法
    progress_bar.set_max_value = function(max_value)
        if progress_bar.current_value > max_value then
            progress_bar.current_value = max_value
        elseif max_value < 0 then
            max_value = 0
        end
        progress_bar.max_value = max_value
        set_image_front_width()
    end

    return progress_bar
end

function SceneLoadingWin:get_loading_path()
    require "../data/sceneloadingconf"
    local max_count = #sence_loading
    local ran_num = math.random(1,max_count)
    ran_num = math.random(1,max_count)
    return string.format("nopack/RageBackGround.png")
end