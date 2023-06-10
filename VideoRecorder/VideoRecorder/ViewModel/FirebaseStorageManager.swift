//
//  FirebaseStorageManager.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/10.
//

import FirebaseStorage
import Firebase

final class FirebaseStorageManager {
    static func uploadVideo(_ video: Data, id: UUID) {
        let metaData = StorageMetadata()
        metaData.contentType = "/mp4"
        
        let firebaseReference = Storage.storage().reference().child("\(id)")
        firebaseReference.putData(video, metadata: metaData)
    }
    
    static func deleteVideo(id: UUID) {
        let firebaseReference = Storage.storage().reference().child("\(id)")
        firebaseReference.delete { error in
            if let error = error {
                print("동영상 삭제 실패: \(error)")
            } else {
                print("동영상 삭제 성공")
            }
        }
    }
}
