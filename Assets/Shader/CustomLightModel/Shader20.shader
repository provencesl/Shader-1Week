Shader "Custom/Shader20"
{
	Properties
	{

		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular",Color) = (1,1,1,1)
		_Gross("Gross", Range(0.0,8.0)) = 4.5

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


			   fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gross;



			   struct v2f
				{
					fixed4 vertex : SV_POSITION;
					fixed3 normal : NORMAL;
				};

				struct a2f
				{

					fixed4 vertex : POSITION;
					fixed3 normal : NORMAL;

				};

				v2f vert(a2f a)
				{
					v2f o;
					
					o.vertex = UnityObjectToClipPos(a.vertex);


					o.normal = UnityObjectToWorldNormal(a.normal);




					return o;
				}




				fixed4 frag(v2f v ): SV_Target
				{

					fixed3 normal = normalize(v.normal);
				fixed3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 halfDot = (saturate(dot(lightDir,normal)) * 0.5) + 0.5;

				

				fixed3 reflectDir = reflect(-lightDir,normal);






					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
					fixed3 diffuse = _LightColor0.rgb * _Diffuse * halfDot ;
					fixed3 specular = _LightColor0.rgb * _Specular.rgb * saturate(pow(reflectDir, _Gross));







					fixed3 finalColor = ambient + diffuse + specular ;

				return
				fixed4(	finalColor,1.0);
				}











				ENDCG

			}


 
    }
    FallBack "Diffuse"
}
