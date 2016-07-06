--MainPanelExp.lua
--created by liubo on 2015-05-14
--主界面经验模块

MainPanelExp = simple_class(GUIStudioView)

local _LAYOUT_FILE = "layout/studio/mainpanel/exp/stu_mainpanel_exp.lua"     -- 本页的布局文件


function MainPanelExp:__init( view )

end

--初始化页
function MainPanelExp:viewCreateCompleted() 
	self.view:setPosition(0,0)
    self.exp_bg = self:findLayoutViewByName("I_Exp_Bg") --经验值背景
    self.exp = self:findLayoutViewByName("LB_Exp") --经验值进度条
    self:create_exp_split()
end

-- 创建接口
function MainPanelExp:create(  )
	return self:createWithLayout( _LAYOUT_FILE )
end

--创建经验分割线
function MainPanelExp:create_exp_split()
	--使用组件创建
    --[[
    local pe = ProgressExpand:create(_PATH_MAIN_PANEL_EXP, cc.PROGRESS_TIMER_TYPE_BAR, false)
    pe:setPosition(0, 0)
    pe:setScaleX(120)
    self.exp_bg:addChild(pe.view)
    --]]

    local split_bg
    for i=1,9 do
        split_bg = GUIImg:create(_PATH_MAIN_PANEL_EXP_SPLIT)
        self.exp_bg:addChild(split_bg.view)
        split_bg:setPosition(i * 96 , 0) 
    end  
end

--设置经验值百分比
function MainPanelExp:set_exp(exp_percent)
    self.exp:setPercent(exp_percent)
end

-- 更新
-- @param update_type 更新类型
-- @param data 更新的数据 
function MainPanelExp:update( update_type, data )
	if update_type == "percent" then 
        self:set_exp(data)
    else

	end
end

--- 变成激活（显示）情况调用
function MainPanelExp:active(  )

end

-- 变成 非激活
function MainPanelExp:unActive(  )

end