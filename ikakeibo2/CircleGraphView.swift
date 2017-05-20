import UIKit

class CircleGraphView: UIView {

    var _params: [Dictionary<String,Float>]!
    var _paramsColor: [Dictionary<String,UIColor>]!
    let viewMargin: CGFloat = 5.0
    
    var endAngle: CGFloat!

    func setParams(params:[Dictionary<String,Float>], paramsColor:[Dictionary<String,UIColor>]) {
        _params = params
        _paramsColor = paramsColor

        self.backgroundColor = UIColor.clear
    }

    func update(link:CADisplayLink){
        let angle = CGFloat(.pi * 2.0 / 100.0);
        endAngle = endAngle +  angle

        if(endAngle > CGFloat(Double.pi * 2)) {
            // CADisplayLinkは、invalidate()で終了される。
            link.invalidate()
        } else {
            // 処理（円グラフ描画）が完了しない間は、画面更新を繰り返す。
            self.setNeedsDisplay()
        }
    }

    func startAnimating(){
        endAngle = -CGFloat(.pi / 2.0);
        // CADisplayLinkを使うと、画面更新の度に処理を行わせる事ができる。
        let displayLink = CADisplayLink(target: self, selector: #selector(CircleGraphView.update(link:)))
        // CADisplayLinkのインスタンスを、メインループに登録する
        displayLink.add(to: RunLoop.current, forMode: .commonModes)
    }

    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!;
        // 円の半径をx,yに設定
        var x: CGFloat = rect.origin.x;
        x += rect.size.width/2;
        
        var y: CGFloat = rect.origin.y;
        y += rect.size.height/2;
        
        var sum:CGFloat = 0;

        for dic : Dictionary<String, Float> in _params {
            let value = CGFloat(dic["value"]!)
            sum += value;
        }
        
        // -90度回転させる(=>円グラフ描画の先頭になる）
        var start_angle: CGFloat = -CGFloat(Double.pi / 2)
        var end_angle: CGFloat = 0
        let radius: CGFloat = x - viewMargin
        var i = 0

        for dic: Dictionary<String,Float> in _params {
            let value = CGFloat(dic["value"]!)
            
            // (value / sum)の箇所は、0.0〜1.0の範囲で角度を指定していることになる。
            end_angle = start_angle + CGFloat(Double.pi * 2) * (value / sum);
            if(end_angle > endAngle) {
                end_angle = endAngle;
            }

            let color = _paramsColor[i]["color"]!
            i = i + 1

            context.move(to: CGPoint(x: x, y: y))
            context.setFillColor(color.cgColor)
            context.addArc(center: CGPoint(x: x, y: y), radius: radius, startAngle: start_angle, endAngle: end_angle, clockwise: false)
            context.closePath()
            context.fillPath()

            // 次回は今回描画した角度以降を描画
            start_angle = end_angle;
        }
    }
}


