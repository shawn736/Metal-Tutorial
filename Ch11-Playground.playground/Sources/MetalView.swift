import MetalKit

public class MetalView: NSObject, MTKViewDelegate {
    
    public var device: MTLDevice!
    var queue: MTLCommandQueue!
    var cps: MTLComputePipelineState!
    
    override public init() {
        super.init()
        registerShaders()
    }
    
    func registerShaders() {
        device = MTLCreateSystemDefaultDevice()!
        queue = device.makeCommandQueue()
        do {
            let library = device.makeDefaultLibrary()!
            let kernel = library.makeFunction(name: "compute")!
            cps = try device.makeComputePipelineState(function: kernel)
        } catch let e {
            Swift.print("\(e)")
        }
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    public func draw(in view: MTKView) {
        if let drawable = view.currentDrawable,
            let commandBuffer = queue.makeCommandBuffer(),
            let commandEncoder = commandBuffer.makeComputeCommandEncoder() {
            commandEncoder.setComputePipelineState(cps)
            commandEncoder.setTexture(drawable.texture, index: 0)
            let threadGroupCount = MTLSizeMake(8, 8, 1)
            let threadGroups = MTLSizeMake(drawable.texture.width / threadGroupCount.width, drawable.texture.height / threadGroupCount.height, 1)
            commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
