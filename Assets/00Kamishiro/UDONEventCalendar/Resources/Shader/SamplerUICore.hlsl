/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*
* This program uses the following code, which is provided under the MIT License.
* https://download.unity3d.com/download_unity/008688490035/builtin_shaders-2018.4.20f1.zip?_ga=2.171325672.957521966.1599549120-262519615.1592172043
*
*/

#include "UnityCG.cginc"
#include "UnityUI.cginc"
#include "CalendarLib.hlsl"

#pragma multi_compile __ UNITY_UI_CLIP_RECT
#pragma multi_compile __ UNITY_UI_ALPHACLIP

struct appdata_t
{
    float4 vertex: POSITION;
    float4 color: COLOR;
    float2 m_texcoord: TEXCOORD0;
    float2 r_texcoord: TEXCOORD2;
    #ifdef _UI_LIGHTING
        float2 l_texcoord: TEXCOORD3;
    #endif
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float4 vertex: SV_POSITION;
    fixed4 color: COLOR;
    float2 m_texcoord: TEXCOORD0;
    float2 r_texcoord: TEXCOORD2;
    #ifdef _UI_LIGHTING
        float2 l_texcoord: TEXCOORD3;
    #endif
    float4 worldPosition: TEXCOORD1;
    UNITY_VERTEX_OUTPUT_STEREO
};

sampler2D _MainTex;
fixed4 _Color;
fixed4 _TextureSampleAdd;
float4 _ClipRect;
float4 _MainTex_ST;
sampler2D _RenderTex;
float4 _RenderTex_ST;
sampler2D _LightMap;
float4 _LightMap_ST;
float _Sample;
float _Scale;
float _Value;
float _Intensity;

v2f vert(appdata_t v)
{
    v2f OUT;
    UNITY_SETUP_INSTANCE_ID(v);
    UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
    OUT.worldPosition = v.vertex;
    OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

    OUT.m_texcoord = TRANSFORM_TEX(v.m_texcoord, _MainTex);
    OUT.r_texcoord = TRANSFORM_TEX(v.r_texcoord, _RenderTex);
    #ifdef _UI_LIGHTING
        OUT.l_texcoord = TRANSFORM_TEX(v.l_texcoord, _LightMap);
    #endif

    fixed4 sampleColor = GetColor(_RenderTex, _Sample);
    bool isBlack = sampleColor.rgb < 0.01f;
    OUT.color = v.color * _Color * fixed4(sampleColor.rgb, isBlack? 0.0f: 1.0f);
    return OUT;
}

fixed4 frag(v2f IN): SV_Target
{
    half4 color = (tex2D(_MainTex, IN.m_texcoord) + _TextureSampleAdd) * IN.color;

    #ifdef _UI_LIGHTING
        fixed3 light;
        #ifdef _PARTITAL_REFERENCE
            float y = 1 - (1 - IN.l_texcoord.y) * _Scale - _Value * (1 - _Scale);
            light = (tex2D(_LightMap, float2(IN.l_texcoord.x, y)));
        #else
            light = (tex2D(_LightMap, IN.l_texcoord));
        #endif
        color.rgb *= light.rgb ;
    #endif
    color.rgb += color.rgb * _Intensity;
    

    #ifdef UNITY_UI_CLIP_RECT
        color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
    #endif

    #ifdef UNITY_UI_ALPHACLIP
        clip(color.a - 0.001);
    #endif

    return color;
}