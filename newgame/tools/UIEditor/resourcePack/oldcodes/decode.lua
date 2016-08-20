require 'luaiconv'
require 'SceneEffectConfig'
require 'strbuf'
require 'list'

local iconv = require("luaiconv")
--utf-8×ªµ½GBK
local cd = iconv.new("GBK", "utf-8")

oldstring = tostring

function __tostring(s)
	return cd:iconv(oldstring(s))
end


tostring = __tostring

print(SceneEffectConfig)
