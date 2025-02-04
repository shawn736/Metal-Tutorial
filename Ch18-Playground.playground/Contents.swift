//: Playground - noun: a place where people can play

let shader =
    "#include <metal_stdlib>\n" +
        "using namespace metal;" +
        "kernel void k(texture2d<float,access::write> o[[texture(0)]]," +
        "              uint2 gid[[thread_position_in_grid]]) {" +
        "   int width = o.get_width();" +
        "   int height = o.get_height();" +
        "   float2 uv = float2(gid) / float2(width, height);" +
        "   float3 color = mix(float3(1.0, 0.6, 0.1), float3(0.5, 0.8, 1.0), sqrt(1 - uv.y));" +
        "   float2 q = uv - float2(0.67, 0.25);" +
        "   float r = 0.2 + 0.1 * cos(atan2(q.x, q.y) * 9.0 + 20.0 * q.x);" +
        "   color *= smoothstep(r, r + 0.01, length(q));" +
        "   r = 0.03 + 0.002 * cos(120.0 * q.y) + exp(-50.0 * (1.0 - uv.y));" +
        "   color *= 1.0 - (1.0 - smoothstep(r, r + 0.002, abs(q.x - 0.25 * sin(2.0 * q.y)))) * smoothstep(0.0, 0.1, q.y);" +
        "   o.write(float4(color, 1.0), gid);" +
"}"
import MetalKit
import PlaygroundSupport

let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
let view = MTKView(frame: frame)
view.framebufferOnly = false
let delegate = MetalView(mtkView: view, shader: shader)
view.delegate = delegate
PlaygroundPage.current.liveView = view

