Shader "GrabPassInvert"
{
    Properties
    { 
        _Number ("_Number", Range(0.5, 1)) = 0.50
        _Number0 ("_Number0", Range(0, 1)) = 0
 _MainTex ("贴图1", 2D) = "white" {}
        _Number1 ("_Number1", Range(-1, 1)) = 0
        _Number2 ("_Number2", Range(0, 10)) = 2
        _Number3 ("_Number3", Range(0, 1)) = 1

        _Number4 ("_Number4", Range(0,1000)) = 0
        _Number5 ("_Number5", Range(0, 1000)) = 0

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
                float2 uv : TEXCOORD1;
            };

            struct appdata
            {
                float4 vertex : POSITION;

                float4 uv : TEXCOORD0;

                
            };

            v2f vert(appdata v) {
                v2f o;
                o.uv = v.uv;
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
            float _Number;
            float _Number0;
            float _Number1;
            float _Number2;
            float _Number3;

            float _Number4;
            float _Number5;

            half4 frag(v2f i) : SV_Target
            {


                //极坐标
                float2 uv =  i.uv-0.5;
                

                //d为各个象限坐标到0点距离,数值为0~0.5
                float distance=length(uv);
                

                //0~0.5放大到0~1
                distance *=_Number2;
                

                //4象限坐标求弧度范围是 [-pi,+pi]
                float angle=atan2(uv.x,uv.y);
                
                //把 [-pi,+pi]转换为0~1
                float angle01=angle/3.14159/_Number3 + _Number1;
                // 

                //输出角度与距离
                // distance += _Number4; cos((_Time.y%100)/100*360);
                 distance += (_Time.y%_Number4)/_Number4*_Number5;

                // return float4(distance,angle01,0,1);
   

                // return float4(i.uv,0,1);
                half4 bgcolor = tex2Dproj(_BackgroundTexture, i.grabPos);

                float4 col = tex2D(_MainTex, float2(distance,angle01));
                bgcolor.r = clamp(bgcolor.r + bgcolor.r*col.r,0,1);
                bgcolor.r = lerp(bgcolor.r,1-bgcolor.r,_Number0);

                float r = smoothstep(1-_Number,_Number,bgcolor.r);

                
                // float r = bgcolor.r;
                return float4(r,r,r,1);
            }
            ENDCG
        }

    }
}