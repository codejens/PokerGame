-- SpriteConfig.lua
-- created by mwy on 2014-5-27
-- 精灵配置
require "../data/std_super_config"
require "../data/superconfig"
require "../data/std_super_mj"
require "../data/superpieceitem"

TransformConfig = {};

TransformConfig.stage_lv_t = { "精", "印", "忍", "体", "幻", "贤", "速", "力" }
TransformConfig.stage_book_t = { "臨の書", "兵の書", "闘の書", "者の書", "皆の書", "陣の書", "列の書", "在の書", "前の书", "火の書" }
TransformConfig.title_t = {"下忍", "精英下忍", "中忍", "精英中忍", "上忍", "精英上忍", "影", "超影", "六道仙人", "真•六道仙人" }

-----------------------变身表------------------------
-- 获取所有类型的忍者
function TransformConfig:get_ninja_model_by_id( ninja_id )
	for k,v in pairs(std_super_config) do
		if v.id == ninja_id then
			return v
		end
	end
	return nil
end

-- 获取变身的技能
function TransformConfig:get_ninja_skill_by_id( ninja_id )
	return std_super_config[ninja_id].skillid
end

-- 获取所有类型的忍者
function TransformConfig:get_all_ninja_models(  )
	local ninja_models = {}
	for i,v in ipairs(std_super_config) do
		ninja_models[i] = TransformConfig:get_ninja_model_by_id(v.id)
	end
	return ninja_models
end
-- 获取忍者个数
function TransformConfig:get_max_ninjia_count(  )
	return #std_super_config
end

-- 获取忍者所需碎片
function TransformConfig:get_piece_num_by_id( id )
	for k,v in pairs(std_super_config) do
		if v.id == id then
			return v.pieceNum
		end
	end
	return nil
end

-- 获取忍者来源
function TransformConfig:get_ninja_orige_way_by_id( nijia_id )
	return std_super_config[nijia_id].getway
end

-- 获取变身模型ID
function TransformConfig:get_ninja_modelid_by_id( nijia_id )
	-- ZXLog('nijia_id',nijia_id)
	return std_super_config[nijia_id].modelid
end

-- 物品产生的变身碎片对应的变身id
function TransformConfig:get_super_id_by_piece( piece_id )
	for k,v in pairs(superpieceitem) do
		if piece_id == v.id then
			return v.superid
		end
	end
	return nil
end

-- 某物品能产生的碎片数
function TransformConfig:get_piece_num_by_piece( piece_id )
	for k,v in pairs(superpieceitem) do
		if piece_id == v.id then
			return v.piecenm
		end
	end
	return 0
end

-- 变身描述
function TransformConfig:get_ninja_desc_by_id( id )
	for k,v in pairs(std_super_config) do
		if v.id == id then
			return v.desc
		end
	end
	return ""
end

function TransformConfig:get_ninja_name_by_id( id )
	for k,v in pairs(std_super_config) do
		if v.id == id then
			return v.name
		end
	end
	return ""
end

function TransformConfig:get_active_item_by_id( id )
	for k,v in pairs(std_super_config) do
		if v.id == id then
			return v.itemid
		end
	end
	return 0
end

function TransformConfig:get_getway_by_id( ninja_id )
	local m = TransformConfig:get_ninja_model_by_id( ninja_id )
	if m then
		return m.getway or ""
	end
	return ""
end

function TransformConfig:get_motto_by_id( ninja_id )
	local m = TransformConfig:get_ninja_model_by_id( ninja_id )
	if m then
		return m.motto or ""
	end
	return ""
end

function TransformConfig:get_max_fight_by_id( ninja_id )
	local m = TransformConfig:get_ninja_model_by_id( ninja_id )
	if m then
		return m.maxzl or 0
	end
	return 0
end

-----------------------秘籍表------------------------
-- 获取秘籍

function TransformConfig:get_all_miji( )
	return std_super_mj
end

function TransformConfig:get_miji_by_id( id )
	for k,v in pairs(std_super_mj) do
		if v.id == id then
			return v
		end
	end
	return nil
end

-- 获取秘籍信息
-- @prame:秘籍id
function TransformConfig:get_miji_info_by_id( id )
	local m = TransformConfig:get_miji_by_id( id )
	return {name = m.name, type = m.deftype, ms = m.ms, desc = m.desc,}
end

-- 获取秘籍属性加成
-- @praram:秘籍id，秘籍等级
-- 血,攻击,法防,物防,暴击,防爆,命中,闪避
function TransformConfig:get_miji_attrs( id, miji_level)
	local m = TransformConfig:get_miji_by_id( id )
	local attr_t = m.attrs[miji_level]
	return {lift=attr_t[1],attack=attr_t[2],mdef=attr_t[3],wdef=attr_t[4],crit=attr_t[5],rcrit=attr_t[6],focus=attr_t[7],dodge=attr_t[8]}
end

-- 获取秘籍抵抗数值加成
-- @praram:秘籍id，秘籍等级
function TransformConfig:get_miji_defvalue( id, miji_level)
	local m = TransformConfig:get_miji_by_id( id )
	local value_t = m.defvalue
	return value_t[miji_level]
end

-- 获取4个秘籍对应的icon
-- @praram:秘籍id
function TransformConfig:get_miji_icon_path( miji_id)
	local path = nil
	if miji_id==1 then
		path='icon/item/00666.pd'
	elseif miji_id==2 then
		path='icon/item/00667.pd'
	elseif miji_id==3 then
		path='icon/item/00668.pd'
	elseif miji_id==4 then
		path='icon/item/00669.pd'
	end
	return path
end

-- 获取奥义秘籍item ID
function TransformConfig:get_need_miji_id( id )
	local m = TransformConfig:get_miji_by_id( id )
	return m.jihuoitem
end

-- 获取升阶晶片item ID
function TransformConfig:get_curr_stage_crystal_item_id()
	return superconfig.jinjieitem
end

-- 获取长阶晶片数量
function TransformConfig:get_upgrade_item_num_by_level( level )
	return superconfig.jinjieNeedNum[level] or 0
end

-- 
function TransformConfig:get_miji_skill_desc_by_id( id )
	local m = TransformConfig:get_miji_by_id( id )
	if m then
		return m.skillway_m or ""
	end
	return ""
end

-- 获取对应等级的祝福值
function TransformConfig:get_max_zhufu_by_level(skill_level)
	-- ZXLog('----------------get_max_zhufu_by_level-----------------',skill_level)
	if skill_level>#superconfig.jinjiemod then
		return 100
	end
	return superconfig.jinjiemod[skill_level][2]
end

-- 获取培养数据 
function TransformConfig:get_dev_info_by_stage( stage )
	local trains = superconfig.SuperTrains.trains
	-- print("=========TransformConfig:get_dev_info_by_stage=======", #trains)
	if stage >= 1 and stage <= #trains then
		return trains[stage]
	else
		return nil
	end
end

-- 获取秘籍升级所需要的元宝
--@prame:秘籍等级
function TransformConfig:get_upgrad_cost_by_level(skill_level)
	return superconfig.jinjieNeedNum[skill_level]*superconfig.jinjieyuanbao
end

-- 获取秘籍升级的晶片数
--@prame:秘籍等级
function TransformConfig:get_upgrad_need_critical(skill_level)
	return superconfig.jinjieNeedNum[skill_level]
end

-- 获取秘籍来源
--@prame:秘籍ID
function TransformConfig:get_miji_source(skill_id)
	return std_super_mj[skill_id].ms
end

-- 获取秘籍效果说明
function TransformConfig:get_miji_effect( skillid )
	for k,v in pairs(std_super_mj) do
		if skillid == v.id then
			return v.dk
		end
	end
	return ""
end

function TransformConfig:get_super_skill(  )
	local super_skill_t = {}
	for k,v in pairs(std_super_config) do
		super_skill_t[k] = v.skillid
	end
	return super_skill_t
end
