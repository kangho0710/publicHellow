# Hellow
- https://ckh.hellowu.co.kr/


![메인](https://user-images.githubusercontent.com/115143610/219283335-1d9089fc-7781-404b-84cd-24364d2fd618.PNG)

- 사용자가 게시판 생성요청을 하고 관리자가 수락 시 자동으로 그에 맞는 게시판을 생성해 주는 커뮤니티 사이트 MVC패턴 사용


1. 사용기술 및 개발환경
 - JAVA 11
 - JSP
 - SpringBoot 2.7
 - MariaDB
 - CSS
 - JavaScript(ajax)
 - AWS EC2,RDS
 - Jenkins
 - eclipse
 - visual studio code
 - gradle
 - git hub

2. 일정
 - 2023.01.16 ~ 2023.02.09

3. 구현
 - 회원가입, 비밀번호 찾기에서 등록한 email로 코드발송, 발송한 코드를 정확히 입력시에만 후속 조치 가능하도록 구현
 - 일반 이용자는 게시판 신청시 한글명과 영어명을 입력
 - 한글명은 사이트에 보이는 게시판 이름으로 등록되며 영어명은 DB에 생성
 - 메인화면에서는 카테고리마다 있는 모든 게시판 중 4가지의 게시판 글을 추천수가 많은 순으로 5개씩 불러올 수 있도록 구현
 - 웹소켓을 이용하여 현재 이용자 수, 댓글 알림, 팔로워와 팔로잉 여부 알람 구현
 - 팔로워(나를 팔로잉 하는 유저들) 리스트에서 만약 내가 팔로우 하지 않았다면 팔로우 할 수 있도록 버튼 추가, 이미 내가 팔로우 한 상태라면 언팔로우 버튼으로 변환
 - 마이페이지에서는 유저가 작성한 글들을 볼수 있도록 클릭시 해당 게시판으로 이동
 - 게시판의 추천, 비추천은 로그인한 유저가 한번만 가능하도록 구현
 - 게시글은 Active가 1인 것만 보여주도록 구현
 - 게시글 삭제시 Active를 0으로 만들어 보이지 않도록 구현
 - summernote를 사용하여 게시글 작성, 수정을 구현하되 이미지 업로드의 경우 외부경로를 따로 잡아주어 DB에 url로 등록되도록 설정

4. 용어정의
 1) Board
  - 게시판
  - List : 게시판 리스트
  - insert : 게시글 작성
  - select : 게시글 보기
  - update : 게시글 수정
  - recommend : 게시글 추천,비추천
  - delete : 게시글 삭제
  - getPrev : 이전글
  - getNext : 다음글
  - uploadSummernoteImageFile: 이미지 업로드 기능

 2) Email
  - 인증코드 전송하는 이메일
  - codeSender : 랜덤으로 만들어진 인증코드 발송
  - codeChecker : 인증코드가 맞는지 확인
 
 3) RealBoardComment
  - 댓글
  - getCommentList : 댓글 리스트 불러오기
  - insertBoardComment : 댓글 작성
  - updateBoardComment : 댓글 수정
  - deleteBoardComment :댓글 삭제
 
 4) Table
  - 게시판 생성
  - createBoard : 요청받은 게시판 양식에 맞춰 게시판 생성
  - createBoardComment : 생성된 게시판의 댓글
  - createBoardRecommend : 생성된 게시판의 추천
  - selectBoardRequestList : 받은 게시판 생성요청 리스트
  - deleteBoardRequest : 생성요청 거절
  - getSidebarMenu : 상단 바에 생성한 게시판 이름 생성
  - getBoardColumnNames : DB에 지정한 column이름 등록
  - checkRequester : 게시판 생성요청 승인
  - getFiveRandomBoardList : 메인화면에 무작위 게시판 글 5개씩 출력
  - getEveryPost : 내가쓴 글 보기
 
 5) UserFollower
  - 팔로우기능
  - countFollowers : 팔로워 수
  - countFollowing : 팔로잉 수
  - insertFollow : 팔로우
  - deleteFollow : 언팔로우
  - selectFollowingUser : 팔로잉 리스트(내가 팔로우한 유저)
  - selectFollowUser : 나를 팔로우한 유저
  - isFollowed : 내가 팔로우했는지 여부
 
 6) UserInfo
  - 유저정보
  - getUserInfo : 로그인
  - userInfoFormChecker : id 양식 확인
  - userProfileImgSaver : 프로필이미지 업로드
  - sendForm : 회원가입 양식 제출
  - modifyUserInfo : 회원정보 수정
  - profileChecker : 회원정보 수정 이전 비밀번호 확인
  - updateUserPwdByEmail :회원정보 수정
  - duplicationChecker : 닉네임 중복확인
  - deleteUserInfo : 회원탈퇴
  - kakaoSignIn : 카카오 이메일 로그인
  - addrCutter : 주소자르기 (ex: 서울시 도봉구 도봉로~ 라면 서울시 도봉구 까지만 보이게)
  - getUserProfileInfo : 유저간 프로필
