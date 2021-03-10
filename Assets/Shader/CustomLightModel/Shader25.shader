Shader "Custom/Shader25"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (0.8,0.8,0.8,0.8)
		_SpecularSmoothStep("SpecularSmoothStep",Range(0,1)) = 0.01






	}
	SubShader
	{
		Tags {"LightMode" = "ForwardBase"}
	 Pass
		{
		
		CGPROGRAM

			#pragma vertex vert
				#pragma fragment frag


#include "UnityCG.cginc"
#include "Lighting.cginc"
		


		struct v2f
			{
				fixed4 vertex : SV_POSITION;
				fixed3 normal : NORMAL;
				fixed3 viewDir : TEXCOORD0;
			};

		struct a2f
		{
			fixed4 vertex : POSITION;
			fixed3 normal : NORMAL;

		};


		fixed4 _Diffuse;
		fixed4 _Specular;
		float _SpecularSmoothStep;
	



		v2f vert(a2f a)
		{

			v2f v;
			v.vertex = UnityObjectToClipPos(a.vertex);
			v.normal = UnityObjectToWorldNormal(a.normal);
			v.viewDir = WorldSpaceViewDir(a.vertex);




			return v;
		}

		fixed4 frag(v2f a): SV_Target
		{
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

		fixed3 viewDir = normalize(a.viewDir);

		fixed3 normal = normalize(a.normal);

		fixed3 light = normalize(_WorldSpaceLightPos0.rgb);
	
	

		fixed3 NDotL = dot(light, normal);





	




		fixed3 lightIntensity = smoothstep(0, 0.1, NDotL);

		
		fixed3 SpecularIntensity = smoothstep(lightIntensity - _SpecularSmoothStep,lightIntensity + _SpecularSmoothStep, lightIntensity * dot(light, normal));
		


		fixed3 diffuse = _Diffuse.rgb * _LightColor0.rgb * NDotL;









		fixed3 finalColor = (_LightColor0.rgb* diffuse   ) + SpecularIntensity   ;






			return fixed4(finalColor,1.0);
		}



		ENDCG

		}


    }
    FallBack "Diffuse"
}
