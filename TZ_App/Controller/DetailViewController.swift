import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    // MARK: - Base variables
    private let viewModel = DetailViewModel()
    private let bag = DisposeBag()
    
    var selectedDay: ForecastPlainModel? {
        didSet {
            viewModel.selectedDaySubject.onNext(selectedDay!)
        }
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - UI Binding
    private func bind() {
        viewModel.selectedDaySubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[unowned self] forecast in
                guard let forecast = forecast else { return }
                self.tempLabel.text = forecast.temperature
                self.weatherLabel.text = forecast.weatherDescription
                self.dateLabel.text = forecast.date
                self.pressureLabel.text = forecast.pressure
                self.humidityLabel.text = forecast.humidity
                self.weatherIcon.image = UIImage(data: forecast.weatherIconData)
            })
            .disposed(by: bag)
    }

}
