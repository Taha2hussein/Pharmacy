//
//  DashboardViewController.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import UIKit
import DropDown
import SDWebImage
class DashboardViewController: BaseViewController {
    
    @IBOutlet weak var ordersCount: UILabel!
    @IBOutlet weak var linearProgressView: MultiProgressView!
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var lastMonthLabel: UILabel!
    @IBOutlet weak var last7DaysLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var chooseDateHeight: NSLayoutConstraint!
    @IBOutlet weak var chooseDateToogleButton: UIButton!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var monthSelected: UITextField!
    @IBOutlet weak var yearSelected: UITextField!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var dailyTotalOrders: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var goButtons: UIButton!
    @IBOutlet weak var customDateStackView: UIStackView!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var fromDateButton: UIButton!
    @IBOutlet weak var dateCustomButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var lasT7DaysButton: UIButton!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var dailyTotalOrderCollectionView: UICollectionView!
    
    let radioController: RadioButtonController = RadioButtonController()
    lazy var dropDowns: DropDown = {
        return self.selectCityFromDropDown
    }()
    
   let year = ["2022","2023","2024","2025","2026","2027","2028","2029","2030"]
   let month = ["1","2","3","4","5","6","7","8","9","10","11","12"]

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
    
    private var startDate: String?
    private var endDate: String?
    private var DatePickers = DatePicker()
    
    let defaultProgress = Progress(totalUnitCount: Int64( 0))

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewControllerRouter()
        setup()
        requestDashboard()
        subscribeToLoader()
        setGesturesForBrnachecs()
        subscribeToDailyOrderBranches()
        subscribeToBranches()
        setGesturesForYear()
        setGesturesForMonth()
        requestListBrhaches()
        subscribeToDailyOrdes()
        intializeRadioButtons()
        todayButtonTapped()
        lasT7DaysButtonTapped()
        dateCustomButtonTapped()
        thisMonthButtonTapped()
        showFromDateAction()
        toogleChooseDateTapped()
        showEndDateAction()
        bindDailyTotalOrderToCollectionView()
        goButtonTapped()
        setupImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        pieChart.segments = []
        linearProgressView.progressInfo.removeAll()
        ordersCount.text = "0"
        articleDetailsViewModel.getDashboard(fromDate:startDate ?? "" , endDate:endDate ?? "")
        articleDetailsViewModel.getTotalDialyOderWithSpecificBranch(fromDate: startDate ?? "", toDate: endDate ?? "", branchId: dailyOderSelectedIndex)
    }
    
    func intializeRadioButtons() {
        getCurrentDates()
        hideCustomDateButtons()
        radioController.buttonsArray = [todayButton,lasT7DaysButton,thisMonthButton,dateCustomButton]
        radioController.defaultButton = todayButton
        changeColor_today()
    }
    
    func setupImage() {
        self.dailyTotalOrders.setRightImage(imageName: "icNext", textField: dailyTotalOrders)
    }
    
    func changeColor_today() {
        todayLabel.textColor = .blue
        last7DaysLabel.textColor = .gray
        lastMonthLabel.textColor = .gray
        customLabel.textColor = .gray
    }
    
    func changeColor_7days() {
        todayLabel.textColor = .gray
        last7DaysLabel.textColor = .blue
        lastMonthLabel.textColor = .gray
        customLabel.textColor = .gray
    }
    
    func changeColor_month() {
        todayLabel.textColor = .gray
        last7DaysLabel.textColor = .gray
        lastMonthLabel.textColor = .blue
        customLabel.textColor = .gray
    }
    
    func changeColor_custom() {
        todayLabel.textColor = .gray
        last7DaysLabel.textColor = .gray
        lastMonthLabel.textColor = .gray
        customLabel.textColor = .blue
    }
    
    func getCurrentDates() {
        endDate = getCurrentDate()
        startDate = getCurrentDate()
    }
    
    func hideCustomDateButtons() {
        goButtons.isHidden = true
        customDateStackView.isHidden = true
    }
    
    func showCustomDateButtons() {
        goButtons.isHidden = false
        customDateStackView.isHidden = false
    }
    
    func setup() {
        let padding: CGFloat = 20
        let height = (view.frame.height - padding * 3) / 2

        pieChart.frame = CGRect(
          x: 0, y: padding, width: view.frame.size.width, height: height
        )
        pieChart.segmentLabelFont = .systemFont(ofSize: 10)
    }
    
    func getDashboardDependonChoosenDate(startDate: String? , endDate: String?) {
        pieChart.segments = []
        linearProgressView.progressInfo.removeAll()
        ordersCount.text = "0"
        articleDetailsViewModel.getDashboard(fromDate:startDate ?? "" , endDate:endDate ?? "")
        articleDetailsViewModel.getTotalDialyOderWithSpecificBranch(fromDate: startDate ?? "", toDate: endDate ?? "", branchId: self.dailyOderSelectedIndex)
    }
    
    func removeLinearProgress() {
        linearProgressView.progressInfo.removeAll()
    }
    
    func todayButtonTapped() {
        todayButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.todayButton)!)
            self?.hideCustomDateButtons()
            self?.startDate = getCurrentDate()
            self?.endDate = getCurrentDate()
            self?.getDashboardDependonChoosenDate(startDate: self?.startDate, endDate:   self?.endDate)
            self?.changeColor_today()
        }.disposed(by: self.disposeBag)
        
    }
    
    func thisMonthButtonTapped() {
        thisMonthButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.thisMonthButton)!)
            self?.hideCustomDateButtons()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let lastMonthDate = Calendar.current.date(byAdding: .weekOfYear, value: -30, to: Date())!
            let last30endDate = formatter.string(from: lastMonthDate)
            self?.startDate = getCurrentDate()
            self?.endDate = last30endDate
            self?.getDashboardDependonChoosenDate(startDate:  self?.startDate, endDate: self?.endDate )
            self?.changeColor_month()
        }.disposed(by: self.disposeBag)
    }
    
    func lasT7DaysButtonTapped() {
        lasT7DaysButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.lasT7DaysButton)!)
            self?.hideCustomDateButtons()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -7, to: Date())!
            let last7days = formatter.string(from: lastWeekDate)
            self?.startDate = getCurrentDate()
            self?.endDate = last7days
            self?.getDashboardDependonChoosenDate(startDate:  self?.startDate, endDate: self?.endDate )
            self?.changeColor_7days()
        }.disposed(by: self.disposeBag)
        
    }
    
    func dateCustomButtonTapped() {
        dateCustomButton.rx.tap.subscribe {[weak self] _ in
            self?.radioController.buttonArrayUpdated(buttonSelected: (self?.dateCustomButton)!)
            self?.showCustomDateButtons()
            self?.changeColor_custom()
        }.disposed(by: self.disposeBag)
    }
    
    func showFromDateAction() {
        fromDateButton.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.fromDateButton.setTitle(date, for: .normal)
                self?.startDate = date

            })
        } .disposed(by: self.disposeBag)
    }
    
    func showEndDateAction() {
        endDateButton.rx.tap.subscribe {[weak self] _ in
            self?.DatePickers.ShowPickerView(pickerView: self!, completionHandler: { date in
                self?.endDate = date
                self?.endDateButton.setTitle(date, for: .normal)
            })
        } .disposed(by: self.disposeBag)
        
    }
    
    func goButtonTapped() {
        goButtons.rx.tap.subscribe {[weak self] _ in
//            self?.articleDetailsViewModel.getDashboard(fromDate:self!.startDate ?? "" , endDate:self!.endDate ?? "")
            self?.getDashboardDependonChoosenDate(startDate: self!.startDate , endDate: self!.endDate)
print("dsfsdf")
//      sd      self?.articleDetailsViewModel.getTotalDialyOderWithSpecificBranch(fromDate: self!.startDate ?? "", toDate: self!.endDate ?? "", branchId: self?.dailyOderSelectedIndex ?? 0)
        } .disposed(by: self.disposeBag)
    }
    
    func setGesturesForBrnachecs() {
        let country = UITapGestureRecognizer(target: self, action: #selector(self.tapDailyBranches))
        dailyTotalOrders.isUserInteractionEnabled = true
        dailyTotalOrders.addGestureRecognizer(country)
    }
    
    func setGesturesForYear() {
        let country = UITapGestureRecognizer(target: self, action: #selector(self.tapYear))
        yearSelected.isUserInteractionEnabled = true
        yearSelected.addGestureRecognizer(country)
    }
    
    func setGesturesForMonth() {
        let country = UITapGestureRecognizer(target: self, action: #selector(self.tapMonth))
        monthSelected.isUserInteractionEnabled = true
        monthSelected.addGestureRecognizer(country)
    }
    
    func subscribeToDailyOrderBranches() {
        articleDetailsViewModel.dailyBranches.subscribe {[weak self] dailyOrders in

            self?.dailyOrdersBranches = dailyOrders.element ?? []
        }.disposed(by: self.disposeBag)
    }
    
    //dailyTotalOrders
    func subscribeToDailyOrdes() {
        articleDetailsViewModel.dailyTotalOrders.subscribe {[weak self]  dailyOrders in
            DispatchQueue.main.async {
                
              if let totalOrders = dailyOrders.element {
            for item in totalOrders{
                var chartColor: UIColor = .clear
                if item.type == "جديد" {
                    chartColor = .blue
                }
                if item.type == "في الانتظار" {
                    chartColor = .yellow
                }
                if item.type == "الغاء" {
                    chartColor = .red
                }
                if item.type == "تم التسليم" {
                    chartColor = .green
                }
                if item.type == "لم يحضر للتسليم" {
                    chartColor = .gray
                }
                
                let chart =  LabelledSegment(color: chartColor, name:  "",   value: CGFloat(item.total ?? 0))
                self?.pieChart.segments.append(chart)
                let progress = Progress(totalUnitCount: Int64(item.total ?? 0))
                self?.linearProgressView.add(progress, progressTintColor: chartColor)
                self?.ordersCount.text = "\(totalOrders.count)"
                }
              }
            }
        }.disposed(by: self.disposeBag)
    }
    
    func bindDailyTotalOrderToCollectionView() {
        articleDetailsViewModel.dailyTotalOrders
            .bind(to: self.dailyTotalOrderCollectionView
                .rx
                .items(cellIdentifier: String(describing:  DailyTotalOrderCollectionViewCell.self),
                       cellType: DailyTotalOrderCollectionViewCell.self)) { row, model, cell in
                cell.setData( product:model)
                
            }.disposed(by: self.disposeBag)
    }

    
    func toogleChooseDateTapped() {
        chooseDateToogleButton.rx.tap.subscribe { [weak self] _ in
            let chooseDateHeight = self?.chooseDateHeight.constant
            if chooseDateHeight == 40 {
                self?.chooseDateHeight.constant = 270
                self?.chooseDateToogleButton.setImage(UIImage(named: "icNext-1"), for: .normal)
            }
            else {
                self?.chooseDateHeight.constant = 40
                self?.chooseDateToogleButton.setImage(UIImage(named: "icNext"), for: .normal)

            }
        }.disposed(by: self.disposeBag)

    }
    
    func subscribeToBranches() {
        articleDetailsViewModel.branchesObject.subscribe {[weak self] branchs in
            DispatchQueue.main.async{
            self?.brnaches = branchs.element!
                
                let totalVlaue = self?.brnaches.map({(Double($0.ordersCount ?? 0)) })
         
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
//                self?.ownerImage.load(url: url)
                self?.ownerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "avatar"))

            }
            self?.ownerName.text = element?.employeeName
            }
        }.disposed(by: self.disposeBag)
    }
    
    func requestListBrhaches(){
        goButton.rx.tap.subscribe {[weak self] _ in
            let month = Int( self?.monthSelected.text ?? "1")
            let year = Int( self?.yearSelected.text ?? "2022")
            self?.articleDetailsViewModel.getBranchList(month: month ?? 1, year: year ?? 2022)
        } .disposed(by: self.disposeBag)
        
    }
}
extension DashboardViewController {
    func bindViewControllerRouter() {
        articleDetailsViewModel.bind(view: self, router: router)
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
            self?.pieChart.segments = []
            self?.linearProgressView.progressInfo.removeAll()
            self?.ordersCount.text = "0"
            self?.articleDetailsViewModel.getTotalDialyOderWithSpecificBranch(fromDate: self!.startDate ?? "", toDate: self!.endDate ?? "", branchId: self?.dailyOderSelectedIndex ?? 0)
        }
        
    }
    
    @objc
    func tapYear(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = yearSelected
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)

        self.selectCityFromDropDown.dataSource = year
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.yearSelected.text = item
            
        }
        
    }
    
    @objc
    func tapMonth(sender:UITapGestureRecognizer) {
        
        selectCityFromDropDown.anchorView = monthSelected
        selectCityFromDropDown.direction = .any
        selectCityFromDropDown.backgroundColor = UIColor.white
        selectCityFromDropDown.bottomOffset = CGPoint(x: 0, y:(selectCityFromDropDown.anchorView?.plainView.bounds.height)!)
        self.selectCityFromDropDown.dataSource = month
        selectCityFromDropDown.show()
        // Action triggered on selection
        
        selectCityFromDropDown.selectionAction = { [weak self] (index, item) in
            
            self?.monthSelected.text = item
            
        }
        
    }
}
