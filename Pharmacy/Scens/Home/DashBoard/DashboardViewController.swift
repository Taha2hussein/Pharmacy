//
//  DashboardViewController.swift
//  Pharmacy
//
//  Created by A on 20/01/2022.
//

import UIKit
import Koyomi

class DashboardViewController: BaseViewController, KoyomiDelegate {
    @IBOutlet weak var basicBarChart: BasicBarChart!
    @IBOutlet weak var ownerImage: UIImageView!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!

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
    
    fileprivate let invalidPeriodLength = 90
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    var articleDetailsViewModel = DashboardViewModel()
    private var router = DashboardRouter()
    private let numEntry = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleDetailsViewModel.sdf()
        bindViewControllerRouter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dataEntries = generateEmptyDataEntries()
        basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: false)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) {[unowned self] (timer) in
            let dataEntries = self.generateRandomDataEntries()
            self.basicBarChart.updateDataEntries(dataEntries: dataEntries, animated: true)
        }
        timer.fire()
    }
    
    func generateEmptyDataEntries() -> [DataEntry] {
        var result: [DataEntry] = []
        Array(0..<numEntry).forEach {_ in
            result.append(DataEntry(color: UIColor.clear, height: 0, textValue: "0", title: ""))
        }
        return result
    }
    
    func generateRandomDataEntries() -> [DataEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [DataEntry] = []
        for i in 0..<numEntry {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            result.append(DataEntry(color: colors[i % colors.count], height: height, textValue: "\(value)", title: formatter.string(from: date)))
        }
        return result
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

