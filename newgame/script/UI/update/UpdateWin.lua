-- UpdateWin.lua
---lyl
-- 更新页面

UpdateWin = {}



local _root = nil                 -- 根结点
local _father_node = nil          -- 所有内容的父节点
local _is_showing = false         -- 是否在显示中
local _animation_switch = true    -- 控制动画

local _download_bar = nil         -- 下载进度条
-- local _download_bar_sign = nil
-- local _bar_state_lable = nil      -- 当前状态（下载、解压等）提示文字lable
-- local _bar_file_size_lable = nil
local _download_per_lable         -- 百分比显示 
local _download_count             -- 下载数值的显示
local _rate_lable = nil           -- 下载速度的前字
-- local _download_rate              -- 下载速度
local _clock_count = 0            -- 时间计数   （每秒钟更新一次进度条）
local _pre_down_num = 0           -- 上一次下载到的进度值（用来计算数字）
local _flash_interval = 1         -- 刷新界面的时间间隔，单位：秒
local _bar_max_num = 100          -- 进度条最大值
local _cur_progress_desc = nil      --当前进度描述
local sceneUpdateTimer = nil
local birdAnimUpdateTimer = nil
local taskTimer = nil
-- 动画
local _animation_sprite_t = {}        -- 参与动画的背景，加入这个表，播放动画的时候，遍历来设置坐标

local image_w = 1024                                                   -- 一张图片的长度
local image_h = 480                                                    -- 一张图片的高度
local _bg_start_x = image_w / 2 + image_w * 2 -100                        -- 一个周期后的起始x坐标
local _bg_end_x   = 0 - image_w / 2  -100                                    -- 停止的x坐标 
local _one_cycle_long = _bg_start_x - _bg_end_x                        -- 一次周期的长度

local _animation_duration = 80                                         -- 一次全屏移动动画所花的时间
local _bg_move_rate = _one_cycle_long / _animation_duration            -- 速度
local _animation_duration_fg = 60--50                                      -- 前景 一次全屏移动动画所花的时间
local _fg_move_rate = _one_cycle_long / _animation_duration_fg         -- 前景速度
local create_clock = nil

_cur_progress_desc_offset_x = 0
_cur_progress_desc_normal_pos = {0,0}
_cur_progress_desc_x = 0

-- 开始播放背景动画
local bg1 = nil
local bg2 = nil
local bg3 = nil
local fg1 = nil
local fg2 = nil
local fg3 = nil
local cloud = nil
local all_fg = nil             -- 一个最上层透明背景，用来放跨图动画
local callbacklst = {}
local cloud = nil
local STRING_UNCOMPRESS = LangCommonString[73] -- [73]='正在提取资源'
local STRING_POWER_SAVING = LangCommonString[74] -- [74]='#cc8ffc8节能模式'

local __resmgr =  ZXResMgr:sharedManager()
local UpdateZUIPos = 255
local gspeed = 1.0
super_class.ResourceManager()
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

local _screenWidth =  GameScreenConfig.ui_screen_width
local _screenHeight = GameScreenConfig.ui_screen_height

local _barWidth = 884

local function SafeloadUI(file)
    if not __resmgr:loadUI(file) then
        error('failed to load .imageset ' .. file)
    end
end

local function SafeLoadFrame(file)
    if not __resmgr:loadFrame(file) then
        error('failed to load .frame ' .. file)
    end
end

function UpdateWin:show(  )
    if not UpdateWin:get_is_showing(  ) then
        UpdateWin:init( GameStateManager:get_game_root():getUINode())
    end
end


local need_remove_list = {}
function UpdateWin:init(root)
    UpdateWin:init_static_value()
    _root             = root
    _is_showing       = true
    _animation_switch = true
    -- local is_ckeck_version = CCAppConfig:sharedAppConfig():getBoolForKey("is_check_version")
    -- if is_ckeck_version then
    --     _father_node = CCBasePanel:panelWithFile(0, 0, _refWidth(1.0), _refHeight(1.0), "ui2/update/background2.wd")
    -- else
    local centre_h = _screenHeight-98
    local centre_w = centre_h/541*1366

    local index = self:get_random()
        _father_node = CCBasePanel:panelWithFile(0, 0, _screenWidth, _screenHeight, "")
        -- _father_node:setAnchorPoint(0.5,0)
    -- end
    table.insert(need_remove_list,_father_node)

    root:addChild(_father_node)

    local centre_size = _father_node:getContentSize()

    local log = CCBasePanel:panelWithFile(0,0,-1,-1,"ui2/update/update_log.png")
    local log_s = log:getContentSize()
    log:setPosition(_screenWidth/2-log_s.width/2,_screenHeight/2-log_s.height/2)
    _father_node:addChild(log)
    log:setAnchorPoint(0,0)
    local x = 155
    local y = -45
    _cur_progress_desc_offset_x = -53
    _cur_progress_desc_normal_pos = {x,y}
    _cur_progress_desc_x = x + _cur_progress_desc_offset_x
    _cur_progress_desc =  self:create_lable_2(LangCommonString[109],_cur_progress_desc_x,y,18,ALIGN_LEFT)
    log:addChild(_cur_progress_desc)


    self:start_timer(LangCommonString[109])
    


    -- self.logo = CCBasePanel:panelWithFile( 41, _screenHeight - 357-36, -1, -1, "ui2/update/logo.png" )
    -- root:addChild( self.logo )

    -- table.insert(need_remove_list,self.logo)
    -- self.bg_down = CCBasePanel:panelWithFile( _screenWidth*0.5, 0, _screenWidth, 97, "ui2/update/down_bg.png" )
    -- self.bg_down:setAnchorPoint( 0.5, 0 )
    -- root:addChild( self.bg_down )

    -----------正在下载中显示
    self.progress_di = CCBasePanel:panelWithFile(0,0,-1,-1,"ui2/update/update_progress_di.png")
    local di_s = self.progress_di:getContentSize()
    _father_node:addChild(self.progress_di)
    self.progress_di:setPosition(_screenWidth/2-di_s.width/2,_screenHeight/2-di_s.height/2-log_s.height/2-37)
    -- table.insert(need_remove_list,self.progress_di)
    local progress_bg_s = {
        width=417,
        height=19,
    }
    --进度条
    _download_bar       = self:create_progress_bar(di_s.width/2-progress_bg_s.width/2, di_s.height/2-progress_bg_s.height/2,progress_bg_s.width,progress_bg_s.height, "ui2/update/update_progress_bg.png","ui2/update/update_progress_vaule.png", 100)
    _download_bar.set_current_value(50)
    self.progress_di:addChild(_download_bar.view)

    --正在更新(xxx/xxxKB)
    local text_y = -45
    local cur_zip_count,max_zip_count = UpdateManager:get_update_zip_info()
    _download_count = self:create_lable_2(string.format(LangCommonString[176],cur_zip_count,max_zip_count,0,0), 0,text_y, 18, ALIGN_LEFT)
    _download_bar.view:addChild(_download_count)

    --下载百分比
    local s = _download_bar.view:getContentSize()
    _download_per_lable = self:create_lable_2( "#cf2c7940%", s.width,text_y, 18, ALIGN_RIGHT )
    _download_bar.view:addChild(_download_per_lable)

    --正在下载xx/xx文件
    -- _download_zip_count = self:create_lable_2("完成读(xx/xx)文件")

    self:set_progress_visible(false)
    -- _download_per_lable:setAnchorPoint(CCPointMake(0.5,0.0))

    -- _download_rate = UpdateWin:create_lable_2(string.format(LangCommonString[175],0), 100, 25, 16, ALIGN_LEFT )
    -- _download_bar.view:addChild( _download_rate )

    -- _download_rate:setIsVisible(false)

    -- _download_bar.set_current_value( 0 )


    -- self.tips_bg = CCZXImage:imageWithFile(_screenWidth/2, 80-1, -1, -1, "ui2/update/tips_bg.png")
    -- self.tips_bg:setAnchorPoint(0.5,0.5)
    -- root:addChild(self.tips_bg)
    -- table.insert(need_remove_list,self.tips_bg)

    -- self.title_bg = CCZXImage:imageWithFile(_screenWidth/2, 98, 270, 36, "ui2/update/title_bg.png",500,500)
    -- self.title_bg:setAnchorPoint(0.5,0.5)
    -- root:addChild(self.title_bg)
    -- table.insert(need_remove_list,self.title_bg)

    -- local tsize = self.title_bg:getSize()
    --loading提示文字
    -- local tishi_str  = "#cFEB300电视剧正版授权手游大作"
    -- self.loading_tip = CCZXLabel:labelWithText(tsize.width/2, tsize.height/2, tishi_str, 20, ALIGN_LEFT, FONT_HORIZONTAL)
    -- self.loading_tip:setAnchorPoint(CCPointMake(0.5, 0.5))
    -- self.title_bg:addChild(self.loading_tip)
end

function UpdateWin:update_progress_desc(str)
    if _cur_progress_desc then
        -- if _cur_progress_desc_x ~= _cur_progress_desc_normal_pos[1] then
        --     _cur_progress_desc_x = _cur_progress_desc_normal_pos[1]
        --     _cur_progress_desc:setPosition(_cur_progress_desc_x,_cur_progress_desc_normal_pos[2])
        -- end 
        -- xprint("str=",str)

        local is_change_pos = true
        self:start_timer(str,is_change_pos)
        -- _cur_progress_desc:setText(str)
    end
end

function UpdateWin:start_timer(str,is_change_pos)
    self:remove_timer()
    self.text_timer = timer()
    local ex_str = "."
    local function task_desc_func()
        _cur_progress_desc:setText(str .. ex_str )
        ex_str = ex_str .. "."
        if ex_str == "......" then
            ex_str = ""
        end
        if is_change_pos == true then
            -- if _cur_progress_desc_x ~= (_cur_progress_desc_normal_pos[1]+_cur_progress_desc_offset_x) then
                _cur_progress_desc_x = _cur_progress_desc_normal_pos[1] --+ _cur_progress_desc_offset_x
                _cur_progress_desc:setPosition(_cur_progress_desc_x,_cur_progress_desc_normal_pos[2])
            -- end
        end
    end
    -- task_desc_func()
    self.text_timer:start(0.2,task_desc_func)
end

function UpdateWin:remove_timer()
    if self.text_timer then
        self.text_timer:stop()
        self.text_timer = nil
    end
end

function UpdateWin:remove_child()
    for i, v in pairs(need_remove_list) do
        v:removeFromParentAndCleanup(true)
    end
    need_remove_list = {}
    self:remove_timer()
end

function UpdateWin:create_lable_2( lable, pos_x, pos_y, fontsize, alignment,showType)
    local fontsize = fontsize or 16
    local alignment = alignment or ALIGN_LEFT
    local showType =  showType  or FONT_HORIZONTAL
    local lable = CCZXLabel:labelWithText( pos_x, pos_y, lable, fontsize,alignment,showType)
    return lable
end

local _is_setup_download_ui = nil         --是否设置过更新界面
-- 版本信息显示
local _server_label = nil             -- 当前资源版本
local _lowpower_label = nil

local _update_info_panel = nil            -- 更新资源信息面板


function UpdateWin:show_version_info(text)
    if _is_setup_download_ui == nil then
        panel =  _father_node
        self.begin_x = 16
        self.begin_y = _screenHeight - 24
    --     _current_game_v_lable = UpdateWin:create_lable_2( text, self.begin_x, self.begin_y, 20, ALIGN_LEFT )
    --     panel:addChild( _current_game_v_lable, UpdateZUIPos )
        _is_setup_download_ui = true
        self:setup_download_ui()
    -- else
        -- _current_game_v_lable:setString(text)
    end
end

function UpdateWin:show_server_version_info(text)
    -- if _server_label == nil then
    --     _server_label = UpdateWin:create_lable_2( text, self.begin_x, self.begin_y - 20 * 1, 20, ALIGN_LEFT )
    --     panel:addChild( _server_label , UpdateZUIPos)
    -- else
    --     _server_label:setString(text)
    -- end
end

function UpdateWin:get_random()
    --八张背景图从中选一张
    math.randomseed(os.time())
    local ran_num = math.random(1,7)
    -- print(ran_num)
    ran_num = math.random(1,7)
    -- print(ran_num)
    return ran_num
end



-- 创建下载显示的控件
function UpdateWin:setup_download_ui( )
    -- if _download_per_lable == nil then
    --     _download_bar = self:create_progress_bar( _screenWidth * 0.5 , 60, 945, 38, "ui2/update/common_progress_bg.png", "ui2/update/common_progress.png", 10000, { 14, nil });
    --     _download_bar.view:setAnchorPoint(0.5,0.0)
    --     _father_node:addChild( _download_bar.view ,UpdateZUIPos)

        -- _download_bar_sign = CCBasePanel:panelWithFile( 0, 3.5, -1, -1, "ui2/update/loading_sign.png" )
        -- _download_bar.view:addChild(_download_bar_sign)
        -- _download_bar_sign:setIsVisible(false)
        -- local s = _download_bar.view:getContentSize()
        -- _download_per_lable = UpdateWin:create_lable_2( "#cf2c7940%", s.width/2, 0, 16, ALIGN_LEFT )
        -- _download_bar.view:addChild( _download_per_lable)
        -- _download_per_lable:setAnchorPoint(CCPointMake(0.5,0.0))

        -- -- _bar_state_lable = UpdateWin:create_lable_2( LangCommonString[75], _barWidth * 0.5, 30, 16, ALIGN_LEFT ) -- [75]="#c4d2308更新资源"
        -- -- _download_bar.view:addChild( _bar_state_lable )
        -- -- _bar_state_lable:setIsVisible(false)

        -- -- _bar_file_size_lable = UpdateWin:create_lable_2( LangCommonString[75], _barWidth -200, 30, 16, ALIGN_LEFT ) -- [75]="#c4d2308更新资源"
        -- -- _download_bar.view:addChild( _bar_file_size_lable,999 )
        -- -- _bar_file_size_lable:setIsVisible(false)

        -- -- _download_count = UpdateWin:create_lable_2( LangCommonString[76], _barWidth * 0.5, 37, 16, ALIGN_LEFT ) -- [76]="检查进度中..."
        -- -- _download_bar.view:addChild( _download_count )
        -- -- _download_count:setAnchorPoint(CCPointMake(0.5,0.0))

        -- -- _rate_lable = UpdateWin:create_lable_2( LangCommonString[77], _barWidth * 0.5, 50, 16, ALIGN_LEFT ) -- [77]="#c4d2308速度:"
        -- -- _download_bar.view:addChild( _rate_lable )
        -- _download_rate = UpdateWin:create_lable_2(string.format(LangCommonString[175],0), 100, 25, 16, ALIGN_LEFT )
        -- _download_bar.view:addChild( _download_rate )

        -- _download_rate:setIsVisible(false)

        -- _download_bar.set_current_value( 0 )
    -- end

    -- self:show_update_log( 'static_text', 'text123456789\ntext123456789\ntext123456789\ntext123456789' )
end

function UpdateWin:show_update_log( static_text, text )
    -- messageList = self:Split(text,'\n')
    -- if _update_info_panel then
    --     _father_node:removeChild( _update_info_panel, true )
    -- end

    -- _update_info_panel = CCZXImage:imageWithFile( 0, _screenHeight - 380, 480, 300, "ui2/update/bg_06.png", 500, 500 ) 
    -- local update_info_x = self.begin_x
    -- local update_info_y = 270
    -- local _update_info_label = {}

    -- _update_info_panel:addChild( UpdateWin:create_lable_2( static_text, update_info_x, update_info_y, 20, ALIGN_LEFT ) )
    -- for i = 1, #messageList do
    --     _update_info_label[i] = UpdateWin:create_lable_2( i..". "..messageList[i], update_info_x, 
    --                                                       update_info_y - 30 * i, 20, ALIGN_LEFT )
    --     _update_info_panel:addChild( _update_info_label[i] )
    -- end

    
    -- panel:addChild( _update_info_panel )

    -- _bar_state_lable:setIsVisible(false)
    -- _download_rate:setIsVisible(false)
    -- _rate_lable:setIsVisible(false)

end



function UpdateWin:setUpdateCountText(message)
    if _download_count then 
        -- print("message=",message)
        self:update_progress_desc(message)
        self:set_progress_visible(false)
    -- _download_count:setPosition(self.count_x,self.count_y)

    -- _download_rate:setIsVisible(false)
    end
end

function UpdateWin:set_progress_visible(visible)
    if self.progress_visible == visible then
        return
    end
    self.progress_di:setIsVisible(visible)
    self.progress_visible = visible
    if self.progress_visible ~= nil then --第一次默认进来false先不设置
        self:remove_timer()
    end
    if _cur_progress_desc then
        _cur_progress_desc:setIsVisible(not visible)
    end
end

-- 下载中的即时显示
function UpdateWin:downloading( curr_num, max_num, speed )
    self:set_progress_visible(true)
    _download_bar.set_max_value( max_num )                        -- 设置最大值
    _download_bar.set_current_value( curr_num )                   -- 设置当前值
    _bar_max_num = max_num

    -- 进度光标
    if curr_num/max_num < 0.03 or curr_num/max_num == 1 then
        -- _download_bar_sign:setIsVisible(false)
    else
        -- _download_bar_sign:setIsVisible(true)
    end
    -- _download_bar_sign:setPosition( curr_num/max_num * (945-50), 3.5 )

    -- 百分比
    local down_percent_value = math.floor( curr_num / max_num * 100 )
    _download_per_lable:setString("#cffdbb0" .. down_percent_value.."%" )

    -- 下载的数值显示
    local cur_zip_count,max_zip_count = UpdateManager:get_update_zip_info()
    -- print("down_percent_value,max_num,cur_zip_count,max_zip_count=",down_percent_value,max_num,cur_zip_count,max_zip_count)
    _download_count:setString(string.format(LangCommonString[176],cur_zip_count,max_zip_count,curr_num,max_num))
    -- _download_count:setPosition(self.count_x+150,self.count_y)

    -- 下载速度
    -- _bar_file_size_lable:setIsVisible(false)
    -- _bar_state_lable:setIsVisible(false)
    -- _download_rate:setIsVisible(true)
    -- _rate_lable:setIsVisible(true)
    -- _download_rate:setString(string.format(LangCommonString[175],speed))

end

function UpdateWin:uncompress( curr_num, max_num )

    -- _download_bar.set_max_value( max_num )                        -- 设置最大值
    -- _download_bar.set_current_value( curr_num )                   -- 设置当前值
    -- _bar_max_num = max_num

    -- 进度光标
    -- if curr_num/max_num < 0.05 or curr_num/max_num == 1 then
        -- _download_bar_sign:setIsVisible(false)
    -- else
        -- _download_bar_sign:setIsVisible(true)
    -- end
    -- _download_bar_sign:setPosition( curr_num/max_num * (945-50), 3.5 )

    -- 百分比
    -- local down_percent_value = math.floor( curr_num / max_num * 100 )
    -- _download_per_lable:setString("#cf2c794" .. down_percent_value.."%" )
    -- print("sssssssssssssssssssss=",down_percent_value)
    -- 下载的数值显示
    --_download_count:setString( curr_num .. "/" .. max_num.."KB" )
    -- _download_count:setString( STRING_UNCOMPRESS )
    -- print("1=",STRING_UNCOMPRESS)
    -- _download_count:setPosition(self.count_x,self.count_y)
    -- _download_rate:setIsVisible(false)
    -- 下载速度
    -- _download_rate:setIsVisible(false)
    -- _rate_lable:setIsVisible(false)
    --_download_rate:setString( speed .."KB/S" )

end


-- 下载结束
function UpdateWin:update_end(  )
    if _download_count then
    -- print("2=",LangCommonString[78])
    self:set_progress_visible(false)
        self:update_progress_desc( LangCommonString[78] ) -- [78]="启动游戏"
        -- _download_count:setPosition(self.count_x,self.count_y)
        -- _download_rate:setIsVisible(false)
        --_download_rate:setString("0KB/S")
        _download_per_lable:setString( "#cf2c794100%" )
        _download_bar.set_max_value( 1 )  
        _download_bar.set_current_value( 1 )
        -- _bar_file_size_lable:setIsVisible(false)
        -- _bar_state_lable:setIsVisible(false)
        -- _download_rate:setIsVisible(false)
        -- _rate_lable:setIsVisible(false)

        --光标
        -- _download_bar_sign:setIsVisible(false)

    end
end

-- 下载结束
function UpdateWin:download_end(  )
    if _download_count then
    -- print("3=",LangCommonString[79])
        self:set_progress_visible(false)
        self:update_progress_desc( LangCommonString[79] ) -- [79]="下载成功"
        -- _download_count:setPosition(self.count_x,self.count_y)
        -- _download_rate:setString("")
        _download_per_lable:setString( "#cf2c794100%" )
        _download_bar.set_current_value( _bar_max_num )

        --光标
        -- _download_bar_sign:setIsVisible(false)
    end
end

-- 开始解压，把相关文字改成解压相关
function UpdateWin:begin_release(  )

    -- _bar_state_lable:setString( LangCommonString[80] ) -- [80]="#c4d2308解压资源"
end

-- 解压中的即时显示（这里直接可以调用下载中的即时显示）
function UpdateWin:release_resource( curr_num, max_num )
    UpdateWin:downloading( curr_num, max_num)
end

-- 获取是否在显示中的标记
function UpdateWin:get_is_showing(  )
    return _is_showing
end

-- 销毁函数
function UpdateWin:destroy()
    _is_showing = false
    _animation_switch = false
    -- _root:removeChild(_father_node, true)
    -- _root:removeChild(_father_node, true)
    -- _root:removeChild(_father_node, true)
    -- _root:removeChild(_father_node, true)
    _cur_progress_desc = nil
    _father_node = nil
    UpdateWin:remove_child()
    if sceneUpdateTimer then
        sceneUpdateTimer:stop()
    end
    if birdAnimUpdateTimer then
        birdAnimUpdateTimer:stop()
    end
    if taskTimer then
        taskTimer:stop()
    end
    UpdateWin:init_static_value()
end


--清空界面，只剩背景
function UpdateWin:clear_win_but_bg()
    if _download_bar then
        _father_node:removeChild(_server_label, true)
        _father_node:removeChild(_update_info_panel, true)
        _father_node:removeChild(_download_bar.view, true)
    end
end


function UpdateWin:begin_bg_animation(  )

    taskTimer = timer()
    
    local task = {}
    local function doTask(dt)
        if #task == 0 then
            taskTimer:stop()
        else
            
            local job = table.remove(task,1)
            job()
        end

    end
    taskTimer:start(0,doTask)

    
    task[#task+1] = function ()

    bg1 = UpdateWin:create_animation_bg( _father_node, "ui2/update/bg1.jpg", _bg_start_x - image_w * 2, image_h / 2,  _bg_end_x, image_h / 2, _bg_move_rate, create_clock )
    end

    task[#task+1] = function ()
    bg2 = UpdateWin:create_animation_bg( _father_node, "ui2/update/bg2.jpg", _bg_start_x - image_w * 1, image_h / 2,  _bg_end_x, image_h / 2, _bg_move_rate, create_clock )
    end 

    task[#task+1] = function ()
    bg3 = UpdateWin:create_animation_bg( _father_node, "ui2/update/bg3.jpg", _bg_start_x - image_w * 0, image_h / 2,  _bg_end_x, image_h / 2, _bg_move_rate, create_clock )
    end 

    task[#task+1] = function ()
    cloud = UpdateWin:create_animation_bg( _father_node, "ui2/logineffect/77713/777131.png", _bg_start_x - image_w * 2, 600,  _bg_end_x, image_h / 2, _bg_move_rate * 1.3, create_clock )
    end 

    task[#task+1] = function ()
    fg1 = UpdateWin:create_animation_bg( _father_node, "ui2/update/fg1.png", _bg_start_x - image_w * 2, image_h / 2,  _bg_end_x, image_h / 2, _fg_move_rate, create_clock )
    end

    task[#task+1] = function ()
    fg2 = UpdateWin:create_animation_bg( _father_node, "ui2/update/fg2.png", _bg_start_x - image_w * 1, image_h / 2,  _bg_end_x, image_h / 2, _fg_move_rate, create_clock )
    end

    task[#task+1] = function ()
    fg3 = UpdateWin:create_animation_bg( _father_node, "ui2/update/fg3.png", _bg_start_x - image_w * 0, image_h / 2,  _bg_end_x, image_h / 2, _fg_move_rate, create_clock )
    end


    -- 不断根据时间，计算每个背景坐标
    local function callback_func()
        if _animation_switch then
            if create_clock == nil then
                create_clock = os.clock()
            end 
            UpdateWin:do_bg_animation( )                                              -- 动画实现                        -- 下一次回调
        end
    end


    task[#task+1] = function ()
    UpdateWin:add_effect_in_bg()
    end

    task[#task+1] = function ()
    sceneUpdateTimer = timer()
    sceneUpdateTimer:start( 0.0, callback_func ) 

    self.sceneUpdateCallback = callback_func
    end

end

function UpdateWin:load_effects()
    SafeLoadFrame("ui2/logineffect/77701/777011.frame")
    SafeLoadFrame("ui2/logineffect/77701/777012.frame")
    SafeLoadFrame("ui2/logineffect/77701/777013.frame")

    SafeLoadFrame("ui2/logineffect/77702/777021.frame")

    SafeLoadFrame("ui2/logineffect/77703/777031.frame")

    SafeLoadFrame("ui2/logineffect/77704/777041.frame")
    SafeLoadFrame("ui2/logineffect/77704/777042.frame")
    SafeLoadFrame("ui2/logineffect/77704/777043.frame")
    SafeLoadFrame("ui2/logineffect/77704/777044.frame")
    SafeLoadFrame("ui2/logineffect/77704/777045.frame")

    SafeLoadFrame("ui2/logineffect/77705/777051.frame")

    SafeLoadFrame("ui2/logineffect/77706/777061.frame")

    SafeLoadFrame("ui2/logineffect/77707/777071.frame")

    SafeLoadFrame("ui2/logineffect/77708/777081.frame")
    SafeLoadFrame("ui2/logineffect/77708/777082.frame")

    SafeLoadFrame("ui2/logineffect/77709/777091.frame")

    SafeLoadFrame("ui2/logineffect/77710/777101.frame")

    SafeLoadFrame("ui2/logineffect/77711/777111.frame")

    SafeLoadFrame("ui2/logineffect/77712/777121.frame")
    SafeLoadFrame("ui2/logineffect/77712/777122.frame")
    SafeLoadFrame("ui2/logineffect/77712/777123.frame")
    SafeLoadFrame("ui2/logineffect/77712/777124.frame")
    SafeLoadFrame("ui2/logineffect/77712/777125.frame")
end

-- 在背景上增加特效
function UpdateWin:add_effect_in_bg(  )
    self:load_effects()            -- 加载特效资源

    UpdateWin:play_effect( fg1.bg_sprite, 77701, 80, 160, 1.2, 1.2, true, nil )  -- 瀑布
    UpdateWin:play_effect( fg1.bg_sprite, 7770201, 320, 150, 1, 1, true, nil )  -- 两灯之一
    UpdateWin:play_effect( fg1.bg_sprite, 7770202, 395, 150, 1, 1, true, nil )  -- 两灯之一
    UpdateWin:play_effect( fg1.bg_sprite, 7770203, 780, 70, 2, 2, true, nil )  -- 大灯
    UpdateWin:play_effect( fg1.bg_sprite, 77703, 815, 70, 1, 1, true, nil )    -- 大灯

    UpdateWin:play_effect( bg2.bg_sprite, 77704, 1025, 280, 1, 1, true, nil )  -- 太阳光晕

    UpdateWin:play_effect( fg2.bg_sprite, 7770601, 165, 40, -1, -1, true, nil )    -- 蝴蝶 1 左
    UpdateWin:play_effect( fg2.bg_sprite, 7770602, 565, 85, 1, 1, true, nil )     -- 蝴蝶2
    UpdateWin:play_blink_effect( fg2.bg_sprite, "ui2/logineffect/77707/777071.png", 405, -75, 1 ) -- 花丛星光  （闪烁）
    UpdateWin:play_effect( fg2.bg_sprite, 77708, 85, 375, 1, 1, true, nil )       -- 蓝色叶子 高
    UpdateWin:play_effect( fg2.bg_sprite, 7770901, 0, 105, 1, 1, true, nil )        -- 绿色叶子 1 左
    -- UpdateWin:play_effect( fg2.bg_sprite, 7770902, 665, 65, 1, true, nil )      -- 绿色叶子 2
    UpdateWin:play_effect( fg2.bg_sprite, 7771001, 690, 245, 1, 1, true, nil )     -- 瀑布  高 左
    UpdateWin:play_effect( fg2.bg_sprite, 7771002, 895, 175, 1, 1, true, nil )     -- 瀑布  高 右
    UpdateWin:play_effect( fg2.bg_sprite, 77712, 170, 285, 1, 1, true, nil )        -- 树顶的星光闪闪

    UpdateWin:play_effect( fg3.bg_sprite, 7771101, 645, 130, 1, 1, true, nil )       -- 瀑布   山顶
    UpdateWin:play_effect( fg3.bg_sprite, 7771004, 625, 130, 1, 1, true, nil )       -- 瀑布   山顶

   UpdateWin:create_bird_animation(  )
end

-- 创建一个移动图片， 并存入移动图片表中。 做动画计算的时候会统一计算位置
function UpdateWin:create_animation_bg( father_node, image_path, begin_x, begin_y, end_x, end_y, move_rate, cc )
    local bg_animation = {}
    
    bg_animation.end_x = end_x
    bg_animation.end_y = end_y
    bg_animation.move_rate = move_rate
    bg_animation.start_clock = cc
    
    bg_animation.bg_sprite = UpdateWin:create_sprite( father_node, image_path, begin_x, begin_y, nil)
    -- father_node:addChild( bg_animation.bg_sprite )
    -- 根据时间，计算位置  
    bg_animation.calculate_position = function ( now_time )
        local interval_clock = now_time - create_clock                                       -- 距离开始动画的间隔
        local s_x = move_rate * interval_clock * gspeed                                      -- 从开始到现在已经移动的距离
        local curr_x =  _one_cycle_long - (end_x - begin_x + s_x) % _one_cycle_long + end_x  -- 计算当前坐标
        bg_animation.bg_sprite:setPosition( curr_x, end_y )

    end
    table.insert( _animation_sprite_t, bg_animation )
    return bg_animation
end

local _animation_duration = 1 / 60          -- 每次计算坐标的间隔
local _animation_clock    = 0               -- 记录一次计算的时间
function UpdateWin:do_bg_animation(  )
    if gspeed < 1.0 then
        gspeed = gspeed + 0.01
    else
        gspeed = 1.0
    end
    local now_clock = os.clock()
    for key, _sprite in pairs(_animation_sprite_t) do
        _sprite.calculate_position( now_clock )
    end
end

-- 鸟的特殊动画
function UpdateWin:create_bird_animation(  )
    UpdateWin:create_one_move_effect( fg3.bg_sprite, 77705, 1674, -10, 824, 275, -1, 1, -0.001, 0.001, 10 )    -- 创建一只鸟
end

-- 创建一个只鸟的动画
function UpdateWin:create_one_move_effect( father_node, effect_id, start_x, start_y, end_x, end_y, begin_scale_x, begin_scale_y, end_scale_x, end_scale_y, duration )
    
    local effect_node = UpdateWin:play_effect( father_node, effect_id, start_x, start_y, begin_scale_x, begin_scale_y, true, nil )
    local start_clock = os.clock()
    birdAnimUpdateTimer = timer()

    local function cb_func(  )
        if not _animation_switch then
            return
        end
        -- ----print("鸟的callback")
        local interval_clock = os.clock() - start_clock
        if interval_clock > duration then                -- 完成一次播放后（根据时间判断）从新开始新的播放
            effect_node:setPosition( start_x, start_y )
            effect_node:setScaleX( begin_scale_x )
            effect_node:setScaleY( begin_scale_y )
            start_clock = os.clock()
        end

        local percentage = interval_clock / duration

        local curr_x = start_x + ( end_x - start_x ) * percentage
        local cuur_y = start_y + ( end_y - start_y ) * percentage
        effect_node:setPosition( curr_x, cuur_y )

        local curr_scale_x = begin_scale_x + ( end_scale_x - begin_scale_x ) * percentage
        effect_node:setScaleX( curr_scale_x )
        local curr_scale_y = begin_scale_y + ( end_scale_y - begin_scale_y ) * percentage
        effect_node:setScaleY( curr_scale_y )                            -- 下一次回调
    end

    birdAnimUpdateTimer:start( 0.0, cb_func ) 
    self.birdAnimUpdateCallback = cb_func
end

-- 再次创建的时候，初始化个静态变量
function UpdateWin:init_static_value(  )
    _root = nil                 -- 根结点
    _father_node = nil          -- 所有内容的父节点
    _is_showing = false         -- 是否在显示中
    _animation_switch = true    -- 控制动画

    _download_bar = nil         -- 下载进度条
    -- _bar_state_lable = nil      -- 当前状态（下载、解压等）提示文字lable
    -- _bar_file_size_lable = nil      -- 当前状态（下载、解压等）提示文字lable
    _download_per_lable = nil   -- 百分比显示 
    _download_count = nil       -- 下载数值的显示
    -- _rate_lable = nil           -- 下载速度的前字
    -- _download_rate = nil              -- 下载速度
    _clock_count = 0            -- 时间计数   （每秒钟更新一次进度条）
    _pre_down_num = 0           -- 上一次下载到的进度值（用来计算数字）
    _flash_interval = 1         -- 刷新界面的时间间隔，单位：秒
    _bar_max_num = 100          -- 进度条最大值


    -- _current_game_v_lable = nil         -- 当前游戏版本
    _server_label = nil             -- 当前资源版本

    _update_info_panel = nil            -- 更新资源信息面板



    _animation_sprite_t = {}      -- 参与动画的背景，加入这个表，播放动画的时候，遍历来设置坐标
end

-- ========================================================================
-- 拷过来的工具方法
-- ========================================================================

-----HJH
-----2012-12-27
-----用于指定字符分拆
function UpdateWin:Split(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
        break  
       end  
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end 


-- -- ===========================================
-- -- 进度条（同样适用血量、经验等）      by lyl
-- -- x, y, w, h  整个进度条的坐标 ，宽高
-- -- image_bg： 进度条背景图片路径
-- -- image_front： 进度条显示
-- -- max_value： 最大值
-- -- font_info: table类型，文字显示的参数：size  color     （注意要按顺序）
-- -- margin_t : table类型，前面显示条，与 左 右 上 下 的距离(注意要按顺序) ,  可以为nil
-- -- if_show_value: 是否隐藏数值
-- -- ===========================================
-- function UpdateWin:create_progress_bar2( x, y, w, h, image_bg, image_front, max_value, font_info, margin_t, if_show_value )
--     local progress_bar = {}                      -- 进度条对象
    
--     progress_bar.view = CCZXImage:imageWithFile( x, y, w, -1, image_bg, 500, 1 )           -- 进度条背景
--     progress_bar.max_value = max_value or 100           -- 表示的最大值
--     progress_bar.current_value = max_value or 100       -- 当前值
--     progress_bar.if_show_value = if_show_value          -- 是否显示数值



--     -- 计算各种边距, 显示前部的条
--     margin_t = margin_t or {}           -- 边距
--     local margin_left    = margin_t[1] or 2
--     local margin_right   = margin_t[2] or 2
--     local margin_top     = margin_t[3] or 2
--     local margin_bottom  = margin_t[4] or 2
--     local image_front = CCZXImage:imageWithFile( 0, 0, (w-50), 22, image_front, 500, 500 )
--     progress_bar.view:addChild( image_front )
--     image_front:setAnchorPoint(0.0,0.5)
--     image_front:setPosition(25,h*0.5)

--     -- 数值显示
--     local font_size  = font_info[1] or 21
--     local font_color = font_info[2] or ""
--     local value_lable = UpdateWin:create_lable_2( font_color..progress_bar.current_value.."/"..progress_bar.max_value, w / 2, margin_bottom, font_size, ALIGN_CENTER )
--     progress_bar.view:addChild( value_lable )

--     if not progress_bar.if_show_value then
--         value_lable:setIsVisible( false )
--     end


--     local _note = CCSprite:spriteWithFile(_note_path)
--     progress_bar.view:addChild(_note)
--     _note:setAnchorPoint(CCPointMake(0.25,0.5))
--     _note:setPosition(CCPointMake(0,h*0.5))
--     -- 设置前部条的长度
--     local function set_image_front_width(  )
--         if  progress_bar.current_value > 0 and progress_bar.max_value > 0 then
--             local percentage = progress_bar.current_value / progress_bar.max_value
--             image_front:setSize( (w-50) * percentage, 22 )
--             image_front:setIsVisible(true)
--             _note:setPosition(CCPointMake((w - 50) * percentage,h*0.5))
--         else
--             image_front:setIsVisible(false)
--         end
--     end

--     -- 设置当前值 的方法
--     progress_bar.set_current_value = function( value )

--         -- if not progress_bar.if_show_value then
--         --     return
--         -- end
--         if value > progress_bar.max_value then
--             value = progress_bar.max_value
--         elseif value < 0 then
--             value = 0
--         end
--         progress_bar.current_value = value
--         value_lable:setString( font_color..progress_bar.current_value.."/"..progress_bar.max_value )
--         set_image_front_width(  )
--     end

--     -- 设置最大值 的方法
--     progress_bar.set_max_value = function( max_value )
--         -- if not progress_bar.if_show_value then
--         --     return
--         -- end
--         if progress_bar.current_value > max_value then
--             progress_bar.current_value = max_value
--         elseif max_value < 0 then
--             max_value = 0
--         end
--         progress_bar.max_value = max_value
--         value_lable:setString( font_color..progress_bar.current_value.."/"..progress_bar.max_value )
--         set_image_front_width(  )
--     end

--     return progress_bar
-- end


--创建进度条
function UpdateWin:create_progress_bar(x, y, w, h, image_bg, image_pro, max_value)
    local progress_bar         = {}
    --进度条底
    progress_bar.view          = CCZXImage:imageWithFile(x, y, w, h, image_bg, 500, 500)
    progress_bar.max_value     = max_value or 100
    progress_bar.current_value = 0
    --进度条
    progress_bar.loading_bar   = CCProgressTimer:progressWithFile(image_pro)
    progress_bar.loading_bar:setContentSize(CCSizeMake(w, h))
    progress_bar.loading_bar:setPosition(CCPoint(1, h))
    progress_bar.loading_bar:setAnchorPoint(CCPoint(0, 1))
    progress_bar.loading_bar:setPercentage(0)
    progress_bar.loading_bar:setType(kCCProgressTimerTypeHorizontalBarLR)
    progress_bar.view:addChild(progress_bar.loading_bar, 5)
    --发光边

    -- ZXResMgr:sharedManager():loadFrame("frame/uieffect/38/381.frame")
    local sprite = nil
    -- sprite = effectCreator.createEffect_animation("frame/uieffect/38",0.125, -1,0,0,5)

    local light   = {}
    light.view    = CCZXImage:imageWithFile(0, 0, -1, -1, "ui2/update/update_progress_effect.png")
    -- light.view = sprite
    local s_light = light.view:getContentSize()
    light.view:setPosition(0, 0)
    light.view:setIsVisible(false)
    -- progress_bar.loading_bar:addChild(light.view, 6)
    progress_bar.light = light

        -- sprite:setIsVisible(false)

    -- self.effect = sprite
    -- self.loading_bar:addChild(self.effect)
    -- self.effect:setPositionY(16)
    -- self.effect:setIsVisible(false)

    --设置进度条长度
    local is_add = false
    local function set_image_front_width()
        if progress_bar.current_value > 0 and is_add == false then
            is_add = true
            progress_bar.loading_bar:addChild(light.view, 6)
        else
            light.view:setIsVisible(true)
        end
        local percentage = 0
        if progress_bar.current_value > 0 and progress_bar.max_value > 0 then
            percentage = progress_bar.current_value/progress_bar.max_value
            progress_bar.loading_bar:setPercentage(percentage*100) 
        else
            progress_bar.loading_bar:setPercentage(percentage)
        end
        if percentage*(w-2) > s_light.width/4 then
            light.view:setIsVisible(true)
            local x = percentage*w-s_light.width
            light.view:setPosition(x, 0)
        else
            light.view:setIsVisible(false)
        end
    end

    -- 设置当前值
    progress_bar.set_current_value = function(value)
        if value > progress_bar.max_value then
            value = progress_bar.max_value
        elseif value < 0 then
            value = 0
        end
        progress_bar.current_value = value
        set_image_front_width()
    end

    -- 设置最大值
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

-- 创建sprite
function UpdateWin:create_sprite(parent,filepath,pos_x,pos_y,z)

    local spr = CCSprite:spriteWithFile(filepath);
    spr:setPosition(pos_x,pos_y);
    if( z == nil ) then 
        z = 0;
    end
    parent:addChild(spr,z);
    return spr;
end

--=========================================
-- 创建自定义字体控件
--label ：字符串，要现实的字符
--pos_x, pos_y:  数字；坐标
--fontsize  ：数字；字体大小。  不传参数，默认16
--alignment：对齐方式；（可不填，默认 ALIGN_LEFT ）使用cocos2d定义好的 ALIGN_LEFT   ALIGN_CENTER   ALIGN_RIGHT
-- 颜色：直接在lable中设置，支持内部颜色变化：例如： 传入  "#c00ff65地球#cff0000太阳" 地球蓝色  太阳红色
--=========================================
function UpdateWin:create_lable_2( lable, pos_x, pos_y, fontsize, alignment )
    local fontsize = fontsize or 16
    local alignment = alignment or ALIGN_LEFT
    local lable = CCZXLabel:labelWithText( pos_x, pos_y, lable, fontsize, alignment)
    return lable
end

-- 播放特效; 参数：
-- father_node ： 父节点
-- view_effect_id： 配置的特效id
-- x, y:  坐标
-- scale： 缩放比例
-- is_forever ： 是否循环播放
-- z： 层次, 可以为nil
-- duration: 动画时间，可以为nil， 如此，动画时间取配置
function UpdateWin:play_effect( father_node, view_effect_id, x, y, scale_x, scale_y, is_forever, z, duraion )
    local ani_table = login_effect_config[view_effect_id];
    if ( z == nil ) then
        z = 10;
    end

    local animation_duraion = duraion or ani_table[2] or 1

    if ( is_forever ) then 
        -- ----print("特效参数：1 :::：", ani_table[1], father_node, ani_table[3], view_effect_id ,x , y, z, animation_duraion )
        ZXEffectManager:sharedZXEffectManager():run_forever_action( ani_table[1], father_node, ani_table[3], view_effect_id ,x , y, z, animation_duraion );
    else
        -- ----print("特效参数：2 :::：", ani_table[1], father_node, ani_table[3], view_effect_id ,x , y, z, animation_duraion )
        ZXEffectManager:sharedZXEffectManager():run_one_animation_action( ani_table[1] ,view, ani_table[3],view_effect_id, 0, 0, animation_duraion, x, y );
    end

    local effect_node = father_node:getChildByTag(view_effect_id);
    if effect_node then
        effect_node:setScaleX( scale_x )
        effect_node:setScaleY( scale_y )
    end
    return effect_node
end

-- 播放闪烁特效
function UpdateWin:play_blink_effect( father_node, image_path, x, y, scale )
    local blink_rect = UpdateWin:create_sprite( father_node, image_path, x, y);
    blink_rect:setScale( scale )

    local fade_out = CCFadeOut:actionWithDuration(1);
    local fade_in = CCFadeIn:actionWithDuration(1);
    local array = CCArray:array();
    array:addObject(fade_out);
    array:addObject(fade_in);
    local seq = CCSequence:actionsWithArray(array);
    local action = CCRepeatForever:actionWithAction(seq);
    blink_rect:runAction( action );

    return blink_rect;
end


function UpdateWin:startLoginMode()
    if self.downloaded then
        _is_showing = true
        _animation_switch = true
        create_clock = os.clock() - self.animate_passed
        sceneUpdateTimer:start( 0.0, self.sceneUpdateCallback ) 
        birdAnimUpdateTimer:start(0.0, self.birdAnimUpdateCallback)
    end
end

function UpdateWin:downloadMode()
    if create_clock == nil then
        os.clock()
    end

    self.animate_passed = os.clock() - create_clock

    self.downloaded = true
    if _lowpower_label == nil then
        _lowpower_label = UpdateWin:create_lable_2( STRING_POWER_SAVING, 
                                                    0, 0, 14 , ALIGN_LEFT )
        panel:addChild( _lowpower_label , UpdateZUIPos)
    else
        _lowpower_label:setString(STRING_POWER_SAVING)
    end

    _is_showing = false
    _animation_switch = false
    
    if sceneUpdateTimer then
        sceneUpdateTimer:stop()
    end
    if birdAnimUpdateTimer then
        birdAnimUpdateTimer:stop()
    end
end






-- ==========================================================
-- 特效配置
-- ==========================================================
local normal_speed = 0.12;
login_effect_config = {
    [77701] = {"ui2/logineffect/77701", normal_speed, 1 },     -- 瀑布
    [7770201] = {"ui2/logineffect/77702", normal_speed, 1 },   -- 灯1
    [7770202] = {"ui2/logineffect/77702", normal_speed, 1 },   -- 灯2
    [7770203] = {"ui2/logineffect/77702", normal_speed, 1 },   -- 灯3
    [77703] = {"ui2/logineffect/77703", normal_speed, 1 },     -- 灯照光
    [77704] = {"ui2/logineffect/77704", normal_speed, 1 },     -- 光晕
    [77705] = {"ui2/logineffect/77705", normal_speed, 1 },     -- 鹤
    [7770601] = {"ui2/logineffect/77706", normal_speed, 1 },     -- 蝴蝶1
    [7770602] = {"ui2/logineffect/77706", normal_speed, 1 },     -- 蝴蝶2
    [77707] = {"ui2/logineffect/77707", normal_speed, 1 },     -- 花丛星光
    [77708] = {"ui2/logineffect/77708", normal_speed, 1 },     -- 蓝色叶子
    [7770901] = {"ui2/logineffect/77709", normal_speed, 1 },     -- 绿色叶子1
    [7770902] = {"ui2/logineffect/77709", normal_speed, 1 },     -- 绿色叶子2
    [7771001] = {"ui2/logineffect/77710", normal_speed, 1 },     -- 瀑布01  1
    [7771002] = {"ui2/logineffect/77710", normal_speed, 1 },     -- 瀑布01  2
    [7771003] = {"ui2/logineffect/77710", normal_speed, 1 },     -- 瀑布01  2
    [7771004] = {"ui2/logineffect/77710", normal_speed, 1 },     -- 瀑布01  2
    [7771101] = {"ui2/logineffect/77711", normal_speed, 1 },     -- 瀑布02  1
    [77712] = {"ui2/logineffect/77712", normal_speed, 1 },     -- 星光闪闪
    [77713] = {"ui2/logineffect/77713", normal_speed, 1 },     -- 云
 }
