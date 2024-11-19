<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&display=swap"
	rel="stylesheet">
<script>
$(function() {
 // Close, X 버튼 클릭하면 모달창 종료
    $('.modalCloseBtn').click(function() {
       $('#myModal').hide(100);
    });
    
 });
 
function showRemoveModal() {   
    let boardNo = $('#boardNo').val();
    $('.modal-body').html(boardNo + "번 글을 삭제하시겠습니까?");
    $('#myModal').show(500); // .show() 괄호 안에 숫자를 넣으면 m/s단위로 애니메이션 추가됨
 }
 
 function saveReply() {
	// textarea에서 댓글 내용 가져오기
	let content = $('#comment').val();
	// boardNo 값을 가져옴
	let boardNo = $('#boardNo').val();
	
	if (!content.trim()) {
        alert('댓글을 입력해주세요!');
        return;
    }
	
	// AJAX로 controller에 데이터 전송
    $.ajax({
        type: "POST",
        url: "/board/saveReply",
        contentType: "application/json; charset=UTF-8",
        data: JSON.stringify({
            boardNo: boardNo,
            content: content
        }),
        success: function(response) {
            alert("댓글이 저장되었습니다.");
            location.reload(); // 페이지를 새로고침하여 댓글 목록을 업데이트
        },
        error: function(error) {
            alert("댓글 저장에 실패했습니다.");
        }
    });
 }
 
 function editReply(replyNo, element) {
	
	console.log(replyNo);
	console.log(element);
	
	// element에서 data-reply-content 속성 값을 가져옴
    const replyContent = $(element).closest('.reply-item').data('reply-content');

	
	 let output = `<div class="modifyReplyArea" style="display: flex; align-items: center; width: 100%;">`;
	 
	 output += `<input type="text" class="form-control" id="modifyReplyContent" placeholder="\${replyContent}" style="position: relative; display: inline-block; width: 90%; margin-right: 10px;"/>`
	 
	 output += `<div class="badges" style="display: flex; gap: 5px;">`;
	 output += `<span class="badge rounded-pill bg-primary" onclick="return modifyReplySave(\${replyNo}, this);"/>저장</span>`;
	 output += `<span class="badge rounded-pill bg-secondary" onclick="cancelEdit(this, '\${replyContent}');"/>취소</span>`;
	 output += `</div>`;
	 
	 output += `</div>`;
	 
	// 해당 댓글 영역에 수정 폼 표시
	$(element).closest('.reply-item').find('.reply-text').html(output);
 }
 
//취소 버튼 클릭 시 원래 댓글 내용으로 복원하는 함수
 function cancelEdit(element, replyContent) {
     $(element).closest('.reply-item').find('.reply-text').html(replyContent);
 }
 
 function modifyReplySave(replyNo, element) {
	 let content = $('#modifyReplyContent').val();
	 console.log(content);
	 console.log(replyNo);
	 
	 if(content == '' || content.length < 1 || content == null) {
		 alert('내용을 입력해주세요');
		 $('#modifyReplyContent').focus();
	 } else {
		 const modifyReply = JSON.stringify({
			replyNo : replyNo,
			content : content
		 });
		 
		 $.ajax({
			url : '/board/modifyReply',
			type : 'post',
			contentType: 'application/json',
			data : modifyReply,
	        async : false,
			statusCode : {
				200 : function() {
					alert('수정 성공');
					// 수정된 댓글 내용으로 변경
                    $(element).closest('.reply-item').find('.reply-text').html(content);
                    // 수정 폼 숨기기
                    $(element).closest('.reply-item').find('.modifyReplyArea').hide();
			 	}, 406 : function() {
			 		alert('수정실패');
			 		}
			 	}
			 
		 });
		 
	 }
 }
 
 function deleteReply(replyNo, element) {
	console.log('삭제할 댓글 번호 : ', replyNo);
	 
	if (!confirm('해당 댓글을 삭제하시겠습니까?')) {
	    return; // 사용자가 취소하면 함수 종료
	}

	    $.ajax({
	        url: '/board/removeReply',
	        type: 'post', // POST 요청
	        contentType: 'application/json', // JSON 형식으로 전송
	        data: JSON.stringify(replyNo), // 댓글 번호를 JSON 형태로 전송
	        success: function(response) {
	        	 alert(response.message); // 서버 응답의 메시지를 알림으로 표시
	             $(element).closest('.reply-item').remove(); // 댓글 삭제 후 UI에서 제거
	        },
	        error: function(xhr, status, error) {
	        	alert('삭제 실패');
	            console.error('댓글 삭제 실패:', xhr.responseText);
	        }
	        	
	    });
 }

 
</script>
<style>
* {
	font-family: "Gowun Batang";
	font-size: normal;
}

.content {
	margin-top: 10px;
	margin-bottom: 10px;
	border: 1px solid #dee2e6;
	border-raidus: 0.375rem;
	padding: 10px;
}

.reply-item {
	position: relative; /* 자식 요소를 절대 위치로 배치할 수 있도록 부모를 상대 위치로 설정 */
	padding-bottom: 20px; /* 날짜를 배치할 공간을 위해 하단 여백 추가 */
}

.reply-content {
	display: flex; /* flexbox를 사용하여 자식 요소들을 수평으로 배치 */
	/* 요소 사이에 공간을 균등하게 분배 */
	align-items: center; /* 수직 가운데 정렬 */
}

.reply-date {
	font-size: 12px; /* 작은 글씨 크기 */
	color: gray; /* 글씨 색을 회색으로 */
	margin-left: 10px; /* replyer와 날짜 사이의 간격 */
}
</style>
</head>
<body>
	<div class="container">
		<c:import url="./../header.jsp" />

		<div class="container">
			<h2 style="text-align: center; margin-top: 15px;">[${board.writer}]의
				게시글</h2>

			<div class="boardInfo">

				<div class="mb-3" style="display: none;">
					<label for="boardNo" class="form-label">글 번호</label> <input
						type="text" class="form-control" id="boardNo"
						value="${board.boardNo}" readonly>
				</div>

				<div class="mb-3">
					<label for="title" class="form-label">제목</label> <input type="text"
						class="form-control" id="title" value="${board.title}" readonly>
				</div>

				<div class="mb-3">
					<label for="writer" class="form-label">작성자</label> <input
						type="text" class="form-control" id="writer"
						value="${board.writer}" readonly>
				</div>

				<div class="mb-3">
					<label for="postDate" class="form-label">작성일</label> <input
						type="text" class="form-control" id="postDate"
						value="${board.postDate}" pattern="yyyy/MM/dd hh:mm:ss" readonly>
				</div>
				<div class="mb-3">
					<label for="readCount" class="form-label">조회수</label> <input
						type="text" class="form-control" id="readCount"
						value="${board.readCount}" readonly>
				</div>
				<div class="mb-3">
					<label for="content" class="form-label">내용</label>
					<div class="content">${board.content}</div>
				</div>

			</div>
		</div>

		<div class="btns" style="text-align: right;">
			<c:if test="${board.writer == sessionScope.loginMember.userId}">
				<button type="button" class="btn btn-primary"
					onclick="location.href='/board/modifyBoard?boardNo=${board.boardNo}';">수정</button>
				<button type="button" class="btn btn-danger"
					onclick="showRemoveModal()">삭제</button>
			</c:if>
			<button type="button" class="btn btn-secondary"
				onclick="location.href='/board/list';">목록보기</button>
		</div>

		<div class="reply-list"></div>


		<div
			style="display: flex; justify-content: space-between; align-items: center; margin-top: 4em; margin-bottom: 3em;">
			<div class="form-floating" style="flex-grow: 1;">
				<textarea class="form-control" id="comment" name="text"
					placeholder="Comment goes here"></textarea>
				<label for="comment">댓글을 달아주세요!</label>
			</div>

			<div style="margin-left: 10px;">
				<img src="/resources/images/saveReply.png" onclick="saveReply();" />
			</div>
		</div>

		<div class="reply-list">
			<c:forEach var="reply" items="${reply}">
				<div class="reply-item" data-reply-content="${reply.content}">
					<div class="reply-content">
						<p>
							<strong>${reply.replyer}</strong>
						</p>
						<p class="reply-date">
							<fmt:formatDate value="${reply.postDate}"
								pattern="yyyy/MM/dd HH:mm" />
						</p>
						<div class="reply-btn"
							style="display: flex; gap: 5px; margin-left: auto;">
							<c:if test="${reply.replyer eq sessionScope.loginMember.userId}">
								<span class="badge rounded-pill bg-success"
									onclick="editReply(${reply.replyNo}, this)">수정</span>
								<span class="badge rounded-pill bg-danger"
									onclick="deleteReply(${reply.replyNo}, this)">삭제</span>
							</c:if>
						</div>
					</div>
					<p class="reply-text">${reply.content}</p>
				</div>
			</c:forEach>
		</div>




	<!-- The Modal -->
	<div class="modal" id="myModal" style="display: none;">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">ITS Project</h4>
					<button type="button" class="btn-close modalCloseBtn"
						data-bs-dismiss="modal"></button>
				</div>

				<!-- Modal body -->
				<div class="modal-body"></div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-info"
						onclick="location.href='/board/removeBoard?boardNo=${param.boardNo}';">삭제</button>
					<button type="button" class="btn btn-danger modalCloseBtn"
						data-bs-dismiss="modal">취소</button>
				</div>
			</div>
		</div>
	</div>
	<c:import url="./../footer.jsp" />
	</div>
</body>
</html>