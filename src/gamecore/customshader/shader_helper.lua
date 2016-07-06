-----------------------------------------------------------------------------
-- 自定义着色器GLProgramState生成帮助类
-- @author haiming
-- @release 1
-----------------------------------------------------------------------------

require 'gamecore.customshader.shader_customdefault'

shader_helper = {}

--- 初始化
function shader_helper.init()
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_highlightPow', shader_highlightPow.vert, shader_highlightPow.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_highlightAdd', shader_highlightAdd.vert, shader_highlightAdd.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_highlightMult', shader_highlightMult.vert, shader_highlightMult.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_inverse', shader_inverse.vert, shader_inverse.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_normal', shader_normal.vert, shader_normal.frag) 
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_bloom', shader_bloom.vert, shader_bloom.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_blur', shader_blur.vert, shader_blur.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_edgeDetection', shader_edgeDetection.vert, shader_edgeDetection.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_outLine', shader_outLine.vert, shader_outLine.frag)
	helpers.CustomGLProgramCache:getInstance():addGLProgram('cs_AdjustHSV', shader_AdjustHVS.vert, shader_AdjustHVS.frag)
end

function shader_helper.checkVec2(Value, default)
	if Value ~= nil  then
		if type(Value) == 'table' and Value.x ~= nil and Value.y ~= nil then
			return Value
		else
			print('Shader input argument Error!')
			return default
		end
	else
		return default
	end
end

function shader_helper.checkVec3(Value, default)
	if Value ~= nil  then
		if type(Value) == 'table' and Value.x ~= nil and Value.y ~= nil  and Value.z ~= nil then
			return Value
		else
			print('Shader input argument Error!')
			return default
		end
	else
		
		return default
	end
end

function shader_helper.checkVec4(Value, default)
	if Value ~= nil  then
		if type(Value) == 'table' and Value.x ~= nil and Value.y ~= nil  and Value.z ~= nil and Value.w ~= nil then
			return Value
		else
			print('Shader input argument Error!')
			return default
		end
	else
		return default
	end
end

--- 高亮 采用指数操作
-- @param indencity (cc.vec4(r,g,b,a)) 每个通道使用的调节参数
function shader_helper.HighLightPow(indencity)
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_highlightPow"))
	glProgramState:setUniformVec4("u_intensity", shader_helper.checkVec4(indencity, cc.vec4(0.5,0.5,0.5,1.0)))
	return glProgramState
end

--- 高亮 采用相加操作
-- @param baseColor (cc.vec4(r,g,b,a)) 每个通道叠加值
function shader_helper.HighLightAdd( baseColor )
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_highlightAdd"))
	glProgramState:setUniformVec4("u_baseColor", shader_helper.checkVec4(baseColor, cc.vec4(0.5, 0.5, 0.5, 0)))
	return glProgramState
end

--- 高亮 采用相乘操作
-- @param multColor (cc.vec4(r,g,b,a)) 每个通道相乘值
function shader_helper.HighLightMult( multColor )
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_highlightMult"))
	glProgramState:setUniformVec4("u_multColor", shader_helper.checkVec4(multColor, cc.vec4(0.5, 0.5, 0.5, 0.0)))
	return glProgramState
end

--- 颜色反转
function shader_helper.Inverse( )
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_inverse"))
	return glProgramState
end

--- 使用法线贴图
-- @param normalFile 	法线贴图文件(string) 需要对法线贴图进行管理
-- @param lightPos 		光源的位置(cc.vec4(x,y,z,w)))
-- @param contentSize 	纹理的大小(cc.p(x,y))
-- @param u_diffuseL	散色光的颜色(cc.vec3(x,y,z))
function shader_helper.Normal(normalFile, lightPos, contentSize, u_diffuseL)
	local texNormal = cc.Director:getInstance():getTextureCache():addImage(normalFile)

	if texNormal ~= nil then
		local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_normal"))
		glProgramState:setUniformTexture("u_normalMap", texNormal)
		glProgramState:setUniformVec4("u_lightPosInLocalSpace", shader_helper.checkVec4(lightPos, cc.vec4(0.5, 0.5, 0.5, 0.0)))
		glProgramState:setUniformVec2("u_contentSize", shader_helper.checkVec2(contentSize, cc.p(0.5, 0.5)))
		glProgramState:setUniformVec3("u_diffuseL", shader_helper.checkVec3(u_diffuseL, cc.vec3(1, 1, 1)))
		return glProgramState
	end

	return nil
end

-- 发亮
function shader_helper.Bloom( )
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_bloom"))
	return glProgramState
end

-- 模糊
-- @param contentSize 纹理的大小（cc.p(x,y)）
-- @param blurRadius  模糊的半径，像素点（float)
-- @param sampleNum   采样数(float)
function shader_helper.Blur( contentSize, blurRadius, sampleNum )
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_blur"))
	glProgramState:setUniformVec2("u_contentSize", shader_helper.checkVec2(contentSize, cc.p(200, 200)))
	glProgramState:setUniformFloat("u_blurRadius", blurRadius or 3)
	glProgramState:setUniformFloat("u_sampleNum", sampleNum or 3)
	return glProgramState
end

-- 边缘检测
-- @param contentSize 使用的纹理的大小（cc.p(x,y))
function shader_helper.EdgeDetection( contentSize )
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_edgeDetection"))
	glProgramState:setUniformVec2("u_contentSize", shader_helper.checkVec2(contentSize, cc.p(200, 200)))
	return glProgramState
end

-- 描绘轮廓
-- @param vec3OutLineColor 	轮廓的颜色（cc.vec3(x,y,z))
-- @param thredhold			阈值
-- @param radius 			半径
function shader_helper.OutLine( vec3OutLineColor, threshold, radius )
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_outLine"))
	glProgramState:setUniformVec3("u_outlineColor", shader_helper.checkVec3(vec3OutLineColor, cc.vec3(1, 0, 0)))
	glProgramState:setUniformFloat("u_threshold", threshold or 5.0)
	glProgramState:setUniformFloat("u_radius", radius or 0.01)
	return glProgramState
end

-- 调整色相，饱和度和亮度
-- @param HugeOffset 色相偏移（红色为0°，绿色为120°,蓝色为240°）
-- @param Saturation 饱和度调整值（0.1即为增加10%）
-- @param VaLude 	 亮度调整值 （0.1即为增加10%）
function shader_helper.AdjustHSV( HugeOffset , Saturation, Valude)
	local glProgramState = cc.GLProgramState:create(helpers.CustomGLProgramCache:getInstance():getGLProgram("cs_AdjustHSV"))
	glProgramState:setUniformFloat("u_HugeOffset", HugeOffset or 0)
	glProgramState:setUniformFloat("u_SaturationPer", Saturation or 0)
	glProgramState:setUniformFloat("u_ValuePer", Valude or 0)
	return glProgramState
end