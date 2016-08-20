super_class.SharedTools()
--------------------------------格式化跑马灯与主屏公告内容
function SharedTools:format_screen_and_center_notic_info(info)
    -- ----print("format_screen_and_center_notic_info",info)
    local temp_begin = 1
    local temp_end = string.len(info)
    local temp_info = ""
    local cur_info = info
    local target_info = ""
    local hit_target = false
    ---------
    self.test = 3
    for temp_begin = 1, temp_end do
        local k,l = string.find(cur_info,"##")
        -- print("------------k,l", cur_info, k, l)
        if k == nil and l == nil then
            if temp_info ~= "" then
                local split_t = SharedTools:Split(info, "##")  -- @modify by chj on 20160216 解析出错:字符串尾不带"##"的部分不再拼接 解决:暂时这样处理,如有不适，再做修改
                if split_t[3] then  -- "##" 一开一关, 所以一定会是第3个, 如有异常,修改
                    return temp_info .. split_t[3]
                else
                    return temp_info 
                end
            else
                return info
            end
        end
        ------print("k,l",k,l)
        ---------
        if k ~= l then
            if hit_target == true then
                hit_target = false
            else
                hit_target = true
            end
        end
        ------print("hit_target",hit_target)
        ---------
        if k <= 0 then
            k = k + 1
        end
        ---------
        if hit_target == true then
            temp_info = temp_info .. string.sub( cur_info, temp_begin, k - 1 )
            cur_info = string.sub( cur_info, l, -1)
            temp_begin = l
        else
            local split_target = string.sub( cur_info, temp_begin, k - 1 )
            local split_info = Utils:Split( split_target, "," )
            -- xprint("88888888888888888888")
            -- debug.debug()
            local m,n = string.find( split_info[2], "#info" )
            temp_info = temp_info .. string.sub( split_info[2], 1, m - 1 )
            cur_info = string.sub( cur_info, l, -1 )
            temp_begin = l
        end
        -- ----print("cur_info",cur_info)
        -- ----print("temp_begin", temp_begin)
        -- ----print("temp_info", temp_info)
    end
    ---------
    -- ----print("format finish temp_info",temp_info)
    return temp_info
end

-----用于指定字符分拆
function SharedTools:Split(str, split_char)
    local sub_str_tab = {}
    print("self.test=",self.test)
    while (true) do
        local pos1,pos2 = string.find(str, split_char)
        if (not pos1) then
            sub_str_tab[#sub_str_tab + 1] = str
            break
        end
        local sub_str = string.sub(str, 1, pos1 - 1)
        sub_str_tab[#sub_str_tab + 1] = sub_str
        if pos2 then
            str = string.sub(str,pos2+1,#str)
        else
            str = string.sub(str, pos1 + 1, #str)
        end
    end
    return sub_str_tab
end  