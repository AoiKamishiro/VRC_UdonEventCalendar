/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*/

float2 scalUV(float2 uv ,float scrollVal)
{
    float scroll = scrollVal * 1.274;
    float header = 1 - (float)53 / (float)3508;
    float footer = 1 - (float)3192 / (float)3508;
    
    if (uv.y > header)
    {
        return float2(uv.x / 2, uv.y / 2 + 0.5);
    }
    else if (uv.y < footer)
    {
        return float2(uv.x / 2, uv.y / 2 + 0.5);
    }
    else
    {
        float page1 = ((float)3508 - ((float)54 + (float)54 + (float)1571)) / (float)3508 + 0.25;
        float page2 = page1 - (float)0.5;
        float page3 = page2 - (float)0.5;
        float page4 = page3 - (float)0.5;
        
        float x2 = 0;
        float y2 = uv.y / 2 + 0.5 - scroll;

        if (y2 >= page1)
        {
            x2 = uv.x / 2;
            y2 = uv.y / 2 + 0.5 - scroll;
        }
        else if (y2 >= page2)
        {
            x2 = uv.x / 2;
            y2 = uv.y / 2 - scroll - page1;
        }
        else if (y2 >= page3)
        {
            x2 = uv.x / 2 + 0.5;
            y2 = uv.y / 2 + 0.5 - scroll - page2;
        }
        else if (y2 >= page4)
        {
            x2 = uv.x / 2 + 0.5;
            y2 = uv.y / 2 - scroll - page3;
        }

        return float2(x2, y2);
    }
}

bool isLoading(sampler2D mainTex)
{
    return(tex2D(mainTex, float2(0, 0))).a - 0.001 < 0;
}