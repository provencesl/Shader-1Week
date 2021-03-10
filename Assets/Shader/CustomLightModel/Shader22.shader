
Shader "Custom/Shader22"
{
	Properties
	{

		_MainTex("MainTex", 2D) = "white"{}




	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }

			Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
#include "Lighting.cginc"





		sampler2D _MainTex;
	float4 _MainTex_ST;



				struct v2f
			{
					fixed4 vertex : SV_POSITION;
					
					fixed3 normal : NORMAL;

					float2 uv : TEXCOORD0;
			};

			struct a2f
			{
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;

				float2 uv : TEXCOORD0;

			};


			v2f vert(a2f a )
			{
				v2f o;
				o.uv = TRANSFORM_TEX( a.uv,_MainTex);
				o.vertex = UnityObjectToClipPos(a.vertex);
				o.normal = UnityObjectToWorldNormal(a.normal);


				return o;

			}


			fixed4 frag(v2f v): SV_Target
			{






				


				return fixed4(1.0,1.0,1.0,1.0);
			}







	        ENDCG

		}

    }
    FallBack "Diffuse"
}
