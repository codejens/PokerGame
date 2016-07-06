local lfs = require"lfs"


-- 加入reload的文件
local reload_file_t = {
    "../gamecore/ui/__init.lua",
    "../gamecore/model/__init.lua",
}





local file_code = ""

-- 某个文件的所有require reload。
local function reloadInFile( filename )
    local file = io.open( filename, "r")
    for line in file:lines() do 
        if line:match("require") then 
            local require_index = line:find("require")
            local require_content = string.sub( line, require_index+7 )
            -- reload语句
            print(filename, line, require_index)
            if not require_content:match("manager") then 
                file_code = file_code .. " reload (" .. require_content .. " )\n"
            end
        end
    end
    file:close()
end

-- reload 文件
for i = 1, #reload_file_t do 
    reloadInFile( reload_file_t[i] )
end 



file_code = file_code .. "GUIManager:refresh_current_win(  )\n"

print(file_code)
-- 写入
local file_path = "RefreshForTest.lua"
local f = io.open( file_path, "w+")
f:write(file_code)
f:close()








local files_name_t = {}
function attrdir (path)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file
            local attr = lfs.attributes (f)
            assert (type(attr) == "table")
            if attr.mode ~= "directory" then
                local path_temp = string.gsub( path, ".\\\/", "" )
                table.insert( files_name_t, path_temp.."/"..file )
            else
                attrdir( f )
            end
        end
    end
    return files_name_t
end

-- 遍历
-- local _files_name_t = attrdir (".\\")

-- for key, file_name in pairs(_files_name_t) do 
--  -- local idx = file_name:match(".+()%.%w+$")
--  -- file_name = file_name:sub(1, idx-1)    
--     if file_name:match("init") then 
--         reloadInFile( file_name )
--     end
-- end