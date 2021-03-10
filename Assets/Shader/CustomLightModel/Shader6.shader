Shader "Custom/Shader6"
{
	Properties
	{
		_SpecularColor("SpecularColor",Color) = (1,1,1,1)
		_Shineness("Shineness",Range(0,32)) = 8
		

	}
	SubShader
	{
	   Pass
	{

		CGPROGRAM

#pragma multi_compile_fwdbase
#pragma vertex vert
#pragma fragment frag 

#include "UnityCG.cginc"

#include "Lighting.cginc"


float4 _SpecularColor;
	float _Shineness;







			struct v2f
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				 
			};

			v2f vert(appdata_base  v)
			{
				v2f o;


				o.vertex = UnityObjectToClipPos(v.vertex);

				float3 L = normalize(WorldSpaceViewDir(v.vertex));
				float3 N = UnityObjectToWorldNormal(v.normal);
				float3 V = normalize(WorldSpaceViewDir(v.vertex));

				o.color = UNITY_LIGHTMODEL_AMBIENT;

				float NDotL = dot(N, L);
				o.color += _LightColor0 * NDotL;

				float3 H = L + V;


				H = normalize(H);

				float specularScale = pow(saturate(dot(H,N)) , _Shineness);




				o.color.rgb += _SpecularColor * specularScale;

				return o;

			}



			fixed4 frag(v2f IN) : COLOR
			{
				return IN.color + UNITY_LIGHTMODEL_AMBIENT;
			}












        ENDCG
	}
 
    }
  
}
