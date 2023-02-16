<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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

</head>

<style>
.note-color-select {
	visibility: hidden;
}

.note-color-select::before {
	visibility: visible;
	content: '직접선택';
}
</style>

<body>

	<div class="container">
		<table>
			<tr>
				<td>작성자</td>
				<td><input type="text" readonly id="uiNickname" name="writer"></td>
			</tr>
			<tr>
				<td>제목</td>
				<td><input type="text" id="tbTitle" name="subject"></td>
			</tr>
			<tr>
				<td>지역</td>
				<td><input type="text" id="tbAddr1" name="subject"></td>
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
					<button onclick="updateBoard()">등록</button>
				</th>
			</tr>
		</table>
	</div>

	<script>
		$('.summernote').summernote(
				{
					height : 150,
					lang : 'ko-KR',
					focus : true,
					toolbar : [
							[ 'fontname', [ 'fontname' ] ],
							[ 'fontsize', [ 'fontsize' ] ],
							[
									'style',
									[ 'bold', 'italic', 'underline',
											'strikethrough', 'clear' ] ],
							[ 'color', [ 'forecolor', 'color' ] ],
							[ 'table', [ 'table' ] ],
							[ 'para', [ 'ul', 'ol', 'paragraph' ] ],
							[ 'height', [ 'height' ] ],
							[ 'insert', [ 'picture', 'link', 'video' ] ],
							[ 'view', [ 'codeview', 'fullscreen', 'help' ] ] ],
					fontNames : [ 'Arial', 'Arial Black', 'Comic Sans MS',
							'Courier New', '맑은 고딕', '궁서', '굴림체', '굴림', '돋음체',
							'바탕체' ],
					fontSizes : [ '8', '9', '10', '11', '12', '14', '16', '18',
							'20', '22', '24', '28', '30', '36', '50', '72' ]
				});

		function updateBoard() {

			const param = {};
			param.tbTitle = document.querySelector('#tbTitle').value;
			param.tb = document.querySelector('#uiNickname').value;
			param['tbContent'] = document.querySelector('#tbContent').value;
			param.tbAddr1 = document.querySelector('#tbAddr1').value;
			param.tbCategory = document.querySelector('#tbCategory').value;

			fetch('/test-board/${param.tbNum}', {
				method : 'PATCH',
				headers : {
					'Content-Type' : 'application/json'
				},
				body : JSON.stringify(param)
			}).then(function(res) {
				return res.json();
			}).then(function(data) {
				if (data === 1) {
					alert('수정완료');
					location.href = '/views/test-board/list';
				}
			});
		}

		window.onload = function() {

			fetch('/test-board/${param.tbNum}').then(function(res) {
				return res.json();
			}).then(function(data) {
				document.querySelector('#tbTitle').value = data.tbTitle;
				document.querySelector('#uiNickname').value = data.uiNickname;
				document.querySelector('#tbAddr1').value = data.tbAddr1;
				document.querySelector('#tbCategory').value = data.tbCategory;
				$('.summernote').summernote('pasteHTML', data.tbContent);
				console.log(document.querySelector('#uiNickname').value);
				if ('${userInfo.uiNickname}' !== data.uiNickname) {
					alert('올바르지 못한 접근입니다');
					location.href = '/views/test-board/list';
				}
			});
		}
	</script>

</body>
</html>