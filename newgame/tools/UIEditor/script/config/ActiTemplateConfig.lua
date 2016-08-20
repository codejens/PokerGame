-- ActiTemplateConfig.lua
-- created by chj on 2015.2.11
-- 活动公共模板配置管理文件


ActiTemplateConfig = {}

function ActiTemplateConfig:get_actitemplate_conf()
	require "../data/activity_config/acti_template/acti_template_conf"
	return acti_template_conf
end

function ActiTemplateConfig:get_maindata_conf( )
	require "../data/activity_config/acti_template/acti_template_conf"
	return acti_template_conf.main_conf
end

-- 获取各个活动的配置文件 not use
-- function ActiTemplateConfig:get_activity_conf( conf_name )
-- 	require "../data/activity_config/acti_template/acti_test_conf"
--     return nil
-- end