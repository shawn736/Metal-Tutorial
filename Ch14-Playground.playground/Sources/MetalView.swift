import MetalKit

public class MetalView: MTKView, NSWindowDelegate {
    
    var queue: MTLCommandQueue! = nil
    var cps: MTLComputePipelineState! = nil
    var timer: Float = 0
    var timerBuffer: MTLBuffer!
    
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public init(frame frameRect: CGRect, device: MTLDevice?) {
        super.init(frame: frameRect, device: device)
        registerShaders()
    }
    
    override public func draw(_ dirtyRect: NSRect) {
        if let drawable = currentDrawable,
            let commandBuffer = queue.makeCommandBuffer(),
            let commandEncoder = commandBuffer.makeComputeCommandEncoder() {
            commandEncoder.setComputePipelineState(cps)
            commandEncoder.setTexture(drawable.texture, index: 0)
            commandEncoder.setBuffer(timerBuffer, offset: 0, index: 0)
            update()
            let threadGroupCount = MTLSizeMake(8, 8, 1)
            let threadGroups = MTLSizeMake(drawable.texture.width / threadGroupCount.width, drawable.texture.height / threadGroupCount.height, 1)
            commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
        
    }
    
    func update() {
        timer += 0.01
        let bufferPointer = timerBuffer.contents()
        memcpy(bufferPointer, &timer, MemoryLayout<Float>.size)
    }
    
    func registerShaders() {
        queue = device!.makeCommandQueue()
        do {
            let library = device!.makeDefaultLibrary()!
            let kernel = library.makeFunction(name: "compute")!
            cps = try device!.makeComputePipelineState(function: kernel)
        } catch let e {
            Swift.print("\(e)")
        }
        timerBuffer = device!.makeBuffer(length: MemoryLayout<Float>.size, options: [])
    }
}
