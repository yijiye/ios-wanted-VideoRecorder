//
//  SceneDelegate.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let recordVideoViewModel = RecordVideoViewModel()
        let videoListViewModel = VideoListViewModel(recordVideoViewModel: recordVideoViewModel)
        let navigationController = UINavigationController(rootViewController: VideoListViewController(viewModel: videoListViewModel, recordVideoViewModel: recordVideoViewModel))
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}

