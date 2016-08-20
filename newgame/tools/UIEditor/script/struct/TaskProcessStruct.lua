-- TaskProcessStruct.lua
-- create by hcl on 2013-1-17
-- 任务的数据结构

super_class.TaskProcessStruct()

function TaskProcessStruct:__init( pack ,_task_id)
	if ( pack )then
		self.task_id = pack:readWord();			-- 任务id
		self.task_process_num = pack:readWord();	-- 任务进度值的数量，如果是有时间限制的任务，最后一个值是剩余的时间
		self.tab_process = {};
		--print("新的进度....task_id = ",self.task_id,"进度数量= ",self.task_process_num);
		for i=1,self.task_process_num do
			self.tab_process[i] = pack:readInt();	--进度值
		--	print("self.tab_process[i]",self.tab_process[i])
		end
		self.start_time = math.floor(os.clock());
		--print("self.start_time...................... = ",self.start_time)
		if( self.task_process_num > 1 ) then

			self.time = self.tab_process[self.task_process_num];
		end
		
	else
		self.task_id = _task_id;			-- 任务id
		self.task_process_num = 0;	-- 任务进度值的数量，如果是有时间限制的任务，最后一个值是剩余的时间
		self.tab_process = {};
		self.start_time = math.floor(os.clock());
	end
	return self;
end

