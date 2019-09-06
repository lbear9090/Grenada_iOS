//
//  CollectionViewDialLayout.swift
//
//


import UIKit


enum WheelAlignmentType{
    case left, center
}

class CollectionViewDialLayout: UICollectionViewFlowLayout {
    var cellCount:Int!
    var wheelType:WheelAlignmentType!
    var center:CGPoint!
    var offset:CGFloat!
    var itemHeight:CGFloat!
    var viewOffset:CGFloat!
    var cellSize:CGSize!
    var angularSpacing:CGFloat!
    var dialRadius:CGFloat!
    var currentIndexPath:IndexPath!
    
    var shouldSnap = false
    var shouldFlip = false
    
    var lastVelocity:CGPoint!
    
    init(radius: CGFloat, angularSpacing: CGFloat, cellSize:CGSize, alignment:WheelAlignmentType, itemHeight:CGFloat, viewOffset:CGFloat) {
        super.init()
        
        self.dialRadius = radius
        self.angularSpacing = angularSpacing
        self.wheelType = alignment
        self.itemHeight = itemHeight
        self.cellSize = cellSize
        self.itemSize = cellSize
        
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.itemHeight = itemHeight
        self.angularSpacing = angularSpacing
        self.sectionInset = UIEdgeInsets.zero
        self.scrollDirection = .horizontal
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        self.offset = 0.0;
    }
    
    override func prepare(){
        super.prepare()
        if self.collectionView!.numberOfSections > 0{
            self.cellCount = self.collectionView?.numberOfItems(inSection: 0)
        }else{
            self.cellCount = 0
        }
        if scrollDirection == .vertical{
            self.offset = -self.collectionView!.contentOffset.y / self.itemHeight
        }else{
            self.offset = -self.collectionView!.contentOffset.x / self.itemHeight
        }
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func getRectForItem(_ itemIndex: Int) -> CGRect{
        var rX = Float(0)
        var rY = Float(0)
        var oX = CGFloat(0)
        var oY = CGFloat(0)
        
        var newIndex =  CGFloat(itemIndex) + self.offset
        //let scaleFactor = fmax(0.6, 1 - fabs( newIndex * 0.25))
        //let deltaX = self.cellSize.width/2
        let temp = Float(self.angularSpacing)
        let dds = Float(self.dialRadius)// + (deltaX * scaleFactor))
        
        if(scrollDirection == .horizontal){
            newIndex = CGFloat(itemIndex - 6) + self.offset
            rX = cosf(temp * Float(newIndex) * Float(Double.pi/180)) * dds
            
            rY = sinf(temp * Float(newIndex) * Float(Double.pi/180)) * dds
            
            oX = self.collectionView!.bounds.size.width/2 + self.collectionView!.contentOffset.x - (0.5 * self.cellSize.width)
            oY = self.dialRadius + viewOffset;// + (0.5 * self.cellSize.height);
        }else{
            rX = cosf(temp * Float(newIndex) * Float(Double.pi/180)) * dds
            
            rY = sinf(temp * Float(newIndex) * Float(Double.pi/180)) * dds
            
            oX = -self.dialRadius - (0.5 * self.cellSize.width)
            oY = self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y - (0.5 * self.cellSize.height)
        }

        if(shouldFlip){
            oX = self.collectionView!.frame.size.width + self.dialRadius - self.viewOffset - (0.5 * self.cellSize.width)
            rX *= -1
        }
        let itemFrame = CGRect(x: oX + CGFloat(rX), y: oY + CGFloat(rY), width: self.cellSize.width, height: self.cellSize.height)
        
        return itemFrame
    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var theLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        let maxVisiblesHalf:Int = 180 / Int(self.angularSpacing)
        //var lastIndex = -1
        
        for i in 0 ..< self.cellCount{
            let itemFrame = self.getRectForItem(i)
            
            if(rect.intersects(itemFrame) && i > (-1 * Int(self.offset) - maxVisiblesHalf) && i < (-1 * Int(self.offset) + maxVisiblesHalf)){
                
                let indexPath = IndexPath(item: i, section: 0)
                let theAttributes = self.layoutAttributesForItem(at: indexPath)
                theLayoutAttributes.append(theAttributes!)
                //lastIndex = i;
            }
        }
        
        return theLayoutAttributes;
    }
    
    
     //Magnetic effect
     override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if(shouldSnap){
            if(scrollDirection == .vertical){
                let index = Int(floor(proposedContentOffset.y / self.itemHeight))
                let off = (Int(proposedContentOffset.y) % Int(self.itemHeight))
                
                let height = Int(self.itemHeight)
                
                var targetY = index * height
                if( off > Int((self.itemHeight * 0.5)) && index <= self.cellCount ){
                    targetY = (index+1) * height
                }
                
                return CGPoint(x: proposedContentOffset.x, y: CGFloat(targetY))
            }else{
                let index = Int(floor(proposedContentOffset.x / self.itemHeight))
                let off = (Int(proposedContentOffset.x) % Int(self.itemHeight))
                
                let height = Int(self.itemHeight)
                
                var targetX = index * height
                if( off > Int((self.itemHeight * 0.5)) && index <= self.cellCount ){
                    targetX = (index+1) * height
                }
                
                return CGPoint(x: CGFloat(targetX), y: proposedContentOffset.y)
            }
        }else{
            return proposedContentOffset;
        }
    }
    
    
    override func targetIndexPath(forInteractivelyMovingItem previousIndexPath: IndexPath, withPosition position: CGPoint) -> IndexPath {
        return IndexPath(item: 0, section: 0)
    }
    
    override var collectionViewContentSize : CGSize {
        if scrollDirection == .vertical{
            return CGSize(width: self.collectionView!.bounds.size.width, height: CGFloat(self.cellCount-1) * self.itemHeight + self.collectionView!.bounds.size.height)
        }
        
        return CGSize(width: self.collectionView!.bounds.size.width + CGFloat(self.cellCount-1) * self.itemHeight, height: self.collectionView!.bounds.size.height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if(scrollDirection == .vertical){
            return layoutAttributesForVerticalScrollForItem(at:indexPath)
        }
        
        return layoutAttributesForHorizontalScrollForItem(at:indexPath)
    }
    func layoutAttributesForVerticalScrollForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        let newIndex = CGFloat(indexPath.item) + self.offset
        
        let theAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        theAttributes.size = self.cellSize
        
        var scaleFactor:CGFloat
        var deltaX:CGFloat = 0
        var translationT:CGAffineTransform
        
        
        let rotationValue = self.angularSpacing * newIndex * CGFloat(Double.pi/180)
        var rotationT = CGAffineTransform(rotationAngle: rotationValue)
        
        if(shouldFlip){
            rotationT = CGAffineTransform(rotationAngle: -rotationValue)
        }
        
        if( self.wheelType == .left){
            scaleFactor = fmax(0.6, 1 - fabs( CGFloat(newIndex) * 0.25))
            let newFrame = self.getRectForItem(indexPath.item)
            theAttributes.frame = CGRect(x: newFrame.origin.x , y: newFrame.origin.y, width: newFrame.size.width, height: newFrame.size.height)
            
            translationT = CGAffineTransform(translationX: 0 , y: 0)
        }else  {
            scaleFactor = fmax(0.4, 1 - fabs( CGFloat(newIndex) * 0.50))
            deltaX =  self.collectionView!.bounds.size.width / 2
            
            if(shouldFlip){
                theAttributes.center = CGPoint( x: self.collectionView!.frame.size.width + self.dialRadius - self.viewOffset , y: self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y)
                
                translationT = CGAffineTransform( translationX: -1 * (self.dialRadius  + ((1 - scaleFactor) * -30)) , y: 0)
                print("should Flip ")
            }else{
                theAttributes.center = CGPoint(x: -self.dialRadius + self.viewOffset , y: self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y);
                translationT = CGAffineTransform(translationX: self.dialRadius  + ((1 - scaleFactor) * -30) , y: 0);
                print("should not Flip ")
            }
        }
        print(deltaX)
        let scaleT:CGAffineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        theAttributes.alpha = scaleFactor
        theAttributes.isHidden = false
        
        theAttributes.transform = scaleT.concatenating(translationT.concatenating(rotationT))
        
        return theAttributes
    }
    
    func layoutAttributesForHorizontalScrollForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes?{
        let newIndex = CGFloat(indexPath.item) + self.offset
        
        let theAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        theAttributes.size = self.cellSize
        
        var scaleFactor:CGFloat
        var deltaX:CGFloat = 0
        var translationT:CGAffineTransform
        
        
        let rotationValue = self.angularSpacing * newIndex * CGFloat(Double.pi/180)
        var rotationT = CGAffineTransform(rotationAngle: rotationValue)
        
        if(shouldFlip){
            rotationT = CGAffineTransform(rotationAngle: -rotationValue)
        }
        
        if( self.wheelType == .left){
            scaleFactor = fmax(0.6, 1 - fabs( CGFloat(newIndex) * 0.25))
            let newFrame = self.getRectForItem(indexPath.item)
            theAttributes.frame = CGRect(x: newFrame.origin.x , y: newFrame.origin.y, width: newFrame.size.width, height: newFrame.size.height)
            
            translationT = CGAffineTransform(translationX: 0 , y: 0)
        }else  {
            scaleFactor = fmax(0.4, 1 - fabs( CGFloat(newIndex) * 0.50))
            deltaX =  self.collectionView!.bounds.size.width / 2
            
            if(shouldFlip){
                theAttributes.center = CGPoint( x: self.collectionView!.frame.size.width + self.dialRadius - self.viewOffset , y: self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y)
                
                translationT = CGAffineTransform( translationX: -1 * (self.dialRadius  + ((1 - scaleFactor) * -30)) , y: 0)
                print("should Flip ")
            }else{
                theAttributes.center = CGPoint(x: -self.dialRadius + self.viewOffset , y: self.collectionView!.bounds.size.height/2 + self.collectionView!.contentOffset.y);
                translationT = CGAffineTransform(translationX: self.dialRadius  + ((1 - scaleFactor) * -30) , y: 0);
                print("should not Flip ")
            }
        }
        print(deltaX)
        let scaleT:CGAffineTransform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        theAttributes.alpha = scaleFactor
        theAttributes.isHidden = false
        
        theAttributes.transform = scaleT.concatenating(translationT.concatenating(rotationT))
 
        return theAttributes
    }
}


