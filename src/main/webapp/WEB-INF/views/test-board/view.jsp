<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<%@ include file="/WEB-INF/views/common/import.jsp"%>



<style>
.container {
	margin-top: 10px;
}

#btn {
	float: right;
	margin-top: 10px;
}

#comment {
	padding-top: 10px;
}

.card {
	margin-top: 80px;
}

#commentBtn {
	float: right;
	margin-top: 10px;
}

#recommendBtn {
	margin-left: 40%;
	margin-bottom: 10px;
}
</style>

</head>
<body>


	<div class="container">
		<div class="card">
			<div class="card-body">
				<span class="card-text"> <small class="text-muted"
					id="uiNickname"></small> <!--글쓴이--> <small class="text-muted"
					id="tbAddr1"></small>
				</span>
				<h5 class="card-title"></h5>
				<!--제목-->
				<span class="card-text"> <small class="text-muted"
					id="tbCategory"></small> <!--카테고리-->
				</span> <span class="card-text"> <small class="text-muted"
					id="tbCnt"></small> <!--조회수-->
				</span>
				<p class="card-text">
					<small class="text-muted">최종 수정일</small> <small class="text-muted"
						id="tbModdat"></small>
					<!--날짜-->
				</p>
				<p class="card-text">
					<small class="text-muted">추천수</small> <small
						class="text-muted tbRecommend"></small>
					<!--날짜-->
				</p>
				<p class="card-text" id="tbContent"></p>
				<!--내용-->
			</div>

			<div id="recommendBtn">
				<button class="btn btn-primary" onclick="recommend(this)">추천</button>
				<span id="tbRecommend"></span>
				<button class="btn btn-primary" onclick="recommend(this)">비추천</button>
			</div>

		</div>


		<div id="btn" style="display: none;">
			<button class="btn btn-primary"
				onclick="location.href = '/views/test-board/update?tbNum=${param.tbNum}'">수정</button>
			<button class="btn btn-primary" data-bs-toggle="modal"
				data-bs-target="#deleteModal">삭제</button>
		</div>

		<!-- Modal -->
		<div class="modal fade" id="deleteModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h1 class="modal-title fs-5" id="exampleModalLabel">알림</h1>
						<button type="button" class="btn-close" data-bs-dismiss="modal"
							aria-label="Close"></button>
					</div>
					<div class="modal-body">정말 삭제하시겠습니까?</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">취소</button>
						<button type="button" class="btn btn-primary"
							onclick="deleteTestBoard()">삭제</button>
					</div>
				</div>
			</div>
		</div>

		<!-- 댓글리스트 -->
		<div class="card">
			<div class="card-header">댓글 목록</div>
			<ul id="reply-box" class="list-group">
				<c:forEach items="${boardCommentList}" var="boardComment">
					<li style="position: relative;"
						class="list-group-item d-flex justify-content-between">
						<p style="display: none">${boardComment.bcNum}<br>
						</p>
						<div style="font-family: Roboto;">${boardComment.uiNickname}<br>
							<div>${boardComment.bcContent}</div>
							<div class="collapse form-group"
								id="collapseExample${boardComment.bcNum}">

								<textarea placeholder="댓글 수정" class="form-control" rows="3"
									cols="100%" id="updateBc${boardComment.bcNum}"
									style="resize: none;">${boardComment.bcContent}</textarea>
								<i
									style="cursor: pointer; position: absolute; margin: -22px 0 0 6px;"
									onclick="updateComment(${boardComment.bcNum})"
									class="fa-sharp fa-solid fa-pen-nib"></i>

							</div>
						</div> <c:if test="${userInfo.uiNickname eq boardComment.uiNickname}">
							<div class="form-group" style="float: right">
								<i style="cursor: pointer;" class="fa-regular fa-pen-to-square"
									data-bs-toggle="collapse"
									href="#collapseExample${boardComment.bcNum}" role="button"
									aria-expanded="false" aria-controls="collapseExample"></i> <i
									style="cursor: pointer;"
									onclick="deleteComment(${boardComment.bcNum})"
									class="fa-solid fa-trash-can"></i>
							</div>

						</c:if>
					</li>

				</c:forEach>

			</ul>
		</div>




		<div class="form-group" style="margin-bottom: 70px">
			<label>댓글 작성</label>
			<textarea class="form-control" id="bcContent" rows="3"
				style="resize: none;"></textarea>
			<button type="button" class="btn btn-primary" id="commentBtn"
				onclick="insertComment()">댓글 작성</button>
		</div>

		<div class='next'></div>
		<div class='prev'></div>


	</div>





	<script>
	
	
		window.onload = function(){
			fetch('/test-board/${param.tbNum}')
			.then(function(res){
				return res.json();
			})
			.then(function(boardInfo){
				if(boardInfo.tbActive === 0){
					alert('잘못된 접근입니다');
				}
				console.log(boardInfo)
				document.querySelector('#tbCnt').innerHTML = boardInfo.tbCnt;
				document.querySelector('#tbCategory').innerHTML = boardInfo.tbCategory;
				document.querySelector('#uiNickname').innerHTML = boardInfo.uiNickname;
				document.querySelector('#tbAddr1').innerHTML = boardInfo.tbAddr1;
				document.querySelector('.card-title').innerHTML = boardInfo.tbTitle;
				document.querySelector('#tbModdat').innerHTML = boardInfo.tbModdat;
				document.querySelector('#tbContent').innerHTML = boardInfo.tbContent;
				document.querySelector('#tbRecommend').textContent=boardInfo.tbRecommend;
				document.querySelector('.tbRecommend').textContent=boardInfo.tbRecommend;
				showBtn();
			});
			
			fetch('/test-board/next/${param.tbNum}')
			.then(function(res){
				return res.json();
			})
			.then(function(nextBoard){
				let html = '';
				if(nextBoard.tbTitle == null || nextBoard.tbTitle === ''){
					html += '<div class="list-group" style="margin-top: 70px;">';
					html += '<span style="font-weight: bold;">다음글</span>│';
					html += '<span style="color: blue;" id="nextTitle">다음글이 없습니다.</span>';
					html +='</div>';
					document.querySelector('.next').innerHTML = html;
				} else{
					html += '<div class="list-group" style="margin-top: 70px;">';
					html += '<a href="/board?tbNum=' + nextBoard.tbNum +'" class="list-group-item list-group-item-action nextNum">';
					html += '<span style="font-weight: bold;">다음글</span>│';
					html += '<span style="color: blue;" id="nextTitle">'+ nextBoard.tbTitle +'</span>';
					html += '</a>'
					html +='</div>';
					document.querySelector('.next').innerHTML = html;
				}
				
			});
			
			
			fetch('/test-board/prev/${param.tbNum}')
			.then(function(res){
				return res.json();
			})
			.then(function(prevBoard){
				let html = '';
				html += '<div class="list-group">';
				html += '<a href="/board?tbNum=' + prevBoard.tbNum +'" class="list-group-item list-group-item-action prevNum">';
				html += '<span style="font-weight: bold;">이전글</span>│';
				html += '<span style="color: blue;" id="prevTitle">'+ prevBoard.tbTitle +'</span>';
				html += '</a>'
				html +='</div>';
				document.querySelector('.prev').innerHTML = html;
			});


		}
		function showBtn(){
			console.log('=>'+document.querySelector('#uiNickname').innerHTML)
			if('${userInfo.uiNickname}' === document.querySelector('#uiNickname').innerHTML){
				document.querySelector('#btn').style.display = '';
				document.querySelector('#recommendBtn').style.display = 'none';
			}
			
		}
		
		function recommend(obj){
			
			if('${userInfo.uiNickname}'=== '' || '${userInfo.uiNickname}'=== null){
				alert('로그인 해주세요')
				return;
			}
			const param = {
					tbNum : '${param.tbNum}',
					uiNickname : '${userInfo.uiNickname}'
			}
			
			fetch('/test-board/recommend/'+obj.innerText,{
				method:'PUT',
				headers : {
					'Content-type' : 'application/json'
				},
				body : JSON.stringify(param)
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data){
					alert(obj.innerText);
					location.reload();
				}
				if(!data){
					alert('이미 '+obj.innerText+'하셨습니다.');
				}
			})
			
		}
		
		
		function insertComment(){
			if('${userInfo.uiNickname}'=== '' || '${userInfo.uiNickname}'=== null){
				alert('로그인 해주세요')
				return;
			}
			
			let param ={};
			param.bcContent = document.querySelector('#bcContent').value;
			param.uiNickname = '${userInfo.uiNickname}';
			param.tbNum = '${param.tbNum}'
			
			fetch('/board-comment',{
				method : 'POST',
				headers :{
					'Content-Type' : 'application/json'
				},
				body : JSON.stringify(param)
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data===1){
					alert("작성완료");
					location.reload();
				} else{
					alert('작성실패');
				}
			})
		}
		
		function deleteComment(bcNum){
			
			fetch('/board-comment/delete/'+bcNum,{
				method : 'PATCH'
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data===1){
					
					alert('댓글삭제');
					location.reload();
				}
			});
		}

		function updateComment(bcNum){
			let param = {};
			param.bcContent = document.querySelector('#updateBc'+bcNum).value;
			console.log(bcNum);
			if(param.bcContent === null || param.bcContent === ''){
				alert('내용써');
				return;
			}
			fetch('/board-comment/'+bcNum, {
				method : 'PATCH',
				headers :{
					'Content-Type':'application/json'
				},
				body : JSON.stringify(param)
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				
				if(data===1){
					alert('수정완료');
					location.reload();
				}
			})

		}
		
		function deleteTestBoard(){
			fetch('/test-board/${param.tbNum}',{
				method:'DELETE'
			})
			.then(function(res){
				return res.json();
			})
			.then(function(data){
				if(data===1){
					alert('삭제완료');
					location.href = '/views/test-board/list';
				}
			});
		}
		
		
		
	</script>
</body>
</html>