Shader "Unlit/37"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_WaveMap("WaveMap",2D) = "white"{}
		_EnvMap("EnvMap",Cube) = "_Skybox"{}
		_WaveXSpeed("WaveXSpeed",Range(-0.1,0.1)) = 0
		_WaveYSpeed("WaveYSpeed",Range(-0.1,0.1)) = 0
		_Distortion("Distortion",Range(0,2000)) = 1
	}
	SubShader
	{
		Tags{"Queue" = "Transparent" "RenderType" = "opaque"}

		GrabPass{"_RefractionTex"}

		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _WaveMap;
			float4 _WaveMap_ST;
			samplerCUBE _EnvMap;
			fixed _WaveXSpeed;
			fixed _WaveYSpeed;
			float _Distortion;
			sampler2D _RefractionTex;
			float4 _RefractionTex_TexelSize;

			struct v2f
			{
				float4 pos:SV_POSITION;
				float4 uv : TEXCOORD0;
				float4 screenPos:TEXCOORD1;
				float4 ttw1:TEXCOORD2;
				float4 ttw2:TEXCOORD3;
				float4 ttw3:TEXCOORD4;
			};

			v2f vert(appdata_tan v)
			{
				v2f o;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.screenPos = ComputeGrabScreenPos(o.pos);

				o.uv.xy = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord,_WaveMap);

				float3 worldPos = mul(unity_ObjectToWorld,v.vertex);
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
				fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				fixed3 worldBinormal = cross(worldNormal,worldTangent) * v.tangent.w;

				o.ttw1 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
				o.ttw2 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
				o.ttw3 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);

				return o;
			}

			fixed4 frag(v2f i) :SV_Target
			{
				float3 worldPos = float3(i.ttw1.w,i.ttw2.w,i.ttw3.w);
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				float2 speed = _Time.y * float2(_WaveXSpeed,_WaveYSpeed);
				
				fixed3 bump1 = UnpackNormal(tex2D(_WaveMap,i.uv.zw + speed)).rgb;
				fixed3 bump2 = UnpackNormal(tex2D(_WaveMap,i.uv.zw - speed)).rgb;
				fixed3 bump = normalize(bump1 + bump2);

				float2 offset = bump.xy * _Distortion * _RefractionTex_TexelSize.xy;
				i.screenPos.xy = offset * i.screenPos.z + i.screenPos.xy;
				fixed3 refractColor = tex2D(_RefractionTex,i.screenPos.xy/i.screenPos.w).rgb;

				bump = normalize(half3(dot(i.ttw1.xyz,bump),dot(i.ttw2.xyz,bump),dot(i.ttw3.xyz,bump)));

				fixed4 texColor = tex2D(_MainTex,i.uv.xy + speed);
				fixed3 reflectDir = reflect(-viewDir,bump);
				fixed3 reflectColor = texCUBE(_EnvMap,reflectDir).rgb * texColor.rgb * _Color.rgb;

				fixed fresnel = pow(1 - saturate(dot(viewDir,bump)),4);
				fixed3 finalColor = reflectColor * fresnel + refractColor * (1 - fresnel);

				return fixed4(finalColor,1);
			}
			ENDCG
		}
	}
}
