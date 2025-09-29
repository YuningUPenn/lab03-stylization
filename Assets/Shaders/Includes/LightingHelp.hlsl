void GetMainLight_float(float3 WorldPos, out float3 Color, out float3 Direction, out float DistanceAtten, out float ShadowAtten) {
#ifdef SHADERGRAPH_PREVIEW
    Direction = normalize(float3(0.5, 0.5, 0));
    Color = 1;
    DistanceAtten = 1;
    ShadowAtten = 1;
#else
    #if SHADOWS_SCREEN
        float4 clipPos = TransformWorldToClip(WorldPos);
        float4 shadowCoord = ComputeScreenPos(clipPos);
    #else
        float4 shadowCoord = TransformWorldToShadowCoord(WorldPos);
    #endif

    Light mainLight = GetMainLight(shadowCoord);
    Direction = mainLight.direction;
    Color = mainLight.color;
    DistanceAtten = mainLight.distanceAttenuation;
    ShadowAtten = mainLight.shadowAttenuation;
#endif
}

void ChooseColor_float(float3 Highlight, float3 Shadow, float Diffuse, float Threshold, out float3 OUT)
{
    if (Diffuse < Threshold)
    {
        OUT = Shadow;
    }
    else
    {
        OUT = Highlight;
    }
}

void ChooseMoreColor_float(float3 Highlight, float3 MidColor, float3 Shadow, float Diffuse, float Threshold, float Mid_Threshold, out float3 OUT)
{
    if (Diffuse < Threshold)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Mid_Threshold)
    {
        OUT = MidColor;
    }
    else {
        OUT = Highlight;
    }
}

void SmoothColor_float(float3 Highlight, float3 Shadow, float Diffuse, float Threshold1, float Threshold2, out float3 OUT)
{
    if (Diffuse < Threshold1)
    {
        OUT = Shadow;
    }
    else if (Diffuse < Threshold2)
    {
        float t = smoothstep(Threshold1, Threshold2, Diffuse);
        OUT = lerp(Shadow, Highlight, t);
    }
    else
    {
        OUT = Highlight;
    }
}