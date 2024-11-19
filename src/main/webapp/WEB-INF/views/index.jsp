<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>ITS Project</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
	
</script>
<style>
* {
	font-family: "Gowun Batang";
	font-size: normal;
}
</style>
</head>
<body>

	<c:import url="./header.jsp" />

	<div class="container mt-5">
		<div class="row">
			<div class="col-sm-4" style="text-align:center;">
				<h2>[About Us]</h2>
				<img src="/resources/images/AboutUs.png" style="width: 200px;">
				<p>팀원 - 최미설 / 김가윤 / 박근영</p>
				<p></p>
				<h3 class="mt-4">[ITS 1차 프로젝트]</h3>
				<p></p>
				<ul class="nav nav-pills flex-column" style="text-align:center;">
					<li class="nav-item"><a class="nav-link" href="/ITSCMS">최미설</a></li>
					<li class="nav-item"><a class="nav-link" href="/ITSKGY">김가윤</a></li>
					<li class="nav-item"><a class="nav-link" href="/ITSPGY">박근영</a></li>
					</li>
					<br>
					<li>
						<button type="button" class="btn btn-secondary"
							onclick="location.href='/logout'">로그아웃</button>
					</li>
				</ul>
				<hr class="d-sm-none">
			</div>
			<div class="col-sm-8" style="text-align: center;">
				<div onclick="location.href='/map'" style="cursor: pointer;">
					<h2>[각 도로의 기상상황]</h2>
				
				<h5>각 도로별 기상상황과 유저들의 소통창</h5>
				<p>궁금한 도로의 기상상황을 실시간으로 확인해요!</p>
				</div>

				<div style="text-align: center;">
					<div onclick="location.href='/board/list'" style="cursor: pointer;">
						<h2 class="mt-5">[게시판]</h2>
						<h5>차린이들의 소통공간</h5>
						<h5>★지금 가장 핫한 게시글★</h5>
					</div>
					<table class="table table-hover">
						<thead>
							<tr>
								<th>제목</th>
								<th>작성자</th>
								<th>조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="list" items="${list}">
								<tr
									onclick="location.href='/board/detail?boardNo=${list.boardNo}'"
									style="cursor: pointer;">
									<td>${list.title}</td>
									<td>${list.writer}</td>
									<td>${list.readCount}</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>


					<div style="float: right; margin-right: 5px;">
						<button type="button" class="btn btn-primary"
							onclick="location.href='/board/showSaveBoardForm';">글 쓰기</button>
					</div>
				</div>
			</div>
		</div>
	</div>


	<c:import url="./footer.jsp" />
</body>
</html>