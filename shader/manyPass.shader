Shader "Unlit/manyPass"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
        _Specular ("Specyler", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20 
        [HideInInspector] _SrcBlend ("__src", Float) = 1.0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        // Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM

            #pragma multi_compile_fwdadd //让光线能有距离衰减   
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            // struct v2f
            // {
                //     float2 uv : TEXCOORD0;
                //     UNITY_FOG_COORDS(1)
                //     float4 vertex : SV_POSITION;
            // };

            // sampler2D _MainTex;
            // float4 _MainTex_ST;

            // v2f vert (appdata v)
            // {
                //     v2f o;
                //     o.vertex = UnityObjectToClipPos(v.vertex);
                //     o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                //     UNITY_TRANSFER_FOG(o,o.vertex);
                //     return o;
            // }
            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o; 
            }

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            fixed4 frag (v2f i) : SV_Target
            {

                return float4(0,0,0,1);
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);


                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir)); 


                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                fixed3 halfDir = normalize(worldLightDir + viewDir);

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss);

                return fixed4 (ambient + diffuse + specular, 1.0);


            }
            
            ENDCG
        }

        Pass 
        {
            Tags {"LightMode"="ForwardAdd"}
            Blend [_SrcBlend] One
            Fog { Color (0,0,0,0) } // in additive pass fog should be black
            ZWrite Off
            ZTest LEqual

            CGPROGRAM

            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _ _ALPHATEST_ON _ALPHABLEND_ON _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local _METALLICGLOSSMAP
            #pragma shader_feature_local _SPECGLOSSMAP
            #pragma shader_feature_local _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature_local _DETAIL_MULX2
            #pragma shader_feature_local _PARALLAXMAP

            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            
            #pragma vertex vert
            #pragma fragment frag 

            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            v2f vert (a2v v)
            {
                v2f o;
                
                o.pos = UnityObjectToClipPos(v.vertex);

                o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o; 
            }

            fixed4 frag(v2f i) : SV_Target 
            {

                float3 lightDir = _WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w;
                
                // fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                worldLightDir = normalize(lightDir);

                //衰减需要用到 #pragma multi_compile_fwdadd
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos)
                // return float4(atten,0, 0,1);

                // float3 color = _LightColor0.rgb;
                // color *= atten;
                // return half4(color, 1);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir)) * atten; 


                fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                fixed3 halfDir = normalize(worldLightDir + viewDir);

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss) * atten;

                return fixed4 ( diffuse + specular, 1.0);


            }


            ENDCG
        }

    }
}
