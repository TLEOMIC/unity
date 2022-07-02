Shader "GrabPassInvert"
{
    Properties
    { 
        _Color ("_color",  Color) = (1,1,1,1)
        _GrayscaleMax ("灰度颜色max(粒子1x)", Range(0, 1)) = 0.50
        _GrayscaleMin ("灰度颜色min(粒子1y)", Range(0, 1)) = 0.50
        _GrayscaleBOW ("灰度白/黑(粒子1z)", Range(0, 1)) = 0
        _GrayscaleWeight  ("灰度权重(粒子1w)", Range(0, 1)) = 1
        [Enum(Close,0,Open,1)] _Switch ("灰度参数粒子控制", Int) = 0
        _MainTex ("贴图1", 2D) = "white" {}
        _PolarCoordinates ("贴图极坐标加法", Range(-1, 1)) = 0
        _PolarCoordinates1 ("贴图极坐标乘法", Range(0, 10)) = 2
        _PolarCoordinates2 ("贴图极坐标旋转", Range(0, 1)) = 1

        _PolarCoordinatesSpeed ("贴图速度1", Range(0,1000)) = 0
        _PolarCoordinatesSpeed2 ("贴图速度2", Range(-1000, 1000)) = 0

        _BeiShu ("颜色倍数", Range(0, 1000)) = 0

        
        [Enum(Close,0,Open,1)] _Switch2 ("反色", Int) = 0
        
        _BeiJingGrayscaleMax ("背景灰度颜色max(粒子2x)", Range(0, 1)) = 0.50
        _BeiJingGrayscaleMin ("背景灰度颜色min(粒子2y)", Range(0, 1)) = 0.50
        _BeiJingGrayscaleBOW("背景灰度白/黑(粒子2z)", Range(0, 1)) = 0
        _BeiJingGrayscaleWeight("背景权重(粒子2w)", Range(0, 1)) = 0
        [Enum(Close,0,Open,1)] _Switch3 ("背景参数粒子控制", Int) = 0

        [Enum(Add,0,max,1,min,2,lerp,3)] _MixedMode ("混合模式", Int) = 0


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
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 grabPos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 uv : TEXCOORD1;
                float4 uv1 : TEXCOORD2;
                float4 uv2 : TEXCOORD3;
            };

            struct appdata
            {
                float4 vertex : POSITION;

                float4 uv : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 uv2 : TEXCOORD2;
                
            };

            v2f vert(appdata v) {
                v2f o;
                o.uv = v.uv;
                o.uv1 = v.uv1;
                o.uv2 = v.uv2;
                // 使用 UnityCG.cginc 中的 UnityObjectToClipPos 来计算
                // 顶点的裁剪空间
                o.pos = UnityObjectToClipPos(v.vertex);
                // 使用 UnityCG.cginc 中的 ComputeGrabScreenPos 函数
                // 获得正确的纹理坐标
                o.grabPos = ComputeGrabScreenPos(o.pos);
                return o;
            }

            sampler2D _BackgroundTexture;
            sampler2D _MainTex;
            float _GrayscaleMax;
            float _GrayscaleMin;
            float _GrayscaleBOW;
            float _GrayscaleWeight;

            float _PolarCoordinates;
            float _PolarCoordinates1;
            float _PolarCoordinates2;

            float _PolarCoordinatesSpeed;
            float _PolarCoordinatesSpeed2;
            fixed4 _Color;
            float _BeiShu;
            float _Switch;
            float _Switch2;

            float _Switch3;
            float _BeiJingGrayscaleMax;
            float _BeiJingGrayscaleMin;
            float _BeiJingGrayscaleBOW;
            float _BeiJingGrayscaleWeight;

            float _MixedMode;

            float3 RGB2HSV(float3 c)  
            {
                float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);  
                float4 p = lerp(float4(c.bg, K.wz), float4(c.gb, K.xy), step(c.b, c.g));  
                float4 q = lerp(float4(p.xyw, c.r), float4(c.r, p.yzx), step(p.x, c.r));  
                float d = q.x - min(q.w, q.y);  
                float e = 1.0e-10;  
                return float3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);  
            }  
            float3 HSV2RGB(float3 c)  
            {
                float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);  
                float3 p = abs(frac(c.xxx + K.xyz) * 6.0 - K.www);  
                return c.z * lerp(K.xxx, saturate(p - K.xxx), c.y);  
            }
            
            half4 frag(v2f i) : SV_Target
            {

                switch(_Switch){
                    case 1:
                    _GrayscaleMax = i.uv.z;
                    _GrayscaleMin =i.uv.w;
                    _GrayscaleBOW = i.uv1.x;
                    _GrayscaleWeight = i.uv1.y;
                    break;
                    default:
                    break;


                }

                switch(_Switch3){
                    case 1:
                    _BeiJingGrayscaleMax = i.uv1.z;
                    _BeiJingGrayscaleMin =i.uv1.w;
                    _BeiJingGrayscaleBOW = i.uv2.x;
                    _BeiJingGrayscaleWeight = i.uv2.y;
                    break;
                    default:
                    break;


                }

                

                //极坐标
                float2 uv =  i.uv-0.5;
                

                //d为各个象限坐标到0点距离,数值为0~0.5
                float distance=length(uv);
                

                //0~0.5放大到0~1
                distance *=_PolarCoordinates1;
                

                //4象限坐标求弧度范围是 [-pi,+pi]
                float angle=atan2(uv.x,uv.y);
                
                //把 [-pi,+pi]转换为0~1
                float angle01=angle/3.14159/_PolarCoordinates2 + _PolarCoordinates;
                // 

                //输出角度与距离
                // distance += _PolarCoordinatesSpeed; cos((_Time.y%100)/100*360);
                distance += (_Time.y%_PolarCoordinatesSpeed)/_PolarCoordinatesSpeed*_PolarCoordinatesSpeed2;

                // return float4(distance,angle01,0,1);
                

                // return float4(i.uv,0,1);
                half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);
                half4 bg_bgcolor;
                float4 col = tex2D(_MainTex, float2(distance,angle01)) * _BeiShu;
                bgcolor = lerp(bgcolor,clamp(bgcolor+bgcolor*col,0,1),1-(col.r+col.g+col.b)/3);
                // bgcolor = clamp(bgcolor + bgcolor*col,0,1);
                bg_bgcolor = lerp(bgcolor,1-bgcolor,_BeiJingGrayscaleBOW);
                bgcolor = lerp(bgcolor,1-bgcolor,_GrayscaleBOW);
                


                float3 hsv = RGB2HSV(bgcolor.rgb);
                float3 hsv2 = RGB2HSV(_Color);
                float r = smoothstep(_GrayscaleMin,_GrayscaleMax,(1-hsv.y)  * 0.65 + hsv.z *0.35);
                float r2 = smoothstep(_GrayscaleMin, _GrayscaleMax,(1-hsv.y)  * 0.65 + hsv.z *0.35);


                float3 bg_hsv = RGB2HSV(bg_bgcolor.rgb);
                float3 bg_hsv2 = RGB2HSV(_Color);
                float bg_r = smoothstep(_BeiJingGrayscaleMin,_BeiJingGrayscaleMax,(1-bg_hsv.y)  * 0.65 + bg_hsv.z *0.35);
                float bg_r2 = smoothstep(_BeiJingGrayscaleMin, _BeiJingGrayscaleMax,(1-bg_hsv.y)  * 0.65 + bg_hsv.z *0.35);

                // 

                // r = lerp(r,1-r,_GrayscaleBOW);
                //  return float4(r,r,r,1);
                // max(max(bgcolor.r,bgcolor.g),bgcolor.b)
                // 
                // return()
                // return float4(bgcolor.rgb,1);
                // float r = smoothstep(_GrayscaleMin   _GrayscaleMax,(bgcolor.r+bgcolor.g+bgcolor.b)/3);
                // float r = smoothstep(_GrayscaleMin   _GrayscaleMax,max(bgcolor.r,max(bgcolor.g,bgcolor.b)));
                //
                // return float4(r,r,r,1) * float4(HSV2RGB(float3(hsv2.x,min(hsv2.y,hsv.y),hsv.z)),1) ;
                

                float4 bgcolor1 = float4(r,r,r,1) * float4(HSV2RGB(float3(hsv2.x,min(hsv2.y,hsv.y),hsv.z)),1) ;
                float4 bg_bgcolor1 = float4(bg_r,bg_r,bg_r,1) * float4(HSV2RGB(float3(bg_hsv2.x,min(bg_hsv2.y,bg_hsv.y),bg_hsv.z)),1) ;

                switch(_Switch2){
                    case 1:
                    float3 hsv3 = RGB2HSV(1-bgcolor1.rgb);
                    float3 hsv4 = RGB2HSV(bgcolor1.rgb);

                    float3 bg_hsv3 = RGB2HSV(1-bg_bgcolor1.rgb);
                    float3 bg_hsv4 = RGB2HSV(bg_bgcolor1.rgb);

                    bgcolor1 = float4(HSV2RGB(float3(hsv3.x,hsv4.y,hsv4.z)),1);
                    bg_bgcolor1 = float4(HSV2RGB(float3( bg_hsv3.x, bg_hsv4.y, bg_hsv4.z)),1);
                    break;
                    default:
                    
                    break;

                }

                switch(_MixedMode){
                    case 1:
                    return max(bgcolor1,bg_bgcolor1);
                    break;
                    case 2:
                    return min(bgcolor1,bg_bgcolor1);
                    break;
                    case 3:
                    return lerp(bgcolor1,bg_bgcolor1,clamp(-_GrayscaleWeight + _BeiJingGrayscaleWeight,0,1));
                    break;
                    default:
                    return bgcolor1 * _GrayscaleWeight + bg_bgcolor1 * _BeiJingGrayscaleWeight;
                    break;
                }

                
                
                // float r = bgcolor.r;
                // return r * bgcolor;
            }
            ENDCG
        }

    }
}