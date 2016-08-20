-- IupGetParam Example in IupLua
-- Shows a dialog with many possible fields.

require("iuplua" )
require("iupluacontrols")
require('resourcePack/codes/config')
require('LuaXml')
require('ex')
local xfile = xml.load("resource/AppConfig.xml")
function param_action(dialog, param_index)
  if (param_index == -1) then
    print("OK")
  elseif (param_index == -2) then
    print("Map")
  elseif (param_index == -3) then
    print("Cancel")
  else
    local param = iup.GetParamParam(dialog, param_index)
    print("PARAM"..param_index.." = "..param.value)
  end
  return 1
end

-- set initial values

local netType_map =
{
	[0] = 'internal_network',
	[1] = 'external_network',
	[2] = 'external_network2'
}



netType_id  = 0
update_type = 0
screen_index = 0

ret, netType_id, update_type,screen_index =
      iup.GetParam( "游戏登录器", param_action,
                    "登录类型: %l|登录内网|登录外网安卓|\n" ..
					"是否更新: %l|不更新|更新|\n" ..
					"屏幕类型: %l|iphone4|iphone5|ipad|1280x720|\n"
					,
                    netType_id, update_type,screen_index)
if (not ret) then
  return
end

local config = AppConfig[netType_map[netType_id]]
if not config then
	iup.Message('无效配置')
end


for k,v in pairs(config) do
	local xscene = xfile:find(k)
	if xscene then
		xscene[1] = v
	else
		xfile:append(k)[1] = v
	end
end

local _update_flag = 'false'
if update_type == 0 then
	_update_flag = 'true'
end

local xscene = xfile:find('no_update')
if xscene then
	xscene[1] = _update_flag
else
	xfile:append('no_update')[1] = _update_flag

end

local screenConfig = AppConfig.screen_size
local config = screenConfig[screen_index]
if not config then
	iup.Message('无效配置')
end


for k,v in pairs(config) do
	local xscene = xfile:find(k)
	if xscene then
		xscene[1] = v
	else
		xfile:append(k)[1] = v
	end
end


xml.save(xfile, "resource/AppConfig.xml")

os.spawn('zhanxian.exe')
