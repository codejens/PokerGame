--json相关 Begin
local json2table_err = ''

function json2table_lasterror()
	local s = json2table_err
	json2table_err = ''
	return s
end

function json2table(message)
		
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
--json相关 End