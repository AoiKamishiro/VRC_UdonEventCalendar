/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*
* This program uses the following code, which is provided under the MIT License.
* https://download.unity3d.com/download_unity/008688490035/builtin_shaders-2018.4.20f1.zip?_ga=2.171325672.957521966.1599549120-262519615.1592172043
*
*/

Shader "Kamishiro/ScrollCalendar/LightmapSampler"
{
    Properties
    {

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

            #include "LightmapSamplerCore.hlsl"

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

            #include "LightmapSamplerCore.hlsl"
            
            ENDCG

        }
    }
}
