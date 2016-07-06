local _old_print = print
local table_concat = table.concat

module(...,package.seeall)
local log = nil

local new_print = function(...)
    local out = {}

    local n = select('#', ...)

    for i=1, n, 1 do
        local v = select(i,...)
        out[#out+1] = tostring(v)
    end
    local msg = table_concat(out,' ')
    _old_print(msg)
    log:setString(msg)
end

function test_Downloader()
	local lastTime = nil
	local function onDownloadOK()
		print('onDownloadOK')
		local function dok()
			print('decompressAsync ok')
		end

		local function progress(name, code0, code1)
			print(name,code0,code1)
		end
		resourceHelper.decompressAsync('F:\\dl_test\\zx_package_ios_1.21.05_1.22.00.zip',1,dok,progress)
	end

	local function onDownloadError(code0,code1,code2)
		print('onDownloadError',code0,code1,code2)
	end

	local function onDownloadProgress(totalToDownload,nowDownloaded, localfileSize)
		if lastTime == nil then
			lastTime = os.clock()
		end

		local time_pass = (os.clock() - lastTime)
		if time_pass == 0 then
			time_pass = 0.0001
		end
		local speed = ( (nowDownloaded / 1024) / time_pass)

	
		local rate = string.format('%.2f',nowDownloaded / totalToDownload)
		print('onDownloadProgress',string.format('%.2f',speed),rate,totalToDownload, localfileSize + nowDownloaded)
	end

	local path = "F:\\dl_test\\"--cc.FileUtils:getInstance():getWritablePath()
	path = path .. [[2002_zxsj1.27.00_yingyongbao_20150521_1545.apk]]
	local URL = [[http://dlied5.myapp.com/myapp/hndd/zhanxian/2002_zxsj1.27.00_yingyongbao_20150521_1545.apk]]
	
	local option = {
		['url'] = URL,
		['file'] = path,
		['priority'] = 0,
		['retry'] = 1,
		['md5'] = '',
		['resume'] = true,
		['fileSize'] = 0
	}
	resourceHelper.loadWWW(option,onDownloadOK,onDownloadError,onDownloadProgress)
	--[[
	local option = {
		['url'] = URL,
		['file'] = path,
		['priority'] = 0,
		['retry'] = 1,
		['md5'] = '',
		['resume'] = true,
		['fileSize'] = 0
	}
	resourceHelper.loadWWW(option,onDownloadOK,onDownloadError,onDownloadProgress)
	]]--
end

function startTest(root)
	print = new_print
  	log = ccui.Text:create()
  	root:addChild(log)
  	log:setPosition(960/2,640/2)
  	test_Downloader(root)
end

function endTest()
	print = _old_print
end