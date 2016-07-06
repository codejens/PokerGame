-- AdditionAttrisStruct.lua
-- created by lyl on 2015-4-30
-- 附加  属性 结构


AdditionAttrisStruct = simple_class( StructBase )
-- ********** 初始化结构配置  子类必须重写
function AdditionAttrisStruct:init_struct_config(  )
	self._struct_config = {
        { "attr_type", SDT_UNSIGNED_CHAR, nil, nil },        -- 属性类型
        { "attr_percent", SDT_UNSIGNED_SHORT, nil, nil },    
        { "attr_value", SDT_UNSIGNED_INT, nil, nil },      -- 属性值
    }
end