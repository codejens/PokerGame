-- DailyWelfareLD.lua  
-- created by lyl on 2013-3-5
-- 离线经验
super_class.DailyWelfareLD(Window)

-- 切换页的时候，用一个表存储每页的信息，以便切换回来的时候可以恢复
local _page_info = {}


function DailyWelfareLD:create(width, height )
    return DailyWelfareLD( "DailyWelfareLD", UILH_COMMON.bottom_bg , true, width, height)
end

function DailyWelfareLD:__init( window_name, texture_name )
    self.all_page_t = {}              -- 存储所有已经创建的页面
    self.current_panel = nil          -- 当前的面板。用于记录 界面。在切换的时候做操作
    local panel = self.view
    local title_bg = CCZXImage:imageWithFile( 33, 444, -1, -1, UILH_NORMAL.title_bg3, 500, 500 )
    -- local title_name =  UILabel:create_lable_2(Lang.benefit.welfare[23], 67, 9, font_size, ALIGN_LEFT ) 
    -- title_bg:addChild(title_name)
    local title_bg_size = title_bg:getSize()
    local title_name = CCZXImage:imageWithFile( 0, 0, -1, -1, UI_WELFARE.offline_exp_title, 500, 500 )
    local title_name_size = title_name:getSize()
    title_name:setPosition(title_bg_size.width/2 - title_name_size.width/2,title_bg_size.height/2 - title_name_size.height/2)
    title_bg:addChild(title_name)
    panel:addChild(title_bg)
    self:change_page( 1 )
end


-- 根据页刷新显示
function DailyWelfareLD:change_page( but_index )
    if self.current_panel then
        self.current_panel.view:setIsVisible(false)
    end
    
    if but_index == 1 then
        if self.all_page_t[1] == nil then
            require "UI/activity/dailywelfare/DailyWelfareLD_exp"
            self.all_page_t[1] =  DailyWelfareLD_exp()
            self.view:addChild( self.all_page_t[1].view )
        end
        self.current_panel = self.all_page_t[1]
    -- elseif  but_index == 2 then
    --     if self.all_page_t[2] == nil then
    --         require "UI/activity/dailywelfare/DailyWelfareLD_lq"
    --         self.all_page_t[2] = DailyWelfareLD_lq()
    --         self.view:addChild( self.all_page_t[2].view )
    --     end
    --     self.current_panel = self.all_page_t[2]
    end
    WelfareModel:play_fu_li_index_effect(but_index)
    if self.current_panel and self.current_panel.update then
        self.current_panel:update( "all" )
    end
    self.current_panel.view:setIsVisible(true)

    -- self.current_page_index = page_index
    -- if self.current_page_index == 2 then                     -- 灵气
    --     if self.current_rate_index > 3 then                  -- 灵气只有三
    --         self:choose_one_but( self.switch_but_t[ 3 ] )
    --     end
    --     self.get_times_lable_1:setString( "#c66ff66领取离线灵气:" )
    -- else
    --     self.get_times_lable_1:setString( "#c66ff66领取离线时间:" )
    -- end

    -- self:update_off_line_exp(  )
end

-- 更新经验离线数据
function DailyWelfareLD:update_off_line_exp(  )
    if self.all_page_t[1] then 
        self.all_page_t[1]:update_off_line_exp()
    end
end

-- 更新领取离线经验消耗
function DailyWelfareLD:update_consume(  )
    if self.all_page_t[1] then 
        self.all_page_t[1]:update_consume()
    end
end

-- 更新灵气离线小时数
function DailyWelfareLD:update_off_line_lingqi(  )
    if self.all_page_t[2] then 
        self.all_page_t[2]:update_off_line_lingqi(  )
    end
end

-- 更新
function DailyWelfareLD:update( update_type )
    if update_type == "all" then 
        for key, page in pairs( self.all_page_t ) do 
            page:update( "all" )
        end
    elseif update_type == "change_to_lingqi" then
        self:change_page( 2 )
    end
end


--重写destroy
function DailyWelfareLD:destroy( ... )
     Window.destroy(self)
    for key, get_panel in pairs( self.all_page_t ) do
        safe_release(get_panel.view)
    end
end