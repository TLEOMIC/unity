Shader "diy/sesan"
{
    Properties
    { 
        _Scale("_Scale", Range(0,1)) = 1

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
            };

            struct appdata
            {
                float4 vertex : POSITION;

                float4 uv : TEXCOORD0;
                float4 uv1 : TEXCOORD1;

                
            };
            float _Scale;

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
                return o;
            }

            sampler2D _BackgroundTexture;




            
            half4 frag(v2f i) : SV_Target
            {



                fixed3 col = fixed3(0,0,0);

                fixed scale = _Scale ; 

                scale = saturate(scale);

                float4 uv_0 = i.grabPos ;
                uv_0 += scale;
               
                float4 uv_1 = i.grabPos ;
                uv_1 -= scale;
                

                col.r = tex2Dproj(_BackgroundTexture, uv_0).r;
                col.g = tex2Dproj(_BackgroundTexture, i.grabPos).g;
                col.b = tex2Dproj(_BackgroundTexture, uv_1).b;

                return fixed4(col,1);

                
            }
            ENDCG
        }

    }
}