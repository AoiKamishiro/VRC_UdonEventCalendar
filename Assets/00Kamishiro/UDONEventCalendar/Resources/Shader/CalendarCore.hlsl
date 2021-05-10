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
#include "Lighting.cginc"
#include "AutoLight.cginc"
#include "CalendarLib.hlsl"

struct appdata
{
    float4 vertex: POSITION;
    float3 normal: NORMAL;
    float2 uv: TEXCOORD0;
    float2 lightmap: TEXCOORD1;
};

struct v2f
{
    float4 pos: SV_POSITION;
    float2 uv: TEXCOORD0;
    float4 val: TEXCOORD3;
    bool isLoaded: TEXCOORD4;

    #ifdef Calendar_Lighting
        #ifdef LIGHTMAP_ON
            float2 lmap: TEXCOORD1;
        #endif
        float4 ambient: COLOR;
        float3 vertexW: TEXCOORD2;
        float3 normal: NORMAL;
    #endif
    UNITY_FOG_COORDS(1)
};

sampler2D _MainTex;
float4 _MainTex_ST;
sampler2D _Loading;
float4 _Loading_ST;
float _Scroll;
float _Intensity;


v2f vert(appdata v)
{
    v2f o;

    #ifdef Calendar_Lighting
        o.vertexW = mul(unity_ObjectToWorld, v.vertex);
        o.normal = UnityObjectToWorldNormal(v.normal);
        o.ambient = fixed4(ShadeSH9(half4(o.normal, 1)), 1);
        #ifdef LIGHTMAP_ON
            o.lmap = v.lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;
        #endif
    #endif


    o.pos = UnityObjectToClipPos(v.vertex);
    UNITY_TRANSFER_FOG(o, o.vertex);

    o.uv = TRANSFORM_TEX(v.uv, _MainTex);
    o.val = GetValues(_MainTex);
    o.isLoaded = IsLoaded(_MainTex);

    return o;
}

fixed4 frag(v2f i): SV_Target
{
    fixed4 color = i.isLoaded? tex2D(_MainTex, ScrollUV(i.uv, _Scroll, i.val)): tex2D(_Loading, i.uv);
    fixed4 c = color;
    #ifdef Calendar_Lighting
        UNITY_LIGHT_ATTENUATION(attenuation, i, i.vertexW);
        
        float3 normal = normalize(i.normal);
        float3 light = normalize(_WorldSpaceLightPos0.w == 0 ? _WorldSpaceLightPos0.xyz: _WorldSpaceLightPos0.xyz - i.vertexW);
        float diffuse = saturate(dot(normal, light));

        #ifdef LIGHTMAP_ON
            fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.lmap));
            c.rgb = color.rgb * lm;
            c.rgb += color * diffuse * _LightColor0 * attenuation;
        #else
            c.rgb *= diffuse * _LightColor0 * attenuation;
        #endif
        c.rgb += color.rgb * i.ambient;
    #endif
    c.rgb += c.rgb * _Intensity;
    
    UNITY_APPLY_FOG(i.fogCoord, color);

    return c;
}
