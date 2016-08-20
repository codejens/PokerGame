-- TaskStruct.lua
-- create by hcl on 2013-1-17
-- 任务的数据结构

super_class.TaskStruct()

function TaskStruct:__init( pack ,_task_id)
	if ( pack )then
		self.task_id = pack:readWord();			    -- 任务id
		self.task_process_num = pack:readWord();	-- 任务进度值的数量，如果是有时间限制的任务，最后一个值是剩余的时间
		self.tab_process = {};
		for i=1,self.task_process_num do
			self.tab_process[i] = pack:readInt();	--进度值
		end
		-- ZXLog('-------------self.task_id-----111---------',self.task_id)
	else
		self.task_id = _task_id;			        -- 任务id
		self.task_process_num = 0;	                -- 任务进度值的数量，如果是有时间限制的任务，最后一个值是剩余的时间
		self.tab_process = {};
		-- ZXLog('-------------self.task_id-----222---------',self.task_id)
	end

end

