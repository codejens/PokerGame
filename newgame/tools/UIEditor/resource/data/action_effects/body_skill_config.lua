--普攻动作和特效配置表
body_normal_attack_config = 
{	
	--默认普通攻击配置，无特效
	--如果找不到body配置，就会用这个默认配置
	default_normal_attack = 
	{
		actions = {  		   --特效id		 --动作id
					 [1] = {   effect = 0,   act = 2,   },  
					 [2] = {   effect = 0,   act = 3,   },  
					 [3] = {   effect = 0,   act = 9,   }
				  }
	},
	-- body id
--   刀客(男)
	[1] = 
	{
		--skill id
		[5] = 
		{
				--actions				
				actions = {  		   --特效id		 --动作id
							 [1] = {   effect = 1000,   act = 1,  type = 2 }, 
							 [2] = {   effect = 1001, 	act = 2,  type = 2 }, 
							 [3] = {   effect = 1002,   act = 3,  type = 2 }, 				
						
						  }
		}
	},

--  枪士(女)
	[2] = 
	{	
		--skill id
		[15] = 
		{
				--actions				
				actions = {  		   --特效id		 --动作id
							 [1] = {   effect = 2100,   act = 32, type = 2 },  
							 [2] = {   effect = 2101,   act = 33, type = 2 }, 
							 [3] = {   effect = 2102,   act = 34, type = 2 }, 						 
						
						  }
		}
	},



--忍术-女
	[3] = 
	{	
		--skill id
		[25] = 
		{
				--actions				
				actions = {  		   --特效id		 --动作id
							 [1] = {   effect = 1705,   act = 15,  type = 3 },  
							 [2] = {   effect = 1705,   act = 16,  type = 3 }, 
							 [3] = {   effect = 1705,   act = 17,  type = 3 }, 						
						
						  }
		}
	},

--幻术--男
	[4] = 
	{	
		--skill id
		[35] = 
		{
				--actions				
				actions = {  		   --特效id		 --动作id
							 [1] = {   effect = 2505,   act = 49, type = 3 },  
							 [2] = {   effect = 2505,   act = 50, type = 3 }, 
							 [3] = {   effect = 2505,   act = 51, type = 3 }, 						 
						
						  }
		}
	},

}

