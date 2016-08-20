WeatherConfig = 
{
	['FlowerSnow'] = {
						type   = 'Snow',
						offset =  30,
						tick   =  0.25,
						file   =  {  'particle/LeafSnow.plist',
								     'particle/PetalSnow.plist',
								     'particle/RedPetalSnow.plist'}

					  }, 

	['HeavyRain'] = {
						type   = 'Snow',
						offset =  30,
						tick   =  0.25,
						file   =  {  'particle/HeavyRain.plist' }

					  }, 

					  
	['Lava']       =  {

						type   = 'Lava',
						offset =  30,
						tick   =  2.0,
						file   =  {  'particle/LavaSmoke.plist',
								     'particle/LavaBoom.plist' }
					  }, 

	['HeatWave']       =  {

						type   = 'Lava',
						offset =  -20,
						tick   =  2.0,
						file   =  {  'particle/Smoky.plist' }
					  }, 
	['Snow']       =  {

						type   = 'Snow',
						offset =  30,
						tick   =  0.25,
						file   =  {  'particle/Snow.plist' }
					  }, 
	['UnderWaterBubble']       =  {

						type   = 'Lava',
						offset =  30,
						tick   =  0.25,
						file   =  {  'particle/UnderWaterBubble.plist' }
					  }, 
					  
}

function WeatherConfig : create(root,key)
	local info = self[key]
	local ctor = _G[info.type]
	return ctor(root,info)
end