-- Utils.lua
-- created by aXing on 2012-12-4
-- 公共函数

super_class.Utils()

MINI_DATE_TIME_BASE = 1262275200

Utils.num_list = {
     [0]  = { format1 = "零" , format2 = "ling" , format3 = "zero"                                    }
    ,[1]  = { format1 = "一" , format2 = "yi"   , format3 = "one"                                    }
    ,[2]  = { format1 = "二" , format2 = "er"   , format3 = "two"                                    }
    ,[3]  = { format1 = "三" , format2 = "san"  , format3 = "three"                                    }
    ,[4]  = { format1 = "四" , format2 = "si"   , format3 = "four"                                    }
    ,[5]  = { format1 = "五" , format2 = "wu"   , format3 = "five"                                    }
    ,[6]  = { format1 = "六" , format2 = "liu"  , format3 = "six"                                    }
    ,[7]  = { format1 = "七" , format2 = "qi"   , format3 = "seven"                                    }
    ,[8]  = { format1 = "八" , format2 = "ba"   , format3 = "eight"                                    }
    ,[9]  = { format1 = "九" , format2 = "jiu"  , format3 = "nine"                                    }
    ,[10] = { format1 = "十" , format2 = "shi"  , format3 = "ten"                                   }
    ,[100] = { format1 = "百" , format2 = "bai"  , format3 = "hundred"                                   }
    ,[1000] = { format1 = "千" , format2 = "千"  , format3 = "thousand"                                   }
    ,[10000] = { format1 = "万" , format2 = "万"  , format3 = "myriad"                                   }
}

function Utils:get_mini_bate_time_base()
    return MINI_DATE_TIME_BASE
end
-- 取一个32位整数的低16位 
function Utils:low_word(input)
	return ZXLuaUtils:lowByte(input)
end

-- 取一个32位整数的高16位
function Utils:high_word(input)
	return ZXLuaUtils:highByte(input)
end

-- 取一个16位整数的低8位
function Utils:low_byte(input)
	return input
end

-- 取一个16位整数的高8位
function Utils:high_byte(input)
	return input
end

-- 取一个整数的 第 n 个8位  lyl
function Utils:get_byte_by_position(input, n)
	local output = input
	for i = 1, (n - 1) do
        output = output / (2 ^ 8) - output / (2 ^ 8) % 1
	end
	output = output % (2 ^ 8)
	return output
end

-- 获取某个数的二进制表示的 第n位  lyl
function Utils:get_bit_by_position(input, n)
    if type(input) == "table" then
        return input
    end
    local output = input
    output = output / (2 ^ (n -1)) -- 先去掉该位置后面的数
    output = math.floor(output)      -- 取整
    output = output % 2                -- 取最后一位
    return output
end

function Utils:toBinary(num)
    -- local function toBinary(num)
    local v = num % 2
    local list = {}
    while (num >= 1) do
        v = num%2
        num = math.floor(num/2)
        table.insert(list,v)
    end
    return list
        -- end
end

--取整数 -by fjh
function Utils:getIntPart(x)
	if x <= 0 then
	   return math.ceil(x)
	end

	x = math.floor(x)
	return x
end



--格式化时间，-by fjh
-- second 秒数,  simple,  brief 这个参数代表着返回简略的格式化时间，即只返回2个单位的时间，如:x天x小时、x小时x分钟、x分钟x秒
-- 
function Utils:formatTime(second, brief)
	local m = Utils:getIntPart(second/60)
	if m > 0 then
		local s = second%60
		local h = Utils:getIntPart(m/60)
		if h>0 then
			local _m = m%60
			local d = Utils:getIntPart(h/24)
			if d>0 then
				local _h = h%24

                if brief == 1 then
                    return Utils:second_to_24time_str(second)
                end
                
                if brief then
                    -- 简略的格式化时间
                    return string.format(LangGameString[2299],d,_h)    -- [2299]="%d天%d小时"
                end
                return string.format(LangGameString[2300],d,_h,_m,s) -- [2300]="%d天%d小时%d分%d秒"
			end

            if brief == 1 then
                return Utils:second_to_24time_str(second)
            end

            if brief then
                -- 简略的格式化时间
                return string.format(LangGameString[2301],h,_m) -- [2301]="%d小时%d分"
            end
			return string.format(LangGameString[2302],h,_m,s) -- [2302]="%d小时%d分%d秒"
		end
        if brief == 1 then
            return Utils:second_to_24time_str(second)
        end
        if brief then
		  return string.format(LangGameString[2303],m)  -- [2303]="%d分"
        end
        return string.format(LangGameString[2304],m,s)  -- [2304]="%d分%d秒"
	end
    if brief == 1 then
        return Utils:second_to_24time_str(second)
    end
	return string.format(LangGameString[2305],second) -- [2305]="%d秒"

end

-----HJH
-----2012-12-27
-----用于指定字符分拆
function Utils:Split(str, split_char)
    local sub_str_tab = {}
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

function Utils:RemoveString(str,remove)  
    local lcSubStrTab = {}  
    while true do  
        local lcPos = string.find(str,remove)  
        if not lcPos then  
            lcSubStrTab[#lcSubStrTab+1] =  str      
            break  
        end  
        local lcSubStr  = string.sub(str,1,lcPos-1)  
        lcSubStrTab[#lcSubStrTab+1] = lcSubStr  
        str = string.sub(str,lcPos+1,#str)  
    end  
    local lcMergeStr =""  
    local lci = 1  
    while true do  
        if lcSubStrTab[lci] then  
            lcMergeStr = lcMergeStr .. lcSubStrTab[lci]   
            lci = lci + 1  
        else   
            break  
        end  
    end  
    return lcMergeStr  
end 

--匹配星期几是否在时间字串的配置中
--weekday 星期几 0-1~6 表示周日-周1~周6
--时间配置的字串，例如"1#2#3#4#5#6#19:30-20:00"，#0表示周日，#7表示全周
function Utils:match_weekday(weekday,cfg)
    local splite_arr = Utils:Split(cfg,"#")
    for key,value in ipairs(splite_arr) do
        if splite_arr[key] == "7" then
            return true
        elseif splite_arr[key] == tostring(weekday) then
            return true
        end
    end
    return false
end
-- 以前的，lyl
function Utils:Split_old(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
       local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
       if not nFindLastIndex then  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
        break  
       end  
       nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
       nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
       nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end 


-- 十进制数字转成十六进制,并且转成字符串(颜色的数值转换用，所以会补0),注意只返回两位
function Utils:hex_to_dec(num)
	local ret = ""
	if type(num) ~= "number" then
        return "00"
    end
    local hex_num_t = {"1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
    local count = 0   -- 位数计数，补0用
    local single_digit = 0
    while num ~= 0 do
    	single_digit = hex_num_t[ num % 16 ] or 0
        ret = tostring(single_digit)..ret
        num = num / 16 - num / 16 % 1
        count = count + 1
    end
    -- 不足两位补0
    for i = 1, (2 - count) do
        ret = "0"..ret
    end
    -- 超过两位，就只取后面的两位
    if string.len (ret) > 2 then
        ret = string.sub(ret,-2, -1)
    end

    return ret
end

function Utils:c3_dec_to_hex(num)
	local ret = ""
	if type(num) ~= "number" then
        return "000000"
    end
    local hex_num_t = {"1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
    local count = 0   -- 位数计数，补0用
    local single_digit = 0
    while num ~= 0 do
    	single_digit = hex_num_t[ num % 16 ] or 0
        ret = tostring(single_digit)..ret
        num = num / 16 - num / 16 % 1
        count = count + 1
    end

    -- 不足两位补0
    for i = 1, (6 - count) do
        ret = "0"..ret
    end

    -- 超6位，就只取后面的6位
    if string.len (ret) > 6 then
        ret = string.sub(ret,string.len (ret)-6+1, string.len (ret))
    end

    return ret
end

-- 克隆一个table. 复制传入的table返回(注：目前只支持复制包含简单数据的table，支持table嵌套).
function Utils:table_clone(table_obj)
	local table_clone = {}
	for key, element in pairs(table_obj) do
        if type(element) == "table" then
            table_clone[ key ] = Utils:table_clone(element)
        else
        	table_clone[ key ] = element
        end
	end
	return table_clone
end

-- 打印一个table所有 key 和数据 （提供测试用, 注意不是按顺序打印的） 第二个参数传nil
function Utils:print_table_key_value(table_obj, count)
--@debug_begin

	-- 打印分割符号
    local  print_str = ""
    local count_temp = count or 0
    for i = 1, count_temp do
        print_str = print_str .. "."
    end
--    print(print_str, "====================================")



	-- for key, value in pairs(table_obj) do
        -- if type(value) == "table" then
            -- Utils:print_table_key_value(value, count_temp + 6)
        -- else
--        	print(tostring(key), tostring(value))

        -- end
	-- end

--@debug_end
end

--带缩进打印 table ,所以类型的变量都能打印
--tabName, indent 不用设值
function Utils:print_table(tab, tabName, indent)
--@debug_begin

    indent = indent or 0
    if indent == 0 then
        print "===========================" 
        if type(tab) ~= "table" then
            print ("not table ~!!!" ,type(tab))
            print (tab)
            print "==========================="
            return
        end
    end
    --indent = indent +1
    local str = ""
    for i = 1, indent do
        str = str .. "  "
    end

    for k,v in pairs(tab) do
        if type(v) == "table" then
            print (string.format("%s%s%s",str, tabName and tabName .. "." or "", tostring(k)))
            self:print_table(v, tostring(k), indent +1)
        else
            print (string.format("%s%s%s = %s", str, tabName and tabName .. "." or "", tostring(k), tostring(v)))
        end
    end
    if indent == 0 then print "===========================" end

--@debug_end
end

-- 四舍五入取整
function Utils:math_round(num)
    if type(num) == "number" then
        local num_temp = num % 1
        if num_temp >= 0.5 then
            return math.ceil(num)
        else
            return math.floor(num)
        end
    end
    return num
end

-- 把 秒为单位的时间，变成24小时制式的字符串 lyl
function Utils:second_to_24time_str(second_time)
    if second_time == nil or second_time < 0 then
        return "0:0:0"
    end
    local time_temp = second_time % (24 * 60 * 60)
    local hours = math.floor(time_temp / (60 * 60))      -- 小时

    time_temp = time_temp % (60 * 60)
    local minites = math.floor(time_temp / 60)             -- 分

    time_temp = time_temp % 60
    local second = math.floor(time_temp)                   -- 秒
    if hours < 10 then
        hours = string.format("0%d", hours)
    end
    if minites < 10 then
        minites = string.format("0%d", minites)
    end
    if second < 10 then
        second = string.format("0%d", second)
    end
    return hours..":"..minites..":"..second
end

function Utils:second_to_time_str(second_time,do_not_hour, bool)
    if second_time == nil or second_time < 0 then
        return "00:00:00"
    end
    -- local time_temp = second_time % (24 * 60 * 60)
    local hours = math.floor(second_time / (60 * 60))      -- 小时
    if hours < 10 then
        hours = "0" .. hours
    end
    second_time = second_time % (60 * 60)
    local minites = math.floor(second_time / 60)             -- 分
    if minites < 10 then
        minites = "0" .. minites
    end
    second_time = second_time % 60
    local second = math.floor(second_time)                   -- 秒
    if second < 10 then
        second = "0" .. second
    end

    if bool then
        return hours .. ":" .. minites
    end

    if do_not_hour then
        return minites .. ":" .. second
    elseif do_not_second then
        return hours..":"..minites
    else
        return hours..":"..minites..":"..second
    end
end


-- 把 秒为单位的时间，变成自定义制式的字符串
-- %Y年%m月%d日 %H时%M分 格式符号
function Utils:get_custom_format_time(format_str ,custom_time)
    require "utils/Utils"
    local time
    if custom_time > 0x80000000 then
        time = custom_time-2147483648
    else
        time = custom_time
    end
    local str = os.date(format_str,(time+MINI_DATE_TIME_BASE))
    return str
end

function Utils:get_hour_minute_string(time)
    local t_timeDate = os.date("*t", second)
    return t_timeDate
end


-- 实现table的深拷贝
function Utils:table_deepcopy(ori_table)
    local function th_table_dup(ori_tab)
        if (type(ori_tab) ~= "table") then
            return nil
        end
        local new_tab = {}
        for i,v in pairs(ori_tab) do
            local vtyp = type(v)
            if (vtyp == "table") then
                new_tab[i] = th_table_dup(v)
            elseif (vtyp == "thread") then
                -- TODO: dup or just point to?
                new_tab[i] = v
            elseif (vtyp == "userdata") then
                -- TODO: dup or just point to?
                new_tab[i] = v
            else
                new_tab[i] = v
            end
        end
        return new_tab
    end
    
    return th_table_dup(ori_table)
end

function Utils:table_deepcopy_class(ori_table)
    local function th_table_dup(ori_tab)
        if type(ori_tab) ~= "table" then
            return nil
        end
        local new_tab = {}
        for i,v in pairs(ori_tab) do
            local vtyp = type(v)
            if i ~= "class" and vtyp == "table" then
                new_tab[i] = th_table_dup(v)
            elseif vtyp == "thread" then
                new_tab[i] = v
            elseif vtyp == "userdata" then
                new_tab[i] = v
            else
                new_tab[i] = v
            end
        end
        return new_tab
    end
    return th_table_dup(ori_table)
end

-- 8bit 负数补码形式，转成 其表示的数字 lyl
function Utils:complement_to_num(complement)
    -- 还原负数补码： 减1  取反（255 - ）  在确定符号位（ 0 - ）
    local num = 0 - (255 - (complement - 1))
    return num
end

function Utils:get_params(s, token)
    local t = {}
    while true do
        local i = string.find(s, token)
        if i == nil then
            t[#t+1] =string.sub(s,0,string.len(s))
            break
        end
        t[#t+1] = string.sub(s,0,i-1)
        s =string.sub(s,i+1,string.len(s))
    end
    return t
end

-- --HJH
-- --把当前时间格式成秒数
-- function Utils:format_sys_time_by_second()
--     local curtime = os.date("%S",os.time())
-- end

----HJH
---按指定二进制长度，取得第N个二进制长度的数值 传入数据为64位数据
function Utils:get_long_long_value_index_stept_info(info, index, stept)
    return ZXLuaUtils:getLongLongIndexInfo(info, index, stept)
end

---HJH
---将一个从2010-1-1到现在的秒数格式化
function Utils:format_time_to_data(info, splitTarge)
    -- --print("Utils:format_time_to_data info", info)
    local time_info = os.date("*t", info + MINI_DATE_TIME_BASE)
    return string.format("%d%s%d%s%d", time_info.year, splitTarge, time_info.month, splitTarge, time_info.day)
end

function Utils:format_time_to_time(info, splitTarge)
    -- --print("Utils:format_time_to_time info", info)
    local time_info = os.date("*t", info + MINI_DATE_TIME_BASE)
    return string.format("%d%s%d", time_info.hour, splitTarge, time_info.min)
end

function Utils:format_time_to_info(info)
    local time_info = os.date("*t", info + MINI_DATE_TIME_BASE)
    return time_info
end

function Utils:format_time(info)
    local time_temp = info % (24 * 60 * 60)
    local hours = math.floor(time_temp / (60 * 60))      -- 小时

    time_temp = time_temp % (60 * 60)
    local minites = math.floor(time_temp / 60)             -- 分

    time_temp = time_temp % 60
    local second = math.floor(time_temp)                   -- 秒

    return { hour = hours, min = minites, sec = second } 
end

function parseargs (s)
  local arg = {}
  string.gsub(s, "(%w+)=([\"'])(.-)%2", function (w, _, a)
    arg[w] = a
  end)
  return arg
end
    
function Utils:collect(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end

-- 将json格式的字符串转化成一个table
function Utils:json2table(message)
    
    require 'json/json' 
    local jtable = {}
    local s,e = pcall(function()
            jtable = json.decode(message)
    end)
    if not s then 
        --print(e)
        json2table_err = e
        return nil
    else
        return jtable
    end
end

-- 格式化时间， 某些界面的特殊需求，只需要  月 日 时
function Utils:second_to_month_day_hours(second)
    local date_t = os.date("*t", second)
    local month = date_t.month or ""
    local day = date_t.day or ""
    local hour = date_t.hour or ""
    local min = date_t.min or ""
    if string.len(min) < 2 then 
        min = "0"..min
    end
    local time_str = month .. "月" .. day .. "日 " .. hour .. ":" .. min
    return time_str
end

-- 格式化时间， 某些界面的特殊需求，只需要  月 日
function Utils:second_to_month_day(second)
    local date_t = os.date("*t", second)
    local month = date_t.month or ""
    local day = date_t.day or ""
    return month,day
end

-- 格式化时间,产生年月日
function Utils:second_to_year_month_day(second)
    local date_t = os.date("*t", second)
    local year = date_t.year or ""
    local month = date_t.month or ""
    local day = date_t.day or ""
    return year,month,day
end

function Utils:splitEntityName(name)
    local name_table = Utils:Split(name, "\\")  
    --name_table[1] = string.match(name_table[1],'(%D+)')
    return name_table
end

function Utils:parseNPCName(name)
    local match_name = string.match(name,'(%D+)')
    -- 纯数字NPC名字会出问题，比如天元城主雕像NPC，预防一下
    if match_name == nil then
        match_name = name
    end
    return match_name
end

-- 是斩仙和一剑灭天的CommonModel:gen_attr_str方法，由于新建CommonModel类麻烦，所以写在这里 note by guozhinan
-- (另外，一剑灭天和斩仙用的是staticAttriTypeList2，这边用的是staticAttriTypeList，使用须注意)
-- 根据属性信息生成字符串(属性请参考staticAttriTypeList类)
function Utils:gen_attr_str(attr_info)
    local blue_color = COLOR.b
    local white_color = COLOR.w
    local str = ""
    if attr_info and attr_info.type and attr_info.value then
        str = string.format("%s%s:  %s+%d",blue_color,staticAttri4[attr_info.type],
            white_color,math.abs(attr_info.value))
    end
    return str
end

--获取表长度，包括哈希
function Utils:table_getlength(t)
    local c = 0
    if t then
        for _ , v in pairs(t) do
            c = c + 1
        end
    end
    return c
end

--判断是否空表
function Utils:is_empty(t)
    if t ~= nil and type(t) == "table" and Utils:table_getlength(t) > 0 then
        return false
    end
    return true
end

--判断字符串是否只是数字
function Utils:is_only_number(s)
    if s ~= nil and s == "" then
        return false
    else
        local v = string.find(s,"[^%d]")
        return v == nil
    end
end

--获取数字的大写
function Utils:numTocapitals(num,str)
    str = str or ""
    -- _print_jens("获取数字的大写 num=",num)
    local str_error = "转换失败"
    if Utils:is_only_number(num) then
        local n = tonumber(num)
        -- _print_jens("n = ",n)
        if n <= 10 then
            return Utils.num_list[n].format1
        elseif n <= 100 then
            if n == 100 then 
                return Utils.num_list[1].format1 .. Utils.num_list[n].format1
            else
                local n1 = math.floor(n / 10)
                local n2 = n % 10
                -- local str = ""
                if n1 ~= 1 then --"一十八,1就除外,直接十八"
                    str = Utils.num_list[n1].format1
                end
                if n2 == 0 then 
                    str = str .. Utils.num_list[10].format1
                else
                    str = str .. Utils.num_list[10].format1 .. Utils.num_list[n2].format1
                end
                return str
            end
        elseif n <= 1000 then
            if n == 1000 then
                return Utils.num_list[1].format1 .. Utils.num_list[n].format1
            else
                -- local str = ""
                local n1 = math.floor(n / 10)
                str = str .. Utils:numTocapitals(n1,str)
            end
        else
            _print_jens("n = ",n)
            return str_error
        end
    end
            _print_jens("n = ",num)
    return str_error
end

--获取数字的大写全拼


--螺旋扫描坐标点函数，从目标点由内向外螺旋扫描
--[[
    maxRound 扫描层数
    minRound 对第几层以外的点才进行判断
    tx, ty 目标点坐标
    conditionFunc 回调函数，用来设置添加判断，返回真则扫描到的点是所需的点
]]

function Utils:spiral_scan(maxRound, minRound, tx, ty, conditionFunc)
    --local numb = 4
    if maxRound <= minRound then
        return 
    end

    local count = 1
    local min_count = 0
    local x,y = 0,0
    local ox,oy = 0,0

    if maxRound > 1 then
        count = math.pow(maxRound*2-1, 2)
    end

    if minRound > 1 then
        min_count = math.pow(minRound*2-1, 2)
    end

    --print "**************************************************"
    --print ("count >>>>>>>>>>>", count)
    for i = 1, count do
        x = x + ox
        y = y + oy
        --因为地图格子坐标点是按照OpenGL坐标系，所以y用减法，正常坐标系才用加法
        if i > min_count and conditionFunc(tx +x, ty -y) then
            return tx +x, ty -y
        end
        --print (string.format("(%d, %d)", x,y))
        if x == y and x >= 0 and y >= 0 then
            ox = 1
            oy = 0
        elseif x + y == 0 and x > 0 and y < 0 then
            ox = -1
            oy = 0
        elseif x + y == 0 and x < 0 and y > 0 then
            ox = 1
            oy = 0
        end
        --print (ox, oy)
        if x - y == 1 and y >= 0 then
            oy = -1
            ox = 0
        elseif x == y and x < 0 then
            oy = 1
            ox = 0
        elseif x == y and x > 0 then
            y = y + 1
            oy = -1
            --ox = 0
        end
        --print (ox, oy)
    end
    --print "**************************************************"

end

-- table转字符串(只取标准写法，以防止因系统的遍历次序导致ID乱序)
function Utils:t2s(tab)
    local szRet = "{"
    function doT2S(i, v)
        if "number" == type(i) then
            szRet = szRet .. "[" .. i .. "] = "
            if "number" == type(v) then
                szRet = szRet .. v .. ","
            elseif "string" == type(v) then
                szRet = szRet .. '"' .. v .. '"' .. ","
            elseif "table" == type(v) then
                szRet = szRet .. self:t2s(v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        elseif "string" == type(i) then
            szRet = szRet .. '["' .. i .. '"] = '
            if "number" == type(v) then
                szRet = szRet .. v .. ","
            elseif "string" == type(v) then
                szRet = szRet .. '"' .. v .. '"' .. ","
            elseif "table" == type(v) then
                szRet = szRet .. self:t2s(v) .. ","
            else
                szRet = szRet .. "nil,"
            end
        end
    end
    table.foreach(tab, doT2S)
    szRet = szRet .. "}"
    return szRet
end

-- 判断某个源字符串里面是否有目标字符串
function Utils:is_contain_string(sourStr, tarStr)
    local start, ended = string.find(sourStr, tarStr)
    local result = false
    if start and ended then
        result = true
    end
    return result
end

--转换yyyyMMddHHmmss
function Utils:getTimeStamp(t)
    -- return os.date("%Y%m%d%H%m%s",t/1000)
    return os.date("%Y%m%d%H%M%S", t) 
end

--功能：时间是否在范围内   swh
--参数：time--时间, start--开始时间, end--结束时间
function Utils:isTimeInRange(time, startTime, endTime)
    if time[1]>startTime[1] or time[1]==startTime[1] and time[2]>=startTime[2] then --大于开始时或等于开始时大于开始分
        if not endTime or time[1]<endTime[1] or time[1]==endTime[1] and time[2]<=endTime[2] then --小于结束时或等于结束时小于结束分
            return true
        end
    end
    return false
end

-- 格式化时间 <天数 时 分 秒> （time_type不传参数显示的格式）
-- time_type "dhms"(天时分秒) "dhm"(天时分) "hms"(时分秒) "hm"(时分) "ms"(分秒) 
function Utils:second_to_dhms(second, time_type)
    local day    = math.floor(second/86400)
    local hour   = math.fmod(math.floor(second/3600), 24)
    local min    = math.fmod(math.floor(second/60), 60)
    local sec    = math.fmod(second, 60)

    local time_str = ""
    if not time_type or time_type == "dhms" then
        time_str = string.format("%d天%d时%d分%d秒", day, hour, min, sec)
    elseif time_type == "dhm" then
        time_str = string.format("%d天%d时%d分", day, hour, min)
    elseif time_type == "hms" then
        time_str = string.format("%d时%d分%d秒", day*24+hour, min, sec)
    elseif time_type == "hm" then
        time_str = string.format("%d时%d分", day*24+hour, min)
    elseif time_type == "ms" then
        time_str = string.format("%d分%d秒", day*24*60+hour*60+min, sec)
    elseif time_type == "m" then
        time_str = string.format("%d分钟", day*24*60+hour*60+min)
    end

    return time_str
end


--从date时间格式转换成时间戳
function Utils:change_date_to_time( time_str )
        -- time_str = "2016-7-20 00:00:00"
        local first_t = Utils:Split(time_str, " ")
        local second = Utils:Split(first_t[1], "-")
        local year = second[1]
        local month = second[2]
        local day = second[3]
        local thrid = Utils:Split(first_t[2], ":")
        local function  check_func( str )
            local f = string.sub(str,1,1)
            if f ==0 or f =="0" then
                return string.sub(str,2,2)
            else
                return str
            end
        end
        local hour = check_func(thrid[1])
        local min = check_func(thrid[2])
        local sec = check_func(thrid[3])
        -- print("year month day hour,min,sec ",year,month,day,hour,min,sec)
         local tab = {year=year, month=month, day=day, hour=hour,min=min,sec=sec}
         local time  = os.time(tab)
    return time
end


--转变服务器时间变成客户端显示时间
function Utils:change_date_to_showstr( time_str )
        -- time_str = "2016-7-20 00:00:00"
        -- print("time_str",time_str)
        local first_t = Utils:Split(time_str, " ")
        local second = Utils:Split(first_t[1], "-")
        local year = second[1]
        local month = second[2]
        local day = second[3]

        local function  check_func( str )
            local f = string.sub(str,1,1)
            if f ==0 or f =="0" then
                return string.sub(str,2,2)
            else
                return str
            end
        end
        -- print(year,month,day)
    return check_func(month).."月"..check_func(day).."日" 
end

-- 改变面向
function Utils:face_to( beginx, beginy, endx, endy)
    local tmp_dir = nil
    local dx = math.floor(endx - beginx)
    local dy = math.floor(endy - beginy)
    local temp_stept = 45
    local begin_stept = temp_stept / 2
    if dx ~= 0 or dy ~= 0 then
        local new_angle = math.atan2(dy,dx)
        local angle = math.deg(new_angle)
        if angle < 0 then
            ----print("temp_angle",angle)
            angle = 360 + angle
        end
        --edit by tjh 动作没有0，4方向 修改下方向计算
        if ( angle >= 0 and angle < begin_stept ) or ( angle >= 360 - temp_stept / 2 and angle <= 360 ) then
            tmp_dir = 2
        elseif angle >= begin_stept and angle < begin_stept + temp_stept+temp_stept/2 then
            tmp_dir = 3
        elseif angle >= begin_stept + temp_stept and angle < begin_stept + temp_stept * 2 then
         tmp_dir = 4
        elseif angle >= begin_stept + temp_stept+temp_stept/2 and angle < begin_stept + temp_stept * 3 then
            tmp_dir = 5
        elseif angle >= begin_stept + temp_stept * 3 and angle < begin_stept + temp_stept * 4 then
            tmp_dir = 6
        elseif angle >= begin_stept + temp_stept * 4 and angle < begin_stept + temp_stept * 5+temp_stept/2 then
            tmp_dir = 7
        elseif angle >= begin_stept + temp_stept * 5 and angle < begin_stept + temp_stept * 6 then
            tmp_dir = 0
        elseif angle >= begin_stept + temp_stept * 6-temp_stept/2 and angle < begin_stept + temp_stept * 7 then
            tmp_dir = 1
       end
    end
    return tmp_dir
end