
local vertNoMVP = 
'										\
	attribute vec4 a_position;				\
	attribute vec2 a_texCoord;				\
	attribute vec4 a_color;					\
	#ifdef GL_ES							\
	varying lowp vec4 v_fragmentColor;		\
	varying mediump vec2 v_texCoord;		\
	#else									\
	varying vec4 v_fragmentColor;			\
	varying vec2 v_texCoord;				\
	#endif									\
	void main()								\
	{												\
   	 	gl_Position = CC_PMatrix * a_position;		\
    	v_fragmentColor = a_color;					\
    	v_texCoord = a_texCoord;					\
	}												\
'

shader_highlightPow = 
{
vert = vertNoMVP,
frag = 
'												\
	#ifdef GL_ES								\
	precision lowp float;						\
	#endif										\
	varying vec4 v_fragmentColor;				\
	varying vec2 v_texCoord;					\
	uniform vec4 u_intensity ;					\
	void main()									\
	{											\
   		gl_FragColor = pow(v_fragmentColor * texture2D(CC_Texture0, v_texCoord), u_intensity);					\
	}											\
'
}

shader_highlightAdd =
{
vert = vertNoMVP,
frag = 
'												\
	#ifdef GL_ES								\
	precision lowp float;						\
	#endif										\
	varying vec4 v_fragmentColor;				\
	varying vec2 v_texCoord;					\
	uniform vec4 u_baseColor;					\
	void main()									\
	{											\
   		gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);					\
   		gl_FragColor = gl_FragColor + u_baseColor*gl_FragColor.a;					\
	}											\
'
}

shader_highlightMult =
{
vert = vertNoMVP,
frag = 
'												\
	#ifdef GL_ES								\
	precision lowp float;						\
	#endif										\
	varying vec4 v_fragmentColor;				\
	varying vec2 v_texCoord;					\
	uniform vec4 u_multColor;					\
	void main()									\
	{											\
   		gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord) * u_multColor;					\
	}											\
'
}


shader_inverse = 
{
vert = vertNoMVP,
frag = 
'												\
	#ifdef GL_ES								\
	precision lowp float;						\
	#endif										\
	varying vec4 v_fragmentColor;				\
	varying vec2 v_texCoord;					\
	void main()									\
	{											\
   		gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);					\
   		gl_FragColor.rgb = (1 - gl_FragColor.rgb)*gl_FragColor.a;					\
	}											\
'
}

shader_normal = 
{
	vert = vertNoMVP,
	frag = 
	'												\
	varying vec4 v_fragmentColor;					\
	varying vec2 v_texCoord;						\
	uniform sampler2D u_normalMap;					\
	const float   u_kBump = 1.0;							\
	uniform vec4  u_lightPosInLocalSpace;			\
	uniform vec2  u_contentSize;					\
	uniform vec3  u_diffuseL;						\
	void main(void)									\
	{												\
    	vec4 texColor=texture2D(CC_Texture0, v_texCoord);	\
    	vec3 normal=texture2D(u_normalMap, v_texCoord).rgb;	\
		normal=normal*2.0-1.0;								\
		normal.y=-normal.y;									\
		if(u_kBump!=1.0)									\
		{													\
      	  	//if the vertex.z mult kBump, then the normal.z should div kBump and re-normalize	\
        	normal=vec3(normal.x,normal.y,normal.z/u_kBump);	\
        	normal=normalize(normal);							\
    	}			\
    	//vec4 lightPos = u_lightPosInLocalSpace;											\
    	//lightPos.x = lightPos.x + u_contentSize.x*(0.5 + 0.5*cos(CC_Time.y));\
    	//lightPos.y = lightPos.y + u_contentSize.x*(0.5 + 0.5*sin(CC_Time.y));\
 		vec4 curPixelPosInLocalSpace=vec4(v_texCoord.x*u_contentSize.x,(1.0-v_texCoord.y)*u_contentSize.y,0.0,1.0);\
		vec4 lightDir=normalize(curPixelPosInLocalSpace-u_lightPosInLocalSpace);	\
		vec3 posToLight=-lightDir.xyz;												\
		float normDotPosToLight=max(0.0,dot(normal,posToLight));					\
		vec4 diffuse=vec4(normDotPosToLight*u_diffuseL,1.0);						\
		vec4 ambient=vec4(0.5,0.5,0.5,1);											\
		gl_FragColor=texColor*vec4(vec3(diffuse+ambient),diffuse.a);				\
	}																				\
	'
}

shader_bloom = 
{
	vert = vertNoMVP,
	frag = 
	'								\
	#ifdef GL_ES					\
	precision mediump float;		\
	#endif							\
									\
	varying vec4 v_fragmentColor;	\
	varying vec2 v_texCoord;		\
									\
	uniform vec2 resolution;		\
									\
										\
	const float blurSize = 1.0/512.0;	\
	const float intensity = 0.65;		\
	void main()							\
	{									\
   		vec4 sum = vec4(0);				\
   		vec2 texcoord = v_texCoord.xy;	\
   		int j;							\
   		int i;							\
   										\
   		//thank you! http://www.gamerendering.com/2008/10/11/gaussian-blur-filter-shader/ for the \
   		//blur tutorial																						\
   		// blur in y (vertical)																				\
   		// take nine samples, with the distance blurSize between them										\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x - 4.0*blurSize, texcoord.y)) * 0.05;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x - 3.0*blurSize, texcoord.y)) * 0.09;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x - 2.0*blurSize, texcoord.y)) * 0.12;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x - blurSize, texcoord.y)) * 0.15;						\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y)) * 0.16;									\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x + blurSize, texcoord.y)) * 0.15;						\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x + 2.0*blurSize, texcoord.y)) * 0.12;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x + 3.0*blurSize, texcoord.y)) * 0.09;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x + 4.0*blurSize, texcoord.y)) * 0.05;					\
																											\
		// blur in y (vertical)																				\
   		// take nine samples, with the distance blurSize between them										\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y - 4.0*blurSize)) * 0.05;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y - 3.0*blurSize)) * 0.09;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y - 2.0*blurSize)) * 0.12;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y - blurSize)) * 0.15;						\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y)) * 0.16;									\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y + blurSize)) * 0.15;						\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y + 2.0*blurSize)) * 0.12;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y + 3.0*blurSize)) * 0.09;					\
   		sum += texture2D(CC_Texture0, vec2(texcoord.x, texcoord.y + 4.0*blurSize)) * 0.05;					\
   																											\
   		//increase blur with intensity!																		\
  	 	gl_FragColor = sum*intensity + texture2D(CC_Texture0, texcoord); 									\
		}																									\
	'
}

shader_blur = 
{
	vert = vertNoMVP,
	frag = 
	'										\
		#ifdef GL_ES						\
			precision mediump float;		\
		#endif								\
											\
		varying vec4 v_fragmentColor;		\
		varying vec2 v_texCoord;			\
											\
		uniform vec2 u_contentSize;			\
		uniform float u_blurRadius;			\
		uniform float u_sampleNum;			\
											\
		vec4 blur(vec2);					\
											\
		void main(void)						\
		{														\
			vec4 col = blur(v_texCoord);						\
			gl_FragColor = col * v_fragmentColor;	\
		}														\
																\
		vec4 blur(vec2 p)										\
		{														\
    		if (u_blurRadius > 0.0 && u_sampleNum > 1.0)			\
    		{													\
       			vec4 col = vec4(0);								\
        		vec2 unit = 1.0 / u_contentSize.xy;				\
        														\
        		float r = u_blurRadius;							\
        		float sampleStep = r / u_sampleNum;				\
        														\
        		float count = 0.0;								\
        														\
        		for(float x = -r; x < r; x += sampleStep)	\
            	{																		\
                	float weight = r *(r - abs(x));										\
                	col += texture2D(CC_Texture0, p + vec2(x * unit.x, 0)) * weight;	\
                	count += weight;													\
            	}																		\
																							\
            	for(float y = -r; y < r; y += sampleStep)	\
            	{																					\
               		float weight = (r - abs(y)) * r;												\
                	col += texture2D(CC_Texture0, p + vec2(0, y * unit.y)) * weight;				\
                	count += weight;																\
            	}																					\
            	return col / count;																	\
    		}																							\
    																									\
    		return texture2D(CC_Texture0, p);															\
		}																								\
	'
}


shader_edgeDetection = 
{
	vert = vertNoMVP,
	frag = 
	'																		\
		#ifdef GL_ES														\
		precision mediump float;											\
		#endif																\
																			\
		varying vec4 v_fragmentColor;										\
		varying vec2 v_texCoord;											\
																			\
		uniform vec2 u_contentSize;											\
																			\
		float lookup(vec2 p, float dx, float dy)							\
		{																	\
    		vec2 uv = p.xy + vec2(dx , dy ) / u_contentSize.xy;				\
    		vec4 c = texture2D(CC_Texture0, uv.xy);							\
    		return 0.2126*c.r + 0.7152*c.g + 0.0722*c.b;					\
		}																	\
																			\
		void main(void)														\
		{																	\
    		vec2 p = v_texCoord.xy;											\
    		// simple sobel edge detection 									\
    		float gx = 0.0;													\
    		gx += -1.0 * lookup(p, -1.0, -1.0);								\
    		gx += -2.0 * lookup(p, -1.0,  0.0);								\
    		gx += -1.0 * lookup(p, -1.0,  1.0);								\
    		gx +=  1.0 * lookup(p,  1.0, -1.0);								\
    		gx +=  2.0 * lookup(p,  1.0,  0.0);								\
    		gx +=  1.0 * lookup(p,  1.0,  1.0);								\
    																		\
   	 		float gy = 0.0;													\
    		gy += -1.0 * lookup(p, -1.0, -1.0);								\
    		gy += -2.0 * lookup(p,  0.0, -1.0);								\
    		gy += -1.0 * lookup(p,  1.0, -1.0);								\
    		gy +=  1.0 * lookup(p, -1.0,  1.0);								\
    		gy +=  2.0 * lookup(p,  0.0,  1.0);								\
    		gy +=  1.0 * lookup(p,  1.0,  1.0);								\
    																		\
    		float g = gx*gx + gy*gy;										\
    																		\
    		gl_FragColor.xyz = vec3(g);										\
    		gl_FragColor.w = length(g);										\
			}																\
	'
}

shader_outLine =
{
	vert = vertNoMVP,
	frag = 
	'								\
	varying vec2 v_texCoord;		\
	varying vec4 v_fragmentColor;	\
									\
	uniform vec3 u_outlineColor;	\
	uniform float u_threshold;		\
	uniform float u_radius;			\
									\
	void main()						\
	{								\
    	float radius = u_radius;	\
    	vec4 accum = vec4(0.0);		\
    	vec4 normal = vec4(0.0);	\
    								\
    	normal = texture2D(CC_Texture0, vec2(v_texCoord.x, v_texCoord.y));				\
    																								\
    	accum += texture2D(CC_Texture0, vec2(v_texCoord.x - radius, v_texCoord.y - radius));		\
    	accum += texture2D(CC_Texture0, vec2(v_texCoord.x + radius, v_texCoord.y - radius));		\
    	accum += texture2D(CC_Texture0, vec2(v_texCoord.x + radius, v_texCoord.y + radius));		\
    	accum += texture2D(CC_Texture0, vec2(v_texCoord.x - radius, v_texCoord.y + radius));		\
    																								\
    	accum *= u_threshold;																		\
    	accum.rgb =  u_outlineColor * accum.a;														\
    	accum.a = length(accum.rgb);																				\
    																								\
    	normal = ( accum * (1.0 - normal.a)) + (normal * normal.a);									\
    																								\
    	gl_FragColor = v_fragmentColor * normal;													\
	}																								\
	'
}

shader_AdjustHVS = 
{
	vert = vertNoMVP,
	frag = 
	'																	\
		varying vec2 v_texCoord;										\
		varying vec4 v_fragmentColor;									\
																		\
		uniform float u_HugeOffset;									\
		uniform float u_SaturationPer;									\
		uniform float u_ValuePer;									\
		vec3 RGBtoHSV(float r, float g, float b)						\
		{																\
    		float minv, maxv, delta;									\
    		vec3 res;													\
   																		\
    		minv = min(min(r, g), b);									\
    		maxv = max(max(r, g), b);									\
   			res.z = maxv;            // v 								\
   																		\
    		delta = maxv - minv;										\
   																		\
    		if( maxv != 0.0 )											\
        		res.y = delta / maxv;      // s 						\
    		else 														\
    			{														\
        			// r = g = b = 0      // s = 0, v is undefined		\
        			res.y = 0.0;										\
        			res.x = -1.0;										\
        			return res;											\
    			}														\
   																		\
    		if( r == maxv )												\
        		res.x = ( g - b ) / delta;      // between yellow & magenta \
    		else if( g == maxv )											\
        		res.x = 2.0 + ( b - r ) / delta;   // between cyan & yellow	\
    		else															\
        		res.x = 4.0 + ( r - g ) / delta;   // between magenta & cyan \
   																			\
    		res.x = res.x * 60.0;            // degrees						\
    		if( res.x < 0.0 )												\
        		res.x = res.x + 360.0;										\
   																			\
    		return res;														\
		}																	\
																			\
																			\
		vec3 HSVtoRGB(float h, float s, float v)							\
		{																	\
	    	int i;															\
	    	float f, p, q, t;												\
    		vec3 res;														\
   																			\
    		if( s == 0.0 )													\
    		{																\
       			// achromatic (grey)										\
        		res.x = v;													\
        		res.y = v;													\
        		res.z = v;													\
        		return res;													\
    		}																\
   																			\
    		h /= 60.0;         // sector 0 to 5								\
    		i = int(floor( h ));											\
    		f = h - float(i);         // factorial part of h 				\
    		p = v * ( 1.0 - s );											\
    		q = v * ( 1.0 - s * f );										\
    		t = v * ( 1.0 - s * ( 1.0 - f ) );								\
   																			\
    		if(i == 0) {													\
        		res.x = v;													\
        		res.y = t;													\
        		res.z = p;													\
    		}																\
    		else if(i == 1) {												\
        		res.x = q;													\
        		res.y = v;													\
        		res.z = p;													\
    		}																\
    		else if(i == 2) {												\
        		res.x = p;													\
        		res.y = v;													\
        		res.z = t;													\
    		}																\
    		else if(i == 3) {												\
        		res.x = p;													\
        		res.y = q;													\
        		res.z = v;													\
    		}																\
    		else if(i == 4) {												\
        		res.x = t;													\
        		res.y = p;													\
        		res.z = v;													\
    		}																\
    		else {															\
        		res.x = v;													\
        		res.y = p;													\
        		res.z = q;													\
    		}																\
    																		\
    		return res;														\
		}																	\
																			\
		void main()															\
		{																	\
			vec4 texColor = texture2D(CC_Texture0, v_texCoord);				\
			vec3 hsv = RGBtoHSV(texColor.r, texColor.g, texColor.b);		\
			hsv.x = mod(hsv.x + u_HugeOffset, 360);							\
			hsv.y = hsv.y*(1 + u_SaturationPer);							\
			hsv.z = hsv.z*(1 + u_ValuePer);									\
			texColor.rgb = HSVtoRGB(hsv.x, hsv.y, hsv.z);					\
			gl_FragColor = texColor;										\
		}																	\
	'
}

