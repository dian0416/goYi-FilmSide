//
//  RoleVC.swift
//  FilmSide
//
//  Created by 米翊米 on 2017/5/13.
//  Copyright © 2017年 🐨🐨🐨. All rights reserved.
//

import UIKit
import Moya

class RoleVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ControlDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var sourceType = 0
    private let identifierWrite = "write"
    private let identifierButton = "button"
    private let identifierText = "text"
    private let identifierTwo = "two"
    private let identifierRange = "range"
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(x: 0, y: NaviViewH-150, width: AppWidth, height: 150))
        picker.backgroundColor = UIColor.white
        picker.datePickerMode = .date
        picker.alpha = 0
        
        return picker
    }()
    private lazy var childTabelView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: AppWidth, height: NaviViewH), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableViewDefault()
        tableView.bounces = false
        
        return tableView
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
    private lazy var actorArray: [(key:String, value:String?)] = {
        let titles = ["角色名*:", "线位*:", "性别*:", "年龄*:", "身高(cm)*:", "体重(kg)*:", "角色标签*:", "人物小传*:"]
        var tups = [(key:String, value:String?)]()
        for title in titles {
            tups.append((title, ""))
        }
        return tups
    }()
    private lazy var tagArray:[(key:String?, value:String?)] = {
        return [(key:String?, value:String?)]()
    }()
    lazy var lines: [String] = {
        return ["角色", "特约", "前特", "群演"]
    }()
    var sex:Int = -1
    var line:Int = 0
    var ageLow:Int = 0
    var ageHigh:Int = 0
    var weightLow:Int = 0
    var weightHigh:Int = 0
    var heightLow:Int = 0
    var heightHigh:Int = 0
    var desc:String?
    var model:RoleModel? {
        didSet{
            self.actorArray[0].value = model?.roleName
            if let linet = model?.lineId {
                line = linet
                self.actorArray[1].value = lines[line-1]
            }
            if let sext = model?.sex {
                sex = sext
                self.actorArray[2].value = sex == 0 ? "女":"男"
            }
            
            if let city = model?.city {
                self.actorArray[3].value = city
            }
            
            if model?.lineId == 2 || model?.lineId == 3 {
                actorArray.insert(("拍摄地*:", model?.city), at: 3)
            }
            
            if let age = model?.ageLow {
                ageLow = age
            }
            
            if let age = model?.ageHigh {
                ageHigh = age
            }
            
            if let wlow = model?.weightLow {
                weightLow = wlow
            }
            
            if let high = model?.weightHigh {
                weightHigh = high
            }
    
            
            if let wlow = model?.heightLow {
                heightLow = wlow
            }
            
            if let high = model?.heightHigh {
                heightHigh = high
            }
            
            if let label = model?.labelName1 {
                if label.length() > 0 {
                    tagArray.append(("", label))
                }
            }
            if let label = model?.labelName2 {
                if label.length() > 0 {
                    tagArray.append(("", label))
                }
            }
            desc = model?.biography
            
            self.childTabelView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //去除多余分割线
        self.view.addSubview(childTabelView)
        self.view.addSubview(toolBar)
        self.view.addSubview(picker)
        self.childTabelView.tableFooterView = UIView()
        self.childTabelView.register(UINib(nibName: "WriteInfoCell", bundle: nil), forCellReuseIdentifier: identifierWrite)
        self.childTabelView.register(UINib(nibName: "RangeViewCell", bundle: nil), forCellReuseIdentifier: identifierRange)
        self.childTabelView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: identifierButton)
        self.childTabelView.register(UINib(nibName: "DescTextCell", bundle: nil), forCellReuseIdentifier: identifierText)
        self.childTabelView.register(UINib(nibName: "TwoTextFieldCell", bundle: nil), forCellReuseIdentifier: identifierTwo)
        _ = addRightItem(title: "提交",color: skinColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func rightClick() {
        self.hideKeyboard()
        self.cancelClick()
        if actorArray[0].value == nil || actorArray[0].value!.length() == 0 {
            self.textHUD("请输入角色名称")
            return
        }
        if line == 0 {
            self.textHUD("请选择线位")
            return
        }
        if sex == -1 {
            self.textHUD("请选择性别")
            return
        }
        if actorArray[3].value == nil && (model?.lineId == 2 || model?.lineId == 3) {
            self.textHUD("请选择拍摄地")
            return
        }
        if tagArray.count == 0 {
            self.textHUD("请输入个性标签")
            return
        }
        if desc == nil || desc!.length() == 0 {
            self.textHUD("请输入人物小传")
            return
        }
        
        var params = [String:Any]()
        params["lineId"] = line
        params["roleName"] = actorArray[0].value
        params["ageLow"] = ageLow
        params["ageHigh"] = ageHigh
        params["sex"] = sex
        if model?.lineId == 2 || model?.lineId == 3 {
            params["city"] = actorArray[3].value
        }
        params["labelName1"] = tagArray[0].value
        if tagArray.count > 1 {
            params["labelName2"] = tagArray[1].value
        }
        params["heightLow"] = heightLow
        params["heightHigh"] = heightHigh
        params["weightLow"] = weightLow
        params["weightHigh"] = weightHigh
        params["biography"] = desc
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
        return actorArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        var index:Int = 3
        if self.line == 2 || self.line == 3 {
            index = 4
        }
        if row < index {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierWrite) as? WriteInfoCell
            cell?.separatorZero()
            cell?.publicDelegate = self
            cell?.indexPath = indexPath
            cell?.titleLabel.text = actorArray[row].key
            let width = cell!.titleLabel.text!.sizeString(font: UIFont.systemFont(ofSize: 15), maxWidth: 150).width
            cell?.titleWidth.constant = width+5
            cell?.accessoryType = .none
            if cell?.descLabel != nil {
                cell?.descLabel.removeFromSuperview()
            }
            cell?.detailTextLabel?.text = nil
            if row == 0 {
                cell?.texitField.placeholder = "请输入角色名称"
                cell?.texitField.text = actorArray[row].value
            }
//            else if (line == 2 || line == 3) && row == index-1 {
//                cell?.texitField.placeholder = "请输入拍摄地址"
//                cell?.texitField.text = actorArray[row].value
//            }
            else {
                cell?.texitField.isUserInteractionEnabled = false
                cell?.accessoryType = .disclosureIndicator
                if actorArray[row].value?.length() > 0 {
                    cell?.texitField.text = actorArray[row].value
                } else {
                    cell?.texitField.text = "点击选择"
                }
            }
            
            return cell!
        } else if row < index+3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierRange) as? RangeViewCell
            cell?.titleLabel.text = actorArray[row].key
            cell?.separatorZero()
            cell?.publicDelegate = self
            cell?.leftField.keyboardType = .numberPad
            cell?.rightField.keyboardType = .numberPad
            if line == 2 || line == 3 {
                cell?.addIndex = 1
            } else {
                cell?.addIndex = 0
            }
            cell?.indexPath = indexPath
            if row == index {
                cell?.leftField.text = "\(ageLow)"
                cell?.rightField.text = "\(ageHigh)"
            } else if row == index+1 {
                cell?.leftField.text = "\(heightLow)"
                cell?.rightField.text = "\(heightHigh)"
            } else if row == index+2 {
                cell?.leftField.text = "\(weightLow)"
                cell?.rightField.text = "\(weightHigh)"
            }

            return cell!
        } else if row == index+3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierTwo) as? TwoTextFieldCell
            cell?.publicDelegate = self
            cell?.indexPath = indexPath
            
            if tagArray.count > 1 {
                cell?.rightField.text = tagArray[1].value
            }
            if tagArray.count > 0 {
                cell?.leftFiled.text = tagArray[0].value
            }
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifierText) as? DescTextCell
            cell?.publicDelegate = self
            cell?.titleLabel.text = actorArray[row].key
            cell?.textView.text = desc
            cell?.textView.setContentOffset(CGPoint(x:0, y:0), animated: true)
            if cell?.descLabel != nil {
               cell?.descLabel.removeFromSuperview()
            }
            
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row == 1 {
            let sheetVC = UIAlertController(title: "选择线位", message: nil, preferredStyle: .actionSheet)
            for line in lines {
                sheetVC.addAction(UIAlertAction(title: line, style: .default, handler: { (action) in
                    self.line = self.lines.index(of: action.title!)!+1
                    self.actorArray[1].value = self.lines[self.line-1]
                    if self.line == 2 || self.line == 3 {
                        if self.actorArray[3].key.hasPrefix("拍摄地*:") {
                            self.childTabelView.reloadData()
                            return
                        }
                        self.actorArray.insert(("拍摄地*:", ""), at: 3)
                    } else {
                        if self.actorArray[3].key.hasPrefix("拍摄地*:") {
                            self.actorArray.remove(at: 3)
                        }
                    }
                    self.childTabelView.reloadData()
                }))
            }
            sheetVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(sheetVC, animated: true, completion: nil)
        } else if row == 2 {
            let sheetVC = UIAlertController(title: "选择性别", message: nil, preferredStyle: .actionSheet)
            sheetVC.addAction(UIAlertAction(title: "女", style: .default, handler: { (action) in
                self.sex = 0
                self.actorArray[2].value = "女"
                self.childTabelView.reloadData()
            }))
            sheetVC.addAction(UIAlertAction(title: "男", style: .default, handler: { (action) in
                self.sex = 1
                self.actorArray[2].value = "男"
                self.childTabelView.reloadData()
            }))
            sheetVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(sheetVC, animated: true, completion: nil)
        } else if row == 3 && (self.line == 2 || self.line == 3) {
            selectedIndex = 0
            picker.alpha = 1
            toolBar.alpha = 1
            picker.reloadAllComponents()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == actorArray.count-1 {
            return 150
        }
        
        return 50
    }
    
    //确认选中
    func sureClick(){
        if datePicker.alpha == 1 {
            let date = datePicker.date
            let formart = DateFormatter()
            
            formart.dateFormat = "yyyy-MM-dd"
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
            actorArray[3].value = cityStr
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
        
        if let row = tmp?.row {
            var index:Int = 3
            if self.line == 2 || self.line == 3 {
                index = 4
            }
            if row < index {
                actorArray[row].value = data as? String
            } else if row < index+3 {
                if row == index {
                    let tdata = data as? (Int, String)
                    if tdata?.0 == 0 {
                        ageLow = Int(tdata!.1)!
                    } else {
                        ageHigh = Int(tdata!.1)!
                    }
                }
                if row == index+1 {
                    let tdata = data as? (Int, String)
                    if tdata?.0 == 0 {
                        heightLow = Int(tdata!.1)!
                    } else {
                        heightHigh = Int(tdata!.1)!
                    }
                }
                if row == index+2 {
                    let tdata = data as? (Int, String)
                    if tdata?.0 == 0 {
                        weightLow = Int(tdata!.1)!
                    } else {
                        weightHigh = Int(tdata!.1)!
                    }
                }
            } else if tmp?.row == index+3 {
                let tdata = data as? (Int, String)
                if tdata?.0 == 0 {
                    if tagArray.count > 0 {
                        tagArray[0].value = tdata?.1
                    } else {
                        tagArray.append(("", tdata?.1))
                    }
                } else {
                    if tagArray.count > 1 {
                        tagArray[1].value = tdata?.1
                    } else if tagArray.count > 0 {
                        tagArray.append(("", tdata?.1))
                    } else {
                        tagArray.append(("", nil))
                        tagArray.append(("", tdata?.1))
                    }
                }
            }
        } else {
            desc = data as? String
        }
    }
    
    //修改角色
    func submitInfo(params: [String : Any]) {
        loadHUD()
        
        MoyaProvider<User>().request(.updateRole(params: params)) { resp in
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
    
    //添加角色
    func addInfo(params: [String : Any]) {
        
        loadHUD()
        
        MoyaProvider<User>().request(.addRole(params: params)) { resp in
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
