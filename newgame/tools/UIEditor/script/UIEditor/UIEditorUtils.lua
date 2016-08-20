function numberbit(num,n)
	num = tostring(num)
	local l = string.len(num)
	for i =1 , n - l do
		num = '0' .. num
	end
	return num
end


function table_serialize(o,nl,tgap)
	local t = {}
	local tab = ''
	nl = nl or '\n'
	tgap = tgap or '    '
	function serialize( o , tab )

		if type(o) == 'number'  then
			t[#t+1] = tostring(o)
		elseif tonumber(o) then
			if string.find(o,'+') then
				t[#t+1] = string.format('%q',o)
			else
				t[#t+1] = tostring(o)
			end
		elseif type(o) == 'string' then
			t[#t+1] = string.format('%q',o)
		elseif type(o) == 'table' then
			t[#t+1] = '{' .. nl
			for k,v in pairs(o) do
				if type(k) == 'number' then
					t[#t+1] = string.format(tab .. ' [%s]=',k)
				else
					t[#t+1] = string.format(tab .. ' [\'%s\']=',k)
				end
				serialize(v, tab .. tgap)
				t[#t+1] = ',' .. nl
			end
			t[#t+1] = tab .. '}' .. nl
		elseif type(o) == 'boolean' then
			if o then
				t[#t+1] = 'true'
			else
				t[#t+1] = 'false'
			end
		else
			t[#t+1] = 'false'
		end
	end

	serialize(o,tab)

	return table.concat(t)
end



function editorGUI:init(root, w,h)
	local cross = CCDebugLine:node()
	--local w = winSize.width
	--local h = winSize.height
	local hh = h/2
	local hw = w/2
	local i = 0
	
	local vh = hh
	cross:setLine(i,CCPointMake(0,vh),CCPointMake(50000,vh),ccc3(125,0,0))
	while(true) do
		vh = vh - 50
		if vh < 0 then
			break;
		end
		i = i + 1
		cross:setLine(i,CCPointMake(0,vh),CCPointMake(50000,vh),ccc3(75,75,75))
		
	end
	local vh = hh
	while(true) do
		vh = vh + 50
		if vh > h then
			break;
		end
		i = i + 1
		cross:setLine(i,CCPointMake(0,vh),CCPointMake(50000,vh),ccc3(75,75,75))
		
	end

	---------------------------------------------------------------------------
	i = i + 1
	cross:setLine(i,CCPointMake(hw,-50000),CCPointMake(hw,50000),ccc3(125,0,0))

	local vw = hw
	while(true) do
		vw = vw - 50
		if vw < 0 then
			break;
		end
		i = i + 1
		cross:setLine(i,CCPointMake(vw,-50000),CCPointMake(vw,50000),ccc3(75,75,75))
	end

	local vw = hw
	while(true) do
		vw = vw + 50
		if vw > w then
			break;
		end
		i = i + 1
		cross:setLine(i,CCPointMake(vw,-50000),CCPointMake(vw,50000),ccc3(75,75,75))
	end


	self.cross = cross
	self.root = root
	self.winSize = winSize
	editorGUI.cross:setPosition(0,0)

	return cross
end

