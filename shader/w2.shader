Shader "Diy/w2"
{
    Properties
    { 
        _Alpha ("Alpha", Range(0, 1)) = 1
        _MainTex ("贴图1", 2D) = "white" {}
        _ShadeMainTex ("阴影贴图1(光照yes>高光贴图)", 2D) = "white" {}
        _BeiShu ("贴图倍数1", Range(0, 10000)) = 1
        [Enum(Close,0,Open,1,Time,2)] _BeiShuSwitch ("贴图倍数1@控制模式(粒子z)", Int) = 0
        _TimeBeiShu1 ("贴图时间控制min倍数1", Range(0, 10000)) = 1
        _TimeBeiShu2 ("贴图时间控制max倍数1", Range(0, 10000)) = 1
        _TimeSpeed1 ("贴图时间速度1", Range(0,1000)) = 0
        _TimeSpeed2 ("贴图时间速度2", Range(0,1000)) = 0

        _Color ("贴图颜色", Color) = (1,1,1,1)
        _ShadeColor ("Shader贴图颜色(光照yes>高光颜色)", Color) = (0.97, 0.81, 0.86, 1)
        [Enum(no,0,yes,1)] _WorldRefSwitch  ("世界反射", Int) = 0
        [Enum(no,0,yes,1)] _WorldRefUseMapSwitch  ("世界天空盒材质开启", Int) = 0
        _EnvMap("反射天空盒材质",Cube) = "_Skybox"{}
        

        _MainTex2 ("贴图2", 2D) = "white" {}
        _ShadeMainTex2 ("阴影贴图2(光照yes>高光贴图)", 2D) = "white" {}
        _BeiShu2 ("贴图倍数2", Range(0, 10000)) = 1
        [Enum(Close,0,Open,1,Time,2)] _BeiShu2Switch ("贴图倍数2@粒子控制(w)", Int) = 0

        _TimeMainTex2BeiShu1 ("贴图时间控制min倍数1", Range(0, 10000)) = 1
        _TimeMainTex2BeiShu2 ("贴图时间控制max倍数1", Range(0, 10000)) = 1
        _TimeMainTex2Speed1 ("贴图时间速度1", Range(0,1000)) = 0
        _TimeMainTex2Speed2 ("贴图时间速度2", Range(0,1000)) = 0

        _Color2 ("贴图2颜色", Color) = (1,1,1,1)
        _ShadeColor2 ("Shader贴图颜色(光照yes>高光颜色)", Color) = (0.97, 0.81, 0.86, 1)
        [Enum(no,0,yes,1)] _WorldRefSwitch1  ("世界反射", Int) = 0
        [Enum(no,0,yes,1)] _WorldRefUseMapSwitch1  ("世界天空盒材质开启", Int) = 0
        _EnvMap1("反射天空盒材质1",Cube) = "_Skybox"{}


        _Rate("贴图1/2切换",Range(0,1))= 0
        [Enum(Close,0,Open,1)] _RateAddSwitch ("贴图1/2叠加模式", Int) = 0
        

        [Enum(Close,0,Open,1,RongJie,2)] _RateSwitch ("贴图1/2切换@粒子控制(x)", Int) = 0
        [Enum(Close,0,Open,1)] _RateTimeSwitch ("贴图1/2切换@时间控制", Int) = 0
        [Enum(Close,0,Open,1)] _UvDefSwithc ("贴图2使用uv1", Int) = 0
        [Enum(Min,0,multiplication,1)] _AlphaSwitch ("透明模式", Int) = 0

        _ReceiveShadowRate ("Receive Shadow", Range(0, 1)) = 1
        _ReceiveShadowTexture ("Receive Shadow Texture", 2D) = "white" {}
        _ShadingGradeRate ("Shading Grade", Range(0, 1)) = 1
        _ShadingGradeTexture ("Shading Grade Texture", 2D) = "white" {}
        _ShadeShift ("Shade Shift", Range(-1, 1)) = 0
        _ShadeToony ("Shade Toony", Range(0, 1)) = 0.9

        _LightColorAttenuation ("Light Color Attenuation", Range(0, 1)) = 0
        _IndirectLightIntensity ("Indirect Light Intensity", Range(0, 1)) = 0.1
        



        _Burn_2_Map("贴图溶解贴图@粒子控制(RongJie)", 2D) = "white"{}
        _Burn_2_Map2("贴图溶解贴图2@粒子控制(RongJie)", 2D) = "white"{}
        _Burn_2_Map3("贴图溶解贴图3@粒子控制(RongJie)", 2D) = "white"{}
        

        _Burn_2_Amount1 ("溶解值", Range(0.0, 1.0)) = 0.0
        [Enum(Close,0,Open,1)] _Burn_2_AmountSwitch ("溶解值@粒子控制2(x)", Int) = 0
        
        _Burn_2_Amount2 ("溶解混合强度", Range(0.0, 1.0)) = 0.0
        _Burn_2_Amount3 ("溶解混合动态", Range(0.0, 1.0)) = 0.0
        [Enum(Close,0,Open,1)] _Burn_2_Amount23Switch ("溶解混合强度/溶解混合动态@粒子控制(x,y)", Int) = 0
        [Enum(no,0,yes,1)] _Burn_2_I ("是否反向溶解", Int) = 0
        _Burn_2_LineWidth("溶解区域强度", Range(0.0, 0.2)) = 0.1
        

        

        // _SrcBlend ("_SrcBlend", Float) = 1.0
        // _DstBlend ("_DstBlend", Float) = 0.0
        

        _FresnelScale("菲涅尔强度",Range(0,1))= 0
        _Fresnel1 ("菲涅尔强度减法", Range(0,1)) = 0
        _Fresnel2 ("菲涅尔倍数", Range(0,3)) = 0
        _FresnelColor ("菲涅尔颜色", Color) = (1,1,1,1)

        _BumpScale ("Normal Scale", Float) = 1.0
        _BumpMap ("Normal Map", 2D) = "bump" {}


        [Enum(Cilp,0,multiplication,1)] _BurnTypeSwitch ("溶解值类型", Int) = 0
        _Burn_1_FirstColor("溶解颜色1", Color) = (1, 0, 0, 1)
        _Burn_1_SecondColor("溶解颜色2", Color) = (1, 0, 0, 1)

        _Burn_1_Map("溶解贴图", 2D) = "white"{}
        _Burn_1_Map2("溶解贴图2", 2D) = "white"{}
        _Burn_1_Map3("溶解贴图3", 2D) = "white"{}

        _Burn_1_Amount1 ("溶解值", Range(0.0, 1.0)) = 0.0
        [Enum(Close,0,Open,1)] _Burn_1_AmountSwitch ("溶解值@粒子控制(y)", Int) = 0
        
        _Burn_1_Amount2 ("溶解混合强度", Range(0.0, 1.0)) = 0.0
        _Burn_1_Amount3 ("溶解混合动态", Range(0.0, 1.0)) = 0.0
        
        [Enum(Close,0,Open,1)] _Burn_1_Amount23Switch ("溶解混合强度/溶解混合动态@粒子控制(x,y)", Int) = 0
        [Enum(no,0,yes,1)] _Burn_1_I ("是否反向溶解", Int) = 0
        _Burn_1_LineWidth("溶解区域强度", Range(0.0, 0.2)) = 0.1
        

        _BlackBeiShu ("黑色倍数", Range(0, 10000)) = 1
        _Cull ("_Cull", Float) = 2.0
        _ZWrite ("_ZWrite", Float) = 1.0
        _AlphaToMask ("_AlphaToMask", Float) = 0.0
        [Enum(no,0,yes,1,MTOON,2)] _NeedLightSwitch  ("与光照交互", Int) = 0
        _LightBeiShu ("光照倍数", Range(0, 10000)) = 1

        [Enum(Close,0,toZero,1)] _DDSTYPE ("顶点色变1", Int) = 0
        _Gloss ("高光", Range(0, 256)) = 1 

        

        

    }
    SubShader
    {
        
        // Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        Tags { "RenderType" = "Opaque"  "Queue" = "Geometry" }
        
        Cull [_Cull]
        Lighting Off
        ZWrite [_ZWrite]
        // BlendOp Add
        Fog { Color (0,0,0,0) }
        LOD 100

        // Blend [_SrcBlend] [_DstBlend]
        Blend SrcAlpha OneMinusSrcAlpha
        AlphaToMask [_AlphaToMask]

        // BindChannels
        // {
            //     Bind "Color", color
            //     Bind "Vertex", vertex
            //     Bind "TexCoord", texcoord
        // }

        
        
        Pass
        {

            Tags { "LightMode" = "ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            #pragma multi_compile_fwdbase
            #pragma multi_compile_fog

            struct appdata
            {
                float4 vertex : POSITION;
                float4 color : COLOR;  //这个可以是顶点色
                float3 normal:NORMAL;

                float4 tangent : TANGENT;
                float4 uv : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 uv2 : TEXCOORD2;
                float4 uv3 : TEXCOORD2;
                
            };

            struct v2f
            {

                float2 UVMainTex : TEXCOORD0;
                
                float4 vertex : SV_POSITION;
                float4 color : TEXCOORD1;
                float3 worldPos:TEXCOORD2;
                float3 worldNormal:TEXCOORD3;
                float3 worldViewDir:TEXCOORD4;
                float3 worldReflection:TEXCOORD5;

                float2 UVBumpMap : TEXCOORD6;
                float2 UVBurn_1_Map : TEXCOORD7;
                float2 UVBurn_2_Map : TEXCOORD8;
                float3 lightDir : TEXCOORD9;
                float4 liZi : TEXCOORD10;
                float4 RandomLizi : TEXCOORD11;
                float4 liZi2 : TEXCOORD12;

                half3 tspace0 : TEXCOORD13;
                half3 tspace1 : TEXCOORD14;
                half3 tspace2 : TEXCOORD15;
                UNITY_FOG_COORDS(16)
                SHADOW_COORDS(17)


            }; 

            float _TimeMainTex2BeiShu1;
            float _TimeMainTex2BeiShu2;
            float _TimeMainTex2Speed1;
            float _TimeMainTex2Speed2;

            float _TimeBeiShu1;
            float _TimeBeiShu2;
            float _TimeSpeed1;
            float _TimeSpeed2;

            sampler2D _MainTex;
            float _BeiShu;
            fixed4 _Color;
            
            sampler2D _MainTex2;
            float _BeiShu2;
            fixed4 _Color2;
            
            float _Rate;

            float _Fresnel2;
            float _Fresnel1;
            float _FresnelScale;
            fixed4 _FresnelColor;

            half _BumpScale;
            sampler2D _BumpMap;

            fixed4 _Burn_1_FirstColor;
            fixed4 _Burn_1_SecondColor;
            sampler2D _Burn_1_Map;
            sampler2D _Burn_1_Map2;
            sampler2D _Burn_1_Map3;
            fixed _Burn_1_Amount1;
            fixed _Burn_1_Amount2;
            fixed _Burn_1_Amount3;
            fixed _Burn_1_I;
            fixed _Burn_1_LineWidth;
            float4 _MainTex_ST;
            float4 _BumpMap_ST;
            float4 _Burn_1_Map_ST;
            float4 _Burn_1_Map2_ST;

            float _Burn_1_AmountSwitch;
            float _Burn_1_Amount23Switch;
            float _RateSwitch;
            float _RateTimeSwitch;
            float _RateAddSwitch;
            float _AlphaSwitch;
            float _UvDefSwithc;
            float _BeiShuSwitch;
            float _BeiShu2Switch;
            float _BlackBeiShu;
            float _LightBeiShu;
            float _DDSTYPE;


            sampler2D _Burn_2_Map;
            sampler2D _Burn_2_Map2;
            sampler2D _Burn_2_Map3;
            fixed _Burn_2_Amount1;
            float _Burn_2_AmountSwitch;
            float _BurnTypeSwitch;
            fixed _Burn_2_Amount2;
            fixed _Burn_2_Amount3;
            float _Burn_2_Amount23Switch;
            fixed _Burn_2_I;
            fixed _Burn_2_LineWidth;
            float4 _Burn_2_Map_ST;
            float4 _Burn_2_Map2_ST;
            float _NeedLightSwitch;
            float _WorldRefSwitch;
            float _WorldRefSwitch1;
            
            
            sampler2D _ReceiveShadowTexture; 
            half _ReceiveShadowRate;
            sampler2D _ShadingGradeTexture;
            half _ShadingGradeRate;
            half _ShadeShift;
            half _ShadeToony;

            sampler2D _ShadeMainTex;
            fixed4 _ShadeColor;
            sampler2D _ShadeMainTex2;
            fixed4 _ShadeColor2;

            half _LightColorAttenuation;
            half _IndirectLightIntensity;


            float _WorldRefUseMapSwitch;
            samplerCUBE _EnvMap;
            float _WorldRefUseMapSwitch1;
            samplerCUBE _EnvMap1;
            float _Alpha;

            float _Gloss;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);

                switch(_DDSTYPE){
                    case 1:
                    o.color = 1;
                    break;
                    default:
                    o.color = v.color;
                    break;
                }

                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
                

                o.UVMainTex = TRANSFORM_TEX(v.uv, _MainTex);
                o.liZi = float4(v.uv.z,v.uv.w,v.uv1.x,v.uv1.y);
                o.RandomLizi = float4(v.uv1.z,v.uv1.w,v.uv2.x,v.uv2.y);
                o.liZi2 = float4(v.uv2.z,v.uv2.w,v.uv3.x,v.uv3.y);

                o.UVBumpMap = TRANSFORM_TEX(v.uv, _BumpMap);
                switch(_UvDefSwithc) {
                    case 1:
                    o.UVBurn_1_Map = TRANSFORM_TEX(v.uv, _Burn_1_Map);
                    break;
                    default:
                    o.UVBurn_1_Map = TRANSFORM_TEX(v.uv1, _Burn_1_Map);
                    break;
                }
                switch(_UvDefSwithc) {
                    case 1:
                    o.UVBurn_2_Map = TRANSFORM_TEX(v.uv, _Burn_2_Map);
                    break;
                    default:
                    o.UVBurn_2_Map = TRANSFORM_TEX(v.uv1, _Burn_2_Map);
                    break;
                }


                //mtoon
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                half3 worldNormal = UnityObjectToWorldNormal(v.normal);
                half3 worldTangent = UnityObjectToWorldDir(v.tangent);
                half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
                half3 worldBitangent = cross(worldNormal, worldTangent) * tangentSign;
                

                o.tspace0 = half3(worldTangent.x, worldBitangent.x, worldNormal.x);
                o.tspace1 = half3(worldTangent.y, worldBitangent.y, worldNormal.y);
                o.tspace2 = half3(worldTangent.z, worldBitangent.z, worldNormal.z);
                //mtoon
                
                TANGENT_SPACE_ROTATION;
                o.lightDir = mul(rotation, ObjSpaceLightDir(v.vertex)).xyz;
                

                // float3 worldPos = mul(_Object2World, vertex).xyz;
                // 计算世界空间视图方向
                float3 worldViewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));
                // 世界空间反射矢量
                o.worldReflection = reflect(-worldViewDir, worldNormal);

                // TRANSFER_SHADOW(o);


                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                

                const float EPS_COL = 0.00001;
                float rate = 0;
                float beishu = 0;
                float beishu2 = 0;

                
                switch(_BeiShuSwitch) {
                    case 1:
                    beishu = i.liZi.z;
                    break;
                    case 2:
                    beishu = lerp(_TimeBeiShu1,_TimeBeiShu2,(cos((_Time.y%_TimeSpeed1)/_TimeSpeed1*_TimeSpeed2)+1)/2);
                    break;
                    default:
                    beishu = _BeiShu;
                    break;
                }
                switch(_BeiShu2Switch) {
                    case 1:
                    beishu2 = i.liZi.w;
                    break;
                    case 2:
                    beishu2 = lerp(_TimeMainTex2BeiShu1,_TimeMainTex2BeiShu2,(cos((_Time.y%_TimeMainTex2Speed1)/_TimeMainTex2Speed1*_TimeMainTex2Speed2)+1)/2);
                    break;
                    default:
                    beishu2 = _BeiShu2;
                    break;
                }


                float burnAmount = 0;
                float burnAmount2 = 0;
                float burnAmount3 = 0;

                switch(_Burn_1_AmountSwitch) {
                    case 1:
                    burnAmount = i.liZi.y;
                    break;
                    default:
                    burnAmount = _Burn_1_Amount1;
                    break;
                }
                switch(_Burn_1_Amount23Switch){
                    case 1:
                    burnAmount2 = i.RandomLizi.x;
                    burnAmount3 = i.RandomLizi.y;
                    break;

                    default:
                    burnAmount2 = _Burn_1_Amount2;
                    burnAmount3 = _Burn_1_Amount3;
                    break;
                }

                // float3 worldNormal = normalize(i.worldNormal);


                half3 tangentNormal = UnpackScaleNormal(tex2D(_BumpMap, i.UVMainTex), _BumpScale);
                half3 worldNormal;
                worldNormal.x = dot(i.tspace0, tangentNormal);
                worldNormal.y = dot(i.tspace1, tangentNormal);
                worldNormal.z = dot(i.tspace2, tangentNormal);

                float3 worldView = normalize(lerp(_WorldSpaceCameraPos.xyz - i.worldPos.xyz, UNITY_MATRIX_V[2].xyz, unity_OrthoParams.w));
                worldNormal *= step(0, dot(worldView, worldNormal)) * 2 - 1; // flip if projection matrix is flipped
                worldNormal *= lerp(+1.0, -1.0, 0);
                worldNormal = normalize(worldNormal);

                float3 worldViewDir = normalize(i.worldViewDir);
                
                //计算 菲涅尔公式
                float fresnel = _FresnelScale + (1 - _FresnelScale)*pow(1 - dot(worldViewDir, worldNormal), 5);//菲涅尔系数
                // 菲涅尔 颜色
                fixed3 color = _FresnelColor * saturate(fresnel - _Fresnel1)* _Fresnel2;

                UNITY_APPLY_FOG(i.fogCoord, color);

                //混合溶解
                fixed4 col1_1 = tex2D(_Burn_1_Map2, i.UVBurn_1_Map);
                float2 uv2_0 = float2(col1_1.r,col1_1.g);

                fixed4 col1_2 = tex2D(_Burn_1_Map3, i.UVBurn_1_Map);
                float2 uv2_1 = float2(col1_2.r,col1_2.g);

                float2 f2 = lerp(i.UVBurn_1_Map,lerp(uv2_0,uv2_1,burnAmount3),burnAmount2);
                
                //溶解核心
                fixed3 burn = tex2D(_Burn_1_Map, f2).rgb;
                
                //smoothstep 一个平滑函数 差不都和渐变纹理差不多 return 0 ~ 1
                // 当c < a < b 或 c > a > b时，返回值为0
                // 当c < b < a 或 c > b > a时，返回值为1
                fixed t = 1 - smoothstep(0.0, _Burn_1_LineWidth, burn.r - abs(_Burn_1_I - burnAmount));

                float tRate = t * step(0.0001, abs(_Burn_1_I - burnAmount)); 

                //lerp 混合 a / b 系数是c
                fixed3 burnColor = lerp(_Burn_1_FirstColor, _Burn_1_SecondColor, t);
                burnColor = pow(burnColor, 5);

                switch(_RateTimeSwitch){
                    case 1:
                    // rate = (_Time.y%0.5)/0.5;
                    rate = cos((_Time.y%100)/100*360);
                    // return float4(,1,1,1);
                    break;
                    default:
                    switch(_RateSwitch) {
                        case 1:
                        rate = i.liZi.x;
                        break;
                        case 2:

                        float burnAmount_2_1 = 0;
                        float burnAmount_2_2 = 0;
                        float burnAmount_2_3 = 0;

                        switch(_Burn_2_AmountSwitch) {
                            case 1:
                            burnAmount_2_1 = i.liZi2.x;
                            break;
                            default:
                            burnAmount_2_1 = _Burn_2_Amount1;
                            break;
                        }

                        switch(_Burn_2_Amount23Switch){
                            case 1:
                            burnAmount_2_2 = i.RandomLizi.x;
                            burnAmount_2_3 = i.RandomLizi.y;
                            break;
                            default:
                            burnAmount_2_2 = _Burn_2_Amount2;
                            burnAmount_2_3 = _Burn_2_Amount3;
                            break;
                        }

                        //混合溶解
                        fixed4 col2_1 = tex2D(_Burn_2_Map2, i.UVBurn_2_Map);
                        float2 uv2_2 = float2(col2_1.r,col2_1.g);
                        fixed4 col2_2 = tex2D(_Burn_2_Map3, i.UVBurn_2_Map);
                        float2 uv2_3 = float2(col2_2.r,col2_2.g);

                        float2 f2_2 = lerp(i.UVBurn_2_Map,lerp(uv2_2,uv2_3,burnAmount_2_3),burnAmount_2_2 );
                        
                        

                        // //溶解核心
                        fixed3 burn_2 = tex2D(_Burn_2_Map, f2_2).rgb;
                        
                        // clip(burn_2.r - abs(_Burn_2_I - burnAmount_2_1));
                        
                        // //smoothstep 一个平滑函数 差不都和渐变纹理差不多 return 0 ~ 1
                        // // 当c < a < b 或 c > a > b时，返回值为0
                        // // 当c < b < a 或 c > b > a时，返回值为1
                        fixed t_2 = 1 - smoothstep(0.0, _Burn_2_LineWidth, burn_2.r - abs(_Burn_2_I - burnAmount_2_1));

                        rate = t_2 * step(0.0001, abs(_Burn_2_I - burnAmount_2_1)); 
                        // rate = _Burn_2_Amount1;
                        break;
                        default:
                        rate = _Rate;
                        break;
                    }
                    break;
                }
                UNITY_LIGHT_ATTENUATION(shadowAttenuation, i, i.worldPos.xyz);
                half lightIntensity  = 0;
                half3 lightColor  = half3(0,0,0);
                switch(_NeedLightSwitch){
                    case 2:
                    //世界光照 抄MTOON

                    half3 lightDir = lerp(_WorldSpaceLightPos0.xyz, normalize(_WorldSpaceLightPos0.xyz - i.worldPos.xyz), _WorldSpaceLightPos0.w);
                    lightColor = _LightColor0.rgb * step(0.5, length(lightDir)); // length(lightDir) is zero if directional light is disabled.
                    half dotNL = dot(lightDir, worldNormal);
                    // return float4(unity_4LightPosX0.xyz,1);

                    float what = _ReceiveShadowRate * tex2D(_ReceiveShadowTexture, i.UVMainTex).r;
                    half lightAttenuation = shadowAttenuation * lerp(1, shadowAttenuation, what);


                    // Decide albedo color rate from Direct Light
                    half shadingGrade = 1.0 - _ShadingGradeRate * (1.0 - tex2D(_ShadingGradeTexture, i.UVMainTex).r);
                    lightIntensity = dotNL; // [-1, +1]
                    lightIntensity = lightIntensity * 0.5 + 0.5; // from [-1, +1] to [0, 1]
                    lightIntensity = lightIntensity * lightAttenuation; // receive shadow
                    lightIntensity = lightIntensity * shadingGrade; // darker
                    lightIntensity = lightIntensity * 2.0 - 1.0; // from [0, 1] to [-1, +1]
                    // tooned. mapping from [minIntensityThreshold, maxIntensityThreshold] to [0, 1]
                    half maxIntensityThreshold = lerp(1, _ShadeShift, _ShadeToony);
                    half minIntensityThreshold = _ShadeShift;
                    lightIntensity = saturate((lightIntensity - minIntensityThreshold) / max(EPS_COL, (maxIntensityThreshold - minIntensityThreshold)));

                    break;
                    default:
                    break;
                }
                
                //最后的颜色混合
                

                fixed4 mainTexCol = tex2D(_MainTex, i.UVMainTex);
                fixed4 mainTexCol2 = tex2D(_MainTex2, i.UVMainTex);

                fixed4 shaderMainTexCol = tex2D(_ShadeMainTex, i.UVMainTex);
                fixed4 shaderMainTexCol2 = tex2D(_ShadeMainTex2, i.UVMainTex);

                float3 tangentLightDir = normalize(i.lightDir);



                half4 lit = mainTexCol * _Color;
                half4 sha = shaderMainTexCol * _ShadeColor;
                half4 lit2 = mainTexCol2 * _Color2;
                half4 sha2 = shaderMainTexCol2 * _ShadeColor2;


                // 使用反射矢量对默认反射立方体贴图进行采样
                half4 skyData = 0;
                // 将立方体贴图数据解码为实际颜色
                half3 skyColor = 0;


                switch(_WorldRefSwitch) {
                    case 1:
                    switch(_WorldRefUseMapSwitch){
                        case 1:
                        skyColor = texCUBE(_EnvMap,i.worldReflection).rgb;

                        break;
                        default:
                        skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldReflection);
                        skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                        break;
                    }
                    // 将立方体贴图数据解码为实际颜色
                    
                    lit.rgb *= skyColor;
                    sha.rgb *= skyColor;
                    break;
                    default:
                    
                    break;
                }

                switch(_WorldRefSwitch1) {
                    case 1:
                    switch(_WorldRefUseMapSwitch1){
                        case 1:
                        skyColor = texCUBE(_EnvMap1,i.worldReflection).rgb;
                        break;
                        default:
                        skyData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, i.worldReflection);
                        skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                        break;
                    }
                    

                    
                    // 将立方体贴图数据解码为实际颜色
                    skyColor = DecodeHDR (skyData, unity_SpecCube0_HDR);
                    lit2.rgb *= skyColor;
                    sha2.rgb *= skyColor;
                    break;
                    default:
                    
                    break;
                }

                fixed4 col2;

                switch(_RateAddSwitch) {
                    case 1:
                    col2 =  lerp(lit,sha,lightIntensity) * beishu + lerp(lit2,sha2,lightIntensity) * beishu2 * rate;
                    rate = 0;
                    break;
                    default:
                    col2 =  lerp(lerp(lit,sha,lightIntensity) * beishu ,lerp(lit2,sha2,lightIntensity) * beishu2,rate);
                    break;
                }
                

                fixed3 albedo = col2.rgb * i.color.rgb ;

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                
                fixed3 diffuse = 0;
                switch(_NeedLightSwitch){
                    case 1:             
                    fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                    fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

                    fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

                    fixed3 halfDir = normalize(worldLightDir + viewDir);

                    //世界光照
                    //高光
                    diffuse = _LightColor0.rgb * lerp(sha * _ShadeColor ,sha2 * _ShadeColor2 ,rate) .rgb * i.color.rgb * pow(max(0, dot(worldNormal, halfDir)),_Gloss);

                    ambient = ambient + diffuse * shadowAttenuation * _LightBeiShu ;
                    break;
                    case 2:


                    half3 lighting = lightColor;
                    lighting = lerp(lighting, max(EPS_COL, max(lighting.x, max(lighting.y, lighting.z))), _LightColorAttenuation); // color atten
                    ambient = lighting * albedo ;


                    half3 toonedGI = 0.5 * (ShadeSH9(half4(0, 1, 0, 1)) + ShadeSH9(half4(0, -1, 0, 1)));

                    half3 indirectLighting = lerp(toonedGI, ShadeSH9(half4(worldNormal, 1)), _IndirectLightIntensity);
                    indirectLighting = lerp(indirectLighting, max(EPS_COL, max(indirectLighting.x, max(indirectLighting.y, indirectLighting.z))), _LightColorAttenuation); // color atten
                    ambient += indirectLighting * col2;
                    
                    ambient = min(ambient, col2); // comment out if you want to PBR absolutely.


                    // half3 staticRimLighting = 1;
                    // half3 mixedRimLighting = lighting + indirectLighting;

                    // half3 rimLighting = lerp(staticRimLighting, mixedRimLighting, _RimLightingMix);
                    // half3 rim = pow(saturate(1.0 - dot(worldNormal, worldView) + _RimLift), _RimFresnelPower) * _RimColor.rgb * tex2D(_RimTexture, mainUv).rgb;
                    // col += lerp(rim * rimLighting, half3(0, 0, 0), 0);


                    break;
                    default:
                    break;
                }

                //溶解混合
                fixed3 finalColor = lerp(ambient , burnColor, tRate);

                fixed a =  lerp(mainTexCol.a,mainTexCol2.a,rate);

                switch(_BurnTypeSwitch){
                    case 1:
                    a = (1+ clamp(burn.r - abs(_Burn_1_I - burnAmount) ,-1,0)) *a;
                    break;
                    default:
                    clip(burn.r - abs(_Burn_1_I - burnAmount));
                    break;
                }

                switch(_AlphaSwitch) {
                    case 1:
                    a = i.color.a*a;
                    break;
                    default:
                    a = min(i.color.a,a);
                    break;
                }
                

                //黑色增幅混合
                float a2 = int(clamp(i.color.r+i.color.g+i.color.b,0,1) +  0.99999);
                a = clamp((1-a2) * lerp(beishu,beishu2,rate) /_BlackBeiShu * a  + a2 * a,0,1) *_Alpha;

                fixed shadow2 = SHADOW_ATTENUATION(i);
                // 用阴影使光照变暗，保持环境不变
                finalColor.rgb *= shadow2 + ShadeSH9(half4(worldNormal, 1));

                return fixed4(color.rgb * saturate(_Fresnel2) + finalColor, a) ;

            }
            ENDCG
        }
    }
}
