// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "roundedRectLine"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
		_StencilComp ("Stencil Comparison", Float) = 8
		_Stencil ("Stencil ID", Float) = 0
		_StencilOp ("Stencil Operation", Float) = 0
		_StencilWriteMask ("Stencil Write Mask", Float) = 255
		_StencilReadMask ("Stencil Read Mask", Float) = 255

		_ColorMask ("Color Mask", Float) = 15

		[Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
		_round("round", Range( 0 , 0.5)) = 0.33
		_size("size", Range( 0 , 0.5)) = 0.5
		_width("width", Range( 0 , 0.5)) = 0.02

	}

	SubShader
	{
		LOD 0

		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" "CanUseSpriteAtlas"="True" }
		
		Stencil
		{
			Ref [_Stencil]
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
			CompFront [_StencilComp]
			PassFront [_StencilOp]
			FailFront Keep
			ZFailFront Keep
			CompBack Always
			PassBack Keep
			FailBack Keep
			ZFailBack Keep
		}


		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask [_ColorMask]

		
		Pass
		{
			Name "Default"
		CGPROGRAM
			
			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "UnityUI.cginc"

			#pragma multi_compile __ UNITY_UI_CLIP_RECT
			#pragma multi_compile __ UNITY_UI_ALPHACLIP
			
			#define ASE_NEEDS_FRAG_COLOR

			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				half2 texcoord  : TEXCOORD0;
				float4 worldPosition : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
				
			};
			
			uniform fixed4 _Color;
			uniform fixed4 _TextureSampleAdd;
			uniform float4 _ClipRect;
			uniform sampler2D _MainTex;
			uniform float _size;
			uniform float _round;
			uniform float _width;
			float MyCustomExpression2( float2 v, float n, float r )
			{
				float2 p = (v * 2.0 - 1) /2; 
				float2 d = abs(p) - n + r;
				  return min(max(d.x, d.y), 0.0) + length(max(d,0.0))- r;
			}
			
			float MyCustomExpression14( float2 v, float n, float r )
			{
				float2 p = (v * 2.0 - 1) /2; 
				float2 d = abs(p) - n + r;
				  return min(max(d.x, d.y), 0.0) + length(max(d,0.0))- r;
			}
			

			
			v2f vert( appdata_t IN  )
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID( IN );
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				UNITY_TRANSFER_INSTANCE_ID(IN, OUT);
				OUT.worldPosition = IN.vertex;
				
				
				OUT.worldPosition.xyz +=  float3( 0, 0, 0 ) ;
				OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

				OUT.texcoord = IN.texcoord;
				
				OUT.color = IN.color * _Color;
				return OUT;
			}

			fixed4 frag(v2f IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 texCoord4 = IN.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 v2 = texCoord4;
				float n2 = _size;
				float r2 = _round;
				float localMyCustomExpression2 = MyCustomExpression2( v2 , n2 , r2 );
				float temp_output_3_0_g3 = ( 0.0 - localMyCustomExpression2 );
				float2 v14 = texCoord4;
				float n14 = ( _size - _width );
				float r14 = ( _round - _width );
				float localMyCustomExpression14 = MyCustomExpression14( v14 , n14 , r14 );
				float temp_output_3_0_g4 = ( 0.0 - localMyCustomExpression14 );
				float4 appendResult33 = (float4(IN.color.r , IN.color.g , IN.color.b , ( ( saturate( ( temp_output_3_0_g3 / fwidth( temp_output_3_0_g3 ) ) ) - saturate( ( temp_output_3_0_g4 / fwidth( temp_output_3_0_g4 ) ) ) ) * IN.color.a )));
				
				half4 color = appendResult33;
				
				#ifdef UNITY_UI_CLIP_RECT
                color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
                #endif
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

				return color;
			}
		ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18900
2622;597;1851;659;578.6937;231.4179;1.100626;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-153.2734,251.8249;Inherit;False;Property;_round;round;0;0;Create;True;0;0;0;False;0;False;0.33;0.081;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;3.451599,334.89;Inherit;False;Property;_width;width;2;0;Create;True;0;0;0;False;0;False;0.02;0.021;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-230.2734,141.8249;Inherit;False;Property;_size;size;1;0;Create;True;0;0;0;False;0;False;0.5;0.461;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;4;-228.2297,-52.25525;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;18;83.04742,-33.89081;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;25;160.0474,75.10919;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.05;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;14;78.04742,-144.8908;Inherit;False;float2 p = (v * 2.0 - 1) /2@ $float2 d = abs(p) - n + r@$  return min(max(d.x, d.y), 0.0) + length(max(d,0.0))- r@;1;False;3;True;v;FLOAT2;0,0;In;;Inherit;False;True;n;FLOAT;0.38;In;;Inherit;False;True;r;FLOAT;0.31;In;;Inherit;False;My Custom Expression;True;False;0;3;0;FLOAT2;0,0;False;1;FLOAT;0.38;False;2;FLOAT;0.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;2;238.7703,222.7448;Inherit;False;float2 p = (v * 2.0 - 1) /2@ $float2 d = abs(p) - n + r@$  return min(max(d.x, d.y), 0.0) + length(max(d,0.0))- r@;1;False;3;True;v;FLOAT2;0,0;In;;Inherit;False;True;n;FLOAT;0.38;In;;Inherit;False;True;r;FLOAT;0.31;In;;Inherit;False;My Custom Expression;True;False;0;3;0;FLOAT2;0,0;False;1;FLOAT;0.38;False;2;FLOAT;0.31;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;28;708.0002,243.093;Inherit;False;Step Antialiasing;-1;;3;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;29;629.3784,-97.5593;Inherit;False;Step Antialiasing;-1;;4;2a825e80dfb3290468194f83380797bd;0;2;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;31;1036.404,294.6549;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;22;856.0474,17.10919;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;1400.84,356.6162;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;1434.085,109.0985;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;1089,-58;Float;False;True;-1;2;ASEMaterialInspector;0;4;roundedRectLine;5056123faa0c79b47ab6ad7e8bf059a4;True;Default;0;0;Default;2;False;True;2;5;False;-1;10;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;True;True;True;True;True;0;True;-9;False;False;False;False;False;False;False;True;True;0;True;-5;255;True;-8;255;True;-7;0;True;-4;0;True;-6;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;False;True;2;False;-1;True;0;True;-11;False;True;5;Queue=Transparent=Queue=0;IgnoreProjector=True;RenderType=Transparent=RenderType;PreviewType=Plane;CanUseSpriteAtlas=True;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;False;0
WireConnection;18;0;10;0
WireConnection;18;1;30;0
WireConnection;25;0;11;0
WireConnection;25;1;30;0
WireConnection;14;0;4;0
WireConnection;14;1;18;0
WireConnection;14;2;25;0
WireConnection;2;0;4;0
WireConnection;2;1;10;0
WireConnection;2;2;11;0
WireConnection;28;1;2;0
WireConnection;29;1;14;0
WireConnection;22;0;28;0
WireConnection;22;1;29;0
WireConnection;34;0;22;0
WireConnection;34;1;31;4
WireConnection;33;0;31;1
WireConnection;33;1;31;2
WireConnection;33;2;31;3
WireConnection;33;3;34;0
WireConnection;1;0;33;0
ASEEND*/
//CHKSM=1033A0F12664546EBFC0045E96C578554D27995E