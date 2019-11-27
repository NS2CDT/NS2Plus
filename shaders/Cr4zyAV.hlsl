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

sampler2D       baseTexture;
sampler2D       depthTexture;
sampler2D       normalTexture;

cbuffer LayerConstants
{
    float       avCombined; //bitshift number
    float       startTime;
    float       amount;
    float       edgeSize;
    float       closeIntensity;
    float       distantIntensity;
    float       desatIntensity;
    float       avViewModel;
    float       avWorldIntensity;
    float       avBlend;
    float       avDesatBlend;
    float       marineRGBInt;
    float       marineIntensity;
    float       alienRGBInt;
    float       alienIntensity;
    float       gorgeRGBInt;
    float       gorgeIntensity;
    float       mStructRGBInt;
    float       mStructIntensity;
    float       aStructRGBInt;
    float       aStructIntensity;
    float       worldCloseRGBInt;
    float       worldFarRGBInt;
};

/**
* Vertex shader.
*/  
VS_OUTPUT SFXBasicVS(VS_INPUT input)
{

   VS_OUTPUT output;

   output.ssPosition = float4(input.ssPosition, 1);
   output.texCoord   = input.texCoord + texelCenter;
   output.color      = input.color;

   return output;

}   

// apparently we dont have bitshift features so heres some fun float math instead
//24bit RGB, no alpha, otherwise float rolls over
float4 colorBitshift( float inputColor )
{
    float shift16 = 65536;
    float shift8 = 256;
    float shift0 = 1;
    
    float extractR = 0;
    float extractG = 0;
    float extractB = 0;

    //24bit RGB
    extractR = floor(inputColor / shift16);
    extractG = floor((inputColor - (extractR * shift16)) / shift8);
    extractB = floor(inputColor - (extractR * shift16) - (extractG * shift8)); 
    
    return clamp(float4(extractR / 255.0, extractG / 255.0, extractB / 255.0, 1),0,1);
}
// For all settings: 1.0 = 100% 0.5=50% 1.5 = 150%
float4 ContrastSaturationBrightness(float4 incolor, float brt, float sat, float con)
{
    float3 color = float3(incolor.r, incolor.g, incolor.b);
	// Increase or decrease theese values to adjust r, g and b color channels seperately
	const float AvgLumR = 0.5;
	const float AvgLumG = 0.5;
	const float AvgLumB = 0.5;
	
	const float3 LumCoeff = float3(0.2125, 0.7154, 0.0721);
	
	float3 AvgLumin = float3(AvgLumR, AvgLumG, AvgLumB);
	float3 brtColor = color * brt;
	float intensityf = dot(brtColor, LumCoeff);
	float3 intensity = float3(intensityf, intensityf, intensityf);
	float3 satColor = lerp(intensity, brtColor, sat);
	float3 conColor = lerp(AvgLumin, satColor, con);
    float4 finColor = float4(conColor,1);
	return finColor;
}

float4 SFXDarkVisionPS(PS_INPUT input) : COLOR0
{
    //get these from bitshift
    float       avPlayers; //player selector
    float       avEdgeClean; //redesigned edges
    float       avNano; //better nanoshield highlights
    float       modeAV; //AV style selection
    float       modeAVoff; // AV disabled style selection
    float       avEdge; // AV edge type
    float       avDesat; //Enable desaturation modes
    float       avViewModelStyle; // view model styles
    float       avToggle; // AV activate mode toggle
    float       avSky; // distant/sky selection
    float       avGorgeUnique; //enable gorge coloring
    float       avStructures; //switches structure coloring modes
    
    // bitshift out variable values in following order
    //avEdgeClean avNano modeAV avGorgeUnique modeAVoff avEdge avStructures avDesat avViewModelStyle avSky avToggle
    float shift22 = 4194304;
    float shift20 = 1048576;
    float shift18 = 262144;
    float shift16 = 65536;
    float shift14 = 16384;
    float shift12 = 4096;
    float shift10 = 1024;
    float shift8 = 256;
    float shift6 = 64;
    float shift4 = 16;
    float shift2 = 4;

    float extract22 = 0;
    float extract20 = 0;
    float extract18 = 0;
    float extract16 = 0;
    float extract14 = 0;
    float extract12 = 0;
    float extract10 = 0;
    float extract8 = 0;
    float extract6 = 0;
    float extract4 = 0;
    float extract2 = 0;
    float extract0 = 0;

    //2bits per, i get it this looks scary messy, tough
    //extract the bitshifted value, set the variable, and then subtract the bitshift from our original value
    float rollingValue = avCombined;
    extract22 = floor(rollingValue / shift22);
    avPlayers = extract22;
    extract22 = extract22 * shift22;
    
    rollingValue = rollingValue - extract22;
    extract20 = floor(rollingValue / shift20);
    avEdgeClean = extract20;
    extract20 = extract20 * shift20;
    
    rollingValue = rollingValue - extract20;
    extract18 = floor(rollingValue / shift18);
    avNano = extract18;
    extract18 = extract18 * shift18;
    
    rollingValue = rollingValue - extract18;
    extract16 = floor(rollingValue / shift16);
    modeAV = extract16;
    extract16 = extract16 * shift16;
    
    rollingValue = rollingValue - extract16;
    extract14 = floor(rollingValue / shift14);
    avGorgeUnique = extract14;
    extract14 = extract14 * shift14;
    
    rollingValue = rollingValue - extract14;
    extract12= floor(rollingValue / shift12);
    modeAVoff = extract12;
    extract12 = extract12 * shift12;
    
    rollingValue = rollingValue - extract12;
    extract10 = floor(rollingValue / shift10);
    avEdge = extract10;
    extract10 = extract10 * shift10;
    
    rollingValue = rollingValue - extract10;
    extract8 = floor(rollingValue / shift8);
    avStructures = extract8;
    extract8 = extract8 * shift8;
    
    rollingValue = rollingValue - extract8;
    extract6 = floor(rollingValue / shift6);
    avDesat = extract6;
    extract6 = extract6 * shift6;
    
    rollingValue = rollingValue - extract6;
    extract4 = floor(rollingValue / shift4);
    avViewModelStyle = extract4;
    extract4 = extract4 * shift4;
    
    rollingValue = rollingValue - extract4;
    extract2 = floor(rollingValue / shift2);
    avSky = extract2;
    extract2 = extract2 * shift2;
    
    rollingValue = rollingValue - extract2;
    extract0 = floor(rollingValue);
    avToggle = extract0;
    
    //vars
    const float frontMovementPower = 2.0;
    const float pulseWidth = 20.0;    
    const float frontSpeed = 12.0;
    
    float4 alienVision = float4(0,0,0,1);
    float2 texCoord = input.texCoord;
    float4 inputPixel = tex2D(baseTexture, texCoord);
    float  depth = tex2D(depthTexture, texCoord).r;
    float modelvm = tex2D(depthTexture,texCoord).g;
    float  model = max(0, tex2D(depthTexture, texCoord).g * 2 - 1);
    float3 normal = tex2D(normalTexture, texCoord).xyz;
    float  intensity = pow((abs(normal.z) * 1.4), 2);
    float4 edge = 0;
    float2 depth1 = tex2D(depthTexture, input.texCoord).rg;
    
    float x = (input.texCoord.x - 0.5) * 20;
    float y = (input.texCoord.y - 0.5) * 20;
    float distanceSq    = (x * x + y * y)/100;      
    float sineX  = sin(-x * .1) * sin(-x * .1);
    float sineY = sin(-y * .1) * sin(-y * .1);
    float avAreaX  = clamp(sineX * 1.7*1.5,0,1);
    float avAreaY = clamp(sineY ,0,1);
    
    //bitshift out colors
    float4 marineRGB     = colorBitshift(marineRGBInt);
    float4 alienRGB      = colorBitshift(alienRGBInt);
    float4 gorgeRGB      = colorBitshift(gorgeRGBInt);
    float4 mStructRGB    = colorBitshift(mStructRGBInt);
    float4 aStructRGB    = colorBitshift(aStructRGBInt);
    float4 worldCloseRGB = colorBitshift(worldCloseRGBInt);
    float4 worldFarRGB   = colorBitshift(worldFarRGBInt);

//these masks create an gorge, alien and marine mask
    //0.5 = Viewmodel
    //0.96 = Alien Players
    //0.9 = Alien Structures
    //0.94 = Gorges & Babbles
    //0.98 = Marine Structures & Equiqment
    //1 = Marine Players

    float alienMask = 0;
    float alienStructureMask = 0;
    float gorgeMask = 0;
    float marineMask = 0;
    float marineStructureMask = 0;
    
    if (depth1.g > 0.95 && depth1.g < 0.97) {
        alienMask = 1;
    }
    else if (depth1.g > 0.89 && depth1.g < 0.91) {
        alienStructureMask = 1;
    }
    else if (depth1.g > 0.93 && depth1.g < 0.95) {
        gorgeMask = 1;
    }
    else if (depth1.g > 0.97 && depth1.g < 0.99) {
        marineStructureMask = 1;
    }
    else if (depth1.g > 0.99) {
        marineMask = 1;
    }
    
    //VIEWMODEL mask
    float myAlien = 0;
    float4 realvm = inputPixel;
    float vmdepth = max(0.12, pow(2, max(depth - 0.5, 0) * -0.2));

    if (modelvm < .6 && depth < 2.2){
        myAlien = 1 * modelvm;
    }
    myAlien = clamp(myAlien*5,0,1);
    float myAlienIntensity = myAlien * avViewModel;
    //select vm to display
    if (avViewModelStyle >= 1){
        realvm = clamp(modelvm * 2 * myAlien * pow(vmdepth,10),0,1);
    }
    else{
        model = model + clamp(modelvm * 2 * myAlien * pow(vmdepth,10),0,1) * avViewModel;
        realvm = 0;
    }
    
    //Structure Mask selector
    //All Structures, Marines Structures Only, Alien Structures Only, No Structures
    float4 currentStructureMask = 0;
    
    if (avStructures >= 3) {
        //no structures, 3
        alienStructureMask = 0;
        marineStructureMask = 0;
    }
    else if (avStructures >= 2 && avStructures < 2.1) {
        //alien structures only, 2
        currentStructureMask = alienStructureMask * aStructRGB;
        marineStructureMask = 0;
    }
    else if (avStructures >= 1 && avStructures < 1.1) {
        //marine structures only, 1
        currentStructureMask = marineStructureMask * mStructRGB;
        alienStructureMask = 0;
    }
    else if (avStructures <= 0){
        //all structures, 0
        currentStructureMask = (alienStructureMask * aStructRGB) + (marineStructureMask * mStructRGB);
    }
    
    //Player Mask selector
    //All Players, Marines Only, Alien Only, No Players
    float4 currentPlayerMask = 0;
    
    if (avPlayers >= 3) {
        //no players, 3
        alienMask = 0;
        gorgeMask = 0;
        marineMask = 0;
    }
    else if (avPlayers >= 2 && avPlayers < 2.1) {
        //alien only, 2
        marineMask = 0;
    }
    else if (avPlayers >= 1 && avPlayers < 1.1) {
        //marine only, 1
        alienMask = 0;
        gorgeMask = 0;
    }
    else if (avPlayers <= 0){
        //all players, 0
    }
    
    float4 currentAlienMask = 0;
    float4 currentMarineMask = (marineMask * marineRGB) + (marineStructureMask * mStructRGB);
    float alienIntensityMask = 0;
    float marineIntensityMask = (marineMask * marineIntensity) + (marineStructureMask * mStructIntensity);
    float combinedIntensityMask = 0;
    
    //Gorge is a unique color selection choice so create masks appropriately
    if (avGorgeUnique < 1){
        currentPlayerMask = ((alienMask + gorgeMask + myAlien) * alienRGB) + (marineMask * marineRGB);
        currentAlienMask = ((alienMask + gorgeMask + myAlien) * alienRGB) + (alienStructureMask * aStructRGB); 
        alienIntensityMask = ((alienMask  + gorgeMask) * alienIntensity) + (alienStructureMask * aStructIntensity) + (myAlien * myAlienIntensity);
        combinedIntensityMask = (marineMask * marineIntensity) + ((alienMask  + gorgeMask) * alienIntensity) + (alienStructureMask * aStructIntensity) + (marineStructureMask * mStructIntensity) + (myAlien * myAlienIntensity);
    }
    else if (avGorgeUnique >= 1){
        currentPlayerMask = ((alienMask + myAlien) * alienRGB) + (gorgeMask * gorgeRGB) + (marineMask * marineRGB);
        currentAlienMask = ((alienMask + myAlien) * alienRGB) + (gorgeMask * gorgeRGB) + (alienStructureMask * aStructRGB); 
        alienIntensityMask = (alienMask * alienIntensity) + (gorgeMask * gorgeIntensity) + (alienStructureMask * aStructIntensity) + (myAlien * myAlienIntensity);
        combinedIntensityMask = (marineMask * marineIntensity) + (alienMask * alienIntensity) + (gorgeMask * gorgeIntensity) + (alienStructureMask * aStructIntensity) + (marineStructureMask * mStructIntensity) + (myAlien * myAlienIntensity);
    }

    //Combine structure and player masks and multiply intensity.
    float4 combinedColorMask = (currentPlayerMask + currentStructureMask) * combinedIntensityMask;

    //make a mask that gets dark rooms/areas and blue highlights for nanoshield
    float ipColour = inputPixel.g + inputPixel.b ;
    float blueInput = (clamp(inputPixel.b - (inputPixel.r + inputPixel.g),0,1) * (marineMask + marineStructureMask))  ;
    float redRoom = 0;
    float blueHighlights = 0;
    float enableRedRoom = 0;
    
    //only impacts av offmodes and minimal av
    if (modeAV == 0) {
        enableRedRoom = 1;
    }
    if (amount < 1 && modeAVoff > 1){
        enableRedRoom = 1;
    }

    if (enableRedRoom == 1) {
        if (ipColour >= 0 && ipColour < 0.000001){
            redRoom = redRoom + 0.2;
        }
        else{
            redRoom = 0;
        }
        if (ipColour >= 0 && ipColour < 0.0007){
            redRoom = redRoom + 0.3;
        }
        else{
            redRoom = 0;
        }
        if (ipColour >= 0 && ipColour < 0.001){
            redRoom = redRoom + 0.35;
        }
        else{
            redRoom = 0;
        }
        if (ipColour >= 0 && ipColour < 0.003){
            redRoom = redRoom + 0.15;
        }
        else{
            redRoom = 0;
        }
        if (ipColour >= 0 && ipColour < 0.006){
            redRoom = redRoom + 0.025;
        }
        else{
            redRoom = 0;
        }
    }
    
    //if av enabled, highlight blue for nanoshield
    if (avNano >= 1) {
        if (blueInput <= 1 && blueInput > .6){
            blueHighlights = blueHighlights + 5;
        }
        else{
            blueHighlights = 0;
        }
    }
    // set nanoshield colour highlight to be inverted marine colour
    float4 nanoHighlight = (blueHighlights * ((1-currentMarineMask) * 2) * clamp(marineIntensityMask*3,.5,4));
    
    //vignette the screen
    float2 screenCenter = float2(0.5, 0.5);
    float darkened = 1 - clamp(length(texCoord - screenCenter) - 0.45, 0, 1);
    darkened = pow(darkened, 4);    
    float edgeSetting = 0;
    
    
    //edge types
    if (avEdge >= 1){
        if (avEdge > 1){
            if (avEdge > 2){
                //3 - thicker edge no fill
                edgeSetting = (edgeSize / 10) + distanceSq * (edgeSize * 2.5) * (1 + depth1.g);
            }
            else{
                //2 - normal edge no fill
                edgeSetting = edgeSize + depth1.g * 0.00001;
            }
        } 
        else {
            //1 - thicker edge
            edgeSetting = (edgeSize / 10) + distanceSq * (edgeSize * 2.5) * (1 + depth1.g);
        }
    }
    else {
        //0 -  normal edge
        edgeSetting = edgeSize + depth1.g * 0.00001;
    }

    float offset;
    if (avEdgeClean < 1) {
        offset = edgeSetting;
    }
    else{
        offset = edgeSetting * (pow(clamp((10-depth)*.1,0,1),1.5) + pow(clamp((60-depth)*.01,0,1),2));
    }

    float  depth2 = tex2D(depthTexture, texCoord + float2( offset, 0)).r;
    float  depth3 = tex2D(depthTexture, texCoord + float2(-offset, 0)).r;
    float  depth4 = tex2D(depthTexture, texCoord + float2( 0,  offset)).r;
    float  depth5 = tex2D(depthTexture, texCoord + float2( 0, -offset)).r;
    
    edge = abs(depth2 - depth) +  
           abs(depth3 - depth) + 
           abs(depth4 - depth) + 
           abs(depth5 - depth);

    edge = min(1, pow(edge + 0.12, 2));
    
    float avBlendChange = avBlend;
    
    if (avBlend > 0) {
        avBlendChange = avBlend * (avBlend/0.66);
    }
    else {
        avBlendChange = avBlend;
    }
    
    float modelEdge = model;
    if (avEdge >= 2){
        //2&3 -  no fill
        modelEdge = edge;
    }
    
    float fadeDistBlend = pow(avBlendChange*.8+.2, -depth1.r * 0.23 + 0.23);
    float fadeDistDesat = pow(avDesatBlend*10+0.2, -depth1.r * 0.23 + 0.23);
    float fadedist = pow(2.6, -depth1.r * 0.23 + 0.23);
    float fadeoff = max(0.12, pow(avBlendChange*.8+1, max(depth - 0.5, 0) * -0.2));
    
    //AV Colour vars
    float4 colourOne = worldCloseRGB * closeIntensity;
    float4 colourTwo = worldFarRGB * distantIntensity;
    float4 colourAngle = lerp(colourOne, colourTwo, .75);
    
    //fog colour/colour three, wont rename in code as to not reset anyones existing options
    float4 colourFog = clamp(((worldCloseRGB * closeIntensity) * clamp(fadeDistBlend * 10,0,1)) + ((worldFarRGB * distantIntensity) * clamp(.75-fadeDistBlend,0,1)),0,1);
    float4 colourModel = 0;

    //player and structure colouring
    //this used to use colours one/two/three to set aliens/marines/world values differently but now we have actual choices for that
    if (modeAV >= 1){
        if (modeAV > 1){
            if (modeAV > 2){
                //seperate world, edge and model colours
                colourFog = combinedColorMask;
                colourModel = ContrastSaturationBrightness(combinedColorMask,1,1.5,1);
                }
            else{
                //depth fog, this sets colour for aliens/marines
                colourAngle = (alienIntensityMask * lerp(currentAlienMask,currentMarineMask,.25)) + (marineIntensityMask * lerp(currentAlienMask,currentMarineMask,.75));
                colourOne = combinedColorMask;
                colourTwo = (alienIntensityMask * clamp(lerp(currentAlienMask,currentMarineMask,.15) / 1.25,0,1)) + (marineIntensityMask * clamp(lerp(currentAlienMask,currentMarineMask,.85) / 1.25,0,1));
            }
        } 
        else {
            //original
            colourFog = combinedColorMask;
            colourModel = ContrastSaturationBrightness(combinedColorMask,1,1.5,1);
        }
    }
    else {
        //minimal
        colourAngle = (alienIntensityMask * lerp(currentAlienMask,currentMarineMask,.25)) + (marineIntensityMask * lerp(currentAlienMask,currentMarineMask,.75));
        colourOne = combinedColorMask;
        colourTwo = (alienIntensityMask * clamp(lerp(currentAlienMask,currentMarineMask,.15) / 1.25,0,1)) + (marineIntensityMask * clamp(lerp(currentAlienMask,currentMarineMask,.85) / 1.25,0,1));
    }
    
    //offset colour when models are at an angle to camera
    float4 angleBlend = clamp(1-fadedist*5,0,1)*distantIntensity*.8 + clamp(fadedist*.5,0,1)*closeIntensity*.5;
    colourAngle = modelEdge * (colourAngle * .6 * angleBlend) * 0.5;

    //set up screen center colouring
    float4 mainColour = 
    modelEdge * edge * colourOne * 2 * clamp(fadeDistBlend*5,0.02,1) +
    modelEdge * edge * colourTwo * 1 * clamp(1-fadeDistBlend*7,0,1) * clamp(fadeDistBlend*300,0.02,1)  +
    modelEdge * edge * colourTwo * .6 * clamp(1-fadeDistBlend*60,0,1);
        
    //set up screen edge colouring
    float4 edgeColour = 
    modelEdge * edge * colourOne * 2 * clamp(fadeDistBlend*2.3,0,1) + 
    modelEdge * edge * colourTwo * 1 * clamp(1-fadeDistBlend*2.7,0,1) * clamp(fadeDistBlend*50,0.02,1) + 
    modelEdge * edge * colourTwo * .6 * (1-clamp(fadeDistBlend*7,0.02,1));

    //outlines for when av is off, edges only
    float4 offOutline = model * (
    ((edge * edge) * 3) * combinedColorMask * 2 * clamp(fadeDistBlend*2.25,0,1) + 
    ((edge * edge) * 2) * combinedColorMask * 1.2 * clamp(1-fadeDistBlend*4.5,0,1) * clamp(fadeDistBlend*500,0.02,1) + 
    (edge * edge) * combinedColorMask * .4 * (1-clamp(fadeDistBlend*60,0.02,1)) * 3) ;
    
    //lerp it together
    float4 outline = lerp(mainColour, edgeColour, clamp(avAreaX + avAreaY, 0, 1));
    
    //set up original mode model colouring
    float4 modelColour =
    (modelEdge * (0.5 + 0.1 * pow(0.1 + sin(time * 5 + intensity * 4), 2)) * clamp(fadedist*5,.5,1)) * colourFog +
    ((modelEdge * pow(edge,2)) * (colourFog * (clamp(fadedist *60,.25,1)))) +
    (modelEdge * pow(edge,2) * modelEdge * pow(edge,2.5)) * (colourModel * clamp(fadedist * 20,2,10));

    //WORLD edges
    // redRoom detection means outlines in dark rooms are much more pronounced
    float4 world = (pow(edge,1.5) * .05 * redRoom) + edge * 0.02;
    
    //FOG setup
    float4 fog = clamp(pow(depth * 0.012, 1), 0, 1.2) * colourFog * (0.6 + edge);
    
    //Nanoshield highlighting setup
    nanoHighlight = ((marineMask + marineStructureMask) * edge * nanoHighlight);
    
    //av off effects
    if (amount < 1){
        if (modeAVoff >= 1){
            if (modeAVoff > 1){
                if (modeAVoff > 2){
                    return inputPixel * (1 + edge) + (offOutline * currentMarineMask) * .4 + world * .6;
                }
            //coloured outlines
            return inputPixel * (1 + edge) + offOutline * .4 + world * .6;
            }
            else {
                //minimal world    
                return inputPixel + world * .2;
            }
        }
        else {
            //nothing av off
            return inputPixel;
        }
    }

    //skybox mask
    //lerp with circle masks because depth is a terrible at widescreen resolutions and this way the result is better, not perfect tho.
    float4 noSkybox = 0;
    float maskSkybox = 0;
    
    if (avSky > 0){
        if (avSky > 1){
            maskSkybox = 1;
            noSkybox = 0;
        }
        else{
            maskSkybox = lerp(step(depth1.r, 120), lerp(step(depth1.r, 90), step(depth1.r,70), clamp(avAreaX + avAreaY, 0, 1)), clamp((avAreaX + avAreaY) * 2,0,1));
            noSkybox = 0;
        }
    }
    else{
        maskSkybox = lerp(step(depth1.r, 120), lerp(step(depth1.r, 90), step(depth1.r,70), clamp(avAreaX + avAreaY, 0, 1)), clamp((avAreaX + avAreaY) * 2,0,1));
        noSkybox = lerp(1,0,maskSkybox) * inputPixel;
    }
    
        float4 inputPixelold = inputPixel;
        inputPixel = inputPixel * avWorldIntensity;
        float red = inputPixel.r;
        float green = inputPixel.g;
        float blue = inputPixel.b;
        
    //desaturate
    float4 desaturate = 0;

    if (avDesat >= 1){
        if (avDesat > 1){
            if (avDesat > 2){
                //close desat
                desaturate = float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * 1 * clamp(fadeDistDesat*2.25,0,1) + 
                float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * .6 *clamp(1-fadeDistDesat*2.5,0,1) * clamp(fadeDistDesat*9,0.02,1) + 
                float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * .2 * (1-clamp(fadeDistDesat*9,0.02,1)) * clamp(fadeDistDesat*30,0.02,1) + 
                float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * 0 * (1-clamp(fadeDistDesat*30,0.02,1)) * (desatIntensity * 5);
            }
            else{
                //distance desat
                desaturate = float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * 0.03 * clamp(fadeDistDesat*2.25,0,1) + 
                float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * .09 *clamp(1-fadeDistDesat*2.5,0,1) * clamp(fadeDistDesat*9,0.02,1) + 
                float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * .15 * (1-clamp(fadeDistDesat*9,0.02,1)) * clamp(fadeDistDesat*30,0.02,1) + 
                float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0) * .2 * (1-clamp(fadeDistDesat*30,0.02,1)) * (desatIntensity * 5);
            }
        }
        else {
            //scene desat
            desaturate = float4(max(0, max(green, blue) - red), max(0, max(red, blue) - green), max(0, max(green, red) - blue), 0);
        }
    }
    else {
        //no desat
        float4 desaturate = 1;
    }

    //put it all together
    //get mode and create final shader
    if (modeAV >= 1){
        if (modeAV > 1){
            if (modeAV > 2){
                //seperate world, edge and model colours
                alienVision = 
                ((pow((clamp(combinedIntensityMask + 1-pow(edge,1.8),0,1) - pow(combinedIntensityMask,0.01)),2) * (inputPixel + desaturate * desatIntensity) * clamp((clamp(combinedIntensityMask + 1-edge,0,1) - combinedIntensityMask) * colourOne *  fadeDistBlend,0,1) +
                clamp((pow(edge,2) - combinedIntensityMask) * colourTwo * fadeoff*10,0,1) + ((inputPixel + desaturate * desatIntensity) * (colourOne)) * clamp(max((model * closeIntensity), combinedIntensityMask),0,1) +
                (modelEdge * colourFog) * 0.1 +
                ((normal.y * .3) * ((0.5 + 0.2 * pow(0.1 + sin(time * 5 + intensity * 3), 2)) * modelEdge * (colourModel * inputPixel)  * clamp(fadedist*20,1,3)) *.25) +
                (pow(clamp(pow(modelEdge * edge,.5),0,1) * (colourFog * 0.5),1.2)) * pow((edge + model),4)) * clamp(pow(1-realvm,12),0,1) +
                (realvm * inputPixel)) * maskSkybox + noSkybox + nanoHighlight;
                }
            else{
                //depth fog
                alienVision = ((pow(inputPixel * .9 * darkened, 1.3) + desaturate * desatIntensity + (fog*(clamp((1-combinedIntensityMask)+0.1,.75,1))) * (2 + edge * .2) + (outline  * (model * 1.5)) * 2 + model * intensity * colourAngle * (0.5 + 0.2 * pow(0.1 + sin(time * 5 + intensity * 3), 2)) ) * clamp(pow(1-realvm,12),0,1) + (realvm * inputPixelold)) * maskSkybox + noSkybox + nanoHighlight;
            }
        } 
        else {
            //original 
            alienVision = (((max(inputPixel,edge) + desaturate * desatIntensity) * clamp(((colourOne * (fadeDistBlend * 10)) + (colourTwo * (.75-fadeDistBlend))),0,1) + (modelColour*.5)) * clamp(pow(1-realvm,12),0,1) + (realvm * inputPixelold)) * maskSkybox + noSkybox + nanoHighlight;
        }
    }
    else {
        //minimal
        alienVision = (((pow(inputPixel * .9 * darkened, 1.4) + desaturate * desatIntensity) + (outline * (model * 1.5)) * 2 + (model * intensity * colourAngle * (0.5 + 0.2 * pow(0.1 + sin(time * 5 + intensity * 3), 2))) + ((inputPixel + desaturate * desatIntensity) + world * .75)) * clamp(pow(1-realvm,12),0,1) + (realvm * inputPixelold)) * maskSkybox + noSkybox + nanoHighlight;
    }
        
    //activation effects
    // Compute a pulse "front" that sweeps out from the viewer when the effect is activated.
    float wave  = cos(4 * (x/20)) + sin(4 * (x/20));
    float front = pow( (time - startTime) * frontSpeed, frontMovementPower) + wave;
    float pulse = 0;

    //instant enable
    if (avToggle > 0){
        if (avToggle > 1){
            return alienVision;
        }
        else {
            pulse = clamp((time - startTime)*1.5,0,1);
            return lerp(inputPixelold,alienVision,pulse);
        }
    }
    else{
        float pulse = saturate((front - depth1.r * 1) / pulseWidth);
        if (pulse > 0) {
        return alienVision;
        }
        else{
        return inputPixelold;
        }
    }
}
