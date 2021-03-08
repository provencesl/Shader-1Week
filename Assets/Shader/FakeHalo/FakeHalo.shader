Shader "Unlit/FakeHalo"
{
  Properties
  {
    _LightDegree("light degree", Range(-180 , 180)) = 45
  }
  SubShader
  {
    Tags { "RenderType"="Opaque" }
    LOD 100

    Pass
    {
      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
     
      #include "UnityCG.cginc"

      struct appdata
      {
        float4 vertex : POSITION;
        //float2 uv : TEXCOORD0;
      };

      struct v2f
      {
        float4 vertex : SV_POSITION;
      };

      uniform float _LightDegree;
     
      v2f vert (appdata v)
      {
        v2f o;
        float3 pivot = float3(0.0, 0.0, 0.0);
        float3 pivotViewPosition = UnityObjectToViewPos(float4(pivot.xyz, 1.0)).xyz;
        float3 pivotWorldPosition  = mul(unity_ObjectToWorld,float4(pivot.xyz, 1.0)).xyz;

        float3 cameraVector = _WorldSpaceCameraPos.xyz - pivotWorldPosition;
        float3 directionToCamera = normalize(cameraVector);
        float3 forwardVector = float3(0.0, 0.0, 1.0);
        float3 forwardVectorWorldSpace =  normalize(mul(unity_ObjectToWorld,float4(forwardVector.xyz, 0.0)).xyz);
        float dotProduct = dot(forwardVectorWorldSpace,directionToCamera); // will return (-1.0,1.0) range
        float degreeInRadians = _LightDegree *  0.01745329252 * dotProduct;

        float2x2 rotationMatrix; // declaration of matrix
        rotationMatrix[0][0] = cos(degreeInRadians);
        rotationMatrix[0][1] = -sin(degreeInRadians);
        rotationMatrix[1][0] = sin(degreeInRadians);
        rotationMatrix[1][1] = cos(degreeInRadians);

        float2 verticiesXY = v.vertex.xy;
        verticiesXY = mul(verticiesXY,rotationMatrix);
        float3 vertexInViewPosition = float3(verticiesXY.xy,v.vertex.z) + pivotViewPosition;
        float4 vertexInProjection = mul(UNITY_MATRIX_P, float4(vertexInViewPosition.xyz, 1.0));

        o.vertex = vertexInProjection;
        return o;
      }
     
      fixed4 frag (v2f i) : SV_Target
      {
        fixed4 col = fixed4(1.0,1.0,1.0,1.0);
        return col;
      }
      ENDCG
    }
  }
}

