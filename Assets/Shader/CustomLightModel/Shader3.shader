Shader "Custom/Shader3"
{
 Properties
 {
	 _Diffuse("Diffuse",Color) =(1.0,1.0,1.0,1.0)
	

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
	 float4 vertex: POSITION;
	 float3 normal : NORMAL;

		};




		struct v2f
		 {
			float4 vertex : SV_POSITION;
			float3 normal : TEXCOORD0;
			float3 color : COLOR;

		 };


		fixed4 _Diffuse;






		v2f vert(a2f v)
		{
			v2f o;

			o.vertex = UnityObjectToClipPos(v.vertex);
			o.normal = UnityObjectToWorldNormal(v.normal);

			fixed3 worldSpaceLight = normalize(_WorldSpaceLightPos0.rgb);

			fixed3 normal = UnityObjectToWorldNormal(o.normal);


			fixed3 FindDot = dot(worldSpaceLight, normal);


			fixed3 color = _Diffuse.rgb + saturate(FindDot) +_LightColor0.rgb;
			




			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;





			o.color = ambient * color;


			return o;

		}


		fixed4 frag(v2f o): SV_TARGET
		{




			return fixed4(o.color,1.0);
		}




		ENDCG


	 }

 }



FallBack "Diffuse "




}
