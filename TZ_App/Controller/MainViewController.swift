import UIKit
import RxSwift
import RxCocoa
import MapKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Base variables
    private let bag = DisposeBag()
    private let viewModel = MainViewModel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rx.setDelegate(self).disposed(by: bag)
        setupActivityIndicator()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = CGPoint(x: view.frame.size.width*0.5, y: view.frame.size.height*0.5)
        activityIndicator.startAnimating()
    }
    
    // MARK: - UI Binding
    private func bind() {
        
        
        viewModel.loadingStatus
            .bind(to: activityIndicator.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.getForecastData()
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: ForecastCell.self)) { (row, item, cell) in
                cell.tempLabel.text = item.temperature
                cell.weatherIcon.image = UIImage(data: item.weatherIconData)
                cell.dateLabel.text = item.date
            }
            .disposed(by: bag)
        
        
    }
    
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
