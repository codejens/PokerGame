-- CountDownView.lua
-- create by hcl on 2013-4-10
-- 倒计时界面
require "UI/component/Window"
super_class.CountDownView(Window)

local x_border = 500
local y_border = 130

function CountDownView:show( ready_time, time, is_sysmsgdialog_timer)
    local win = UIManager:show_window("count_down_view");
    if ( win ) then 
        win._ready_time = ready_time;
        win._match_time = time
        win._is_sysmsgdialog_timer = is_sysmsgdialog_timer
        win:init_with_arg();
    end
    return win
end

function CountDownView:__init( window_name, texture_name, is_grid, width, height )
    
    self.number_img = CCZXImage:imageWithFile(0+x_border,130+y_border,65,76,"");
    self.number_img:setAnchorPoint(0.5,0);
    self.view:addChild(self.number_img);
    self.number_img2 = CCZXImage:imageWithFile(66+x_border,130+y_border,65,76,"");
    self.number_img2:setAnchorPoint(0.5,0);
    self.view:addChild(self.number_img2);
    self.number_img3 = CCZXImage:imageWithFile(132+x_border,130+y_border,65,76,"");
    self.number_img3:setAnchorPoint(0.5,0);
    self.view:addChild(self.number_img3);

    self.view:setPosition(300,300)
    self.view:setDefaultMessageReturn(false);

end

function CountDownView:init_with_arg()
    self.is_begin = false;
    self._time = self._ready_time;
    self._timer = timer();
    local function dismiss( dt )
        self:show_next();
    end
    -- 调整数字位置
    self:layout_by_num( self._time )

    -- 一开始马上开始计时
    self:show_next();
    self._timer:start(1,dismiss)
end

function CountDownView:show_next()
    
    if self._time > 0 then
        if ( self._time > 99 ) then
            local num1 = math.floor( self._time/100);
            local num2 = math.floor((self._time - num1 * 100)/10);
            local num3 = self._time - num1 * 100 - num2*10;
            self.number_img:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",num1));
            self.number_img2:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",num2));
            self.number_img3:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",num3));
        elseif ( self._time == 99 ) then
            -- 调整数字位置
            self:layout_by_num( self._time )
            local num1 = math.floor( self._time/10);
            local num2 = self._time - num1 * 10;
            self.number_img:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",num1));
            self.number_img2:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",num2));
        elseif ( self._time > 9 ) then
            local num1 = math.floor( self._time/10);
            local num2 = self._time - num1 * 10;
            self.number_img:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",num1));
            self.number_img2:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",num2));
        elseif ( self._time == 9 ) then
            -- 调整数字位置
            self:layout_by_num( self._time )
            self.number_img:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",self._time));
        else
            self.number_img:setTexture(string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",self._time));
        end
        
    elseif self._time == 0 then
        if ( self.is_begin == false ) then
            self.is_begin = true;
            self._time = self._match_time;
            self:layout_by_num( self._time )
            self.number_img:setTexture("");
        else
            self._timer:stop();
            self._timer = nil;
            UIManager:destroy_window("count_down_view");
        end
        
        end
    self._time = self._time - 1;
end

function CountDownView:layout_by_num( num )
    if ( num > 99 ) then
        self.number_img:setPosition(0+x_border,130+y_border);
        self.number_img2:setPosition(66+x_border,130+y_border);
        self.number_img3:setPosition(132+x_border,130+y_border);
    elseif ( num > 9 ) then
        self.number_img:setPosition(0+x_border,130+y_border);
        self.number_img2:setPosition(66+x_border,130+y_border);
        self.number_img3:setTexture("");
    else
        self.number_img:setPosition(66+x_border,130+y_border);
        self.number_img2:setTexture("");
        self.number_img3:setTexture("");

        -- 对于倒计时为10，而且是系统对话框的倒计时的情况，重置一下number_img位置
        if self._is_sysmsgdialog_timer ~= nil and self._is_sysmsgdialog_timer == true then
        	self.number_img:setPosition(0,0);
        end
    end
end

function CountDownView:destroy()
    Window.destroy(self)
	print("CountDownView:destroy()");
    if ( self._timer ) then 
        self._timer:stop();
        self._timer = nil;
    end
end

function CountDownView:active( show )
	-- 关闭的时候停止计时器
	if ( show == false ) then
        if ( self._timer ) then 
    		self._timer:stop();
            self._timer = nil;
        end
	end
end