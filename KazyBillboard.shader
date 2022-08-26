// Source: https://en.wikibooks.org/wiki/Cg_Programming/Unity/Billboards
// Source: http://www.unity3d-france.com/unity/phpBB3/viewtopic.php?t=12304
// Disclaimer: I know nothing about shader devlopment and cobbled this together from several different shaders.
Shader "Kazy/Kazy Billboards Alpha"
{
    Properties
    {
        _MainTex ("RGBA Texture Image", 2D) = "white" {} 
        _Cutoff ("Alpha Cutoff", Float) = 0.5
        _ScaleX ("Scale X", Float) = 1.0
        _ScaleY ("Scale Y", Float) = 1.0
    }
 
    SubShader
    {  
	        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
            "DisableBatching"="True"
        }
        Cull Off
		zWrite Off
        Pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
 
            #pragma shader_feature IGNORE_ROTATION_AND_SCALE
            #pragma vertex vert
            #pragma fragment frag


 
            // User-specified uniforms          
            uniform sampler2D _MainTex;      
            uniform float _ScaleX;
            uniform float _ScaleY;
			
            float _Transparency;
            float4 _MainTex_ST;
			float _CutoutThresh;
			float _Cutoff;
 
            struct vertexInput
            {
                float4 vertex : POSITION;
                float4 tex : TEXCOORD0;
            };
 
            struct vertexOutput
            {
                float4 pos : SV_POSITION;
                float2 tex : TEXCOORD0;
            };
            vertexOutput vert(vertexInput input)
            {
                // The world position of the center of the object
                float3 worldPos = mul(unity_ObjectToWorld, float4(0, 0, 0, 1)).xyz;
 
                // Distance between the camera and the center
                float3 dist = _WorldSpaceCameraPos - worldPos;
 
                // atan2(dist.x, dist.z) = atan (dist.x / dist.z)
                // With atan the tree inverts when the camera has the same z position
                float angle = atan2(dist.x, dist.z);
 
                float3x3 rotMatrix;
                float cosinus = cos(angle);
                float sinus = sin(angle);
       
                // Rotation matrix in Y
                rotMatrix[0].xyz = float3(cosinus, 0, sinus);
                rotMatrix[1].xyz = float3(0, 1, 0);
                rotMatrix[2].xyz = float3(- sinus, 0, cosinus);
 
                // The position of the vertex after the rotation
                float4 newPos = float4(mul(rotMatrix, input.vertex * float4(_ScaleX, _ScaleY, 0, 0)), 1);
 
                // The model matrix without the rotation and scale
                float4x4 matrix_M_noRot = unity_ObjectToWorld;
                matrix_M_noRot[0][0] = 1;
                matrix_M_noRot[0][1] = 0;
                matrix_M_noRot[0][2] = 0;
 
                matrix_M_noRot[1][0] = 0;
                matrix_M_noRot[1][1] = 1;
                matrix_M_noRot[1][2] = 0;
 
                matrix_M_noRot[2][0] = 0;
                matrix_M_noRot[2][1] = 0;
                matrix_M_noRot[2][2] = 1;
 
                vertexOutput output;
 
                // The position of the vertex in clip space ignoring the rotation and scale of the object
                #if IGNORE_ROTATION_AND_SCALE
                output.pos = mul(UNITY_MATRIX_VP, mul(matrix_M_noRot, newPos));
                #else
                output.pos = mul(UNITY_MATRIX_VP, mul(unity_ObjectToWorld, newPos));
                #endif
 
                output.tex = TRANSFORM_TEX(input.tex, _MainTex);
 
                return output;
            }
            float4 frag(vertexOutput input) : COLOR
            {
				float4 textureColor = tex2D(_MainTex, input.tex.xy);  
				if (textureColor.a < _Cutoff)
               // alpha value less than user-specified threshold?
				{
				discard; // yes: discard this fragment
				}
				return textureColor;
            }
            ENDCG
        }
    }
}
