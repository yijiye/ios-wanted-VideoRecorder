//
//  ViewController.swift
//  VideoRecorder
//
//  Created by 리지 on 2023/06/05.
//

import UIKit
import Combine

final class VideoListViewController: UIViewController {
    enum Section {
        case main
    }
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, VideoEntity>
    private var cancellables = Set<AnyCancellable>()
    private var videoDataSource: DataSource?
    private let viewModel = VideoListViewModel()
    
    private lazy var videoListCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDataSource()
        bind()
        setUpView()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.readAll()
    }
    
    private func bind() {
        viewModel.$videoList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { output in
                self.setUpSnapshot(output)
            })
            .store(in: &cancellables)
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(videoListCollectionView)

        let safeArea = view.safeAreaLayoutGuide
        videoListCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoListCollectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            videoListCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            videoListCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            videoListCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
    }
    
    private func configureNavigationBar() {
        let listImage = UIImage(systemName: "list.triangle")
        let listButton = UIButton()
        listButton.tintColor = .black
        listButton.setImage(listImage, for: .normal)
        let list = UIBarButtonItem(customView: listButton)
        
        let titleLabel = UILabel()
        titleLabel.text = "Video List"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        let title = UIBarButtonItem(customView: titleLabel)
        
        let videoImage = UIImage(systemName: "video.fill.badge.plus")
        let videoButton = UIButton()
        videoButton.tintColor = .purple
        videoButton.setImage(videoImage, for: .normal)
        videoButton.addTarget(self, action:  #selector(videoButtonTapped), for: .touchUpInside)
        let video = UIBarButtonItem(customView: videoButton)
        
        navigationItem.leftBarButtonItems = [list, title]
        navigationItem.rightBarButtonItem = video
    }
    
    @objc private func videoButtonTapped() {
        let recordViewController = RecordVideoViewController()
        recordViewController.modalPresentationStyle = .fullScreen
        self.present(recordViewController, animated: true, completion: nil)
    }
}

// MARK: DataSource
extension VideoListViewController {
    private func setUpDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<VideoListCell, VideoEntity> {
            cell,indexPath,itemIdentifier in
            cell.video = itemIdentifier
            cell.accessories = [.disclosureIndicator()]
        }
        
        videoDataSource = DataSource(collectionView: videoListCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func setUpSnapshot(_ videos: [VideoEntity]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, VideoEntity>()
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
