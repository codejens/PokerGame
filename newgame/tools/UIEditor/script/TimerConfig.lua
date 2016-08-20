--将Timer的间隔写在这里Debug用
t_gsm_ = 0.01  		--GameStateManager:init
t_pavtr_ = 0.011		--PlayerAvatar:__init( handle )
t_ppet_ = 0.012		--PlayerPet:__init( handle )
t_jstk_ = 0.013		--create_joystick()
t_petai_ = 1.0 		--PetAI:start_ai
t_aimgr_ = 0.7   		--AIManager:init()
t_mmdl_ = 1			--MallModel:set_limit_time( limit_time )
t_tyb_  = 5 * 60 	--FubenCenterModel:did_enter_tianyuan_battle(  )
					--function FubenCenterModel:destory_message_dialog(  )
t_cnt_  = 1			--start_game( pack )
					--ShangJinBuffView:__init(  )
t_entdialog_ = 5    --EntityDialog:init_with_str( parent,str )
					--MiniBtnWin:move_btn()
					--function Msg:show(str)
					--ProcessBar:init_with_arg(time)
t_qtb_		= 3		--QuestTeleportDialog:show(quest_id,quest_type)
					--SlotSkill:play_skill_cd_animation( cooltime ,skill_id )
t_xsyd0     = 0.013 --新手指引缩小框时间
t_xsyd1     = 5.0   --新手指引开启新系统的动画时间
t_xsydblind = 0.5   --新手指引闪烁框间隔时间
t_screen_icon = 0.5 --主屏弹出图片聊字
t_attr_speed = 0.2  --主角属性变化时播放动画的间隔时间
t_entity_destroy = 1.5 --怪物淡出时间
t_getItem     = 2.5 -- 飘道具的特效时间
t_talk_duration = 5 -- 剧情动画中怪物对话的时间
t_ride_a_mount = 1 	-- SceneManager:do_touch_began_event()

t_weather     = 0.21