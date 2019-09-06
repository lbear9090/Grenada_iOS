//
//  GCGGrenadaVC.swift
//  GoCaribGo Grenada
//
//  Created by Lucky on 23/02/2018.
//  Copyright © 2018 The RedBox Agency. All rights reserved.
//

import UIKit

struct CategoryInfoLanding{
    var img = ""
    var name = ""
    var text = ""
    var isText = false
    var pagetype = 0
}
class LandingVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    @IBOutlet weak var imgWheel: UIImageView!
    
    @IBOutlet weak var collectionContent: UICollectionView!
    @IBOutlet var collectionCategory: UICollectionView!
    
    var dialLayout:CollectionViewDialLayout!
    
    let itemSize = 80
    let categories = [CategoryInfoLanding(img:"act", name:"Grenada", text:"", isText:false, pagetype:0),
                      CategoryInfoLanding(img:"bar", name:"Carriacou", text:"", isText:false, pagetype:1),
                      CategoryInfoLanding(img:"bus", name:"Petit Martinique", text:"", isText:false, pagetype:1)
                      ]
    
    var screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setCircularLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentifier = ""
        if collectionView == collectionCategory{
            cellIdentifier = "cellCategory"
        }else if collectionView == collectionContent{
            cellIdentifier = "cellContent"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let bIsText = categories[indexPath.row].isText
        
        if(collectionView == collectionCategory){
            let img = cell.viewWithTag(100) as! UIImageView
            let text = cell.viewWithTag(101) as! UILabel
            
            if bIsText{
                text.text = categories[indexPath.row].name
            }else{
                img.image = UIImage.init(named: categories[indexPath.row].name+"icon")
            }
            img.isHidden = bIsText
            text.isHidden = !bIsText
            cell.layer.cornerRadius = CGFloat(itemSize/2)
            cell.clipsToBounds = true
        }else if collectionView == collectionContent{
            let img = cell.viewWithTag(100) as! UIImageView
            let title = cell.viewWithTag(101) as! UILabel
            let text = cell.viewWithTag(102) as! UITextView
            //let label = cell.viewWithTag(103) as! UILabel
            //if bIsText{
                //label.text = categories[indexPath.row].name
            //}else{
                img.image = UIImage.init(named: categories[indexPath.row].img)
            //}
            title.text = categories[indexPath.row].name.uppercased()
            text.text = categories[indexPath.row].text
            
            //img.isHidden = bIsText
            //label.isHidden = !bIsText
            
        }
        return cell
    }
    
    func setCircularLayout(){
        
        let angularSpacing = CGFloat(15)
        let radius = CGFloat(screenSize.width)
        let offset = CGFloat(5)
        let dialLayout = CollectionViewDialLayout(radius: radius, angularSpacing: angularSpacing, cellSize: CGSize(width: itemSize, height: itemSize) , alignment: WheelAlignmentType.center, itemHeight: CGFloat(itemSize), viewOffset: offset)
        dialLayout.shouldSnap = true
        dialLayout.shouldFlip = true
        collectionCategory.setCollectionViewLayout(dialLayout, animated: true)
        
        
        dialLayout.cellSize = CGSize(width: itemSize, height: itemSize)
        dialLayout.wheelType = .left
        dialLayout.shouldFlip = false
        
        dialLayout.dialRadius = radius
        dialLayout.angularSpacing = angularSpacing
        dialLayout.viewOffset = offset
        
        collectionCategory.reloadData();

        imgWheel.frame.size = CGSize(width: (radius + offset) * 2, height: (radius + offset) * 2)
        imgWheel.layer.cornerRadius = radius + offset
        imgWheel.clipsToBounds = true

        imgWheel.frame.origin.y =  collectionCategory.frame.origin.y
        imgWheel.center.x = collectionCategory.center.x
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(categories[indexPath.row].pagetype == 0){
            
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "GCGGrenadaVC")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.size.width - 10, height:collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //let contentCollectionViewFlowLayout = collectionContent.collectionViewLayout as! UICollectionViewFlowLayout
        let categoryCollectionViewFlowLayout = collectionCategory.collectionViewLayout as! UICollectionViewFlowLayout
        let contentDistanceBetweenItemsCenter = collectionContent.frame.size.width//contentCollectionViewFlowLayout.minimumLineSpacing + contentCollectionViewFlowLayout.itemSize.width
        let categoryDistanceBetweenItemsCenter = categoryCollectionViewFlowLayout.minimumLineSpacing + categoryCollectionViewFlowLayout.itemSize.width
        let offsetFactor = contentDistanceBetweenItemsCenter / categoryDistanceBetweenItemsCenter
        
        if (scrollView == collectionContent) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            collectionCategory.contentOffset.x = xOffset / offsetFactor
        }
        else if (scrollView == collectionCategory) {
            let xOffset = scrollView.contentOffset.x - scrollView.frame.origin.x
            collectionContent.contentOffset.x = xOffset * offsetFactor
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
