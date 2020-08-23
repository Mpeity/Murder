//
//  GameVoteResultModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation



class TrueAnswerModel : NSObject {

    var answerTitle : String?
    var scriptAnswerId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        answerTitle = dictionary["answer_title"] as? String
        scriptAnswerId = dictionary["script_answer_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if answerTitle != nil{
            dictionary["answer_title"] = answerTitle
        }
        if scriptAnswerId != nil{
            dictionary["script_answer_id"] = scriptAnswerId
        }
        return dictionary
    }
}


class TrueUserModel : NSObject {

    var head : String?
    var name : String?
    var scriptRoleId : String?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        head = dictionary["head"] as? String
        name = dictionary["name"] as? String
        scriptRoleId = dictionary["script_role_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if head != nil{
            dictionary["head"] = head
        }
        if name != nil{
            dictionary["name"] = name
        }
        if scriptRoleId != nil{
            dictionary["script_role_id"] = scriptRoleId
        }
        return dictionary
    }

}


class ResultListModel : NSObject {

    var questionTitle : String?
    var scriptQuestionId : Int?
    var trueAnswers : [TrueAnswerModel]?
    var trueUsers : [TrueUserModel]?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        questionTitle = dictionary["question_title"] as? String
        scriptQuestionId = dictionary["script_question_id"] as? Int
        trueAnswers = [TrueAnswerModel]()
        if let trueAnswersArray = dictionary["true_answers"] as? [[String:Any]]{
            for dic in trueAnswersArray{
                let value = TrueAnswerModel(fromDictionary: dic)
                trueAnswers!.append(value)
            }
        }
        trueUsers = [TrueUserModel]()
        if let trueUsersArray = dictionary["true_users"] as? [[String:Any]]{
            for dic in trueUsersArray{
                let value = TrueUserModel(fromDictionary: dic)
                trueUsers!.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if questionTitle != nil{
            dictionary["question_title"] = questionTitle
        }
        if scriptQuestionId != nil{
            dictionary["script_question_id"] = scriptQuestionId
        }
        if trueAnswers != nil{
            var dictionaryElements = [[String:Any]]()
            for trueAnswersElement in trueAnswers! {
                dictionaryElements.append(trueAnswersElement.toDictionary())
            }
            dictionary["true_answers"] = dictionaryElements
        }
        if trueUsers != nil{
            var dictionaryElements = [[String:Any]]()
            for trueUsersElement in trueUsers! {
                dictionaryElements.append(trueUsersElement.toDictionary())
            }
            dictionary["true_users"] = dictionaryElements
        }
        
        return dictionary
    }
}


class GameVoteResultModel : NSObject {

    var list : [ResultListModel]?
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        list = [ResultListModel]()
        if let listArray = dictionary["list"] as? [[String:Any]]{
            for dic in listArray{
                let value = ResultListModel(fromDictionary: dic)
                list!.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if list != nil{
            var dictionaryElements = [[String:Any]]()
            for listElement in list! {
                dictionaryElements.append(listElement.toDictionary())
            }
            dictionary["list"] = dictionaryElements
        }
        return dictionary
    }

}
