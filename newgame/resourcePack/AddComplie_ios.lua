require"lfs"


local scriptPath = "script" 	--脚本所在目录名
local binaryPath = ".\\AppleStoreRelease\\resource\\script" 	--bin文件所在目录名
local scriptType = ".lua"	 	--脚本扩展名
local binaryType = ".nst"   	--bin文件扩展名
local RecordRevistionFile = ".\\AppleStoreRelease\\addComplie.version" --增量打包版本号记录文件
local SVNLogTemp = "C:\\svnLog_ios.txt" --保存script差异信息
local batWorkPath = lfs.currentdir() --批处理脚本所在目录
batWorkPath = string.gsub(batWorkPath, "/", "\\")
local binaryChange = false
local SVNCommitlog = "脚本自动提交:听说有些版本必须要有提交log，而且字数必须凑够，但是我不知道需要多少字，怎样的log，所以我尽量写多些"
local t_ModifyFile 		= {}
local t_AddNewFile    	= {}
local t_AddNewBinDir  	= {}


function print_log(log)
	os.execute("echo  " .. log)
end

local _os_execute = os.execute
os.execute = function(cmd)
	print(cmd)
	_os_execute(cmd)
end
--获取当前最新版本
function GetNewRevision()
	print("scriptPath = ",scriptPath)
	os.execute("resourcePack\\bin\\svn info " .. scriptPath .. " > C:\\svnTemp_ios.txt" )
	local svnTempFile = io.open("C:\\svnTemp_ios.txt", "r")
	if svnTempFile then
		local line = svnTempFile:read()
		while line do
			local s, e = string.find(line, "Revision")
			if s then
				local Revision = string.sub(line, e+3, string.len(line))
				svnTempFile:close()
				return Revision
			end
			line = svnTempFile:read()
		end
	end
	svnTempFile:close()
	print_log("version error")
	return 0
end

--记录此次编译版本号
function RecordNewRersion()
	local info = lfs.attributes(RecordRevistionFile)
	if info then
		local revisionFile = io.open(RecordRevistionFile, "w")
		revisionFile:write(GetNewRevision()+1)
		revisionFile:close()
	else
		local cmdCreatFile = "echo create > " .. RecordRevistionFile
		os.execute(cmdCreatFile)
		local revisionFile = io.open(RecordRevistionFile, "w")
		revisionFile:write(GetNewRevision()+1)
		revisionFile:close()
	end
end

--获取上次增量编译版本号
function GetLastRersion()
	local info = lfs.attributes(RecordRevistionFile)
	if info then
		local revisionFile = io.open(RecordRevistionFile, "r")
		local line = revisionFile:read()
		revisionFile:close()
		if line then
			return line
		else
			return GetNewRevision()
		end
	else
		RecordNewRersion()
		os.execute("resourcePack\\bin\\svn add " .. RecordRevistionFile)
		os.execute("resourcePack\\bin\\svn commit -m 第一次使用这个脚本第一次使用这个脚本第一次使用这个脚本第一次使用这个脚本第一次使用这个脚本第一次使用这个脚本第一次使用这个脚本第一次使用这   " .. binaryPath)
		print_log("first run" .. RecordRevistionFile)
		return GetNewRevision()
	end
end

--返回bin文件在binary中的全路径
function GetBinaryBinFileName(fileName)
	local binFile = string.gsub(fileName, scriptPath, binaryPath)
	binFile = string.gsub(binFile, scriptType, binaryType)
	return binFile
end

--返回bin文件在script中的全路径
function GetScriptBinFileName(fileName)
	local binFile = string.gsub(fileName, scriptType, binaryType)
	return binFile
end


--编译生成bin文件
function ComplieFileAndMove(proJectPath, relativePath)
	if string.find(relativePath, ".lua$") then
		local fullPath = proJectPath .. relativePath
		local luacFile = fullPath-- .. "c"
		-- local cmdComplie = "luac -o " .. luacFile .. " " .. fullPath
		local cmdEncrypt = batWorkPath .. "\\resourcePack\\encryptlua " .. luacFile .. ' ' .. GetScriptBinFileName(relativePath)
		-- os.execute(cmdComplie)

		local luacInfo = lfs.attributes(luacFile)
		if luacInfo then
			os.execute(cmdEncrypt)
			-- os.remove(luacFile)
		else
			return 0 --编译失败
		end

		return 1 --编译成功
	end

	return 2--不是lua文件
end

--修改文件夹名？
--对修改的文件进行操作
function ModifyFile(proJectPath, relativePath)
	relativePath = string.gsub(relativePath, "/", "\\")
	local fullPath = proJectPath .. relativePath
	local info = lfs.attributes(fullPath)

	if info then
		if info.mode == "file" then
			local Ret = ComplieFileAndMove(proJectPath, relativePath)
			if Ret == 0 then
				return false
			elseif Ret == 1 then
				table.insert(t_ModifyFile, relativePath)
			end
		end
	end

	return true
end

--对新增加的文件进行操作
function AddFile(proJectPath, relativePath)

	relativePath = string.gsub(relativePath, "/", "\\")
	local fullPath = proJectPath .. relativePath
	local info = lfs.attributes(fullPath)

	if info then
		if info.mode == "file" then
			local Ret = ComplieFileAndMove(proJectPath, relativePath)
			if Ret == 0 then
				return false
			elseif Ret == 1 then
				table.insert(t_AddNewFile, relativePath)
			end
		else
			local binaryBinDir = proJectPath .. string.gsub(relativePath, scriptPath, binaryPath)
			local dirInfo = lfs.attributes(binaryBinDir)
			if dirInfo == nil then
				table.insert(t_AddNewBinDir, binaryBinDir)
			end
		end
	end

	return true
end

--对删除的文件进行操作
function DelFile(proJectPath, relativePath)
	relativePath = string.gsub(relativePath, "/", "\\")
	local binaryBinFile = proJectPath .. GetBinaryBinFileName(relativePath)
	local info = lfs.attributes(binaryBinFile)

	if info then
		local cmdSVNDel = "resourcePack\\bin\\svn del " .. binaryBinFile
		os.execute(cmdSVNDel)
		print(cmdSVNDel)
	end
end


--编译
function ComplieFile()
	local NewRevision = GetNewRevision()
	local LastRevision = GetLastRersion()
	print("NewRevision = ",NewRevision)
	print("LastRevision = ",LastRevision)
	
	-- if tonumber(NewRevision) <= tonumber(LastRevision) then
	-- 	return true
	-- end
	-- print("NewRevision = ",NewRevision)
	-- print("LastRevision = ",LastRevision)
	--从最新版本到上次操作的版本，拉取操作信息
	local cmdGetSvnLog = "resourcePack\\bin\\svn log -v -r " .. NewRevision .. ":" .. LastRevision .. " " .. scriptPath .. " >  " .. SVNLogTemp
	os.execute(cmdGetSvnLog)
	local logSVNFile = io.open(SVNLogTemp)
	local line = logSVNFile:read()
	local t_File = {} --记录文件已经添加到相应的table中
	local t_AddFile = {} --进行添加操作的文件
	local t_DelFile = {} --进行删除操作的文件
	local t_ModFile = {} --进行修改操作的文件

	--找出操作过的文件和文件夹，及其进行的操作
	while line do
		local Scs, ScE = string.find(line, scriptPath) --使用路径中的script确定操作的是script目录中的文件
		if Scs then
			local s,e = string.find(line, " A ")
			if s then
				local file = string.sub(line, Scs, string.len(line))
				if t_File[file] == nil then
					t_File[file] = true
					t_AddFile[file] = true
					table.insert(t_AddFile, file)
				end
			else
				local s,e = string.find(line, " M ")
				if s then
					local file = string.sub(line, Scs, string.len(line))
					print(file)
					if t_File[file] == nil then
						t_File[file] = true
						table.insert(t_ModFile, file)
					end
				else
					local s,e = string.find(line, " D ")
					if s then
						local file = string.sub(line, Scs, string.len(line))
						if t_File[file] == nil then
							t_File[file] = true
							table.insert(t_DelFile, file)
						end
					end
				end
			end

		end

		line = logSVNFile:read()
	end
	logSVNFile:close()

	--对添加和修改的文件进行编译
	--若是编译出错，清理中间文件，返回
	local projectPath = batWorkPath .. "\\"
	for i, v in ipairs(t_AddFile) do
		if AddFile(projectPath, v) == false then
			for i, v in ipairs(t_AddNewFile) do
				local scriptBinFile = projectPath .. GetScriptBinFileName(v)
				os.remove(scriptBinFile)
			end

			for i, v in ipairs(t_ModifyFile) do
				local scriptBinFile = projectPath .. GetScriptBinFileName(v)
				os.remove(scriptBinFile)
			end
			return false
		end
	end

	for i, v in ipairs(t_ModFile) do
		if ModifyFile(projectPath, v) == false then
			for i, v in ipairs(t_AddNewFile) do
				local scriptBinFile = projectPath .. GetScriptBinFileName(v)
				os.remove(scriptBinFile)
			end

			for i, v in ipairs(t_ModifyFile) do
				local scriptBinFile = projectPath .. GetScriptBinFileName(v)
				os.remove(scriptBinFile)
			end
			return false
		end
	end


	--告知svn添加和删除的文件
	for i, v in ipairs(t_AddNewBinDir) do
		lfs.mkdir(v)
		local cmdSVNAddFile = "resourcePack\\bin\\svn add " .. v
		os.execute(cmdSVNAddFile)
		binaryChange = true
	end

	for i, v in ipairs(t_AddNewFile) do
		local scriptBinFile = projectPath .. GetScriptBinFileName(v)
		local binaryBinFile = projectPath .. GetBinaryBinFileName(v)
		local cmdCopy = "copy /Y " .. scriptBinFile .. " " .. binaryBinFile
		local cmdSVNAdd = "resourcePack\\bin\\svn add " .. binaryBinFile
		os.execute(cmdCopy)
		os.execute(cmdSVNAdd)
		os.remove(scriptBinFile)
	end

	for i, v in ipairs(t_ModifyFile) do
		local scriptBinFile = projectPath .. GetScriptBinFileName(v)
		local binaryBinFile = projectPath .. GetBinaryBinFileName(v)
		local cmdCopy = "copy /Y " .. scriptBinFile .. " " .. binaryBinFile
		os.execute(cmdCopy)
		os.remove(scriptBinFile)
		binaryChange = true
	end

	for i, v in ipairs(t_DelFile) do
		DelFile(projectPath, v)
		binaryChange = true
	end

	return true
end

function GetCommitMsg()
	os.execute("resourcePack\\bin\\svn log -l 1 " .. scriptPath .. " > C:\\svnCommitLog_ios.txt")
	local file = io.open("C:\\svnCommitLog_ios.txt", "r")
	local line = file:read()
	local logSVN = ""
	local count = 0
	while line do

		if string.len(line) == 0 then
			count = count + 1
			if count > 1 then
				break
			end
		end
		if count > 0 then
			logSVN =  logSVN .."     " .. line
		end
		line = file:read()
	end
	file:close()
	logSVN = "auto commit:" .. logSVN
	return logSVN
end
--确保可以拉取到最新的版本号
os.execute("resourcePack\\bin\\svn update " .. binaryPath)
os.execute("resourcePack\\bin\\svn update " .. scriptPath)

if ComplieFile() then
	if binaryChange  then
		RecordNewRersion()
		os.execute("resourcePack\\bin\\svn log -l 1 " .. scriptPath .. " > C:\\svnCommitLog_ios.txt")
		os.execute("resourcePack\\bin\\svn commit -F " .. " C:\\svnCommitLog_ios.txt "   .. binaryPath)
	else
		print_log("echo script folder no change")
	end
else
	print_log("build error")
end

