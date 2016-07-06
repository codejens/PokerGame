module(...,package.seeall)
--这个测试了timer和luasocket
function startTest(root)
	serverBase()
	serverBase:start()
end
