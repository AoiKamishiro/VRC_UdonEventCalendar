/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*/

#define IMGSIZE (float)4096
#define HEIGHT (float)3508
#define PADDING (float)54
#define FOOTER (float)200
#define ADDAREA (float)32
#define ID16 16 / IMGSIZE
#define ID32 32 / IMGSIZE

float4 GetValues(sampler2D tex)
{
    uint height = 0;
    for (uint h = 0; h < 6; h++)
    {
        fixed3 t = tex2Dlod(tex, float4(1, 1 - ID16 - ID32 * h, 0, 0)).rgb;
        fixed3 s = step(0.5f, t);
        fixed3 p = pow(2 * s, uint3(3 * h, 3 * h + 1, 3 * h + 2));
        height += p.r + p.g + p.b;
    }
    float header = 1 - ((PADDING + 5) / HEIGHT);
    float footer = (PADDING * 2 + 5 + FOOTER) / HEIGHT;
    float xscale = IMGSIZE / (IMGSIZE - ADDAREA) * 2;
    float yscale = ((float)height / 2) / HEIGHT;
    return float4(header, footer, xscale, yscale);
}

fixed4 GetColor(sampler2D tex, float sp)
{
    uint3 c = uint3(0, 0, 0);
    for (int i = 0; i < 8; i++)
    {
        fixed3 rgb = tex2Dlod(tex, fixed4(1, sp - ID32 * (7 - i), 0, 0)).rgb;
        c += pow(step(0.5f, rgb) * 2, i);
    }
    
    #if !UNITY_COLORSPACE_GAMMA
        return fixed4(pow(c / 255.0, 2.2), 1);
    #else
        return fixed4(c / 255.0, 1);
    #endif
}

float2 ScrollUV(float2 uv, float scroll, float4 val)
{
    float header = val.x;
    float footer = val.y;
    float xscale = val.z;
    float yscale = val.w;

    if (uv.y > header)
    {
        return float2(uv.x / xscale, 1 - (1 - uv.y) / yscale);
    }
    else if (uv.y < footer)
    {
        return float2(uv.x / xscale + 0.5 - ID16, uv.y / yscale);
    }
    else
    {
        //float x2 = uv.x / (IMGSIZE / (IMGSIZE - ADDAREA) * 2);
        //float y2 = uv.y / yscale - scroll /**/ + (1 - 1 / yscale) /**/ - scroll * (1 - 1 / yscale);
        float x2 = uv.x / xscale;
        float y2 = 1 - (1 - uv.y) / yscale - scroll * (2 - 1 / yscale);

        if (y2 <= 0)
        {
            x2 += 0.5 - ID16;
            y2 += 1;
        }
        return float2(x2, y2);
    }
}

bool IsLoaded(sampler2D mainTex)
{
    return(tex2Dlod(mainTex, float4(0, 0, 0, 0))).rgb - 0.001 > 0;
}