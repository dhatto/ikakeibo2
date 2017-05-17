import UIKit

class CircleGraphView: UIView {
    
//    var _params:[Dictionary<String,AnyObject>]!
    var _params:[Dictionary<String,Float>]!
    var _paramsColor:[Dictionary<String,UIColor>]!
    
    var _end_angle:CGFloat!
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//    init(frame: CGRect,params:[Dictionary<String,AnyObject>]) {
//        super.init(frame: frame)
//        _params = params;
//        self.backgroundColor = UIColor.clear
//        _end_angle = -CGFloat(.pi / 2.0);
//    }

//    func setParams(params:[Dictionary<String,AnyObject>]) {
//        _params = params;
//        self.backgroundColor = UIColor.clear
//        _end_angle = -CGFloat(.pi / 2.0);
//    }
    
    func setParams(params:[Dictionary<String,Float>], paramsColor:[Dictionary<String,UIColor>]) {
        _params = params
        _paramsColor = paramsColor
        
        self.backgroundColor = UIColor.clear
        _end_angle = -CGFloat(.pi / 2.0);
    }

    func update(link:AnyObject){
        let angle = CGFloat(.pi*2.0 / 100.0);
        _end_angle = _end_angle +  angle
        if(_end_angle > CGFloat(Double.pi*2)) {
            //終了
            link.invalidate()
        } else {
            self.setNeedsDisplay()
        }
    }

//    func changeParams(params:[Dictionary<String,AnyObject>]){
//        _params = params;
//    }

    func startAnimating(){
        _end_angle = -CGFloat(.pi / 2.0);
        let displayLink = CADisplayLink(target: self, selector: #selector(CircleGraphView.update(link:)))
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if _params == nil {
            return
        }
        
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        var x:CGFloat = rect.origin.x;
        x += rect.size.width/2;
        var y:CGFloat = rect.origin.y;
        y += rect.size.height/2;
        var max:CGFloat = 0;
        
//        for dic : Dictionary<String,AnyObject> in _params {
//            let test = dic["value"]?.value
//            let test2 = dic["color"]
////            let value = CGFloat(dic["value"] as! Float)
////            max += value;
//        }
        
        for dic : Dictionary<String, Float> in _params {
            let value = CGFloat(dic["value"]!)
            //let value = CGFloat(dic["value"] as! Float)
            max += value;
        }
        
        
        var start_angle:CGFloat = -CGFloat(Double.pi / 2);
        var end_angle:CGFloat    = 0;
        let radius:CGFloat  = x - 10.0;
        
//        for dic : Dictionary<String,AnyObject> in _params {
        for dic : Dictionary<String,Float> in _params {
            //let value = CGFloat(dic["value"] as! Float)
            let value = CGFloat(dic["value"]!)
            end_angle = start_angle + CGFloat(Double.pi*2) * (value/max);
            if(end_angle > _end_angle) {
                end_angle = _end_angle;
            }
            
            let color:UIColor = _paramsColor[0]["color"]!
            
            context.move(to: CGPoint(x: x, y: y))
            context.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: start_angle, endAngle: end_angle, clockwise: false)
            //CGContextAddArc(context, x, y, radius,  start_angle, end_angle, 0);

            //
            //If you comment out this line , the graph will be to fill all .
            //
            context.addArc(center: CGPoint(x: x, y: y), radius: radius/2, startAngle: end_angle, endAngle: start_angle, clockwise: false)
            context.setFillColor(color.cgColor)
            context.closePath()
            context.fillPath()

//            CGContextSetFillColor(context, CGColorGetComponents(color.CGColor));
//            CGContextClosePath(context);
//            CGContextFillPath(context);
            start_angle = end_angle;
        }

    }

}
