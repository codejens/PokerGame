
-- super_class.WardrobeCC();
WardrobeCC = {}

-- 翅膀子系统cmd=40
local wing_cmd = 40;

----------------------------------------------------------------------------------------

-- 139, 118 C->S

function WardrobeCC:req_huanhua_info()  --初始获得幻化信息
	print("WardrobeCC:req_huanhua_info")
	local pack = NetManager:get_socket():alloc(139, 118);
	NetManager:get_socket():SendToSrv(pack);
end


-- 139, 118  S->C
function WardrobeCC:do_huanhua_info(pack)
	print("WardrobeCC:do_huanhua_info")

	local star_num = pack:readChar() --激活星数
	local huanhua_id =  pack:readInt()  --当前幻化时装id 0 为未幻化
	local fashion_num = pack:readChar() --时装数量
	-- pack:readInt()--时装信息 array
	WardrobeModel:do_huanhua_info(star_num,huanhua_id,fashion_num)
end

----------------------------------------------------------------------------------------

-- 139, 119 C->S

function WardrobeCC:req_append_att()  --附加属性
	print("WardrobeCC:req_append_att")
	local pack = NetManager:get_socket():alloc(139, 119);
	NetManager:get_socket():SendToSrv(pack);
end


-- 139, 119  S->C
function WardrobeCC:do_append_att(pack)
	print("WardrobeCC:do_huanhua_info")

	local star_num = pack:readWord() --附加属性个数
	print("star_num=",star_num)
	for i=1,star_num do
		local Type = pack:readInt() -- 属性类型
		local Value = pack:readInt() -- 属性值
		print("Type=",Type)
		print("Value=",Value)
	end
	local circle_num = pack:readChar() --时装槽圈数
	print("circle_num=",circle_num)
	for i=1,circle_num do
		print(i)
	end
	-- pack:readInt()--时装信息 array
	-- WardrobeModel:do_huanhua_info(star_num,huanhua_id,fashion_num)
end


----------------------------------------------------------------------------------------


-- 139, 120 C->S

function WardrobeCC:req_huanhua_event(sz_id)  --按钮点击幻化
	print("WardrobeCC:req_huanhua_event")
	local pack = NetManager:get_socket():alloc (139, 120);
	pack:writeChar(sz_id)
	NetManager:get_socket():SendToSrv(pack);
end


-- 139, 120  S->C
function WardrobeCC:do_huanhua_event(pack)
	print("WardrobeCC:do_huanhua_event")

	local result = pack:readChar() --幻化结果
	local huanhua_id =  pack:readInt()  --当前幻化时装id 0 为未幻化
	-- pack:readInt()--时装信息 array
	WardrobeModel:do_huanhua_event(result,huanhua_id)
end
