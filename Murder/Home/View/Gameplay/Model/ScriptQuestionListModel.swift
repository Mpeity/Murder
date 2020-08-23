//
//  ScriptQuestionListModel.swift
//  Murder
//
//  Created by 马滕亚 on 2020/8/23.
//  Copyright © 2020 m.a.c. All rights reserved.
//

import Foundation


class ScriptAnswerModel : NSObject {

    var answerTitle : String!
    var isAnswer : Int!
    var scriptAnswerId : Int!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        answerTitle = dictionary["answer_title"] as? String
        isAnswer = dictionary["is_answer"] as? Int
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
        if isAnswer != nil{
            dictionary["is_answer"] = isAnswer
        }
        if scriptAnswerId != nil{
            dictionary["script_answer_id"] = scriptAnswerId
        }
        return dictionary
    }
}


class ScriptQuestionListModel : NSObject {

    var isPost : Int?
    var noScriptRoleIds : Int?
    var questionTitle : String?
    var questionType : Int?
    var reverseScore : Int?
    var reverseScoreScriptRoleIds : String?
    var score : Int?
    var scriptAnswer : [ScriptAnswerModel]?
    var scriptQuestionId : Int?


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isPost = dictionary["is_post"] as? Int
        noScriptRoleIds = dictionary["no_script_role_ids"] as? Int
        questionTitle = dictionary["question_title"] as? String
        questionType = dictionary["question_type"] as? Int
        reverseScore = dictionary["reverse_score"] as? Int
        reverseScoreScriptRoleIds = dictionary["reverse_score_script_role_ids"] as? String
        score = dictionary["score"] as? Int
        scriptAnswer = [ScriptAnswerModel]()
        if let scriptAnswerArray = dictionary["script_answer"] as? [[String:Any]]{
            for dic in scriptAnswerArray{
                let value = ScriptAnswerModel(fromDictionary: dic)
                scriptAnswer!.append(value)
            }
        }
        scriptQuestionId = dictionary["script_question_id"] as? Int
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isPost != nil{
            dictionary["is_post"] = isPost
        }
        if noScriptRoleIds != nil{
            dictionary["no_script_role_ids"] = noScriptRoleIds
        }
        if questionTitle != nil{
            dictionary["question_title"] = questionTitle
        }
        if questionType != nil{
            dictionary["question_type"] = questionType
        }
        if reverseScore != nil{
            dictionary["reverse_score"] = reverseScore
        }
        if reverseScoreScriptRoleIds != nil{
            dictionary["reverse_score_script_role_ids"] = reverseScoreScriptRoleIds
        }
        if score != nil{
            dictionary["score"] = score
        }
        if scriptAnswer != nil{
            var dictionaryElements = [[String:Any]]()
            for scriptAnswerElement in scriptAnswer! {
                dictionaryElements.append(scriptAnswerElement.toDictionary())
            }
            dictionary["script_answer"] = dictionaryElements
        }
        if scriptQuestionId != nil{
            dictionary["script_question_id"] = scriptQuestionId
        }
        return dictionary
    }

}
