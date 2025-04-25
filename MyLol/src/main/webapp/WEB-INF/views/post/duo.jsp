<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>듀오 모집 게시판</title>
    
</head>
<body>
    <div class="container mt-4">
        <h1 class="mt-3">듀오 모집 게시판</h1>
        <h4>해야할 부분</h4>
        <ul>
            <li>게시글 목록 가져오기</li>
            <li>position_board와 관련있어 보임</li>
            <li>position 이건 position_board를 참조하고 있네</li>
            <li>일단 진짜 해야할 부분은 게시글 작성, 수정, 삭제임</li>
            <li>작성할 때에는 카테고리가 그냥 정해져있는건가? 그렇다면 뭘로 되어있는지 확인해보기</li>
            <li>작성 양식은 제목, 내용, 가고자하는 라인, 계정 정보(닉네임, 태그) => 티어, 모스트픽 3개 가져옴</li>
            <li>계정 정보를 가져오려면 RiotApiService 기능 좀 쓰기</li>
            <li>회원정보에는 롤 닉네임과 태그가 없음.. SS가 있긴한데 참조되어있지도 않아서 이거 그냥 못쓴다고 봐야함</li>
            <li>getSummonerByRiotId => getSummonerByPuuid => getLOLLeagueInfo 이걸로 티어랑 점수까지는 가져올 수 있음.</li>
            <li>그럼 postDuoInsert 이런거 컨트롤러에서 만들 때 위 3개 메소드 써서 가져온걸 model로 보내야 하나? 아 애초에 회원 가입할 때 게임 닉네임과 태그를 입력받았어야 했음. 아님 수정에서라도..?</li>
        </ul>

        <h4 class="mt-4">게시글 목록</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th scope="col">닉네임</th>
                    <th scope="col">티어</th>
                    <th scope="col">가고자 하는 라인</th>
                    <th scope="col">모스트픽</th>
                    <th scope="col">상태</th>
                </tr>
            </thead>
            <tbody>
                <!-- 여기에 게시글 데이터 반복 -->
                <tr>
                    <td>멜 겅</td>
                    <td>E4</td>
                    <td>탑</td>
                    <td>챔프1, 챔프2, 챔프3</td>
                    <td>모집중</td>
                </tr>
                <tr>
                    <td>박사이디</td>
                    <td>E4</td>
                    <td>미드</td>
                    <td>챔프1, 챔프2, 챔프3</td>
                    <td>모집중</td>
                </tr>
                <!-- 추가 데이터는 반복문을 통해 동적으로 삽입 -->
            </tbody>
        </table>
    </div>

    <footer class="footer">
        <div>© 2025 듀오 모집 게시판</div>
    </footer>
</body>
</html>
