//
//  ViewController.swift
//  power!!!!
//
//  Created by 手嶋慧太 on 2021/03/16.
//

import UIKit
import EMTNeumorphicView
import CoreHaptics

struct ColorData {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
}

class ViewController: UIViewController {
    @IBOutlet weak var powerButton: EMTNeumorphicButton!
    @IBOutlet weak var lockView: EMTNeumorphicView!
    @IBOutlet weak var sliderView: EMTNeumorphicButton!
    @IBOutlet weak var hapticSlider: UISlider!
    
    var colorData = ColorData(red: 0.85, green: 0.85, blue: 0.85)
    var forcePower: Int = 0
    var buttonState: Bool = false
    var viewState: Bool = false
    var flag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewBackgroundColorConfigure()
        buttonConfigure()

        hapticSlider.addTarget(self, action: #selector(valueDidLeft), for: UIControl.Event.touchUpInside)
        // Do any additional setup after loading the view.
    }

    @IBAction func toggleDidTapped(_ sender: UISwitch) {
        flag = sender.isOn
    }

    
    private func viewBackgroundColorConfigure() {
        let mainColor = UIColor(red: colorData.red, green: colorData.green, blue: colorData.blue, alpha: 1)

        self.view.backgroundColor = mainColor
        lockView.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
        lockView.layer.cornerRadius = 10
        lockView.neumorphicLayer?.elementDepth = 7

        sliderView.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
        sliderView.layer.cornerRadius = 10
        sliderView.neumorphicLayer?.elementDepth = 7
    }
    
    private func buttonConfigure() {
        powerButton.layer.cornerRadius = 50
        powerButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
        powerButton.tintColor = UIColor.darkGray
        powerButton.neumorphicLayer?.elementDepth = 7
        powerButton.isSelected = true
        powerButton.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
    }

    private func changeViewColor() {
        if !flag {
            colorData.red = 1-colorData.red
            colorData.green = 1-colorData.green
            colorData.blue = 1-colorData.blue

            let mainColor = UIColor(red: colorData.red, green: colorData.green, blue: colorData.blue, alpha: 1)

            self.view.backgroundColor = mainColor
            lockView.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
            sliderView.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor
            powerButton.neumorphicLayer?.elementBackgroundColor = view.backgroundColor!.cgColor

            viewState = !viewState
        }
    }
    
    @objc func tapped(_ button: EMTNeumorphicButton) {
        // isSelected property changes neumorphicLayer?.depthType automatically
        
        if viewState == buttonState {
            changeViewColor()
        }

        fireFeedBack()

        button.isSelected = !button.isSelected
        buttonState = !buttonState
    }

    private func fireFeedBack() {
        switch forcePower {
        case 0:
            Feedbacker.impact(style: .soft)
        case 1:
            Feedbacker.impact(style: .light)
        case 2:
            Feedbacker.impact(style: .rigid)
        case 3:
            Feedbacker.impact(style: .medium)
        case 4:
            Feedbacker.impact(style: .heavy)
        default:
            break
        }
    }

    @objc func valueDidLeft(sender: UISlider) {
        sender.value = round(sender.value)
        forcePower = Int(round(sender.value))
        fireFeedBack()
    }

}

struct Feedbacker {

  static func notice(type: UINotificationFeedbackGenerator.FeedbackType) {
      let generator = UINotificationFeedbackGenerator()
      generator.prepare()
      generator.notificationOccurred(type)
  }

  static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
      let generator = UIImpactFeedbackGenerator(style: style)
      generator.prepare()
      generator.impactOccurred()
  }

  static func selection() {
      let generator = UISelectionFeedbackGenerator()
      generator.prepare()
      generator.selectionChanged()
  }

}
