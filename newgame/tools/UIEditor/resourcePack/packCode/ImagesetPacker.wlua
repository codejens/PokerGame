-- IupGetParam Example in IupLua
-- Shows a dialog with many possible fields.

require( "iuplua" )
require( "iupluacontrols" )
require 'os'
function param_action(dialog, param_index)
  if (param_index == -1) then
    print("OK")
  elseif (param_index == -2) then
    print("Map")
  elseif (param_index == -3) then
    print("Cancel")
  else
	--print(dialog)
	--local param = iup.GetParamParam(dialog, param_index)
	--print("PARAM"..param_index.." = "..param.value)
    --local param = iup.GetParamParam(dialog, param_index)
  end
  return 1
end

function getLastPath(path)
	local i = string.find(path,'[/\\]')
	if i == nil then
		return path
	elseif  i == string.len(path) then
		return string.sub(path,0,string.len(path)-1)
	end
	local subpath = string.sub(path,i+1,string.len(path))
	return getLastPath(subpath)
end

srcPath = './../resourceTree/'
dstPath = './../resource/'
-- set initial values
function DoPack(reset)
	if reset then
		pboolean = 0
		pAnchorX = 316
		pAnchorY = 236
		pPackType = 0
		pAlpha = 0.02
		pFileType = 0
		pWidth = 3
		pHeight = 3
		pInputPath = 'ui\\'
		pOutputPath = 'ui'
		pOutputFilePrefix = ''
		size_table = { 128, 256, 512, 1024 }
		file_type = { '.png', '.jpg' }
		comporess_type = {'--dither-none-nn','--dither-none-linear','--dither-fs','--dither-fs-alpha','--dither-atkinson','--dither-atkinson-alpha'}
		pSort = 1
		pWebp = 0
		comporess_option = 3
	end
	ret,  pPackType, pFileType, comporess_option, pWidth, pHeight, pSort,pInputPath,pboolean,pWebp = --,pOutputPath = --,pAlpha, pAnchorX,pAnchorY =
		  iup.GetParam("图片打包工具", param_action,
					  "类型: %l|静帧(*.imageset)|\n"..
					  "通用参数 %t\n"..
					  "文件类型: %l|.png|.jpg|\n"..
					  "压缩类型: %l|NearestNeighbour|Linear|FloydSteinberg|FloydSteinberg-alpha|Atkinson|Atkinson-alpha|\n"..
					  "宽度: %l|128|256|512|1024|\n"..
					  "高度: %l|128|256|512|1024|\n"..
					  "排序: %l|不排序|高度升序|高度降序|\n"..
					  "输入\'./../resourceTree/\' %t\n"..
					  "子文件夹: %s{输入目标子文件夹名称,例如：输入 \'frame/human'\ ,结果就会从 './../resourceTree/frame/human\' 输入}\n" ..
					  "RGBA8888: %b\n" ..
					  "Webp: %b\n"
					  --..
					  --"输出\'./../resource/\' %t\n"..
					  --"子文件夹: %s{输出目标子文件夹名称,例如：输入 \'frame'\ ,结果就输出到 './../resource/frame\' }\n"
					  --"动画参数 %t\n"..
					  --"Alpha裁剪 %r{当裁剪时小于这个alpha阀值的像素将会被裁剪掉}\n"..
					  --"默认锚点X: %i[0,1024]\n"..
					  --"默认锚点Y: %i[0,1024]\n"
					  ,
					  pPackType, pFileType, comporess_option, pWidth, pHeight, pSort, pInputPath,pboolean,pWebp)--,pOutputPath) --, pAlpha, pAnchorX,pAnchorY)
	if (not ret) then
	  return false
	end

	pOutputFilePrefix = string.gsub(pInputPath,'[/\\]','_')
--[[
	print( pAnchorX,
		   pAnchorY,
		   pPackType,
		   pAlpha,
		   file_type[pFileType + 1],
		   size_table[pWidth + 1],
		   size_table[pHeight + 1],
		   srcPath .. pInputPath,
		   dstPath .. pOutputPath,
		   pOutputFilePrefix)
	]]--
	local reset = false
	pOutputPath = pInputPath
	pOutputPath = string.gsub(pOutputPath,'[\n\r]','')
	pInputPath = string.gsub(pInputPath,'[\n\r]','')
	pOutputFilePrefix = string.gsub(pOutputFilePrefix,'[\n\r]','')
	if pInputPath == '' then
		iup.Message('错误','输入文件夹为空')

	elseif pOutputPath == '' then
		iup.Message('错误','输入文件夹为空')

	elseif outprefix == '' then
		iup.Message('错误','输入文件夹为空')
	end
		local p = dstPath .. pOutputPath .. '/' .. pOutputFilePrefix
		local outdir = dstPath .. pOutputPath
		p =string.gsub(p,'[/]','\\')
		outdir =string.gsub(outdir,'[/]','\\')
		os.execute('del /s ' .. p .. '*' .. file_type[pFileType + 1])
		os.execute('del /s ' .. p .. '*.imageset')
		--os.execute()
		--os.execute('del /s ' .. dstPath .. pOutputPath .. '/' .. pOutputFilePrefix .. '*.imageset')

		local cmd = string.format('lua packCode/imagesetpacker.lua %s %d %d %s %s %s %s %d %s %d %s',
					file_type[pFileType + 1],
					size_table[pWidth + 1],
					size_table[pHeight + 1],
					srcPath .. pInputPath,
					dstPath .. pOutputPath,
					pOutputPath,
					pOutputFilePrefix,
					pSort,
					pboolean,
					pWebp,
					comporess_type[comporess_option+1]
					)
		print(cmd)
		os.execute(cmd)
		os.execute('lua packCode/buildTexturePath.lua')
		--os.execute('explorer ' .. outdir)

	DoPack(reset)
end

DoPack(true)
