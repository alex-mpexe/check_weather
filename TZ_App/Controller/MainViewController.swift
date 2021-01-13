import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Base variables
    private let bag = DisposeBag()
    private let viewModel = MainViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rx.setDelegate(self).disposed(by: bag)
        setupActivityIndicator()
        bind()
    }
    
    // MARK: - Setup Activity Indicator for loader
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5)
        activityIndicator.startAnimating()
    }
    
    // MARK: - UI Binding
    private func bind() {
        
        // Handle selected table item
        tableView.rx.modelSelected(ForecastPlainModel.self)
            .subscribe(onNext: {[unowned self] model in
                let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
                detailVC.selectedDay = model
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: bag)
        
        // Deselect row
        tableView.rx.itemSelected
            .subscribe(onNext: { [unowned self] indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: bag)
        
        // Binding for activity indicator
        viewModel.loadingStatus
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: bag)
        
        // Binding for tableView data
        viewModel.getForecastData()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: ForecastCell.self)) { (row, item, cell) in
                cell.tempLabel.text = item.temperature
                cell.weatherIcon.image = UIImage(data: item.weatherIconData)
                cell.dateLabel.text = item.date
            }
            .disposed(by: bag)
    }
    
}

// MARK: - Extension for TableView Delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
}
