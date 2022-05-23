//
//  NotifcationListTableViewCell.swift
//  Pharmacy
//
//  Created by taha hussein on 19/05/2022.
//

import UIKit
import SDWebImage
import RxCocoa
import RxRelay
import RxSwift
class NotifcationListTableViewCell: UITableViewCell {

    @IBOutlet weak var notificationReadButton: UIButton!
    @IBOutlet weak var notificationDelete: UIButton!
    @IBOutlet weak var notificationAvatart: UIImageView!
    @IBOutlet weak var notificationTime: UILabel!
    @IBOutlet weak var notificationDes: UILabel!
    @IBOutlet weak var notificationName: UILabel!
    @IBOutlet weak var notificationtitle: UILabel!
    
    var bag = DisposeBag()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
     
    }
    
    func intializeLabelHeigh(){
        notificationDes.sizeToFit()
        notificationTime.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
 
    
    func setData(notification:MotificaitonListMessage) {
        intializeLabelHeigh()
        self.notificationName.text = notification.fromUserName
        self.notificationtitle.text = notification.notificationTitle
        self.notificationDes.text = notification.notificationDetailsMessage
        if let convertedDate = convertDateFormat(inputDate: notification.notificationDate ?? "")as? String {
            notificationTime.text = convertedDate
        }
        if let url = URL(string: baseURLImage + (notification.fromUserImageURL?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")) {
            self.notificationAvatart.sd_setImage(with: url)
        }
        
        if (notification.isRead == true) {
            notificationReadButton.setImage(UIImage(named:"ic_read"), for: .normal)
        } else {
            notificationReadButton.setImage(UIImage(named:"ic_unread"), for: .normal)

        }
    }
}
