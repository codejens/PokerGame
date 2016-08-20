-- HLDZhuPuHuDongAction.lua
-- created by hcl on 2013-9-25
-- 主仆互动

super_class.HLDZhuPuHuDongAction(Window)

local btns_pos_info = {
    {112,320},
    {34,277},  --51,39
    {14,204},  --29,39
    {14,126},  --57,39
    {34,52},  --21,41 
    {112,14},  --18,43 

    {200,320},  --100,23
    {276,277},  --37,39
    {294,204},  --43,41
    {294,126},  --33,43
    {276,52},  --29,47
    {200,14},  --51,43
 }

local btns_names_info = {
    {LangGameString[1268],LangGameString[1269]}, -- [1268]="烛光晚餐" -- [1269]="拍拍马屁"
    {LangGameString[1270],LangGameString[1271]}, -- [1270]="看皮影戏" -- [1271]="给TA请安"
    {LangGameString[1272],LangGameString[1273]}, -- [1272]="神话故事" -- [1273]="给TA揉腿"
    {LangGameString[1274],LangGameString[1275]}, -- [1274]="游山玩水" -- [1275]="给TA唱歌"
    {LangGameString[1276],LangGameString[1277]}, -- [1276]="泡泡温泉" -- [1277]="给TA跳舞"
    {LangGameString[1278],LangGameString[1279]}, -- [1278]="爱的抱抱" -- [1279]="亲TA一口"
    {LangGameString[1280],LangGameString[1281]}, -- [1280]="打扫卫生" -- [1281]="抛TA白眼"
    {LangGameString[1282],LangGameString[1283]}, -- [1282]="广场罚跑" -- [1283]="书法表演"
    {LangGameString[1284],LangGameString[1285]}, -- [1284]="瘦身减肥" -- [1285]="人缘非凡"
    {LangGameString[1286],LangGameString[1287]}, -- [1286]="跳舞奇才" -- [1287]="威胁恐吓"
    {LangGameString[1288],LangGameString[1289]}, -- [1288]="野蛮女友" -- [1289]="客观评价"
    {LangGameString[1290],LangGameString[1291]}, -- [1290]="搬砖达人" -- [1291]="人身自由"
}

local msg_ids = {
    {4101,4301},
    {4102,4302},
    {4103,4303},
    {4104,4304},
    {4105,4305},
    {4106,4306},
    {4107,4307},
    {4108,4308},
    {4109,4309},
    {4110,4310},
    {4111,4311},
    {4112,4312},
}

function HLDZhuPuHuDongAction:show( hld_user_info )
    local win = UIManager:show_window("hld_zhupuhudongaction");
    if ( win ) then
        win:update_view( hld_user_info,hudong_cd );
    end
end

-- 初始化
function HLDZhuPuHuDongAction:__init( )


    MUtils:create_zximg(self.view,UIPIC_GRID_nine_grid_bg3,10,10,374,388,500,500);
   	
    ZCCSprite:create(self.view,"ui/hld/bg1.jpg",197 ,203)

    self.btn_name_tab = {};
    for i=1,12 do
        -- 互动
        local function btn_fun( eventType,args,msgid )
            local my_info = HuanLeDouModel:get_my_hld_info()
            local msg_index = 0;
            if ( my_info.state == HuanLeDouModel.STATE_DIZHU ) then
                msg_index = 1;
            else
                msg_index = 2;
            end
            HuanLeDouCC:req_hudong( self.target_id,msg_ids[i][msg_index] );
            if self.cd_time == nil then
                -- 显示cd
                self.cd_time = TimerLabel:create_label(self.view, 232, 210, 15, 20*60, "#cd5c241", nil,false);
            end
        end
        if ( i < 7 ) then
            self.btn_name_tab[i] = ZTextButton:create(self.view,"", UIResourcePath.FileLocate.huanledou.."action_bg1.png", btn_fun, btns_pos_info[i][1], btns_pos_info[i][2], -1, -1)
            --local btn,lab = MUtils:create_btn_and_lab(self.view,UIResourcePath.FileLocate.huanledou.."hld_btn.png",nil,btn_fun,btns_pos_info[i][1],btns_pos_info[i][2],100,30,LangGameString[1268],16,2); -- [1268]="烛光晚餐"
        else
            self.btn_name_tab[i] = ZTextButton:create(self.view,"", UIResourcePath.FileLocate.huanledou.."action_bg2.png", btn_fun, btns_pos_info[i][1], btns_pos_info[i][2], -1, -1)
            --local btn,lab = MUtils:create_common_btn( self.view,LangGameString[1280],btn_fun,btns_pos_info[i][1],btns_pos_info[i][2] ,2); -- [1280]="打扫卫生"
            --self.btn_name_tab[i] = lab;
        end

    end

    self.name = MUtils:create_zxfont(self.view,"",130,85,1,16)
    -- self.level = MUtils:create_zxfont(self.view,"",200,85,1,16)
end
    
function HLDZhuPuHuDongAction:active( show )
    if ( show ) then 
        -- 每次打开互动动作时同时打开互动记录
        UIManager:show_window("hld_hudongjilu");
    else
        -- 每次关闭互动动作时同时关闭互动记录
        UIManager:hide_window("hld_hudongjilu");
    end
end

function HLDZhuPuHuDongAction:update_view( hld_user_info )
    if ( self.bg2 ) then
        self.bg2:removeFromParentAndCleanup(true);
        self.bg2 = nil;
    end
    local info = HuanLeDouModel:get_my_hld_info()
    local bg2_path = nil;
    local str = ""
    if ( info.state == HuanLeDouModel.STATE_DIZHU ) then
        for i=1,12 do
            self.btn_name_tab[i]:setText(btns_names_info[i][1])
        end
        str = "#c66ff66仆人:#cffffff"
        -- bg2_path = nil
        -- self.cloud_text:setText("折磨?")
        -- self.cloud_text2:setText("安抚?")
        -- self.bg2 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.huanledou .. bg2_path,100,110);
        --self.cloud_text.view:setTexture("ui/hld/hld_action1.png");
        --.cloud_text2.view:setTexture("ui/hld/hld_action2.png");
    elseif ( info.state == HuanLeDouModel.STATE_KUGONG ) then
        for i=1,12 do
            self.btn_name_tab[i]:setText(btns_names_info[i][2])
        end
        str = "#c66ff66主人:#cffffff"
        -- bg2_path = nil
        -- self.cloud_text:setText("讨好?")
        -- self.cloud_text2:setText("嫌弃?")
        -- self.bg2 = MUtils:create_sprite(self.view,UIResourcePath.FileLocate.huanledou .. bg2_path,80,110);
        --self.cloud_text.view:setTexture("ui/hld/hld_action3.png");
        --self.cloud_text2.view:setTexture("ui/hld/hld_action4.png");
    end
    

    self.name:setText(str..hld_user_info.name) -- [1292]="名字:#c66ff66"
    -- self.level:setText(LangGameString[940]..hld_user_info.level) -- [940]="等级:"
    self.target_id = hld_user_info.id;
    print("info.interactiveCD = ",hld_user_info.interactiveCD)
    ZLabel:create(self.view,"#c66ff66互动cd:",175,210,15,1);
    if self.cd_time == nil then
        if hld_user_info.interactiveCD ~= 0 then
            local function end_call()
                self.cd_time:destroy()
                self.cd_time = nil;
            end 
            self.cd_time = TimerLabel:create_label(self.view, 232, 210, 15, hld_user_info.interactiveCD, "#cd5c241", nil,false);
        end
    else
        if hld_user_info.interactiveCD ~= 0 then 
            self.cd_time:setText( hld_user_info.interactiveCD )
        else
            self.cd_time:destroy();
            self.cd_time = nil;
        end
    end
end

function HLDZhuPuHuDongAction:do_btn_method( index )

end
