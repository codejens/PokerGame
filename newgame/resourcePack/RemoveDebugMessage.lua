require 'lfs'

local scriptpath = arg[1]
if scriptpath then
	print(scriptpath,'…æ≥˝∂ÓÕ‚ print debug–≈œ¢')
end

local multi_print = false
local debug_section = false

function removeDebug(filename)
	local mainfile = io.open(filename,'r')
	local c = mainfile:read('*all')
	c = string.gsub(c,'[\r]','\n')
	
	mainfile:close()
	
	local f = io.open(filename, 'w+')
	f:write(c)
	f:close()
	
	local mainfile = io.open(filename,'r')
	local removed = false
	local sourcetable = {}
	
	for line in mainfile:lines() do
		if multi_print then
			sourcetable[#sourcetable+1] = '--' .. line .. '\n'
			removed = true
			local ebk = string.find(line, ')')
			if ebk then
				multi_print = false
			end
		else
			local debug_section_begin = string.find(line,'--@debug_begin')
			if debug_section_begin then
				debug_section = true
			end

			if debug_section then
				debug_section_end = string.find(line,'--@debug_end')
				if debug_section_end then
					debug_section = false
				end
				sourcetable[#sourcetable+1] = '--' .. line .. '\n'
				removed = true
			else

				n,code = string.match(line,'(%s*)(%Z+)')
				if code then
					local release_time = string.find(code,'local release_time')
					if release_time then
						sourcetable[#sourcetable+1] = 'local release_time=' .. os.time() .. '\n'
						removed = true
					else
						local check_list = {
							'^print%(',
							'^xprint%(',
							'^printc%(',
							'^print %(',
							'^_print_jens%(',
							'^_print_zengsi%(',
							'^_print_xhd%(',
							'^_print_chj%(',
							'^Utils:print_table%('
						}
						local check_index = 1
						while(check_list[check_index]) do
							p = string.find(code,check_list[check_index])
							if p == nil then
								check_index = check_index + 1
							else
								check_index = 99
							end
						end
						-- p = string.find(code, '^print%(')
						-- if p == nil then
						-- 	p = string.find(code, '^printc%(')
						-- end
						-- if p == nil then
						-- 	p = string.find(code, '^print %(')
						-- end
						-- if p == nil then
						-- 	p = string.find(code, '^_print_jens%(')
						-- end
						-- if p == nil then
						-- 	p = string.find(code, '^_print_zengsi%(')
						-- end
						-- if p == nil then
						-- 	p = string.find(code, '^_print_xhd%(')
						-- end
						-- if p == nil then
						-- 	p = string.find(code, '^_print_chj%(')
						-- end
						if p then
							local ebk = string.find(code, ')')
							if ebk == nil then
								multi_print = true
							end
							sourcetable[#sourcetable+1] = '--' .. line .. '\n'
							removed = true
						else
							sourcetable[#sourcetable+1] = line .. '\n'
							removed = true
						end
					end
				else
					sourcetable[#sourcetable+1] = line .. '\n'
					removed = true
				end
			end
		end
	end

	print('removeDebug', filename, removed)
	local f = io.open(filename, 'w+')
	f:write(table.concat(sourcetable))
	f:close()
end

sep = '/'
function TravelPath (path)
	for file in lfs.dir(path) do
		if file ~= "." and file ~= ".." then
			local f = path..sep..file
			local attr = lfs.attributes (f)
			assert (type(attr) == "table")
			if attr.mode == "directory" then
				TravelPath (f)
			else
				n,e = string.match(file,"(%Z+).lua")
				if n then
					removeDebug(f)
				end
			end
		end
	end
end

--removeDebug('../script/utils/callback.lua')

TravelPath(scriptpath)
function GetPlatform()
end
local db = io.open(scriptpath .. '\\' .. 'zxDebugger.lua','r')
str = db:read('*all')
db:close()
loadstring(str)()
if zxDebugger_check_debug then
	zxDebugger_check_debug()
end
local sfn = 'version.txt'
local svnfile = io.open(scriptpath .. '\\' .. sfn,'a+')
svnfile:write('m:release')
svnfile:close()