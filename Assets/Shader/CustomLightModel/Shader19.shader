Shader "Custom/Shader19"
{
    Properties
    {
		_MainTex("MainTextures",2D) = "white"{}
	_Color("Color", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8.0,255.0)) = 16.0

		_BumpTex("BumpTex", 2D) = "bump"{}

	_BumpScale("BumpScale", Float) = 1.0


    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
			{

		Tags{"LightMode" = "ForwardBase"}


				CGPROGRAM
  
				#pragma vertex vert
				#pragma fragment frag


				#include "Lighting.cginc"
#include "UnityCG.cginc"


			struct a2f
				{
					float4 vertex : POSITION;
					float3 normal : NORMAL;
					float4 tangent : TANGENT;
					float2 uv : TEXCOORD0;
				
				};

			struct v2f
				{
					float4 vertex : SV_POSITION;
					float4 uv : TEXCOORD0;
					float3 lightDir : TEXCOORD1;
					float3 viewDir : TEXCOORD2;
				};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Specular;
			fixed4 _Color;
			sampler2D _BumpTex;
			float4 _BumpTex_ST;
			float _Gloss;
			float _BumpScale;

			v2f vert(a2f v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.uv.xy = TRANSFORM_TEX(v.uv,_MainTex);
				o.uv.zw = TRANSFORM_TEX(v.uv, _BumpTex);
				//	float3 binormal = cross( normalize(v.normal), normalize(v.tangent.xyz)) * v.tangent.w;
				float3 binormal = cross(normalize(v.normal),normalize(v.tangent.xyz))* v.tangent.w;

				float3x3 objectToTangentMat = float3x3(  v.tangent.xyz,binormal,v.normal);


				o.lightDir = mul(objectToTangentMat,ObjSpaceLightDir(v.vertex)).xyz;
				o.viewDir = mul(objectToTangentMat,ObjSpaceViewDir(v.vertex)).xyz;


				return o;
			}

		fixed4 frag(v2f v): SV_Target
		{
			fixed3 tangentLightDir = normalize(v.lightDir);
			fixed3 tangentViewDir = normalize(v.viewDir);

			fixed4 packedNormal = tex2D(_BumpTex,v.uv.zw);

			fixed3 tangentNormal = UnpackNormal(packedNormal);


			tangentNormal.xy *= _BumpScale;

			tangentNormal.z = sqrt(1- saturate(dot(tangentNormal.xy,tangentNormal.xy)));


			fixed3 albedo = tex2D(_MainTex,v.uv.xy ).rgb * _Color.rgb;
			fixed3 ambient = albedo * UNITY_LIGHTMODEL_AMBIENT.xyz;

			fixed3 diffuse = _LightColor0.rgb * albedo * saturate(dot(tangentNormal, tangentLightDir));

			fixed3 halfDir = normalize(tangentNormal + tangentViewDir);

			//fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(tangentNormal, halfDir)), _Gloss);

			fixed3 specular = _LightColor0.rgb * _Specular.rgb 
				* pow(saturate(dot(tangentNormal,halfDir)),_Gloss);


			fixed3 finalColor = ambient + diffuse + specular;


			return fixed4(finalColor,1.0);
		}








				ENDCG
			}

    }
    FallBack "Specular"
}
