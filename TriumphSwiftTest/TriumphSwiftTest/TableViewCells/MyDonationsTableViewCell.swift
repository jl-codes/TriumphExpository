import UIKit
import SDWebImage

class MyDonationsTableViewCell: UITableViewCell {
    
    // Views and labels
    var profileImageView = UIImageView()
    var nameLabel = UILabel()
    var usernameLabel = UILabel()
    var moneyLabel = UILabel()
    var timestampLabel = UILabel()
    let profileCircleSize = 43
    
    
    var donation: Donation? {
        didSet {
            self.nameLabel.text = donation?.receiverId
            self.usernameLabel.text = donation?.senderId
            if let donationAmount = donation?.amount {
                moneyLabel.text = "$\(donationAmount)0"
            }
            if let timestamp = donation?.timestamp {
                let date = Date(timeIntervalSince1970: timestamp)
                
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = TimeZone(abbreviation: "PST")
                dateFormatter.locale = NSLocale.current
                dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                dateFormatter.date(from: String(describing: date))
                
                let readableDate = dateFormatter.string(from: date)
                
                self.timestampLabel.text = String(describing: readableDate)
            }
            if let orgId = donation?.receiverId {
                Api.Organization.getOrganizationFromId(orgId: orgId, completion: {
                    organization in
                    if let photoURL = organization?.profilePhotoURL {
                        self.profileImageView.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(named: "organization.png"))
                    }
                })
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setConstraints() {
        self.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: CGFloat(profileCircleSize)).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: CGFloat(profileCircleSize)).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        self.profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = CGFloat(profileCircleSize/2)
        
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -12).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nameLabel.shadowOffset = CGSize(width: 0.1, height: 0.1)
        nameLabel.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nameLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 15).isActive = true
        usernameLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        usernameLabel.shadowOffset = CGSize(width: 0.1, height: 0.1)
        usernameLabel.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        usernameLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
        
        contentView.addSubview(moneyLabel)
        moneyLabel.translatesAutoresizingMaskIntoConstraints = false
        moneyLabel.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: 0).isActive = true
        moneyLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        moneyLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        moneyLabel.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        moneyLabel.text = ""
        
        self.addSubview(timestampLabel)
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        timestampLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor, constant: 0).isActive = true
        timestampLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        timestampLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        timestampLabel.shadowOffset = CGSize(width: 0.1, height: 0.1)
        timestampLabel.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        timestampLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setConstraints()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil
        
        let imageServerURL = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: imageServerURL) {
            URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
