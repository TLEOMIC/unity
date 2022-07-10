Shader "diy/sesan23"
{
    Properties
    { 
        _Scale("_Scale", Range(0,1)) = 1

        _FresnelScale("菲涅尔强度",Range(0,1))= 0
        _Fresnel1 ("菲涅尔强度减法", Range(0,1)) = 0
        _Fresnel2 ("菲涅尔倍数", Range(0,3)) = 0
        _FresnelColor ("菲涅尔颜色", Color) = (1,1,1,1)

        _BumpScale ("Normal Scale", Float) = 1.0
        _BumpMap ("Normal Map", 2D) = "bump" {}


        _Cull ("_Cull", Float) = 2.0

        _Diffuse ("Diffuse", Color) = (1, 1, 1, 1)
        _Specular ("Specyler", Color) = (1, 1, 1, 1)
        _Gloss ("Gloss", Range(8.0, 256)) = 20 
        _Gloss2 ("Gloss2", Range(8.0, 256)) = 20 
        [HideInInspector] _SrcBlend ("__src", Float) = 1.0
    }
    SubShader
    {
        // 在所有不透明几何体之后绘制自己
        Tags { "Queue" = "Transparent" }

        // 将对象后面的屏幕抓取到 _BackgroundTexture 中
        GrabPass
        {
            "_BackgroundTexture"
        }

        // 使用上面生成的纹理渲染对象，并反转颜色
        Pass
        {
            CULL [_Cull]

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            

            

            struct appdata
            {
                float4 vertex : POSITION;

                float4 uv : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                

                
            };

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD1;
                float4 uv1 : TEXCOORD2;
                float3 worldNormal:TEXCOORD3;
                float3 worldViewDir:TEXCOORD4;


                half3 tspace0 : TEXCOORD5;
                half3 tspace1 : TEXCOORD6;
                half3 tspace2 : TEXCOORD7;
                float3 worldPos : TEXCOORD8;
            };
            
            float _Scale;

            float _Fresnel2;
            float _Fresnel1;
            float _FresnelScale;
            fixed4 _FresnelColor;

            sampler2D _BackgroundTexture;
            sampler2D _BumpMap;
            float4 _BumpMap_ST;
            float _BumpScale;

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            float _Gloss2;

            v2f vert(appdata v) {
                v2f o;
                o.uv = v.uv;
                o.uv1 = v.uv1;
                // 使用 UnityCG.cginc 中的 UnityObjectToClipPos 来计算
                // 顶点的裁剪空间
                o.pos = UnityObjectToClipPos(v.vertex);
                // 使用 UnityCG.cginc 中的 ComputeGrabScreenPos 函数
                // 获得正确的纹理坐标
                o.grabPos = ComputeGrabScreenPos(o.pos);

                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldViewDir = UnityWorldSpaceViewDir(o.pos);

                half3 worldTangent = UnityObjectToWorldDir(v.tangent);
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                half3 worldBitangent = cross(o.worldNormal, worldTangent) * tangentSign;
                

                o.tspace0 = half3(worldTangent.x, worldBitangent.x, o.worldNormal.x);
                o.tspace1 = half3(worldTangent.y, worldBitangent.y, o.worldNormal.y);
                o.tspace2 = half3(worldTangent.z, worldBitangent.z, o.worldNormal.z);

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                return o;
            }

            
            half4 frag(v2f i) : SV_Target
            {
                half3 tangentNormal = UnpackScaleNormal(tex2D(_BumpMap, i.uv), _BumpScale);
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tangentNormal);
                worldNormal.y = dot(i.tspace1, tangentNormal);
                worldNormal.z = dot(i.tspace2, tangentNormal);

                float3 worldView = normalize(lerp(_WorldSpaceCameraPos.xyz - i.pos.xyz, UNITY_MATRIX_V[2].xyz, unity_OrthoParams.w));
                worldNormal *= step(0, dot(worldView, worldNormal)) * 2 - 1; // flip if projection matrix is flipped
                worldNormal *= lerp(+1.0, -1.0, 0);
                worldNormal = normalize(worldNormal);

                float3 worldViewDir = normalize(i.worldViewDir);
                
                //计算 菲涅尔公式
                float fresnel = _FresnelScale + (1 - _FresnelScale)*pow(1 - dot(worldViewDir, i.worldNormal), 5);//菲涅尔系数
                // 菲涅尔 颜色
                fixed4 color = _FresnelColor * saturate(fresnel - _Fresnel1)* _Fresnel2;

                i.grabPos.x += _Scale;


                float3 lightDir = _WorldSpaceLightPos0.xyz - i.worldPos.xyz * _WorldSpaceLightPos0.w;
                
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                worldLightDir = normalize(lightDir);

                //衰减需要用到 #pragma multi_compile_fwdadd
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos)

                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                fixed3 halfDir = normalize(worldLightDir + viewDir);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss) * atten; 

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss2) * atten;

                
                return tex2Dproj(_BackgroundTexture, i.grabPos ) + float4(specular + diffuse,1) + color;

                
            }
            ENDCG
        }

        Pass 
        {
            Tags {"LightMode"="ForwardAdd"}
            CULL [_Cull]
            Blend [_SrcBlend] One
            Fog { Color (0,0,0,0) } // in additive pass fog should be black
            ZWrite Off
            ZTest LEqual

            CGPROGRAM

            #pragma multi_compile_fwdadd_fullshadows
            #pragma multi_compile_fog
            
            #pragma vertex vert
            #pragma fragment frag 

            #include "Lighting.cginc"
            #include "AutoLight.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            float _Gloss2;

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
                
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

                worldLightDir = normalize(lightDir);

                //衰减需要用到 #pragma multi_compile_fwdadd
                UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos)

                fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                fixed3 halfDir = normalize(worldLightDir + viewDir);



                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss) * atten; 

                fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss2) * atten;

                return fixed4 (diffuse+specular, 1.0);


            }
            ENDCG
        }
    }
}