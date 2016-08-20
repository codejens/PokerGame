-- Utils.lua
-- created by aXing on 2012-12-4
-- 公共函数

super_class.Utils()


MINI_DATE_TIME_BASE = 1262275200

function Utils:get_mini_bate_time_base()
    return MINI_DATE_TIME_BASE
end
-- 取一个32位整数的低16位 
function Utils:low_word( input )
	return ZXLuaUtils:lowByte(input)
end

-- 取一个32位整数的高16位
function Utils:high_word( input )
	return ZXLuaUtils:highByte(input)
end

-- 取一个16位整数的低8位
function Utils:low_byte( input )
	return input
end

-- 取一个16位整数的高8位
function Utils:high_byte( input )
	return input
end

-- 取一个整数的 第 n 个8位  lyl
function Utils:get_byte_by_position( input, n )
	local output = input
	for i = 1, (n - 1) do
        output = output / (2 ^ 8) - output / (2 ^ 8) % 1
	end
	output = output % (2 ^ 8)
	return output
end

-- 获取某个数的二进制表示的 第n位  lyl
function Utils:get_bit_by_position( input, n )
    local output = input
    output = output / ( 2 ^ ( n -1 ) ) -- 先去掉该位置后面的数
    output = math.floor( output )      -- 取整
    output = output % 2                -- 取最后一位
    return output
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
function Utils:formatTime( second, brief )
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
        local pos = string.find(str, split_char)
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str
            break
        end
        local sub_str = string.sub(str, 1, pos - 1)
        sub_str_tab[#sub_str_tab + 1] = sub_str
        str = string.sub(str, pos + 1, #str)
    end
    return sub_str_tab
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
function Utils:hex_to_dec( num )
	local ret = ""
	if type(num) ~= "number" then
        return "00"
    end
    local hex_num_t = {"1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
    local count = 0   -- 位数计数，补0用
    local single_digit = 0
    while num ~= 0 do
    	single_digit = hex_num_t[ num % 16 ] or 0
        ret = tostring( single_digit )..ret
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

function Utils:c3_dec_to_hex( num )
	local ret = ""
	if type(num) ~= "number" then
        return "00"
    end
    local hex_num_t = {"1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"}
    local count = 0   -- 位数计数，补0用
    local single_digit = 0
    while num ~= 0 do
    	single_digit = hex_num_t[ num % 16 ] or 0
        ret = tostring( single_digit )..ret
        num = num / 16 - num / 16 % 1
        count = count + 1
    end
    -- 不足两位补0
    for i = 1, (6 - count) do
        ret = "0"..ret
    end
    -- 超过两位，就只取后面的两位
    if string.len (ret) > 6 then
        ret = string.sub(ret,-2, -1)
    end

    return ret
end

-- 克隆一个table. 复制传入的table返回(注：目前只支持复制包含简单数据的table，支持table嵌套).
function Utils:table_clone( table_obj )
	local table_clone = {}
	for key, element in pairs(table_obj) do
        if type(element) == "table" then
            table_clone[ key ] = Utils:table_clone( element )
        else
        	table_clone[ key ] = element
        end
	end
	return table_clone
end

-- 打印一个table所有 key 和数据 （提供测试用, 注意不是按顺序打印的） 第二个参数传nil
function Utils:print_table_key_value( table_obj, count )
	-- 打印分割符号
    local  print_str = ""
    local count_temp = count or 0
    for i = 1, count_temp do
        print_str = print_str .. "."
    end
    print( print_str, "====================================")


	for key, value in pairs( table_obj ) do
        if type( value ) == "table" then
            Utils:print_table_key_value( value, count_temp + 6 )
        else
        	print( tostring( key ), tostring( value ) )
        end
	end
end

-- 四舍五入取整
function Utils:math_round( num )
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
function Utils:second_to_24time_str( second_time )
    if second_time == nil or second_time < 0 then
        return "0:0:0"
    end
    local time_temp = second_time % ( 24 * 60 * 60 )
    local hours = math.floor( time_temp / ( 60 * 60 ) )      -- 小时

    time_temp = time_temp % ( 60 * 60 )
    local minites = math.floor( time_temp / 60 )             -- 分

    time_temp = time_temp % 60
    local second = math.floor( time_temp )                   -- 秒

    return hours..":"..minites..":"..second
end

-- 把 秒为单位的时间，变成自定义制式的字符串
-- %Y年%m月%d日 %H时%M分 格式符号
function Utils:get_custom_format_time(format_str ,custom_time )
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


-- 实现table的深拷贝
function Utils:table_deepcopy(ori_table)
    
    local function th_table_dup( ori_tab )
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
    
    return th_table_dup( ori_table )

end

-- 8bit 负数补码形式，转成 其表示的数字 lyl
function Utils:complement_to_num( complement )
    -- 还原负数补码： 减1  取反（255 - ）  在确定符号位（ 0 - ）
    local num = 0 - ( 255 - ( complement - 1) )
    return num
end

function Utils:get_params( s, token )
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
    -- print("Utils:format_time_to_data info", info)
    local time_info = os.date("*t", info + MINI_DATE_TIME_BASE)
    return string.format( "%d%s%d%s%d", time_info.year, splitTarge, time_info.month, splitTarge, time_info.day )
end

function Utils:format_time_to_time(info, splitTarge)
    -- print("Utils:format_time_to_time info", info)
    local time_info = os.date("*t", info + MINI_DATE_TIME_BASE)
    return string.format( "%d%s%d", time_info.hour, splitTarge, time_info.min )
end

function Utils:format_time_to_info(info)
    local time_info = os.date("*t", info + MINI_DATE_TIME_BASE)
    return time_info
end

function Utils:format_time(info)
    local time_temp = info % ( 24 * 60 * 60 )
    local hours = math.floor( time_temp / ( 60 * 60 ) )      -- 小时

    time_temp = time_temp % ( 60 * 60 )
    local minites = math.floor( time_temp / 60 )             -- 分

    time_temp = time_temp % 60
    local second = math.floor( time_temp )                   -- 秒

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
        print(e)
        json2table_err = e
        return nil
    else
        return jtable
    end
end

-- 格式化时间， 某些界面的特殊需求，只需要  月 日 时
function Utils:second_to_month_day_hours( second )
    local date_t = os.date("*t", second)
    local month = date_t.month or ""
    local day = date_t.day or ""
    local hour = date_t.hour or ""
    local min = date_t.min or ""
    if string.len( min ) < 2 then 
        min = "0"..min
    end
    local time_str = month .. "月" .. day .. "日" .. hour .. ":" .. min
    return time_str
end

-- 格式化时间， 某些界面的特殊需求，只需要  月 日
function Utils:second_to_month_day( second )
    local date_t = os.date("*t", second)
    local month = date_t.month or ""
    local day = date_t.day or ""
    return month,day
end

-- 格式化时间,产生年月日
function Utils:second_to_year_month_day( second )
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
        str = string.format("%s%s:  %s+%d",blue_color,staticAttriTypeList[attr_info.type],
            white_color,math.abs(attr_info.value) )
    end
    return str
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