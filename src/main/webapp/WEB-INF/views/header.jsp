<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ITS Project</title>

  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- font -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Gowun+Batang:wght@400;700&display=swap" rel="stylesheet">
<!-- ------------------------------------------------------------------------------------- -->
	
<style>
	.custom-style {
		font-family: "Gowun Batang";
		font-size: normal;
	}
	
	.userArea {
		display : flex;
		align-items : center;
		color : rgba(255, 255, 255, 0.55);
	}

	.userProfile {
		width : 40px;
		border-radius : 20px;
		border : 2px solid #595959;
		padding : 4px;
	}
</style>
</head>
<body>
	<div class="p-5 bg-primary text-white text-center custom-style" onclick="location.href='/'">
  		<h1>ITS Project</h1>
  		<p>기상상황에 따른 교통상황 By 최김박</p> 
	</div>
</body>
</html>