require 'lfs'

require 'luaiconv'
require 'strbuf'
require 'list'

local iconv = require("luaiconv")
--utf-8×ªµ½GBK
local cd = iconv.new("GBK", "utf-8")

oldstring = tostring

function __tostring(s)
	return cd:iconv(oldstring(s))
end

function utf8code(s)
	return iconv.utf8code(s)
end
tostring = __tostring
--

local req = "(.-)([^\\]-([^%.]+))$"
local sep = '\\'

local multi_print = false
local debug_section = false
local findMatch = 0
local findFile = 0
local stringmap = {}
local system_id = 1
local stringtable = {}
local global_string_id = 1
local lanfilename = 'LangGameString'
local log_only = true

function byte4id(n)
	local n = tonumber(n)
	if n < 10 then
		return string.format('000%d',n)
	elseif n < 100 then
		return string.format('00%d',n)
	elseif n < 1000 then
		return string.format('0%d',n)
	end
	return tostring(n)
end
-- 是否有中文
function hasChinese(str)
	local t = utf8code(str)
	for k,v in ipairs(t) do
		if v > 255 then
			return true
		end
	end
	--print(str,t)
	return false
end
-- 忽略/过滤
function ignore(line)
	if not string.find(line,'[\"|\']') then
		return true
	end

	--¶àÐÐprint
	if multi_print then
		local ebk = string.find(line, ')')
		if ebk then
			multi_print = false
		end
		return true
	else
		--debug section
		local debug_section_begin = string.find(line,'--@debug_begin')
		if debug_section_begin then
			debug_section = true
		end

		if debug_section then
			debug_section_end = string.find(line,'--@debug_end')
			if debug_section_end then
				debug_section = false
			end
			return true
		else
		--print section
			n,code = string.match(line,'(%s*)(%Z+)')
			if code then
				p = string.find(code, '^print%(')
				if p then
					local ebk = string.find(code, ')')
					if ebk == nil then
						multi_print = true
					end
					return true
				else
					return false
				end
			else
				return false
			end
		end
	end
	return false
end


function findString(str)
	if ignore(str) then
		return {}
	end

	local lastc = nil
	local token = {}
	local open_token = false
	for i = 1, #str do
		local c = str:sub(i,i)
		--ÕÒ³ö×Ö·û´®
		if (c == '\"' and lastc ~= '\\') or c == '\'' then
			token[#token+1] = i

		--ºöÂÔ×¢ÊÍ
		elseif #token % 2 == 0 and c == '-' and lastc == '-' then
			--print(str)
			break
		end
		lastc = c
	end
	local itable = {}
	local t = {}
	for i=1, #token, 2 do
		local x = token[i]
		local y = token[i+1]
		local match = string.sub(str,x,y)
		--print(match)
		if hasChinese(match) then
			t[#t+1] = { str = match,  [1] = x, [2] = y }
		end

	end
	return t
end

function splitreplace(line, replace_table)
	local start = 1
	local fin = nil
	local t = {}
	local indexs = {}
	local allstring = {}

	assert(string.find(line,'\n')==nil)
	--line = string.gsub(line,'[\r]','')

	for k,v in ipairs(replace_table) do
		--print(v[1],v[2])
		if start ~= v[1] then
			t[#t+1] = string.sub(line,start,v[1] - 1)
		end
		start = v[2] + 1
		local c = string.sub(line,start,start)
		t[#t+1] = string.format(lanfilename .. '[%d]', v.sid)
		allstring[#allstring+1]= string.format(' -- [%d]=%s',v.sid,v.str)
	end

	if string.len(line) > start then
		t[#t+1] = string.sub(line,start,string.len(line))
	end

	print(line)
	line = table.concat(t)
	line = string.gsub(line,'[\r]','') .. table.concat(allstring)

	print('>>', line)

	return line
end

function parse_line(file)
	--ÎÄ¼þ¸ñÊ½×ª´æ
	filename = file
	local mainfile = io.open(filename,'r')
	local c = mainfile:read('*all')
	c = string.gsub(c,'[\r]','\n')
	mainfile:close()
	local f = io.open(filename, 'w+')
	f:write(c)
	f:close()
	--

	local f = io.open(file,'rb')
	local i = 1;

	multi_print = false
	debug_section = false

	local fileWithString = {}
	--print(file)
	local sub_id = 1
	local stringGroup = {}

	local newfile = false
	local newfilecontent = {}
	for line in f:lines() do
		local result = findString(line)
		if #result > 0 then
			newfile = true
			--print(i,line)
			--fileWithString[#fileWithString+1] = string.format('  [%d]%s',i,line)
			findFile = findFile + 1
			for i, v in pairs(result) do
				findMatch = findMatch + 1
				--ÕÒÒ»ÏÂÃ»ÓÐ¶«¶«
				local replace_id = nil
				if stringtable[v.str] == nil then
					stringtable[v.str] = global_string_id
					stringGroup[#stringGroup+1] = { str = v.str, sid =  global_string_id }
					replace_id = global_string_id
					global_string_id = global_string_id + 1
				else
					replace_id = stringtable[v.str]
					--print(__tostring(v.str),stringtable[v.str])
				end
				if log_only then
					print(file, v.str,replace_id)
				end

				v.sid = replace_id
				--local line2 = string.gsub(line,'%(' .. v.str ..')','hi')
				--print(line2)
				sub_id = sub_id + 1
			end
			line = splitreplace(line,result) .. '\r'

		end
		i = i + 1
		if string.find(line,'\r') == nil then
			line = line .. '\r'
		end
		newfilecontent[#newfilecontent+1] = line
	end
	if #stringGroup > 0 then
		stringmap[#stringmap+1] = { group = stringGroup, filename = file }
		system_id = system_id + 1
	end

	f:close()
	if not log_only and newfile then
		f = io.open(file,'wb')
		f:write(table.concat(newfilecontent))
		f:close()

		local mainfile = io.open(file,'r')
		local c = mainfile:read('*all')
		c = string.gsub(c,'[\r]','\n')
		mainfile:close()
		local f = io.open(filename, 'w+')
		f:write(c)
		f:close()
	end
	--print(newfilecontent)
end
--±éÀúÎÄ¼þ¼Ð
function TravelSource (path)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local fullpath = path..sep..file
			local attr = lfs.attributes (fullpath)
			assert (type(attr) == "table")
			if attr.mode == "directory" and file ~= '.svn' and file ~= 'language' then
				TravelSource(fullpath)
			else
				print("file = ",file)
				local p,f,e = string.match(file,req)
				if e == 'lua' then
					parse_line(fullpath)
					print("fullpath = ",fullpath)
				end
			end
		end
	end
end
TravelSource('../script')

local lantable = { lanfilename .. ' = {\n'}

if(#stringmap) then
	--print(stringmap)

	for i, group in ipairs(stringmap) do
		local string_id = 1
		local details = group.group
		local filename = group.filename
		for i, v in ipairs(details) do
			lantable[#lantable+1] = string.format('[%s]=%s, 		--%s\n',v.sid,v.str,filename)
		end
	end
	lantable[#lantable+1] = '}\n'
	local content = table.concat(lantable)
	if not log_only then
		f = io.open( lanfilename .. '.lua','wb+')
		f:write(content)
		f:close()
	end

	local count = 0
	for k,v in pairs(stringtable) do
		count = count + 1
	end
	print(count)
end


print('ÎÄ¼þÊý:',findFile,'Æ¥ÅäÊý',findMatch)
--print()
