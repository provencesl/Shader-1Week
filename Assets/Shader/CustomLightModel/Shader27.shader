Shader "Custom/Shader27"
{
    Properties
    {
		_Diffuse("Diffuse",Color) = (0.5,0.5,0.5,0.5)
		_Specular("Specular", Color ) = (0.4,0.4,0.4,0.4)
		_SpecularIntensity("SpecularIntensity",Range(0,1)) = 0.1

    }
    SubShader
    {
      Tags{"LightMode" = "ForwardBase"}
		Pass
		{

		CGPROGRAM

			#pragma vertex vert 
				#pragma fragment frag
		
#include "UnityCG.cginc"
#include "Lighting.cginc "



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
		fixed3 _Diffuse;
		fixed3 _Specular;
		float _SpecularIntensity;



		v2f vert(a2f a)
		{
			v2f v;
			v.vertex = UnityObjectToClipPos(a.vertex);
			v.normal = UnityObjectToWorldNormal(a.normal);
			v.viewDir = WorldSpaceViewDir(a.vertex );





			return v;
		}

		fixed4 frag(v2f v):SV_Target
		{
		fixed3 light = normalize(_WorldSpaceLightPos0.rgb);
		fixed3 normal = normalize(v.normal);
		fixed3 viewDir = normalize(v.viewDir);

		fixed3 NDotL = dot(light, normal);
		fixed3 NDotH = dot(viewDir, normal);



		fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;



		fixed3 diffuse = _Diffuse.rgb * _LightColor0.rgb * saturate(NDotL);




		fixed3 MinusNDotH = 1 - NDotH;
		fixed3 specular = _Specular.rgb * _LightColor0.rgb * saturate(MinusNDotH);

		fixed3 specularInten = smoothstep(1 - _SpecularIntensity, 1 + _SpecularIntensity, NDotH);



		fixed3 finalColor = diffuse + ambient + (specular + specularInten);



		return fixed4(finalColor, 1);
		}










		ENDCG

		}

    }
    FallBack "Specular"
}
