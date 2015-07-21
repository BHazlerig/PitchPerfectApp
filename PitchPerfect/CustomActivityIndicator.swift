//
//  CustomActivityIndicator.swift
//  PitchPerfect
//
//  Created by Ben Hazlerig on 7/19/15.
//  Copyright (c) 2015 Benjamin Allen. All rights reserved.
//

import UIKit

class CustomActivityIndicator: UIView {
  
  private var animating : Bool = false
  private var _color : UIColor? = UIColor.grayColor()
  

  var hidesWhenStopped : Bool = false
  var circles : [UIView] = []
  
  var color : UIColor? {
    get
    {
      return _color!
    }
    set
    {
      _color = newValue
      if let unwrappedColor = _color {
        for index in 0...3
        {
          let currentBar : UIView = self.circles[index]
          currentBar.backgroundColor = unwrappedColor
        }
      }
    }
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    commonInit()
  }
  
  override required init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }
  
  private func commonInit() {
    self.backgroundColor = UIColor.clearColor()
    let circleWidth = self.bounds.size.width / 5
    let circleHeight = circleWidth
    let circleSpacing = circleWidth/3
    let cornerRadius = circleWidth/2
    var currX : CGFloat = 0.0
    let currY : CGFloat = (self.bounds.size.height - circleHeight)/2
    for _ in 0...3
    {
      let currView : UIView = UIView(frame: CGRectMake(currX, currY, circleWidth, circleHeight))
      currView.layer.cornerRadius = cornerRadius
      self.circles.append(currView)
      currX += circleWidth + circleSpacing
      self.addSubview(currView)
    }
  }
  
  func startAnimating() {
    if self.isAnimating()
    {
      return
    }
    self.layer.hidden = false
    self.animating = true
    
    var animationMin = 0.2
    let animationDiffs = (1.0 - animationMin) / Double(self.circles.count)
    let animationKeyframeDiffs = 1.0 / Double(self.circles.count)
    for index in 0...3
    {
      let currentCircle : UIView = self.circles[index]
      let animationX = CAKeyframeAnimation(keyPath: "transform.scale.x")
      let animationY = CAKeyframeAnimation(keyPath: "transform.scale.y")
      var values : [Double] = []
      var startValue = animationMin
      for _ in 0...self.circles.count
      {
        if startValue > 1.0
        {
          startValue = 0.2
        }
        values.append(startValue)
        startValue += animationDiffs
      }
      animationMin += animationDiffs
      animationX.values = values
      animationY.values = values
      var animationStart = 0.0
      var keyFrames : [Double] = []
      for _ in 0...self.circles.count
      {
        keyFrames.append(animationStart)
        animationStart += animationKeyframeDiffs
      }
      animationX.keyTimes = keyFrames
      animationX.calculationMode = kCAAnimationPaced
      animationX.repeatCount = Float.infinity
      animationX.duration = 0.5
      animationX.autoreverses = true
      currentCircle.layer.addAnimation(animationX, forKey: "animationX\(index)")
      
      animationY.keyTimes = keyFrames
      animationY.calculationMode = kCAAnimationPaced
      animationY.repeatCount = Float.infinity
      animationY.duration = 0.5
      animationY.autoreverses = true
      currentCircle.layer.addAnimation(animationY, forKey: "animationY\(index)")
    }
  }
  
  func stopAnimating() {
    if !self.isAnimating()
    {
      return
    }
    self.animating = false
    self.layer.hidden = self.hidesWhenStopped
    for index in 0...3
    {
      let currentCircle : UIView = self.circles[index]
      currentCircle.layer.removeAllAnimations()
    }
  }
  
  func isAnimating() -> Bool {
    return self.animating
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let circleWidth = self.bounds.size.width / 5
    let circleHeight = circleWidth
    let circleSpacing = circleWidth/3
    let cornerRadius = circleWidth/2
    var currX : CGFloat = 0.0
    let currY : CGFloat = (self.bounds.size.height - circleHeight)/2
    for index in 0...3
    {
      let currentCircle : UIView = self.circles[index]
      currentCircle.frame = CGRectMake(currX, currY, circleWidth, circleHeight)
      currX += circleWidth + circleSpacing
      currentCircle.layer.cornerRadius = cornerRadius
    }
  }
  
}