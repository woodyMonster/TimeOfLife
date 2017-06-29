//
//  detailViewController.swift
//  TimeOfLife
//
//  Created by 王志輝 on 2017/6/20.
//  Copyright © 2017年 Woody. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{


    @IBOutlet weak var placeImageView: UIImageView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var timeOfLife:TimeOfLifeMO!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 地圖設定
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(timeOfLife.address!, completionHandler: { placemarks, error in
            if error != nil {
                let alert = UIAlertController(title: "Oops.. something wrong. ", message: "please try another address.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let placemarks = placemarks {
                // 取得第一個座標
                let placemark = placemarks[0]
                // 加上標註
                let annotation = MKPointAnnotation()
                if let  location = placemark.location {
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    //  設定縮放
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
                
                
            }
        })
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        placeImageView.image = UIImage(data: timeOfLife.image! as Data)
        
        // navigation title
        title = timeOfLife.area
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.fieldLabel.text = "地區:"
            cell.valueLabel.text = timeOfLife.area
        case 1:
            cell.fieldLabel.text = "時間:"
            cell.valueLabel.text = timeOfLife.date
        case 2:
            cell.fieldLabel.text = "地址:"
            cell.valueLabel.text = timeOfLife.address
        case 3:
            cell.fieldLabel.text = "描述:"
            cell.valueLabel.text = timeOfLife.descriptions
        default:
            cell.fieldLabel.text = ""
            cell.valueLabel.text = ""
        }
        
        return cell
        
    }
    
    func showMap() {
        performSegue(withIdentifier: "showMap", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapViewController
            destinationController.timeOfLife = timeOfLife
        }
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    

}
