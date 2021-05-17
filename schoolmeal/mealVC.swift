//
//  yesterdaymealVC.swift
//  schoolmeal
//
//  Created by 김부성 on 11/22/20.
//

import UIKit
import Alamofire
import Lottie
import SwiftyJSON

class mealVC: UITableViewController {
    var meal : [String] = []
    var menu : [String] = []
    var formatter = DateFormatter()
    
    lazy var animationview: AnimationView = {
        //로티 애니메이션을 만듬
        let loading = AnimationView(name: "loading")
        // 크기를 맞춰주고 위치를 정렬함
        loading.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        loading.center = CGPoint(x: (self.view.frame.width) / 2, y: 200)
        // 루프모드로 설정
        loading.loopMode = .loop
        // 애니메이션 속도 설정
        loading.animationSpeed = 0.5
        // 바로 실행될수 있게 설정
        loading.play()
        // 로딩 반환
        return loading }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTable(_:)), name: .updateTable, object: nil)
    }
    
    @objc func updateTable(_ notification: Notification) {
        network(todaydate: notification.object as! String)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // subview에 로딩추가
        self.view.addSubview(self.animationview)
        formatter.dateFormat = "YYYYMMdd"
        let date = formatter.string(from: Date())
        // 네트워크 실행
        network(todaydate: date)
        // 셀 선택을 막음
        self.tableView.allowsSelection = false
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return meal.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let menuName = (self.meal[section]).components(separatedBy: "<br/>")
        return menuName.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let firstcell = tableView.dequeueReusableCell(withIdentifier: "firstcell", for: indexPath) as! firstcell
            let delegate = UIApplication.shared.delegate as! AppDelegate
            firstcell.timelbl.text = delegate.sections[indexPath.section]
            return firstcell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! cell
            let menuName = (self.meal[indexPath.section]).components(separatedBy: "<br/>")
            self.menu = []
            self.menu.append(contentsOf: menuName)
            cell.menulbl.text = menu[indexPath.row - 1]
            return cell
        }
        
        // Configure the cell...
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60.0
        }
        return 44.0
    }
    
    func network(todaydate: String) {
        let request = AF.request("https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&pIndex=1&pSize=100&ATPT_OFCDC_SC_CODE=D10&SD_SCHUL_CODE=7240454&MLSV_YMD=\(todaydate)")
        request.responseJSON{ response in
            switch response.result {
            case.success(let result):
                let json = JSON(result)
                self.meal = []
                if json["RESULT"]["CODE"] == "INFO-200" {
                    for _ in 0...2 {
                        self.meal.append("급식이 없습니다.")
                    }
                }
                else {
                    let data = json["mealServiceDietInfo"].arrayValue
                    let row = data[1]["row"]
                    for index in 0...2 {
                        self.meal.append(row[index]["DDISH_NM"].string ?? "급식이 없습니다.")
                    }
                }
                // 테이블 다시 로드
                self.tableView.reloadData()
                // lottie 중지 및 뷰에서 삭제
                self.animationview.stop()
                self.animationview.removeFromSuperview()
            case.failure(let error):
                print(error)
                let alert = UIAlertController(title: "네트워크 오류", message: "네트워크를 다시 확인해 주세요!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    @IBAction func infobtn(_ sender: Any) {
        let info = storyboard?.instantiateViewController(withIdentifier: "info")
        present(info!, animated: true)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
