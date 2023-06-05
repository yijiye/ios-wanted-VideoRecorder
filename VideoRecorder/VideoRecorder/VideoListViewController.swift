//
//  ViewController.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

final class VideoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let listImage = UIImage(systemName: "list.triangle")
        let listButton = UIButton()
        listButton.tintColor = .black
        listButton.setImage(listImage, for: .normal)
        let list = UIBarButtonItem(customView: listButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "Video List"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        let title = UIBarButtonItem(customView: titleLabel)
        
        let videoImage = UIImage(systemName: "video.fill.badge.plus")
        let videoButton = UIButton()
        videoButton.tintColor = .purple
        videoButton.setImage(videoImage, for: .normal)
        let video = UIBarButtonItem(customView: videoButton)
        
        navigationItem.leftBarButtonItems = [list, title]
        navigationItem.rightBarButtonItem = video
    }
}
