
local _string_find = string.find
local _string_sub  = string.sub
local _string_len  = string.len
local _string_gsub = string.gsub
local function getNextHash(text)
	local i = string.find(text,'##')
	if not i then
		return nil
	end
	return '##' .. _string_sub(text,1,i+1)
end
local textAn = ZXTexAn:shareTexAn()

local function getColor(text)
	local color = _string_sub(text,1,6)
	if tonumber('0x'..color) then
		local ch = _string_sub(text,7,7)
		local sum =  textAn:getUTF8Len(ch)
		return '#c' .. _string_sub(text,1,6+sum)
	end
end

local KEYWORDS =
{
	['#'] = getNextHash,
	['c'] = getColor
}

local function toWord(text,msgList)
	local text_index = 1
	local len = _string_len(text)
	local count = 0
	while(true) do
		if text_index > len then
			return
		end
		local ch = string.sub(text,text_index,text_index);
		local sum =  textAn:getUTF8Len(ch)
		local next_i = text_index + sum - 1
		msgList[#msgList+1] = _string_sub(text,text_index,next_i)
		text_index = next_i + 1
		count = count + 1
		if count > 255 then
			error(string.format('parsing overflow %s ',msg))
		end
	end
end

function splitDialogText(msg)
	text = msg
	local msgList = {}
	local start_i = 1
	local count = 0
	local token_i = nil
	local start_i = 1
	while(true) do
		token_i = _string_find(text,'#')
		if not token_i then
			toWord(text,msgList)
			break
		else
			toWord(_string_sub(text,start_i,token_i-1),msgList)
			local next_i = token_i+1
			local keyword = _string_sub(text,next_i,next_i)
			local handler = KEYWORDS[keyword]
			if handler then
				text = _string_sub(text,next_i+1,_string_len(text))
				local ret = handler(text)
				if not ret  then
					error(string.format('parsing [%s] >%s< >%s< >%d<',keyword,msg,text,token_i))
				end
				msgList[#msgList+1] = ret
				text = _string_sub(text,_string_len(ret)-1)
			else
				msgList[#msgList+1] = '#' .. keyword
				text = _string_sub(text,next_i+1)
			end
		end
		count = count + 1
		if count > 255 then
			error(string.format('parsing overflow %s ',msg))
		end
	end
	for i,v in ipairs(msgList) do
		print('--',i,v)
	end
	return msgList
end

function movieParseDialogText(text, emote, player)
	if not emote then return text end
	--替换表情
	player = EntityManager:get_player_avatar()
	for pat,i in pairs(emote) do
		local rep = Hyperlink.getFace(i)
		text = _string_gsub(text,'%['..pat..'%]',rep)
	end
	if player then
		--替换玩家名字
		text = _string_gsub(text, "@player", player.name);
	end
	return text
end