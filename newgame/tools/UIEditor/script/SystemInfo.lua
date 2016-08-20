SystemInfo = {}

function SystemInfo.getAvailableMemory()
	return phone_getAvailableMemory()
end

function SystemInfo.getThreshold()
	return phone_getThreshold()
end

function SystemInfo.getNetworkType()
	return phone_tx_getNetworkType()
end

function SystemInfo.getSP()
	return phone_tx_getSP()
end

function SystemInfo.showMemoryState()
	if GetPlatform() == CC_PLATFORM_ANDROID then	
		local av = SystemInfo.getAvailableMemory()
		local th = SystemInfo.getThreshold()
		local tipmsg = string.format('剩余内存[%.2fmb],可用内存[%.2fmb]',av/1024.0,(av-th)/1024.0)
		MUtils:toast_black(tipmsg ,500000,8,true)
	end
end

function SystemInfo.getMacAddress()
	return GetMacAddress()
end