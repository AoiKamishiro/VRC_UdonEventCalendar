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

struct appdata
{
    float4 vertex: POSITION;
    float3 normal: NORMAL;
    float2 lightmap: TEXCOORD1;
};

struct v2f
{
    float4 vertex: SV_POSITION;
    float3 vertexW: TEXCOORD0;
    #ifdef LIGHTMAP_ON
        float2 lmap: TEXCOORD1;
    #endif
    float4 ambient: COLOR;
    float3 normal: NORMAL;
    bool doRender: TEXCOORD2;
    UNITY_FOG_COORDS(1)
};

bool willRender()
{
    float4 projectionSUP = float4(1, 1, UNITY_NEAR_CLIP_VALUE, _ProjectionParams.y);
    float4 viewSUP = mul(unity_CameraInvProjection, projectionSUP);
    float asr = viewSUP.x / viewSUP.y;
    return(abs(asr - 0.0396825397f) < 0.01) /* && !(unity_CameraProjection[2][0] != 0.0f || unity_CameraProjection[2][1] != 0.0f )*/;
}

v2f vert(appdata v)
{
    v2f o;

    o.vertexW = mul(unity_ObjectToWorld, v.vertex);
    o.vertex = UnityObjectToClipPos(v.vertex);
    o.normal = UnityObjectToWorldNormal(v.normal);
    o.ambient = fixed4(ShadeSH9(half4(o.normal, 1)), 1);
    o.doRender = willRender();
    #ifdef LIGHTMAP_ON
        o.lmap = v.lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;
    #endif
    UNITY_TRANSFER_FOG(o, o.vertex);
    return o;
}

fixed4 frag(v2f i): SV_Target
{
    if (!i.doRender)
    {
        discard;
    }

    fixed4 color = float4(1, 1, 1, 1);
    fixed4 c = color;
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
    UNITY_APPLY_FOG(i.fogCoord, c);

    return c;
}
