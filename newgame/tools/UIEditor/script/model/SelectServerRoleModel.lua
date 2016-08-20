-- SelectServerRoleModel.lua
-- created by lyl on 2013-11-8
-- 选择服务器的多个角色

SelectServerRoleModel = {}

local _role_data_list = {}      -- 角色列表

-- local _camp_icon_list = {       -- 阵营icon
-- 	"ui2/role/xianyi_icon_s.png",
-- 	"ui2/role/xingchen_icon_s.png",
-- 	"ui2/role/xiaoyao_icon_s.png",
-- }

-- local _job_icon_list = {
-- 	"ui2/role/tianlei_tip.png",
-- 	"ui2/role/shushan_tip.png",
-- 	"ui2/role/yuanyue_tips.png",
-- 	"ui2/role/yuanhua_tips.png"
-- }

local _cur_page_index = 1

local _cur_role_select_index = 1

function SelectServerRoleModel:fini( ... ) 
    _role_data_list = nil
    _role_data_list = {}
    _cur_page_index = 1
    _cur_role_select_index = 1
end

function SelectServerRoleModel:set_cur_page_index(index)
    _cur_page_index = index
end

function SelectServerRoleModel:get_cur_page_index()
    return _cur_page_index
end

function SelectServerRoleModel:set_cur_role_select_index(index)
    _cur_role_select_index = index
end

function SelectServerRoleModel:get_cur_role_select_index()
    return _cur_role_select_index
end

function SelectServerRoleModel:set_role_data_list( role_data_list )
	_role_data_list = role_data_list
    SelectServerRoleModel:sort_info(_role_data_list)
end

function SelectServerRoleModel:sort_info(info)
    if type(info) == "table" then
        local function sort_fun(a,b)
            if a ~= nil and b ~= nil then
                if a.fightValue > b.fightValue then
                    return true
                elseif a.level > b.level then
                    return true
                else
                    return false
                end
            end
        end
        table.sort( info, sort_fun )
    end
end

-- 获取角色列表
function SelectServerRoleModel:get_role_data_list(  )
	return _role_data_list
end

-- 根据序号获取某个角色信息
function SelectServerRoleModel:get_role_data_by_index( index )
	local role_data = _role_data_list[ index ]

    -- role_data = { job = 3, sex = 1, name = "名字名字名字", level = 6, camp = 2, job = 2 }

	return role_data
end

-- -- 根据职业和性别获取头像
-- function SelectServerRoleModel:get_head_by_job_sex( job, sex )
--     local head_image_path = ""
--     local job_temp = 1
--     if job ~= nil and job ~= "" and job ~= "null" then
--         job_temp = tonumber(job)
--     end
--     local sex_temp = 1
--     if sex ~= nil and sex ~= "" and sex ~= "null" then
--         sex_temp = tonumber(sex) + 1
--     end 
--     -- print( job_temp, sex_temp )
--     local _head_image = { { "ui2/head/head10.png", "ui2/head/head11.png" },
--                           { "ui2/head/head20.png", "ui2/head/head21.png" },
--                           { "ui2/head/head30.png", "ui2/head/head31.png" },
--                           { "ui2/head/head40.png", "ui2/head/head41.png" },
--                         }

--     if _head_image[job_temp] and _head_image[job_temp][sex_temp] then 
--         head_image_path = _head_image[job_temp][sex_temp]
--     else
--         head_image_path = _head_image[1][1]
--     end
--     return _head_image[job_temp][sex_temp] or _head_image[1][1]
-- end

-- -- 根据序号 获取阵营 图标
-- function SelectServerRoleModel:get_camp_icon( index )
-- 	local icon_path = _camp_icon_list[ index ] or ""
-- 	return icon_path
-- end

-- -- 获取职业icon
-- function SelectServerRoleModel:get_job_icon_path( index )
-- 	local icon_path = _job_icon_list[ index ] or ""
-- 	return icon_path
-- end

-- 进入游戏
function SelectServerRoleModel:make_sure_role( index )
	local role_data = _role_data_list[ index ]
	if role_data then 
        RoleModel:enter_game_scene( role_data.id, 0 );
		MUtils:lockScreen(false,2048,'登录游戏',3)
	end
end