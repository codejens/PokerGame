-- XianDaoHuiWin.lua
-- create by hcl on 2013-8-9
-- 仙道会界面

require "UI/component/Window"
super_class.XianDaoHuiWin(NormalStyleWindow)

require "UI/xiandaohui/BJZBS"
require "UI/xiandaohui/BJZYS"
require "UI/xiandaohui/GZSM"
require "UI/xiandaohui/LJXW"
require "UI/xiandaohui/SJSLQ"


-- 宠物信息,悟性提升，成长提升，技能学习，技能刻印，宠物融合的table
local tab_pages = {nil,nil,nil,nil,nil};

-- 当前选中tab的index
local curr_node_index = -1;

function XianDaoHuiWin:show()
    UIManager:toggle_window("xiandaohui_win");
end

-- 
function XianDaoHuiWin:__init( )
    -- 创建一个大背景
    local bg = CCZXImage:imageWithFile( 6, 8, 886, 518, UILH_COMMON.normal_bg_v2,500,500 )
    self.view:addChild(bg)

    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.common .. "win_title1.png",397,418);
    -- MUtils:create_sprite(self.view,UIResourcePath.FileLocate.xiandaohui .. "xdh_title.png",397,421);

    -- local function btn_close_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --         UIManager:hide_window("xiandaohui_win");
    --     end
    --     return true
    -- end
    -- local exit_btn = MUtils:create_btn(self.view,UIResourcePath.FileLocate.common .. "close_btn_n.png",UIResourcePath.FileLocate.common .. "close_btn_s.png",btn_close_fun,710,380,-1,-1);
    -- local exit_btn_size = exit_btn:getSize()
    -- local spr_bg_size = self.view:getSize()
    -- exit_btn:setPosition( spr_bg_size.width - exit_btn_size.width, spr_bg_size.height - exit_btn_size.height )
    -- 创建导航栏，上面有5个按钮 1,本届自由赛2,本届争霸赛3,上届十六强4,历届仙王5,规则说明
    self.text_title = {Lang.xiandaohui[1],Lang.xiandaohui[2],Lang.xiandaohui[3],Lang.xiandaohui[4],Lang.xiandaohui[5],}
    self.label_title = {}
    self:create_radio_button_group();
end

function XianDaoHuiWin:create_radio_button_group()
    -- 94*6
    self.raido_btn_group = CCRadioButtonGroup:buttonGroupWithFile(20 ,520 , 101*5,48,nil);
    self.view:addChild(self.raido_btn_group);
    -- 宠物栏上面的6个按钮 1,宠物信息，2悟性提升，3成长提升，4技能学习，5技能刻印，6宠物融合
    -- local base_tab_path = UIResourcePath.FileLocate.xiandaohui.."xdh_r";
    for i=1,5 do

        local function btn_fun(eventType,args,msg_id)
            if eventType == TOUCH_CLICK then
                self:do_tab_button_method(i);
                return true;
            elseif eventType == TOUCH_BEGAN then
                
                return true;
            elseif eventType == TOUCH_ENDED then
                return true;
            end
            return true
        end
        local x = 1+100*(i-1);
        local y = 1;
    
        local btn = MUtils:create_radio_button(self.raido_btn_group,UILH_COMMON.tab_gray,UILH_COMMON.tab_light,btn_fun,x,y,101,48,false);
        self.label_title[i] = MUtils:create_zxfont(btn,LH_COLOR[2]..self.text_title[i],101/2,14,2,15);
        -- MUtils:create_sprite(btn,base_tab_path..i..".png", 47, 18.5);
    end 
end


-- tab上button的回调
function XianDaoHuiWin:do_tab_button_method( index )
    -- 如果点击的面板当前正在显示，直接返回
    if(curr_node_index == index) then
        return;
    end

    -- 更新标题文字颜色
    for i,v in ipairs(self.label_title) do
        v:setText(LH_COLOR[2]..self.text_title[i])
    end
    self.label_title[index]:setText(LH_COLOR[15]..self.text_title[index])

    if ( curr_node_index ~= -1 ) then
        -- 当前显示的面板隐藏
        tab_pages[curr_node_index].view:setIsVisible(false);
    end

    -- 更新选中的面板索引
    curr_node_index = index;
    self.raido_btn_group:selectItem(curr_node_index-1)

    if ( not tab_pages[index] ) then
        if(1 == index) then
            --本届自由赛
            tab_pages[index] = BJZYS();
        elseif(2 == index) then
            --本届争霸赛
            tab_pages[index] = BJZBS();
        elseif(3 == index) then
            --上届十六强
            tab_pages[index] = SJSLQ();
        elseif(4 == index) then
            --历届仙王
            tab_pages[index] = LJXW();
        elseif(5 == index) then
            --规则说明
            tab_pages[index] = GZSM();
        end
        self.view:addChild(tab_pages[index].view);
    else
        tab_pages[index].view:setIsVisible(true);
    end
    -- 子面板更新
    self:update( "sub_panel" )
end

function XianDaoHuiWin:update( _type ,tab_arg)
    -- 更新子面板
    tab_pages[curr_node_index]:update( _type,tab_arg );

end

function XianDaoHuiWin:active( show )
    if ( show ) then
        if ( curr_node_index == -1 ) then
            self:do_tab_button_method(1);
        else
            tab_pages[curr_node_index]:active();
        end
    end
end


function XianDaoHuiWin:destroy()
    curr_node_index = -1
    Window.destroy(self)
    for key, page in pairs(tab_pages) do
        if page.destroy ~= nil then
            page:destroy()
        end
    end
    tab_pages = {nil,nil,nil,nil,nil};
end

