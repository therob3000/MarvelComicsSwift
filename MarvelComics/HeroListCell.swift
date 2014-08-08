//
//  HeroListCell.swift
//  MarvelComics
//
//  Created by Sergey Shulga on 6/11/14.
//  Copyright (c) 2014 Sergey Shulga. All rights reserved.
//

import UIKit

let heroListCellMaxParalaxOffset:CGFloat = 50.0

class HeroListCell: UITableViewCell {
    
    
    @IBOutlet var heroImageView: UIImageView?
    @IBOutlet var blurConteinerView: UIView?
    @IBOutlet var heroNameLabel: UILabel?
    @IBOutlet var scrollView: UIScrollView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView!.scrollsToTop = false
        self.__createBlurView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.heroNameLabel!.text  = ""
        self.heroImageView!.image = UIImage(named: "hero_placeholder")
    }
    
}


extension HeroListCell {
    
    func configCellWith(hero:Hero!){
        self.__setHeroImageWith(hero.thumbnail?)
        self.heroNameLabel!.text = hero.name
    }
    
    func paralaxScrollingForDeleta(delta:CGFloat, scrollDirection:Bool){
        
        if scrollDirection {
            if self.scrollView!.contentOffset.y + delta > heroListCellMaxParalaxOffset {
                self.scrollView!.contentOffset.y = heroListCellMaxParalaxOffset
            } else {
                self.scrollView!.contentOffset.y += delta
            }
        } else {
            if self.scrollView!.contentOffset.y - delta < -heroListCellMaxParalaxOffset {
                self.scrollView!.contentOffset.y = -heroListCellMaxParalaxOffset
            } else {
                self.scrollView!.contentOffset.y -= delta
            }
        }
        
    }
    
    private func __setHeroImageWith(thumbnail:Thumbnail?){
        
        if thumbnail{
            var stringUrl:String      = thumbnail!.path + "/standard_xlarge." + thumbnail!.imageExtension;
            var url:NSURL             = NSURL(string: stringUrl)
            var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
            
            request.addValue("image/*", forHTTPHeaderField: "Accept")
            
            self.heroImageView!.setImageWithURLRequest(request, placeholderImage: nil,
                success: {[weak self] (request: NSURLRequest!,response: NSHTTPURLResponse!,image: UIImage!)  in
                    self!.heroImageView!.image = image
                },
                failure:nil)
        }else{
            self.heroImageView!.image = UIImage(named: "hero_placeholder")
        }
    }
    
    
    private func __createBlurView(){
        
        let blurView:UIVisualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark))
        
        blurView.frame = self.blurConteinerView!.bounds
        blurView.clipsToBounds = true
        
        blurConteinerView!.insertSubview(blurView, belowSubview: self.heroNameLabel)
    }
    
}
