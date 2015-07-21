//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Ben Hazlerig on 7/18/15.
//  Copyright (c) 2015 Benjamin Allen. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
  var filePathUrl: NSURL
  var title: String
  
  init (filePathUrl: NSURL, title: String) {
    self.filePathUrl = filePathUrl
    self.title = title
  }
}

