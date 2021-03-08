/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*
* This program uses the following code, which is provided under the MIT License.
* https://download.unity3d.com/download_unity/008688490035/builtin_shaders-2018.4.20f1.zip?_ga=2.171325672.957521966.1599549120-262519615.1592172043
*
*/

Shader "Kamishiro/ScrollCalendar/Unlit"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "white" { }
        [NoScaleOffset] _Loading ("Loading Texture", 2D) = "white" { }
        _Scroll ("Scroll", Range(0, 1)) = 0
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"
            #include "ScrollCalendar.hlsl"

            struct appdata
            {
                float4 vertex: POSITION;
                float2 uv: TEXCOORD0;
                float2 uv1: TEXCOORD1;
            };

            struct v2f
            {
                float2 uv: TEXCOORD0;
                float2 uv1: TEXCOORD1;
                UNITY_FOG_COORDS(1)
                float4 vertex: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _Loading;
            float4 _Loading_ST;
            float _Scroll;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv1 = TRANSFORM_TEX(v.uv1, _Loading);
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                fixed4 col = isLoaded(_MainTex)? tex2D(_MainTex, scrollUV(i.uv, _Scroll)): tex2D(_Loading, i.uv1);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG

        }
    }
}
