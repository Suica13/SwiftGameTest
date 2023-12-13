//
//  ViewController.swift
//  SwiftGameTest
//
//  Created by student on 2023/11/15.
//

import UIKit

class ViewController: UIViewController {
    
    var characterTask:Task<Void,Never>?
    var dateUpdateTask:Task<Void,Never>?
    
    @IBOutlet weak var topBaseView:UIView!
    @IBOutlet weak var lifePointValueLabel:UILabel!
    @IBOutlet weak var comfyPointValueLabel:UILabel!
    @IBOutlet weak var favPointValueLabel:UILabel!
    @IBOutlet weak var bottomBaseView:UIView!
    @IBOutlet weak var eatButton:UIButton!
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var cleaningButton:UIButton!
    @IBOutlet var characterImageViews:[UIImageView]!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var dayOfWeekLabel:UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        topViewSetup()
        bottomViewSetup()
        eatButton.addTarget(self, action: #selector(eatButtonPressed), for: .touchUpInside)
        cleaningButton.addTarget(self, action: #selector(cleaningButtonPressed), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        updateCharacterPosition()
        updateDateLabel()
    }
    
    func topViewSetup()
    {
        topBaseView.layer.borderColor = UIColor.label.cgColor
        topBaseView.layer.borderWidth = 0.0
        topBaseView.layer.cornerRadius = 25.0
        topBaseView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
    }
    
    func bottomViewSetup()
    {
        bottomBaseView.layer.borderColor = UIColor.label.cgColor
        bottomBaseView.layer.borderWidth = 0.0
        bottomBaseView.layer.cornerRadius = 25.0
        bottomBaseView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }

    var characterInstance = CharacterModel(
        currentGrowthState: .childhood,
        currentHitPoint: 10,
        maxHitPoint: 100,
        livingEnvironment: 1,
        maxLivingEnvironment: 10,
        favorabilityRating: 0,
        maxFavorabilityRating: 100,
        lastFeedDate: nil,
        last12HourFeedCount: 0
    )
    
    //Update Character Image Pos
    func updateCharacterPosition()
    {
        characterTask = Task
        {
            @MainActor in
            
            characterImageViews.forEach{view in view.image = nil}
            
            if let imageView = characterImageViews.randomElement()
            {
                imageView.image = UIImage(named: "CharacterDemoImage")
            }
            try? await Task.sleep(nanoseconds: 5 * 1000000000)
            //updateCharacterPosition()
        }
    }
    
    func updateDateLabel()
    {
        dateUpdateTask = Task
        {
            @MainActor in
            lifePointValueLabel.text = String(characterInstance.currentHitPoint) + "/" + String(characterInstance.maxHitPoint)
            comfyPointValueLabel.text = String(characterInstance.livingEnvironment) + "/" + String(characterInstance.maxLivingEnvironment)
            favPointValueLabel.text = String(characterInstance.favorabilityRating) + "/" + String(characterInstance.maxFavorabilityRating)
            let now = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .init(identifier: "ja_JP")
            dateFormatter.dateFormat = "MM/dd"
            dateLabel.text = dateFormatter.string(from: now)
            dateFormatter.dateFormat = "EEEE"
            dayOfWeekLabel.text = "(\(dateFormatter.string(from: now)))"
            try? await Task.sleep(nanoseconds: 60 * 60 * 1000000000)
            updateDateLabel()
        }
    }
    
    @objc func eatButtonPressed() {
        print("Eat Button Pressed!")
        if(self.characterInstance.currentHitPoint<self.characterInstance.maxHitPoint)
        {
            self.characterInstance.currentHitPoint += 1
            lifePointValueLabel.text = String(characterInstance.currentHitPoint) + "/" + String(characterInstance.maxHitPoint)
            print("LifePoint++")
            updateCharacterPosition()
        }
    }
    
    @objc func playButtonPressed() {
        print("Play Button Pressed!")
        if(self.characterInstance.favorabilityRating<self.characterInstance.maxFavorabilityRating)
        {
            self.characterInstance.favorabilityRating += 1
            favPointValueLabel.text = String(characterInstance.favorabilityRating) + "/" + String(characterInstance.maxFavorabilityRating)
            print("FavPoint++")
            updateCharacterPosition()
        }
    }
    
    @objc func cleaningButtonPressed() {
        print("Cleaning Button Pressed!")
        if(self.characterInstance.livingEnvironment<self.characterInstance.maxLivingEnvironment)
        {
            self.characterInstance.livingEnvironment += 1
            comfyPointValueLabel.text = String(characterInstance.livingEnvironment) + "/" + String(characterInstance.maxLivingEnvironment)
            print("Environment++")
            updateCharacterPosition()
        }
        else
        {
            print("On Max Living Environment")
        }
    }
}

