-- NumView.lua
-- created by hcl on 2014/3/11
-- 用来播放数字动画的控件

super_class.NumView()

local NUM_FILE_PATH = "ui/fonteffect/f_g";
local NUM_WIDTH = 12;
local NUM_HEIGHT = 18;

function NumView:create( num,parent,x,y,speed )
    local view = NumView(num,parent,x,y,speed);
    return view;
end

function NumView:__init(num,parent,x,y,speed)
    self.view = ZBasePanel:create(parent,"",x,y,50,50);
    -- 当前数字
    self._currNum = 0;
    -- 目标数字
    self._tNum = 0;
    -- 保存数字精灵的控件 索引1存储的是个位数2存储的是十位数
    self._numSprTable = {};
    -- 每0.05秒增加多少数
    self._numSpeed = 100;
    if speed then
        self._numSpeed = speed;
    end
    self:update_num(num); 
end

-- 计算数字的位数
local function calNumDigit( num )
    if num > 9 then
        return math.floor(math.log10(num) )+1
    end
    return 1;
end

-- 更新逻辑
function NumView:update_num( target_num )
    -- 要删除掉当前比目标位数多的位数
    local oldDigit = calNumDigit(self._currNum);
    local tarDigit = calNumDigit(target_num);
    if tarDigit < oldDigit then
        -- print("oldDigit,tarDigit",oldDigit,tarDigit,"self._currNum = ",self._currNum,target_num)
        for i=tarDigit+1,oldDigit do
             -- print("i",i)
            -- 是否存在旧数字 如果存在的话就删除掉他
            if self._numSprTable[i].old_view then
                self._numSprTable[i].old_view.view:removeFromParentAndCleanup(true);
                self._numSprTable[i].old_view = nil;
            end
            -- 是否存在新数字 如果存在，就把它变成旧数字
            if self._numSprTable[i].new_view then
                self._numSprTable[i].new_view.view:removeFromParentAndCleanup(true);
                self._numSprTable[i].new_view = nil;
            end
        end
    end
    target_num = math.max(target_num,0);

    self._numSpeed = math.max( math.floor( (target_num - self._currNum)/10 ),1 );
    self._tNum = target_num;
    -- print("NumView:update_num( target_num )",target_num,self._tNum,self._numSpeed)

    if self._timer then
        self._timer:stop();
        self._timer = nil;
    end
    self._timer = timer();

    local function fun( dt )
        local num = self._currNum + self._numSpeed;
        if num >= self._tNum then
            num = self._tNum;
        end
        self._currNum = num;
        local currDigit = calNumDigit( num );

        -- print("currDigit = ",currDigit,num);
        local temp_num = num;
        -- 创建图片 索引1存储的是个位数2存储的是十位数
        for i=1,currDigit do
            local n = math.floor(temp_num / math.pow(10,currDigit-i));
            local view_index = currDigit-i+1;
            -- print("n = ",n,"view_index = ",view_index,"temp_num=",temp_num)
            if ( self._numSprTable[view_index] ) then
                -- 是否存在旧数字 如果存在的话就删除掉他
                if self._numSprTable[view_index].old_view then
                    self._numSprTable[view_index].old_view.view:removeFromParentAndCleanup(true);
                    self._numSprTable[view_index].old_view = nil;
                end
                -- 是否存在新数字 如果存在，就把它变成旧数字
                if self._numSprTable[view_index].new_view then
                    self._numSprTable[view_index].old_view = self._numSprTable[view_index].new_view;
                    self._numSprTable[view_index].old_view.view:setOpacity(160);
                end
            else
                self._numSprTable[view_index] = {};
            end
            self._numSprTable[view_index].new_view = ZCCSprite:create( self.view,string.format("%s%d.png",NUM_FILE_PATH,n)
                , NUM_WIDTH/2 + (i-1)*NUM_WIDTH,NUM_HEIGHT/2);
            self._numSprTable[view_index].new_view.view:setScale(0.8)
            temp_num = temp_num - math.pow(10,currDigit-i)*n;
        end
        -- print("num = ",num,"self._tNum",self._tNum);
        if num == self._tNum then
            self._timer:stop();
            self._timer = nil;
            for i=1,currDigit do
                if self._numSprTable[i].old_view then
                    self._numSprTable[i].old_view.view:removeFromParentAndCleanup(true);
                    self._numSprTable[i].old_view = nil;
                end
            end
        end
    end
    self._timer:start(0.05,fun)
end

function NumView:getPositionY(  )
    local ccp = self.view:getPosition();
    return ccp.y;
end

function NumView:destroy()
    if self._timer then
        self._timer:stop();
        self._timer = nil;  
    end
end



