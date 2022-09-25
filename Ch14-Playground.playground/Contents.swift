//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport

let device = MTLCreateSystemDefaultDevice()!
let frame = NSRect(x:0, y:0, width:400, height:400)
let view = MetalView(frame: frame, device: device)
view.framebufferOnly = false
PlaygroundPage.current.liveView = view
