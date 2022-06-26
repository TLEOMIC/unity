// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Diy/skyBox"
{
    Properties
    {
        _Alpha ("Alpha", Range(0, 1)) = 1
        _BeiShu ("_BeiShu", Range(0, 10)) = 1
        _Rotation ("Rotation", Range(0, 360)) = 0
        [NoScaleOffset] _Tex ("Cubemap", Cube) = "grey" {}

         _SrcBlend ("_SrcBlend", Float) = 1.0
        _DstBlend ("_DstBlend", Float) = 0.0
    }
    
    SubShader
    {
        Tags { "Queue"="Background" "RenderType"="Background" "PreviewType"="Skybox" }
        Cull Off
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        // Blend [_SrcBlend] [_DstBlend]
        // Blend SrcAlpha Zero
        
        Pass
        {
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            
            #include "UnityCG.cginc"
            
            samplerCUBE _Tex;
            float _Rotation;
            float _BeiShu;
            float _Alpha;
            
            float3 RotateAroundYInDegrees (float3 vertex, float degrees)
            {
                float alpha = degrees * UNITY_PI / 180.0;
                float sina, cosa;
                sincos(alpha, sina, cosa);
                float2x2 m = float2x2(cosa, -sina, sina, cosa);
                return float3(mul(m, vertex.xz), vertex.y).xzy;
            }
            
            struct appdata_t
            {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 texcoord : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };
            
            v2f vert (appdata_t v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                float3 rotated = RotateAroundYInDegrees(v.vertex, _Rotation);
                o.vertex = UnityObjectToClipPos(rotated);
                o.texcoord = v.vertex.xyz;
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                
                half4 tex = texCUBE(_Tex, i.texcoord);
                return float4(tex.rgb * _BeiShu,_Alpha);
            }
            ENDCG
        }
    }

    Fallback Off
}
