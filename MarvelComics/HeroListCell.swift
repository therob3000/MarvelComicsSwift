//
//  HeroListCell.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

let constraintConstant:CGFloat = 8

class HeroListCell: UITableViewCell {
    
    
    @IBOutlet var heroImageView: UIImageView
    @IBOutlet var blurConteinerView: UIView
    @IBOutlet var heroNameLabel: UILabel
    @IBOutlet var scrollView: UIScrollView
    
              var shouldParalax: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.shouldParalax = true
        //self.scrollView.contentOffset.y = 50
        self._createBlurView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.heroNameLabel.text  = ""
        //self.scrollView.contentOffset.y = 50
        self.shouldParalax = true
    }
    
}


extension HeroListCell {
    
    func configCellWith(hero:Hero!){
        self.setHeroImageWith(hero.thumbnail?)
        self.heroNameLabel.text = hero.name
        println("Offset = \(NSStringFromCGPoint(self.scrollView.contentOffset))")
    }
    
    func setHeroImageWith(thumbnail:Thumbnail?){
        
        if thumbnail{
            var stringUrl:String      = thumbnail!.path + "/landscape_incredible." + thumbnail!.imageExtension;
            var url:NSURL             = NSURL(string: stringUrl)
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            request.addValue("image/*", forHTTPHeaderField: "Accept")
            
            weak var weakSelf :HeroListCell! = self
            
            self.heroImageView.setImageWithURLRequest(request, placeholderImage: nil,
                success: {(request: NSURLRequest!,response: NSHTTPURLResponse!,image: UIImage!) in
                    weakSelf.heroImageView!.image = image
                },
                failure:nil)
        }else{
            self.heroImageView.image = UIImage(named: "hero_placeholder")
        }
    }
    
    func paralaxScrollingForDeleta(delta:CGFloat, scrollDirection:Bool){
        
        if scrollDirection {
            if self.scrollView.contentOffset.y + delta > 30 {
                self.scrollView.contentOffset.y = 30
            } else {
                self.scrollView.contentOffset.y += delta
            }
        } else {
            if self.scrollView.contentOffset.y - delta < -30 {
                self.scrollView.contentOffset.y = -30
            } else {
                self.scrollView.contentOffset.y -= delta
            }
        }
        
        println("Image offset = \(NSStringFromCGPoint(scrollView.contentOffset))")

    }
    
    func _createBlurView(){
        
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        
        blurView.frame = self.blurConteinerView.bounds
        blurView.clipsToBounds = true
        
        blurConteinerView.insertSubview(blurView, belowSubview: self.heroNameLabel)
    }
    
}
