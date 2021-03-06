//
//  ViewController.swift
//  AVTestApp
//
//  Created by Roshan on 1/1/18.
//  Copyright © 2018 Roshan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  private lazy var registrar = AVAPIKeyRegistrar()
  private lazy var isAdjusted = false
  fileprivate lazy var periodicityOrdering = AVHistoricalTimeSeriesPeriodicity.ordering()
  
  fileprivate var selectedPeriodicity: AVHistoricalTimeSeriesPeriodicity {
    return periodicityOrdering[periodicityPickerView.selectedRow(inComponent: 0)]
  }
  
  @IBOutlet weak var periodicityPickerView: UIPickerView!
  
  // MARK: Lifecycle
  
  required init?(coder aDecoder: NSCoder) {
    periodicityPickerView = UIPickerView()
    
    super.init(coder: aDecoder)
    if let key = registrar.getAPIKey() {
      AVAPIKeyStore.sharedInstance.setAPIKey(apiKey: key)
    }
    
  }
  
  override func loadView() {
    super.loadView()
    
    periodicityPickerView.delegate = self
    periodicityPickerView.dataSource = self
  }
  
  // MARK: Configuring behaviors
  
  @IBAction func addAPIKey(_ sender: Any) {
    registrar.requestUserInputAPIKey(forViewController: self)
  }
  
  @IBAction func getAPIKey(_ sender: Any) {
    print(registrar.getAPIKey() as Any)
  }
  
  @IBAction func setAdjustedPrices(_ adjustedSwitch: UISwitch)
  {
    isAdjusted = adjustedSwitch.isOn
  }
  
  @IBAction func fetchData()
  {
    if isAdjusted {
      print("Fetch Adjusted")
      self.fetchAdjustedPrices()
    } else {
      print("Fetch Standard")
      self.fetchStandardPrices()
    }
  }
  
  private func fetchAdjustedPrices() {
    print("Periodicity: \(selectedPeriodicity)")
    let beginDate = try! Date.from(month: 12, day: 1, year: 2017)
    AVHistoricalAdjustedStockPricesBuilder()
      .setSymbol("MSFT")
      .setPeriodicity(selectedPeriodicity)
      .withDateFilter(AVDateFilter.after(beginDate))
      .getResults { (stocks, error) in
        print(stocks?.timeSeries as Any)
        print(error as Any)
    }
  }
  
  private func fetchStandardPrices() {
    print("Periodicity: \(selectedPeriodicity)")
    let beginDate = try! Date.from(month: 11, day: 1, year: 2003)
    let endDate = try! Date.from(month: 1, day: 1, year: 2005)
    AVHistoricalStandardStockPricesBuilder()
      .setSymbol("MSFT")
      .setPeriodicity(selectedPeriodicity)
      .setConfiguration(
        AVStockFetcherConfiguration(
        fetchQueue: .global(qos: .userInitiated),
        callbackQueue: .main,
        failOnParsingError: true))
      .withDateFilter(AVDateFilter.between(beginDate, endDate))
      .getResults { stocks, error in
          print(stocks?.timeSeries as Any)
          print(error as Any)
    }
  }
}

// MARK: UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
  public func pickerView(_ pickerView: UIPickerView,
                          titleForRow row: Int,
                          forComponent component: Int) -> String?
  {
    return periodicityOrdering[row].rawValue
  }
}

// MARK: UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return periodicityOrdering.count
  }
}

