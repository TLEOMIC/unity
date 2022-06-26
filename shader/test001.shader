Shader "Diy/test001"
{
    Properties
    {
        _MainTex ("贴图", 2D) = "white" {}
        _BeiShu ("贴图倍数", Range(0, 1000)) = 1

        _DstBlend ("DstBlend", Float) = 10.0
        _Cull ("cull", Float) = 2.0

        _FresnelScale("菲涅尔强度",Range(0,1))= 0
        _BeiShu3 ("菲涅尔强度减法", Range(0,1)) = 0
        _Color ("菲涅尔颜色", Color) = (1,1,1,1)
        _BeiShu2 ("菲涅尔倍数", Range(0,3)) = 0
        

    }
    SubShader
    {
        
        Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        
        Cull [_Cull]
        Lighting Off
        ZWrite Off
        BlendOp Add
        Fog { Color (0,0,0,0) }
        LOD 100

        ZWrite Off
        Blend SrcAlpha [_DstBlend]

        BindChannels
        {
            Bind "Color", color
            Bind "Vertex", vertex
            Bind "TexCoord", texcoord
        }

        
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD2;
                float3 worldPos:TEXCOORD6;
                float3 worldNormal:TEXCOORD3;
                float3 worldViewDir:TEXCOORD4;
                // float3 worldReflection:TEXCOORD5;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
 
                return o;
            }

            sampler2D _MainTex;
            float _BeiShu;
            float _BeiShu2;
            float _BeiShu3;
            float _FresnelScale;
            fixed4 _Color;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float3 worldNormal = normalize(i.worldNormal);
                float3 worldViewDir = normalize(i.worldViewDir);
                
                //计算 菲涅尔公式
                float fresnel = _FresnelScale + (1 - _FresnelScale)*pow(1 - dot(worldViewDir, worldNormal), 5);//菲涅尔系数

                col.rgb = col.rgb * i.color * i.color.a * _BeiShu;
                
                fixed3 color = _Color * saturate(fresnel - _BeiShu3)* _BeiShu2;

                UNITY_APPLY_FOG(i.fogCoord, color);
                return fixed4(color, 1) * saturate(_BeiShu2) + col;
                // return col;
            }
            ENDCG
        }
    }
}
