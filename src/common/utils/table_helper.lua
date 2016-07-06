
local _s_find = string.find
local _s_upper = string.upper
local _s_split = string.split
local _s_sub = string.sub
local _t_concat = table.concat
--local _sys_sm = NiSystem.StringMatch
function find_all(s, re)
	local t = {}
	local i = 0;
	while true do
		i = _s_find(s,re,i+1)
		if i == nil then break end
		t[#t + 1] = i
	end
	return t
end

function find_last_command(s)
	local t = find_all(s,'[()=+-*/,%s]')
	local last = t[#t]
	if last == #s then
		return nil
	end
	return last
end


function string:split(sSeparator, nMax, bRegexp)
	assert(sSeparator ~= '')
	assert(nMax == nil or nMax >= 1)

	local aRecord = {}

	if self:len() > 0 then
		local bPlain = not bRegexp
		nMax = nMax or -1

		local nField = 1
		local nStart = 1
		local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
		while nFirst and nMax ~= 0 do
			aRecord[nField] = self:sub(nStart, nFirst-1)
			nField = nField+1
			nStart = nLast+1
			nFirst,nLast = self:find(sSeparator, nStart, bPlain)
			nMax = nMax-1
		end
		aRecord[nField] = self:sub(nStart)
	end

	return aRecord
end

function FindMember(tb,name,bExact)
	local re = {};

	local upper_name = _s_upper(name)
	local max_score = 0.0
	local result = name
	for k,v in pairs(tb) do

		if bExact then
			if k == name then
				return k
			end
		else
			if #k >= #name then
				local upper_k = _s_upper(k)
				local r = _s_find(upper_k,'^' .. upper_name);
				if r then
					return k;
				elseif #name / #k > 0.5 then
					r = _s_find(upper_k, upper_name);
					if r then

						return k;
					end
				end
			end
		end
	end
	return name
end

function _GetTable(tb,depth)
	local op = ''
	local count = (#tb) + depth;
	local ParentTable = _G
	--print(tb)
	for i=1, count do
		ParentTable = ParentTable[tb[i]]
	end

	return ParentTable;
end


function FindTableMember(name)

	if name == '' then
		return ''
	end
	---print(name)
	local tb = _s_split(name,'[.:]', nil,true)

	local lastname = tb[#tb]

	local fullname = ''

	if #tb == 1 then
		if type(tb) == 'table' then
			return FindMember(_G,name)
		else
			return name
		end
	end

	local ctb = _GetTable(tb,-1)

	if _s_find(lastname,'[%p]') then
		return name
	end
    
	if type(ctb) == 'table' then
	    strict_ignore_get = true
		if ctb.__type == 'object' then
			local meta = getmetatable(ctb)
			fullname =  FindMember(meta,lastname)
		else
			fullname =  FindMember(ctb,lastname)
		end
		strict_ignore_get = false
	elseif type(ctb) == 'userdata' then
		fullname = lastname
	else
		fullname = lastname
	end

	if fullname ~= '' then
		local i,j = _s_find(name,lastname .. '$')
		return _s_sub(name,0,i-1) .. fullname
	end
	return name
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
