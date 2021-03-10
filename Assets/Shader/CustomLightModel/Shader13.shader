Shader "Custom/Shader13"
{
    Properties
    {
    _Diffuse("Diffuse",Color) =(1,1,1,1)
	_Specular("Specular", Color)=(1,1,1,1)
		_Gloss("Gloss",Range(0,255)) = 8.0



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



		struct v2f
		{

		fixed4 vertex :SV_POSiTION;
		fixed3 normal : NORMAL;

		};
		struct a2f
		{
			fixed4 vertex : POSITION;
			fixed3 normal : NORMAL;
		};



		fixed4 _Diffuse;
		fixed4 _Specular;
		float3 _Gloss;



		v2f vert(a2f v)
		
		{
			v2f o;

			o.vertex = UnityObjectToClipPos(v.vertex);
			o.normal = UnityObjectToWorldNormal(v.normal);

			return o;
		}



		fixed4 frag(v2f v): SV_Target
		{
			fixed3 lightDir = normalize(_WorldSpaceLightPos0.rgb);
		fixed3 normal = normalize(v.normal);

		fixed3 DotLN = dot(lightDir, normal)* 0.5;


		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

		fixed3 diffuse = _Diffuse * _LightColor0.rgb * (DotLN  + 0.5);

		fixed3 reflectDir = reflect(-lightDir,normal);

		fixed3 specular = _Specular * _LightColor0.rgb * pow(dot(reflectDir ,normal ),_Gloss );


		fixed3 color = ambient + diffuse + specular;


			return fixed4(color,1.0);
		}




			ENDCG







		}

    }
    FallBack "Diffuse"
}
