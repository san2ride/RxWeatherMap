//
//  WeatherController.swift
//  RxWeather
//
//  Created by Jason Sanchez on 7/11/19.
//  Copyright © 2019 Jason Sanchez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityNameTextField.rx.controlEvent(.editingDidEndOnExit)
        .asObservable()
            .map { self.cityNameTextField.text }
            .subscribe(onNext: { city in
                
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    } else {
                        self.fetchWeather(by: city)
                    }
                }
            })
            .disposed(by: bag)
    }
    
    private func fetchWeather(by city: String) {
        
        guard let cityEncoded =
            city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
            let url = URL.urlForWeatherAPI(city: cityEncoded) else {
                return
        }
        
        let resource = Resource<WeatherResult>(url: url)
        /*
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: WeatherResult.empty)
        */
        
        let search = URLRequest.load(resource: resource)
        .observeOn(MainScheduler.instance)
            .retry(3)
            .catchError { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp) ℉" }
        .drive(self.temperatureLabel.rx.text)
        .disposed(by: bag)
        
        search.map { "\($0.main.humidity) 💦" }
        .drive(self.humidityLabel.rx.text)
        .disposed(by: bag)
    }
    
    private func displayWeather(_ weather: Weather?) {
        
        if let weather = weather {
            self.temperatureLabel.text = "\(weather.temp) ℉"
            self.humidityLabel.text = "\(weather.humidity) 💦"
        } else {
            self.temperatureLabel.text = "🤬"
            self.humidityLabel.text = "🚫"
        }
    }
}
