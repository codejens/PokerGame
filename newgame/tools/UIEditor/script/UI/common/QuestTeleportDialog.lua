-- QuestTeleportDialog.lua
-- created by hcl on 2013/1/31
-- 点击任务弹出的 传送和立即完成按钮

require "UI/component/Window"
require "utils/MUtils"
super_class.QuestTeleportDialog(Window)



function QuestTeleportDialog:show(quest_id,quest_type)
    -- 创建通用购买面板
    local win = UIManager:show_window("quest_teleport_dialog");
    win.quest_id = quest_id;
    win.quest_type = quest_type;

    local quest_info = QuestConfig:get_quest_by_id(quest_id)

    if ( quest_type == 1 and quest_info.quickFinish  ) then
        win.finish_btn:setIsVisible(true);
        if ( quest_info.loopid ) then
            self.lab_btn_name:setText(LangGameString[829]); -- [829]="轻松解环"
        else
            self.lab_btn_name:setText(LangGameString[830]); -- [830]="立即完成"
        end
    else
        win.finish_btn:setIsVisible(false);
    end

    -- -- 新手指引代码
    -- if ( XSZYManager:get_state() == XSZYConfig.VIP_ZY ) then
    --     -- 155,y = 235 0,36,80,28
    --     XSZYManager:play_jt_and_kuang_animation( 155,271,"" ,1,80,28 , XSZYConfig.QUICK_QUEST_PANEL_TAG)
    -- end

    -- 三秒后消失
    local function dismiss( dt )

        --[[if ( XSZYManager:get_state() == XSZYConfig.VIP_ZY ) then
            XSZYManager:destroy_jt( XSZYConfig.QUICK_QUEST_PANEL_TAG );
        end--]]
        UIManager:hide_window("quest_teleport_dialog");
        win.quest_id = nil;
    end

    if win.questTeleDismiss_cb == nil then
        win.questTeleDismiss_cb = callback:new()
    else
        win.questTeleDismiss_cb:cancel()
    end

    win.questTeleDismiss_cb:start(t_qtb_, dismiss)
end

-- 
function QuestTeleportDialog:__init()
	panel = self.view;

    -- local function btn_ok_fun(eventType,x,y)
    --     if eventType == TOUCH_CLICK then
    --  		UIManager:hide_window("quest_teleport_dialog");
    --  		if ( self.quest_id ) then
    --             -- 先停止人物动作
    --             local player = EntityManager:get_player_avatar()
                
    --             --print("停止所有动作")
    --             local scene_id,scene_name,scene_x,scene_y = self:get_teleport_arg(self.quest_id);
    --             require "control/MiscCC"
    --             if ( scene_id and scene_name and scene_x and scene_y ) then
    --                 -- -- 筋斗云 18601
    --                 local count = ItemModel:get_item_count_by_id( 18601 )
                  
    --                 -- 如果vip等级大于3或者有筋斗云
    --                 if ( VIPModel:is_vip_lv3() or count > 0  ) then
    --                     player:stop_all_action()
    --                     -- 设置传送后的AIManager动作 
    --                     AIManager:set_after_pos_change_command( scene_id ,AIConfig.COMMAND_DO_QUEST,{self.quest_id ,self.quest_type});
    --                     self.quest_id = nil;
    --                     print("AIManager:get_state()",AIManager:get_state());
    --                 else
    --                     print("没有筋斗云或者vip不大于3")
    --                 end
    --                 MiscCC:req_teleport(scene_id,scene_name,scene_x,scene_y)
    --             end
    --  		end
    --     end
    --     return true
    -- end
    -- local btn1 = MUtils:create_btn_and_lab(panel,UIResourcePath.FileLocate.common .. "button2_bg.png",UIResourcePath.FileLocate.common .. "button2_bg.png",btn_ok_fun,0,36,80,28,"传送");

    local function btn_cancel_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
        	UIManager:hide_window("quest_teleport_dialog");
            if ( self.quest_id ) then
                if ( self.lab_btn_name:getText() == LangGameString[830] ) then -- [830]="立即完成"
                    local money_type = MallModel:get_only_use_yb() and 3 or 2
                    -- local price = 2
                    -- local param = {self.quest_id, money_type}
                    -- local finish_func = function( param )
                    --     TaskCC:req_rapid_finish_task(param[1], param[2])
                    --     self.quest_id = nil;
                    --     self.finish_quest_btn:setIsVisible(false);
                    -- end
                    TaskCC:req_rapid_finish_task(self.quest_id, money_type)
                    self.quest_id = nil;
                else
                    -- 如果是跑环任务直接解环
                     local money_type = MallModel:get_only_use_yb(  ) and 3 or 2
                     local price = 5
                    local param = {money_type}
                    local func = function( param )
                        PaoHuanCC:req_jiehuan(param[1])
                    end
                    MallModel:handle_auto_buy( price, func, param )
                end
            end
        end
        return true
    end
    self.finish_btn,self.lab_btn_name =  MUtils:create_btn_and_lab(panel,UIResourcePath.FileLocate.common .. "button2_bg.png",UIResourcePath.FileLocate.common .. "button2_bg.png",btn_cancel_fun,0,0,80,28,LangGameString[830]); -- [830]="立即完成"
end

function QuestTeleportDialog:get_teleport_arg(quest_id)
    require "model/TaskModel"
    local quest_info = TaskModel:get_info_by_task_id( quest_id );
    local scene_id,scene_name,scene_x,scene_y = nil,nil,nil,nil;
    local quest_type = self.quest_type;
    local tab_target = quest_info.target;
    -- 如果target为空
    if ( quest_type== 2 or #tab_target == 0 ) then
        -- 斩妖除魔任务 特殊处理
        if ( quest_info.starid == 1 ) then
            return;
        end

        -- 要访问的npc
        local npc = nil;
        if ( quest_type == 1 ) then
            npc = quest_info.comp.npc;
            scene_name = quest_info.comp.scene;
            scene_id = SceneConfig:get_id_by_name( scene_name );
        else
            npc = quest_info.prom.npc;
            scene_name = quest_info.prom.scene;
            scene_id = SceneConfig:get_id_by_name( scene_name );
        end
        scene_x,scene_y = SceneConfig:get_npc_pos(scene_id,npc);
    else
        -- 取出目标table中的第一项
        local target_struct = tab_target[1];
    
        -- 判断任务是否完成
        -- 当前进度值
        local curr_process_value = TaskModel:get_process_value(quest_id );
        if ( curr_process_value == nil ) then
            curr_process_value = 0;
        end
        print("curr_process_value,target_struct.count",curr_process_value,target_struct.count);
        if ( curr_process_value >= target_struct.count ) then
            -- 任务完成
            local npc_name = AIManager:get_commit_quest_npc(quest_info)
            scene_name = quest_info.comp.scene;
            scene_id  = SceneConfig:get_id_by_name( scene_name );
            scene_x,scene_y = SceneConfig:get_npc_pos(scene_id,npc_name);
            return scene_id,scene_name,scene_x,scene_y;
        end

        -- 任务没完成，执行任务
        -- tab_target.type 0 杀怪类、1 收集类、2 消耗类、3 对话类、4 送物类
        if ( target_struct.type == 0 )  then

            -- 如果有data 就解析data
            if ( target_struct.data ) then
                return QuestTeleportDialog:parse_str( target_struct.data );
            end
    
            -- 判断是打怪还是采集
            local monster_info = MonsterConfig:get_monster_by_id( target_struct.id);
            -- 采集
            if ( monster_info.entityType == 12 ) then
                local gatherTime = monster_info.gatherTime;
                scene_id = target_struct.location.sceneid;
                scene_name = SceneConfig:get_scene_name_by_id(scene_id);
                scene_x,scene_y = SceneConfig:get_monster_pos( scene_id , target_struct.id );
            -- 打怪
            elseif ( monster_info.entityType == 1 ) then
                
                if ( target_struct.data ~= nil ) then
                    scene_id = target_struct.location.sceneid;
                    scene_name = SceneConfig:get_scene_name_by_id(scene_id);
                    scene_x,scene_y = SceneConfig:get_npc_pos( target_struct.location.entityName );
            
                else

                    scene_id = target_struct.location.sceneid
                    scene_name = SceneConfig:get_scene_name_by_id(scene_id);
                    scene_x,scene_y = SceneConfig:get_monster_pos( scene_id , target_struct.id );
                end             
            end
        -- 0 杀怪类、1 收集类、2 消耗类、3 对话类、4 送物类5角色的等级达标
        -- 6角色所在帮派等级 7身上其中一件装备强化等级8身上其中一件装备打孔等级
        --9身上其中一件装备镶嵌指定数量宝石10身上其中一件装备精锻等级
        --11角色杀戮值12角色战魂值13角色帮派贡献分14角色阵营贡献
        --40 打开界面或访问npc
        elseif ( target_struct.type == 5 ) then

        elseif ( target_struct.type == 7 ) then

        elseif ( target_struct.type == 40 ) then
            return QuestTeleportDialog:parse_str( target_struct.data );
        elseif ( target_struct.type == 127 ) then
            return QuestTeleportDialog:parse_str( target_struct.data );
        end
    end
    print("scene_id,scene_name,scene_x,scene_y",scene_id,scene_name,scene_x,scene_y)
    return scene_id,scene_name,scene_x,scene_y;
end


-- 根据字符串执行相应的操作 show_window(window_type):打开窗口 ask_npc(npc_name):访问npc
function QuestTeleportDialog:parse_str( str )
    print("str = ",str);
    --require "utils/Utils"
    local str_table = Utils:Split( str, "/" ); 
    str_table = Utils:Split( str_table[2], "," );  
    if( str_table[1] == "@show_window" ) then
        return nil;
    elseif ( str_table[1] == "@ask_npc" ) then
        local scene_name = str_table[2];
        local sceneid = SceneConfig:get_id_by_name( scene_name );
        local scene_x ,scene_y = SceneConfig:get_npc_pos( sceneid,str_table[3] );
        return sceneid,scene_name,scene_x,scene_y;
    end
end
