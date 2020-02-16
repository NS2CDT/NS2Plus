source      = "shaders/Daltonize.hlsl"
techniques  =
    [
        {
            name                                = "SFXDaltonizeVision"
            vertex_shader                       = "SFXBasicVS"
            pixel_shader                        = "SFXDaltonizeVisionPS"
            depth_test                          = always
            depth_write                         = false
            cull_mode                           = none
        }
    ]