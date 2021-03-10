Shader "Custom/Shader23"
{
    Properties
    {
      
		_Diffuse("Diffuse",Color) = (1,1,1,1)



    }
    SubShader
    {
    


Pass
		{
		CGPROGRAM

	#include "UnityCG.cginc"
	#include "Lighting.cginc"

#pragma vertex vert
#pragma fragment frag




		fixed4 _Diffuse;






		struct v2f
	{
	fixed4	vertex:SV_POSITION;
fixed3 	normal: NORMAL;

	};

	struct a2f
	{
fixed4	vertex: POSITION;
fixed3 	normal: NORMAL;
	};






	v2f vert(a2f a)
	{

		v2f v;

		v.vertex = UnityObjectToClipPos(a.vertex );
		v.normal = UnityObjectToWorldNormal(a.normal);

		return v;

	}


	fixed4 frag(v2f v): SV_Target
	{
		fixed3 ambient =UNITY_LIGHTMODEL_AMBIENT.rgb;

	fixed3 normal = normalize(v.normal);

	fixed3 light = normalize(_WorldSpaceLightPos0.rgb);


	fixed3 diffuse = _Diffuse.rgb * saturate(dot(light, normal));

	return fixed4(diffuse + ambient, 1.0);







	}












        ENDCG

		}

    }
    FallBack "Diffuse"
}
