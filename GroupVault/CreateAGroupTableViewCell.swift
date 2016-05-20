//
//
//import UIKit
//
//class CreateAGroupTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var userImageView: UIImageView!
//    
//    @IBOutlet weak var usernameLabel: UILabel!
//    
//    @IBOutlet weak var selectButton: UIButton!
//    
//    var delegate: CreateAGroupTableViewCellDelegate?
//    
//    var selectedUserBooleon: Bool = false
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    @IBAction func selectButtonTapped(sender: AnyObject) {
//        if let delegate = delegate {
//            delegate.selectButtonTapped(self)
//        }
//    }
//    
//    func userSelected() {
//        selectButton.setBackgroundImage(UIImage(named: "selected"), forState: .Normal)
//    }
//    
//    func userUnselected() {
//        selectButton.setBackgroundImage(UIImage(named: "notSelected"), forState: .Normal)
//    }
//
//}
//
//protocol CreateAGroupTableViewCellDelegate: class {
//    func selectButtonTapped(sender: CreateAGroupTableViewCell)
//}