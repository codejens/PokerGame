temp = {--新手村场景配置
{
	--场景1
	--这个id必须每次递增，比如第一个场景id是0，下一个一定是1，类推
	scenceid = 1,
	--场景名称
	scencename = Lang.SceneName.s1,
	--场景对应的地图,只需要填文件名，不需要写路径和后缀名，比如这个地图文件是map/demo.jxm，只需要写demo
	mapfilename = "yyw",
	--限制等级,低于这个等级无法进入
	minlevel = 0,
	--限制物品，这是一个数字列表，代表有这些物品的玩家不能进入
	forbiddenitem = {},
	--限制的技能列表，有这些技能的玩家不能进入
	forbiddenskill = {},
	--0表示可以pk，1表示不可以，默认是0
	nopk = 1,
	progress = 0,
	music = "yewaiqingxin.mp3", 
	musicInterval=5,
        --在世界地图上的坐标x
        worldmapPosx =0,
        worldmapPosy =0,
        --场景的长宽,是指格子数的长宽
        sceneWidth =79,
        sceneHeight =99,

	poetry = Lang.SceneName.s1,
	area = 
	{
		{ name = Lang.SceneName.s1, range = { 0,0,79,0,79,99,0,99}, center = { 28,16},
		    attri = { 
		      {type= 46 ,value = {}},
              {type= 50 ,value = {0}},		  
					}
		},			
	},
	--refresh项用来配置这个场景的刷怪点，每个场景可以有多个刷怪点，可以用include包含多个刷怪点

     
 refresh =
{
--#include "refresh1.txt"  	  
},
	--这里配置这个场景出现的NPC，如果有多个NPC，这配置多行，每一项（行）表示一个NPC
	npc ={
{posx=47, posy=20, name=Lang.EntityName.n57, icon=1, modelid=1, script="data/script/yueyawan/shanbao.txt", },
{posx=69, posy=37, name=Lang.EntityName.n25, icon=2, modelid=23, script="data/script/yueyawan/laozhongyi.txt", },
{posx=16, posy=46, name=Lang.EntityName.n3, icon=3, modelid=25, script="data/script/yueyawan/cunzhang.txt", },
{posx=29, posy=59, name=Lang.EntityName.n3004, icon=4, modelid=19, script="data/script/yueyawan/xiyuqixia.txt", },
{posx=72, posy=77, name=Lang.EntityName.n55, icon=5, modelid=5, script="data/script/yueyawan/longtianxiang.txt", },
{posx=39, posy=88, name=Lang.EntityName.n29, icon=6, modelid=21, script="data/script/yueyawan/minbing.txt", },

},
teleport ={
{posx=41, posy=58, name=Lang.SceneName.s1, effect=20, modelid=50001, toPosx=60, toPosy=81, toSceneid=1, },
{posx=28, posy=95, name=Lang.SceneName.s2, modelid=50000, toPosx=7, toPosy=73, toSceneid=2, },

},
},}