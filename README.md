# README
# VideoRecoder
> 비디오 녹화, 저장 및 재생하는 애플리케이션
> 
> 프로젝트 기간: 2023.06.05 - 2023.06.11
> 

## 개발자

| 리지 |
|  :--------: | 
|<Img src ="https://user-images.githubusercontent.com/114971172/221088543-6f6a8d09-7081-4e61-a54a-77849a102af8.png" width="200" height="200"/>
|[Github Profile](https://github.com/yijiye)


## 목차
1. [실행 화면](#실행-화면)
2. [앱 기능](#앱-기능)
3. [적용 기술](#적용-기술)
4. [프로젝트 구조](#프로젝트-구조)
5. [핵심경험](#핵심경험)
6. [참고 링크](#참고-링크)

<br/>

# 실행 화면

https://github.com/yijiye/TIL-swift-/assets/114971172/27e3c9bf-d7c3-4a26-b554-85134152f979

<br/>

# 앱 기능

- 카메라구현으로 영상 녹화, 화면 전환 가능
- 영상 녹화시간 기록
- 영상 제목 저장
- 썸네일 추출, 영상길이 표시
- 녹화한 영상 클릭시 재생화면으로 이동 및 재생
- 녹화한 영상 LocalDB 및 RemoteDB에 저장/백업

</br>

|                            메인 화면                             |                               삭제                               |                            녹화 화면                             |                          영상제목 저장                           |                              플레이                              |
|:----------------------------------------------------------------:|:----------------------------------------------------------------:|:----------------------------------------------------------------:|:----------------------------------------------------------------:|:----------------------------------------------------------------:|
| <img src="https://hackmd.io/_uploads/rksMT0zw3.png" width="300"> | <img src="https://hackmd.io/_uploads/BkjfaAfDn.png" width="300"> | <img src="https://hackmd.io/_uploads/rJJApRGv2.png" width="300"> | <img src="https://hackmd.io/_uploads/ryIhekmDn.png" width="300"> | <img src="https://hackmd.io/_uploads/B1D2bbQDn.png" width="300"> |



|                             LocalDB                              |                             RemoteDB                             |
|:----------------------------------------------------------------:|:----------------------------------------------------------------:|
| <img src="https://hackmd.io/_uploads/rk1bcZmDn.png" width="300"> | <img src="https://hackmd.io/_uploads/Sk2zt-7vh.png" width="600"> |

<br/>


# 적용 기술

|  UI   | Local DB |    Remote DB    | Reactive | Architecture | Dependency |
|:-----:|:--------:|:---------------:|:--------:|:------------:|:----------:|
| UIKit | CoreData | FirebaseStorage | Combine  |     MVVM     |    SPM     |

## 세부 내용

#### 화면구현
- UIKit을 사용하여 코드베이스로 UI를 구성하였습니다.
- 총 3개의 화면으로 구성되어 있습니다.
   - VideoList 화면
   - 영상 녹화 화면
   - 녹화된 영상 플레이되는 화면
- `VideoList` 화면은 `UICollectionView`를 활용하였고, `UICollectionCompositionalLayout`의 `List` 모드를 적용하였습니다.
- 데이터 구성은 `DiffableDataSource`, `NSDiffableDataSourceSnapshot`를 사용하였습니다.
- 영상 녹화 화면은 `AVFoundation` 프레임워크를 사용하여 직접 커스텀하였으며 다른 UI요소도 커스텀하여 화면에 띄웠습니다.
- 녹화된 영상은`AVPlayerViewController`를 사용하였습니다.

#### DataBase
- 녹화가 종료된 지점에서 LocalDB와 RemoteDB에 저장되도록 구현하였습니다.
- LocalDB는 Apple에서 제공하는 CoreData 프레임워크를 사용하였습니다.
- RemoteDB는 FirebaseStorage를 사용하였습니다.
- 저장된 데이터는 앱에서 저장, 삭제시 동기화되도록 구현하였습니다.
- 의존성 관리도구로 Swift Package Manager를 사용하였습니다.

#### Reactive, Architecture
- ViewController의 역할을 분리하고자 MVVM 패턴을 사용하였습니다.
- View - ViewModel간 바인딩시 Apple에서 제공하는 Combine 프레임워크를 사용하였습니다.
    

<br/>

# 프로젝트 구조

![](https://hackmd.io/_uploads/SJhXebmPn.png)


 <br/>
 

# 핵심경험

<details><summary><big>✅ AVFoundation</big></summary>

# AVFoundation

> Framework
> Video Record 화면 구현하기

## Overview
AVFoundation은 Apple 플랫폼에서 시청각 미디어를 검사, 재생, 캡처 및 처리하기 위한 광범위한 작업을 포함하는 몇 가지 주요 기술 영역을 결합한다.

**즉, Apple 플랫폼에 시청각 관련한 하드웨어를 컨트롤할 수 있게 해주는 프레임워크이다.**

- STEP
   - CaptureSession 생성
   - CaptureDevice 생성
   - CaptureDeivceInput 생성
   - Video UI에 출력
   - Recording 

## Capture setup
> API Collection 
> media capture를 위해 내장 카메라나 마이크 그리고 외부 디바이스를 구성해야한다.

- 사용자 지정 카메라 UI 구현
- 사용자가 초점, 노출 및 안정화 옵션과 같은 사진 및 비디오 캡처를 직접 제어할 수 있도록 구현
- RAW 형식 사진, 깊이 지도 또는 사용자 지정 시간 메타데이터가 있는 비디오와 같은 시스템 카메라 UI와 다른 결과를 생성한다.
- 캡처 장치에서 직접 픽셀 또는 오디오 데이터 스트리밍에 실시간으로 액세스할 수 있다.

<img src="https://hackmd.io/_uploads/rJiN-hzPh.png" width=600>

캡쳐 아키텍쳐의 메인파트는 `sessions`, `inputs`, `output` 3가지 이다.

- `CaptureSession` : 하나 이상의 `input`과 `output`을 연결한다.
- `Inputs` : iOS나 Mac에 빌트인된 카메라나 마이크와 같은 디바이스를 포함한 media의 소스를 뜻한다. 디바이스로 찍은 사진이나 동영상을 말한다.
- `Outputs` : 사용가능한 데이터를 만들어 낸 결과물
- `CatureDevice` : 디바이스, 내 아이폰 카메라

## CaptureSession 
`Input`과 `Output`을 연결해주어 데이터 흐름을 제어한다.

```swift 
let captureSession = AVCaptureSession()
captureSession.sessionPreset = .high

...
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    DispatchQueue.global(qos: .background).async { [weak self] in
        self?.captureSession.startRunning()
    }
}
    
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    DispatchQueue.global(qos: .background).async { [weak self] in
        self?.captureSession.stopRunning()
    }
}
```

- `sessionPreset` : 녹화 품질을 설정할 수 있다. 높게할수록 배터리 소비량이 늘어난다.
- `startRunning()` : 실질적은 플로우가 시작된다. **이는 UI를 처리하는 메인스레드와 다른 스레드에서 처리해줘야한다.** 
- `stopRunning()` : 세션의 일이 끝났을 때 호출한다.

나는 view가 나타날때 시작을해주고 view가 사라질때 종료를 설정해주었다. 둘다 메인스레드가 아닌 global()안에 넣어주었다.

## CaptureDevice
사용하려는 장치를 정의해준다.

```swift
// audioDevice
let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)

// cameraDevice
private func selectedCamera(in position: AVCaptureDevice.Position) -> AVCaptureDevice? {
    let deviceTypes: [AVCaptureDevice.DeviceType] = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        
    let discoverySession = AVCaptureDevice.DiscoverySession(
        deviceTypes: deviceTypes,
        mediaType: .video,
        position: .unspecified
    )
        
    let devices = discoverySession.devices
    guard !devices.isEmpty,
          let device = devices.first(where: { device in device.position == position }) else { return nil }
        
    return device
}
```

## CaptureDeviceInput
`captureDevice`를 이용해서 `session`에 `captureDeviceInput`을 추가해준다.

```swift
private func setUpSession() {
    guard let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio) else { return }

    captureSession.sessionPreset = .high
        
    do {
        // 1
        captureSession.beginConfiguration()
        
        // 2
        videoDevice = selectedCamera(in: .back)
        guard let videoDevice else { return }
        videoInput = try AVCaptureDeviceInput(device: videoDevice)
        guard let videoInput else { return }
            
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
            
        // 3
        let audioInput = try AVCaptureDeviceInput(device: audioDevice)
        if captureSession.canAddInput(audioInput)  {
            captureSession.addInput(audioInput)
        }
        
        // 4
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        }

        // 5
        captureSession.commitConfiguration()
        self.view.layer.addSublayer(videoPreViewLayer)
        
        // 6
        setUpCloseButton()
        setUpRecordStackView()
        
        videoPreViewLayer.session = captureSession
            
    } catch let error as NSError {
        print(error.localizedDescription)
    }
}
```

1. 세션 구성의 시작을 나타낸다.
2. 비디오 디바이스에 대한 입력을 만들어 세션에 추가한다.
3. 오디오 디바이스에 대한 입력을 만들어 세션에 추가한다.
4. 비디오, 오디오를 파일로 출력하기 위한 output을 만들어 세션에 추가한다.
5. 세션 구성의 완료를 나타낸다.
6. videoPreViewLayer 위에 추가하는 UI요소를 넣어준다.


## Video UI
화면에 비디오나 사진 촬영시 보여지는 UI를 구현한다.

```swift
 private lazy var videoPreViewLayer: AVCaptureVideoPreviewLayer = {
    let previewLayer = AVCaptureVideoPreviewLayer()
    previewLayer.frame = self.view.frame
    previewLayer.videoGravity = .resizeAspectFill
        
    return previewLayer
}()
```

- frame 은 view의 frame에 맞추고 videoGravity에 원하는 값을 넣어주었다.
- session을 구성할때 view의 layer에 추가해주고 그 아래 다른 요소를 추가해야 정상적으로 화면에 나타났다. 
- 우선 Layer를 추가하고 다른 view나 button등 UI는 그 다음에 추가해야 화면에 뜸! 
- 또한 카메라 사용전 기본 info.plist 설정도 해야한다.


## Recording
이제 view에 나타는 화면을 녹화해야하는데 이는 `AVCaptureMovieFileOutput`을 이용하면 된다.

```swift
let videoOutput = AVCaptureMovieFileOutput()

// 녹화시작
private func startRecording() {
    startTimer()
    outputURL = viewModel.createVideoURL()
    guard let outputURL else { return }
    videoOutput.startRecording(to: outputURL, recordingDelegate: self)
}

// 녹화종료
private func stopRecording() {
    if videoOutput.isRecording == true {
        stopTimer()
        videoOutput.stopRecording()
    }
}
```

녹화가 종료된 후의 작업은 `AVCaptureFileOutputRecordingDelegate`를 준수하여 원하는 메서드를 사용할 수 있다.

```swift
extension RecordVideoViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        recordStackView.changeCameraModeButton.isEnabled = false
     }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        recordStackView.changeCameraModeButton.isEnabled = true
    if (error != nil) {
         print(error?.localizedDescription as Any)
    } else {
        guard let videoRecordedURL = outputURL,
              let videoData = try? Data(contentsOf: videoRecordedURL) else { return }
            
        let title = "영상의 제목을 입력해주세요."
        let save = "저장"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: save, style: .default) { [weak self] _ in
            guard let videoTitle = alert.textFields?[0].text else { return }
            self?.fetchThumbnail(from: videoRecordedURL, videoData: videoData, title: videoTitle)
        }
            
        alert.addTextField()
        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
}
```

- 첫 번째 메서드는 녹화가 시작되면 호출되는 메서드로 나는 녹화가 시작되었을 때, 카메라 모드를 바꾸는 버튼이 작동하지 않도록 구현했다.
- 두 번째 메서드는 녹화가 종료되면 호출되는 메서드로 종료가 되면 제목을 입력하는 Alert창이 뜨고 입력된 제목과 나머지 데이터를 이용해 로컬 DB에 저장하도록 구현했다.

</details> 

<details><summary><big>✅ AVAssetImageGenerator</big></summary>
    
# AVAssetImageGenerator로 Thumbnail 만들기
> class 
> video asset에서 image를 만들어내는 객체

.mp4 포맷 영상의 썸네일을 구하기 위해 `AVAssetImageGenerator`를 사용하였다.
이미지를 생성하기 위해 `Asset`이 필요하고 `Asset`을 구하기 위해 `URL`이 필요하다.
나는 녹화가 완료된 데이터(영상)을 `CoreData`에 저장하였는데 이때 `outPutURL(임시 URL)`에 담은 후 `Data`로 뽑아서 `Data`타입으로 저장을 하였다.
그래서 `CoreData`에 저장한 model 타입을 만들 때 `URL`이 이용되고 이때 썸네일을 뽑아서 같이 `CoreData`에 넣는 방법으로 구현했다.

### `URL`을 받아와서 `Asset`을 만들고 `AVAssetImageGenerator`를 이용하여 이미지를 뽑아내는 메서드를 구현

```swift
 private func generateThumbnail(from url: URL) -> Future<UIImage?, RecordingError> {
    return Future<UIImage?, RecordingError> { promise in
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1, preferredTimescale: 1)

            guard let cgImage = try? imageGenerator.copyCGImage(at: time, actualTime: nil) else {
                promise(.failure(.thumbnail))
                return
            }
            let thumbnailImage = UIImage(cgImage: cgImage)
            promise(.success(thumbnailImage))
        }
    }
}
```

- 나는 Combine을 사용하여 `Future`를 이용했다. (이렇게 쓰는게 맞나..?)
- UI를 방해하면 안되기 때문에 `DispatchQueue.global().async` 블록 안에 넣어주었다.
- `CMTime` : 1초로 정의 했다.
- `copyCGImage(at, actualTime:)` : cgImage를 구한다. 이 프로퍼티는 iOS16부터 사용할 수 없지만 이 앱의 타겟은 최소 iOS14버전이기 때문에 사용하였다.
- 마지막에 UIImage로 변경하여 success에 넣어주었다.


### Future를 구독하여 성공시 image를 받아 CoreData에 저장

```swift
private func fetchThumbnail(from videoRecordedURL: URL, videoData: Data, title: String) {
    generateThumbnail(from: videoRecordedURL)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        } receiveValue: { [weak self] image in
            if let image {
                guard let imageData = image.pngData(),
                      let playTime = self?.fetchPlayTime(videoRecordedURL.absoluteString) else { return }
                let video = Video(title: "\(title).mp4", date: Date(), savedVideo: videoData, thumbnailImage: imageData, playTime: playTime)
                self?.viewModel.create(video)
            }
        }
        .store(in: &cancellables)
}
```

제목 그대로 `Future`타입을 반환하는 메서드를 구독하여 실패와 성공 케이스로 나눠 성공했을 때 이미지를 받아와서 `CoreData`에 넣을 `model` 타입에 이미지를 같이 저장해주었다.
그리고 viewModel의 `create`를 실행해 실제 데이터를 로컬 DB에 저장했다.


### 녹화가 끝나고 실행되도록 구현

AVFoundation에는 `AVCaptureFileOutputRecordingDelegate` 가 있고 여기에 녹화가 종료되면 실행되는 메서드가 있다. 나는 녹화가 종료되면 썸네일을 가져오고 그걸 로컬DB에 저장하도록 했다.

```swift
func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        recordStackView.changeCameraModeButton.isEnabled = true
    if (error != nil) {
        print(error?.localizedDescription as Any)
    } else {
        guard let videoRecordedURL = outputURL,
              let videoData = try? Data(contentsOf: videoRecordedURL) else { return }
            
        let title = "영상의 제목을 입력해주세요."
        let save = "저장"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: save, style: .default) { [weak self] _ in
            guard let videoTitle = alert.textFields?[0].text else { return }
            self?.fetchThumbnail(from: videoRecordedURL, videoData: videoData, title: videoTitle)
            }
            
        alert.addTextField()
        alert.addAction(saveAction)
        self.present(alert, animated: true)
    }
}
```

- 추가적으로 비디오의 이름은 저장이 끝나면 Alert창이 뜨고 거기 TextField에 입력하여 얻은 text를 사용했다. Alert에 textField가 포함되어있어 쉽게 구현할 수 있었다.

</details>
    
    
<details><summary><big>✅ AVPlayerViewController</big></summary> 
    
# AVPlayerViewController
> Class
> playback 컨트롤을 위한 유저 인터페이스를 보여주고 플레이어로 부터 컨텐츠를 보여주는 viewController 

## Overview
AVKit프레임워크는 AVPlayerViewController subclassing을 지원하지 않는다.

- Airplay 지원
- Picture in Picture(PiP) 지원
PiP 재생을 통해 사용자는 비디오 플레이어를 작은 플로팅 창으로 최소화하여 기본 앱이나 다른 앱에서 다른 활동을 수행할 수 있다.
- tvOS Playback 경험 커스텀 지원

## 직접 구현하기

video를 플레이하려면 videoURL이 필요하다. 이 URL(filepath)을 AVPlayer(url:)에 넣어주어 플레이하도록 해야하는데 여기서 트러블슈팅이 있었다.

- 🔍 저장하는 Model 타입에 URL을 통해 썸네일을 저장하니 URL을 같이 저장해서 이 URL을 사용해보자 

처음 이렇게 접근했는데, 앱을 종료하고 다시 실행하니 동영상 재생이 제대로 되지 않았다. 이유를 생각해보니 임시로 URL을 만들어서 이 URL이 변경되었나? 정확하지 않은가 의심했다.

```swift
func createVideoURL() -> URL? {
    let directory = NSTemporaryDirectory() as NSString
        
    if directory != "" {
        let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
        return URL(fileURLWithPath: path)
    }
        
    return nil
}
```

이렇게 임시Directory를 만들고 Filepath를 저장한 것이 문제인가 싶어서 FileManager를 이용해서 저장하는 방법으로 변경했다. 그러나 이마저도 해결되지 않았다.
URL은 앱을 다시 켰을 때와 처음과 동일했다. 결국 문제는 URL은 맞지만 그 안에 파일이 없다는게 문제였다. 생각해보니 CoreData에 영상을 저장했는데 filePath는 CoreData 위치와 맞지 않았다. 그냥 filePath만 일치했을 뿐...🥲 

### 해결방법

저장된 데이터의 url을 찾아야했는데 CoreData저장 위치를 일일히 알아내는 것은 힘들었다. 저장되고나서 아는건 되지만 계속해서 추적하기는 불가능했다. 
따라서 Data타입을 url로 변경하는 방법을 계속해서 찾아보았고 `write(to:options)` 메서드를 발견했다. 이는 데이터를 담아줄 url을 변수고 가지고 있다. 

- 새로운 임시 url을 만든다.
- 화면에 띄울 data를 url에 저장한다.
- 그 url을 player에 넣어주어 화면에 띄운다.

이렇게 하니까 앱을 종료하고 다시켜도 정상 작동하는 것을 확인했다.

```swift
import AVKit
...

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let videoEntity = viewModel.read(at: indexPath),
          let video = videoEntity.savedVideo,
          let videoURL = viewModel.createVideoURL() else { return }
        
    do {
        try video.write(to: videoURL)
        let playerController = AVPlayerViewController()
        let player = AVPlayer(url: videoURL)
        playerController.player = player
        playerController.entersFullScreenWhenPlaybackBegins = true
        self.present(playerController, animated: true) {
            player.play()
        }
    } catch let error {
        print(error.localizedDescription)
    }
}
```
</details>
    
<details><summary><big>✅ Future - Combine</big></summary> 
    
# Future, Combine
> Class
> single value를 생산하고 finish하거나 fail하는 publisher


## Overview
Future는 비동기적으로 single element를 publish할 때 사용한다. 클로저는 promise를 호출하여 성공인지 실패인지 결과를 전달한다.
성공인 경우 future의 다운스트림 구독자가 그 요소를 받고 error인 경우에 publishing을 종료한다.

```swift
func generateAsyncRandomNumberFromFuture() -> Future <Int, Never> {
    return Future() { promise in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let number = Int.random(in: 1...10)
            promise(Result.success(number))
        }
    }
}
```

Published value를 전달받을 때 subscriber를 이용하여 받는다.

```swift
cancellable = generateAsyncRandomNumberFromFuture()
    .sink { number in print("Got random number \(number).") }
```

</details>
    
<details><summary><big>✅ Firebase</big></summary> 
    
# Firebase
> CloudDB

## 설치하기

백업 용으로 CloudBD가 필요했고, Firebase를 사용하였다.
Firebase 사이트에 들어가면 Apple 프로젝트에 추가하는 방법이 자세히 나와있다.
- [Firebase 공식홈페이지](https://firebase.google.com/docs/ios/setup?hl=ko)

1. Firebase에 프로젝트 생성하기
2. Firebase에 앱 등록하기 (이때, 앱 번들 ID가 필요하다)
3. Firebase 구성 파일 추가
   - GoogleService-Info.plist 다운로드한다.
   - XCode에 추가한다.
4. 앱에 Firebase SDK를 추가한다.
   - SPM을 이용하여 Firebase 종속항목을 설치하고 관리한다.
   - Xcode -> File -> Add Packages
5. 앱에서 Firebase를 초기화한다.
   - UIApplicationDelegate에서 초기화해줌

```swift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
```

## 데이터 파일 저장 및 삭제하기

나는 동영상을 백업해야하므로 Firebase Storage를 활용했다.
- SPM에서 FirebaseFireStore, FirebaseStorage를 선택했다.

FirebaseStorage를 관리하는 객체를 하나 생성하고 그 객체를 통해 저장과 삭제를 관리하였다.

```swift
import FirebaseStorage
import Firebase

final class FirebaseStorageManager {
    static func uploadVideo(_ video: Data, id: UUID) {
        let metaData = StorageMetadata()
        metaData.contentType = ".mp4"
        
        let firebaseReference = Storage.storage().reference().child("\(id).mp4")
        firebaseReference.putData(video, metadata: metaData)
    }
    
    static func deleteVideo(id: UUID) {
        let firebaseReference = Storage.storage().reference().child("\(id).mp4")
        firebaseReference.delete { error in
            if let error = error {
                print("동영상 삭제 실패: \(error)")
            } else {
                print("동영상 삭제 성공")
            }
        }
    }
}

```

- 저장할 때 child안에 들어가는 것이 이름이 되고 .mp4를 이용해 확장자를 설정하였다.
- 삭제할 때는 title로 비교하면 같은 이름의 동영상을 구분하기 어려울 것 같아 고유한 식별자인 UUID를 이용하여 삭제하도록 하였다.

현재 localDB에 3개의 파일이 저장되어 있고 백업파일도 3개가 존재한다.
<img src="https://hackmd.io/_uploads/Sk2zt-7vh.png" width="600">


</details>
    
<br/>
    
# 참고 링크

## 공식문서

- [AppleDeveloper - AVPlayerViewController](https://developer.apple.com/documentation/avkit/avplayerviewcontroller)
- [AppleDeveloper - write(to:options)](https://developer.apple.com/documentation/foundation/data/1779858-write)
- [AppleDeveloper - AVAssetImageGenerator](https://developer.apple.com/documentation/avfoundation/avassetimagegenerator)
- [AppleDeveloper - copyCGImage(at:actualTime)](https://developer.apple.com/documentation/avfoundation/avassetimagegenerator/1387303-copycgimage)
- [AppleDeveloper - Creating images from a video asset](https://developer.apple.com/documentation/avfoundation/media_reading_and_writing/creating_images_from_a_video_asset)
- [AppleDeveloper - AVFoundation](https://developer.apple.com/documentation/avfoundation/)
- [AppleDeveloper - Capture setup](https://developer.apple.com/documentation/avfoundation/capture_setup)
- [AppleDeveloper - Future](https://developer.apple.com/documentation/combine/future)
- [Firebase 공식홈페이지](https://firebase.google.com/docs/ios/setup?hl=ko)
    
## 블로그
- [felix-mr.tistory](https://felix-mr.tistory.com/4)
- [moonibot.tistory](https://moonibot.tistory.com/43)
- [@heyksw velog](https://velog.io/@heyksw/iOS-AVFoundation-으로-custom-camera-구현)
- [jintaewoo.tistory](https://jintaewoo.tistory.com/43)
- [김종권님 tistory](https://ios-development.tistory.com/769)
