Shader "Custom/Shader14"
{
	Properties
	{
		_MainTex("MainTex",2D) = "white"{}
		_Diffuse("Diffuse",Color) = (1,1,1,1)
			_RimColor("RimColor",Color) = (1,1,1,1)
			_RimPower("RimPower",Range(0.0,10.0)) = 0.3
			_RimIntensity("RimIntensity",Range(0.0,50)) = 3

	}
	SubShader
	{


		Pass
			{
				CGPROGRAM

			#pragma vertex vert

			#pragma fragment frag

			#include "UnityCG.cginc"

#include "Lighting.cginc"


				struct a2f
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
					float3 normal : NORMAL;

				};

				struct v2f 
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
					float3 worldNormal : NORMAL;
					float4 worldPos : TEXCOORD1;

				};

				sampler2D _MainTex;
				float4 _MainTex_ST;
				fixed4 _Diffuse;
				float4 _RimColor;
				float _RimPower;
				float _RimIntensity;





				v2f vert(a2f a)
				{
					v2f o;

					float4 worldPos;


					o.vertex = UnityObjectToClipPos(a.vertex);

					o.uv = TRANSFORM_TEX(a.uv, _MainTex);

					o.worldPos = mul(unity_ObjectToWorld, a.vertex);

					o.worldNormal = mul(a.normal,(float3x3)unity_WorldToObject);

					return o;

				}


				fixed4 frag(v2f i): SV_Target
				{

					fixed4 color = tex2D(_MainTex,i.uv);
					
					fixed3 worldNormal = normalize(i.worldNormal);
					
					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);


					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * _Diffuse.xyz;


		


					fixed halfLambert = dot(worldNormal, worldLightDir) * 0.5 + 0.5;

					fixed3 diffuse = _LightColor0.rgb * _Diffuse.xyz * halfLambert + ambient;


					float3 worldviewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);


					float rim = 1 - max(0,dot(worldviewDir, worldNormal));



					fixed3 rimColor = _RimColor.rgb * pow(rim, 1 / _RimPower) * _RimIntensity;






					fixed3 finalColor = color.rgb * diffuse + rimColor;
						return fixed4(finalColor,1.0);

				}

				ENDCG

			}
    }
    FallBack "Diffuse"
}
