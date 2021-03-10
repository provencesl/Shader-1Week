Shader "Custom/Shader4"
{
    Properties
    {
		_MainTex("Texture", 2D ) = "white"{}
	_SpecularColor("Specular",Color) = (1,1,1,1)
		_Diffuse("Diffuse", Color) = (0.4,0.4,0.4,0.4)






    }
    SubShader
    {
		Tags {"RenderType" = "Opaque"}
      
		Pass
		{
		Tags{"LightMode" = "ForwardBase"}


			CGPROGRAM







			ENDCG 
		}




    }
    FallBack "Specular"
}
