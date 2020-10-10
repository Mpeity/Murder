//
//  GPMapPlaceListModel.swift
//  Murder
//
//  Created by m.a.c on 2020/8/20.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation

class GPMapPlaceListModel : NSObject {

    var controlHeight : String?
    var controlWidth : String?
    var controlXCoordinate : String?
    var controlYCoordinate : String?
    var placeName : String?
    var scriptNodeMapId : Int?
    var scriptPlaceId : Int?
    var searchOver : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        controlHeight = dictionary["control_height"] as? String
        controlWidth = dictionary["control_width"] as? String
        controlXCoordinate = dictionary["control_x_coordinate"] as? String
        controlYCoordinate = dictionary["control_y_coordinate"] as? String
        placeName = dictionary["place_name"] as? String
        scriptNodeMapId = dictionary["script_node_map_id"] as? Int
        scriptPlaceId = dictionary["script_place_id"] as? Int
        searchOver = dictionary["search_over"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if controlHeight != nil{
            dictionary["control_height"] = controlHeight
        }
        if controlWidth != nil{
            dictionary["control_width"] = controlWidth
        }
        if controlXCoordinate != nil{
            dictionary["control_x_coordinate"] = controlXCoordinate
        }
        if controlYCoordinate != nil{
            dictionary["control_y_coordinate"] = controlYCoordinate
        }
        if placeName != nil{
            dictionary["place_name"] = placeName
        }
        if scriptNodeMapId != nil{
            dictionary["script_node_map_id"] = scriptNodeMapId
        }
        if scriptPlaceId != nil{
            dictionary["script_place_id"] = scriptPlaceId
        }
        if searchOver != nil{
            dictionary["search_over"] = searchOver
        }
        return dictionary
    }

}
