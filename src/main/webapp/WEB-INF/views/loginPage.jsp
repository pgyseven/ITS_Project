<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>오늘의 날씨</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style type="text/css">
* {
	padding: 0;
	margin: 0;
	border: none;
	font-family: "Gowun Batang";
	font-size: normal;
}

body {
	font-size: 14px;
	font-family: 'Roboto', sans-serif;
}

.loginform {
	display: flex;
	justify-content: center;
	align-content: space-between;
}

.login-wrapper {
	width: 400px;
	height: 350px;
	padding: 40px;
	box-sizing: border-box;
}

.login-wrapper>h2 {
	font-size: 24px;
	color: blue;
	margin-bottom: 20px;
}

#login-form>input {
	width: 100%;
	height: 48px;
	padding: 0 10px;
	box-sizing: border-box;
	margin-bottom: 16px;
	border-radius: 6px;
	background-color: #F8F8F8;
}

#login-form>input::placeholder {
	color: blue;
}

#login-form>input[type="submit"] {
	color: #fff;
	font-size: 16px;
	background-color: #7FAD39;
	margin-top: 20px;
}

input[type="button"] {
	width: 100%;
	height: 48px;
	padding: 0 10px;
	box-sizing: border-box;
	margin-bottom: 16px;
	border-radius: 6px;
	color: #fff;
	font-size: 16px;
	background-color: blue;
	margin-top: 20px;
}

#login-form>input[type="checkbox"] {
	display: none;
}

#login-form>label {
	color: blue;
}

#login-form input[type="checkbox"]+label {
	cursor: pointer;
	padding-left: 26px;
	background-image: url("checkbox.png");
	background-repeat: no-repeat;
	background-size: contain;
}

#login-form input[type="checkbox"]:checked+label {
	background-image: url("checkbox-active.png");
	background-repeat: no-repeat;
	background-size: contain;
}
</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script type="text/javascript">
   $(function() {
      let status = '${status}'
      if (status == 'loginFail') {
         $('.modal-body').text('로그인 실패 다시로그인 하여 주세요');
         $('#myModal').show();
      } else if (status == 'loginSuccess') {
         $('.modal-body').text('로그인에 성공하였습니다.');
         $('#myModal').show();
         setTimeout(function() {
                window.location.href = '/'; // 성공 시 이동할 페이지
            }, 2000);
      }
      // 체크박스 체크시 로그인 하는 유저의 id 저장
      if (localStorage.getItem('userId') != null) {
         $('#userId').val(localStorage.getItem('userId'));
         $('#remember-check').prop('checked', true);
      }
 
   });

   // 유저의 id 저장
   function userIdsave() {
      if ($('#remember-check')[0].checked == true) {
         let userId = $('#userId').val()
         localStorage.setItem('userId', userId);
      } else if ($('#remember-check')[0].checked == false) {
         localStorage.removeItem('userId');
         console.log(localStorage.getItem('userId'));
      }
   }

   // 로그인시 유효성 검사하는 함수
   function valid() {
      let userId = $('#userId').val()
      let userPwd = $('#userPwd').val()

      let returnYn = false;

      if (userId == '') {
         //alert('아이디를 입력하여 주세요');
         $('.modal-body').text('아이디를 입력하여 주세요');
         $('#myModal').show();
         return returnYn;
      }
      if (userPwd == '') {
         $('.modal-body').text('비밀번호를 입력하여 주세요');
         $('#myModal').show();
         return returnYn;
      }
      if (userId != '' && userPwd != '') {
         userIdsave();
         returnYn = true;
      }
      return returnYn;

   }
   function modalClose(){
      $('#myModal').hide();
   }
</script>

</head>
<body>
		<c:import url="./header.jsp" />
	<div class="loginform">
		<div class="login-wrapper" style="width:30%; margin: 30px auto; align-items: center; ">
			<h2>Login</h2>
			<form method="post" action="/login" id="login-form">
				<input type="text" name="userId" id="userId" placeholder="아이디">
				<input type="password" name="userPwd" id="userPwd"
					placeholder="Password"> <label for="remember-check">
					<input type="checkbox" id="remember-check" onclick="userIdsave()">아이디
					저장하기
				</label> <input type="submit" value="Login" onclick="return valid();" style="background-color: blue;">
			</form>
			
		</div>
	</div>
	<!-- The Modal -->
	<div class="modal" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">

				<!-- Modal Header -->
				<div class="modal-header">
					<h4 class="modal-title">Modal Heading</h4>
					<button type="button" class="btn-close" data-bs-dismiss="modal" onclick="modalClose()"></button>
				</div>

				<!-- Modal body -->
				<div class="modal-body">Modal body..</div>

				<!-- Modal footer -->
				<div class="modal-footer">
					<button type="button" class="btn btn-danger" onclick="modalClose()"
						data-bs-dismiss="modal">Close</button>
				</div>

			</div>
		</div>
				
	</div>
<c:import url="./footer.jsp" />
</body>
</html>