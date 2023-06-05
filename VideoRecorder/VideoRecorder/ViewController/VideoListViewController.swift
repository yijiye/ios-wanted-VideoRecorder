//
//  ViewController.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit

final class VideoListViewController: UIViewController {
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Video>
    private var videoDataSource: DataSource?
    
    private lazy var videoListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        configureNavigationBar()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(videoListCollectionView)
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

// MARK: DataSource
extension VideoListViewController {
    private func setUpDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<VideoListCell, Video> {
            cell,indexPath,itemIdentifier in
        }
        
        videoDataSource = DataSource(collectionView: videoListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func setUpSnapshot(_ videos: [Video]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Video>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos, toSection: .main)
        videoDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: Layout
extension VideoListViewController {
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}
