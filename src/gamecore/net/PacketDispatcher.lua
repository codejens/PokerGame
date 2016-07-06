-- PacketDispatcher.lua
-- created by aXing on 2012-11-27
-- 网络消息派发器
-- 单单用于处理网络消息

--[[
 这里声明一下net packetage有哪些读取方法
    void            writeString(const char *str);
    char*           readString();

    unsigned char   readByte();
    char            readChar();
    unsigned short  readWord();
    short           readShort();
    int             readInt();
    unsigned int    readUInt();
    double          readUint64();
    double          readInt64();

    void            writeByte(unsigned char btValue);
    void            writeChar(char cValue);
    void            writeWord(unsigned short wValue);
    void            writeShort(short wValue);
    void            writeInt(int  nValue);
    void            writeUInt(unsigned int  uValue);    
    void            writeUint64(double value);
    void            writeInt64(double value); 
]]--



PacketDispatcher = {}

--local bi_server_url = CCAppConfig:sharedAppConfig():getStringForKey("bi_server_url")

-- 执行包函数
function PacketDispatcher:do_game_logic(sysid, pid, pack, size)
	print("receive sysid, pid",sysid, pid)
    -- 分发到具体方法
    if protocol_func_map_server[sysid] and 
    	protocol_func_map_server[sysid][pid] then 
        local func = protocol_func_map_server[sysid][pid]
        func( pack )
    end

end

-- 发送协议
function PacketDispatcher:send_protocol( prot_id_t, ...  )
    local prot_func = nil
    local sysid = prot_id_t[1] or ""
    local pid   = prot_id_t[2] or ""

    if ( protocol_func_map_client[sysid] and protocol_func_map_client[sysid][pid] ) then 
        prot_func = protocol_func_map_client[sysid][pid]
        print(" send sysid : ", sysid , pid, ...)
        prot_func( ... )
    else
    	printError( "Can't find the function : ", sysid, pid )
    end
end

-- 注册协议处理函数
local _protocol_callback_t = {}
function PacketDispatcher:register_protocol_callback( prot_id_t, func )
	if prot_id_t == nil then 
        return 
	end
	local sysid = prot_id_t[1] or ""
    local pid   = prot_id_t[2] or ""

    _protocol_callback_t[sysid] = _protocol_callback_t[sysid] or {}
    if _protocol_callback_t[sysid][pid] then
        local message = string.format("注册协议%d，%d处理函数失败,此协议已经注册过了",sysid,pid)
        systemHelper.messageBox("注册失败",message )
        return
    end
    _protocol_callback_t[sysid][pid] = func
   -- _protocol_callback_t[sysid][pid] = _protocol_callback_t[sysid][pid] or {}
   -- table.insert( _protocol_callback_t[sysid][pid], func )
end

function PacketDispatcher:dispather( sid, pid, ... )--分发数据
    if _protocol_callback_t[sid] and
    	_protocol_callback_t[sid][pid] then
        local callback_f = _protocol_callback_t[sid][pid]
        if callback_f then
            callback_f(...)
        end
        -- for i = 1, #callback_t do 
        --     local callback_f = callback_t[i]
        --     callback_f(...)
        -- end
    end
end