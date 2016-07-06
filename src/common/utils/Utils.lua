-- Utils.lua
-- created by aXing on 2012-12-4
-- 公共函数

Utils = simple_class()


MINI_DATE_TIME_BASE = 1262275200;

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
	   return math.ceil(x);
	end

	x = math.floor(x);
	return x;
end



--格式化时间，-by fjh
-- second 秒数,  simple,  brief 这个参数代表着返回简略的格式化时间，即只返回2个单位的时间，如:x天x小时、x小时x分钟、x分钟x秒
-- 
function Utils:formatTime( second, brief )
	
	local m = Utils:getIntPart(second/60);
	if m > 0 then
		local s = second%60;
		local h = Utils:getIntPart(m/60);
		if h>0 then
			local _m = m%60;
			local d = Utils:getIntPart(h/24);
			if d>0 then
				local _h = h%24;
                
                if brief then
                    -- 简略的格式化时间
                    return string.format("%d天%d小时",d,_h);   
                end
                return string.format("%d天%d小时%d分%d秒",d,_h,_m,s);
			end

            if brief then
                -- 简略的格式化时间
                return string.format("%d小时%d分",h,_m);
            end
			return string.format("%d小时%d分%d秒",h,_m,s);
		end
        if brief then
		  return string.format("%d分",m); 
        end
        return string.format("%d分%d秒",m,s); 
	end
	return string.format("%d秒",second);

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

--功能：根据秒计算的时间转换成时分格式时间
--参数：1、second       秒计算的时间
--返回：无
--作者：陈亮
--时间：2014.06.27
function Utils:secondTransformHourMinute(second)
    --把秒数量时间转化为单位时间
    local t_timeDate = os.date("*t", second)
    --获取时和分
    local t_hour = t_timeDate.hour or ""
    local t_minute = t_timeDate.min or ""
    --定义时文本
    local t_hourText = nil
    local t_hourBitCount = string.len(t_hour)
    --如果时为个位数，在前面加一个0
    if t_hourBitCount < 2 then
        t_hourText = "0" .. t_hour
    else
        t_hourText = "" .. t_hour
    end
    --定义分文本
    local t_minuteText = nil
    local t_minBitCount = string.len(t_minute)
    --如果分为个位数，在前面加一个0
    if t_minBitCount < 2 then
        t_minuteText = "0" .. t_minute
    else
        t_minuteText = "" .. t_minute
    end

    --组合成时分时间格式
    local t_timeText = t_hourText .. ":" .. t_minuteText
    return t_timeText
end

-----HJH
-----2012-12-27
-----用于指定字符分拆
function Utils:Split(str, split_char)  
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
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
    local time;
    if custom_time > 0x80000000 then
        time = custom_time-2147483648;
    else
        time = custom_time;
    end
    local str = os.date(format_str,(time+MINI_DATE_TIME_BASE));
    return str;
end


-- 实现table的深拷贝
function Utils:table_deepcopy(ori_table)
    
    local function th_table_dup( ori_tab )
        if (type(ori_tab) ~= "table") then
            return nil;
        end
        local new_tab = {};
        for i,v in pairs(ori_tab) do
            local vtyp = type(v);
            if (vtyp == "table") then
                new_tab[i] = th_table_dup(v);
            elseif (vtyp == "thread") then
                -- TODO: dup or just point to?
                new_tab[i] = v;
            elseif (vtyp == "userdata") then
                -- TODO: dup or just point to?
                new_tab[i] = v;
            else
                new_tab[i] = v;
            end
        end
        return new_tab;
    end
    
    return th_table_dup( ori_table );

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
            break;
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
    print("Utils:format_time_to_data info", info)
    local time_info = os.date("*t", info + MINI_DATE_TIME_BASE)
    return string.format( "%d%s%d%s%d", time_info.year, splitTarge, time_info.month, splitTarge, time_info.day )
end

function Utils:format_time_to_time(info, splitTarge)
    print("Utils:format_time_to_time info", info)
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


function Utils:urlencode(str)
   if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w ])",
         function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
   end
   return str    
end

--截取字符串
function Utils:get_str_by_length( str,length)
    --计算长度 去掉颜色

    
    local sub_str_tab = {};
    local sub_color_tab = {};
    local strlen = 0
    while (true) do
        local pos = string.find(str, "#");
        if (not pos) then
            strlen = strlen + string.len(str)

            sub_str_tab[#sub_str_tab + 1] = str;
            if strlen > length then
            local need_count = strlen - length

                str = Utils:truncateUTF8String(str, string.len(str) - need_count)  

                sub_str_tab[#sub_str_tab] = str;
            end
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        strlen = strlen + string.len(sub_str)
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        sub_color_tab[#sub_str_tab] =  string.sub(str, pos, pos +7);
        str = string.sub(str, pos + 8, #str);

        if strlen > length then
            local need_count = strlen - length
            sub_str = Utils:truncateUTF8String(str, string.len(sub_str) - need_count)  
            sub_str_tab[#sub_str_tab] = sub_str;
        end
    end

    local return_str = ""
    local color = ""
    for i=1,#sub_str_tab do
        color = ""
        if sub_color_tab[i] then
            color = sub_color_tab[i]
        end
        return_str = string.format("%s%s%s",return_str,sub_str_tab[i],color)
    end
    return return_str,strlen
end
--中文截取
function Utils:truncateUTF8String(str, pos)  
  local dropping = string.byte(str, pos+1)  
  if not dropping then return str end  
  if dropping >= 128 and dropping < 192 then  
    return self:truncateUTF8String(str, pos-1)  
  end  
  return string.sub(str, 1, pos)  
end

--把表格变为枚举（KEY-VALUE 转换）
--[[
EnumTable = 
{ 
    "ET1", 
    "ET2", 
}
EnumTable = CreatEnumTable(EnumTable )
print(EnumTable.ET1) 
--]]
function Utils:CreatEnumTable(tbl, index) 
    assert( type(tbl) == "table") 
    local enumtbl = {} 
    local enumindex = index or 0 
    for i, v in ipairs(tbl) do 
        enumtbl[v] = enumindex + i 
    end 
    return enumtbl 
end

function Utils:has_value(str)
    if str and str ~= "" then
        return true
    else
        return false
    end 
end