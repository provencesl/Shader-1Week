// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Shader9"
{
	Properties
	{
		_Color("Color Tint",Color) = (0.3,0.3,0.3,0.3)
		_MainTex("MainTex",2D) = "white"{}




	}
	SubShader
	{
		Tags{
		"Queue" = "AlphaTest"
		"IgnoreProjector" = "True"
		"RenderType" = "TransparentCutout" }



	   Pass
		{

			Tags{"LightMode" = "ForwardBase"}

			Cull Off

			CGPROGRAM


#pragma multi_complie_fwdbase
#pragma vertex vert
#pragma fragment frag 


#include "Lighting.cginc"
#include "AutoLight.cginc"


		fixed4 _Color;
	sampler2D _MainTex;
	float4 _MainTex_ST;
	fixed _CullOff;




		struct v2f
		{
		
		float4 vertex : SV_POSITION;
		float3 normal : TEXCOORD0;
		float3 worldpos : TEXCOORD1;
		float2 uv : TEXCOORD2;

		SHADOW_COORDS(3)
		};

		
		struct a2v
		{
			float4 vertex:POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;

		};



		v2f vert(a2v v) 
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.normal = UnityObjectToWorldNormal(v.normal);

			o.worldpos = mul(unity_ObjectToWorld, v.vertex).xyz;

			o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);


			TRANSFER_SHADOW(o);





			return o;
		}


		fixed4 frag(v2f i ): SV_Target
		{
			fixed3 normal = normalize(i.normal);
		fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldpos) );

		fixed4 texColor = tex2D(_MainTex,i.uv);

		clip(texColor.a - _CullOff);


		fixed3 albedo = texColor.rgb * _Color.rgb;

		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz* albedo;


		fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(normal
			,worldLightDir))   ;


		UNITY_LIGHT_ATTENUATION(atten, i, i.worldpos);


		fixed3 color = (ambient + diffuse)* atten ;

		return fixed4(color,1.0);

		}











			ENDCG

		}

    }
    FallBack "Diffuse"
}
