<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글싸기</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
<script
	src=" https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
<%@ include file="/WEB-INF/views/common/import.jsp"%>

<style>
.note-color-select {
	visibility: hidden;
}

.note-color-select::before {
	visibility: visible;
	content: '직접선택';
}
</style>
</head>

<body>
	<div class="container">
		<table>
			<tr>
				<td>작성자</td>
				<td><input type="text" readonly id="uiNickname" name="writer"
					value="${userInfo.uiNickname}"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" id="tbTitle" name="subject"></td>
			</tr>
			<tr>
				<td>지역</td>
				<td><input type="text" readonly id="tbAddr1" name="subject"
					value="${userInfo.addr}"></td>
			</tr>
			<tr>
				<td>취미</td>
				<td><select id="tbCategory">
						<option value="스포츠">스포츠</option>
						<option value="게임">게임</option>
						<option value="공지사항">공지사항</option>
				</select></td>
			</tr>
			<tr>
				<td colspan="2"><textarea class="summernote" id="tbContent"
						name="memo" style="resize: none"></textarea></td>
			</tr>
			<tr>
				<th colspan="2">
					<button onclick="insertBoard()">등록</button>
				</th>
			</tr>
		</table>
	</div>


	<script>

		$('.summernote').summernote({
			height:400,
			minheight:400,
			lang: 'ko-KR',
			focus: true,
			toolbar :[
				['fontname',['fontname']],
				['fontsize',['fontsize']],
				['style',['bold','italic','underline','strikethrough','clear']],
				['color',['forecolor','color']],
				['table',['table']],
				['para',['ul','ol','paragraph']],
				['height',['height']],
				['insert',['picture','link','video']],
				['view',['codeview','fullscreen','help']]
			],
			fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋음체','바탕체'],
			fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'],
			
			callbacks: {	//여기 부분이 이미지를 첨부하는 부분
				onImageUpload : function(files) {
					uploadSummernoteImageFile(files[0],this);
				},
				onPaste: function (e) {
					var clipboardData = e.originalEvent.clipboardData;
					if (clipboardData && clipboardData.items && clipboardData.items.length) {
						var item = clipboardData.items[0];
						if (item.kind === 'file' && item.type.indexOf('image/') !== -1) {
							e.preventDefault();
						}
					}
				}
			}
		
		});

		
		function uploadSummernoteImageFile(file, editor) {
			data = new FormData();
			data.append("file", file);
			$.ajax({
				data : data,
				type : "POST",
				url : "/uploadSummernoteImageFile",
				contentType : false,
				processData : false,
				success : function(data) {
	            	//항상 업로드된 파일의 url이 있어야 한다.
					$(editor).summernote('insertImage', data.url);
				}
			});
		}
		
		$("div.note-editable").on('drop',function(e){
	         for(i=0; i< e.originalEvent.dataTransfer.files.length; i++){
	         	uploadSummernoteImageFile(e.originalEvent.dataTransfer.files[i],$("#summernote")[0]);
	         }
	        e.preventDefault();
	   })
	
		function insertBoard(){
			const param = {};
			param.uiNickname = document.querySelector('#uiNickname').value;
			param.tbTitle = document.querySelector('#tbTitle').value;
			param['tbContent'] = document.querySelector('#tbContent').value;
			param.tbCategory = document.querySelector('#tbCategory').value;
			param.tbAddr1 = document.querySelector('#tbAddr1').value;
			
			fetch('/test-board/insert',{
				method:'POST',
				headers : {
					'Content-Type' : 'application/json'
				},
				body : JSON.stringify(param)
			})
			.then(async function(res){
				if(res.ok){
					return res.json();
				}else{
					const err = await res.text();
					throw new Error(err);
				}
			})
			.then(function(data){
				if(data===1){
					alert('정상등록 되었습니다.');
					location.href='/views/test-board/list';
				}
				
			})
			.catch(function(err){
				alert(err);
			});
		}
		
		window.onload = function(){
		// 	if('${empty userInfo}'){
		// 		alert('로그인 해주세요')
		// 		location.href='/views/test-board/list';
		// 	}
		console.log('${userInfo}')
		}
	</script>

</body>
</html>