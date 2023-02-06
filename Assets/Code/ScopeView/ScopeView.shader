Shader "Unlit/ScopeShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _BackgroundColor ("Background color", Color) = (.0, .0, .0, .0)
        _LineColor ("Line color", Color) = (.1, .0, .0, 1)
        _LineWidthParameter ("Line param 1", float) = 0.5
        _LineWidthParameter2 ("Line param 2", float) = 0.5
        _LineOffset ("Line Offset", Vector) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        float _LineWidthParameter;
        float _LineWidthParameter2;
        float2 _LineOffset;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
        // put more per-instance properties here
        float _floatArray[128];
        fixed4 _Color;
        float4 _BackgroundColor;
        float4 _LineColor;
        int _rangeMax = 128;
        int _rangeMin = 0;
        UNITY_INSTANCING_BUFFER_END(Props)

        float calcLineWeight (float2 pos)
        {
           
            float length = _rangeMax - _rangeMin; // min to max range value
             
            int index = floor(pos.x * length + _rangeMin);
            float offset = (pos.x * length + _rangeMin) - index;
            float lx = floor(pos.x * length)/length;

            float2 l = float2(0, (_floatArray[index] + 1) * 0.5);
            float2 r = float2(1, (_floatArray[index + 1] + 1) * 0.5);
            float2 dir = r - l;
            float2 perp = float2(dir.y, -dir.x);
            float2 dirToPos = l - float2(offset, pos.y);
            float dist = abs(dot(normalize(perp), dirToPos));
            
            float lineWeight = max(_LineWidthParameter - dist * _LineWidthParameter2, 0); // 0 to _LineWidthParameter
            lineWeight *= lineWeight;
            return lineWeight;
        }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;

            float lineWeight = calcLineWeight(IN.uv_MainTex + _LineOffset);

            o.Albedo = c.rgb;
            o.Emission = _LineColor * lineWeight;
            // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
