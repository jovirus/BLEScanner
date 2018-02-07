 //
//  DFUDashboardViewController.swift
//  nRF Connect
//
//  Created by Jiajun Qiu on 22/11/2016.
//  Copyright © 2016 Nordic Semiconductor. All rights reserved.
//

import Foundation
import UIKit
import Charts
import iOSDFULibrary
 
 extension DFUDetailViewController: DFUDetailViewModelDelegate {
    func statusChanged(status: DFUStatus) {
        if status == .Complete {
            self.dfuProgressBar.setProgress(Float(100), animated: false)
            controlButtonStateChange(iconName: self.dfuDetailViewModel.completeIcon)
        } else if status == .Abort {
            controlButtonStateChange(iconName: self.dfuDetailViewModel.playIcon)
        } else if status == .Start || status == .Update {
            controlButtonStateChange(iconName: self.dfuDetailViewModel.pauseIcon)
            
        }
        self.DFUStatus.text = status.rawValue
    }
 
    func logUpdated(info: String) {
        self.log.text = info
    }
    
    func timeCounterChanged(elapse: String) {
        self.timeCounter.text = elapse
        self.dfuProgressBar.setProgress(dfuDetailViewModel.getdfuProgress(), animated: true)
    }
    
    func didUpdateDFUProgress(currentBytesPerSec: Double, avgBytesPerSec: Double, progress: Int) {
        updateChart(currentBytesPerSec: currentBytesPerSec, avgBytesPerSec: avgBytesPerSec, progress: progress)
        if !isChartInitialized {
            initiateChartData(deviceName: "Test device", currentBytesPerSec: currentBytesPerSec, avgBytesPerSec: avgBytesPerSec, progress: progress)
            isChartInitialized = !isChartInitialized
        } else {
            updateChart(currentBytesPerSec: currentBytesPerSec, avgBytesPerSec: avgBytesPerSec, progress: progress)
        }
    }
 }
 
 extension DFUDetailViewController: ChartViewDelegate {
    //MARK: Chart
    fileprivate func prepareForChart() {
        progressLineChartView.delegate = self;
        progressLineChartView.chartDescription?.text = "";
        progressLineChartView.noDataText = "Press start to update";
        progressLineChartView.dragEnabled = true
        progressLineChartView.setScaleEnabled(true)
        progressLineChartView.pinchZoomEnabled = true;
        progressLineChartView.drawGridBackgroundEnabled = false;
        
        //[_chartView.xAxis addLimitLine:llXAxis];
        let ll1 = ChartLimitLine.init(limit: 3000, label: "average")
        ll1.lineWidth = 2.0;
        ll1.lineDashLengths = [CGFloat(5.0), CGFloat(5.0)]
        ll1.labelPosition = .rightTop;
        ll1.valueFont = UIFont.systemFont(ofSize: 10.0)
        
        let leftAxis: YAxis = progressLineChartView.leftAxis;
        //leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.axisMaximum = 5000.0;
        leftAxis.axisMinimum = 0.0;
        leftAxis.gridLineDashLengths = [CGFloat(5.0), CGFloat(5.0)]
        leftAxis.drawZeroLineEnabled = false;
        leftAxis.drawLimitLinesBehindDataEnabled = false;
        let xAxis = progressLineChartView.xAxis
        xAxis.granularity = 1
        
        progressLineChartView.setVisibleXRange(minXRange: 0, maxXRange: self.maximunNumerValueInView)
        progressLineChartView.autoScaleMinMaxEnabled = true
        progressLineChartView.rightAxis.enabled = false;
        progressLineChartView.legend.form = .circle;
        progressLineChartView.animate(xAxisDuration: 0.0)
        progressLineChartView.legend.wordWrapEnabled = false
        progressLineChartView.legend.orientation = .vertical
        progressLineChartView.legend.drawInside = true
        progressLineChartView.legend.horizontalAlignment = .left
        progressLineChartView.legend.verticalAlignment = .top
        progressLineChartView.legend.yOffset = 20
        progressLineChartView.legend.xOffset = 70
    }
    
    fileprivate func initiateChartData(deviceName: String, currentBytesPerSec: Double, avgBytesPerSec: Double, progress: Int) {
        let dataEntry = ChartDataEntry(x: Double(progress), y: currentBytesPerSec)
        var chartDataSets: [LineChartDataSet] = []
        var dataEntries: [ChartDataEntry] = []
        var dataSet: LineChartDataSet!
        
        dataEntries.append(dataEntry)
        dataSet = LineChartDataSet(values: dataEntries, label: "bytes/sec")
        dataSet.setColor((UIColor.green.withAlphaComponent(0.5)))
        dataSet.mode = .cubicBezier
        dataSet.lineWidth = 2
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = false
        dataSet.drawCirclesEnabled = false
        
        let gradientColors: [CGColor] = [ChartColorTemplates.colorFromString("#ffffff").cgColor,ChartColorTemplates.colorFromString("#009cde").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        dataSet.fillAlpha = 1.0;
        dataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        
        chartDataSets.append(dataSet)
        let chartData = LineChartData(dataSets: chartDataSets)
        progressLineChartView.fitScreen()
        progressLineChartView.data = chartData
        progressLineChartView.notifyDataSetChanged()
    }
    
    fileprivate func updateChart(currentBytesPerSec: Double, avgBytesPerSec: Double, progress: Int) {
        guard progress != 0 else {
            return
        }
        let dataEntryNew = ChartDataEntry(x: Double(progress), y: Double(currentBytesPerSec))
        _ = progressLineChartView.data?.dataSets[0].addEntry(dataEntryNew)
        progressLineChartView.leftAxis.limitLines[0].limit = avgBytesPerSec
        progressLineChartView.setVisibleXRange(minXRange: 1, maxXRange: Double(maximunNumerValueInView))
        progressLineChartView.data?.notifyDataChanged()
        progressLineChartView.moveViewToX(Double(progress))
    }
    
    private func setGradient(){
        let gradientColors: [CGColor] = [ChartColorTemplates.colorFromString("#ffffff").cgColor,ChartColorTemplates.colorFromString("#009cde").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)
        let dataSet = self.progressLineChartView.data?.dataSets[0] as! LineChartDataSet
        dataSet.fillAlpha = 1.0;
        dataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
    }
 }
 
 

class DFUDetailViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var DFUStatus: UILabel!
    @IBOutlet weak var CloseButton: UIBarButtonItem!
    @IBOutlet weak var shareLogButton: UIButton!
    @IBOutlet weak var progressLineChartView: LineChartView!
    @IBOutlet weak var showInfoButton: UIButton!
    @IBOutlet weak var ConsoleHeight: NSLayoutConstraint!
    @IBOutlet weak var timeCounter: UILabel!
    @IBOutlet weak var estimateTime: UILabel!
    @IBOutlet weak var firmwareName: UILabel!
    @IBOutlet weak var log: UILabel!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var controlButtonImage: UIImageView!
    @IBOutlet weak var dfuProgressBar: UIProgressView!
    
    private(set) var maximunNumerValueInView: Double = 20

    
    //MARK: Progress chart properties
    fileprivate var isChartInitialized = false
    
    var firmwareInfoPopUp: FirmwareInfoPopUp!
    var dfuDetailViewModel: DFUDetailViewModel!
    override func viewDidLoad() {
        self.dfuDetailViewModel.dfuDetailViewModelDelegate = self
        initializePopoverController()
        self.ConsoleHeight.constant = UIHelper.screenHeight*0.4
        self.firmwareName.text = self.dfuDetailViewModel.firmwareName
        self.dfuProgressBar.setProgress(0.0, animated: true)
        self.estimateTime.text = self.dfuDetailViewModel.getEstimatedTime()
        prepareForChart()
    }
    
    func initializePopoverController()
    {
        self.firmwareInfoPopUp = self.storyboard!.instantiateViewController(withIdentifier: "FirmwareInfoPopUp") as? FirmwareInfoPopUp
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.DFUStatus.text = self.dfuDetailViewModel.status.rawValue
    }
    
    // MARK: Buttons
    @IBAction func CloseViewButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func showInfoButtonPressed(_ sender: UIButton) {
        if let popUpVC = self.firmwareInfoPopUp
        {
            popUpVC.modalPresentationStyle = .popover
            popUpVC.firmwareInfoPopUpViewModel = self .dfuDetailViewModel.getfirmwareInfo()
            var size: CGSize!
            if popUpVC.firmwareInfoPopUpViewModel.firmwareType == DFUFileKind.DistributionPackage {
                size = CGSize(width: UIHelper.screenWidth*0.8, height: UIHelper.screenWidth*0.4)
            } else if popUpVC.firmwareInfoPopUpViewModel.firmwareType == DFUFileKind.Binary {
                 size = CGSize(width: UIHelper.screenWidth*0.8, height: UIHelper.screenWidth*0.6)
            }
            popUpVC.preferredContentSize = size
            let popoverWriteValueCharacteristic = popUpVC.popoverPresentationController
            popoverWriteValueCharacteristic?.permittedArrowDirections = .any
            popoverWriteValueCharacteristic?.delegate = self
            popoverWriteValueCharacteristic?.sourceView = sender
            popUpVC.popoverPresentationController?.delegate = self
            self.present(popUpVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func controlButtonPessed(_ sender: UIButton) {
        if dfuDetailViewModel.status == .Ready || dfuDetailViewModel.status == .Pause {
            controlButtonStateChange(iconName: self.dfuDetailViewModel.pauseIcon)
            dfuDetailViewModel.startUpdate()
        } else if dfuDetailViewModel.status == .Update {
            controlButtonStateChange(iconName: self.dfuDetailViewModel.playIcon)
            dfuDetailViewModel.pauseUpdating()
        } else if dfuDetailViewModel.status == .Complete {
            self.dismiss(animated: true) {
            }
        } else if dfuDetailViewModel.status == .Abort {
            controlButtonStateChange(iconName: self.dfuDetailViewModel.playIcon)
            dfuDetailViewModel.startUpdate() // try again
        }
    }
    
    //END MARK
    fileprivate func controlButtonStateChange(iconName: String) {
        self.controlButtonImage.image = UIImage(named: iconName)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func shareLogButtonPressed(_ sender: UIButton) {
        if let records = self.dfuDetailViewModel.logger.getAllRecords(session: self.dfuDetailViewModel.session) {
            let objectsToShare = [records]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if AppInfo.deviceModel == .pad {
                activityVC.popoverPresentationController?.sourceView = sender
            }
            self.present(activityVC, animated: true, completion: nil)
        } else {
            self.dfuDetailViewModel.logger.addLog("No activity to show", logType: .info, object: #function, session: self.dfuDetailViewModel.session)
        }
    }
}
