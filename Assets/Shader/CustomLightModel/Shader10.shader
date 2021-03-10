Shader "Custom/Shader10"
{
	Properties
	{

		_Diffuse("Diffuse",Color) = (1,1,1,1)



	}
	SubShader
	{


		Pass
		{

		Tags{"LightMode" = "ForwardBase"}



			CGPROGRAM

			#include "Lighting.cginc"

#pragma vertex vert 
#pragma fragment frag 



		fixed4 _Diffuse;



		struct a2f 
		{
		
		float4 vertex : POSITION;
		float3 normal : NORMAL;

		};

		struct v2f
		{
			float4 vertex : SV_POSITION;
			float3 worldNormal: TEXCOORD0;
			float3 worldVertex : TEXCOORD1;

		};


		v2f vert(a2f v)
		{
			v2f o;

			o.vertex = UnityObjectToClipPos(v.vertex);


			o.worldNormal = mul(v.normal,(float3x3)unity_WorldToObject);

			o.worldVertex = mul(v.vertex,unity_WorldToObject).xyz;

			return o;
		}



		fixed4 frag(v2f i) : SV_Target
		{
			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;

		fixed3 normalDir = normalize(i.worldNormal);

		fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

		fixed3 diffuse = _LightColor0.rgb * max(0,dot(lightDir,normalDir)) *_Diffuse.rgb ;





		fixed3 albedo = ambient + diffuse;

		return fixed4(albedo ,1.0);


		}









            ENDCG
        }
    }
		FallBack"VertexLit"



}
