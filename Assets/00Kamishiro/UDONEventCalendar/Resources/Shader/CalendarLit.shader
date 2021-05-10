/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*
* This program uses the following code, which is provided under the MIT License.
* https://download.unity3d.com/download_unity/008688490035/builtin_shaders-2018.4.20f1.zip?_ga=2.171325672.957521966.1599549120-262519615.1592172043
*
*/

Shader "Kamishiro/ScrollCalendar/CalendarLit"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("Main Texture", 2D) = "white" { }
        [NoScaleOffset] _Loading ("Loading Texture", 2D) = "white" { }
        _Scroll ("Scroll", Range(0, 1)) = 0
        _Intensity ("Emission Intensity", Range(0, 1)) = 0
    }
    SubShader
    {
        Pass
        {
            Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase" }

            CGPROGRAM

            #pragma multi_compile_fog
            #pragma vertex   vert
            #pragma fragment frag
            #pragma multi_compile _ LIGHTMAP_ON
            //#pragma multi_compile_fwdbase

            #define Calendar_Lighting
            #include "CalendarCore.hlsl"

            ENDCG

        }

        Pass
        {
            Tags { "RenderType" = "Opaque" "LightMode" = "ForwardAdd" }

            Blend One One

            CGPROGRAM

            #pragma multi_compile_fwdadd
            #pragma vertex   vert
            #pragma fragment frag

            #define Calendar_Lighting
            #include "CalendarCore.hlsl"
            
            ENDCG

        }

        Pass
        {
            Tags { "LightMode" = "ShadowCaster" }

            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex: POSITION;
                float3 normal: NORMAL;
                float2 texcoord: TEXCOORD0;
            };

            struct v2f
            {
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            fixed4 frag(v2f i): SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG

        }
    }
    Fallback "Kamishiro/ScrollCalendar/CalendarUnlit"
}
