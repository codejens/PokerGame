luaFunToCFunc = {}
local XLambdaLua = helpers.XLambdaLua
function luaFunToCFunc.convert(func)
	return XLambdaLua:create(func)
end
