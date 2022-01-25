//
//  DashboardViewController.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import UIKit
import Koyomi
import DropDown

class DashboardViewController: BaseViewController, KoyomiDelegate {
    
    @IBOutlet weak var basicBarChart: BarChartView!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var dailyTotalOrders: UITextField!
    
    @IBOutlet fileprivate weak var koyomi: Koyomi! {
        didSet {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                koyomi.circularViewDiameter = 0.6
            case .pad:
                koyomi.circularViewDiameter = 0.2
            case .tv:
                print("tv")
            case .carPlay:
                print("carplay")
            case .unspecified:
                print("undufed")
            @unknown default:
                break
            }
            
            koyomi.calendarDelegate = self
            koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            koyomi.weeks = ("SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT")
            koyomi.dayPosition = .center
            koyomi.selectionMode = .single(style: .circle)
            
            let colors = UIColor.blue
            koyomi.selectedStyleColor = colors
           
            koyomi
                .setDayFont(fontName: "Segoe UI", size: 19)
                .setWeekFont(fontName: "Segoe UI",size: 12)
            
        }
    }
    lazy var dropDowns: DropDown = {
        return self.selectCityFromDropDown
    }()
    
   
    let selectCityFromDropDown = DropDown()
    fileprivate let invalidPeriodLength = 90
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var articleDetailsViewModel = DashboardViewModel()
    private var router = DashboardRouter()
    private let numEntry = 20
    private var dailyOrdersBranches = [TotalDailyOrdersBranch]()
    private var brnaches = [Branch]()
    private var dailyOderSelectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        setup()
        requestDashboard()
        subscribeToLoader()
        articleDetailsViewModel.getDashboard()
        setGesturesForBrnachecs()
        subscribeToDailyOrderBranches()
        subscribeToBranches()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    func setup() {
        let currentDateString = koyomi.currentDateString(withFormat: "yyyy'-'MM'-'dd")
        segmentView.setTitle(currentDateString, forSegmentAt: 1)

    }
    
    func setGesturesForBrnachecs() {
        let country = UITapGestureRecognizer(target: self, action: #selector(self.tapDailyBranches))
        dailyTotalOrders.isUserInteractionEnabled = true
        dailyTotalOrders.addGestureRecognizer(country)
    }
    
    func subscribeToDailyOrderBranches() {
        articleDetailsViewModel.dailyTotalOrders.subscribe {[weak self] dailyOrders in
            self?.dailyOrdersBranches = dailyOrders.element!
        }.disposed(by: self.disposeBag)
    }
    
    func subscribeToBranches() {
        articleDetailsViewModel.branchesObject.subscribe {[weak self] branchs in
            DispatchQueue.main.async{
            self?.brnaches = branchs.element!
                let values = [Double(self?.brnaches[0].branchID ?? 0)]
            
                self?.basicBarChart.drawChart(values)
      
            }
        }.disposed(by: self.disposeBag)
    }
    
    func subscribeToLoader() {
        articleDetailsViewModel.state.isLoading.subscribe(onNext: {[weak self] (isLoading) in
            DispatchQueue.main.async {
                if isLoading {
                    
                    self?.showLoading()
                    
                } else {
                    self?.hideLoading()
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    func requestDashboard() {
        articleDetailsViewModel.dashBoard.subscribe {[weak self] dashboard in
            DispatchQueue.main.async{
            let element = dashboard.element?.message
            if let url = URL(string: baseURLImage + (element?.profileImage ?? "")) {
                self?.ownerImage.load(url: url)
            }
            self?.ownerName.text = element?.employeeName
            }
        }.disposed(by: self.disposeBag)


    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        let month: MonthType = {
            switch sender.selectedSegmentIndex {
            case 0:  return .previous
            case 1:  return .current
            default: return .next
            }
        }()
        koyomi.display(in: month)
    }
    
    func configureStyle(_ style: KoyomiStyle) {
        koyomi.style = style
        koyomi.reloadData()
    }
}
extension DashboardViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
    }
}
extension DashboardViewController {
    
    func koyomi(_ koyomi: Koyomi, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        print("You Selected: \(String(describing: date))")
        
        let dates = date?.stringFromFormat("yyyy'-'MM'-'dd")
        
        // here store date in array
        segmentView.setTitle(dates, forSegmentAt: 1)
        
        // end store date
    }

    func koyomi(_ koyomi: Koyomi, deSelect date: Date?, forItemAt indexPath: IndexPath) {
        print("You Deselected: \(String(describing: date))")
    }
    
    @objc(koyomi:shouldSelectDates:to:withPeriodLength:)
    func koyomi(_ koyomi: Koyomi, shouldSelectDates date: Date?, to toDate: Date?, withPeriodLength length: Int) -> Bool {
        if length > invalidPeriodLength {
            print("More than \(invalidPeriodLength) days are invalid period.")
            return false
        }
        return true
    }
}

extension DashboardViewController {
    @objc
    func tapDailyBranches(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = dailyTotalOrders
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        let country = dailyOrdersBranches.map({($0.branchName ?? "") })
        let countryIds = dailyOrdersBranches.map({($0.branchID ?? 0) })
        self.selectCityFromDropDown.dataSource = country
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.dailyTotalOrders.text = item
            self?.dailyOderSelectedIndex = countryIds[index]
            
        }
        
    }
}
