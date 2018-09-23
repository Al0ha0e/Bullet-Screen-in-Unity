Shader "Unlit/Bullet"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TexWidth("W",Float) = 0
		_TexHeight("H",Float) = 0
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag		
			#include "UnityCG.cginc"
			StructuredBuffer<float4> Position;
			StructuredBuffer<float3> Color;

			struct v2g
			{
				fixed3 color0 : COLOR0;
				float4 vertex : POSITION;
			};

			struct g2f
			{
				fixed3 color0 : COLOR0;
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2g vert (uint id : SV_VertexID)
			{
				v2g o;
				o.vertex = Position[id];
				o.color0 = Color[id];
				return o;
			}

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _TexWidth;
			float _TexHeight;

			[maxvertexcount(6)]

			void geom(point v2g gin[1], inout TriangleStream<g2f> triStream)
			{
				float H = gin[0].vertex.w * _TexHeight;
				float W = gin[0].vertex.w *  _TexWidth;
				g2f o;
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(0.0f,0.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(gin[0].vertex);
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(0.0f, 1.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(float3(gin[0].vertex.x, gin[0].vertex.y + H, gin[0].vertex.z));
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(1.0f,1.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(float3(gin[0].vertex.x + W, gin[0].vertex.y + H, gin[0].vertex.z));
				triStream.Append(o);

				triStream.RestartStrip();

				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(0.0f, 0.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(gin[0].vertex);
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(1.0f, 1.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(float3(gin[0].vertex.x + W, gin[0].vertex.y + H, gin[0].vertex.z));
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(1.0f,0.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(float3(gin[0].vertex.x + W, gin[0].vertex.y , gin[0].vertex.z));
				triStream.Append(o);
				triStream.RestartStrip();
			}

			fixed4 frag (g2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				if (col.a == 0) discard;
				if (col.r == 0) { col.r = 0.0f; col.g = 0.0f, col.b = 0.0f; }
				else { col.rgb = i.color0.rgb; }

				col.a = 1.0;
				return col;
			}
			ENDCG
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag		
			#include "UnityCG.cginc"
			StructuredBuffer<float4> Position;
			StructuredBuffer<float3> Color;

			struct v2g
			{
				fixed3 color0 : COLOR0;
				float4 vertex : POSITION;
			};

			struct g2f
			{
				fixed3 color0 : COLOR0;
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2g vert(uint id : SV_VertexID)
			{
				v2g o;
				o.vertex = Position[id];
				o.color0 = Color[id];
				return o;
			}

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _TexWidth;
			float _TexHeight;

			[maxvertexcount(6)]

			void geom(point v2g gin[1], inout TriangleStream<g2f> triStream)
			{
				float H = _TexHeight / 2; float W =  _TexWidth / 2;
				/*
				float3 LD = float3(-W,-H,gin[0].vertex.z);
				float3 LU = float3(-W,H, gin[0].vertex.z);
				float3 RU = float3(W,H, gin[0].vertex.z);
				float3 RD = float3(W,-H, gin[0].vertex.z);
				*/
				
				float3 LD = float3(cos(gin[0].vertex.x - H)*gin[0].vertex.w, sin(gin[0].vertex.x - H)*gin[0].vertex.w, gin[0].vertex.z + W);
				float3 LU = float3(cos(gin[0].vertex.x + H)*gin[0].vertex.w, sin(gin[0].vertex.x + H)*gin[0].vertex.w, gin[0].vertex.z + W);
				float3 RU = float3(cos(gin[0].vertex.x + H)*gin[0].vertex.w, sin(gin[0].vertex.x + H)*gin[0].vertex.w, gin[0].vertex.z - W);
				float3 RD = float3(cos(gin[0].vertex.x - H)*gin[0].vertex.w, sin(gin[0].vertex.x - H)*gin[0].vertex.w, gin[0].vertex.z - W);
				
				g2f o;
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(0.0f,0.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(LD);
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(0.0f, 1.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(LU);
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(1.0f,1.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(RU);
				triStream.Append(o);

				triStream.RestartStrip();

				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(0.0f, 0.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(LD);
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(1.0f, 1.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(RU);
				triStream.Append(o);
				o.color0 = gin[0].color0;
				o.uv = TRANSFORM_TEX(float2(1.0f,0.0f), _MainTex);
				o.vertex = UnityObjectToClipPos(RD);
				triStream.Append(o);
				triStream.RestartStrip();
			}

			fixed4 frag(g2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				if (col.a == 0) discard;
				
				if (col.r == 0) { col.r = 0.0f; col.g = 0.0f, col.b = 0.0f; }
				else { col.rgb = i.color0.rgb; }
				
				//col.rgb = i.color0.rgb;
				col.a = 1.0;
				return col;
			}
			ENDCG
		}
	}
}
