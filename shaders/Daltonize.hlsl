#include <renderer/RenderSetup.hlsl>

struct VS_INPUT
{
    float3 ssPosition   : POSITION;
    float2 texCoord     : TEXCOORD0;
    float4 color        : COLOR0;
};

struct VS_OUTPUT
{
    float2 texCoord     : TEXCOORD0;
    float4 color        : COLOR0;
    float4 ssPosition   : SV_POSITION;
};

struct PS_INPUT
{
    float2 texCoord     : TEXCOORD0;
    float4 color        : COLOR0;
};

sampler2D baseTexture;

cbuffer LayerConstants
{
    float   mode;
};

/**
 * Vertex shader.
 */
VS_OUTPUT SFXBasicVS(VS_INPUT inputPixel)
{

    VS_OUTPUT output;

    output.ssPosition = float4(inputPixel.ssPosition, 1);
    output.texCoord   = inputPixel.texCoord + texelCenter;
    output.color      = inputPixel.color;

    return output;

}

/**
 * Daltonization algorithm by daltonize.org
 * http://www.daltonize.org/2010/05/lms-daltonization-algorithm.html
*/
float4 SFXDaltonizeVisionPS(PS_INPUT input) : COLOR0
{
    float4 inputPixel = tex2D(baseTexture, input.texCoord);
    
    // RGB to LMS matrix conversion
	float l = (17.8824f * inputPixel.r) + (43.5161f * inputPixel.g) + (4.11935f * inputPixel.b);
	float m = (3.45565f * inputPixel.r) + (27.1554f * inputPixel.g) + (3.86714f * inputPixel.b);
	float s = (0.0299566f * inputPixel.r) + (0.184309f * inputPixel.g) + (1.46709f * inputPixel.b);

    // Simulate color blindness
    float daltL;
    float daltM;
    float daltS;

	if (mode == 1) // Protanopia - reds are greatly reduced (1% men)
	{
        daltL = /* 0.0f * l + */ 2.02344f * m + -2.52581f * s;
        daltM = /* 0.0f * l + */ 1.0f * m; // + 0.0f * s;
        daltS = /* 0.0f * l + 0.0f * m + */ 1.0f * s;
    }
	else if (mode == 2) // Deuteranopia - greens are greatly reduced (1% men)
	{
        daltL = 1.0f * l; // + 0.0f * m + 0.0f * s;
        daltM = 0.494207f * l; /* + 0.0f * m */ + 1.24827f * s;
        daltS = /* 0.0f * l + 0.0f * m + */ 1.0f * s;
    }
	else if (mode == 3) // Tritanopia - blues are greatly reduced (0.003% population)
	{
        daltL = 1.0f * l; // + 0.0f * m + 0.0f * s
        daltM = /* 0.0f * l + */ 1.0f * m;  // + 0.0f * s;
        daltS = -0.395913f * l + 0.801109f * m; // + 0.0f * s;
    }

	// LMS to RGB matrix conversion
	float3 error;
	error.r = (0.0809444479f * daltL) + (-0.130504409f * daltM) + (0.116721066f * daltS);
	error.g = (-0.0102485335f * daltL) + (0.0540193266f * daltM) + (-0.113614708f * daltS);
	error.b = (-0.000365296938f * daltL) + (-0.00412161469f * daltM) + (0.693511405f * daltS);

    // Isolate invisible colors to color vision deficiency (calculate error matrix)
	error = (inputPixel - error);

    // Shift colors towards visible spectrum (apply error modifications)
	float4 correction;
	correction.r = 0; // (error.r * 0.0) + (error.g * 0.0) + (error.b * 0.0);
	correction.g = (error.r * 0.7) + (error.g * 1.0); // + (error.b * 0.0);
	correction.b = (error.r * 0.7) + (error.b * 1.0); // + (error.g * 0.0);
	correction.a = 0;

    // Add compensation to original values
    correction = inputPixel + correction;

	return correction;
}