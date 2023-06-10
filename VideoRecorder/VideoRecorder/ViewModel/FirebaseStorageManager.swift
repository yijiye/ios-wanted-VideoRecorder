//
//  FirebaseStorageManager.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/10.
//

import FirebaseStorage
import Firebase

final class FirebaseStorageManager {
    static func uploadVideo(_ video: Data, videoName: String) {
        let metaData = StorageMetadata()
        metaData.contentType = "/mp4"
        
        let videoName = videoName
        
        let firebaseReference = Storage.storage().reference().child("\(videoName)")
        firebaseReference.putData(video, metadata: metaData)
    }
}
