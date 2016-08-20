-- LingGen.lua
-- create by hcl on 2012-12-13
-- 灵根(忍书)系统

require "UI/component/Window"
require "../data/client/linggen_config" --灵根配置

super_class.LingGen()

-- ui param
local panel_width = 877
local panel_height = 525

require "utils/MUtils"
require "config/RootConfig"
local _LINGGEN_NUM = 15;
local _base_size = CCSize(900, 605)
-- self.view
local basePanel = nil;
local left_up_panel =nil
-- --modified by zyz,添加一个背景panel,ui替换后，左半边灵根背景及灵根点位置发生偏移，改为以此panel为父节点
-- local left_panel = nil
-- 左边距和下边距
local l_m = 6;
local b_m = 44;
-- 当前选择的灵根点索引 从0开始
local curr_select_linggen = 0;
-- 当前的灵根等级 从0开始
local curr_linggen_lv = 0;
-- 灵根点说明label的集合
local tab_linggen_labs = {};

-- 灵根兽背景图
local spr_bg = nil;
-- 当前灵根兽背景页 从0开始
local spr_bg_index = 0;


-- 是否第一次打开灵根
local is_first = true;
-- 灵根选中特效
local spr_select = nil;

-- 美术坐标，y坐标需要被480减
local tab_ling_p = {
				-- 1 月狐
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 2 天狼
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 3 灵猿
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 4 星马
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 5 金牛
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 6 苍熊
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 7 腾蛟
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 8 玄武
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 9 朱雀
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 10 白虎
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 11 青龙
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 12 麒麟
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 13 白泽
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 14 重明
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				-- 15 獬豸
				151-40-10,480 -184+50,
				241-70-10,480 -229+160+50,
				164+80-10,480 -279+120+50,
				162+160-10,480 -343+280+50,
				361+20-10,480 -167+50,

				319+120-10,480 -343+260+50,
				393+130,480 -287+100+50,
				361+230-25,480 -167+100+50,
				};

local tab_ling_p_btn = {};--穴位
local tab_ling_l = {};--穴位连线

local LINGGEN_POINT_WIDTH = 79
local LINGGEN_POINT_HEIGHT = 81

local LINGGEN_POINT_CHARACTER_WIDTH=35
local LINGGEN_POINT_CHARACTER_HEIGHT=35

local LING_P_OFFSET = 16;
local LING_WIDTH = 25;

local BOOK_PATH_TAB = {
	UIPIC_LingGen_009,
	UIPIC_LingGen_0010,
	UIPIC_LingGen_0011,
	UIPIC_LingGen_0012,
	UIPIC_LingGen_0013,
	UIPIC_LingGen_0014,
	UIPIC_LingGen_0015,
	UIPIC_LingGen_0016,
	UIPIC_LingGen_0017,
	UIPIC_LingGen_0018,
	UIPIC_LingGen_0019,
	UIPIC_LingGen_0020,
	UIPIC_LingGen_0021,
	UIPIC_LingGen_0022,
	UIPIC_LingGen_0023,
	UIPIC_LingGen_0024,
}

local tab_ling_character= {
	[1]={normal_pic="ui/linggen/li-1.png",highlight_pic="ui/linggen/li-2.png"}, --力
	[2]={normal_pic="ui/linggen/huan-1.png",highlight_pic="ui/linggen/huan-2.png"}, --幻
	[3]={normal_pic="ui/linggen/jing-1.png",highlight_pic="ui/linggen/jing-2.png"}, --精
	[4]={normal_pic="ui/linggen/yin-1.png",highlight_pic="ui/linggen/yin-2.png"}, --印
	[5]={normal_pic="ui/linggen/ren-1.png",highlight_pic="ui/linggen/ren-2.png"}, --忍
	[6]={normal_pic="ui/linggen/ti-1.png",highlight_pic="ui/linggen/ti-2.png"}, --体
	[7]={normal_pic="ui/linggen/xian-1.png",highlight_pic="ui/linggen/xian-2.png"}, --贤
	[8]={normal_pic="ui/linggen/su-1.png",highlight_pic="ui/linggen/su-2.png"}, --速
}

local  tab_ling_character_btn={};

local _font_size = 16
local _text_color = {
	yellow = "#cfce911",
	white  = "#cfefdf9",
	green = "#c46fa00",
}
local _max_page_index = #_acupoint_pos           -- 最大显示页数

--local _acupoint_btn={}
local _current_page_index=1
--定义页信息  包括穴位，连线，说明等等
local _pageinfo={
	incentre_label=nil, --真气
	acupoint_btn_list={},--穴位
	acupoint_connbar_list={},--连线
	acupoint_name_label=nil, --穴位名称 如“月狐木灵根”
	acupoint_property_label=nil,--穴位详细参数
	acupoint_remark_label=nil,--穴位备注说明
	getway_label=nil,--获得途径
	btn_active=nil,--激活按钮
	btn_active_textlabel=nil,--激活按钮文字
	wait_active_effect=nil, --待激活特效

} 

--local _pageinfo_list={} --页信息列表
local _acupoint_bg=nil --穴位背景

function LingGen:setAcupointState(acupoint, enable)
	if enable==true then
		acupoint:setTexture(UILH_LINGGEN.acupoint_enable)
	else
		acupoint:setTexture(UILH_LINGGEN.acupoint_disable)
	end
end


function LingGen:destroy()
	print("LingGen:destroy")
	-- Window.destroy(self);
	tab_ling_p_btn = {};
	tab_ling_l = {};
	tab_ling_character_btn={};

	for i=1,#_pageinfo.acupoint_btn_list do
		_pageinfo.acupoint_btn_list[i] = nil
	end
	for i=1,#_pageinfo.acupoint_connbar_list do
		_pageinfo.acupoint_connbar_list[i] = nil
	end
	_pageinfo.wait_active_effect=nil
	_acupoint_bg=nil


	-- 当前选择的灵根点索引 从0开始
	curr_select_linggen = 0;
	-- 当前的灵根等级 从0开始
	curr_linggen_lv = 0;
	-- 灵根点说明label的集合
	tab_linggen_labs = {};

	-- 灵根兽背景图
	spr_bg = nil;
	-- 当前灵根兽背景页 从0开始
	spr_bg_index = 0;


	-- 是否第一次打开灵根
	is_first = true;
	-- 星灵选中特效
	spr_select = nil;
end

function LingGen:show()
	require "model/GameSysModel"
	--判断
	if ( GameSysModel:isSysEnabled(GameSysModel.ROOTS) ) then
		UIManager:show_window("linggen_win");
	end
end

function LingGen:set_pagebtn_state()
	-- 如果已经到了上一页，或者最后一页，就变暗
	local page_index = _current_page_index
    if page_index == 1 then 
        self.left_but.view:setCurState( CLICK_STATE_DISABLE )        
        self.right_but.view:setCurState( CLICK_STATE_UP )   
        --print("first page")     
    elseif page_index == _max_page_index then  
        self.left_but.view:setCurState( CLICK_STATE_UP )          
        self.right_but.view:setCurState( CLICK_STATE_DISABLE )   
        --print("last page")       
    else
        self.left_but.view:setCurState( CLICK_STATE_UP )        
        self.right_but.view:setCurState( CLICK_STATE_UP )     
        --print("middle page")     
    end
end

-- 上一页
function LingGen:change_to_pre_page(  )
	
    if _current_page_index - 1 > 0 then
    	 _current_page_index = _current_page_index-1
        --self:change_item_page_by_index( self.current_page_index - 1 )
        self:create_acupoints(_acupoint_bg, _current_page_index)
        -- local temp_acupoint_index = (_current_page_index-1)*8
        local temp_acupoint_index = 0
    	local maxpageindex = math.floor((curr_linggen_lv-1)/8)+1 --最高等级所在的页号  从1开始
        if _current_page_index < maxpageindex then
            temp_acupoint_index = (_current_page_index-1)*8+7
    	else
            temp_acupoint_index= curr_linggen_lv 
    	end

        self:change_selected_linggen_shuoming(temp_acupoint_index)	        
        self:set_pagebtn_state()

    end
end

-- 下一页
function LingGen:change_to_next_page( )
    local maxpageindex = math.floor((curr_linggen_lv-1)/8)+1 --最高等级所在的页号  从1开始
    if _current_page_index < _max_page_index then  	
    	if _current_page_index<maxpageindex or ((_current_page_index==maxpageindex) and (curr_linggen_lv%8==0) )then
	    	_current_page_index = _current_page_index+1
	       --self:change_item_page_by_index( self.current_page_index + 1 )
	       self:create_acupoints(_acupoint_bg, _current_page_index)
	       	local maxpageindex = math.floor((curr_linggen_lv-1)/8)+1 --最高等级所在的页号  从1开始
	        if _current_page_index < maxpageindex then
	            temp_acupoint_index = (_current_page_index-1)*8+7
	    	else
	            temp_acupoint_index= curr_linggen_lv 
	    	end
	       self:change_selected_linggen_shuoming(temp_acupoint_index)	      
	       self:set_pagebtn_state()

	    end
    end
end

--生成穴位
function LingGen:create_acupoints(acupoint_bg, pageindex)
	acupoint_bg_size = acupoint_bg:getSize()
	--经脉点
	--local pageindex=_current_page_index
	local acupointnum = #_acupoint_pos[pageindex]	

	for i=1, acupointnum do
		local temp_acupoint_index = acupointnum*(pageindex-1)+i-1 --从0开始
		local function acupoint_btn_event( eventType, x, y)	
			if eventType==TOUCH_CLICK then
				self:change_selected_linggen_shuoming(temp_acupoint_index)	
			end	
			return true
		end	
		local acupoint_btn_pos=CCPointMake(_acupoint_pos[pageindex][i].x, acupoint_bg_size.height-_acupoint_pos[pageindex][i].y)
		local acupoint_btn = CCNGBtnMulTex:buttonWithFile(
			acupoint_btn_pos.x,acupoint_btn_pos.y,-1,-1,UILH_LINGGEN.acupoint_disable)
		acupoint_btn:setAnchorPoint(0.5,0.5);
		--acupoint_btn:addTexWithFile(CLICK_STATE_DOWN, UILH_LINGGEN.acupoint_disable)
		--acupoint_btn:addTexWithFile(CLICK_STATE_UP, UILH_LINGGEN.acupoint_enable)
		--acupoint_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_LINGGEN.acupoint_enable) --CLICK_STATE_DISABLE用启用状态图片
		acupoint_btn:registerScriptHandler(acupoint_btn_event)		
		acupoint_bg:addChild(acupoint_btn, 999)		
		

        -- print("清掉了动画了吗？",_pageinfo.waitactive_effect)
		if _pageinfo.acupoint_btn_list[i] then
			_pageinfo.acupoint_btn_list[i]:removeFromParentAndCleanup(true)
			_pageinfo.acupoint_btn_list[i]=nil
		end

		_pageinfo.acupoint_btn_list[i]=acupoint_btn

		-- --设置待激活特效	
		if _pageinfo.wait_active_effect~=nil then	
			_pageinfo.wait_active_effect:removeFromParentAndCleanup(true)
			_pageinfo.wait_active_effect=nil
		end

		-- local acupointcount=8
		-- local jihuo_acupointcount = curr_linggen_lv%acupointcount
		
		-- if jihuo_acupointcount<=acupointcount then		
			

		-- 	if curr_linggen_lv < _max_page_index*8 then
		-- 		local nextbtn = _pageinfo.acupoint_btn_list[jihuo_acupointcount+1]
		-- 		local btnsize = nextbtn:getSize()
		-- 		local waitactive_effect = ZImage:create(
		-- 			nextbtn, UILH_LINGGEN.wait_active, btnsize.width/2,btnsize.height/2, -1, -1, -1)
		-- 		waitactive_effect:setAnchorPoint(0.5,0.5)

		-- 		local fadeIn = CCFadeIn:actionWithDuration(1.5)
	 --       		local fadeOut = CCFadeOut:actionWithDuration(1.5)
	 --       		local actseq = CCSequence:actionOneTwo(fadeIn, fadeOut)
		-- 		local actrepeat = CCRepeatForever:actionWithAction(actseq)
		-- 		waitactive_effect.view:runAction(actrepeat)
		-- 		--print("##############wait_active##########")
		-- 		_pageinfo.wait_active_effect = waitactive_effect	
		-- 	end	
		-- end

		--连接线
		if i<acupointnum then
			--print("连线",i)
			local pos1=CCPointMake(_acupoint_pos[pageindex][i].x, acupoint_bg_size.height-_acupoint_pos[pageindex][i].y)
			local pos2=CCPointMake(_acupoint_pos[pageindex][i+1].x, acupoint_bg_size.height-_acupoint_pos[pageindex][i+1].y)
			--print("pos1 ",pos1.x, pos1.y)
			--print("pos2 ",pos2.x, pos2.y)

			local lenght, angle = self:calculate_angle_and_lenght(pos1, pos2)	
			--print("lenght, angle ",lenght, angle)		
			local btn_connbar = ZImage:create(acupoint_bg, UILH_LINGGEN.acupoint_connbar, pos1.x, pos1.y, lenght, 10)
			local linesize=btn_connbar:getSize()
			btn_connbar:setAnchorPoint(0.5,0)
			btn_connbar.view:setScaleX(linesize.height/linesize.width)
			btn_connbar.view:setScaleY(linesize.width/linesize.height)
			btn_connbar.view:setRotation(90+angle)

			if _pageinfo.acupoint_connbar_list[i] then
				_pageinfo.acupoint_connbar_list[i].view:removeFromParentAndCleanup(true)
				_pageinfo.acupoint_connbar_list[i]=nil
			end
			_pageinfo.acupoint_connbar_list[i]=btn_connbar
		end
	end	
end

function LingGen:__init(window_name, texture_name)

	--self.current_page_index = 1

	--self.item_page_t = {}             -- 存放页的表
    --self.item_slot_t = {}            -- 存放所有已经创建的slot，key 对应背包位置. 这样就不用每次滑动都创建了。但要注意release
 
	--self.label_t = {}       --存储文字label的table，这样可以动态地获取修改文字内容

	local panel_w = 900-10*2
	local panel_h = 605-45 -35

	self.view = ZBasePanel.new( "", panel_w, panel_h).view

	basePanel = self.view

	

	--大背景
	local bg_region_pos = { x = 0, y = 0, width = panel_width, height = panel_height}

    local bg_region = CCBasePanel:panelWithFile( bg_region_pos.x, bg_region_pos.y, bg_region_pos.width,bg_region_pos.height, UILH_COMMON.normal_bg_v2, 500, 500);  --方形区域
    basePanel:addChild(bg_region)

    --左边区域
    -- local left_region_padding={left=10, top=0, right=276, bottom=0}
    local left_region_size = {width = 562, height = 498}
    local left_region = CCBasePanel:panelWithFile(
    	15, 15, left_region_size.width, left_region_size.height, UILH_COMMON.bottom_bg, 500, 500);  --方形区域
    bg_region:addChild(left_region)

    --右边区域背景
    local right_region_size = {width = 276, height = 498}
    local right_region = CCBasePanel:panelWithFile(858, 15, right_region_size.width, right_region_size.height, UILH_COMMON.bottom_bg, 500, 500);  --方形区域
    bg_region:addChild(right_region)
    right_region:setAnchorPoint(1, 0)

    --左边区域背景花纹

    local corner_figure_padding={
    	[1]={left=5, top=5},
    	[2]={top=5, right=5},
    	[3]={right=5, bottom=5},
    	[4]={left=5, bottom=5},
    }
    -- local corner_figure_size=CCSize(-1, -1)

 --    local corner_figure_setting={
 --    	--left top
 --    	[1]={    		
 --    		pos=CCPointMake(corner_figure_padding[1].left, left_region_size.height-corner_figure_padding[1].top),
 --    		anchor=CCPointMake(0, 1), 
 --    		flip={x=false, y=false}
 --    	},
 --    	--right top
 --    	[2]={    		
 --    		pos=CCPointMake(left_region_size.width-corner_figure_padding[2].right, left_region_size.height-corner_figure_padding[2].top),
 --    		anchor=CCPointMake(1, 1), 
 --    		flip={x=true, y=false}
 --    	},
 --    	--right bottom
 --    	[3]={    		
 --    		pos=CCPointMake(left_region_size.width-corner_figure_padding[3].right, corner_figure_padding[3].bottom),
 --    		anchor=CCPointMake(1, 0), 
 --    		flip={x=true, y=true}
 --    	},
 --    	--left bottom
 --    	[4]={    		
 --    		pos=CCPointMake(corner_figure_padding[4].left, corner_figure_padding[4].bottom),
 --    		anchor=CCPointMake(0, 0), 
 --    		flip={x=false, y=true}
 --    	},
	-- }
 --    local corner_figure_padding={left=0, top=0, right=0, bottom=0}    
	-- local corner_figure_size=CCSize(-1, -1)
	-- local corner_figure_pos=CCPointMake(corner_figure1_padding.left, left_region_size.height)    
 --    for i=1, 4 do
	    
	--     local corner_figure = ZImage:create(
	--     	left_region, UILH_LINGGEN.corner_figure, corner_figure_setting[i].pos.x, corner_figure_setting[i].pos.y, 
	--     	corner_figure_size.width, corner_figure_size.height)
	--     local anchor = corner_figure_setting[i].anchor
	--     corner_figure:setAnchorPoint(anchor.x, anchor.y)
	--     corner_figure.view:setFlipX(corner_figure_setting[i].flip.x)
	--     corner_figure.view:setFlipY(corner_figure_setting[i].flip.y)
	-- end


	--左边区域标题
	local left_region_title_padding={top=10}
	local left_region_title_pos=CCPointMake(left_region_size.width/2, left_region_size.height-left_region_title_padding.top)
	--ZLabel:create(fatherPanel, text, x, y, fontSize, aline, z)
	local fmt = _text_color.yellow .. Lang.lenggen.left_top_title .. _text_color.white .. "%d"
	local left_region_title_text = string.format(fmt, 0)
	--left_region_title_text = text .. left_region_title_text
	local left_region_title = ZLabel:create(
		left_region, left_region_title_text, left_region_title_pos.x, left_region_title_pos.y, _font_size, ALIGN_LEFT, 5)
	left_region_title.view:setAnchorPoint(CCPointMake(0.5, 1))
	
	_pageinfo.incentre_label = left_region_title --真气标签

	--经脉背景
	local acupoint_bg_padding={left=22, top=32, right=22, bottom=10}
	-- local acupoint_bg_size=CCSize(
	-- 	left_region_size.width-acupoint_bg_padding.left-acupoint_bg_padding.right,
	-- 	left_region_size.height-acupoint_bg_padding.top-acupoint_bg_padding.bottom
	-- 	)
	
	local acupoint_bg_size=CCSize(530, 480)
	local acupoint_bg_pos=CCPointMake(left_region_size.width/2, acupoint_bg_padding.bottom)
	local acupoint_bg = CCBasePanel:panelWithFile(
		acupoint_bg_pos.x, acupoint_bg_pos.y, acupoint_bg_size.width, acupoint_bg_size.height, "", 500, 500)
	acupoint_bg:setAnchorPoint(0.5, 0)
	local left_bg = ZImage:create(acupoint_bg, "nopack/BigImage/linggen_bg.png", 0, 0, -1, -1)
	local right_bg = ZImage:create(acupoint_bg, "nopack/BigImage/linggen_bg.png", 264.2, 0, -1, -1)
	right_bg.view:setFlipX(true)
	left_region:addChild(acupoint_bg)
	_acupoint_bg = acupoint_bg
	--self:create_acupoints(acupoint_bg) --生成穴位

	local page_btn_padding={left=-10, right=0}
	local page_btn_size=CCSize(-1, -1)
	-- 左翻页
    local function left_but_callback()
        self:change_to_pre_page()
    end
    self.left_but = UIButton:create_button_with_name( 20, 300, -1, -1, 
        UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_disable, "", left_but_callback )
    self.view:addChild(self.left_but.view )
    self.left_but.set_double_click_func( left_but_callback )    
    --self.left_but.view:setFlipY(true)
    self.left_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.arrow_disable )
    self.left_but.view:setAnchorPoint(0, 0.5)
    self.pre_btn = self.left_but

    -- 右翻页
    local function right_but_callback()
        self:change_to_next_page()
    end
    self.right_but = UIButton:create_button_with_name( 590, 300, -1, -1, 
         UILH_COMMON.arrow_normal, UILH_COMMON.arrow_normal, UILH_COMMON.arrow_disable, "", right_but_callback )
    self.view:addChild( self.right_but.view )    
    self.right_but.set_double_click_func( right_but_callback )  -- 双击
    self.right_but.view:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.arrow_disable )
    self.right_but.view:setAnchorPoint(1, 0.5)
    self.next_btn = self.right_but
    self.right_but.view:setFlipX(true)

    local nowy = 543
    --右上区域
    local righttop_region_padding={left=0, top=0, right=0, bottom=0}
    local righttop_region_size=CCSize(right_region_size.width, 198)
    local righttop_region_pos=CCPointMake(righttop_region_padding.left, nowy-righttop_region_padding.top)
    local righttop_region = CCBasePanel:panelWithFile(
    	righttop_region_pos.x, righttop_region_pos.y, righttop_region_size.width,righttop_region_size.height, "", 500, 500);  --方形区域
    right_region:addChild(righttop_region)
    righttop_region:setAnchorPoint(0, 1)

    --右上标题
    local righttop_title_padding={left=0, top=0, right=0}
    local righttop_title_size=CCSize(215, -1)
    local righttop_title_pos={ x = righttop_region_size.width/2, y = righttop_region_size.height-50}
    local righttop_title = ZImage:create(
	    	righttop_region, UILH_NORMAL.title_bg4, righttop_title_pos.x, righttop_title_pos.y, 
	    	righttop_title_size.width, righttop_title_size.height,500,500)
    righttop_title:setAnchorPoint(0.5, 1)
    
    --右上标题文字
    righttop_title_size = righttop_title:getSize()
    local righttop_label_padding={left=0, top=0, right=0, bottom=0}
    local righttop_label_pos=CCPointMake(righttop_title_size.width/2, righttop_title_size.height/2+3)
    local righttop_label = ZLabel:create(righttop_title, "", 
    	righttop_label_pos.x, righttop_label_pos.y, _font_size, ALIGN_LEFT)
    righttop_label.view:setAnchorPoint(CCPointMake(0.5, 0.5))

    _pageinfo.acupoint_name_label = righttop_label --穴位名称

    --右上内容文字
    local righttop_label_size = righttop_label:getSize()
    local righttop_content_padding={left=10, top=45, right=10, bottom=10}
    local righttop_content_size=CCSize(
    	righttop_region_size.width-righttop_content_padding.left-righttop_content_padding.right,
    	righttop_region_size.height-righttop_content_padding.top-righttop_content_padding.bottom)
    local righttop_content_pos=CCPointMake(righttop_content_padding.left, righttop_region_size.height-righttop_content_padding.top)
    local righttop_content = ZDialog:create(righttop_region, "", 
    	righttop_content_pos.x, righttop_content_pos.y-30, righttop_content_size.width, righttop_content_size.height, _font_size)
    righttop_content.view:setLineEmptySpace(5)
    righttop_content:setAnchorPoint(0, 1)

    _pageinfo.acupoint_property_label = righttop_content --穴位详细参数

    --激活按钮
    local function active_event(evnetType, x, y)    	
		if(evnetType == TOUCH_CLICK) then
			Instruction:handleUIComponentClick(instruct_comps.BOOK_WIN_ACTIVATE_BTN)
			Analyze:parse_click_main_menu_info(259)
			if curr_linggen_lv>=_max_page_index*8 then
				print("已经达到等级上限")
				return
			end

			-- Instruction:handleUIComponentClick(instruct_comps.BOOK_WIN_ACTIVATE_BTN)
			
			if curr_select_linggen+1 <= curr_linggen_lv then 
				--print("已经升级",curr_select_linggen,curr_linggen_lv);
				return
			elseif	curr_select_linggen+1 > (curr_linggen_lv+1) then
				--print("灵根等级不够");
				return			
			end

			
			LingGenCC:req_level_up();
		end	    	
    end
    local active_btn_padding={right=10, bottom=10}
    local active_btn_pos=CCPointMake(200, active_btn_padding.bottom)
    local active_btn_size=CCSize(-1, -1)
    -- local active_btn = ZTextButton:create(righttop_region, "激活", UILH_COMMON.lh_button2, 
    --     active_event, active_btn_pos.x, active_btn_pos.y, active_btn_size.width, active_btn_size.height)
	local active_btn = CCNGBtnMulTex:buttonWithFile(
			active_btn_pos.x, active_btn_pos.y-30, active_btn_size.width, active_btn_size.height, UILH_COMMON.lh_button2)
    --active_btn:setFontSize(_font_size) --设置字体大小
	active_btn:setAnchorPoint(1, 0)
	active_btn:registerScriptHandler(active_event)
	active_btn:addTexWithFile(CLICK_STATE_DISABLE, UILH_COMMON.lh_button2_disable)
	righttop_region:addChild(active_btn)
	active_btn_size = active_btn:getSize()
	--MUtils:create_zxfont(parent,str,pos_x,pos_y,aligntype,fontsize,z)
	_pageinfo.btn_active_textlabel = MUtils:create_zxfont(active_btn, Lang.lenggen.btn_active_text, active_btn_size.width/2, active_btn_size.height/2-5, ALIGN_LEFT, _font_size) 
	local txt_size = _pageinfo.btn_active_textlabel:getSize()
	_pageinfo.btn_active_textlabel:setPosition(active_btn_size.width/2-txt_size.width/2,active_btn_size.height/2-txt_size.height/2+3)
	_pageinfo.btn_active = active_btn --激活按钮

    --右中区域
    nowy = nowy - righttop_region_padding.top - righttop_region_size.height
    local rightmid_region_padding={left=0, top=0, right=0, bottom=0}
    local rightmid_region_size=CCSize(right_region_size.width, 98)
    local rightmid_region_pos=CCPointMake(rightmid_region_padding.left, nowy-rightmid_region_padding.top)
    local rightmid_region = CCBasePanel:panelWithFile(
    	rightmid_region_pos.x, rightmid_region_pos.y, rightmid_region_size.width,rightmid_region_size.height, "", 500, 500);  --方形区域
    right_region:addChild(rightmid_region)
    rightmid_region:setAnchorPoint(0, 1)

    --右中标题
    local rightmid_title_padding={left=0, top=0, right=0}
    local rightmid_title_size=CCSize(215, -1)
    local rightmid_title_pos=CCPointMake(rightmid_region_size.width/2, rightmid_region_size.height-rightmid_title_padding.top)
    local rightmid_title = ZImage:create(
	    	rightmid_region, UILH_NORMAL.title_bg4, rightmid_title_pos.x, rightmid_title_pos.y-30, 
	    	rightmid_title_size.width, rightmid_title_size.height,500,500)
    rightmid_title:setAnchorPoint(0.5, 1)
    
    --右中标题文字
    rightmid_title_size = rightmid_title:getSize()
    local rightmid_label_padding={left=0, top=0, right=0, bottom=0}
    local rightmid_label_pos=CCPointMake(rightmid_title_size.width/2, rightmid_title_size.height/2+3)
    local rightmid_label = ZLabel:create(rightmid_title, _text_color.yellow .. Lang.lenggen.acupoint_remark_title, 
    	rightmid_label_pos.x, rightmid_label_pos.y, _font_size, ALIGN_LEFT)
    rightmid_label.view:setAnchorPoint(CCPointMake(0.5, 0.5))



    --右中内容文字
    local rightmid_label_size = rightmid_label:getSize()
    local rightmid_content_padding={left=10, top=45, right=10, bottom=5}
    local rightmid_content_size=CCSize(
    	rightmid_region_size.width-rightmid_content_padding.left-rightmid_content_padding.right,
    	rightmid_region_size.height-rightmid_content_padding.top-rightmid_content_padding.bottom)
    local rightmid_content_pos=CCPointMake(rightmid_content_padding.left, rightmid_region_size.height-rightmid_content_padding.top)
    local rightmid_content = ZDialog:create(rightmid_region, Lang.lenggen.acupoint_remark_content, 
    	rightmid_content_pos.x, rightmid_content_pos.y-30, rightmid_content_size.width, rightmid_content_size.height, _font_size)
    rightmid_content.view:setLineEmptySpace(5)
    rightmid_content:setAnchorPoint(0, 1)

    _pageinfo.acupoint_remark_label = rightmid_content --战阵说明内容

    --右下区域
    nowy = nowy - rightmid_region_padding.top - rightmid_region_size.height
    local rightbottom_region_padding={left=0, top=0, right=0, bottom=0}
    local rightbottom_region_size=CCSize(right_region_size.width, 198)
    local rightbottom_region_pos=CCPointMake(rightbottom_region_padding.left, nowy-rightbottom_region_padding.top)
    local rightbottom_region = CCBasePanel:panelWithFile(
    	rightbottom_region_pos.x, rightbottom_region_pos.y, rightbottom_region_size.width,rightbottom_region_size.height, "", 500, 500);  --方形区域
    right_region:addChild(rightbottom_region)
    rightbottom_region:setAnchorPoint(0, 1)
    
    --右下标题
    local rightbottom_title_padding={left=0, top=0, right=0}
    local rightbottom_title_size=CCSize(215, -1)
    local rightbottom_title_pos=CCPointMake(rightbottom_region_size.width/2, rightbottom_region_size.height-rightbottom_title_padding.top)
    local rightbottom_title = ZImage:create(
	    	rightbottom_region, UILH_NORMAL.title_bg4, rightbottom_title_pos.x, rightbottom_title_pos.y-30, 
	    	rightbottom_title_size.width, rightbottom_title_size.height,500,500)
    rightbottom_title:setAnchorPoint(0.5, 1)

    --右下标题文字
    rightbottom_title_size = rightbottom_title:getSize()
    local rightbottom_label_padding={left=0, top=0, right=0, bottom=0}
    local rightbottom_label_pos=CCPointMake(rightbottom_title_size.width/2, rightbottom_title_size.height/2+3)
    local rightbottom_label = ZLabel:create(rightbottom_title, _text_color.yellow .. Lang.lenggen.getway_title, 
    	rightbottom_label_pos.x, rightbottom_label_pos.y, _font_size, ALIGN_LEFT)
    rightbottom_label.view:setAnchorPoint(CCPointMake(0.5, 0.5))

    --右下内容文字
    local rightbottom_label_size = rightbottom_label:getSize()
    local rightbottom_content_padding={left=10, top=45, right=10, bottom=5}
    local rightbottom_content_size=CCSize(
    	rightbottom_region_size.width-rightbottom_content_padding.left-rightbottom_content_padding.right,
    	rightbottom_region_size.height-rightbottom_content_padding.top-rightbottom_content_padding.bottom)
    local rightbottom_content_pos=CCPointMake(rightbottom_content_padding.left, rightbottom_region_size.height-rightbottom_content_padding.top)
    local rightbottom_content = ZDialog:create(rightbottom_region, Lang.lenggen.getway_content, 
    	rightbottom_content_pos.x, rightbottom_content_pos.y-30, rightbottom_content_size.width, rightbottom_content_size.height, _font_size)
    rightbottom_content.view:setLineEmptySpace(5)
    rightbottom_content:setAnchorPoint(0, 1)

    _pageinfo.getway_label = rightbottom_content --真气获得 内容
end 

require "UI/component/ToggleView"
function LingGen:init_with_args(page_index)
	-- -- 当前选择的灵根点索引 从0开始
	local linggen_num = 8 * page_index;

	self:create_acupoints(_acupoint_bg, page_index+1) --生成穴位
	if ( is_first == false ) then 
		-- 更换文字说明
		self:change_selected_linggen_shuoming(linggen_num);

	end
	self:set_pagebtn_state()

end


-- 根据给出的两个点计算两个点之间的长度和角度
function LingGen:calculate_angle_and_lenght(p1,p2)
	local xdis = p1.x - p2.x
	local ydis = p1.y - p2.y
	local v1 = xdis * xdis + ydis * ydis
	--print(v1);
	local lenght = math.sqrt(v1);
	--local v = (math.abs(p1.x - p2.x)) / lenght;
	local v = (-(p1.x - p2.x)) / lenght;
	local angle = math.deg(math.acos(v));
	
	if( p2.y > p1.y) then
		angle = 360 - angle;
	end
	--print("lenght = ".. lenght .. "  angle = ".. angle);
	-- 因为p1,p2，是两个圆的中心点，lenght是两个中心点的长度，然后需求是求两个圆边角连线的长度，所以要减去圆的半径乘于2
	-- 圆的半径39
	--lenght = lenght - 19 * 2;
	return lenght,angle;
end

-- 根据圆的中心点坐标，半径，和角度，计算圆边线上的坐标
function calculate_ccp_by_radius_and_angle(p1,p2,radius,angle)

	local result_x,result_y = 0

	if( angle <= 90) then
		-- 角度转弧度
		local rad = math.rad(angle);
		-- 半径12.5
		result_x = math.cos(rad) * radius;
		result_y = math.sin(rad) * radius;
		result_y = - result_y;

	elseif ( angle <= 180) then 
		angle = angle - 90;
		-- 角度转弧度
		local rad = math.rad(angle);
		result_y = math.cos(rad) * radius;
		result_x = math.sin(rad) * radius;
		result_y = - result_y;
		result_x = - result_x;

	elseif (angle <= 270) then
		angle = angle - 180;
		-- 角度转弧度
		local rad = math.rad(angle);
		result_x = math.cos(rad) * radius;
		result_y = math.sin(rad) * radius;
		result_x = - result_x;

	elseif (angle <= 360) then
		angle = 360 - angle;
		-- 角度转弧度
		local rad = math.rad(angle);
		result_x = math.cos(rad) * radius;
		result_y = math.sin(rad) * radius;
	end

	--print("result_x = ".. result_x.."  result_y= "..result_y);
	
	local result_p1 = CCPoint(p1.x + result_x,p1.y + result_y);

	-- result_x = math.cos(360-90-angle) * radius;
	-- result_y = math.sin(360-90-angle) * radius;
	-- local result_p2 = CCPoint(p2.x + result_x)
	return result_p1;
end


-- 改变选中灵根的说明文字
function LingGen:change_selected_linggen_shuoming(linggen_point_index)
	print("function LingGen:change_selected_linggen_shuoming(linggen_point_index)",linggen_point_index)
	--print("change_selected_linggen_shuoming",linggen_point_index, curr_linggen_lv)

	curr_select_linggen = linggen_point_index;
	--print("curr_linggen_lv, curr_select_linggen ", curr_linggen_lv, curr_select_linggen)

	local str,attri,value,expr,coin = RootConfig:get_info_by_level( linggen_point_index );

	_pageinfo.acupoint_name_label:setText(_text_color.yellow .. str)
	
	--if curr_linggen_lv >= curr_select_linggen+1 then
		-- -- 消耗灵气
		-- tab_linggen_labs[2]:setIsVisible(false);
		-- -- 消耗银两
		-- tab_linggen_labs[3]:setIsVisible(false);
		-- -- 激活按钮文字
		-- tab_linggen_labs[6]:setIsVisible(false);
		-- -- 消耗灵气标题
		-- tab_linggen_labs[7]:setIsVisible(false);
		-- -- 消耗银两标题
		-- tab_linggen_labs[8]:setIsVisible(false);
		-- -- 已激活
		-- tab_linggen_labs[9]:setIsVisible(true);
		--_pageinfo.acupoint_property_label.view:setIsVisible(false)
		--_pageinfo.btn_active:setIsVisible(false)

		
	--else
		-- 消耗灵气
		--tab_linggen_labs[2]:setIsVisible(true);
		_pageinfo.acupoint_property_label.view:setIsVisible(true)
		local attistr="" --属性内容
		--attri,value,expr,coin
		
		local player = EntityManager:get_player_avatar();
		local can_jihuo = true;
		local color = "#cffffff";
		if ( player.lingQi <  expr ) then
			color = "#cfff000";
			can_jihuo = false;
		end
		-- -- 消耗查克拉
		-- tab_linggen_labs[2]:setString(color..tostring(expr))		
		-- -- 消耗银两
		-- tab_linggen_labs[3]:setIsVisible(true)
		if ( player.yinliang < coin ) then
			color = "#cff0000";
			can_jihuo = false;
		else
			color = "#cffffff";
		end

		if ( curr_linggen_lv < curr_select_linggen ) then
			can_jihuo = false;
		end

		--tab_linggen_labs[3]:setString(color..tostring(coin));

		

		-- 激活按钮
		--tab_linggen_labs[6]:setIsVisible(true);
		_pageinfo.btn_active:setIsVisible(true)

		if ( can_jihuo  == false) then
			-- tab_linggen_labs[6]:setCurState(CLICK_STATE_DISABLE);
		else
			-- tab_linggen_labs[6]:setCurState(CLICK_STATE_UP);
		end
		-- -- 消耗灵气标题
		-- tab_linggen_labs[7]:setIsVisible(true);
		-- -- 消耗银两标题
		-- tab_linggen_labs[8]:setIsVisible(true);
		-- -- 已激活
		-- tab_linggen_labs[9]:setIsVisible(false);
		attistr = LH_COLOR[2] .. attistr .. attri .. "：" .. "+" .. tostring(value) .. "#r" .. LH_COLOR[2] .. Lang.lenggen.active_use_zhenqi .. tostring(expr) .. "#r" .. LH_COLOR[2] .. Lang.lenggen.active_use_yinliang .. tostring(coin)	
		_pageinfo.acupoint_property_label:setText(attistr)
	--end

	if (curr_select_linggen == curr_linggen_lv) then
		if can_jihuo == true then
			-- print("可以激活")
			_pageinfo.btn_active:setCurState( CLICK_STATE_UP )
			_pageinfo.btn_active_textlabel:setText(Lang.lenggen.btn_active_text)
		else
			-- print("材料不够")
			_pageinfo.btn_active:setCurState( CLICK_STATE_DISABLE )
			_pageinfo.btn_active_textlabel:setText(Lang.lenggen.btn_active_text)
		end
	elseif (curr_select_linggen > curr_linggen_lv) then
		-- print("灵根等级不够")
		_pageinfo.btn_active:setCurState( CLICK_STATE_DISABLE )
		_pageinfo.btn_active_textlabel:setText(Lang.lenggen.btn_active_text)
	else
		-- print("已经激活")
		_pageinfo.btn_active:setCurState( CLICK_STATE_DISABLE )
		_pageinfo.btn_active_textlabel:setText(Lang.lenggen.btn_active_text2)
	end

	--spr_select:setPosition(CCPoint( tab_ling_p[2 *linggen_point_index + 1] -l_m + 38,tab_ling_p[2 *linggen_point_index + 2] - b_m+38))

	--local jihuo_lastpageindex = math.floor((curr_linggen_lv-1)/8) --从0开始的页索引
	--for i=0, jihuo_lastpageindex do
		local acupointcount=#_acupoint_pos[_current_page_index]
		local maxpageindex = math.floor((curr_linggen_lv-1)/8)+1 --最高等级所在的页号  从1开始
		local curpage_actived_pointnum=  0
		if _current_page_index<maxpageindex then
			curpage_actived_pointnum = 8
		elseif _current_page_index==maxpageindex  then
			if curr_linggen_lv%8==0 then
				curpage_actived_pointnum = 8
			else
				curpage_actived_pointnum = curr_linggen_lv%acupointcount				
			end
		else
			curpage_actived_pointnum = 0
		end

		--(_current_page_index<maxpageindex) and 8 or (curr_linggen_lv%acupointcount)  --当前页激活的穴位数
		for j=1, curpage_actived_pointnum do
			--_pageinfo.acupoint_btn_list[j]:setCurState(CLICK_STATE_DISABLE)
			_pageinfo.acupoint_btn_list[j]:setTexture(UILH_LINGGEN.acupoint_enable)
			_pageinfo.acupoint_btn_list[j]:addTexWithFile(CLICK_STATE_DOWN, UILH_LINGGEN.acupoint_enable)
			_pageinfo.acupoint_btn_list[j]:addTexWithFile(CLICK_STATE_UP, UILH_LINGGEN.acupoint_enable)
		end

		--设置待激活特效
		if _pageinfo.wait_active_effect~=nil then	
			-- if  curpage_actived_pointnum ~=0 then
			if  curpage_actived_pointnum ~=0  then
				_pageinfo.wait_active_effect:removeFromParentAndCleanup(true)
				_pageinfo.wait_active_effect=nil
			end
		    -- end
		end
		if curpage_actived_pointnum<acupointcount then	
			if curr_linggen_lv < _max_page_index*8 then
				local nextbtn = _pageinfo.acupoint_btn_list[curpage_actived_pointnum+1]
				local btnsize = nextbtn:getSize()

				--local waitactive_effect = ZImage:create(
				--	nextbtn, UILH_LINGGEN.wait_active, btnsize.width/2,btnsize.height/2, -1, -1, -1)
				--local waitactive_effect = CCBasePanel:panelWithFile(
				--	btnsize.width/2,btnsize.height/2, -1, -1, UILH_LINGGEN.wait_active)
				--nextbtn:addChild(waitactive_effect)
				local waitactive_effect = MUtils:create_sprite(
					nextbtn, UILH_LINGGEN.wait_active, btnsize.width/2,btnsize.height/2, -1)
    			waitactive_effect:setAnchorPoint(CCPointMake(0.5,0.5))

				--waitactive_effect:setAnchorPoint(0.5,0.5)	

				local fadeIn = CCFadeIn:actionWithDuration(0.5)
	       		local fadeOut = CCFadeOut:actionWithDuration(0.5)

				--local moveby = CCMoveBy:actionWithDuration(1.0,CCPointMake(-32,0))

	       		local actseq = CCSequence:actionOneTwo(fadeOut, fadeIn)
				local actrepeat = CCRepeatForever:actionWithAction(actseq)

				--print("actrepeat is ", actrepeat==nil and "nil" or "not nil")
				waitactive_effect:stopAllActions()
				waitactive_effect:runAction(actrepeat)
				--print("##############wait_active##########")
				_pageinfo.wait_active_effect = waitactive_effect	
			end	

		end
	--end
	
end

-- 点激活按钮时操作
function LingGen:do_jihuo()
	local page_index = math.floor(curr_linggen_lv / 8);
	local num = curr_linggen_lv % 8 ;
	

	-- -- 连线
	-- if ( num > 0) then
	-- 	local i = num - 1; 
	-- 	local p1 = CCPoint(tab_ling_p[i*2+1 +page_index * 16] -l_m+ LINGGEN_POINT_WIDTH/2 ,tab_ling_p[i*2+2 +page_index * 16] -b_m+ LINGGEN_POINT_HEIGHT/2);
	-- 	local p2 = CCPoint(tab_ling_p[i*2+3 +page_index * 16] -l_m+ LINGGEN_POINT_WIDTH/2 ,tab_ling_p[i*2+4 +page_index * 16] -b_m+ LINGGEN_POINT_HEIGHT/2);
	-- 	local lenght,angle = calculate_angle_and_lenght(p1,p2);
	-- 	local p = calculate_ccp_by_radius_and_angle(p1,p2,40,angle);

	-- 	if ( tab_ling_l[i + 1] ) then
	-- 		tab_ling_l[i + 1]:removeFromParentAndCleanup(true);
	-- 		tab_ling_l[i + 1] = nil;
	-- 	end

	-- 	tab_ling_l[i + 1] = MUtils:create_sprite(basePanel,"ui/linggen/ling_line_highlight.png",p.x,p.y);
	-- 	tab_ling_l[i + 1]:setScaleX(lenght/(LING_WIDTH-12))
	-- 	tab_ling_l[i + 1]:setAnchorPoint(CCPoint(0,0.5));
	-- 	tab_ling_l[i + 1]:setRotation(angle);
	-- end
	
	-- -- 当前点亮的灵根显示另外一张图片
	-- tab_ling_p_btn[num + 1]:show_frame(2);
	-- tab_ling_character_btn[num+1]:show_frame(2);

	-- 判断当前点亮的灵根是不是当前页的最后一个，如果是的话，自动帮忙切到下一页
	-- if (num == 0 ) then 
	-- 	-- if ( page_index  > _LINGGEN_NUM-2) then 
	-- 	-- 	print("LingGen::当前是最后一页");
	-- 	-- 	return;
	-- 	-- end
	-- 	if curr_linggen_lv>=_max_page_index*8 then
	-- 		print("已经达到等级上限")
	-- 		return
	-- 	end
	-- 	--self:init_with_args(page_index+1) --下一页
	-- end

	--[[if ( XSZYManager:get_state() == XSZYConfig.LINGGEN_ZY ) then
		XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
		-- 指向关闭按钮 715,480-56-b_m,62,56
		XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.LINGGEN_ZY,3 , XSZYConfig.OTHER_SELECT_TAG );
	end--]]

	

	-- -- 播放激活特效
	-- --xiehande
	-- spr_effect = LuaEffectManager:play_view_effect( 35,0,0,basePanel,false)
	-- -- 移动选中特效的坐标
	-- spr_effect:setPosition(CCPoint( tab_ling_p[2 *curr_linggen_lv + 1]-l_m+38,tab_ling_p[2 *curr_linggen_lv + 2]- b_m + 38));
end

------------------
-- 网络回调函数 --
------------------

function LingGen:cb_do_get_linggen_info(page_index,index)
	--print("LingGen:cb_do_get_linggen_info(page_index,index)",page_index,index);
	local old_spr_bg_index = spr_bg_index;
	--最后一页将翻页
	if page_index>=_max_page_index then
		page_index = page_index - 1
		index = #_acupoint_pos[page_index+1]	
		spr_bg_index = page_index;
		curr_linggen_lv = page_index * 8 + index;
		_current_page_index = page_index+1
		curr_select_linggen = curr_linggen_lv-1  --选中的穴位
	else
		spr_bg_index = page_index;
		curr_linggen_lv = page_index * 8 + index;	

		--if (curr_linggen_lv==(page_index * 8 + index)) then
		
		--else
			_current_page_index = page_index+1 --当前页
			curr_select_linggen = curr_linggen_lv  --选中的穴位
		--end
	end


	--print("after uplevel curr_linggen_lv, curr_select_linggen", curr_linggen_lv, curr_select_linggen)
	

	--local curren_info_page = page_index+2

	-- self:set_linggen_info(curren_info_page)
    -- print("curr_select_linggen = ",curr_select_linggen);
	-- 目前只开放到12级
	-- if ( curr_select_linggen == _LINGGEN_NUM*8 ) then 
	-- 	spr_bg_index = _LINGGEN_NUM-1;
	-- 	curr_select_linggen = _LINGGEN_NUM*8-1;
	-- 	curr_linggen_lv = _LINGGEN_NUM*8-1;
	-- end

	

	if( is_first ) then 

		self:init_with_args(spr_bg_index);
		self:change_selected_linggen_shuoming( curr_select_linggen);

		is_first = false;
	else
		-- 如果是当前页升级
		if old_spr_bg_index == spr_bg_index then
			print("当前页升级")
			--if ( curr_select_linggen > 0 ) then
				self:do_jihuo();
			--end
		else
			print("其他页升级")
			self:init_with_args(spr_bg_index);
		end
	end

	
end

-- 设置当前属性
function LingGen:set_linggen_info(linggen_value)

	-- 读取配置表信息
	-- local root =  RootConfig:get_page_attr(page_index)
	-- 设置空间显示

	-- self.label_t["innerAttack"]:setString("#c00ff00"..tostring(linggen_value.innerAttack))
	-- self.label_t["innerDefence"]:setString("#c00ff00"..linggen_value.innerDefence)
	-- self.label_t["hp"]:setString("#c00ff00"..linggen_value.hp)
	-- self.label_t["criticalStrikes"]:setString("#c00ff00"..linggen_value.criticalStrikes)
	-- self.label_t["outDefence"]:setString("#c00ff00"..linggen_value.outDefence)
	-- self.label_t["defCriticalStrikes"]:setString("#c00ff00"..linggen_value.defCriticalStrikes)
	-- self.label_t["hit"]:setString("#c00ff00"..linggen_value.hit)
	-- self.label_t["dodge"]:setString("#c00ff00"..linggen_value.dodge)
end

-- 被添加或移除到显示节点上面的事件
function LingGen:update( update_type )

	if update_type == "all" then
		local player = EntityManager:get_player_avatar();
		if player then
			--tab_linggen_labs[10]:setText("#cffffff"..player.lingQi);
			_pageinfo.incentre_label:setText(_text_color.yellow .. Lang.lenggen.left_top_title .. _text_color.white .. player.lingQi) --真气值
			
		end
		
		--[[if ( XSZYManager:get_state() == XSZYConfig.LINGGEN_ZY ) then
			XSZYManager:destroy_jt( XSZYConfig.OTHER_SELECT_TAG );
			-- 指向第一个灵根点 115,480 -214,
			XSZYManager:play_jt_and_kuang_animation_by_id( XSZYConfig.LINGGEN_ZY,1 , XSZYConfig.OTHER_SELECT_TAG );
		end--]]

		-- 更新界面
		local page_index,index = LinggenModel:get_current_linggen_info();
		--print("LinggenModel:get_current_linggen_info():page_index,index", page_index,index)
		self:cb_do_get_linggen_info(page_index,index)
		self:update_view();

		-- 删除激活特效
		--LuaEffectManager:stop_view_effect(35,spr_select);
	else
		--[[if ( XSZYManager:get_state() == XSZYConfig.LINGGEN_ZY ) then
            AIManager:do_quest( 333,2 );
			XSZYManager:destroy( XSZYConfig.OTHER_SELECT_TAG );

		end--]]

		-- 清除选中特效
		--LuaEffectManager:stop_view_effect(35,basePanel);
	end
end

function LingGen:update_view( )
	if ( is_first == false ) then
		-- -- 目前只开放到12级
		-- if ( curr_select_linggen == _LINGGEN_NUM*8) then 
		-- 	spr_bg_index = _LINGGEN_NUM-1;
		-- 	curr_select_linggen = _LINGGEN_NUM*8-1;
		-- 	curr_linggen_lv = curr_select_linggen;
		-- end
		ZXLog("---------------3333------------------")
		-- print("update_view:curr_select_linggen, curr_linggen_lv", curr_select_linggen, curr_linggen_lv)

		self:change_selected_linggen_shuoming( curr_select_linggen);
		
	end
	
end

-- 更新灵气
function LingGen:update_lingqi()
	local player = EntityManager:get_player_avatar();
	--print("更新灵气");
	--tab_linggen_labs[10]:setText("#cffffff"..player.lingQi);
	_pageinfo.incentre_label:setText(_text_color.yellow .. Lang.lenggen.left_top_title .. _text_color.white .. player.lingQi) --真气值
end