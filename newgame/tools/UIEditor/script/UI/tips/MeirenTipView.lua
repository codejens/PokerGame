-- MeirenTipView.lua 
-- createed by xiehande on 2015-3-19
-- MeirenTipView 面板
 
super_class.MeirenTipView(Window)

require "../data/card_tips"

local c3_white  = "#cffffff";
local c3_green 	= "#c38ff33";
local c3_yellow = "#cfff000";
local c3_pink	= "#cff66cc";
local c3_blue	= "#c00c0ff";
local c3_gray	= "#ca7a7a6";
local c3_purple = "#cff66cc";
local c3_red	= "#cff0000";

local FONT_SIZE = UI_TOOLTIPS_FONT_SIZE
-- local TIP_WIDTH = UI_TOOLTIPS_ITEM_DIALOG_WIDTH
-- local TIP_HEIGHT_MIN = UI_TOOLTIPS_RECT_HEIGHT+UI_TOOLTIPS_BORDER*2+UI_TOOLTIPS_ITEM_BUTTON_HEIGHT
local TIP_WIDTH = UI_TOOLTIPS_ITEM_DIALOG_WIDTH
local TIP_HEIGHT_MIN = 64

function MeirenTipView:__init( window_name, texture_name, is_grid, width, height,title_text )
	-- print("width,height",width,height)
	local data = self.model_data
    local item_id = data.card_data.itemId
    local attr = data.attr
    local card_data = data.card_data
    
    if item_id then
        local item = ItemConfig:get_item_by_id( item_id)
    	--美人头像
		local meiren_icon_bg = CCZXImage:imageWithFile(15,height,-1,-1,UILH_NORMAL.skill_bg1);
		meiren_icon_bg:setAnchorPoint(0,1);
		self.view:addChild(meiren_icon_bg);
		
  		local icon_resPath = string.format( "%s%s.pd","icon/item/",item_id)

		self.meiren_icon = CCZXImage:imageWithFile(90/2,90/2,-1,-1,icon_resPath);
		self.meiren_icon:setAnchorPoint(0.5,0.5);
		meiren_icon_bg:addChild(self.meiren_icon);

		--美人名字
		local item_base = ItemConfig:get_item_by_id( item_id )
	    if item_base == nil then
	        return 
	    end
		local name_color = ItemModel:get_item_color( item_id )

		self.meiren_name = CCZXLabel:labelWithText(105,height-30,name_color..item_base.name,16,ALIGN_LEFT);
		self.view:addChild(self.meiren_name);
    
        --战斗力
        local fight_val = HeluoBooksModel.get_card_fight_value( attr )
		local zhandouli = CCZXLabel:labelWithText(105,height-62,Lang.lingqi.hougong[12],16,ALIGN_LEFT);
		self.view:addChild(zhandouli);
	    
	    --战斗力数值
	    self.fight = CCZXLabel:labelWithText(175,height-62,fight_val,16,ALIGN_LEFT);
		self.view:addChild(self.fight);

  		  --美人原画
  		local meiren_bg = CCZXImage:imageWithFile(56,378,166+20,221+20,UILH_COMMON.bottom_bg,500,500);
  		local resPath = string.format( "%s%s.png","ui/lh_lingqi_hg/",string.format("kapai_%04d",card_data.id))
	    self.meiren_img = CCZXImage:imageWithFile(10,10,-1,-1,resPath,500,500);
	    meiren_bg:addChild(self.meiren_img)
		self.view:addChild(meiren_bg);


    --基础属性

    local  basic_txt= CCZXLabel:labelWithText(10,355,LH_COLOR[2]..Lang.lingqi.hougong[13],16,ALIGN_LEFT);
	self.view:addChild(basic_txt);
    
	local row_height = data.row_height or 30
	local item_num = #data.contents or 0

	 local col_count = 1
	if data.cols_width then
	    col_count = #data.cols_width
	end

        -- local desc_height = item_desc_dialog:getInfoSize().height;
        -- local cont_height = row_height*item_num
        -- local height = cont_height + desc_height
    local height = 360

 	 if data.contents then
            for i = 1, item_num do
                height = height - row_height
                -- local row_panel = ZBasePanel:create( self.view, "", 0, height, 280, row_height, 500, 500 )
                local content = data.contents[i]
                local x = 10
                for j = 1, col_count do
                    local text = content[j]
                    local text_panel = ZLabel:create( self.view, text , x, height, data.content_font )
                    x = x + data.cols_width[j]
                end
            end
        end

    --分割线
    local split_img = CCZXImage:imageWithFile( 10, 177, 280, 3, UILH_COMMON.split_line )
    self.view:addChild( split_img )
    -- 美人描述
    local describe = CCZXLabel:labelWithText(10,155,LH_COLOR[2]..Lang.lingqi.hougong[14],16,ALIGN_LEFT);
    self.view:addChild(describe)

	self.describe_val = CCDialogEx:dialogWithFile(10, 85,280, 30, 14, "", 1 ,ADD_LIST_DIR_UP);
	self.describe_val:setFontSize(16);
	self.describe_val:setText(tips.cardConfig[card_data.id].des);
	self.view:addChild(self.describe_val)
    

    local split_img2 = CCZXImage:imageWithFile( 10, 69, 280, 3, UILH_COMMON.split_line )
    self.view:addChild( split_img2 )


    --获取方式
    local achieve_txt =   CCZXLabel:labelWithText(10,44,LH_COLOR[2]..Lang.lingqi.hougong[15],16,ALIGN_LEFT);
    self.view:addChild(achieve_txt)
    -- local item = ItemConfig:get_item_by_id( item_id)
    -- local item_desc_text = c3_white.. item.desc;
	self.achieve_val = CCDialogEx:dialogWithFile(10, 10,UI_TOOLTIPS_RECT_WIDTH - 30, 30, 14, "", 1 ,ADD_LIST_DIR_UP);
	self.achieve_val:setFontSize(16);
	self.achieve_val:setText(tips.cardConfig[card_data.id].source);
	self.view:addChild(self.achieve_val)

	-- -- if self.model_data.level < 10 and self.model_data.level ~= 0 then 
	-- 	--------------------------	-昏割线
	-- 	local split_img = CCZXImage:imageWithFile(10,contentHeight-skill_desc_height-71-15-15,UI_TOOLTIPS_RECT_WIDTH - 30,3,UILH_COMMON.split_line);
	-- 	self.view:addChild(split_img);
	
	-- 	--根据动态高度重新设置contentSize
	-- local contentHeight = 120+skill_desc_height+next_desc_height;
	-- self.view:setSize(UI_TOOLTIPS_RECT_WIDTH,contentHeight);	


	-- -- end


    end

end

function MeirenTipView:create( model_data )
	self.model_data = model_data;
	-- return MeirenTipView(TIP_WIDTH,TIP_HEIGHT_MIN);

		-- local temp_info = { texture = "", x = 0, y = 5, width = 280, height = 239 }
	return MeirenTipView("MeirenTipView", "", true, 300, 700);


end


function MeirenTipView:destroy(  )
   Window:destroy(self)

end
