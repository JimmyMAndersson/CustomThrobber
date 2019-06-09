import UIKit

@IBDesignable class ThrobberView: UIView {
    private var gradientLayer: CAGradientLayer = CAGradientLayer()
    private var maskingLayer: CAShapeLayer = CAShapeLayer()
    private var shape: UIBezierPath = UIBezierPath()
    private var counter: CGFloat = 1
    private var animationTimer: Timer
    public var isAnimating: Bool {
        return animationTimer.isValid
    }
    
    override init(frame: CGRect) {
        animationTimer = Timer()
        animationTimer.invalidate()
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        animationTimer = Timer()
        animationTimer.invalidate()
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
        maskingLayer.frame = self.bounds
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(center))
        removeObserver(self, forKeyPath: #keyPath(frame))
    }
    
    private func initialize() {
        self.alpha = 0
        gradientLayer.type = .conic
        gradientLayer.colors = [UIColor.red.cgColor,
                                UIColor.green.cgColor,
                                UIColor.blue.cgColor,
                                UIColor.red.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        
        maskingLayer.fillColor = UIColor.clear.cgColor
        maskingLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = maskingLayer
        
        gradientLayer.frame = self.bounds
        maskingLayer.frame = self.bounds
        
        self.layer.addSublayer(gradientLayer)
        addObserver(self, forKeyPath: #keyPath(center),
                    options: .new, context: nil)
        addObserver(self, forKeyPath: #keyPath(frame),
                    options: .new, context: nil)
        animationTimer.invalidate()
    }
    
    public func startAnimating() {
        guard !isAnimating else { return }
        print("Starting animation")
        rotate(timing: .linear, duration: 0.5)
        DispatchQueue.global(qos: .userInitiated).async {
            self.animationTimer = Timer(timeInterval: 0.5,
                                        repeats: true,
                                        block: { (_) in
                                            
                                            self.rotate(timing: .linear, duration: 0.5)
                                            
            })
            RunLoop.current.add(self.animationTimer, forMode: .common)
            RunLoop.current.run()
        }
        UIView.animate(withDuration: 0.4) {
            self.alpha = 1
        }
    }
    
    public func stopAnimating() {
        guard isAnimating else { return }
        print("Stopping animation")
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { (_) in
            self.animationTimer.invalidate()
        }
    }
    
    private func rotate(timing: CAMediaTimingFunctionName, duration: CFTimeInterval) {
        if counter == 3 { counter = 1 }
        
        let anim = CABasicAnimation()
        anim.duration = duration
        anim.keyPath = "transform"
        anim.toValue = CATransform3D(m11: cos(counter * CGFloat.pi),
                                     m12: -sin(counter * CGFloat.pi),
                                     m13: 0,
                                     m14: 0,
                                     m21: sin(counter * CGFloat.pi),
                                     m22: cos(counter * CGFloat.pi),
                                     m23: 0,
                                     m24: 0,
                                     m31: 0,
                                     m32: 0,
                                     m33: 1,
                                     m34: 0,
                                     m41: 0,
                                     m42: 0,
                                     m43: 0,
                                     m44: 1)
        anim.isRemovedOnCompletion = false
        anim.fillMode = .forwards
        anim.timingFunction = CAMediaTimingFunction(name: timing)
        
        gradientLayer.add(anim, forKey: nil)
        counter += 1
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(center) || keyPath == #keyPath(frame) {
            print(keyPath!)
            
            shape.removeAllPoints()
            let lineWidth = max(min(bounds.height, bounds.width) / 8, 1)
            let radius = (min(bounds.height, bounds.width) / 2) - lineWidth
            shape.addArc(withCenter: CGPoint(x: self.bounds.midX, y: self.bounds.midY), radius: radius, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            maskingLayer.path = shape.cgPath
            maskingLayer.lineWidth = lineWidth
            maskingLayer.frame = self.bounds
            gradientLayer.frame = self.bounds
        }
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.alpha = 1
        self.gradientLayer.frame = self.bounds
        self.maskingLayer.frame = self.bounds
    }
}
