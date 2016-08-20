-- added by aXing on 2013-5-14
-- 由于 os.clock() 函数在不同的机器上面不正常，所以改掉
function ZXClock(  )
	return CCDirector:getClock()
end
local oldclock = os.clock
os.clock = ZXClock
os.oldclock = oldclock

--为math库增加函数normailize和dot
local math_sqrt = math.sqrt
math.normalize = function(x,y)
	local l = 1.0 / math_sqrt(x * x + y * y)
	return x * l, y * l
end

math.dot = function (x0,y0,x1,y1)
	return x0 * x1 + y0 * y1
end

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
			-- print(e)
			json2table_err = e
			return nil, e
		else
			return jtable, nil
		end
end
--json相关 End