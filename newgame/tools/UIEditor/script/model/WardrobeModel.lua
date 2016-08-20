-- WardrobeModel.lua
-- created by liuguowang on 2013-12-25
-- 衣柜系统

WardrobeModel = {}

local _star_num--激活星数
local _huanhua_id   --当前幻化时装id 0 为未幻化
local _fashion_num  --时装数量

local _result  --幻化结果


local _cur_active_window = nil
--------------------------------------------------------------------------------------------------
-- c -> s 139.118
function WardrobeModel:req_huanhua_info() --向服务器申请幻化信息
    WardrobeCC:req_huanhua_info()
end
-- s -> c 139.118
function WardrobeModel:do_huanhua_info(star_num,huanhua_id,fashion_num)
    _star_num = star_num
    _huanhua_id = huanhua_id
    _fashion_num = fashion_num
    print("star_num=",star_num)
    print("huanhua_id=",huanhua_id)
    print("fashion_num=",fashion_num)
end

-- c -> s 139.119
function WardrobeModel:req_append_att() --向服务器申请幻化信息
    WardrobeCC:req_append_att()
end
-- s -> c 139.119
function WardrobeModel:do_append_att()
    -- _star_num = star_num
    -- _huanhua_id = huanhua_id
    -- _fashion_num = fashion_num
end


--------------------------------------------------------------------------------------------------

-- c -> s 139.120
function WardrobeModel:req_huanhua_event() --向服务器申请幻化某件时装
    WardrobeCC:req_huanhua_event()
end
-- s -> c  139.120
function WardrobeModel:do_huanhua_event(result,_huanhua_id)
    _result = result
    _huanhua_id = _huanhua_id
    print("star_num=",star_num)
    print("huanhua_id=",huanhua_id)
    print("fashion_num=",fashion_num)
end

--------------------------------------------------------------------------------------------------获取数据

function WardrobeModel:get_star_num()
    _star_num = 2
	return _star_num
end

function WardrobeModel:get_huanhua_id()
	return _huanhua_id
end

function WardrobeModel:get_fashion_num()
    return _fashion_num
end

function WardrobeModel:get_huanhua_result()
    return _result
end


-- added by aXing on 2013-5-25
function WardrobeModel:fini( ... )
    UIManager:destroy_window( "bag_win" )
end


function WardrobeModel:need_tujian_add( star_num )
    if star_num == 6 then
        return 0,0
    end
    local need_add = star_num * 50
    local need_add_life = star_num * 500
    local cur_str = string.format( LangGameString[2329],need_add,need_add,need_add,need_add_life) -- 属性前   物理防御

    return cur_str
end



function WardrobeModel:need_star_add( i ) -- i 是第几个圈数  由里到外
    
    if i == 1 then
        local need_add =  35
        local need_add_life = 350
    elseif i == 2 then
        local need_add =  25
        local need_add_life =  250
    elseif i == 3 then
        local need_add = 15
        local need_add_life = 150
    end

    local cur_str = string.format( Lang.wardrobe_info.attribute,need_add,need_add,need_add,need_add_life) -- 属性前   物理防御

    return cur_str
end