/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*
* This program uses the following code, which is provided under the MIT License.
* https://download.unity3d.com/download_unity/008688490035/builtin_shaders-2018.4.20f1.zip?_ga=2.171325672.957521966.1599549120-262519615.1592172043
*
*/// Unity built-in shader source. Copyright (c) 2016 Unity Technologies. MIT license (see license.txt)

Shader "Kamishiro/ScrollCalendar/SamplerUI"
{
    Properties
    {
        [Header(UI Setting)]
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" { }
        _Color ("Tint", Color) = (1, 1, 1, 1)

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
        [Space(10)]
        [Header(Base Color Sample)]
        _Sample ("Sample", Range(0, 1)) = 0
        [NoScaleOffset] _RenderTex ("Sampler Texture", 2D) = "white" { }
        _Intensity ("Intensity", Range(0, 1)) = 0
        [Space(10)]
        [Header(Lighting Setting)]
        [Toggle(_UI_LIGHTING)] _UI_LIGHTING ("Use Lighting", Float) = 0
        [NoScaleOffset] _LightMap ("LightMap Texture", 2D) = "white" { }
        [Toggle(_PARTITAL_REFERENCE)] _PARTITAL_REFERENCE ("Partitil Reference", Float) = 0
        _Scale ("Scale", float) = 1
        _Value ("Value", float) = 0
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" "CanUseSpriteAtlas" = "True" }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        //Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
            #pragma shader_feature _UI_LIGHTING
            #pragma shader_feature _PARTITAL_REFERENCE

            #include "SamplerUICore.hlsl"
            ENDCG

        }
    }
}
