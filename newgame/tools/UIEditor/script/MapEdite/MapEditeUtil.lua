--MapEditeUtil.lua

MapEditeUtil ={}


--bom格式头
local _bom_head = nil

function MapEditeUtil:txt_to_lua( file_name )
	local ret_t = {}
	print("xxd")

	local txt_name = file_name .. ".txt"
	local file,err = io.open(txt_name)
    print("txt_name,file,err",txt_name,file,err)
	if not file then
		return nil
	end

    _bom_head =  file:read(3)
    local data = file:read("*a") -- 读取所有内容
    local _str_date = data
    file:close()

    data = "temp = {" ..data .."}"


 	file = io.open("script/temp.lua", "w+")

    file:write(data)
    file:close()
    Lang = nil
    reload("MapEdite/lang")
    reload("temp")
    ret_t = temp

    for k,v in pairs(ret_t) do
    	print(k,v)
    end
 
   return ret_t,_str_date
end  

function MapEditeUtil:sava_to_file( file_name,t_date )
    local lantable = ""

    if(#t_date) then
        lantable = MapEditeUtil:table_to_string( t_date,'\n' )
        MapEditeUtil:sava_file( file_name,lantable )
       

    end
end

function MapEditeUtil:save_npc_tp_file( file_name,npc_date,tp_date )
    local date_t,date_str = MapEditeUtil:txt_to_lua( file_name )

    local startp,endp = string.find(date_str,"npc =")
    if not startp then
        startp,endp = string.find(date_str,"npc=")
    end
    if not startp then
        CCMessageBox("Please check the file scene of npc =","scene file error")
        return
    end
    local date_str = string.sub(date_str,0,startp-1)

    local npc_str = MapEditeUtil:table_to_string( npc_date,' ' )
    npc_str = string.format("npc ={\n%s\n},\n",npc_str)
    local tp_str = MapEditeUtil:table_to_string( tp_date,' ' )
    tp_str = string.format("teleport ={\n%s\n},\n",tp_str)

    date_str = string.format("%s%s%s},",date_str,npc_str,tp_str)

    MapEditeUtil:sava_file( file_name,date_str )

end

function MapEditeUtil:table_to_string( t_date, decollator )
    local lantable = ""
    for i=1,#t_date do
        lantable = string.format("%s{",lantable)
        for key, value in pairs(t_date[i]) do
            if key == "name" then
                for k,v in pairs(Lang.EntityName) do
                    if v == value then
                        value = string.format("Lang.EntityName.%s",k)
                    end
                end
                for k,v in pairs(Lang.SceneName) do
                    if v == value then
                        value = string.format("Lang.SceneName.%s",k)
                    end
                end
            elseif type(value) == "string" then
                value = string.format('"%s"',value)
            end
            lantable = string.format('%s%s=%s,%s',lantable,tostring(key),value,decollator)
        end
        lantable = string.format("%s},\n",lantable)
    end
    return lantable
end

function MapEditeUtil:sava_file( file,str )
    local f = io.open( file..".txt",'wb+')
    if f then
        f:write(_bom_head)
        f:write(str)
        f:close()
    end
end