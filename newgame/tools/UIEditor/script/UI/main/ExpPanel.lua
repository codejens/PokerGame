-- ExpPanel.lua
-- create by hcl on 2012-3-29
-- 经验条

require "utils/MUtils"
require "UI/component/Window"

super_class.ExpPanel(Window)

-- local exp_view_table = {};
local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

function ExpPanel:__init( )

    local exp_bg = ZImage:create(self.view,UILH_MAIN.m_exp_bg,209,0,534,13, nil, 500, 500)
    self.exp = MUtils:create_zximg(exp_bg,UILH_MAIN.m_exp_fg,22,3,490,5,500,500);
    local beg_x = 21
    local exp_width = 49
    for i = 1,9 do
        ZImage:create(exp_bg, UILH_MAIN.m_exp_line, beg_x+i*exp_width, 1, -1, -1)
    end
    -- for i=1,9 do
    --     local spr = MUtils:create_sprite(self.view, UIResourcePath.FileLocate.main .. "m_exp2.png",80*i-1,3,2);
    --     spr:setScaleY(2.0);
    -- end
end

function ExpPanel:updateExp( )
    local player = EntityManager:get_player_avatar();
    local player_exp = player.expH *(2^32) + player.expL
    local player_max_exp = player.maxExpH *(2^32) + player.maxExpL
    local exp_rate = player_exp/player_max_exp ;
    --防止连续升级时的经验条溢出
    local _, rate = math.modf(exp_rate)
    self.exp:setScaleX(rate);
    -- for i=1,10 do
    --     if ( i <= exp_view_num ) then
    --         if ( exp_view_table[i] == nil ) then
    --             exp_view_table[i] = MUtils:create_zximg2(self.view, UIResourcePath.FileLocate.main .. "m_exp.png",(i-1)*80,-1,80,6,8,2,8,2,8,2,8,2);
    --         else
    --             exp_view_table[i]:setSize( 80,4 );
    --         end
    --     elseif ( i== exp_view_num+1 ) then
    --         if ( exp_rate - exp_view_num > 0 ) then
    --             if ( exp_view_table[exp_view_num+1] ) then
    --                 exp_view_table[exp_view_num+1]:setSize( (exp_rate - exp_view_num)*80,4 );
    --             else
    --                 exp_view_table[i] = MUtils:create_zximg2(self.view, UIResourcePath.FileLocate.main .. "m_exp.png",(i-1)*80,-1,(exp_rate - exp_view_num)*80,6,8,2,8,2,8,2,8,2);
    --             end
    --         else
    --             if ( exp_view_table[i] ) then
    --                 exp_view_table[i]:removeFromParentAndCleanup(true);
    --                 exp_view_table[i] = nil;
    --             end
    --         end
    --     else
    --         if ( exp_view_table[i] ) then
    --             exp_view_table[i]:removeFromParentAndCleanup(true);
    --             exp_view_table[i] = nil;
    --         end
    --     end
    -- end
   
end
