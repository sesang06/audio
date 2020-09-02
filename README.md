rxSwift, mvvm 오디오  어플리케이션

# 설치법

1. Xcode 를 설치합니다.
2. 레포지터리를 엽니다.
3. SPM 가 외부 라이브러리를 가져올 때까지 잠시 기다립니다.
4. iPhone Simulator 등으로 빌드합니다.

# 사용한 서드 파티 라이브러리

- RxSwift, RxCocoa [https://github.com/ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift)
    - mvvm 패턴을 구현하기 위해서 사용했습니다.
- Alamofire [https://github.com/Alamofire/Alamofire](https://github.com/Alamofire/Alamofire)
    - 서버와 네트워크 통신할 때 사용했습니다.
- Moya, RxMoya [https://github.com/Moya/Moya](https://github.com/Moya/Moya)
    - Alamofire와 RxSwift 간에 네트워크 레이어로 서비스를 만들기 위해서 사용했습니다.
- SnapKit [https://github.com/SnapKit/SnapKit](https://github.com/SnapKit/SnapKit)
    - 오토 레이아웃으로 뷰를 작성하기 위해서 사용했습니다.
- Kingfisher [https://github.com/onevcat/Kingfisher](https://github.com/onevcat/Kingfisher)
    - 이미지를 다운로드하기 위해서 사용했습니다.
- SwiftyJSON [https://github.com/SwiftyJSON/SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
    - 서버에서 내려받은 json 데이터를 모델로 매핑하기 위해서 사용했습니다.

# 구현내용

- **AudioListViewModel**
    - 핵심 비즈니스 로직을 처리하는 뷰모델입니다. 네트워크 처리나 오디오 재생 등의 도메인(유즈케이스)는 생성할 때 의존성 주입받습니다.
- **Domain(UseCase)**
    - **AudioService**
        - 모야로 구현된 통신 도메인입니다. 서버에서 음원 목록과 url 프리픽스를 가져와서 Single로 방출합니다.
    - **AudioDownloadService**
        - 리모트에 있는 mp3 파일을 알라모파이어로 다운받습니다. 만약 기존에 다운로드받은 것이 있다면, 다시 다운로드하지 않습니다. 다운받으면 로컬의 mp3 파일 경로를 반환합니다.
    - **AudioPlayService**
        - AVFoundation 프레임워크에 의존되어 있습니다. 로컬의 mp3 파일을 재생하거나, 일시 정지하거나, 15초로 되감거나 앞으로 뛰어넘는 처리를 실행합니다.
- **ViewController**
    - ViewModel과 엮여 있는 UIKit 의존 뷰입니다. 사용자가 재생, 일시정지, 다음 등의 버튼을 누르거나, 셀을 누르거나, 앱을 킨 것과 같은 입력을 하면 뷰모델에 넣습니다. 그 결과로 뿌려야 하는 UI 정보를 구독하여 화면에 표시합니다.
