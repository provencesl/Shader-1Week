﻿Shader "K/Other/RiverScroll" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ScrollXSpeed ("X Scroll Speed", Range(0, 10)) = 2  
		_ScrollYSpeed ("Y Scroll Speed", Range(0, 10)) = 2  
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert  
		#pragma target 3.0

		sampler2D _MainTex;
		fixed _ScrollXSpeed;  
		fixed _ScrollYSpeed;  

		struct Input {
			float2 uv_MainTex;
		};


		void surf (Input IN, inout SurfaceOutput o) {

			fixed2 scrolledUV = IN.uv_MainTex; 

			fixed xScrollValue = _ScrollXSpeed * _Time.y;  
			fixed yScrollValue = _ScrollYSpeed * _Time.y;

			scrolledUV += fixed2(xScrollValue, yScrollValue); 

			fixed4 c = tex2D (_MainTex, scrolledUV);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
