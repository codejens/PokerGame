-- SkillMiJiModel.lua
-- created by tjh on 2014-5-29
-- 技能秘籍

SkillMiJiModel = {}

--秘籍背包数据
local _miji_beibao_date = {}

local _jingyandan_id = {29661,29660,39605,39606,39607,39608} --秘籍经验丹

local _pingzhi_string = {
	"green","blue","purple","orange","red",
}
--数字转换文字
local _num_tex = {
	"一重·","二重·","三重·","四重·","五重·","六重·","七重·","八重·","九重·",
}
--秘籍界面左上角按钮当前选中的选项
local _curr_select_btn = 1
--当前选中的技能ID
local _curr_select_skill_id = 1
--秘籍数据
local _miji_date = {}
--秘籍是否装备
--成功标志
local _SUCCESSED = 1

function SkillMiJiModel:fini(  )
	_miji_beibao_date = {}
	_curr_select_btn = 1
	_curr_select_skill_id = 1
	_miji_date = {}
end

--获取背包数据
function SkillMiJiModel:get_miji_beibao_date(  )
	return _miji_beibao_date
end

--秘籍点击回调
function SkillMiJiModel:miji_click_cb_func( skill_id )
	_curr_select_skill_id = skill_id
   local page = SkillMiJiModel:get_miji_page(  )
   if page then 
   		local is_have =  SkillMiJiModel:is_have_miji( skill_id )
   		local miji_id= SkillMiJiModel:get_skill_can_user_miji()
   		local table = SkillMiJiModel:get_miji_desc(99,9,0)
   		page:update_miji_left_down(is_have,miji_id,table.desc)
   		--if _curr_select_btn == 1 then
    		--local miji_date = SkillMiJiModel:get_my_curr_miji(  )
    		local date = SkillMiJiModel:get_miji_desc( )
    		--local date = {id = miji_date.item_id,name = name,desc=desc }
    		page:update_rt_page( _curr_select_btn,is_have,date )

   		--end
   		SkillMiJiModel:update_beibao_date( skill_id,_curr_select_btn )
   end
   
end

--生成秘籍描述及一些相关东西
function SkillMiJiModel:get_miji_desc( max_level,max_chong,max_ceng )

	local curr_miji_date = SkillMiJiModel:get_my_curr_miji(  )
	 local table = {}
	if curr_miji_date then
		local item_data = ItemConfig:get_item_by_id(curr_miji_date.item_id);
		local chong = curr_miji_date.void_bytes_tab[2] + 1 --重
		local ceng =  curr_miji_date.void_bytes_tab[7] 		--层
		ceng = SkillMiJiModel:xiulian_value_to_ceng( chong,ceng )
		local curexp = curr_miji_date.void_bytes_tab[3]
		local pz = _pingzhi_string[item_data.color]
		local level,maxexp = MijiConfig:get_miji_level( curexp,pz )
		-- print("当前秘籍经验值",curexp)
		-- 额外获取一下上一级需要的经验值 add by gzn
		local last_maxexp = nil;
		if level > 1 then
			last_maxexp = MijiConfig:get_miji_exp( level-1 ,pz)
		else
			last_maxexp = 0;
		end

		if max_level then
			level = max_level
			chong =max_chong
			ceng = max_ceng
		end
		local value_table,att_type = MijiConfig:get_miji_dest_value_by_id( curr_miji_date.item_id,level,chong,ceng)
		local desc_str = item_data.desc
		 if #value_table <=2 then --非顶级
		 	desc_str = MiJiItemTipView:comminute_dest(false,desc_str)
		 	desc_str = desc_str..value_table[1]
		 else
		 	local str_table = MiJiItemTipView:comminute_dest(true,desc_str,att_type)
		 	desc_str  =""
		 	for i=1,#str_table do
		 		desc_str = desc_str..str_table[i]
		 		if value_table[i] and i < (#str_table) then
	 				desc_str = desc_str..value_table[i]
	 			end
		 	end
		 end

		 if level >99 then
		 	level =99
		 end
		 --名字加上颜色
		 local color = ItemConfig:get_item_color(curr_miji_date.quality)
		 local name  =  "#c"..color.._num_tex[chong]..item_data.name
		 table = {id =curr_miji_date.item_id, name =name,level = level,
		 desc =desc_str,maxexp = maxexp ,curexp = curexp,chong= chong,ceng = ceng,
		 quality =curr_miji_date.quality ,last_maxexp = last_maxexp}
	 end
	 return table
end
--右边tab按钮回调
function SkillMiJiModel:tab_btn_click_cb_fun( index )
   _curr_select_btn = index
   local page = SkillMiJiModel:get_miji_page(  )
   if page then
    		local is_miji = SkillMiJiModel:is_have_miji(_curr_select_skill_id)
    		local date = SkillMiJiModel:get_miji_desc( )
    		page:update_rt_page( index,is_miji,date )
    end
    SkillMiJiModel:update_beibao_date( _curr_select_skill_id,_curr_select_btn )
end 

--背包道具使用回调
function SkillMiJiModel:user_item_cb_func( index )
	if index ~= 1 then
		local curr_miji = SkillMiJiModel:get_my_curr_miji(  )
		if not curr_miji then
			GlobalFunc:create_screen_notic( "请先装备秘籍", 16, 300, 200 )
			return false
		end
	end
	return true
end

--获取到技能秘籍页
function SkillMiJiModel:get_miji_page(  )
	local win = UIManager:find_window("user_skill_win")
	if win then 
		return win:get_page(UserSkillModel.MI_JI);
	end
end

--判断某个技能是否附带秘籍
function SkillMiJiModel:is_have_miji(skill_id)
	--local num = _miji_date.skill_num or  0
	if _miji_date.skill_num then
		for i=1,_miji_date.skill_num do
			if _miji_date.miji_date[i].skill_id == skill_id then
				return true
			end
		end
	end
	return false
end

--准备好背包数据
function SkillMiJiModel:update_beibao_date( skill_id,btn_index )
	local flags = false  --是否是这个技能的秘籍
	local item_id = 1
	_miji_beibao_date = {} --清空数据
	if btn_index == 1 then
			local miji_id = MijiConfig:get_miji_by_skill_id( _curr_select_skill_id )--skill_id ) --某技能对应的秘籍ID
			local miji_date = SkillMiJiModel:get_items_by_type(ItemConfig.ITEM_TYPE_SKILL_MIJI) --背包中秘籍的卷
			if miji_date then
				for i=1,#miji_date do
					item_id = miji_date[i].item_id 
					flags = SkillMiJiModel:is_this_skill_miji( item_id ,miji_id )
					if flags then
						table.insert(_miji_beibao_date,miji_date[i])
					end
				end
			end
	elseif btn_index == 2 then
			_miji_beibao_date = SkillMiJiModel:get_items_by_type(ItemConfig.ITEM_TYPE_SKILL_MIJI,nil,true)
			local miji_date = SkillMiJiModel:get_miji_jingyandan(  )
			if miji_date then
				for i=1,#miji_date do
					table.insert(_miji_beibao_date,miji_date[i])
				end
			end
	elseif btn_index == 3 then
		local miji_id = MijiConfig:get_miji_by_skill_id( _curr_select_skill_id )
		local miji_date = SkillMiJiModel:get_items_by_type( ItemConfig.ITEM_TYPE_SKILL_MIJI,4 )
		if miji_date then
			for i=1,#miji_date do
				item_id = miji_date[i].item_id 
				flags = SkillMiJiModel:is_this_skill_miji( item_id ,miji_id )
				if flags then
					table.insert(_miji_beibao_date,miji_date[i])
				end
			end
		end
	end

   local page = SkillMiJiModel:get_miji_page(  )
   if page then 
		page:update_beibao(#_miji_beibao_date)
	end
end

--去背包取得适合职业的技能秘籍卷
function SkillMiJiModel:get_items_by_type(item_type,quality,is_need_exp) --ItemConfig.ITEM_TYPE_SKILL_MIJI
	local player = EntityManager:get_player_avatar()
	local bag_date,count = ItemModel:get_bag_data()
	local bag_date_clone = {}
    -- 去除空的
    for i = 1, count do  
        if bag_date[i] then 
        	local job_need = ItemModel:get_item_need_job( bag_date[i].item_id)
			if player.job == job_need or job_need == 0 then
				local itemtype = ItemModel:get_item_type( bag_date[i].item_id )
				if itemtype == item_type then
					if not quality or bag_date[i].quality == quality then
						if is_need_exp then  --如果需要经验
							if bag_date[i].void_bytes_tab[3] >0 then
								table.insert(bag_date_clone,bag_date[i])
							end
						else
							table.insert(bag_date_clone,bag_date[i])
						end
					end
				end
			end
        end
    end
    return bag_date_clone
end

--判断一个技能秘籍是否属于某个技能
function SkillMiJiModel:is_this_skill_miji( id,miji_id )
	for i=1,#miji_id do
		if miji_id[i] == id then
			return true
		end
	end
	return false
end
--取得背包中的秘籍经验丹
function SkillMiJiModel:get_miji_jingyandan(  )
	
	local bag_date,count = ItemModel:get_bag_data()
	local bag_date_clone = {}
    -- 去除空的
    for i = 1, count do  
        if bag_date[i] then 
        	if SkillMiJiModel:is_miji_jingyandan( bag_date[i].item_id ) then
        		table.insert(bag_date_clone,bag_date[i])
        	end
        end
    end
    return bag_date_clone
end
--取得同技能秘籍
function SkillMiJiModel:get_equal_skill_miji(  )
	local bag_date,count = ItemModel:get_bag_data()
	local bag_date_clone = {}
    -- 去除空的
    local miji_id = 1
    local num = _miji_date.skill_num or  0
    for i=1,num do
		if _miji_date.miji_date[i].skill_id == _curr_select_skill_id then
			 miji_id = _miji_date.miji_date[i].userItem.item_id
		end
	end
    for i = 1, count do  
        if bag_date[i] then 
    	 	if miji_id == bag_date[i].item_id then
    	 		table.insert(bag_date_clone,bag_date[i])
    	 	end
        end
    end
    return bag_date_clone
end
--判断一个物品是否是秘籍经验丹
function SkillMiJiModel:is_miji_jingyandan( item_id )
	
	for i=1,#_jingyandan_id do
		if item_id == _jingyandan_id[i] then
			return true
		end
	end
	return false
end

--获取某技能可装备的秘籍
function SkillMiJiModel:get_skill_can_user_miji(  )
	local miji_id = MijiConfig:get_miji_by_skill_id( _curr_select_skill_id )
	return miji_id
end
--取得我当前的秘籍
function SkillMiJiModel:get_my_curr_miji(  )
	local num = _miji_date.skill_num or 0
	for i=1, num do
		if _miji_date.miji_date[i].skill_id == _curr_select_skill_id then
			return  _miji_date.miji_date[i].userItem
		end
	end
end

--更新背包
function SkillMiJiModel:update_all( )
	SkillMiJiModel:update_beibao_date( _curr_select_skill_id,_curr_select_btn )
	local page = SkillMiJiModel:get_miji_page(  )
   if page then
		local is_miji = SkillMiJiModel:is_have_miji(_curr_select_skill_id)
		local date = SkillMiJiModel:get_miji_desc( )
		page:update_rt_page( _curr_select_btn,is_miji,date )
		page:delete_effect()
		--激活特效
		page:update_left_panel(_miji_date.miji_date,_miji_date.fight)

    end
end

--升级成功 装备成功 修炼成功
function SkillMiJiModel:do_successed( date  )
	if date.result == _SUCCESSED then
		local num = _miji_date.skill_num or  0
		--print("num",num)
		for i=1,num do
			if _miji_date.miji_date[i].userItem.series == date.guid or
			 _miji_date.miji_date[i].skill_id == date.skill_id then
			 local page = SkillMiJiModel:get_miji_page(  )
			 if page then
			 	local job_skill_t = UserSkillModel:get_player_skills()
			 	for j=1,#job_skill_t do
			 	   	if job_skill_t[j].id == _miji_date.miji_date[i].skill_id then
			 	   		page:player_successed_effect( j )
			 	    end  
			 	end
		     end
		     return
			end
		end

	end

end

---升级添加道具  可以获得经验
function SkillMiJiModel:add_items( items )
	local curr_miji_date = SkillMiJiModel:get_my_curr_miji(  )
	if not curr_miji_date then
		return
	end
	local exp = curr_miji_date.void_bytes_tab[3]
	-- print("当前秘籍经验值",exp)
	local new_exp = 0
	local item_id = nil
	local std_item = nil
	
	for i=1,#items do
		if items[i].guid then
			item_id = items[i].item_date.item_id
			std_item = ItemConfig:get_item_by_id( item_id )
			if std_item.type == ItemConfig.ITEM_TYPE_SKILL_MIJI	 then
				new_exp = new_exp + (items[i].item_date.void_bytes_tab[3]*items[i].count)
			else
				if std_item.experience then
					new_exp = new_exp + std_item.experience*items[i].count
				end
			end
		end
	end
	exp = exp + new_exp
	local pz = _pingzhi_string[curr_miji_date.quality]
	local level = MijiConfig:get_miji_level( exp,pz )
	if level == (curr_miji_date.strong+1) then
		level = level + 1
	end
	if level>99 then
		level = 99
	end

	-- 额外获取一下上一级需要的经验值 add by gzn
	local last_maxexp = nil;
	if curr_miji_date.strong+1 > 1 then
		last_maxexp = MijiConfig:get_miji_exp( curr_miji_date.strong+1-1 ,pz)
	else
		last_maxexp = 0;
	end

	local date = {exp=exp,new_exp =new_exp ,level=level,last_maxexp=last_maxexp}
	local page = SkillMiJiModel:get_miji_page(  )
	if page then
		page:update_exp_money_level(_curr_select_btn,date)
	end

end
--修炼添加道具 可以获得修炼值
function SkillMiJiModel:xiulian_add_items( items )
	local curr_miji_date = SkillMiJiModel:get_my_curr_miji(  )
	if not curr_miji_date then
		return
	end
	local chong = curr_miji_date.void_bytes_tab[2] + 1 --重
	local ceng =  curr_miji_date.void_bytes_tab[7] 		--层
	local xiulian_value = ceng
	local value = 0
	for i=1,#items do
		if items[i].guid then
			value = items[i].item_date.void_bytes_tab[7] + 1
			xiulian_value = xiulian_value +value
		end
	end
	--if xiulian_value == ceng  then
	--end
	local max_chong = SkillMiJiModel:get_chong_by_xianlian( xiulian_value )

	xiulian_value = SkillMiJiModel:xiulian_value_to_ceng( chong,xiulian_value )

	if max_chong >= 9 then
		max_chong = 9
	end
	if max_chong == chong then
		max_chong = chong + 1
	end
	local date = {value=xiulian_value,chong=max_chong}
	
	local page = SkillMiJiModel:get_miji_page(  )
	if page then
		page:update_exp_money_level(_curr_select_btn,date)
	end

end

--打开秘籍窗口
function SkillMiJiModel:open_miji_page(  )
    if not GameSysModel:isSysEnabled( GameSysModel.MIJI ,true) then
        return
    end
	local win = UIManager:show_window( "user_skill_win" )
	if win then 
		win:selected_tab_button( UserSkillModel.MI_JI )
	end
end

--升级修炼界面点击icon事件
function SkillMiJiModel:slot_click_cb_func(  )
	local date = SkillMiJiModel:get_my_curr_miji(  )
	TipsWin:showTip( 300,250, date,nil,nil, nil)
end
------------网络部分---------------
--申请我的秘籍信息
function SkillMiJiModel:req_miji_info(  )
	SkillMiJiCC:req_miji_info(  )
	
end
--下发我的秘籍信息
function SkillMiJiModel:do_miji_info( date )
	_miji_date = date

	--更新背包
	SkillMiJiModel:update_beibao_date( _curr_select_skill_id,_curr_select_btn )
   local page = SkillMiJiModel:get_miji_page(  )
   if page then 
	    local is_miji = SkillMiJiModel:is_have_miji(_curr_select_skill_id)
		local date = SkillMiJiModel:get_miji_desc( )
		page:update_rt_page( _curr_select_btn,is_miji,date )
		--更新秘籍
		page:update_left_panel(_miji_date.miji_date,_miji_date.fight)
		local miji_id= SkillMiJiModel:get_skill_can_user_miji()
		local table = SkillMiJiModel:get_miji_desc(99,9,0)
		page:update_miji_left_down(is_miji,miji_id,table.desc)
	end
end




--申请附带秘籍
function SkillMiJiModel:req_fudai_miji( guid )
	SkillMiJiCC:req_fudai_miji( guid )
end
--下发附带秘籍结果
function SkillMiJiModel:do_fudai_miji( date )
	SkillMiJiModel:req_miji_info(  )
	if _curr_select_btn == 1 then
		SkillMiJiModel:tab_btn_click_cb_fun( 1 )
	end
	print("--下发附带秘籍结果")
	SkillMiJiModel:do_successed( date )
end
--申请卸下秘籍
function SkillMiJiModel:req_xiexia_miji(  )
	SkillMiJiCC:req_xiezai_miji( _curr_select_skill_id )
end
--卸下秘籍返回
function SkillMiJiModel:do_xiaxia_miji(date)
	SkillMiJiModel:req_miji_info(  )
	-- if _curr_select_btn == 1 then
	-- 	SkillMiJiModel:tab_btn_click_cb_fun( 1 )
	-- end
end
--升级秘籍
function SkillMiJiModel:req_shengji_miji( items )

	local num = _miji_date.skill_num or  0
	for i=1,num do
		if _miji_date.miji_date[i].skill_id == _curr_select_skill_id then
			local dest_guid = _miji_date.miji_date[i].userItem.series
			SkillMiJiCC:req_shengji_miji( dest_guid,items )
			return
		end
	end

end
--下发升级秘籍结果
function SkillMiJiModel:do_shengji_miji( date )
	SkillMiJiModel:req_miji_info(  )
	SkillMiJiModel:do_successed( date)
end
--合成秘籍
function SkillMiJiModel:req_hecheng_miji( items )
	local num = _miji_date.skill_num or  0
	for i=1,num do
		if _miji_date.miji_date[i].skill_id == _curr_select_skill_id then
			local dest_guid = _miji_date.miji_date[i].userItem.series
			SkillMiJiCC:req_hecheng_miji( dest_guid,items )
			return
		end
	end
	
end

function SkillMiJiModel:do_hecheng_miji( date )
	SkillMiJiModel:req_miji_info(  )
	SkillMiJiModel:do_successed(date)
end

--层转换 服务器给的是总修炼值
function SkillMiJiModel:xiulian_value_to_ceng( chong,value )
	local sum = 0
	for i=1,chong -1 do
		sum = sum + i 
	end
	return value - sum
end
--根据修炼值 计算重数
function SkillMiJiModel:get_chong_by_xianlian( value )
	local sum = 0
	for i=1,10 do
		sum = sum + i
		if sum > value then
			return i
		end
	end
end

function SkillMiJiModel:is_closing_window()
	-- 关闭窗口时，通知model层重置数据
	_curr_select_btn = 1;
end