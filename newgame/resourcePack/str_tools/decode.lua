require 'luaiconv'
require 'strbuf'
require 'list'

local iconv = require("luaiconv")
--utf-8×ªµ½GBK
local cd = iconv.new("GBK", "utf-8")

oldstring = tostring

function __tostring(s)
	return cd:iconv(oldstring(s))
end

function utf8code(s)
	return iconv.utf8code(s)
end

tostring = __tostring
