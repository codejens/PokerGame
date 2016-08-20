-- GZSM.lua
-- create by hcl on 2013-8-16
-- 规则说明

super_class.GZSM()

function GZSM:__init()
	local panel = CCBasePanel:panelWithFile(17,19,864,496,UILH_COMMON.bottom_bg,500,500);
	self.view = panel;
	-- 滑动条
	self:create_scroll(  );
	
	return panel;
end

function GZSM:create_scroll(  )

    local _scroll_info = { x = 10 , y = 10 , width = 840, height = 475, maxnum = 1, stype = TYPE_HORIZONTAL }
    self.scroll = CCScroll:scrollWithFile( _scroll_info.x, _scroll_info.y, _scroll_info.width, _scroll_info.height, _scroll_info.maxnum, nil, _scroll_info.stype )
    self.view:addChild(self.scroll);

    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then

            local temparg = Utils:Split(args,":")
            local row = temparg[1] +1             -- 行

            -- 每行的背景panel
            local panel = CCDialogEx:dialogWithFile(0,0,_scroll_info.width,_scroll_info.height,99999,"",1,ADD_LIST_DIR_UP);
            for i = 1, #Lang.xiandaohui.gzsm do
                panel:insertText( Lang.xiandaohui.gzsm[i].."#r" )
            end
            -- panel:setText(Lang.xiandaohui.gzsm[1]);
            -- panel:insertText(Lang.xiandaohui.gzsm[2]);
            -- panel:insertText(Lang.xiandaohui.gzsm[3]);
            -- panel:insertText(Lang.xiandaohui.gzsm[4]);
            self.scroll:addItem(panel);
            self.scroll:refresh();
            return false
        end
    end
    self.scroll:registerScriptHandler(scrollfun);
    self.scroll:refresh()
end

function GZSM:active()

end

function GZSM:update()
end