//
//  ViewController.swift
//  AlamofireDemo2
//
//  Created by Farhana Khan on 25/04/21.
//

import UIKit
import Alamofire
import Kingfisher

class CityVC: UIViewController {
    
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var errBtn: UIButton!
    @IBOutlet weak var errLb: UILabel!
    @IBOutlet var errView: UIView!
    var city = NSDictionary()
    var citySort = [String]()
    var state = [String]()
    @IBOutlet weak var TV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        actInd.hidesWhenStopped = true
        alamofirePostExample()
    }
    func alamofirePostExample()  {
        let parameter = ["request":"city_listing","device_type":"ios","country":"india"]
        AF.request("https://www.kalyanmobile.com/apiv1_staging/city_listing.php",method: .post,parameters: parameter).responseJSON { (resp) in
            if let arr = resp.value as? NSDictionary{
                print("RESPONSE HERE \(arr)")
                if let respCode = arr.value(forKey: "responseCode") as? String, let respMsg = arr.value(forKey: "responseMessage") {
                    if respCode == "success" {
                        self.actInd.stopAnimating()
                        print("success")
                        if let cityArr = arr.value(forKey: "city_array") as? NSDictionary {
                            self.city = cityArr
                            self.TV.backgroundView = nil
                            self.TV.reloadData()
                        }
                        else {
                            print("Err \(respMsg)")
                        }
                    }
                    
                }
            }
            else if let err = resp.error {
                self.actInd.stopAnimating()
                print("Error: \(err.localizedDescription)")
                self.showError(msg: "\(err.localizedDescription)")
                //                let alert = UIAlertController(title: "Warning!", message: "Error.. retry!", preferredStyle: .alert)
                //                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                //                let Retry = UIAlertAction(title: "Retry", style: .default) { (action) in
                //                    self.alamofirePostExample()
                //                }
                //                alert.addAction(cancel)
                //                alert.addAction(Retry)
                //                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func showError(msg:String) {
        errLb.text = msg
        TV.backgroundView = errView
    }
    @IBAction func retryPress(_ sender: UIButton) {
        alamofirePostExample()
    }
}
extension CityVC:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        city.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "header") as! CustomHeader
        if section % 2 == 0 {
            header.backgroundColor = UIColor.systemOrange
        }
        else {
        header.backgroundColor = UIColor.systemGreen
        }
        let cityArr = city.allKeys
        header.cityLb.text = cityArr[section] as? String ?? ""
        
        return header
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keysArr = city.allKeys as! [String]
//        print(keysArr)
        let stateArr = keysArr[section]
//        print(stateArr)
        state = city.value(forKey: "\(stateArr)") as! [String]
        return state.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTVC
        let keysArr = city.allKeys as! [String]
        let stateArr = keysArr[indexPath.section]
        state = city.value(forKey: "\(stateArr)") as! [String]
        cell.stateLb.text = "\(state[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.1
    }
}
