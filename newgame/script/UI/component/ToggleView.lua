-- ToggleView
-- create by hcl on 2012-12-12
-- 点击切换图片的控件

super_class.ToggleView()

-- 创建sprite
local function create_sprite(parent,filepath,pos_x,pos_y)

    local spr = CCSprite:spriteWithFile(filepath);
    spr:setPosition(CCPoint(pos_x,pos_y));
    parent:addChild(spr);
    return spr;
end

-- parent 父类容器
-- pos_x,pos_y x,y 坐标
-- width,height    宽高
-- ... 可变参数，切换的图片路径
function ToggleView:create(type,parent,pos_x,pos_y,width,height,fun,ccp,max_num,...)
    if ( max_num  == nil ) then
        max_num = #arg;
    end
    return ToggleView(type,parent,pos_x,pos_y,width,height,fun,ccp,max_num,arg);
end 

-- 可以手动控制显示哪张图片
function ToggleView:__init(type,parent,pos_x,pos_y,width,height,fun,ccp,max_num,table)
    self.btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,"");
    

    self.spr_num = #table;
    self.tab_spr = {};
    self.max_num = max_num;
    self.current_index = 1;
    for i=1,self.spr_num do
        local spr = create_sprite( self.btn,table[i],width * ccp.x,height * ccp.y);
        spr:setAnchorPoint(ccp);
        self.tab_spr[i] = spr;
        if(i ~=1) then
            spr:setIsVisible(false);
        end
    end

    local function btn_fun(eventType,x,y)
        if eventType == TOUCH_BEGAN then
            return true;
        elseif eventType == TOUCH_CLICK then
            if(type == 1) then 
                self.tab_spr[self.current_index]:setIsVisible(false);
                if ( self.current_index == self.max_num ) then
                    
                    self.current_index = 1;
                else
                    self.current_index = self.current_index + 1;
                end
                
                if(self.current_index == (self.spr_num +1)) then
                    self.current_index = 1;
                end
                self.tab_spr[self.current_index]:setIsVisible(true);
            end
            -- 执行方法
            if(fun ~= nil) then
               fun();
            end
            return true;
        end
        return true
    end
    self.btn:registerScriptHandler(btn_fun);
    parent:addChild( self.btn,5);
    return self;
end

-- 更新ToggleView
function ToggleView:update(parent,pos_x,pos_y,width,height,fun,ccp,...)
    self.btn:removeFromParentAndCleanup(true);
    self.btn = nil;
    local table = arg;
    self.btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,table[1]);
    self.spr_num = #table;
    self.tab_spr = {};
    self.current_index = 1;
    for i=1,self.spr_num do
        local spr = create_sprite( self.btn,table[i],width * ccp.x,height * ccp.y);
        spr:setAnchorPoint(ccp);
        self.tab_spr[i] = spr;
        if(i ~=1) then
            spr:setIsVisible(false);
        end
    end
    local function btn_fun(eventType,x,y)
        if  eventType == TOUCH_CLICK then
            if(type == 1) then 
                self.tab_spr[self.current_index]:setIsVisible(false);
                self.current_index = self.current_index + 1;
                if(self.current_index == (self.spr_num +1)) then
                    self.current_index = 1;
                end
                self.tab_spr[self.current_index]:setIsVisible(true);
            end
            -- 执行方法
            if(fun ~= nil) then
               fun();
            end
        end
        return true
    end
     self.btn:registerScriptHandler(btn_fun);
    parent:addChild( self.btn);
    return self;
end

-- 是否隐藏
function ToggleView:setIsVisible(is_vis)
    self.btn:setIsVisible(is_vis);
    self.tab_spr[ self.current_index ]:setIsVisible(is_vis);
end



-- 显示指定的图片
function ToggleView:show_frame(index)
    if (self.current_index == index) then
        return;
    end

    self.tab_spr[self.current_index]:setIsVisible(false);
    self.current_index = index;
    self.tab_spr[self.current_index]:setIsVisible(true);
end

function ToggleView:addChild(child)
    self.btn:addChild(child);
end

function ToggleView:removeFromParentAndCleanup(bool)
    self.btn:removeFromParentAndCleanup(true);
    self.btn = nil;
end



-- 带点击效果的切换图片view
-- 主界面专用
-- 可变参数 1为普通图片，2为选择图片,3为普通图片...
function ToggleView:create2(parent,pos_x,pos_y,width,height,ccp,...)

    local btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,arg[1]);
    
    local spr_num = #arg;
    self.tab_spr = {};
    self.current_index = 1;
    for i=1,spr_num do
        local spr = create_sprite(btn,arg[i],width * ccp.x,height * ccp.y);
        spr:setAnchorPoint(ccp);
        self.tab_spr[i] = spr;
        if(i ~=1) then
            spr:setIsVisible(false);
        end
    end

    local function btn_fun(eventType,x,y)
        if ( self.callback == nil ) then 
            if  eventType == TOUCH_BEGAN then
                -- 必须是单数
                if ( self.current_index %2 == 0) then
                    return true;
                end

                -- 按钮变亮
                self.tab_spr[self.current_index]:setIsVisible(false);
                self.current_index = self.current_index + 1;
                self.tab_spr[self.current_index]:setIsVisible(true);
                return true;
            elseif eventType == TOUCH_ENDED then
                -- 必须是偶数
                if ( self.current_index %2 == 1) then
                    return true;
                end
                -- 按钮切换方向
                self.tab_spr[self.current_index]:setIsVisible(false);
                self.current_index = self.current_index + 1;
                if(self.current_index == (spr_num +1)) then
                    self.current_index = 1;
                end
                self.tab_spr[self.current_index]:setIsVisible(true);

                local is_show_menus = false;
                if(self.current_index == 3) then
                    is_show_menus = true;
                end
                -- 移动
                -- require "UI/main/MenusPanel";
                -- require "UI/main/RightPanel"
                MenusPanel:show_or_hide_panel(is_show_menus);

                self.callback = callback:new();
                local function dismiss( dt )
                    self.callback = nil;
                end
                self.callback:start( 0.5,dismiss)
                return true;
            end
        end
    end
    btn:registerScriptHandler(btn_fun);
    parent:addChild(btn);
    return self;
end 

function ToggleView:show_view()
    if ( self.current_index == 1 ) then
        self.current_index =  self.current_index + 2;
        self.tab_spr[self.current_index]:setIsVisible(true);
        MenusPanel:show_or_hide_panel(true);
    end
end

function ToggleView:hide_view()
    if ( self.current_index == 3 ) then
        self.current_index =  1;
        self.tab_spr[self.current_index]:setIsVisible(true);
        MenusPanel:show_or_hide_panel(false);
    end
end

