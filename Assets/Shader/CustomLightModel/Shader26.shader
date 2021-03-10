Shader "Custom/Shader26"
{
    Properties
    {
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color)= (0.4,0.4,0.4,0.4)
		_lightInten("LightIntensity", Range(0.01,1)) = 0.1
    }
    SubShader
    {
		Tags{ "LightMode" = "ForwardBase" }
       Pass
	{
		


		CGPROGRAM


#pragma vertex vert
#pragma fragment frag 


#include "UnityCG.cginc"
#include "Lighting.cginc"



		struct v2f
	{
		fixed4 vertex : SV_POSITION;
		fixed3 normal : NORMAL;
		fixed3 viewDir : TEXCOORD0;


	};

		struct a2f
		{

			fixed4 vertex : POSITION;
			fixed3 normal : NORMAL;


		};



		fixed4 _Diffuse;
		fixed4 _Specular;
		float _lightInten;




		v2f vert(a2f a)
		{
			v2f v;

			v.vertex = UnityObjectToClipPos(a.vertex);
			v.normal = UnityObjectToWorldNormal(a.normal);

			v.viewDir = WorldSpaceViewDir(a.vertex );


			return v;
		}


		fixed4 frag(v2f v): SV_Target
		{
			fixed3 light = normalize(_WorldSpaceLightPos0.xyz);
			fixed3 normal = normalize(v.normal);

			fixed3 NDotH = dot(v.viewDir, normal);
			fixed3 NDotL =dot(light, normal);

			fixed3 reflectDir =normalize( reflect(-light, normal));



			fixed3 lightIntensity = smoothstep(1- _lightInten,1 + _lightInten,NDotL);

			fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.rgb;





			fixed3 diffuse = _Diffuse.rgb * _LightColor0.rgb *saturate( lightIntensity)  ;



			fixed3 specular = _Specular.rgb * _LightColor0.rgb * saturate( 1-     NDotH) *saturate( reflectDir);






			fixed3 finalColor = diffuse + ambient + specular;



			return fixed4(finalColor ,1.0);

		}




		ENDCG
	}

    }
    FallBack "Diffuse"
}
