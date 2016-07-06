--SlotDrugMode.lua
--处理slot的拖动事件

SlotDrugMode = {}

--所有监听拖动的slot
local _all_listener_solt = {}

SlotDrugMode.SKILL = "skill" --人物技能拖动
SlotDrugMode.EQUIP = "equip" --人物装备拖动
SlotDrugMode.YAO   = "yao" 	 --药品拖动
SlotDrugMode.ITEM  = "item"  --药品拖动
----新类型再添加


function SlotDrugMode:init(  )
	
end

function SlotDrugMode:fini(  )
	_all_listener_solt = {}
end

--注册的solt的view, 要监听的类型table
function SlotDrugMode:registDragEvent( obj,types )
	for i=1,#types do
		if not _all_listener_solt[types[i]] then
			_all_listener_solt[types[i]] = {}
		end
		table.insert(_all_listener_solt[types[i]],obj)
	end
end

function SlotDrugMode:removeDragEvent( obj,types )
	for i=1,#types do
		if _all_listener_solt[types[i]] then
			for k,v in pairs(_all_listener_solt[types[i]]) do
				if v == obj then
					table.remove(_all_listener_solt[types[i]],k)
					return 
				end
			end
		end
	end
end

--结束拖动位置，物品类型，物品
function SlotDrugMode:endDrag( pos,type,obj )
	if _all_listener_solt[type] then
		for k,v in pairs(_all_listener_solt[type]) do
			--SlotDrugMode:hitTest( v,pos )
			--如果都是Widget 可以用Widget的hitTest
			if v.view:isVisible() and v.view:hitTest(pos) then
				v:on_drag_in(obj)
				return
			end
		end
	end

end

--如果都是Widget 可以用Widget的hitTest
function SlotDrugMode:hitTest( obj,pos )
	local size = obj:getContentSize()
	local nsp = obj:convertToNodeSpace(pos);
    local rect = cc.rect(0,0,size.width,size.height)
   	local ret = cc.rectContainsPoint(rect,nsp)
    return ret;
end