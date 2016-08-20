tips={
    --分组配置 用于前端显示 subList中的id对应cardSubGroup里面的id
	cardGroup =
	{			
		{
			typeName = "汉室佳丽",
			subList = {1,},
		},
	},	
	--二级分组配置 特别注意！！！---> id必须连续
	cardSubGroup = {
		{
			id = 1,
			typeName = "沉鱼",
			--此处subList对应下面配置的cardSeriesGroup里面的seriesId
			subList = {1},
		},
	},
    --系列配置 特别注意！！！---> seriesId必须连续
	cardSeriesGroup = {	
		{
			seriesId = 1, --系列ID
			typeName = "沉鱼",
			subList =
			{
				1,2,3,4,--馆陶公主 卫少儿 王儿姁 傅昭仪 
				5,6,7,8-- 尹夫人 刘细君 赵合德 卫子夫
			},	
		},
	},
		--卡牌配置 特别注意！！！---> id必须连续
	cardConfig = {									
		{
			id = 1, --馆陶公主
			 typename="沉鱼",
             des="西汉皇室的馆陶大长公主,汉朝400年唯一的大长公主,地位在诸侯王之上,皇帝之下,称窦太主。",
             source = "",
		},			
	    {
            id = 2,--卫少儿
            typename="沉鱼",
            des="原是平阳公主府的侍女,后嫁于詹事陈掌。她的儿子是“匈奴未灭,何以家为”的霍去病。",
             source = "",

        },
        {
            id = 3,--王儿姁
            typename="沉鱼",
            des="中国西汉时期皇族女性,为汉景帝刘启妃嫔。她多愁伤感,妩媚妖娆,对他人不予信任。",
             source = "",

        },
         {
            id = 4,--傅昭仪
            typename="沉鱼",
            des="汉元帝刘奭的妃嫔,为人很有才识,善于处理人际关系,下至宫人左右,都为她祝酒祭地,愿她长寿。",
            source = "",
        },
         {
            id = 5,--尹夫人
            typename="沉鱼",
            des="汉武帝刘彻宠妃,与另一位妃嫔邢夫人于同一时期受宠,武帝下诏她们不得相见,以免互相争风呷醋。",
            source = "",
        },
         {
            id = 6,--刘细君
            typename="沉鱼",
            des="西汉宗室,知识渊博,多才多艺,其不卑不亢的性格赢得乌孙国上下的敬重。",
            source = "",
        },
         {
            id = 7,--赵合德
            typename="沉鱼",
            des="汉成帝刘骜宠妃,与姐姐赵飞燕(汉成帝第二任皇后)同侍皇帝,专宠后宫,享尽荣华富贵十余年。",
            source = "",
        },
          {
            id = 8,--卫子夫
            typename="沉鱼",
            des="汉武帝刘彻第二任皇后,在皇后位38年,谥号思。是中国历史上第一位拥有独立谥号的皇后。",
            source = "",
        },
     },
}