//
//  RSSIChartViewController.swift
//  MasterControlPanel
//
//  Created by Jiajun Qiu on 25/05/16.
//  Copyright © 2016 Jiajun Qiu. All rights reserved.
//

import Foundation
import Charts

extension RSSIChartViewController: RearViewControllerStatusDelegate {
    func rearPageWillAppear(_ pageType: RearPageViewEnum) {}
    func rearPageWillDisappear(_ pageType: RearPageViewEnum) {}
}

extension RSSIChartViewController: ChartViewDelegate {}
extension RSSIChartViewController: RSSIChartViewModelDelegate {
    func didUpdateRSSIChartData(_ averageValue: Dictionary<String, [RSSIChartDataSetViewModel]>, timeSlot: [String]) {
        setChart(timeSlot, values: averageValue)
    }
}

class RSSIChartViewController: UIViewController
{
    
    @IBOutlet weak var RSSIChartView: LineChartView!
    @IBOutlet weak var chartViewWidth: NSLayoutConstraint!
    @IBOutlet weak var chartViewHeight: NSLayoutConstraint!
    
    var months: [String]!
    var rssiChartViewModel = RSSIChartViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
            self.rssiChartViewModel.rssiChartViewModelDelegate = self
        }
    
    override func viewDidLoad() {
        chartViewWidth.constant = UIHelper.screenWidth*0.85
        chartViewHeight.constant = UIHelper.screenHeight*0.80
        RSSIChartView.delegate = self;
        
        RSSIChartView.chartDescription?.text = "";
        RSSIChartView.noDataText = "Collecting advertising packets...";
        
        RSSIChartView.dragEnabled = true
        RSSIChartView.setScaleEnabled(true)
        RSSIChartView.pinchZoomEnabled = true;
        RSSIChartView.drawGridBackgroundEnabled = false;
        
        // x-axis limit line
        let llXAxis = ChartLimitLine.init(limit: 10.0, label: "Index 10")
        llXAxis.lineWidth = 4.0;
        llXAxis.lineDashLengths = [CGFloat(10.0), CGFloat(10.0), CGFloat(0.0)]
        llXAxis.labelPosition = .rightBottom;
        llXAxis.valueFont = UIFont.systemFont(ofSize: 10.0)
        
        //[_chartView.xAxis addLimitLine:llXAxis];
        let ll1 = ChartLimitLine.init(limit: -10, label: "Upper Limit")
        ll1.lineWidth = 4.0;
        ll1.lineDashLengths = [CGFloat(5.0), CGFloat(5.0)]
        ll1.labelPosition = .rightTop;
        ll1.valueFont = UIFont.systemFont(ofSize: 10.0)
        
        let ll2 = ChartLimitLine.init(limit: -90, label: "Lower Limit")
        ll2.lineWidth = 4.0;
        ll2.lineDashLengths = [CGFloat(5.0), CGFloat(5.0)]
        ll2.labelPosition = .rightBottom;
        ll2.valueFont = UIFont.systemFont(ofSize: 10.0);
        
        let leftAxis: YAxis = RSSIChartView.leftAxis;
        leftAxis.removeAllLimitLines()

        leftAxis.axisMaximum = 0.0;
        leftAxis.axisMinimum = -100.0;
        leftAxis.gridLineDashLengths = [CGFloat(5.0), CGFloat(5.0)]
        leftAxis.drawZeroLineEnabled = false;
        leftAxis.drawLimitLinesBehindDataEnabled = false;
        
        let xAxis = RSSIChartView.xAxis
        xAxis.granularity = 2
        RSSIChartView.rightAxis.enabled = false;
        
        RSSIChartView.legend.form = .circle;
        
        RSSIChartView.setVisibleXRange(minXRange: 0, maxXRange: Double(self.rssiChartViewModel.maximunValueOnView))
        RSSIChartView.autoScaleMinMaxEnabled = true
        RSSIChartView.animate(xAxisDuration: 0.5)
        RSSIChartView.legend.wordWrapEnabled = false
        RSSIChartView.legend.orientation = .vertical
        RSSIChartView.legend.drawInside = true
        RSSIChartView.legend.horizontalAlignment = .left
        RSSIChartView.legend.verticalAlignment = .top
        RSSIChartView.legend.yOffset = 20
        RSSIChartView.legend.xOffset = 70
    }
    
    func setChart(_ dataPoints: [String], values: Dictionary<String, [RSSIChartDataSetViewModel]>) {
        guard dataPoints.count > 0 && values.count > 0 && !values.contains(where: { (_, viewModel
            ) -> Bool in
            return viewModel.count != dataPoints.count
        }) else {
            return
        }
        var chartDataSets: [LineChartDataSet] = []
        for (_, vm) in values {
            var dataEntries: [ChartDataEntry] = []
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(x: Double(vm[i].timeSlot), y: Double(vm[i].averageRSSI))
                    dataEntries.append(dataEntry)
                }
            let dataSet = LineChartDataSet(values: dataEntries, label: vm.first?.deviceName)
            dataSet.setColor((vm.first?.displayColor.withAlphaComponent(0.5))!)
            dataSet.mode = .cubicBezier
            dataSet.lineWidth = 2
            chartDataSets.append(dataSet)
        }
        let chartData = LineChartData(dataSets: chartDataSets)
        RSSIChartView.data = chartData
        for item in RSSIChartView.data!.dataSets {
           let dataSet = item as! ILineChartDataSet
          dataSet.drawValuesEnabled = !item.drawValuesEnabled
          dataSet.drawCirclesEnabled = false
        }
        RSSIChartView.setVisibleXRange(minXRange: 1, maxXRange: Double(self.rssiChartViewModel.maximunValueOnView))
        RSSIChartView.moveViewToX(Double(dataPoints.last!)!)
        RSSIChartView.notifyDataSetChanged()
    }
}
