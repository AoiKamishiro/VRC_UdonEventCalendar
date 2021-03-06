/*
* Copyright (c) 2021 AoiKamishiro
*
* This code is provided under the MIT license.
*
* This program uses the following code, which is provided under the MIT License.
* https://download.unity3d.com/download_unity/008688490035/builtin_shaders-2018.4.20f1.zip?_ga=2.171325672.957521966.1599549120-262519615.1592172043
*
*/

#ifndef UNITY_STANDARD_CORE_FORWARD_INCLUDED
    #define UNITY_STANDARD_CORE_FORWARD_INCLUDED

    #if defined(UNITY_NO_FULL_STANDARD_SHADER)
        #   define UNITY_STANDARD_SIMPLE 1
    #endif

    #include "UnityStandardConfig.cginc"

    #if UNITY_STANDARD_SIMPLE
        #include "UnityStandardCoreForwardSimple.cginc"
        VertexOutputBaseSimple vertBase(VertexInput v)
        {
            return vertForwardBaseSimple(v);
        }
        VertexOutputForwardAddSimple vertAdd(VertexInput v)
        {
            return vertForwardAddSimple(v);
        }
        half4 fragBase(VertexOutputBaseSimple i): SV_Target
        {
            return fragForwardBaseSimpleInternal(i);
        }
        half4 fragAdd(VertexOutputForwardAddSimple i): SV_Target
        {
            return fragForwardAddSimpleInternal(i);
        }
    #else
        #include "KamishiroStandardCore.cginc"
        VertexOutputForwardBase vertBase(VertexInput v)
        {
            return vertForwardBase(v);
        }
        VertexOutputForwardAdd vertAdd(VertexInput v)
        {
            return vertForwardAdd(v);
        }
        half4 fragBase(VertexOutputForwardBase i): SV_Target
        {
            return fragForwardBaseInternal(i);
        }
        half4 fragAdd(VertexOutputForwardAdd i): SV_Target
        {
            return fragForwardAddInternal(i);
        }
    #endif

#endif // UNITY_STANDARD_CORE_FORWARD_INCLUDED
