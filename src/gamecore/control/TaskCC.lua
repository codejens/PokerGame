
--TaskCC.lua
--create by liubo on 2015-05-05
--任务系统

TaskCC = {}

-- NPC的对话框有四种形态，0接任务1完成任务2是普通对话3是选择任务
TaskCC.ACCEPT_TASK = 0
TaskCC.FINISH_TASK = 1
TaskCC.TALK_TASK = 2
TaskCC.CHOOSE_TASK = 3

function TaskCC:init(  )
	TaskCC:regist_protocol()
end

function TaskCC:finish( ... )
	-- body
end

function TaskCC:show_window(  )
    local win = GUIManager:show_window("task")
    win:setPosition(500,300)
    return win
end
--s 0,11 NPC对话返回
local function do_talk_to_npc( success,handle,param )
    print("success,handle,param",success,handle,param)
	if success then
		if param then
			local _param = TaskCC:analyze_param( param )
			local win = TaskCC:show_window(  )
            if win then
                win:update(_param)
            end
		end
	end
end

--解析对话参数
--@return ret_table包含字段

--state   --对话类型
--content  内容
--quest_name --任务名称（普通任务才有）
--task_id    -任务id（普通任务才有）
--sever_fun_str -任务描述（回复任务第二个参数）
--choose_btn --多个按钮

--下面两个特殊参数 貌似只有加入仙盟的时候用到
--dialog_expend 
--text_btn_data 按钮数据
function TaskCC:analyze_param( sever_str )
	
	--返回结果
	local ret_table = {}
	-- 普通任务对话框
    local tab_data = Utils:Split(sever_str, "|"); 
    if ( #tab_data > 1 ) then
        ret_table.quest_name = table[1]
        ret_table.state = tonumber(table[2])
        ret_table.content = table[3]
        ret_table.sever_fun_str = table[4]
        ret_table.task_id = tonumber(Utils:Split(table[4], ",")[2])
        print( ret_table.quest_name,ret_table.state, ret_table.content,ret_table.sever_fun_str,ret_table.task_id)
        return ret_table
    end

    -- 副本或日常任务对话框
    local content = ""
    -- 首先分割"\"
    local str_table  = Utils:Split(sever_str, "\\")
    content = str_table[1]

    local text_btn_table = Utils:Split(content, "&")
    if ( #text_btn_table > 2 ) then
        content = text_btn_table[1]
        ret_table.dialog_expend = text_btn_table[2]
        ret_table.text_btn_data = text_btn_table[3]
    end

    ret_table.content = content
    ret_table.state = TaskCC.CHOOSE_TASK

    if ( str_table[2] == nil or string.len(str_table[2]) == 0 ) then
        return ret_table
    end

    --多任务 
    local tab_choose = {}
    for i=2,#str_table do
        local str = str_table[i];
        -- 如果为空就直接返回
        if ( str ~= "" ) then
            local temp_table = Utils:Split(str, "/");
            if ( #temp_table >=3 ) then
                temp_table[1] = temp_table[1].."/"..temp_table[2];
                temp_table[2] = temp_table[3];
                table.remove(temp_table,3);
            end
            if ( temp_table[2] ) then
                -- 去掉@字符
                temp_table[2] = string.gsub(temp_table[2],"@","");
            end
            tab_choose[#tab_choose+1] = temp_table
        end
    end
    ret_table.tab_choose = tab_choose

    return ret_table
end

function TaskCC:regist_protocol(  )
	PacketDispatcher:register_protocol_callback( PROTOCOL_ID_S_0_11,do_talk_to_npc )
end

--c 0,5与NPC对话
function TaskCC:req_talk_to_npc( npc_handle, content )
	PacketDispatcher:send_protocol( PROTOCOL_ID_C_0_5,npc_handle,content)
end