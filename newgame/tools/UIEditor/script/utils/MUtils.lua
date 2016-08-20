-- MUtils
-- create by hcl on 2012-12-24
-- 帮助类
ZXLog('MUtils loaded')

local _refWidth =  UIScreenPos.relativeWidth
local _refHeight = UIScreenPos.relativeHeight

super_class.MUtils();

-- 根据策划的坐标计算出程序的坐标，策划给的坐标是锚点(0,1.0)的坐标
function MUtils:calculate_cpp(x,y,width,height,anchor_x,anchor_y)
	if(anchor_x == nil) then 
		anchor_x = 0.5;
	end
	if(anchor_y == nil) then 
		anchor_y = 0.5;
	end
	-- 策划的高度上面是0，程序的高度下面是0
	local new_x = x + width * anchor_x;
	local new_y = ( SCREEN_HEIGHT - y ) - height * (1.0 - anchor_y );

	return new_x,new_y;
end

-- 根据策划的坐标计算出程序的坐标，策划给的坐标是锚点(0.5,0.5)的坐标
function  MUtils:calculate_cpp2(x,y,width,height,anchor_x,anchor_y)
	if(anchor_x == nil) then 
		anchor_x = 0.5;
	end
	if(anchor_y == nil) then 
		anchor_y = 0.5;
	end
	-- 策划的高度上面是0，程序的高度下面是0
	local new_x = x + width * (anchor_x - 0.5);
	local new_y = ( SCREEN_HEIGHT - y ) - height * (0.5 - anchor_y );

	return new_x,new_y;
end

-- 创建label
-- function MUtils:create_label(parent,str,font_name,font_size,pos_x,pos_y,color,anchor_point,z)

--     local lab = CCLabelTTF:labelWithString(str,font_name,font_size);
--     if(color == nil) then
--         color = ccc3(0,0,0);
--     end
--     if(anchor_point ~= nil) then
--         lab:setAnchorPoint(anchor_point);
--     end
--     lab:setPosition(CCPoint(pos_x,pos_y));
--     lab:setColor(color);
--       if(z == nil) then 
--         z = 0;
--     end
--     parent:addChild(lab,z);
--     return lab;
-- end

-- 创建label
function MUtils:create_label_with_size(parent,str,font_name,font_size,dimensions,alignment,pos_x,pos_y,color,anchor_point,z)

    --local str = "#cffffff都看得见id付款#cff00ff"
    local lab = CCLabelTTF:labelWithString(str,dimensions,alignment,font_name,font_size);
    if(color == nil) then
        color = ccc3(0,0,0);
    end
    if(anchor_point ~= nil) then
        lab:setAnchorPoint(anchor_point);
    end
    lab:setColor(color);
    lab:setPosition(CCPoint(pos_x,pos_y));
    if(z == nil) then 
        z = 0;
    end
    parent:addChild(lab,z);
    return lab;
end
-- aligntype 
--    ALIGN_LEFT = 1,
--    ALIGN_CENTER = 2,
--    ALIGN_RIGHT = 3,
function MUtils:create_zxfont(parent,str,pos_x,pos_y,aligntype,fontsize,z)
    local lab = nil;
    if ( aligntype == nil or fontsize == nil) then
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str);
    else
        lab = CCZXLabel:labelWithText(pos_x,pos_y,str, fontsize,aligntype);
    end
    if(z == nil) then 
        z = 0;
    end
    parent:addChild(lab,z);
    return lab;
end


-- 创建sprite
function MUtils:create_sprite(parent,filepath,pos_x,pos_y,z)
    -- print('MUtils:create_sprite',filepath)
    local spr = CCSprite:spriteWithFile(filepath);
    spr:setPosition(pos_x,pos_y);
    if( z == nil ) then 
        z = 0;
    end
    parent:addChild(spr,z);
    return spr;
end

-- 创建ZXImage
function MUtils:create_zximg(parent,filepath,pos_x,pos_y,width,height,coner_w,coner_h,z,tag)

    if ( coner_w == nil or coner_h == nil) then
        coner_w = 500;
        coner_h = 500;
    end 

	local zximg = CCZXImage:imageWithFile(pos_x,pos_y,width,height,filepath,coner_w,coner_h); 
    if(z == nil) then 
        z = 0;
    end
    if ( tag ) then
        parent:addChild(zximg,z,tag);
    else
        parent:addChild(zximg,z);
    end
	
	return zximg;
end

function MUtils:create_zximg3(parent,filepath,pos_x,pos_y,z,tag)
    local zximg = CCZXImage:imageWithFile(pos_x,pos_y,-1,-1,filepath); 
    if(z == nil) then 
        z = 0;
    end
    if ( tag ) then
        parent:addChild(zximg,z,tag);
    else
        parent:addChild(zximg,z);
    end
    
    return zximg;
end

-- 创建ZXImage
function MUtils:create_zximg2(parent,filepath,pos_x,pos_y,width,height,topleftw,toplefth,toprightw,toprighth,bottomleftw,bottomlefth,bottomrightw,bottomrighth,z)

 
    local zximg = CCZXImage:imageWithFile(pos_x,pos_y,width,height,filepath,topleftw,toplefth,toprightw,toprighth,bottomleftw,bottomlefth,bottomrightw,bottomrighth); 
      if(z == nil) then 
        z = 0;
    end
    parent:addChild(zximg,z);
    return zximg;
end

-- 创建按钮
function MUtils:create_btn(parent,filepath,selectedpath,func,pos_x,pos_y,width,height,z,lb_w,lb_h,rb_w,rb_h,lt_w,lt_h,rt_w,rt_h)
    local btn = nil;
    if (lb_w==nil or lb_h == nil) then
        btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,filepath);
    else
        btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,filepath,TYPE_MUL_TEX,lb_w,lb_h,rb_w,rb_h,lt_w,lt_h,rt_w,rt_h);
    end
    
    if (selectedpath) then
        btn:addTexWithFile(CLICK_STATE_DOWN,selectedpath);
    end
    -- if(func == nil) then
    --     func = function(eventType,x,y)
    --         if eventType == TOUCH_CLICK then
    --             --按钮抬起时处理事件.
    --             return true;
    --         end
    --     end
    -- end
    if ( func ) then
        btn:registerScriptHandler(func);
    end
    if(z == nil) then 
        z = 0;
    end
    parent:addChild(btn,z);
    return btn;
end

-- 创建通用按钮
function MUtils:create_common_btn( parent,str,func,pos_x,pos_y,z )
    -- 中文要除于3
    local str_len = string.len(str)/3;
    -- print("str_len = ",str_len);
    local btn = CCNGBtnMulTex:buttonWithFile( pos_x, pos_y, -1, -1,
        UIResourcePath.FileLocate.common.."button"..str_len..".png",
        TYPE_MUL_TEX);

    if ( func ) then
        btn:registerScriptHandler(func);
    end
    if(z == nil) then 
        z = 0;
    end
    parent:addChild(btn,z);

    local size = btn:getSize();
    local lab = MUtils:create_zxfont(btn,str,size.width/2,20,2,18);

    return btn,lab;
end

-- 创建一个双按钮 ，响应的是同一个事件
-- first_btn ： table，结构 { file, x, y, w, h}
function MUtils:create_double_btn( parent, first_btn, second_btn, func, x, y, w, h )
    
    local panel = CCBasePanel:panelWithFile(x,y,w,h,"");
    parent:addChild(panel);

    local f_btn = MUtils:create_btn(panel, first_btn.file, first_btn.file, func, first_btn.x, first_btn.y, first_btn.w, first_btn.h);

    local s_btn = MUtils:create_btn(panel, second_btn.file, second_btn.file, func, second_btn.x, second_btn.y, second_btn.w, second_btn.h);

    return panel;
end

-- 创建按钮和按钮上的文字
function MUtils:create_btn_and_lab(parent,filepath,selectedpath,func,pos_x,pos_y,width,height,lab_str,lab_size,z)
    local btn = CCNGBtnMulTex:buttonWithFile(pos_x,pos_y,width,height,filepath);
    btn:addTexWithFile(CLICK_STATE_DOWN,selectedpath);
    if(func == nil) then
        func = function(eventType,x,y)
            if eventType == TOUCH_CLICK then
                --按钮抬起时处理事件.
                return true;
            end
        end

    end
    btn :registerScriptHandler(func);
    if(z == nil) then 
        z = 0;
    end
    parent:addChild(btn,z);

    if ( lab_size == nil ) then
        lab_size = 16;
    end
    local size = btn:getSize()
    local lab = MUtils:create_zxfont(btn,lab_str,size.width/2,size.height/2+lab_size/4,2,lab_size);
    lab:setAnchorPoint(CCPointMake(0,0.5))

    -- local lab = CCLabelTTF:labelWithString(lab_str,"Arial",lab_size);
    -- lab:setPosition(CCPoint(width/2,height/2));
    -- if(lab_color == nil) then 
    --     lab_color = ccc3(255,255,255);
    -- end
    -- lab:setColor(lab_color);
    --btn:addChild(lab);


    return btn,lab;
end

-- 创建带有背景的lab
function MUtils:create_lab_with_bg(parent,str,aligntype,font_size,pos_x,pos_y,bg_path,bg_width,z)

    local spr = CCSprite:spriteWithFile(bg_path);
    if ( bg_width == nil) then
        spr:setPosition(CCPoint(pos_x - 5,pos_y + 5));
        spr:setAnchorPoint(CCPoint(0,0.5));
    else
        spr:setPosition(CCPoint(pos_x,pos_y + 5));
    end
        
    parent:addChild(spr);

    if(z == nil) then 
        z = 0;
    end

    local lab = MUtils:create_zxfont(parent,str,pos_x,pos_y,aligntype,font_size,z);

    return lab,spr;
end

-- 创建RadioButton    -- CCTextAlignmentLeft
function MUtils:create_radio_button(parent,path,select_path,func,pos_x,pos_y,width,height,is_select)
    local radio_button = CCRadioButton:radioButtonWithFile(pos_x,pos_y,width,height,path);
    if(func == nil) then
        -- func = function(eventType,x,y)
        --    if eventType == TOUCH_CLICK then
        --         --按钮抬起时处理事件.
        --         return true;
        -- RadioButton必须要注册TOUCH_BEGAN和TOUCH_ENDED
        --    elseif eventType == TOUCH_BEGAN then
        --        return true;
        --    elseif eventType == TOUCH_ENDED then
        --        return true;
        --    end
        -- end
    else
        radio_button:registerScriptHandler(func);
    end
    
    radio_button:addTexWithFile(CLICK_STATE_DOWN,select_path);
    parent:addGroup(radio_button);
    return radio_button;
end

-- 计算点击的是第几个按钮
function MUtils:get_click_btn_index(arg,left_margin,top_margin,width,height,line_btn_num)
    if  arg == nil  then
         return -1;
    end
    require "utils/Utils"
    local temparg = Utils:Split(arg,":")
    local x = tonumber(temparg[1]);
    local y = tonumber(temparg[2]);
    -- 计算当前点击的是第几个按钮
    print ("MUtils:x = "..x .. "y = " .. y,top_margin);
    --MUtils:get_click_btn_index(eventType,arg,msgid,44-l_m,356,160,70,1);
    local line =  math.floor( (top_margin - y)/height );
    -- print("line = ",line,top_margin,height);
    local index = line * line_btn_num + math.floor((x - left_margin)/width) + 1;
    
    --index = math.min(index,line_btn_num);
    index = math.max(1,index);

    print ("当前点击第" .. index .. "个按钮");
    return index;
end


-- 创建ccdialogEx
function MUtils:create_ccdialogEx(parent,str,pos_x,pos_y,width,height,max_num,font_size,z,add_list_dir_direction)
    if ( add_list_dir_direction == nil ) then
        add_list_dir_direction = ADD_LIST_DIR_UP;
    end
    local dialog = CCDialogEx:dialogWithFile(pos_x, pos_y, width, height, max_num,"",1,add_list_dir_direction);
    --dialog:setAnchorPoint(0,1)
    if ( font_size ) then
        dialog:setFontSize(font_size);
    end
    dialog:setText(str);
    if ( z == nil) then
        z = 0;
    end
    parent:addChild(dialog,z);
    return dialog;
end

-- 创建TextButton
function MUtils:create_text_btn(parent,str,pos_x,pos_y,width,height,func,_font_size)
    local text_btn = CCTextButton:textButtonWithFile(pos_x, pos_y, width, height, str, "");
    --text_btn:setAnchorPoint(0,0);
    parent:addChild(text_btn);
    local font_size = 16;
    if ( _font_size  ) then
        font_size = _font_size;
    end
    text_btn:setFontSize(font_size);
    text_btn:registerScriptHandler(func);
    return text_btn;
end

-- 创建SlotItem
function MUtils:create_slot_item(parent,bg_path,pos_x,pos_y,width,height,item_id,fun)
    local slot_width  = 64
    local slot_height = 64
    local slotItem = SlotItem(slot_width, slot_height)               --创建slotitem
    if ( bg_path ) then
        local posx = (slot_width - width - 4) / 2
        local posy = (slot_height - height - 4) / 2
        if width == 72 then
            posx, posy = -4, -4
        elseif width == 81 then
            posx, posy = -8, -8
        end
        slotItem:set_icon_bg_texture( bg_path, posx, posy, width, height )   -- 背框
    end
    if ( item_id ) then 
        -- print("item_id",item_id);
        slotItem:set_icon( item_id )
        if width == 72 then
            slotItem:set_color_frame(item_id, -2, -2, 68, 68);
        else
            slotItem:set_color_frame(item_id)
        end
    end
    slotItem:set_item_count(1);
    slotItem:setPosition( pos_x + (width - slot_width) / 2, pos_y + (height - slot_height) / 2)

    if ( fun == nil  ) then
        --设置回调单击函数
        local function f1( ... )
            if ( item_id ) then 
                local a, b, arg = ...
                local click_pos = Utils:Split(arg, ":")
                local world_pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                TipsModel:show_shop_tip( world_pos.x, world_pos.y, item_id );
            end
            
        end
        slotItem:set_click_event( f1 )
    else
        slotItem:set_click_event( fun )
    end

    parent:addChild(slotItem.view);
    return slotItem;
end

-- 创建SlotItem
function MUtils:create_slot_item2(parent,bg_path,pos_x,pos_y,width,height,item_id,fun,icon_offset)
    --local icon_offset=2
    if(icon_offset==nil) then
        icon_offset=0
        --print("icon_offset call")
    end
    local slot_width  = width
    local slot_height = height
    local bg_rect=CCRect(-icon_offset, -icon_offset, slot_width+icon_offset*2, height+icon_offset*2)
    local slotItem = SlotItem(slot_width, slot_height)               --创建slotitem
    if ( bg_path ) then
        -- local posx = (slot_width - width - 4) / 2
        -- local posy = (slot_height - height - 4) / 2
        -- if width == 72 then
        --     posx, posy = -4, -4
        -- end
        slotItem:set_icon_bg_texture( bg_path, bg_rect.origin.x, bg_rect.origin.y, bg_rect.size.width, bg_rect.size.height )   -- 背框
    end
    if ( item_id ) then 
        -- print("item_id",item_id);
        slotItem:set_icon( item_id )
        --if width == 72 then
            slotItem:set_color_frame(item_id, bg_rect.origin.x, bg_rect.origin.x, bg_rect.size.width, bg_rect.size.height);
        --else
            --slotItem:set_color_frame(item_id)
        --end
    end
    slotItem:set_item_count(1);
    slotItem:setPosition( pos_x, pos_y)

    if ( fun == nil  ) then
        --设置回调单击函数
        local function f1( ... )
            if ( item_id ) then 
                local a, b, arg = ...
                local click_pos = Utils:Split(arg, ":")
                local world_pos = slotItem.view:getParent():convertToWorldSpace( CCPointMake( tonumber(click_pos[1]),tonumber(click_pos[2]) ) )
                TipsModel:show_shop_tip( world_pos.x, world_pos.y, item_id );
            end
            
        end
        slotItem:set_click_event( f1 )
    else
        slotItem:set_click_event( fun )
    end

    parent:addChild(slotItem.view);
    return slotItem;
end


-- 创建SlotSkill
function MUtils:create_pet_slot_skill(parent,bg_path,pos_x,pos_y,width,height,skill_id,skill_lv,fun)

    local pet_slot_skill = SlotPetSkill(width, height)             --创建slotitem
    if ( bg_path ) then
        pet_slot_skill:set_icon_bg_texture( bg_path,(width-72)/2 , (height-71)/2,72,71 )   -- 背框
    end
    if ( skill_id and skill_lv ) then 
        pet_slot_skill:set_pet_skill_icon( skill_id,skill_lv ) 
    end
    pet_slot_skill:setPosition( pos_x - (72 - width)/2, pos_y - (71 - height)/2 )

    if ( fun == nil  ) then

    else
        pet_slot_skill:set_click_event( fun )
    end

    parent:addChild(pet_slot_skill.view);
    return pet_slot_skill;
end

-- 创建SlotSkill,由于pet_item有新需求，如果改原函数的话又没空去改所有的引用，所以只能新开一个来开
function MUtils:create_pet_slot_skill2(parent,bg_path,pos_x,pos_y,width,height,skill_id,skill_lv,fun,bg_width,bg_height)
    bg_width = bg_width or 80
    bg_height = bg_height or 80
    local pet_slot_skill = SlotPetSkill(width, height)             --创建slotitem
    if ( bg_path ) then
        pet_slot_skill:set_icon_bg_texture( bg_path,(width-bg_width)/2 , (height-bg_height)/2,bg_width,bg_height )   -- 背框
    end
    if ( skill_id and skill_lv ) then 
        pet_slot_skill:set_pet_skill_icon( skill_id,skill_lv ) 
    end
    pet_slot_skill:setPosition( pos_x - (bg_width - width)/2, pos_y - (bg_height - height)/2 )

    if ( fun == nil  ) then

    else
        pet_slot_skill:set_click_event( fun )
    end

    parent:addChild(pet_slot_skill.view);
    return pet_slot_skill;
end

-- 创建其他的slotitem(目前：金钱，经验，真气~~)
-- （由对话窗口-NPCDialog，一过来更改）
local awards_img = {
    [1]     = "nopack/task/zhenqi.png",
    [2]     = "nopack/task/exp.png",
    [3]     = "nopack/task/guild_jl_1.png", 
    [5]     = "nopack/task/tongbi.png", 
    [6]     = "nopack/task/tongbi.png",
    [14]    = "nopack/task/guild_jl_2.png", 
    [999]   = "icon/money/1.pd"}
function MUtils:create_value_slot_item(parent, bg, x, y)
    local slot_item = MUtils:create_slot_item( parent, bg, x, y, 83, 83, nil);
    slot_item:set_icon_bg_texture( bg, -9, -9, 83, 83 )   -- 背框
    function slot_item:set_icon_and_num(type, path_index, count)
        if type == 1 then
            local icon = awards_img[path_index] or ""
            slot_item:set_icon_texture(icon);
            slot_item:set_item_count(count)
        end
    end
    return slot_item
end


local loadingAnimations = {}
function MUtils:create_animation(x,y,fileName,action, anim_pos )
    -- print('MUtils:create_animation',fileName)
    anim_pos = anim_pos or 30
    local animationSprite = CCBasePanel:panelWithFile(x,y,0,0,""); 
    animationSprite:setAnchorPoint(0.5,0);
    if fileName == nil or fileName == '' then
        return animationSprite
    end
    --retain
    safe_retain(animationSprite)

    local loading = nil
    if not loading then
        require 'UI/component/ProgressImg'
        loading = ProgressImg('nopack/circle_load.png')
        loading.view:setPosition(CCPoint(0,anim_pos))
        loading.view:setScale(0.5)
    end

    animationSprite:addChild(loading.view);
    ResourceManager.AnimationBackgroudnLoad(fileName, 
        function(_filename)
            if not _filename or animationSprite:retainCount() == 1 then
                --释放loading
                -- if loading.view then
                --     loading.view:removeFromParentAndCleanup(true)
                -- end 
                loading:destory()
                --release parent
                safe_release(animationSprite)
                return
            end
            loading.view:removeFromParentAndCleanup(true)
            loading:destory()
            local animation = ZXAnimation:createWithFileName(fileName)
            --local defAction = ZXAnimation:createAnimationAction(action[1],action[2],action[3],action[4])
            animation:replaceZXAnimationAction(action[1],action[2],action[3],action[4])
            animation:setDefaultAction(action[1]);
            
            local pet_sprite = ZXAnimateSprite:createWithFileAndAnimation("",animation)
            animationSprite:addChild(pet_sprite);
            safe_release(animationSprite)
        end)
    return animationSprite;
end





function MUtils:creat_mutable_btn( x,y,frame_1,img_1,frame_2,img_2,func)
    
    local max_h =0;
    if frame_1.h > frame_2.h then
        max_h = frame_1.h;
    else
        max_h = frame_2.h;
    end
    local max_w = frame_1.w+frame_2.w;

    local question_btn = CCNGBtnMulTex:buttonWithFile(x, y, max_w, max_h, "");
    question_btn:addTexWithFile(CLICK_STATE_DOWN,"")
    question_btn:registerScriptHandler(func);
    
    local image_1 = CCZXImage:imageWithFile(frame_1.x,frame_1.y,frame_1.w,frame_1.h,img_1);
    question_btn:addChild(image_1);
    
    local image_2 = CCZXImage:imageWithFile(frame_2.x,frame_2.y,frame_2.w,frame_2.h,img_2);
    question_btn:addChild(image_2);

    return question_btn;
end

-- 创建测试用的宠物动画
function MUtils:create_test_pet_animation(parent,pos_x,pos_y)
    local action  = ZXLuaUtils:createAnimate("frame/pet/2",9);
    local spr = ZXLuaUtils:createAnimateSprite("frame/pet/2/00000.png");
    spr:setPosition(pos_x,pos_y);
    spr:runAction(action);
    parent:addChild(spr);
    return spr
end

function MUtils:get_zhenying_name(zhenying_index)
    return Lang.camp_info[zhenying_index];
end

function MUtils:get_sex_str( sex_index ) 
    if ( sex_index == GameConfig.SEX_MALE ) then
        return LangGameString[91]; -- [91]="男"
    elseif ( sex_index == GameConfig.SEX_FEMALE ) then
        return LangGameString[92]; -- [92]="女"
    end
end

-- by : lyl
-- 创建 星星序列  最多五个。最少一个  根据数量不同，颜色也不同
-- 参数： 加入的面板  坐标和单个星星的大小 ， num 星星的数量
function MUtils:create_star_range( fath_panel, x, y, w, h, num )
    local star_range = {}    -- 返回的星星序列对象
    local star_t     = {}    -- 记录所有星星图片，重建时删除
    local star_interval = 0  -- 星星间的间隔
    
    -- 每种数量对应的颜色星星
    local star_path_t = { [1] = UILH_NORMAL.star, 
                          [2] = UILH_NORMAL.star, 
                          [3] = UILH_NORMAL.star, 
                          [4] = UILH_NORMAL.star,
                          [5] = UILH_NORMAL.star, }
    
    -- 创建星星序列
    local function create_star( num )
        local count = num
        if count > 5 then
            count = 5
        end
        for i = 1, count do
            local star_image = CCZXImage:imageWithFile( x + (w + star_interval) * ( i - 1), y, w, h, UILH_NORMAL.star )
            --star_image:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
            table.insert( star_t, star_image )
            fath_panel:addChild( star_image )
        end
    end

    -- 删除所有星星
    local function remove_all_star(  )
        for key, star in pairs(star_t) do
            fath_panel:removeChild( star, true )
        end
        star_t = {}
    end

    -- 改变星星数量
    star_range.change_star_num = function( num )
        remove_all_star(  )
        create_star( num )
    end

    -- 改变星星的间隔
    star_range.change_star_interval = function ( star_interval_x )
        star_interval = star_interval_x
        remove_all_star(  )
        create_star( num )
    end

    -- 改变星星的位置
    star_range.setPosition = function( x, y )
        for i,v in ipairs(star_t) do
            v:setPosition(x + (w + star_interval) * ( i - 1), y)
        end
    end

    create_star( num )

    return star_range
end


-- 绘制 没有颜色差别的星星，黄色
function MUtils:drawStart(start_layer,start_count)
    -- 清楚所有星星
    start_layer:removeAllChildrenWithCleanup(true);
    for i=0,9 do
        local star = CCZXImage:imageWithFile(25*i,8,22,22,UIResourcePath.FileLocate.common .. "star_big.png");
        --star:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
        star:setTag(i);
        start_layer:addChild(star);
        if i>(start_count-1) then 
            --star:setTexture("ui/common/star_gray.png")
            star:setCurState(CLICK_STATE_DISABLE);
        end
    end
end

-- 画星处理，面板较大型(翅膀)
function MUtils:drawStart2(start_layer,start_count)
    -- 清楚所有星星
    start_layer:removeAllChildrenWithCleanup(true);
    for i=0,9 do
        local star = CCZXImage:imageWithFile( 55*i, 0, -1, -1, UILH_NORMAL.star );
        --star:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
        star:setTag(i);
        start_layer:addChild(star);
        if i>(start_count-1) then 
            --star:setTexture("ui/common/star_gray.png")
            star:setCurState(CLICK_STATE_DISABLE);
        end
    end
end

-- 绘制5颗星，玩法大厅副本用
function MUtils:drawStart3(start_layer,start_count)
    -- 清楚所有星星
    start_layer:removeAllChildrenWithCleanup(true);
    for i=0,4 do
        local star = CCZXImage:imageWithFile( 35*i, 8, 30, 30, UILH_NORMAL.star );
        --star:addTexWithFile(CLICK_STATE_DISABLE, "ui/common/star_gray.png")
        star:setScale(1)
        star:setTag(i);
        start_layer:addChild(star);
        if i>(start_count-1) then 
            --star:setTexture("ui/common/star_gray.png")
            star:setCurState(CLICK_STATE_DISABLE);
        end
    end
end



-- =========================================
-- 数字输入控件  by: lyl
-- 参数： x, y 坐标  w,h 宽高  
-- max_num 最大数字，可以不填，默认为999
-- num_change_cb: 数字改变时的回调函数, 可以为nil
-- texture_name: 数字输入控件的背景图，可以为nil，当为nil时，取"bg06.png"
-- =========================================
function MUtils:create_num_edit( x, y, w, h, max_num, num_change_cb, texture_name, alignment )
    local num_edit = {}             -- 数字编辑框对象
    local bg_name = UIResourcePath.FileLocate.common .. "wzk-2.png"
    if texture_name ~= nil then
        bg_name = texture_name
    end
    num_edit.view = CCBasePanel:panelWithFile( x, y, w, h, bg_name, 500, 500 )   -- 背景

    num_edit.max_num = max_num or 999           -- 最大数字
    num_edit.num_change_cb = num_change_cb
    -----
    num_edit.is_active_zero = false

    -- 输入框中数字
    num_edit.num = 0
    alignment = alignment or ALIGN_CENTER;
    local num_lable = UILabel:create_lable_2( 0, w / 2, 2, 16, alignment )
    num_edit.view:addChild( num_lable )
    num_edit.label = num_lable
    -- 更新数字
    local function udpate_num( num )
        num_edit.num = num
        num_lable:setString( tostring(num) )
        if num_edit.num_change_cb then
            num_edit.num_change_cb( num_edit.num )
         end
    end
    
    -- 点击背景，弹出数字键盘
    local function enter_frame_fun(eventType,x,y)
        if eventType == TOUCH_CLICK then
            require "UI/common/BuyKeyboardWin"
            local function enter_num_call_back( num )
                udpate_num( num )
            end
            BuyKeyboardWin:show( nil, enter_num_call_back, 8, num_edit.max_num, {LangGameString[2297]}, num_edit.is_active_zero ) -- [2297]="输入数字"
            return false 
        end
        return true
    end
    num_edit.view:registerScriptHandler( enter_frame_fun ) 

    -- 提供方法，获取输入框数字
    num_edit.get_num = function(  )
        return num_edit.num
    end

    -- 提供方法，设置输入框中的数字
    num_edit.set_num = function( num )
        udpate_num( num )
    end

    -- 设置数字，但是不触发消息
    num_edit.set_num_not_do_cb = function( num )
        num_edit.num = num
        num_lable:setString( tostring(num) )
    end 

    -- 提供方法，设置输入框最大值
    num_edit.set_max_num = function( max_num )
        num_edit.max_num = max_num or num_edit.max_num
        if num_edit.num > num_edit.max_num then
            udpate_num( num_edit.max_num )
        end
    end

    return num_edit
end

-- ===========================================
-- 进度条（同样适用血量、经验等）      by lyl
-- x, y, w, h  整个进度条的坐标 ，宽高
-- image_bg： 进度条背景图片路径
-- image_front： 进度条显示
-- max_value： 最大值
-- font_info: table类型，文字显示的参数：size  color     （注意要按顺序）
-- margin_t : table类型，前面显示条，与 左 右 上 下 的距离(注意要按顺序) ,  可以为nil
-- if_show_value: 是否显示数值
-- ===========================================
function MUtils:create_progress_bar( x, y, w, h, image_bg, image_front, max_value, font_info, margin_t, if_show_value )
    local progress_bar = {}                      -- 进度条对象
    progress_bar.view = CCZXImage:imageWithFile( x, y, w, h, image_bg, 500, 500 )           -- 进度条背景
    progress_bar.max_value = max_value or 100           -- 表示的最大值
    progress_bar.current_value = max_value or 100       -- 当前值
    progress_bar.if_show_value = if_show_value          -- 是否显示数值

    -- 计算各种边距, 显示前部的条
    margin_t = margin_t or {}           -- 边距
    local margin_left    = margin_t[1] or 2
    local margin_right   = margin_t[2] or 2
    local margin_top     = margin_t[3] or 2
    local margin_bottom  = margin_t[4] or 2
    local image_front = CCZXImage:imageWithFile( margin_left, margin_bottom, w - margin_left - margin_right, h - margin_bottom - margin_top, image_front, 500, 500 )
    progress_bar.view:addChild( image_front )

    -- 数值显示
    local font_size  = font_info[1] or 16
    local font_color = font_info[2] or ""
    local value_lable = UILabel:create_lable_2( font_color..progress_bar.current_value.."/"..progress_bar.max_value, w / 2, margin_bottom, font_size, ALIGN_CENTER )
    progress_bar.view:addChild( value_lable )

    if not progress_bar.if_show_value then
        value_lable:setIsVisible( false )
    end

    -- 设置前部条的长度
    local function set_image_front_width(  )
        local percentage = progress_bar.current_value / progress_bar.max_value
        image_front:setSize( (w - margin_left - margin_right) * percentage, h - margin_bottom - margin_top )
    end

    -- 设置当前值 的方法
    progress_bar.set_current_value = function( value )
        -- if not progress_bar.if_show_value then
        --     return
        -- end
        if value > progress_bar.max_value then
            value = progress_bar.max_value
        elseif value < 0 then
            value = 0
        end
        progress_bar.current_value = value
        value_lable:setString( font_color..progress_bar.current_value.."/"..progress_bar.max_value )
        set_image_front_width(  )
    end

    -- 设置最大值 的方法
    progress_bar.set_max_value = function( max_value )
        -- if not progress_bar.if_show_value then
        --     return
        -- end
        if progress_bar.current_value > max_value then
            progress_bar.current_value = max_value
        elseif max_value < 0 then
            max_value = 0
        end
        progress_bar.max_value = max_value
        value_lable:setString( font_color..progress_bar.current_value.."/"..progress_bar.max_value )
        set_image_front_width(  )
    end

    return progress_bar
end

-- ================================================
-- 数值滑动条 中间有一个按钮的长条，控制数值   by lyl
-- x, y： 坐标
-- bar_image ： 背景长条的图片路径   bar_image_w, bar_image_h:  宽、高
-- but_image ： 按钮        but_image_w, but_image_h：按钮宽高
-- max_value ： 数字：最大值
-- callback_func： 生效时的回调函数
-- ================================================
function MUtils:create_value_move_bar( x, y, bar_image, bar_image_w, bar_image_h, but_image, but_image_w, but_image_h, max_value, callback_func )
    local value_move_bar = {}                   -- 数字滑动条对象
    local but_current_x  = 0                    -- 记录按钮当前的位置（相对滑动条区域的左下角）
    local but_pre_cb_x   = 0                    -- 按钮上一次相应位置, 这里是要控制每变化5%就回调一次，防止拖出区域以外才松开，没有end时间响应的情况
    local max_value = max_value or 1            -- 最大表示值
    
    -- 整个可响应区域的背景,  长度根据长调的 w 值，  高度根据 按钮的  h 值  ui/common/nine_grid_bg.png
    value_move_bar.view = CCBasePanel:panelWithFile( x, y, bar_image_w, but_image_h, "", 500, 500 )

    -- 长条
    local bg_bar_x = 0
    local bg_bar_y = (but_image_h - bar_image_h) / 2        -- 长条的位置居中
    local bg_bar = CCZXImage:imageWithFile( bg_bar_x, bg_bar_y, bar_image_w, bar_image_h, bar_image, 500, 500 )
    value_move_bar.view:addChild( bg_bar )

    -- 按钮
    local move_but = CCZXImage:imageWithFile( 0, 0, but_image_w, but_image_h, but_image, 500, 500 )
    value_move_bar.view:addChild( move_but )


    -- 计算当前值
    local function calulate_current_value(  )
        local percentage = but_current_x / (bar_image_w - but_image_w)
        local curr_value = percentage * max_value          -- 当前表示的值
        curr_value = math.floor(curr_value)
        return curr_value
    end

    -- 调用回调函数
    local callback_temp = callback:new()
    local function do_callback_func(  )
        callback_temp:cancel()
        local curr_value = calulate_current_value(  )
        but_pre_cb_x = but_current_x 

        -- 解决  “触点离开区域才放开的情况下，不会响应end事件” 的问题。但又不能平凡调用。所以用个callback
        local function callback_temp_func()
            if callback_func then
                callback_func( curr_value )
            end
        end
        -- 标记回调函数时，按钮的位置
        callback_temp:start( 0.3, callback_temp_func ) 
    end

    -- 设置按钮的位置
    local function set_but_position( pos_x )
        but_current_x = pos_x
        pos_x = pos_x - but_image_w / 2                    -- 点击处为按钮中心
        if pos_x > bar_image_w - but_image_w * 3 / 2 then          -- 控制按钮显示不超出滑动条
            pos_x = bar_image_w - but_image_w
            but_current_x = pos_x
        end
        if ( pos_x / (bar_image_w - but_image_w * 3 / 2) ) <= 0.05 then             -- 要控制为0的时候，不好拖动。 所以接近的时候，就设置为0
            pos_x = 0
            but_current_x = pos_x
        elseif ( pos_x / (bar_image_w - but_image_w * 3 / 2) ) >= 0.95 then
            pos_x = bar_image_w - but_image_w
            but_current_x = pos_x
        end
        move_but:setPosition( pos_x, 0 )

        -- 由于触点离开区域才放开的情况下，不会响应end事件，这里每百分之五回调一次函数
        -- todo !!!!!!!!!!!!!  这里是暂时测试，这样处理。以后panel要提供离开事件 
        if math.abs( but_pre_cb_x - pos_x ) / max_value > 0.1 then
            do_callback_func(  )
        end 
    end

    -- 触摸事件
    local pos_temp   = {}        -- 每次触发事件用到的变量
    local x_temp     = 0         
    local function touch_event_func( eventType, touch_x_y )
        -- 设置拖动按钮的位置
        if eventType == TOUCH_BEGAN or eventType == TOUCH_MOVED or eventType == TOUCH_ENDED then
            if not touch_x_y then                         -- 开始的时候会来两个nil值，避开
                return 
            end
            pos_temp = Utils:Split(touch_x_y,":")         -- 计算坐标
            x_temp = pos_temp[1]                          -- 点击事件发生的x坐标
            if tonumber(x_temp) ~= 0 then                 -- 放开的时候会返回一个0的坐标，这里把它避开
                set_but_position( tonumber(x_temp) - x )  -- 注意要减掉整个滑动条的坐标
            end
        end

        -- 结束点击时，回调函数
        if eventType == TOUCH_ENDED then
            if callback_func then
                do_callback_func(  )
            end
        end
    end
    value_move_bar.view:registerScriptHandler( touch_event_func ) 



    -- ////////提供外部使用的方法///////////////

    -- 获取当前滑动条表示值
    value_move_bar.get_current_value = function(  )
        local curr_value = calulate_current_value(  )
        return curr_value
    end

    -- 设置当前值
    value_move_bar.set_current_value = function( curr_value )
        -- print("设置当前值", max_value, curr_value)
        local curr_pox_x = curr_value / max_value * (bar_image_w - but_image_w)      -- 计算位置
        set_but_position( curr_pox_x )
    end

    return value_move_bar
end

-- ================================================
-- 数值滑动条2 中间有一个按钮的长条，控制数值   by lyl 
-- 第2版是为了让滑动块可以在滑动条外面 edit by guozhinan
-- x, y： 坐标
-- bar_image ： 背景长条的图片路径   bar_image_w, bar_image_h:  宽、高
-- but_image ： 按钮        but_image_w, but_image_h：按钮宽高
-- max_value ： 数字：最大值
-- callback_func： 生效时的回调函数
-- ================================================
function MUtils:create_value_move_bar2( x, y, bar_image, bar_image_w, bar_image_h, but_image, but_image_w, but_image_h, max_value, callback_func )
    local value_move_bar = {}                   -- 数字滑动条对象
    local but_current_x  = 0                    -- 记录按钮当前的位置（相对滑动条区域的左下角）
    local but_pre_cb_x   = 0                    -- 按钮上一次相应位置, 这里是要控制每变化5%就回调一次，防止拖出区域以外才松开，没有end时间响应的情况
    local max_value = max_value or 1            -- 最大表示值
    
    -- 整个可响应区域的背景,  长度根据长调的 w 值，  高度根据 按钮的  h 值  ui/common/nine_grid_bg.png
    value_move_bar.view = CCBasePanel:panelWithFile( x, y, bar_image_w, but_image_h, "", 500, 500 )

    -- 长条
    local bg_bar_x = but_image_w/2
    local bg_bar_y = (but_image_h - bar_image_h) / 2        -- 长条的位置居中
    local bg_bar = CCZXImage:imageWithFile( bg_bar_x, bg_bar_y, bar_image_w-but_image_w, bar_image_h, bar_image, 500, 500 )
    value_move_bar.view:addChild( bg_bar )

    -- 按钮
    local move_but = CCZXImage:imageWithFile( 0, 0, but_image_w, but_image_h, but_image, 500, 500 )
    value_move_bar.view:addChild( move_but )


    -- 计算当前值
    local function calulate_current_value(  )
        local percentage = but_current_x / (bar_image_w - but_image_w)
        local curr_value = percentage * max_value          -- 当前表示的值
        curr_value = math.floor(curr_value)
        return curr_value
    end

    -- 调用回调函数
    local callback_temp = callback:new()
    local function do_callback_func(  )
        callback_temp:cancel()
        local curr_value = calulate_current_value(  )
        but_pre_cb_x = but_current_x 

        -- 解决  “触点离开区域才放开的情况下，不会响应end事件” 的问题。但又不能平凡调用。所以用个callback
        local function callback_temp_func()
            if callback_func then
                callback_func( curr_value )
            end
        end
        -- 标记回调函数时，按钮的位置
        callback_temp:start( 0.3, callback_temp_func ) 
    end

    -- 设置按钮的位置
    local function set_but_position( pos_x )
        but_current_x = pos_x
        pos_x = pos_x - but_image_w / 2                    -- 点击处为按钮中心
        if pos_x > bar_image_w - but_image_w * 3 / 2 then          -- 控制按钮显示不超出滑动条
            pos_x = bar_image_w - but_image_w
            but_current_x = pos_x
        end
        if ( pos_x / (bar_image_w - but_image_w * 3 / 2) ) <= 0.05 then             -- 要控制为0的时候，不好拖动。 所以接近的时候，就设置为0
            pos_x = 0
            but_current_x = pos_x
        elseif ( pos_x / (bar_image_w - but_image_w * 3 / 2) ) >= 0.95 then
            pos_x = bar_image_w - but_image_w
            but_current_x = pos_x
        end
        move_but:setPosition( pos_x, 0 )

        -- 由于触点离开区域才放开的情况下，不会响应end事件，这里每百分之五回调一次函数
        -- todo !!!!!!!!!!!!!  这里是暂时测试，这样处理。以后panel要提供离开事件 
        if math.abs( but_pre_cb_x - pos_x ) / max_value > 0.1 then
            do_callback_func(  )
        end 
    end

    -- 触摸事件
    local pos_temp   = {}        -- 每次触发事件用到的变量
    local x_temp     = 0         
    local function touch_event_func( eventType, touch_x_y )
        -- 设置拖动按钮的位置
        if eventType == TOUCH_BEGAN or eventType == TOUCH_MOVED or eventType == TOUCH_ENDED then
            if not touch_x_y then                         -- 开始的时候会来两个nil值，避开
                return 
            end
            pos_temp = Utils:Split(touch_x_y,":")         -- 计算坐标
            x_temp = pos_temp[1]                          -- 点击事件发生的x坐标
            if tonumber(x_temp) ~= 0 then                 -- 放开的时候会返回一个0的坐标，这里把它避开
                set_but_position( tonumber(x_temp) - x )  -- 注意要减掉整个滑动条的坐标
            end
        end

        -- 结束点击时，回调函数
        if eventType == TOUCH_ENDED then
            if callback_func then
                do_callback_func(  )
            end
        end
    end
    value_move_bar.view:registerScriptHandler( touch_event_func ) 



    -- ////////提供外部使用的方法///////////////

    -- 获取当前滑动条表示值
    value_move_bar.get_current_value = function(  )
        local curr_value = calulate_current_value(  )
        return curr_value
    end

    -- 设置当前值
    value_move_bar.set_current_value = function( curr_value )
        -- print("设置当前值", max_value, curr_value)
        local curr_pox_x = curr_value / max_value * (bar_image_w - but_image_w)      -- 计算位置
        set_but_position( curr_pox_x )
    end

    return value_move_bar
end
-- ==================================================================
-- 创建页数指示 圆圈  ， 参数：坐标， 总数量  lyl    
-- circle_n = CCZXImage:imageWithFile( 0, 0, 15, 15, "ui/bag/non_current_page_circle.png") current_page_circle
-- x, y,  坐标
-- num ： 数量
-- circle_image_n, circle_image_s： 正常状态和选中状态
-- circle_w, circle_h: 宽高
-- circle_interval：  间隔
-- callback_func：  切换页的回调函数
-- ==================================================================
function MUtils:create_page_circle( x, y, num, circle_image_n, circle_image_s, circle_w, circle_h, circle_interval, callback_func )
    local show_page_circle = {}


    -- 创建一个圆圈，内部调用。  参数：位置， 响应区域的宽高
    local create_one_circle = function( circle_x, circle_y, w, h, circle_index )
        local one_circle = {}
        -- one_circle.view = CCZXImage:imageWithFile( circle_x, circle_y, circle_w, circle_h, "")   -- 一个圆圈的背景
        local function on_click_event( eventType, args, msgid )
            if eventType == TOUCH_BEGAN then
                if callback_func then
                    callback_func( circle_index )
                end
                show_page_circle.change_page_index( circle_index )
                return true
            end
        end
        one_circle.view = CCBasePanel:panelWithFile( circle_x + circle_w / 2 - w / 2, circle_y + circle_h / 2 - h / 2, w, h, "" )
        one_circle.view:registerScriptHandler(on_click_event)

        -- 之所以这样麻烦计算坐标，是为了让使用者只关心 点的位置。 而不用考虑响应区域
        local circle_n = CCZXImage:imageWithFile( w / 2 - circle_w / 2, h / 2 - circle_h / 2, circle_w, circle_h, circle_image_n)      -- 未选中状态
        one_circle.view:addChild( circle_n )
        local circle_s = CCZXImage:imageWithFile( w / 2 - circle_w / 2, h / 2 - circle_h / 2, circle_w, circle_h, circle_image_s)      -- 选中状态
        one_circle.view:addChild( circle_s )

        -- 页数
        -- local page_num = UILabel:create_lable_2( circle_index, w / 2 - circle_w / 2, h / 2 - circle_h / 2, 8, ALIGN_LEFT )
        -- one_circle.view:addChild( page_num )

        -- 设置圈圈的选中状态
        one_circle.set_state = function( if_select )
            if if_select then
                circle_n:setIsVisible( false )
                circle_s:setIsVisible( true  )
                -- page_num:setIsVisible( true )
            else
                circle_n:setIsVisible( true )
                circle_s:setIsVisible( false  )
                -- page_num:setIsVisible( false )
            end
        end
        return one_circle
    end

    
    -- show_page_circle.view = CCZXImage:imageWithFile( x, y, circle_h, num * circle_interval, "")  -- 背景
    local view_x = x + circle_w / 2 - circle_interval / 2        -- 计算背景面板坐标（要扩大点击响应区域）
    local view_y = y + circle_h / 2 - circle_interval / 2        
    show_page_circle.view = CCBasePanel:panelWithFile( view_x , view_y, num * circle_interval, circle_interval, "" )
    
    local circle_t = {}                 -- 存放所有circle， 做页数选择的时候使用
    local circle_num = num or 0
    for i = 1, circle_num do
        local circle_x = circle_interval * ( i - 1 ) + circle_interval / 2 - circle_w / 2
        local circle_y = 0 + circle_interval / 2 - circle_h / 2
        circle_t[i] = create_one_circle( circle_x, circle_y, circle_interval , circle_interval, i  )
        show_page_circle.view:addChild( circle_t[i].view )
    end

    -- 修改第几页的提示  page_index ： 表示第几页
    show_page_circle.change_page_index = function( page_index )
        for i = 1, circle_num do
            if i == page_index then
                circle_t[i].set_state( true )
            else
                circle_t[i].set_state( false )
            end
        end
    end

    return show_page_circle
end

-- ==================================================================
-- 创建一个带倒计时的活动图标按钮
-- autor：fjh
-- args: parent 父节点; x、y、w、h 坐标宽高; btn_img 按钮图片; time 倒计时时间;
--       click_func 按钮点击事件; end_call_func 倒计时停止的回调;  
-- ==================================================================

function MUtils:create_countdown_avtivity_btn( parent, x, y, w, h, btn_img, time, click_func, end_call_func )
    
    local countdown_btn = {};

    countdown_btn.btn = MUtils:create_btn(parent, btn_img, btn_img, click_func, x, y, w, h);

    countdown_btn.timer_lab = nil;
    local function time_end(  )
        
        if end_call_func then
            end_call_func()
        end
        
    end

    if time then
       countdown_btn.timer_lab = TimerLabel:create_label(countdown_btn.btn, w/2, -13, 12, time, nil, time_end,false, ALIGN_CENTER);
    end
   

    countdown_btn.remove_timer = function ( bool ) 
            if countdown_btn.timer_lab then 
                
                countdown_btn.timer_lab:destroy();
            end
        end
        -- body
     return countdown_btn;
end

--根据获取数字图片名称
local function get_num_ima( one_num ,img_type)
    -- print("get_num_ima,one_num",one_num);
    local path = nil;
    if img_type == 1 then
        path = UIResourcePath.FileLocate.lh_other.."number2_"..one_num..".png";
    elseif img_type == 2 then
        path = "ui/fonteffect/u"..one_num..".png";
    elseif img_type == 3 then
        path = UIResourcePath.FileLocate.lh_other .. "number1_" .. one_num .. ".png";
    elseif img_type == 4 then
        path = UIResourcePath.FileLocate.lh_other .. "vip" .. one_num .. ".png";
    end
    return path;
end

--把数字转成对应的数字图片:  显示的数字，起始坐标 x  y ,显示的底panel
function MUtils:change_num_to_ima( num ,star_x, star_y, pannel,img_type)
    -- print("num",num);
    local num_str = tostring(num)  --把数字转成字符串
    local i = 1                    --获取字符索引
    local contentHeight = 0
    local contentWidth = 0
    local p = CCPointMake(0.0,0.0)
    if num_str ~= nil then
        local a_char = string.sub(num_str, i, i)
        while a_char ~= "" do
            --画图
            local num_ima = CCSprite:spriteWithFile(get_num_ima( a_char,img_type ))--CCZXImage:imageWithFile( 0, 0, -1, -1, get_num_ima( a_char,img_type )); --数字图片
            pannel:addChild( num_ima )
            local sz = num_ima:getContentSize()
            local width = sz.width-3;
            -- print("width",width);
            num_ima:setPosition(width * (i - 1), 0)
            i = i + 1
            a_char = string.sub(num_str, i, i)
            contentWidth = contentWidth + width
            contentHeight = sz.height
            num_ima:setAnchorPoint(p)
        end
    end
    pannel:setContentSize(CCSizeMake(contentWidth,contentHeight))
end

function MUtils:create_num_img( num,start_x,start_y,parent,img_type )
    if img_type == nil then
        img_type = 1;
    end
    local node = CCSpriteBatchNode:batchNodeWithFile(get_num_ima('0',img_type))
    node:setPosition(CCPoint(start_x,start_y));
    MUtils:change_num_to_ima( num ,0, 0, node,img_type);
    parent:addChild(node);
    return node;
end

-- 计算背包里面某个道具在屏幕的x,y坐标
function MUtils:cal_bag_win_item_position( item_id )
    local index = ItemModel:get_item_index_by_item_id( item_id )
    if ( index ) then
        local page = math.floor( (index-1)/20) + 1;
        local bag_win = UIManager:find_window("bag_win");
        if ( bag_win ) then 
            bag_win:change_item_page_by_index( page )
        end
        index = (index-1) %20 + 1; 
        local x,y;
        local row = math.floor((index-1)/5);
        local cloumn = (index-1)%5 ;
        print("index = ",index,"row = ",row,"cloumn = ",cloumn);
        x = 533 + cloumn * 80;
        y = 483 - row*80;
        return x,y;
    end
    return nil,nil;
end

-- 根据宠物资质取得宠物名字的颜色 
--500以下：FFFFFF、500-600：66FF66、600-700：35C3F7、700-900：FF49F4、900以上：FFC000 
function MUtils:get_pet_name_color( pet_info )
    local max_zz = 0;
    for i=1,4 do
        local zz = pet_info.tab_attr[28+i];
        if ( zz > 899 ) then
            -- 如果资质大于900,直接返回颜色值
            return "#cFFC000";
        end
        if ( zz > max_zz ) then
            max_zz = zz;
        end
    end
    if ( max_zz > 699 ) then
        return "#cFF49F4";
    elseif ( max_zz > 599 ) then
        return "#c35C3F7";
    elseif ( max_zz > 499 ) then
        return "#c66FF66";
    else
        return "#cffffff";
    end

end

function MUtils:get_color_by_zz( zz_table )
    local max_zz = 0;
    for i=1,4 do
        local zz = zz_table[i];
        if ( zz > 899 ) then
            -- 如果资质大于900,直接返回颜色值
            return "#cFFC000";
        end
        if ( zz > max_zz ) then
            max_zz = zz;
        end
    end
    if ( max_zz > 699 ) then
        return "#cFF49F4";
    elseif ( max_zz > 599 ) then
        return "#c35C3F7";
    elseif ( max_zz > 499 ) then
        return "#c66FF66";
    else
        return "#cffffff";
    end
end

function MUtils:get_zz_color( zz )
    if ( zz > 899 ) then
        return "#cFFC000";
    elseif ( zz > 699 ) then
        return "#cFF49F4";
    elseif ( zz > 599 ) then
        return "#c35C3F7";
    elseif ( zz > 499 ) then
        return "#c66FF66";
    end
    return "#cffffff";
end

-- =================================================
-- 创建一个slotItem， 可向里面设置数据，并显示  by lyl  
-- item_id: 道具的id.  可以为nil，此时创建一个空的 背景框
-- x, y   : 坐标
-- w, h   : 图标大小。 可以为空，默认64 * 64
-- =================================================
function MUtils:create_one_slotItem( item_id, x, y, w, h )
    -- 先按48 *　48的大小再创建在根据传入的大小进行缩放
    local slot_w, slot_h = 64, 64
    local slotItem = SlotItem( slot_w, slot_h )
    slotItem.item_date = nil                   -- 存储道具动态数据
    slotItem.item_id   = item_id               -- 道具id,   ！！！ 注意，值可能是nil   ！！！
    slotItem:set_icon_bg_texture( UIPIC_ITEMSLOT, -9, -9, 83, 83)
    -- slotItem:set_icon_bg_texture( UILH_COMMON.slot_bg, -4, -4, 72, 72 )   -- 背框
    slotItem:setPosition (x, y)

	--OPEN by HWL 9.25
    -- 缩放成指定大小
    w = w or 64
    h = h or 64
    local curr_scale_x = w / 64
    local curr_scale_y = h / 64
    slotItem.view:setScaleX( curr_scale_x )
    slotItem.view:setScaleY( curr_scale_y )

    if item_id ~= nil then
        local item_base = ItemConfig:get_item_by_id( item_id )
        
        if item_base then
            -- print(item_id, x, y, w, h)
            slotItem:set_icon( item_id )
            slotItem:set_gem_level( item_id ) 
            slotItem:set_color_frame( item_id, -2, -2, 68, 68 )
        end
    end

    -- ************提供方法**********
    -- 根据item_id 设置基础显示
    slotItem.set_base_date = function( item_id )
        if item_id and item_id ~= 0 then          -- 介于很多地方使用0来表示没有道具，这里加入这个特殊判断
            slotItem.item_id = item_id
            slotItem:set_icon( item_id )
            slotItem:set_gem_level( item_id ) 
            slotItem:set_color_frame( item_id, -2, -2, 68, 68 )
        else
            slotItem.init()
        end
    end
    -- 设置数据
    slotItem.set_date = function( item_date )
        if item_date == nil then
            slotItem.init()
            return
        end

        local item_base = ItemConfig:get_item_by_id( item_date.item_id )
        -- print("MUtils:create_one_slotItem item_date.item_id",item_date.item_id, item_base)
        if item_base == nil then
            return
        end
        slotItem:set_icon(item_date.item_id)
        slotItem:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
        slotItem:set_color_frame( item_date.item_id, -2, -2, 68, 68 )    -- 边框颜色
        slotItem:set_item_count( item_date.count )       -- 数量
        slotItem:set_strong_level( item_date.strong )    -- 强化等级
        slotItem:set_gem_level( item_date.item_id )      -- 宝石的等级
        
        slotItem.item_id   = item_date.item_id
        slotItem.item_date = item_date
    end
    -- 初始化显示  把包括图标在内的所有显示元素清空
    slotItem.init = function(  )
        slotItem:set_icon_texture("");
        slotItem:set_lock( false )
        slotItem:set_color_frame( nil )
        slotItem:set_item_count( 0 )
        slotItem:set_strong_level( 0 ) 
        slotItem:set_gem_level( nil )

        slotItem.item_id = nil
        slotItem.item_date = nil
    end

    return slotItem
end

-- 天将雄狮添加 外框较大,调整边框大小
function MUtils:create_one_slotItem_align( item_id, x, y, w, h, align, slot_bg )
    -- 先按48 *　48的大小再创建在根据传入的大小进行缩放
    local slot_w, slot_h = 64, 64
    local slotItem = SlotItem( slot_w, slot_h )
    slotItem.item_date = nil                   -- 存储道具动态数据
    slotItem.item_id   = item_id               -- 道具id,   ！！！ 注意，值可能是nil   ！！！

    -- add by chj in tjxs
    local si_px, si_py = -4, -4
    local si_w, si_h = 72, 72
    local frame_px, frame_py = 0, 0
    local frame_w, frame_h = 66, 66
    if align then
        --slot
        si_w = si_w + align
        si_h = si_h + align
        si_px = si_px - align*0.5
        si_py = si_py - align*0.5

        --frame
        frame_w = frame_w - align
        frame_h = frame_h - align
        -- frame_px = frame_px - align*0.5
        -- frame_py = frame_py - align*0.5
    end
    slot_bg = slot_bg or UILH_COMMON.slot_bg

    slotItem:set_icon_bg_texture( slot_bg, si_px, si_py, si_w, si_h )   -- 背框
    slotItem:setPosition (x, y)

    --OPEN by HWL 9.25
    -- 缩放成指定大小
    w = w or 64
    h = h or 64

    local curr_scale_x = w / 64
    local curr_scale_y = h / 64
    slotItem.view:setScaleX( curr_scale_x )
    slotItem.view:setScaleY( curr_scale_y )

    if item_id ~= nil then
        local item_base = ItemConfig:get_item_by_id( item_id )
        
        if item_base then
            -- print(item_id, x, y, w, h)
            slotItem:set_icon( item_id )
            slotItem:set_gem_level( item_id ) 
            slotItem:set_color_frame( item_id, frame_px, frame_py, frame_w, frame_h )
        end
    end

    -- ************提供方法**********
    -- 根据item_id 设置基础显示
    slotItem.set_base_date = function( item_id )
        if item_id and item_id ~= 0 then          -- 介于很多地方使用0来表示没有道具，这里加入这个特殊判断
            slotItem.item_id = item_id
            slotItem:set_icon( item_id )
            slotItem:set_gem_level( item_id ) 
            slotItem:set_color_frame( item_id, frame_px, frame_py, frame_w, frame_h )
        else
            slotItem.init()
        end
    end
    -- 设置数据
    slotItem.set_date = function( item_date )
        if item_date == nil then
            slotItem.init()
            return
        end

        local item_base = ItemConfig:get_item_by_id( item_date.item_id )
        -- print("MUtils:create_one_slotItem item_date.item_id",item_date.item_id, item_base)
        if item_base == nil then
            return
        end
        slotItem:set_icon(item_date.item_id)
        slotItem:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
        slotItem:set_color_frame( item_date.item_id, frame_px, frame_py, frame_w, frame_h )    -- 边框颜色
        slotItem:set_item_count( item_date.count )       -- 数量
        slotItem:set_strong_level( item_date.strong )    -- 强化等级
        slotItem:set_gem_level( item_date.item_id )      -- 宝石的等级
        
        slotItem.item_id   = item_date.item_id
        slotItem.item_date = item_date
    end
    -- 初始化显示  把包括图标在内的所有显示元素清空
    slotItem.init = function(  )
        slotItem:set_icon_texture("");
        slotItem:set_lock( false )
        slotItem:set_color_frame( nil )
        slotItem:set_item_count( 0 )
        slotItem:set_strong_level( 0 ) 
        slotItem:set_gem_level( nil )

        slotItem.item_id = nil
        slotItem.item_date = nil
    end

    return slotItem
end

function MUtils:create_equip_slotItem( item_id, x, y, w, h, item_bg )
    -- 先按48 *　48的大小再创建在根据传入的大小进行缩放
    local slot_w, slot_h = 64, 64
    local slotItem = SlotItem( slot_w, slot_h )
    slotItem.item_date = nil                   -- 存储道具动态数据
    slotItem.item_id   = item_id               -- 道具id,   ！！！ 注意，值可能是nil   ！！！

    -- slotItem:set_icon_bg_texture( UIPIC_ITEMSLOT, -4, -4, 72, 72 )   -- 背框
    slotItem:set_icon_bg_texture( UIPIC_ITEMSLOT, -9, -9, 83, 83)
    slotItem:setPosition (x, y)

    -- 缩放成指定大小
    -- w = w or 48
    -- h = h or 48
    -- local curr_scale_x = w / 48
    -- local curr_scale_y = h / 48
    -- slotItem.view:setScaleX( curr_scale_x )
    -- slotItem.view:setScaleY( curr_scale_y )

    if item_id ~= nil then
        local item_base = ItemConfig:get_item_by_id( item_id )
        
        if item_base then
            -- print(item_id, x, y, w, h)
            slotItem:set_icon( item_id )
            slotItem:set_gem_level( item_id ) 
            slotItem:set_color_frame( item_id, -2, -2, 68, 68 )
        end
    end

    -- ************提供方法**********
    -- 根据item_id 设置基础显示
    slotItem.set_base_date = function( item_id )
        if item_id and item_id ~= 0 then          -- 介于很多地方使用0来表示没有道具，这里加入这个特殊判断
            slotItem.item_id = item_id
            slotItem:set_icon( item_id )
            slotItem:set_gem_level( item_id ) 
            slotItem:set_color_frame( item_id, -2, -2, 68, 68 )
        else
            slotItem.init()
        end
    end
    -- 设置数据
    slotItem.set_date = function( item_date )
        if item_date == nil then
            slotItem.init()
            return
        end
        local item_base = ItemConfig:get_item_by_id( item_date.item_id )
        if item_base == nil then
            return
        end
        slotItem:set_icon(item_date.item_id)
        slotItem:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
        slotItem:set_color_frame( item_date.item_id, -2, -2, 68, 68 )    -- 边框颜色
        slotItem:set_item_count( item_date.count )       -- 数量
        slotItem:set_strong_level( item_date.strong )    -- 强化等级
        slotItem:set_gem_level( item_date.item_id )      -- 宝石的等级
        
        slotItem.item_id   = item_date.item_id
        slotItem.item_date = item_date
    end
    -- 初始化显示  把包括图标在内的所有显示元素清空
    slotItem.init = function(  )
        slotItem:set_icon_texture("");
        slotItem:set_lock( false )
        slotItem:set_color_frame( nil )
        slotItem:set_item_count( 0 )
        slotItem:set_strong_level( 0 ) 
        slotItem:set_gem_level( nil )

        slotItem.item_id = nil
        slotItem.item_date = nil
    end

    return slotItem
end

function MUtils:create_gem_slotItem( item_id, x, y, w, h, item_bg )
    -- 先按48 *　48的大小再创建在根据传入的大小进行缩放
    local slotItem = SlotItem( 48, 48 )
    slotItem.item_date = nil                   -- 存储道具动态数据
    slotItem.item_id   = item_id               -- 道具id,   ！！！ 注意，值可能是nil   ！！！

    slotItem:set_icon_bg_texture( item_bg, -7, -4, w, h )   -- 背框
    slotItem:setPosition (x, y)

    if item_id ~= nil then
        local item_base = ItemConfig:get_item_by_id( item_id )
        
        if item_base then
            -- print(item_id, x, y, w, h)
            slotItem:set_icon( item_id )
            -- slotItem:set_gem_level( item_id ) 
        end
    end

    -- ************提供方法**********
    -- 根据item_id 设置基础显示
    slotItem.set_base_date = function( item_id )
        if item_id and item_id ~= 0 then          -- 介于很多地方使用0来表示没有道具，这里加入这个特殊判断
            slotItem.item_id = item_id
            slotItem:set_icon( item_id )
            -- slotItem:set_gem_level( item_id )
        else
            slotItem.init()
        end
    end
    -- 设置数据
    slotItem.set_date = function( item_date )
        if item_date == nil then
            slotItem.init()
            return
        end
        local item_base = ItemConfig:get_item_by_id( item_date.item_id )
        if item_base == nil then
            return
        end
        slotItem:set_icon(item_date.item_id)
        slotItem:set_lock( item_date.flag == 1 )         -- 是否绑定(锁)
        -- slotItem:set_color_frame( item_date.item_id, -4, -5, 57, 57 )    -- 边框颜色
        -- slotItem.set_flash_frame()
        slotItem:set_item_count( item_date.count )       -- 数量
        slotItem:set_strong_level( item_date.strong )    -- 强化等级
        slotItem:set_gem_level( item_date.item_id )      -- 宝石的等级
        
        slotItem.item_id   = item_date.item_id
        slotItem.item_date = item_date
    end
    -- 初始化显示  把包括图标在内的所有显示元素清空
    slotItem.init = function(  )
        slotItem:set_icon_texture("");
        slotItem:set_lock( false )
        slotItem:set_color_frame( nil )
        slotItem:set_item_count( 0 )
        slotItem:set_strong_level( 0 ) 
        slotItem:set_gem_level( nil )

        slotItem.item_id = nil
        slotItem.item_date = nil
    end

    slotItem.set_flash_frame = function(  )
        local self = slotItem
        if self.color_frame == nil then
            self.color_frame= CCZXImage:imageWithFile(-7, -5, 62, 71, UIPIC_FORGE_007)
            self.view:addChild(self.color_frame, 9)
        end
    end

    return slotItem
end



-- =================================================
-- 创建一条属性数据条 . jiehua fang on 2013-5-22
-- attri_name:  属性名字
-- init_data:   初始化数据
-- =================================================

function MUtils:create_attrs_bar( parent, x, y, attri_name, init_data )
    
    local attrs_bar = {};

    attrs_bar.view = CCBasePanel:panelWithFile(x,y,143,20,"");
    parent:addChild( attrs_bar.view );

    -- 属性名字
    -- attrs_bar.attri_name = UILabel:create_lable_2( "#c33a6ee"..attri_name, 0, 0, 14, ALIGN_LEFT )
    attrs_bar.attri_name = UILabel:create_lable_2( LH_COLOR[2]..attri_name, 0, 0, 14, ALIGN_LEFT )
    attrs_bar.view:addChild(attrs_bar.attri_name);

    attrs_bar.attri_bg = MUtils:create_zximg( attrs_bar.view,nil,75,-1,77,20,500,500);
    -- 属性数据
    attrs_bar.attri_data = UILabel:create_lable_2(""..init_data, 5, 3, 14, ALIGN_LEFT );
    attrs_bar.attri_bg:addChild(attrs_bar.attri_data);

    ---- 更新属性名字
    attrs_bar.update_name = function ( name )
        -- attrs_bar.attri_name:setText( "#cfff000"..name );
        attrs_bar.attri_name:setText(LH_COLOR[2]..name );
    end

    ---- 更新属性数据
    attrs_bar.update_data = function ( data )
        attrs_bar.attri_data:setText( "+"..data );
    end

    -- 更新属性数据的背景图
    attrs_bar.update_attri_bg = function ( texture_path )
        attrs_bar.attri_bg:setTexture( texture_path );
    end

    return attrs_bar;

end



-- =================================================
-- 创建一个可左右切换选择的按钮组件 . jiehua fang on 2013-5-23
-- sum_index:   可选择的index总数
-- page_func:   翻页按钮回调事件
-- =================================================

function MUtils:create_page_btn( parent, x, y, w, h, sum_index, page_func )
    local page_btn = {};
    page_btn.index = 1;
    page_btn.sum_index = sum_index;
    page_btn.page_func = page_func;

    page_btn.view = CCBasePanel:panelWithFile(x,y,w,h,"");
    parent:addChild(page_btn.view);

    -- 左翻事件
    local function left_event( eventType )
        if TOUCH_CLICK == eventType then
            if page_btn.index > 1 then
                page_btn.index = page_btn.index - 1;
                page_btn.page_func( page_btn.index );
                if page_btn.index == 1 then
                    page_btn.left_btn:setCurState(CLICK_STATE_DISABLE);
                else
                    page_btn.left_btn:setCurState(CLICK_STATE_UP);
                end
                page_btn.right_btn:setCurState(CLICK_STATE_UP);
            end
        end
        return true;
    end  
    page_btn.left_btn = MUtils:create_btn(page_btn.view,UIResourcePath.FileLocate.common .. "left_page_turn_btn_n2.png",
        UIResourcePath.FileLocate.common .. "left_page_turn_btn_n2.png",
                                        left_event, 0, h/2-54/2, -1, -1);
    page_btn.left_btn:setCurState(CLICK_STATE_DISABLE);

    -- 右翻事件
    local function right_event( eventType )
        if TOUCH_CLICK == eventType then
            if page_btn.index < page_btn.sum_index then
                page_btn.index = page_btn.index + 1;
                page_btn.page_func( page_btn.index );
                if page_btn.index == page_btn.sum_index then
                    page_btn.right_btn:setCurState(CLICK_STATE_DISABLE);
                else
                    page_btn.right_btn:setCurState(CLICK_STATE_UP);
                end
                page_btn.left_btn:setCurState(CLICK_STATE_UP);
            end
        end
        return true;
    end  
    page_btn.right_btn = MUtils:create_btn(page_btn.view,UIResourcePath.FileLocate.common .. "right_page_turn_btn_n2.png",
        UIResourcePath.FileLocate.common .. "right_page_turn_btn_n2.png",
                                        right_event, w-28, h/2-54/2, -1, -1);


    --- 更新至index项
    page_btn.update_index = function ( index )
        page_btn.index = index;
        if page_btn.index <= 1 then
            page_btn.left_btn:setCurState(CLICK_STATE_DISABLE);
            page_btn.right_btn:setCurState(CLICK_STATE_UP);
        end
        if page_btn.index >= 2 and page_btn.index <= page_btn.sum_index -1 then
            page_btn.left_btn:setCurState(CLICK_STATE_UP);
            page_btn.right_btn:setCurState(CLICK_STATE_UP);
        end
        if page_btn.index >= page_btn.sum_index then
            page_btn.left_btn:setCurState(CLICK_STATE_UP);
            page_btn.right_btn:setCurState(CLICK_STATE_DISABLE);
        end

        page_btn.page_func( page_btn.index );
    end

    return page_btn;
end

-- 取得当前系统的年月日
function MUtils:get_current_date(  )
    local tab = os.date("*t");
    --print(tab.year, tab.month, tab.day, tab.hour, tab.min, tab.sec);
    return tab;
end
-- 取得是否是闰年
function MUtils:is_leap_year( year )
    return ( ( 0 == year % 4 and 0 ~= year %100 ) or ( 0 == year % 400 ) ); 
end
-- 返回某一年某一月的天数
function MUtils:get_month_day_number( year,month)
    local daynumber = 0;
    -- 二月单独处理
    if ( 2 == month ) then
        if ( MUtils:is_leap_year( year ) ) then 
            daynumber = 29;
        else
            daynumber = 28;
        end
    else
        -- 八月前奇数月为31天,八月后偶数月为31天
        if ((month < 8 and 1 == month %2) or ( month >=8 and 0 == month%2 )) then
            daynumber = 31;
        end
        -- 八月前偶数月30天,八月后奇数月30天
        if( ( month < 8  and 0 == month % 2) or ( month >= 8 and 1 == month % 2 ) ) then
            daynumber = 30;
        end
    end
    return daynumber;
end
-- 从某一天到2013年1月1日有多少天 (2013/1/1星期二)
function MUtils:now_to_day(year,month,day)
    local di_day = 0;
    for i=2013,year-1 do
        if ( self:is_leap_year(i)) then
            di_day = di_day +  366;
        else
            di_day = di_day +  365;
        end
    end
    for i=1,month-1 do
        di_day = di_day + self:get_month_day_number(year,i);
    end
    di_day = di_day + day -1;
    -- print(string.format("%d年%d月%d日到2013年1月1日是%d天",year,month,day,di_day));
    return di_day;
end

-- 查找某一天是星期几
function MUtils:find_day_weekend( year,month,day )
    -- print("year,month,day",year,month,day);
    local total_day = self:now_to_day(year,month,day);
    local weekend = (total_day + 2)%7;
    -- print(string.format("%d年%d月%d日是星期%d",year,month,day,weekend));
    return weekend
end

-- 创建宠物和魔法阵
function MUtils:create_pet_and_mfz( parent,pet_id,pos_x,pos_y )
    local pet_file = string.format("scene/monster/%d",pet_id);
    local action = {0,0,9,0.2};
    self.pet_spr = MUtils:create_animation(pos_x,pos_y,pet_file,action )
    parent:addChild( self.pet_spr );
    -- 播放魔法阵特效
    -- LuaEffectManager:play_view_effect( 10012,0 ,0,self.pet_spr,true ,-1);
    -- LuaEffectManager:play_view_effect( 10013,0 ,0,self.pet_spr,true ,1);
    return self.pet_spr;
end

-- =============================================================================
-- 创建一个scroll   by lyl
-- pos_x, pos_y, size_w, size_h：坐标，宽高
-- max_num： 最大行（纵滑动情况下）或者列(横滑动)数
-- bg_name: 背景名称
-- forward_type: 方向  纵：TYPE_HORIZONTAL    TYPE_VERTICAL
-- create_func : 需要创建一个新元素的时候，的回调函数。 其中回调函数需要返回一个 panel给本scroll使用
-- =============================================================================
function MUtils:create_one_scroll( pos_x, pos_y, size_w, size_h, max_num, bg_name, forward_type, create_func )


    local scroll = CCScroll:scrollWithFile(pos_x, pos_y, size_w, size_h, max_num, bg_name, TYPE_HORIZONTAL)
    local function scrollfun(eventType, args, msg_id)
        if eventType == nil or args == nil or msg_id == nil then 
            return
        end
        if eventType == TOUCH_BEGAN then
            return true
        elseif eventType == TOUCH_MOVED then
            return true
        elseif eventType == TOUCH_ENDED then
            return true
        elseif eventType == SCROLL_CREATE_ITEM then
            -- 计算创建的 序列号
            local temparg = Utils:Split_old(args,":")
            local x = temparg[1]              -- 行
            local y = temparg[2]              -- 列
            local panel_index = x + 1

            local create_panel = nil
            if create_func then
                create_panel = create_func( panel_index )
            end
            if create_panel then
                scroll:addItem( create_panel )
            else
                local bg = CCBasePanel:panelWithFileS(CCPointMake(0,0),CCSizeMake(0,0),nil)
                scroll:addItem(bg)
            end

            scroll:refresh()
            return false
        end
    end
    scroll:registerScriptHandler(scrollfun)
    scroll:refresh()

    return scroll
end

function MUtils:show_vip_dialog(content_word)
    local confirm_word = content_word or LangGameString[2298] -- [2298]="#cfff000仙尊3#cffffff级玩家,每日免费#cfff000无限速传#r#cffffff#cfff000仙尊2#cffffff级玩家,每日免费速传#cfff00020#cffffff次#r#cffffff#cfff000仙尊1#cffffff级玩家,每日免费速传#cfff00010#cffffff次"
    local function confirm_func(  )
        -- print("成为仙尊")
        ActivityModel:open_vipSys_win(  )
    end
    ConfirmWin2:show( 3, 3, confirm_word, confirm_func )
end


-- =============================================================================
-- 创建一个倒计时
-- @param time 倒数时间
-- @param callback 倒数完毕的回调
-- @param has_start 是否有开始图片
-- =============================================================================
function MUtils:create_big_count_down( parent,x,y,time, callback, has_start )
    
    local data = {};
    

    if has_start then
        data.num_img = CCZXImage:imageWithFile( x-30, y, 132, 108, UIResourcePath.FileLocate.lh_fuben .. "countdown_began.png");
        parent:addChild(data.num_img);
    else
        data.num_img = CCZXImage:imageWithFile(x, y, 65, 76, "");
        parent:addChild(data.num_img);
    end

    local _time = 5;
    if ( time ) then
        _time = time;
    end
    -- 记录初始秒数
    data.beagin_time = _time;

    local t = timer()
    
    local function timer_tick( )
        if _time > 0 then
            if has_start and _time == data.beagin_time then
            else
                data.num_img:setSize(65,76)
                data.num_img:setPosition(x, y)
                data.num_img:setTexture( string.format(UIResourcePath.FileLocate.lh_fuben .. "countdown_%d.png",_time) );
            end
        elseif _time <= 0 then
            data.num_img:removeFromParentAndCleanup(true);
            t:stop();
            if callback then
                callback();
            end
        end
        _time = _time - 1;
    end
    t:start(1,timer_tick)
    
    -- return data;--
    --modify by xiehande
    return data,t;

end

local blackScreen = 'nopack/blocked.png'
local blackScreenSprite = nil
local blackScreenLoading = nil
local Toast = nil
local BlackToast = nil
local ToastRemoveCallback = callback:new()
local BlackToastRemoveCallback = callback:new()
local nLockedByHandle = nil
local isLocked = nil

function MUtils:getLockHandle()
    return nLockedByHandle
end

--锁屏
--@param meg         Toast消息
--@param depth       深度
--@param showtime    Toast消息显示时间
function MUtils:toast(meg,depth,showtime, top)
    ToastRemoveCallback:cancel()
    if Toast then
        Toast:removeFromParentAndCleanup(true)
    end

    local UIRoot = ZXLogicScene:sharedScene():getUINode()
    local fontsize = 16
    local alignment = ALIGN_CENTER
    showtime = showtime or 2.5

    local width = 256 
    if string.len(meg) > 24 then
        width = 512
    end

    local end_pos =  -70
    local start_pos = 0
    if top then
        end_pos = GameScreenConfig.standard_height
        start_pos = GameScreenConfig.standard_height - 70
    end

    local labelposx = width * 0.5
    local label = CCZXLabel:labelWithText( labelposx, 32, meg, fontsize, alignment)
    local move_in = CCMoveTo:actionWithDuration(0.25,CCPoint(_refWidth(0.5),start_pos));
    local move_out = CCMoveTo:actionWithDuration(0.25,CCPoint(_refWidth(0.5),end_pos));
    local delay = CCDelayTime:actionWithDuration(showtime);
    --local removeact = CCRemove:action();
    local array = CCArray:array();
    array:addObject(move_in);
    array:addObject(delay)
    array:addObject(move_out);
    --array:addObject(removeact);
    local seq = CCSequence:actionsWithArray(array);
    label:setAnchorPoint(CCPointMake(0.0,0.5))
    local desc_bg = CCZXImage:imageWithFile( _refWidth(0.5),-70,width,64,
                                            "nopack/bg_06.png",
                                             width,64);
    desc_bg:addChild(label);
    desc_bg:setAnchorPoint(0.5,0.0)
    desc_bg:setPosition(CCPointMake(_refWidth(0.5),end_pos))
    UIRoot:addChild(desc_bg,depth)
    desc_bg:runAction(seq)

    ToastRemoveCallback:start( showtime + 0.5, 
                              function() 
                                if Toast then
                                    Toast:removeFromParentAndCleanup(true)
                                    Toast = nil
                                end
                                -- print('kill Toast') 
                                end)

    Toast = desc_bg
end

function MUtils:toast_black(meg,depth,showtime, top)

    BlackToastRemoveCallback:cancel()
    if BlackToast then
        BlackToast:removeFromParentAndCleanup(true)
    end

    local UIRoot = ZXLogicScene:sharedScene():getUINode()
    local fontsize = 16
    local alignment = ALIGN_CENTER
    showtime = showtime or 2.5

    local width = 256 
    if string.len(meg) > 24 then
        width = 512
    end

    local end_pos =  -70
    local start_pos = 0
    if top then
        end_pos = GameScreenConfig.ui_screen_height
        start_pos = GameScreenConfig.ui_screen_height - 70
    end
    local labelposx = width * 0.5
    local label = CCZXLabel:labelWithText( labelposx, 32, meg, fontsize, alignment)
    local move_in = CCMoveTo:actionWithDuration(0.25,CCPoint(_refWidth(0.5),start_pos));
    local move_out = CCMoveTo:actionWithDuration(0.25,CCPoint(_refWidth(0.5),end_pos));
    local delay = CCDelayTime:actionWithDuration(showtime);
    --local removeact = CCRemove:action();
    local array = CCArray:array();
    array:addObject(move_in);
    array:addObject(delay)
    array:addObject(move_out);
   -- array:addObject(removeact);
    local seq = CCSequence:actionsWithArray(array);
    label:setAnchorPoint(CCPointMake(0.0,0.5))
    local desc_bg = CCSprite:spriteWithFile('nopack/blocked.png')
    desc_bg:reSize(width, 64)
    desc_bg:setAnchorPoint(CCPointMake(0.5,0.0))
    desc_bg:setPosition(CCPointMake(_refWidth(0.5),end_pos))
    --[[
     GameScreenConfig.standard_half_width,-70,width,64,
                                             ,
    ]]--                                     width,64);
    desc_bg:addChild(label);
    
    UIRoot:addChild(desc_bg,depth)
    desc_bg:runAction(seq)
    BlackToast = desc_bg

    BlackToastRemoveCallback:start( showtime + 0.5, 
                              function() 
                                if BlackToast then
                                    BlackToast:removeFromParentAndCleanup(true)
                                    BlackToast = nil
                                end
                                end)

    BlackToast = desc_bg
end

function MUtils:lockGUI(state)
    local UIRoot = ZXLogicScene:sharedScene():getUINode()
    UIRoot:setBlocked(state)
end

--锁屏
--@param state              是否开启
--@param depth              深度
--@param reason             锁屏原因
--@param reason_showtime    锁屏原因显示时间
function MUtils:lockScreen(state, depth, reason, reason_showtime, lockhandle )
    -- print('blocked!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!', state)
    require 'UI/component/ProgressImg'
    local UIRoot = ZXLogicScene:sharedScene():getUINode()
    UIRoot:setBlocked(state)
    nLockedByHandle = lockhandle
    if state then
        if not blackScreenSprite then
            local hx = _refWidth(0.5)
            local hy = _refHeight(0.5)
            local UIRoot = ZXLogicScene:sharedScene():getUINode()
            blackScreenSprite = CCSprite:spriteWithFile(blackScreen);
            blackScreenLoading = ProgressImg('nopack/'..'circle_load.pd')
            blackScreenLoading.view:setPosition(hx,hy)
            blackScreenLoading.view:setScale(0.8)

            blackScreenSprite:addChild(blackScreenLoading.view,64)
            blackScreenSprite:setPosition(hx,hy)
            --blackScreenSprite:setOpacity(120)
            blackScreenSprite:reSize(_refWidth(1.0),_refHeight(1.0))
            UIRoot:addChild(blackScreenSprite,depth)
        end

        if reason then
            MUtils:toast(reason,depth + 1, reason_showtime)
        end
    else
        if blackScreenSprite then
            local fade_out = CCFadeOut:actionWithDuration(1.0);
            local removeact = CCRemove:action()
            local array = CCArray:array();
            array:addObject(fade_out);
            array:addObject(removeact)
            local seq = CCSequence:actionsWithArray(array);
            blackScreenSprite:setOpacity(255)
            blackScreenSprite:runAction(seq)
            blackScreenSprite = nil

            blackScreenLoading:destory()
            blackScreenLoading = nil
            local UIRoot = ZXLogicScene:sharedScene():getUINode()
            if reason then
                MUtils:toast(reason, depth + 1, reason_showtime)
            else
                ToastRemoveCallback:cancel()
                if Toast then
                    Toast:removeFromParentAndCleanup(true)
                    Toast = nil
                end                    
            end
        end
    end
end

function MUtils:CCSprite(root, file, x, y)
    local s = CCSprite:spriteWithFile(file);
    if root then
        root:addChild(s)
    end
    s:setPosition(CCPointMake(x,y))
    return s
end

function MUtils.CCSpriteSetGrayscale(comp, file)
    local result = string.find( file, ".png" )
    local gray_png = string.find( file, "_d.png" )
    local gray_pd = string.find( file, "_d.pd" )
    if gray_png ~= nil then
        return file
    end
    if gray_pd ~= nil then
        return file
    end
    -- print("MUtils.CCSpriteSetGrayscale file", file)
    if result ~= nil then 
        local i = string.find(file,'.png')
        local d = string.sub(file,1,i-1)
        d = d .. '_d' .. '.png'
        --print("d",d)
        return d
        --comp:replaceTexture(d)
    else
        local i = string.find(file,'.pd')
        local d = string.sub(file,1,i-1)
        d = d .. '_d' .. '.pd'
        --print("d",d)
        return d       
        --comp:replaceTexture(d)
    end
end

-- 创建不再提示对话框
function MUtils:create_not_tip_dialog( need_money,is_show_next,fun,fun2,str )
    local player = EntityManager:get_player_avatar();
    if ( player:check_is_enough_money(4,need_money) ) then
        if ( is_show_next == false ) then
            ConfirmWin2:show( 5, 0, str,  fun, fun2 )
        else
            fun();
        end
    end
end

function MUtils.GetGrayscaleName(file)
    print("MUtils.GetGrayscaleName file", file)
    local result = string.find( file, ".png" )
    local gray_png = string.find( file, "_d.png" )
    local gray_pd = string.find( file, "_d.pd" )
    if gray_png ~= nil then
        return file
    end
    if gray_pd ~= nil then
        return file
    end
    if result ~= nil then 
        local i = string.find(file,'.png')
        local d = string.sub(file,1,i-1)
        d = d .. '_d' .. '.png'
        return d
    else
        local i = string.find(file,'.pd')
        local d = string.sub(file,1,i-1)
        d = d .. '_d' .. '.pd'       
        return d
    end
end

function MUtils.GetNormalName(file)
    -- print("MUtils.GetNormalName file",file)
    local d = file
    local i = string.find( file, "_d.png" )
    local j = string.find( file, "_d.pd" )
    -- print("i,j",i,j)
    if i ~= nil then
        d = string.sub(file,1,i-1)
        d = d .. ".png"
    elseif j ~= nil then
        d = string.sub(file,1,j-1)
        d = d .. ".pd"
    end
    return d
end

function MUtils.GetRoundName(file)
    print("MUtils.GetRoundName file", file)
    local result = string.find( file, ".png" )
    local gray_png = string.find( file, "_d.png" )
    local gray_pd = string.find( file, "_d.pd" )
    if gray_png ~= nil then
        return file
    end
    if gray_pd ~= nil then
        return file
    end
    if result ~= nil then 
        local i = string.find(file,'.png')
        local d = string.sub(file,1,i-1)
        d = d .. '_r' .. '.png'
        return d
    else
        local i = string.find(file,'.pd')
        local d = string.sub(file,1,i-1)
        d = d .. '_r' .. '.pd'       
        return d
    end
end

-- font_align 1,从左往右2,从上往下
function MUtils:create_font_spr( str,parent,x,y,base_path ,font_align)
    local str_tab = string2Unicode(str);
    -- print('>>>>',str_tab, str)
    if ( font_align == nil ) then
        font_align = 1;
    end
    local font_tab = {};
    if str_tab and #str_tab > 0 then
        local first_font = MUtils:create_sprite(parent,base_path..string.format('%x',str_tab[1])..".png",x,y);
        font_tab[1] = first_font;
        local font_size = first_font:getContentSize();
        local half_width = font_size.width/2;
        local half_height = font_size.height/2;
        if ( font_align == 1 ) then
            for i=2,#str_tab do
                font_tab[i] = MUtils:create_sprite( first_font,base_path..string.format('%x',str_tab[i])..".png",half_width+(i-1)*font_size.width,half_height);
            end
        elseif ( font_align == 2 ) then
            for i=2,#str_tab do
                font_tab[i] = MUtils:create_sprite( first_font,base_path..string.format('%x',str_tab[i])..".png",half_width,half_height - (i-1)*(font_size.height-8));
            end
        end
        return first_font,font_tab;
    end
end

function MUtils:get_random_num( range_1,range_2 )
    local x = math.random(range_1,range_2);
    x = math.random(range_1,range_2);
    return x;
end

function MUtils:create_font_spr2( str,parent,x,y,base_path,align_x )
    local str_tab = string2Unicode(str);
    -- print('>>>>',str_tab, str)
    if ( font_align == nil ) then
        font_align = 1;
    end
    if align_x == nil then
        align_x = 0;
    end
    local font_tab = {};
    if str_tab and #str_tab > 0 then
        local first_font = MUtils:create_sprite(parent,base_path..string.format('%x',str_tab[1])..".png",x,y);
        font_tab[1] = first_font;
        local font_size = first_font:getContentSize();
        local half_width = font_size.width/2;
        local half_height = font_size.height/2;
        if ( font_align == 1 ) then
            for i=2,#str_tab do
                font_tab[i] = MUtils:create_sprite( first_font,base_path..string.format('%x',str_tab[i])..".png",half_width+(i-1)*(font_size.width+align_x),half_height);
            end
        end
        return first_font,font_tab;
    end
end

-- @brief 创建常用按钮,建议创建按钮都用这个函数！
-- @param parent 父类
-- @param btn_type 按钮类型 1,红色按钮
-- @param btn_str 按钮上的文字 
-- @param x,y 坐标 
-- @return 按钮
local BTN_PATH_TAB = {
    {[2] = "ui/common/button2_red.png",[4] = "ui/common/button_red.png"},
}
local FONT_BASE_PATH = "ui/font/"

function MUtils:createCommonBtn(parent,btn_type,btn_str,x,y,fun)
    local btn = nil;
    -- 中文要除于3
    local str_len = string.len(btn_str)/3;
    local btn_path = BTN_PATH_TAB[btn_type][str_len];
    local font_base_path = string.format("%s%d/",FONT_BASE_PATH,btn_type)
    if btn_type == 1 then
        btn = ZButton:create(parent,btn_path,fun,x,y);
        local btn_size = btn.view:getContentSize();
        local align_x = 2;
        local font_width = 27;
        local x = (btn_size.width - ((font_width+align_x)*str_len-align_x))/2 + font_width/2
        local y = btn_size.height/2;
        MUtils:create_font_spr2( btn_str,btn.view,x,y,font_base_path,align_x )
    end
    return btn;
end

--创建一个label，并且把label存储。使创建后可以动态修改显示的lable内容
function MUtils:create_lable( label, dimensions, item_pos_x , item_pos_y, fontsize, alignment, r, g, b, index , label_t)
    local labelttf = UILabel:create_label_1(label, dimensions, item_pos_x ,  item_pos_y, fontsize, alignment, r, g, b)
    if index ~= nil and label ~= nil then 
        label_t[ tostring(index) ] = labelttf
    end
    return labelttf
end

-- 创建一个选择控件
function MUtils:create_one_switch_but( x, y, w, h, image_n, image_s, words, words_x, fontsize, but_key ,callback)
    local function switch_button_func(  )
        callback( )
    end
    local switch_but = UIButton:create_switch_button( x, y, w, h, image_n, image_s, words, words_x, fontsize, nil, nil, nil, nil, switch_button_func )
    switch_but.but_key = but_key
    return switch_but
end

function MUtils.delay_phone_hideProgress(t)
    local c = callback:new()
    c:start_global(t, function() phone_hideProgress() end)
end