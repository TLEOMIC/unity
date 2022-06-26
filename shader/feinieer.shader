Shader "Unlit/feinieer"{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_FresnelScale("FresnelScale",Range(0,1))=0.5
		_Cubemap("Cubemap",Cube)="_Skybox"{}
        _Color ("Main Color", Color) = (1,1,1,1)
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
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float3 normal:NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float3 worldPos:TEXCOORD2;
				float3 worldNormal:TEXCOORD3;
				float3 worldViewDir:TEXCOORD4;
				float3 worldReflection:TEXCOORD5;
            };

            sampler2D _MainTex;
			samplerCUBE _Cubemap;
            float4 _MainTex_ST;
            float _FresnelScale;
             fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldViewDir = UnityWorldSpaceViewDir(o.worldPos);
				o.worldReflection = reflect(-o.worldViewDir, o.worldNormal);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				float3 worldNormal = normalize(i.worldNormal);
				float3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 worldViewDir = normalize(i.worldViewDir);

				// fixed3 diffuse = tex2D(_MainTex, i.uv).rgb*_LightColor0.rgb*saturate(dot(worldNormal, worldLightDir));

				fixed3 reflection = texCUBE(_Cubemap, i.worldReflection).xyz;

				float fresnel = _FresnelScale + (1 - _FresnelScale)*pow(1 - dot(worldViewDir, worldNormal), 5);//菲涅尔系数
				// fixed3 color = ambient + lerp(_Color, reflection, saturate(fresnel));
                fixed3 color = ambient + _Color * saturate(fresnel);
                UNITY_APPLY_FOG(i.fogCoord, color);
				return fixed4(color, 1);
            }
            ENDCG
        }
    }
}

