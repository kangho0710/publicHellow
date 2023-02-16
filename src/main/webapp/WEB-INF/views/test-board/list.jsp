<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리스트</title>
<%@ include file="/WEB-INF/views/common/import.jsp"%>
</head>

<body>
	<main class="flex-shrink-0 p-3 col-lg-12 col-md-12 col-sm-12 col-12">

		<div class="container" style="margin-top: 20px; margin-bottom: 20px;">
			<%@ include file="/WEB-INF/views/common/sidebar.jsp"%>
			<ul class="nav nav-tabs" style="margin-bottom: 20px">
				<li class="nav-item"><a class="nav-link active"
					aria-current="page" href="/views/test-board/list">전체보기</a></li>
				<li class="nav-item"><a type="button"
					class="nav-link tbCategory" data-bs-toggle="tab"
					onclick="getBoardLists()">인기글</a></li>
				<li class="nav-item"><a type="button"
					class="nav-link tbCategory" data-bs-toggle="tab"
					onclick="getBoardLists()">스포츠</a></li>
				<li class="nav-item"><a type="button"
					class="nav-link tbCategory" data-bs-toggle="tab"
					onclick="getBoardLists()">게임</a></li>
			</ul>

			<table class="table" border="1">
				<tr>
				<thead class="table-dark">
					<th data-col="tbNum">번호</th>
					<th data-col="tbCategory">카테고리</th>
					<th data-col="tbAddr1">지역</th>
					<th data-col="uiNickname">작성자</th>
					<th data-col="tbTitle">제목</th>
					<th data-col="tbCnt">조회수</th>
					<th data-col="tbModdat">작성일</th>
					<th data-col="tbRecommend">추천수</th>
				</thead>
				</tr>
				<tbody id=nBody class="table-group-divider"></tbody>
				<!-- 공지사항만 받아올 곳 페이징 관계x -->
				<tbody id=rBody class="table-group-divider"></tbody>
				<!-- 인기글만 받아올 곳 페이징 관계x -->
				<tbody id=tBody class="table-group-divider"></tbody>
			</table>
			<button onclick="goInsert()" class="btn btn-primary"
				style="float: right;">글쓰기</button>
			<br>
			<nav aria-label="Page navigation example">
				<ul class="pagination justify-content-center" id="paging">

				</ul>
			</nav>


			<button id="dropdown"
				class="btn btn-outline-secondary dropdown-toggle" type="button"
				data-bs-toggle="dropdown" aria-expanded="false"
				style="width: 100px; height: 35px; border-radius: 0px;">제목</button>
			<ul class="dropdown-menu">
				<li><a class="dropdown-item" onclick="getValue(this)">제목</a></li>
				<li><a class="dropdown-item" onclick="getValue(this)">제목+내용</a></li>
				<li><a class="dropdown-item" onclick="getValue(this)">글쓴이</a></li>
				<li><a class="dropdown-item" onclick="getValue(this)">지역</a></li>
			</ul>
			<input id="searchValue" type="text" class="col-md-3"
				style="height: 35px; width: 200px;"
				aria-label="Text input with dropdown button">
			<button type="button" class="btn btn-outline-primary"
				onclick="getBoardLists()">검색</button>

			<!-- <input type = "text" id = "tbTitle" placeholder = "제목">
			<input type = "text" id = "tbContent" placeholder = "내용">
			<button onclick = "getBoardLists()">조회</button> -->
		</div>
	</main>
	<script>
	function getNoticeList(){ //공지사항만 가져옴 페이징 관계x 
		fetch('/test-board/getNotice')
		.then(function(res){
			return res.json();
		})
		.then(function(data){
			let html = '';
			for(let i=0; i<data.length; i++){
				const boardList = data[i]
				html +='<tr>';
				html +='<td>' + boardList.tbNum + '</td>';
				html +='<td><b>' + boardList.tbCategory + '</b></td>';
				html +='<td>' + boardList.tbAddr1 + '</td>';
				html +='<td><b>' + boardList.uiNickname + '</b></td>';
				html +='<td><b><a href="/board?tbNum=' + boardList.tbNum+ '">' + boardList.tbTitle + '</b></a></td>';
				html +='<td>' + boardList.tbCnt + '</td>';
				html +='<td>' + boardList.tbCredat + '</td>';
				html +='<td>' + boardList.tbRecommend + '</td>';
				html += '</tr>';
			}
			document.querySelector('#nBody').innerHTML = html;
		})
	}
	
	function getRecommendList(){
		fetch('/test-board/getRecommend')
		.then(function(res){
			return res.json();
		})
		.then(function(data){
			let html = '';
			for(let i=0; i<data.length; i++){
				const boardList = data[i]
				html +='<tr class="table-primary"">';
				html +='<td>' + boardList.tbNum + '</td>';
				html +='<td><b>' + boardList.tbCategory + '</b></td>';
				html +='<td>' + boardList.tbAddr1 + '</td>';
				html +='<td><b>' + boardList.uiNickname + '</b></td>';
				html +='<td><b><a href="/board?tbNum=' + boardList.tbNum + '">' + boardList.tbTitle + '</a></b></td>';
				html +='<td><b>' + boardList.tbCnt + '</b></td>';
				html +='<td>' + boardList.tbCredat + '</td>';
				html +='<td>' + boardList.tbRecommend + '</td>';
				html += '</tr>';
			}
			document.querySelector('#rBody').innerHTML = html;
		});
	}
	
	function getBoardLists(nowPage){
		let now = 1; // 현재 페이지
		const bottomSize = 10; // 하단 사이즈
		const listSize = 15; // 한번에 보여줄 게시물 수

		const dropdown = document.querySelector('#dropdown').innerHTML
		const searchValue = document.querySelector('#searchValue').value

		if(typeof nowPage ==='number' && nowPage > 0){
			now = nowPage;
		}
		let url = '/test-board?tbTitle='
		switch(dropdown){
			case '제목': url += searchValue 
			break;
			case '제목+내용': url += searchValue + '&tbContent=' + searchValue 
			break;
			case '글쓴이' : url +='&uiNickname='+ searchValue 
			break;
			case '지역' : url +='&tbAddr1=' + searchValue 
			break;
		}
		// url += '&tbContent=' + document.querySelector('#tbContent').value //내용검색
		
		if(document.querySelector('a[aria-selected]')){ //카테고리별로 보기
		 url += '&tbCategory=' + document.querySelector('a[aria-selected=true]').innerHTML;
		}
		
		url += now==1? '&nowPage=0': '&nowPage='+((now-1)*listSize);
		console.log(url);
		const cols = document.querySelectorAll('th[data-col]');
		
		fetch(url)
		.then(function(res){
			if(res.ok){
				return res.json();
			} else throw new Error('');
		}).then(function(data){
			
			let total = data[0].totalSize;  // 전체 게시글 수
			let totalPageSize = Math.ceil(total/listSize); // 하단 전체 사이즈
			let firstBottomNumber = now - now % bottomSize + 1; // 하단 최초 숫자
			let lastBottomNumber = now - now % bottomSize + bottomSize // 하단 마지막 숫자
			
			if(lastBottomNumber > totalPageSize){
				lastBottomNumber = totalPageSize;
			}
			console.log('now',now);
			
			let page = '<li class="page-item"><a class="page-link" href="#" onclick="getBoardLists('+((now-bottomSize)<firstBottomNumber? (now-bottomSize):firstBottomNumber)+')">PREV</a></li>';
			for(let i=firstBottomNumber; i<=lastBottomNumber; i++){
				if(i === nowPage){
					page += '<li style="cursor:pointer;"class="page-item"><a class="page-link active" onclick="getBoardList('+i+');">'+i+'</a></li>';
					continue;
				}
				page += '<li class="page-item"><a class="page-link" href="#" onclick="getBoardLists('+i+')">'+i+'</a></li>';
			}
			page += '<li class="page-item"><a class="page-link" href="#" onclick="getBoardLists('+((now+bottomSize)<lastBottomNumber? (now+bottomSize):lastBottomNumber)+')">NEXT</a></li>';
			document.querySelector('#paging').innerHTML = page;
			
			let html = '';
			
			for(let obj of data){
				html += '<tr>';
				for(let col of cols){
					if(col.getAttribute('data-col') === 'tbTitle') {
						html += '<td style="cursor:pointer;" onclick=\"location.href=\'/board?tbNum='+obj.tbNum+'\'\">'+obj[col.getAttribute('data-col')]+'</td>';
						continue;
					}
					html += '<td>'+obj[col.getAttribute('data-col')]+'</td>';
				}
				html += '</tr>';
			}
			document.querySelector('#tBody').innerHTML = html;
		})
		.catch(()=>{
			
		})
	}
		window.onload = function(){
			getNoticeList();
			getRecommendList();
			getBoardLists(1);
		}

		function goInsert(){
			if('${userInfo.uiNickname}'=== '' || '${userInfo.uiNickname}'=== null){
				alert('로그인 해주세요')
				location.href='/';
			} else{
				location.href='/views/test-board/insert';
			}
		}
		function getValue(self){
			document.querySelector('#dropdown').innerHTML = self.innerHTML
		}


	</script>

</body>
</html>