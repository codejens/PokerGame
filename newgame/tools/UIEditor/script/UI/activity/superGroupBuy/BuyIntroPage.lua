--CBuyIntroPage.lua
--内容：团购窗口类
--作者：chj
--时间：2015.01.17

local panel_page_w = 412
local panel_page_h = 515

local panel_w = 385
local panel_align_y = 7
local panel_align_x = 13

--创建团购窗口类
super_class.BuyIntroPage()

function BuyIntroPage:__init()

	-- 背景图
	self.view = ZBasePanel.new( UILH_COMMON.normal_bg_v2, panel_page_w, panel_page_h).view

	-- 里层背景图
	ZImage:create(self.view, UILH_COMMON.bottom_bg, panel_align_x, 15, panel_w, 485, 0, 500, 500)

	-- 说明内容
	local str = LH_COLOR[2] .. Lang.SuperGBuy[13]
	self.one_intro = CCDialogEx:dialogWithFile(panel_align_x+20, panel_page_h -30, panel_page_w-70, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.one_intro:setAnchorPoint(0,1);
    self.one_intro:setFontSize(16);
    self.one_intro:setTag(0)
    self.one_intro:setLineEmptySpace (10)
    self.one_intro:setText( str );   
    self.view:addChild(self.one_intro)

    str = LH_COLOR[2] .. Lang.SuperGBuy[14]
    self.two_intro = CCDialogEx:dialogWithFile(panel_align_x+20, panel_page_h -100, panel_page_w-70, 80, 10, "", TYPE_VERTICAL ,ADD_LIST_DIR_UP);
    self.two_intro:setAnchorPoint(0,1);
    self.two_intro:setFontSize(16);
    self.two_intro:setTag(0)
    self.two_intro:setLineEmptySpace (10)
    self.two_intro:setText( str );   
    self.view:addChild(self.two_intro)
end

-- update更新界面
function BuyIntroPage:update( updateType )

end

function BuyIntroPage:active(status)
	--打开窗口
end


function BuyIntroPage:destroy()

end