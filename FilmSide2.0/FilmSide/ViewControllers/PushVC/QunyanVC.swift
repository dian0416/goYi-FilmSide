//
//  QunyanVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/5/14.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya
import HandyJSON

class QunyanVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ControlDelegate {
    var model:RoleModel? {
        didSet{
            if model?.byTime != nil {
                dateStr = "\(model!.byTime!/1000)".stringFormartDate(formart: "yyyy-MM-dd HH:mm:ss")
            }
            if model?.personCount != nil {
                count = model!.personCount!
            }
            if model?.city != nil {
                cityStr = model!.city
            }
            self.childTabelView.reloadData()
        }
    }
    private let identifierWrite = "write"
    private lazy var childTabelView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviViewH), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableViewDefault()
        tableView.bounces = false
        
        return tableView
    }()
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: NaviViewH-150, width: AppWidth, height: 150))
        picker.backgroundColor = UIColor.white
        picker.datePickerMode = .dateAndTime
        picker.alpha = 0
        
        return picker
    }()
    private lazy var toolBar:UIToolbar = {
        let tool = UIToolbar(frame: CGRect(x: 0, y: NaviViewH-190, width: AppWidth, height: 40))
        tool.backgroundColor = UIColor.gray
        tool.alpha = 0
        
        let commitBar = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(sureClick))
        commitBar.tintColor = skinColor
        let cancelBar = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelClick))
        cancelBar.tintColor = UIColor.black
        
        let nullBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        tool.items = [cancelBar, nullBar, commitBar]
        
        return tool
    }()
    lazy var citys: [(id:Int, name:String)] = {
        var sss = [(id: Int, name:String)]()
        let c1 = ["北京市", "天津市", "河北省", "山西", "内蒙古自治区"]
        for i in 11..<16 {
            sss.append((i, c1[i-11]))
        }
        let c2 = ["辽宁省", "吉林省", "黑龙江省"]
        for i in 21..<24 {
            sss.append((i, c2[i-21]))
        }
        let c3 = ["上海市", "江苏省", "浙江省", "安徽省", "福建省", "江西省", "山东省"]
        for i in 31..<38 {
            sss.append((i, c3[i-31]))
        }
        let c4 = ["河南省", "湖北省", "湖南省", "广东省", "广西壮族自治区", "海南省"]
        for i in 41..<47 {
            sss.append((i, c4[i-41]))
        }
        let c5 = ["重庆市", "四川省", "贵州省", "云南省", "西藏自治区"]
        for i in 50..<55 {
            sss.append((i, c5[i-50]))
        }
        let c6 = ["陕西省", "甘肃省", "青海省", "宁夏回族自治区", "新疆维吾尔自治区"]
        for i in 61..<66 {
            sss.append((i, c6[i-61]))
        }
        sss.append((71, "台湾省"))
        
        return sss
    }()
    private lazy var picker: UIPickerView = {[unowned self] in
        let picker = UIPickerView(frame: CGRect(x: 0, y: NaviViewH-150, width: AppWidth, height: 150))
        picker.backgroundColor = UIColor.white
        picker.alpha = 0
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    var cityStr:String?
    var scity = [(id:Int?, name:String?)]()
    var msgID:Int?
    var dateStr:String?
    var sid:Int?
    var cid:Int?
    var count:Int = 0
    var selectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(childTabelView)
        self.view.addSubview(toolBar)
        self.view.addSubview(datePicker)
        self.view.addSubview(picker)
        self.childTabelView.register(UINib(nibName: "WriteInfoCell", bundle: nil), forCellReuseIdentifier: identifierWrite)
        _ = addRightItem(title: "提交",color: skinColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rightClick() {
        self.cancelClick()
        self.hideKeyboard()
        if dateStr == nil {
            self.textHUD("请选择日期")
            return
        }
        if cityStr == nil {
            self.textHUD("请输入拍摄地")
            return
        }
        
        var params = [String:Any]()
        params["date"] = dateStr
        params["personCount"] = count
        params["city"] = cityStr
        if model != nil {
            params["messageId"] = msgID
            params["id"] = model?.id
            submitInfo(params: params)
        } else {
            params["messageId"] = msgID
            addInfo(params: params)
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierWrite) as? WriteInfoCell
        cell?.publicDelegate = self
        cell?.separatorZero()
        cell?.indexPath = indexPath
        cell?.accessoryType = .none
        if cell?.descLabel != nil {
            cell?.descLabel.removeFromSuperview()
        }
        
        if row == 0 {
            cell?.texitField.isUserInteractionEnabled = false
            cell?.titleLabel.text = "线位*"
            cell?.texitField.text = "群演"
        } else if row == 1 {
            cell?.texitField.isUserInteractionEnabled = false
            cell?.titleLabel.text = "日期*"
            cell?.texitField.text = "点击选择"
            cell?.texitField.text = dateStr
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.texitField.isUserInteractionEnabled = true
            cell?.titleLabel.text = row == 2 ? "拍摄地*" : "人数*"
            cell?.texitField.placeholder = row == 2 ? "请输入拍摄地" : "请输入群演人数"
            if row == 2 {
                cell?.texitField.text = cityStr
                cell?.texitField.keyboardType = .default
            } else {
                cell?.texitField.text = "\(count)"
                cell?.texitField.keyboardType = .numberPad
            }
        }
        let width = cell!.titleLabel.text!.sizeString(font: UIFont.systemFont(ofSize: 15), maxWidth: 150).width
        cell?.titleWidth.constant = width+5

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == 1 {
            toolBar.alpha = 1
            datePicker.alpha = 1
        }
//        else if row == 2 {
//            selectedIndex = 0
//            picker.alpha = 1
//            toolBar.alpha = 1
//            picker.reloadAllComponents()
//        }
    }
    
    //确认选中
    func sureClick(){
        if datePicker.alpha == 1 {
            let date = datePicker.date
            let formart = DateFormatter()
            
            formart.dateFormat = "yyyy-MM-dd HH:mm"
            dateStr = formart.string(from: date)
            childTabelView.reloadData()
            cancelClick()
        } else if selectedIndex == 0 {
            let index = picker.selectedRow(inComponent: 0)
            cid = citys[index].id
            cityStr = citys[index].name
            cancelClick()
            getCity()
        } else {
            let index = picker.selectedRow(inComponent: 0)
            sid = scity[index].id
            cityStr = scity[index].name
            cancelClick()
            self.childTabelView.reloadData()
        }
    }
    
    //取消选择
    func cancelClick(){
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker.alpha = 0
            self.toolBar.alpha = 0
            self.picker.alpha = 0
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedIndex == 0 {
            return citys.count
        } else {
            return scity.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedIndex == 0 {
            return citys[row].name
        } else {
            return scity[row].name
        }
    }
    
    func dataHandler(type: Any?, data: Any?) {
        let tmp = type as? IndexPath
        
        if tmp?.row == 3 {
            let tdata = data as? String
            if tdata?.length() > 0 {
                count = Int(tdata!)!
            }
        } else if tmp?.row == 2 {
            let tdata = data as? String
            if tdata?.length() > 0 {
                cityStr = tdata
            }
        }
    }
    
    //修改群演
    func submitInfo(params: [String : Any]) {
        loadHUD()
        
        MoyaProvider<User>().request(.updateSwarm(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        self.hideHUD()
                        NotificationCenter.default.post(name: NSNotification.Name("ROLE"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else if let msg = status.msg {
                        self.textHUD(msg)
                    } else {
                        self.textHUD("网络错误, 请稍后重试")
                    }
                } else {
                    self.textHUD("网络错误, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    //添加群演
    func addInfo(params: [String : Any]) {
        
        loadHUD()
        
        MoyaProvider<User>().request(.addSwarm(params: params)) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let status = StatusModel.deserialize(from: value) {
                    if status.status == 0 {
                        self.hideHUD()
                        NotificationCenter.default.post(name: NSNotification.Name("ROLE"), object: nil)
                        self.navigationController?.popViewController(animated: true)
                    } else if let msg = status.msg {
                        self.textHUD(msg)
                    } else {
                        self.textHUD("网络错误, 请稍后重试")
                    }
                } else {
                    self.textHUD("网络错误, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    //获取城市
    func getCity() {
        
        loadHUD()
        
        MoyaProvider<User>().request(.getCity(params: ["code": cid!])) { resp in
            do {
                let response = try? resp.dematerialize()
                let value = try response?.mapString()
                if let city = [CityModel].deserialize(from: value) {
                    self.hideHUD()
                    if city.count > 0 {
                        for cy in city {
                            self.scity.append((cy?.id, cy?.name))
                        }
                        if city.count > 0 {
                            self.selectedIndex = 1
                            self.picker.alpha = 1
                            self.toolBar.alpha = 1
                            self.picker.reloadAllComponents()
                        }
                    } else {
                        self.textHUD("网络错误, 请稍后重试")
                    }
                } else {
                    self.textHUD("网络错误, 请稍后重试")
                }
            } catch {
                let printableError = error as CustomStringConvertible
                self.textHUD(printableError.description)
            }
        }
    }
    
    

}

class CityModel:HandyJSON {
    var id:Int?
    var name:String?
    var code:Int?
    
    required init() {
        
    }
}
