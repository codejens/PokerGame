-- ComAttriStruct.lua
-- created by lyl on 2015-4-30
-- 属性 结构


ComAttriStruct = simple_class( StructBase )
-- ********** 初始化结构配置  子类必须重写
function ComAttriStruct:init_struct_config(  )
	self._struct_config = {
        { "attr_type", SDT_UNSIGNED_CHAR, nil, nil },        -- 属性类型
        { "attr_value", SDT_INT, nil, nil },      -- 属性值
    }
end

function ComAttriStruct:init_debug(  )
    self.is_debug = true
end