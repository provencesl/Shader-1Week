Shader "Custom/Toon"
{
	Properties
	{
		_Color("Color", Color) = (0.5, 0.65, 1, 1)
		_MainTex("Main Texture", 2D) = "white" {}
	_AmbientColor("AmbientColor", Color) = (0.4,0.4,0.4,0.4)
		_SpecularColor("SpecularColor", Color) = (0.9,0.9,0.9,1)
		_Glossiness("Glossiness", Float) = 32

		_RimColor("Rim Color", Color) = (1,1,1,1)
		_RimAmount("Rim Amount", Range(0,1)) = 0.724

		_RimThreshold("RimThreshold",Range(0,1)) = 0.01

	}
		SubShader
	{
		Tags
	{
		"LightMode"= "ForwardBase"
		"PassFlags" = "OnlyDirectional"
	}




		Pass
	{
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#pragma multi_compile_fwdbase




#include "UnityCG.cginc"
#include "Lighting.cginc"

#include "AutoLight.cginc"




		struct appdata
	{
		float4 vertex : POSITION;
		float4 uv : TEXCOORD0;
		float3 normal : NORMAL;
		SHADOW_COORDS(2)
	};

	struct v2f
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float3 worldnormal : NORMAL;
		float3 viewDir : TEXCOORD1;
	};

	sampler2D _MainTex;
	float4 _MainTex_ST;
	float4 _AmbientColor;
	float _Glossiness;
	float4 _SpecularColor;
	float4 _RimColor;
	float _RimAmount;
	float _RimThreshold;



	v2f vert(appdata v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.worldnormal = UnityObjectToWorldNormal(v.normal);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		o.viewDir = WorldSpaceViewDir(v.vertex);
		TRANSFER_SHADOW(o);
		return o;
	}

	float4 _Color;

	float4 frag(v2f i) : SV_Target
	{
		float4 sample = tex2D(_MainTex, i.uv);
	float3 normal = normalize(i.worldnormal);

	float3 viewDir = normalize(i.viewDir);

	float3 halfvector = normalize(_WorldSpaceLightPos0.rgb + viewDir);
	float3 NDotH = dot(halfvector,normal);



	
	float NDotL = dot(_WorldSpaceLightPos0, normal);

	float shadow = SHADOW_ATTENUATION(i);




	//float lightIntensity = NDotL > 0 ? 1 : 0;
	float lightIntensity = smoothstep(0, 0.01, NDotL * shadow);

	float4 light = lightIntensity * _LightColor0;




	float specularIntensity = pow(NDotH * lightIntensity, _Glossiness *  _Glossiness);

	float specularIntensitySmooth = smoothstep(0.005, 0.1, specularIntensity);

	float4 specular = specularIntensitySmooth * _SpecularColor;

	float4 rimdot = 1 - dot(viewDir, normal);



	/*float RimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, rimdot );

	float4 rim = RimIntensity * _RimColor;*/

	float RimIntensity = rimdot * pow(NDotL, _RimThreshold);
	RimIntensity = smoothstep(_RimAmount - 0.01, _RimAmount + 0.01, RimIntensity);


	float4 rim = RimIntensity * _RimColor;


	return _Color * sample *(_AmbientColor+ light + specularIntensity + specular + rim);
	}
		ENDCG
	}
			UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}