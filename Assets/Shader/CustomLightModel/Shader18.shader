Shader "Custom/Shader18"
{
    Properties
    {
   
		_MainTex("MainTexture",2D) = "white"{}
			_NoiseTex("NoiseTexture",2D) = "white"{}
			_Mitigation("Mitigation", Range(0,50)) = 8
				_SpdX("SpdX",Range(0,5)) = 2.5
				_SpdY("SpdY",Range(0,5)) = 2.5

    }
    SubShader
    {
      

		Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag 


#include "UnityCG.cginc"


				struct v2f
				{
					float4  vertex : SV_POSITION;

					float2 uv : TEXCOORD0;

				};

				struct a2f
				{
					float4 vertex : POSITION;

					float2 uv: TEXCOORD;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				sampler2D _NoiseTex;
				float4 _NoiseTex_ST;


				float _Mitigation;
				float _SpdX;
				float _SpdY;





				v2f vert(a2f a)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(a.vertex);

					o.uv = TRANSFORM_TEX(a.uv,_MainTex);




					return o;
				}


				fixed4 frag(v2f v): SV_Target
				{
					float2 uv = v.uv;
					float2 Spd = (_SpdX, _SpdY);



					fixed noise = tex2D(_NoiseTex,uv).r;

					noise = noise / _Mitigation;

					uv += noise *cos(_Time.y * Spd );

					return tex2D(_MainTex,uv);

				}







				ENDCG
			}

    }
    FallBack "Diffuse"
}
