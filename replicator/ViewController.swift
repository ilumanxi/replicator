//
//  ViewController.swift
//  replicator
//
//  Created by lumanxi on 15/9/14.
//  Copyright © 2015年 fanfan. All rights reserved.
//  http://www.devtalking.com

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var replicatorAnimationView: UIView!
    
    
    
    @IBOutlet weak var activityIndicatorView: UIView!
    
    /*
    
        CAReplicatorLayer是一个新面孔，它也是CALayer的子类，正如它的名称一样，CAReplicatorLayer可以对它自己的子Layer进行复制操作。创建了CAReplicatorLayer实例后，设置了它的尺寸大小、位置、锚点位置、背景色，并且将它添加到
    
            autoreverses，这个属性为Bool类型，设置为true时，开启自动反向执行动画，比如示例中的白色长方形的移动动画为向上移动50个像素，如过autoreverses设置为false，那么动画结束后，会根据重复次数，白色长方形重新回到初始位置，继续向上移动，如果autoreverses设置为true，则当动画结束后，白色长方形会继续向下移动至初始位置，然后再开始第二次的向上移动动画
    
        Layer的默认锚点坐标是(0.5, 0.5)，也就是Layer的中心点位置，而Layer的position又是根据锚点计算的，所以如果你设置Layer的position属性为(10, 10)，就相当于设置了Layer的中心位置为(10, 10)，并不是你期望的左上角位置。所以如果Layer想使用它父视图的坐标位置，就需要将锚点位置设置为(0, 0)，这样一来Layer的position属性标识的就是Layer左上角的位置：
    
    */
    
    func firstReplicatorAnimation(){
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.bounds = CGRect(x: replicatorAnimationView.frame.origin.x, y: replicatorAnimationView.frame.origin.y, width: replicatorAnimationView.frame.size.width, height: replicatorAnimationView.frame.size.height)
        replicatorLayer.anchorPoint = CGPoint(x: 0, y: 0)
        replicatorLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        replicatorAnimationView.layer.addSublayer(replicatorLayer)
        let rectangle = CALayer()
        rectangle.bounds = CGRect(x: 0, y: 0, width: 30, height: 90)
        rectangle.anchorPoint = CGPoint(x: 0, y: 0)
        rectangle.position = CGPoint(x: replicatorAnimationView.frame.origin.x + 10, y: replicatorAnimationView.frame.origin.y + 110)
        rectangle.cornerRadius = 2
        rectangle.backgroundColor = UIColor.whiteColor().CGColor
        replicatorLayer.addSublayer(rectangle)
        
        let moveRectangle = CABasicAnimation(keyPath: "position.y")
        moveRectangle.toValue = rectangle.position.y - 70
        moveRectangle.duration = 0.7
        moveRectangle.autoreverses = true
        moveRectangle.repeatCount = HUGE
        rectangle.addAnimation(moveRectangle, forKey: nil)
        
        //Layer复制3份，复制Layer与原Layer的大小、位置、颜色、Layer上的动画等等所有属性都一模一样，所以这时编译运行代码我们看不到任何不同的效果，因为三个白色长方形是重合在一起的，
        replicatorLayer.instanceCount = 3
        //设置每个白色长方形的间隔
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(40, 0, 0)
        //CAReplicatorLayer中的每个子Layer的动画起始时间逐个递增。这里我们设置为0.3秒，也就是第一个长方形先执行动画，过0.3秒后第二个开始执行动画，再过0.3秒后第三个开始执行动画
        replicatorLayer.instanceDelay = 0.3
        //masksToBounds是CALayer的属性，作用是将Layer视为一个遮罩，只显示遮罩区域内的内容
        replicatorLayer.masksToBounds = true
        replicatorLayer.backgroundColor = UIColor.clearColor().CGColor
    }
    
    func activityIndicatorAnimation(){
        let replicatorLayer = CAReplicatorLayer()
        replicatorLayer.bounds = CGRect(x: 0, y: 0, width: activityIndicatorView.frame.size.width, height: activityIndicatorView.frame.size.height)
        replicatorLayer.position = CGPoint(x: activityIndicatorView.frame.size.width/2, y: activityIndicatorView.frame.size.height/2)
        replicatorLayer.backgroundColor = UIColor.lightGrayColor().CGColor
        activityIndicatorView.layer.addSublayer(replicatorLayer)
        
        let circle = CALayer()
        circle.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        circle.position = CGPoint(x: activityIndicatorView.frame.size.width/2, y: activityIndicatorView.frame.size.height/2 - 55)
        circle.cornerRadius = 7.5
        circle.backgroundColor = UIColor.whiteColor().CGColor
        replicatorLayer.addSublayer(circle)
        
        replicatorLayer.instanceCount = 15
        let angle = CGFloat(2 * M_PI) / CGFloat(15)
        replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        //首先创建一个按比例缩放类型的动画，设置起始比例为1，也就是当前大小。再设置希望缩放到的比例为0.1。动画持续时间为1秒，重复无限次。最后将该动画添加在小圆点中。编译
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 0.1
        scale.duration = 1
        scale.repeatCount = HUGE
        circle.addAnimation(scale, forKey: nil)
        
        
        //目前每个小圆点是同时执行动画，我们需要设置小圆点的动画延迟时间，接着添加如下代码：这里为什么是1/15呢，因为整个动画的时间是由每个小圆点的动画时间决定的，这里也就是1秒，所有小圆点的延迟时间加起来要等于整个动画的持续时间，所以这里就是用1秒除以小圆点的数量15
        replicatorLayer.instanceDelay = 1/15
        
        //从效果图中可以看到，刚开始的动画不是很自然，那是因为小圆点的初始比例是1，所以一开始会先看到小圆点，然后才会慢慢开始正常的动画。这个问题很好解决，我们让小圆点的初始比例为0.1，也就是刚开始看不到小圆点，这样就可以避免这个情况了，我们接着加一行代码
        circle.transform = CATransform3DMakeScale(0.01, 0.01, 0.01)
        
        replicatorLayer.backgroundColor = UIColor.clearColor().CGColor

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        firstReplicatorAnimation()
        activityIndicatorAnimation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

