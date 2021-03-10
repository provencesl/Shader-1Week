// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Shader7"
{
	Properties
	{
		_Diffuse("Diffuse",Color) =(0.5,0.5,0.5,0.5)
		_Specular("Specular",Color) =(0.7,0.7,0.7,0.7)
		_Gloss("Gloss",Range(1.0,255)) = 20


	}
	SubShader
	{


	  Pass
	{

		Tags{"LightingMode" = "ForwardBase"}


		CGPROGRAM

#include "Lighting.cginc"

#pragma vertex vert
#pragma fragment frag 



		fixed4 _Diffuse;
		fixed4 _Specular;
		float _Gloss;


		struct a2v
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
		};

		struct v2f
		{
			float4 vertex: SV_POSITION;
			float3 worldNormal : NORMAL;
			float3 worldPos : TEXCOORD0;
		};



		v2f vert(a2v v)
		
				
		{
			v2f o;

			o.vertex = UnityObjectToClipPos(v.vertex);

			o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));



			o.worldPos = mul(unity_WorldToObject,v.vertex).xyz;

			return o;
		}




		fixed4 frag (v2f v) : SV_Target
		{
			fixed3 lightAmbient = UNITY_LIGHTMODEL_AMBIENT.xyz  * _Diffuse ;

		fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

		fixed3 normal = normalize(v.worldNormal);

		fixed3 diffuse = _LightColor0.rgb * saturate(dot(worldLight,normal)) *  _Diffuse.rgb ;

		fixed3 reflectDir = normalize(reflect(-worldLight,normal));

		fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - v.worldPos.xyz);

		fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0.0,dot(reflectDir,viewDir )),_Gloss);



		fixed3 color = diffuse + lightAmbient + specular  ;


		return fixed4(color,1.0);


		}



	
		ENDCG
	}

    }
   
		FallBack "Diffuse"


}
