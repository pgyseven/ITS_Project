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

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
	href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&display=swap"
	rel="stylesheet">
<script>
$(function(){
    let pagingSize = '${param.pagingSize}'
    if(pagingSize == '') {
 	  	pagingSize=5;
 	  } else {
 		pagingSize = parseInt(pagingSize);
 	  }
    $('#pagingSize').val(pagingSize);
    
    // 클래스가 modalCloseBtn인 태그를 클릭하면 실행되는 함수
    $('.modalCloseBtn').click(function(){
       $("#myModal").hide(); // 태그를 화면에서 감춤
    });
    
    
 // 유저가 페이징 사이즈를 선택하면
    $('.pagingSize').change(function(){
 	   console.log($(this).val());
 	   
 	   let pageNo = '${param.pageNo}';
 		  if(pageNo == '') {
 			  pageNo = 1;
 		  } else {
 			  pageNo = parseInt('${param.pageNo}');
 		  }
 	   
 	   location.href='/board/list?pagingSize=' + $(this).val() + '&pageNo=' + pageNo;
    });

 });  // 웹 문서가 로딩 완료되면 현재의 함수를 실행하도록 한다
</script>
<style>
* {
	font-family: "Gowun Batang";
	font-size: normal;
}
</style>
</head>
<body>
	<div class="container">
		<c:import url="./../header.jsp" />

		<div class="content">
		<h1 style="text-align:center; margin-top:15px;">~차린이 소통방~</h1>

			<div class="boardControl" style="float : left; margin-right:5px;">
				<select class="form-select pagingSize" id="pagingSize">
					<option value="5">5개씩 보기</option>
					<option value="10">10개씩 보기</option>
				</select>
			</div>
			
					<table class="table table-hover">
						<thead>
							<tr style="text-align: center;">
								<th>제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="list" items="${boardList}">
										<tr
											onclick="location.href='/board/detail?boardNo=${list.boardNo}';">
											<td>${list.title}</td>
											<td style="text-align: center;">${list.writer}</td>
											<td class="postDate" style="text-align: center;"><fmt:formatDate value="${list.postDate}"
													pattern="yyyy/MM/dd hh:mm" /></td>
											<td style="text-align: center;">${list.readCount}</td>
										</tr>
							</c:forEach>
						</tbody>
					</table>
				

		</div>

		<div style="float : right; margin-right:7px;">
			<button type="button" class="btn btn-primary"
				onclick = "location.href='/board/showSaveBoardForm';">글 쓰기</button>
			<button type="button" class="btn btn-secondary"
				onclick = "location.href='/';">돌아가기</button>
		</div>

		<div class="pagination justify-content-center" style="margin: 20px 0; margin-top:50px;">
			<ul class="pagination">
				<c:if test="${param.pageNo > 1}">
					<li class="page-item"><a class="page-link"
						href="/board/list?pageNo=${param.pageNo - 1}&pagingSize=${param.pagingSize}">◀</a></li>

				</c:if>

				<c:forEach var="i" begin="${PagingInfo.startPageNoCurBlock}"
					end="${PagingInfo.endPageNoCurBlock}">
					<c:choose>
						<c:when test="${param.pageNo == i}">
							<li class="page-item active" id="${i}"><a class="page-link"
								href="/board/list?pageNo=${i}&pagingSize=${param.pagingSize}">${i}</a></li>
						</c:when>
						<c:otherwise>
							<li class="page-item" id="${i}"><a class="page-link"
								href="/board/list?pageNo=${i}&pagingSize=${param.pagingSize}">${i}</a></li>
						</c:otherwise>
					</c:choose>

				</c:forEach>

				<c:if test="${param.pageNo < PagingInfo.totalPageCnt}">
					<li class="page-item"><a class="page-link"
						href="/board/list?pageNo=${param.pageNo + 1}&pagingSize=${param.pagingSize}">▶</a></li>
				</c:if>
			</ul>
		</div>


		<c:import url="./../footer.jsp" />
	</div>
</body>
</html>