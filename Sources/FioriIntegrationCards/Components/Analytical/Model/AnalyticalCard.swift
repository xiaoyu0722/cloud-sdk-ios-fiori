//
//  AnalyticalCard.swift
//  DevTest
//
//  Created by Ma, Xiao on 1/23/20.
//  Copyright © 2020 sstadelman. All rights reserved.
//

import AnyCodable
import Foundation

public class AnalyticalCard: Decodable {
    
    private let headerTemplate: Header
    // not sure about the optional here
    var header: NumericHeader?

    private let template: Template
    public var content: AnalyticalContent?

    private enum MainKeys: CodingKey {
        case header
        case content
    }
    
    public enum ContentKeys: CodingKey {
        case chartType
        case legend
        case plotArea
        case title
        case measureAxis
        case dimensionAxis
        case measures
        case dimensions
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: MainKeys.self)
        headerTemplate = try container.decode(Header.self, forKey: .header)
        let contentContainer = try container.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
        
        template = try Template(from: contentContainer)
        
        let contentDataJson = try HavingContent<HavingData<AnyCodable>>(from: decoder).content.data.value as! JSONDictionary
        guard let contentData = contentDataJson["json"] as? JSONDictionary else {
            return
        }
        content = AnalyticalContent.init(from: template, with: contentData)
        
//        let headerDataJson = try HavingHeaderData<HavingData<AnyCodable>>(from: decoder).header.data.value as! JSONDictionary
//        guard let headerData = headerDataJson["json"] as? JSONDictionary else {
//            return
//        }
//
//        switch headerTemplate {
//        case .numeric(let template):
//            header = getbindedHeader(with: headerData, for: template)
//            break
//        default:
//            break
//        }
    }
    
    public struct HavingAnyModel<Model: Decodable>: Decodable {
        let model: Model?
        
        enum CodingKeys: CodingKey {
            case model
        }
        
        init(from json: JSONDictionary, with key: CodingKey) {
            model = json[key.stringValue] as? Model
        }
    }
    
    private struct HavingHeaderData<DataModel: Decodable>: Decodable {
        let header: DataModel
    }
    
    private struct HavingData<Model: Decodable>: Decodable {
        let data: Model
    }
}


extension AnalyticalCard: Hashable {
    public static func == (lhs: AnalyticalCard, rhs: AnalyticalCard) -> Bool {
        return lhs.header == rhs.header
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(header)
    }
}


public struct AnalyticalContent: Decodable {
    public let chartType: String
    public let legend: AnalyticalLegend?
    public let plotArea: AnalyticalPlotArea?
    public let title: AnalyticalTitleAttributes?
    public let measureAxis: String?
    public let dimensionAxis: String?
    public let measures: [AnalyticalMeasureDimension]
    public let dimensions: [AnalyticalMeasureDimension]
    
    public var data: [DataCategory]?
    
    init(from template: Template, with jsonData: JSONDictionary) {
        chartType       = template.chartType.replacingPlaceholders(withValuesIn: jsonData)
        measureAxis     = template.measureAxis?.replacingPlaceholders(withValuesIn: jsonData)
        dimensionAxis   = template.dimensionAxis?.replacingPlaceholders(withValuesIn: jsonData)
        legend = {
            let _title              = template.legend?.title?.replacingPlaceholders(withValuesIn: jsonData)
            let _drawingEffect      = template.legend?.drawingEffect?.replacingPlaceholders(withValuesIn: jsonData)
            let _isHierarchical     = template.legend?.isHierarchical?.replacingPlaceholdersToBoolean(withValuesIn: jsonData)
            let _isScrollable       = template.legend?.isScrollable?.replacingPlaceholdersToBoolean(withValuesIn: jsonData)
            let _isVisible          = template.legend?.isVisible?.replacingPlaceholdersToBoolean(withValuesIn: jsonData)
            return AnalyticalLegend(title: _title, drawingEffect: _drawingEffect, isHierarchical: _isHierarchical, isScrollable: _isScrollable, isVisible: _isVisible)
        }()
        
        title = template.title
        plotArea = template.plotArea
        
        measures = {
            let _measures = template.measures.map { (measureTemp) -> AnalyticalMeasureDimension in
                let _label = measureTemp.label.replacingPlaceholders(withValuesIn: jsonData)
                let _value = measureTemp.value.replacingPlaceholders(withValuesIn: jsonData)
                return AnalyticalMeasureDimension(label: _label, value: _value)
            }
            return _measures
        }()
        dimensions = {
            let _dimensions = template.dimensions.map { (measureTemp) -> AnalyticalMeasureDimension in
                let _label = measureTemp.label.replacingPlaceholders(withValuesIn: jsonData)
                let _value = measureTemp.value.replacingPlaceholders(withValuesIn: jsonData)
                return AnalyticalMeasureDimension(label: _label, value: _value)
            }
            return _dimensions
        }()
        data = {
            let listArray = jsonData["list"] as! JSONArray
            let _data = self.measures.map { (measure) -> DataCategory in
                let _names = listArray.map { (json) -> String in
                    let _name = self.dimensions.first?.value.replacingPlaceholders(withValuesIn: json)
                    return _name ?? "Empty"
                }
                let _points = listArray.map { (json) -> DataPoint in
                    let _series = measure.label.replacingPlaceholders(withValuesIn: json)
                    let _value  = measure.value.replacingPlaceholdersToDouble(withValuesIn: json)
                    return DataPoint(series: _series, value: _value, secondaryValue: nil, tertiaryValue: nil)
                }
                return DataCategory(names: _names, points: _points)
            }
            return _data
        }()
    }
}

public struct Template: Decodable {
    public let chartType: String
    public let legend: AnalyticalLegendTemplate?
    public let plotArea: AnalyticalPlotArea?
    public let title: AnalyticalTitleAttributes?
    public let measureAxis: String?
    public let dimensionAxis: String?
    public let measures: [AnalyticalMeasureDimension]
    public let dimensions: [AnalyticalMeasureDimension]
    
    init(from container: KeyedDecodingContainer<AnalyticalCard.ContentKeys>) throws {
        chartType       = try container.decode(String.self, forKey: .chartType)
        legend          = try container.decode(AnalyticalLegendTemplate.self, forKey: .legend)
        plotArea        = try container.decode(AnalyticalPlotArea.self, forKey: .plotArea)
        title           = try container.decode(AnalyticalTitleAttributes.self, forKey: .title)
        measureAxis     = try container.decode(String.self, forKey: .measureAxis)
        dimensionAxis   = try container.decode(String.self, forKey: .dimensionAxis)
        measures        = try container.decode([AnalyticalMeasureDimension].self, forKey: .measures)
        dimensions      = try container.decode([AnalyticalMeasureDimension].self, forKey: .dimensions)
    }
}

public struct AnalyticalLegendTemplate: Decodable {
    public let title: String?
    public let drawingEffect: String?
    public let isHierarchical: String?
    public let isScrollable: String?
    public let isVisible: String?
    
    enum CodingKeys: String, CodingKey {
        case title, drawingEffect, isHierarchical, isScrollable, isVisible = "visible"
    }
}

public struct DataCategory: Identifiable, Decodable {
    public let id: UUID = UUID()
    public let names: [String]
    public let points: [DataPoint]
}

public struct DataPoint: Identifiable, Decodable {
    public let id: UUID = UUID()
    public let series: String
    public let value: Double   // y value in most charts, sometimes the x in horizontal charts
    public let secondaryValue: Double? // would be used in scatter and bubble charts
    public let tertiaryValue: Double?  // would be used in bubble charts
}