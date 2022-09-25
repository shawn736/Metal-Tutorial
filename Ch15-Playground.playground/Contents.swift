//: Playground - noun: a place where people can play

import MetalKit
import PlaygroundSupport

let frame = NSRect(x: 0, y: 0, width: 400, height: 400)
let delegate = MetalView()
let view = MTKView(frame: frame, device: delegate.device)
view.delegate = delegate
view.framebufferOnly = false
PlaygroundPage.current.liveView = view
