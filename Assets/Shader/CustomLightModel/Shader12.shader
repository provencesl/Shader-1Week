Shader "Custom/Shader12"
{
    Properties
    {
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200
		Pass
		{
			CGPROGRAM
     
#pragma vertex vert
#pragma fragment frag 
#include "UnityCG.cginc "

#include "Lighting.cginc"


			struct v2f
			{
			float4 vertex :SV_POSITION;
			float3 normal : NORMAL;

			};


	struct a2f
	{
		float4 vertex :POSITION;
		float3 normal : NORMAL;

	};


	fixed4 _Diffuse;







	v2f vert(a2f v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.normal = UnityObjectToWorldNormal(v.normal);



		return o;
	}


	fixed4 frag(v2f v): SV_Target
	{
		fixed3 normal = normalize(v.normal);
	fixed3 light =normalize(_WorldSpaceLightPos0.xyz);


	fixed3 NDotL = dot(light, normal);




	fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

	fixed3 diffuse = NDotL * _Diffuse.rgb;















	fixed3 color = ambient + diffuse;






		return fixed4(color,1.0);
	}






			ENDCG



		}





     
    }
    FallBack "Diffuse"
}
