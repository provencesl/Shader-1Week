Shader "Custom/Shader8"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(0.0,255)) = 8.0 

	}
	SubShader
	{
		Pass
	{
		CGPROGRAM

#include "Lighting.cginc "



#pragma vertex vert
#pragma fragment frag 

		fixed4 _Diffuse;
	fixed4 _Specular;
	float _Gloss;






	struct a2f
	{

		float4 vertex : POSITION;
		float3 normal : NORMAL;

	};

	struct v2f
	{

		float4 vertex : SV_POSITION;
		float3 worldnormal :NORMAL;
		float3 worldPos : TEXCOORD1;

	};

	v2f vert(a2f o)
	{
		v2f v;

		v.vertex = UnityObjectToClipPos(o.vertex);

		v.worldnormal = normalize(mul(o.normal,(float3x3)unity_WorldToObject));

		v.worldPos = mul(unity_WorldToObject,o.vertex ).xyz;

		return v;
	}



	fixed4 frag(v2f v): SV_Target
	{
		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Diffuse;

	fixed3 worldLightColor = normalize(_WorldSpaceLightPos0.xyz);


	fixed3 normal = normalize(v.worldnormal);

	fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(normal,worldLightColor));

	fixed3 reflectDir = normalize(reflect(-worldLightColor,normal));

	fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - v.worldPos.xyz);


	fixed3 specular = _Specular.rgb * _LightColor0.rgb * pow(max(0.0,dot(reflectDir,viewDir)),_Gloss);


	fixed3 color = ambient+ diffuse + specular  ;

		return fixed4(color , 1.0);
	}







	ENDCG






	}








    }
    FallBack "Diffuse"
}
