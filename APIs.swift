//
//  APIs.swift
//  MoguDemo
//
//  Created by Zhuofan Ma on 11/23/16.
//  Copyright © 2016 Zhuofan Ma. All rights reserved.
//

import Foundation

func API_One(_ resultBlock:@escaping (_ succeeded:Bool, _ dict:[String:String]) -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(8)) {
        resultBlock(true, ["title":"Shanghai","imageURL":"https://65.media.tumblr.com/avatar_912aa4e0fdf0_128.png"])
    }
}

func API_Two(_ resultBlock:@escaping (_ succeeded:Bool, _ dict:[String:String]) -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4)) {
        resultBlock(true, ["title":"Beijing","imageURL":"https://media-cdn.tripadvisor.com/media/photo-s/07/67/77/f9/main-entrance-gate-to.jpg"])
    }
}

func API_Three(_ resultBlock:@escaping (_ succeeded:Bool, _ dict:[String:String]) -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(12)) {
        resultBlock(true, ["title":"Rome","imageURL":"https://news.artnet.com/app/news-upload/2014/07/800px-Trevi_Fountain_Rome_Italy_2_-_May_2007-e1404205710388-256x256.jpg"])
    }
}

func API_Four(_ resultBlock:(_ succeeded:Bool, _ dict:[String:String]) -> ()) {
    resultBlock(true, ["title":"Paris","imageURL":"https://s-media-cache-ak0.pinimg.com/236x/bc/d6/0f/bcd60fb2eb4f2c7df9db26b2c80776d5.jpg"])
}

func API_Five(_ resultBlock:(_ succeeded:Bool, _ dict:[String:String]) -> ()) {
    resultBlock(false, [:])
}
