//
//  Image-Extention.swift
//  Murder
//
//  Created by m.a.c on 2020/10/8.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import UIKit


extension UIImage {
    //根据指定尺寸缩放图片
    func imageWithImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
        return newImage!
    }
    
    /**
      *  重设图片大小
      */
     func reSizeImage(reSize: CGSize) -> UIImage? {
        
         //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize, false , 0.0)
        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: reSize))
        let reSizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext ()
        return reSizeImage
     }
     
     /**
      *  等比率缩放
      */
     func scaleImage(scaleSize: CGFloat) -> UIImage?  {
        let reSize = CGSize(width: self.size.width*scaleSize, height: self.size.height*scaleSize)
        return reSizeImage(reSize: reSize)
     }
    
    
    ///根据指定比例缩放图片
    //-(UIImage *)imageCompressWithScale:(CGFloat)scale
    //{
    //
    //    CGSize size = self.size;
    //    CGFloat width = size.width;
    //    CGFloat height = size.height;
    //    CGFloat scaleWidth = width*scale;
    //    CGFloat scaleHeight = height*scale;
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaleWidth, scaleHeight), NO, 0.0);    ///<用这个不失真
    //    [self drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
    //    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return newImage;
    

}
