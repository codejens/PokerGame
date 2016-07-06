-- UserItem.lua
-- created by lyl on 2015-4-29
-- 用户道具结构基类


StructBase = simple_class()

-- 这里要移动到常量定义文件
SDT_BOOL           = "bool"                 -- bool
SDT_CHAR           = "char"                 -- char
SDT_UNSIGNED_CHAR  = "unsigned_char"        -- unsigned char
SDT_SHORT          = "short"                -- short
SDT_UNSIGNED_SHORT = "unsigned_short"       -- unsigned short
SDT_INT            = "int"                  -- int
SDT_UNSIGNED_INT   = "unsigned_int"         -- unsigned int
SDT_INT64          = "int64"                -- int64
SDT_UNSIGNED_INT64 = "unsigned_int64"       -- unsigned int64


SDT_STRUCT         = "struct"       -- struct
SDT_STRING         = "string"       -- string
SDT_ARRAY          = "array"        -- array

-- 类型字符串与方法的映射
local data_type_function_name_map = {
    [SDT_BOOL]          = { read = "readChar",  write = "writeChar"  },       -- bool
	[SDT_CHAR]          = { read = "readChar",  write = "writeChar"  },       -- char
    [SDT_UNSIGNED_CHAR] = { read = "readByte",  write = "writeByte"  },       -- unsigned char
    [SDT_SHORT]         = { read = "readShort", write = "writeShort"  },       -- short
    [SDT_UNSIGNED_SHORT]= { read = "readWord", write = "writeWord"  },       -- unsigned short
    [SDT_INT]           = { read = "readInt",   write = "writeInt"  },       -- int
    [SDT_UNSIGNED_INT]  = { read = "readUInt",  write = "writeUInt"  },       -- unsigned int
    [SDT_INT64]         = { read = "readInt64" ,write = "writeInt64"  },       -- int64
    [SDT_UNSIGNED_INT64]= { read = "readUint64",write = "writeUint64"  },       -- unsigned int64
    [SDT_STRING]        = { read = "readString", write = "writeString"  },       -- string
}



-- 属性配置。 { data_name, data_type, length_or_class, cell_property_config }
-- data_name: 属性名
-- data_type: 数据类型
-- length_or_class: 如果是数组，就传入长度  !:: 非数组情况传nil.  如果是结构，就是对应的 结构类
-- cell_property_config: 数组元素的配置(元素也可以是数组)  !:: 非数组情况传nil

-- 结构配置范例  参考UserItem
--[[
self._struct_config = {
	{ "var_name", "data_type", length_or_class, cell_property_config }
    { "series", SDT_INT64, nil, nil },                -- 物品唯一系列号
    { "holes", SDT_ARRAY, 3, Holes_config },          -- 物品的镶嵌槽列表，对于一个镶嵌槽0x8000位置位则表示已经打孔，0x7FFF位表示所镶嵌的物品的ID
    { "bapize_value", SDT_ARRAY, 3, bapize_value_config },    -- 洗练属性类型和值  
}


]]
-- 根据类型读取包
--   pack: 网络跑
-- one_property_config :  属性配置。 { data_name, data_type, length_or_class, cell_property_config }
-- data_name: 属性名
-- data_type: 数据类型
-- length_or_class: 如果是数组，就传入长度  !:: 非数组情况传nil.  如果是结构，就是对应的 结构类
-- cell_property_config: 数组元素的配置(元素也可以是数组)  !:: 非数组情况传nil
function StructBase:readPackData( pack, one_property_config )
    local ret = nil    -- 返回值
    local var_name = one_property_config[1]         -- 变量名
    local data_type = one_property_config[2]        -- 类型
    local length_or_class = one_property_config[3]  -- 数组的长度。 结构的类
    local cell_property_config = one_property_config[4]  -- 数组元素的类型
    
    if data_type == SDT_STRUCT then 
        ret = length_or_class( pack )
    elseif data_type == SDT_ARRAY then 
    	ret = {}
    	local array_length = length_or_class 
    	-- 如果数组情况下，这是个字符串，则表示这个长度根据前面的数组
    	if type( length_or_class ) == "string" then 
            array_length = self[ length_or_class ]
    	end
    	for i = 1, array_length do 
    		local data  = self:readPackData( pack, cell_property_config )
    		-- self:check_print( "struct  array      var_name:", var_name, "   data:", data , "   i:", i  )
            table.insert( ret, data )
    	end

    else 
    	local func_map = data_type_function_name_map[ data_type ]
    	local func_name = func_map.read
    	ret = pack[ func_name ]( pack )
    	self:check_print( "func_name : ", func_name)
    end
    -- self:check_print( "struct ::::::     var_name:", var_name, "   ret:", ret, "   data_type:", data_type  )
    return ret
end

-- 根结构配置，把数据写入包
function StructBase:writePackData( pack, one_property_config )
	local var_name = one_property_config[1]         -- 变量名
    local data_type = one_property_config[2]        -- 类型
    local length_or_class = one_property_config[3]  -- 数组的长度。 结构的类
    local cell_property_config = one_property_config[4]  -- 数组元素的类型
    local property_data = self[ var_name ]
    
    if data_type == SDT_STRUCT then 
        property_data:write_pack( pack )

    elseif data_type == SDT_ARRAY then 
    	for i = 1, length_or_class do 
    		self:writePackData( pack, cell_property_config )
    	end

    else 
    	local func_map = data_type_function_name_map[ data_type ]
    	local func_name = func_map.write
    	local property_data = self[ var_name ]
    	pack[ func_name ]( pack, property_data )    -- 写入
    end
end

-- 打印解析过程
function StructBase:check_print( ... )
    if self.is_debug then 
        print(...)
    end
end

-- 打印某个value
function StructBase:print_value( var_name, var_value, pre_str  )
	if not self.is_debug then 
        return
	end
	pre_str = pre_str .. "----"
    if type( var_value ) == "table" then 
    	self:check_print( "struct ::::::  "..pre_str.."  var_name: ", var_name, "    var_value:",var_value )
    	-- 如果 var_value 是个结构体，就不是一般的遍历，否则会把所有元素打印出来
    	if var_value._struct_config then 
            var_value:print_property( pre_str  )
            return
    	end
        for key, value in pairs( var_value ) do 
            self:print_value( key, value, pre_str )
        end
    else
    	self:check_print( "struct ::::::  "..pre_str.."  var_name: ", var_name, "    var_value:",var_value )
    end
end

-- 打印属性
function StructBase:print_property( pre_str )
	local is_debug_old = self.is_debug
	self.is_debug = true
    for i = 1, #self._struct_config do 
        local var_name = self._struct_config[i][1]
        self:print_value( var_name, self[ var_name ], pre_str  )
    end
    self.is_debug = is_debug_old
end


function StructBase:__init( pack )
	self.is_debug = false            -- 调试的时候，所有解析过程打印出来
    self._struct_config = nil        -- 结构配置，由子类定义
    self:init_debug(  )
    self:init_struct_config()
    self:read_pack( pack )
    
end

-- 根据自己结构读包。 特殊情况，子类可以重写
function StructBase:read_pack( pack )
	for i = 1, #self._struct_config do 
		local var_name = self._struct_config[i][1]
		local var_value = self:readPackData( pack, self._struct_config[i] )
        self[ var_name ] = var_value
        self:print_value( var_name, var_value, ""  )
    end
end

-- 根据自己数据，想包写入数据
function StructBase:write_pack( pack )
	for i = 1, #self._struct_config do 
        writePackData( pack, self._struct_config[i] )
    end
end





-- ************ 如果要调试，打印读取和写入过程。 重写这个方法。 然后 self.is_debug = true
function StructBase:init_debug(  )
    
end

-- ********** 初始化结构配置  子类必须重写
function StructBase:init_struct_config(  )
	self._struct_config = {}    -- 定义结构
end