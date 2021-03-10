Shader "Custom/Shader11"
{
    Properties
    {
		_Diffuse("Diffuse", Color) = (1,1,1,1)
    }
    SubShader
    {
      
     Pass
		{
			Tags{"LightMode" = "ForwardBase"}

			CGPROGRAM

#pragma vertex vert
#pragma fragment frag 
#include "Lighting.cginc"

			
			fixed4 _Diffuse;





			struct v2f
			{
		fixed4 vertex :SV_POSITION;
		fixed3 normal : NORMAL;
	

			};

			struct a2f
			{
				fixed4 vertex :POSITION;
				fixed3 normal : NORMAL;
			


			};


			v2f vert(a2f v)
			{

				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				o.normal = UnityObjectToWorldNormal(v.normal);

				



				return o;
			}

			fixed4 frag(v2f v) : SV_Target
			{
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;
			
			fixed3 lightDir = normalize(_WorldSpaceLightPos0.rgb);
			
			fixed3 normal = normalize(v.normal);






			fixed3 diffuse = saturate(  dot(lightDir, normal)) * _Diffuse * _LightColor0.rgb;




			fixed3 color = ambient + diffuse ;

			return fixed4(color, 1.0);

			}




				ENDCG


		}

    }
    FallBack "Diffuse"
}
