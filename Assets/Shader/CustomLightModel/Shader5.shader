Shader "Custom/Shader5"
{
	Properties
	{

		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_Shineness("Shineness",Range(0,32)) = 8

	}
	SubShader
	{
	 Pass
	{
		Tags {"LightMode" = "ForwardBase"}




		CGPROGRAM

		#pragma multi_compile_fwdbase
		#pragma vertex vert 
		#pragma fragment frag 

		#include "UnityCG.cginc"
		#include "Lighting.cginc "


		float4 _SpecularColor;
		float _Shineness;



		struct v2f 
		{
			float4 position : POSITION;
			float3 normal : TEXCOORD0;
			float vertex : COLOR;
		};


	v2f vert (appdata_base v)
	{
		v2f o;


		o.position = UnityObjectToClipPos(v.vertex);

		o.normal = v.normal;

		o.vertex = v.vertex;

		return o;
		
	}

	fixed4 frag(v2f IN): COLOR
	{
		
		fixed4 col =UNITY_LIGHTMODEL_AMBIENT;


		float3 Normal = UnityObjectToWorldNormal(IN.normal);
		float3 LightDir = WorldSpaceLightDir(IN.vertex);

		float diffScale = saturate(dot(Normal,LightDir));

		col += diffScale * _LightColor0;


		float3 V = normalize(WorldSpaceViewDir(IN.vertex));

		float3 R = 2 * dot(Normal, LightDir)*Normal - LightDir;


		float _specularScale = saturate(dot(R,V));

		col += _SpecularColor * pow(_specularScale, _Shineness);

		return col;

	}

		ENDCG

	}

     
    }

}
