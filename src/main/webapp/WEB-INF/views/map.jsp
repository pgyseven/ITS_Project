<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기상청 API 데이터와 카카오맵 결합</title>
<script
   src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
   src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9699b3370a9cf5aa1be6da13bb92aa7f"></script>

<script>

    $(document).ready(function() {
       setDateAndTime();
        loadICData();
        
    });
    
    let date ="";
    let time = "";
    
    function setDateAndTime() {
        const now = new Date();

        // 날짜를 yyyyMMdd 형식으로 변환
        const year = now.getFullYear();
        const month = ('0' + (now.getMonth() + 1)).slice(-2);
        const day = ('0' + now.getDate()).slice(-2);
        date = `\${year}\${month}\${day}`; // yyyyMMdd 형식의 날짜

        // 시간을 30분 단위로 설정
        const hours = now.getHours();
        const minutes = now.getMinutes();
        time = (minutes < 30) ? ('0' + (hours === 0 ? 23 : hours - 1)).slice(-2) + '30' : ('0' + hours).slice(-2) + '30';
    }



   // 도로공사 API에서 IC 데이터 가져오기 (전체 페이지 반복 호출)
   function loadICData() {
       const apiKey = "3131669207";  // 도로공사 API 인증키
       const baseUrl = `https://data.ex.co.kr/openapi/locationinfo/locationinfoUnit?key=\${apiKey}&type=json&numOfRows=1000`;
       let allICData = [];  // 전체 데이터를 저장할 배열
       let currentPage = 1; // 현재 페이지 번호
       const pageSize = 3;  // 총 페이지 수
   
       // 전체 데이터를 비동기적으로 가져오기
       function fetchAllPages() {
           const url = `\${baseUrl}&pageNo=\${currentPage}`;
           console.log(`현재 페이지: ${currentPage}, 요청 URL: ${url}`);
   
           $.ajax({
               url: url,
               type: 'GET',
               dataType: 'json',
               success: function(data) {
                   if (data && data.code === "SUCCESS") {
                       allICData = allICData.concat(data.list);  // 현재 페이지의 데이터를 전체 배열에 추가
                       console.log(`현재 페이지: ${currentPage}, 누적 데이터 수: ${allICData.length}`);
   
                       // 현재 페이지가 총 페이지 수(pageSize)보다 작으면 계속 호출
                       if (currentPage < pageSize) {
                           currentPage += 1;  // 페이지 번호 증가
                           fetchAllPages();  // 다음 페이지 호출
                       } else {
                           displayMarkersOnMap(allICData);  // 모든 데이터 수집 후 마커 표시
                           console.log("모든 데이터 수집 완료");
                       }
                   } else {
                       alert("영업소 위치 데이터 호출 실패: " + data.message);
                   }
               },
               error: function(xhr, status, error) {
                   alert(`도로공사 API 데이터를 가져오는 데 실패했습니다. 상태: ${status}, 에러: ${error}`);
                   console.log("에러 세부 정보:", xhr);
               }
           });
       }
   
       fetchAllPages();  // 첫 페이지 데이터 호출 시작
   }



    // 지도에 마커와 표시하는 함수
function displayMarkersOnMap(icData) {
    var mapContainer = document.getElementById('map'),
        mapOption = { 
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 7
        };
    var map = new kakao.maps.Map(mapContainer, mapOption);

    map.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC); // 교통정보 추가

    const icListEl = document.getElementById('icList'); // IC 목록을 표시할 UL 엘리먼트 찾기

    icData.forEach(ic => {
        const xValue = parseFloat(ic.xValue);
        const yValue = parseFloat(ic.yValue);

        if (!isNaN(xValue) && !isNaN(yValue)) {
            const markerPosition = new kakao.maps.LatLng(yValue, xValue);
            const marker = new kakao.maps.Marker({
                map: map,
                position: markerPosition,
                title: ic.unitName // 마커의 title 속성에 영업소 이름 추가
            });

            marker.unitCode = ic.unitCode;
            marker.customOverlay = null;

            // 마커 클릭 시 오버레이 표시
            kakao.maps.event.addListener(marker, 'click', function() {
                if (marker.customOverlay) {
                    marker.customOverlay.setMap(null);
                    marker.customOverlay = null;
                } else {
                   viewBoard(marker.unitCode)
                    getWeatherDataForLocation(markerPosition, ic.unitName, map, marker);
                }
            });

            // IC 목록에 리스트 항목 추가
            const listItem = document.createElement('li');
            listItem.innerHTML = ic.unitName;
            listItem.style.cursor = "pointer";
            listItem.onclick = function() {
                map.panTo(markerPosition); // 클릭 시 해당 위치로 지도 이동
                kakao.maps.event.trigger(marker, 'click');  // 클릭 시 마커의 클릭 이벤트 트리거
            };
            icListEl.appendChild(listItem);  // IC 목록에 항목 추가
        }
    });
}

   
   // 특정 위치에 대한 기상청 날씨 데이터를 가져와서 마커에 표시하는 함수
   function getWeatherDataForLocation(position, unitName, map, marker) {
      console.log("날짜 확인"+date);
      console.log("시간 확인"+time);
       const serviceKey = "RRgow1c7tvWE17qrOIVAUIwK8wz6qyNEWm3tRCuSiQ07UUrux%2BH9Uk6lP37qeLXDTrr7Toht5t52ZdjR6Dh4SA%3D%3D";
       const baseDate = date;
       const baseTime = time;
       const ny = Math.round(position.getLng());
       const nx = Math.round(position.getLat());
   
       const weatherUrl = `https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtFcst?serviceKey=\${serviceKey}&pageNo=1&numOfRows=1000&dataType=JSON&base_date=\${baseDate}&base_time=\${baseTime}&nx=\${nx}&ny=\${ny}`;
      //console.log(weatherUrl);
       $.ajax({
           url: weatherUrl,
           type: 'GET',
           dataType: 'json',
           success: function(data) {
               if (data.response && data.response.header.resultCode === "00") {
                   // 오버레이를 표시할 때 마커도 전달하여 해당 마커에 연결된 오버레이로 관리
                   displayWeatherOverlay(data.response.body.items.item, unitName, position, map, marker);
               }
           }
       });
   }
   
   // 지도에 날씨 정보를 표시하는 함수
   function displayWeatherOverlay(items, unitName, position, map, marker) {
       let weatherContent = '<div class="wrap">' + 
                            '    <div class="info">' + 
                            '        <div class="title">' + unitName + ' 날씨 정보</div>' +
                            '        <div class="body">' + 
                            '            <div class="img">' +
                            '                <img src="/resources/images/car.gif" width="60" height="60" style="float: left; margin-right: 10px;">' + 
                            '            </div>' + 
                            '            <div class="desc">' + 
                            '                <ul class="weather-list">';
   
       const firstItemsByCategory = getFirstForecastByCategory(items);
       for (const category in firstItemsByCategory) {
           const item = firstItemsByCategory[category];
           const categoryName = getCategoryName(item.category);
           const imgRoot = imgCheck(categoryName, item.fcstValue);
           const weatherValue = valueCheck(categoryName, item.fcstValue);
   
           if (categoryName) {
               weatherContent += `<li>\${categoryName}: <div>\${weatherValue}</div> <img src="\${imgRoot}" alt="날씨 이미지" width="30" height="30"></li>`;
           }
       }
   
       weatherContent += '                </ul>' +
                         '            </div>' + 
                         '        </div>' + 
                         '    </div>' + 
                         '</div>';
   
       // 오버레이 생성
       const customOverlay = new kakao.maps.CustomOverlay({
           position: position,
           content: weatherContent,
           xAnchor: 0.5,
           yAnchor: 1.5,
           map: map
       });
   
       // 기존 오버레이가 있으면 닫기
       if (marker.customOverlay) {
           marker.customOverlay.setMap(null);
       }
   
       // 새 오버레이를 마커의 속성으로 저장
       marker.customOverlay = customOverlay;
   
       // 오버레이 표시
       customOverlay.setMap(map);
   }



    function getFirstForecastByCategory(items) {
        return items.reduce((acc, item) => {
            if (!acc[item.category]) {
                acc[item.category] = item;
            }
            return acc;
        }, {});
    }

    // 카테고리 코드에 대한 한글 설명을 반환하는 함수
    function getCategoryName(categoryCode) {
        switch (categoryCode) {
            case 'LGT': return "낙뢰";
            case 'PTY': return "강수 형태";
            case 'RN1': return null;
            case 'SKY': return "하늘 상태";
            case 'T1H': return "기온";
            case 'REH': return "습도";
            case 'UUU': return null;
            case 'VVV': return null;
            case 'VEC': return null;
            case 'WSD': return "풍속";
            default: return null;
        }
    }
    
    function imgCheck(category, value) {
        // 기상 값에 따라 이미지를 선택하는 로직
        //console.log(category, value);

        if (category === "낙뢰") {
            if (value === '0') {
                return '/resources/images/없음.gif';  // 올바른 확장자로 변경
            } else {
                return '/resources/images/낙뢰.gif';
            }
        }

        if (category === "강수 형태") {
            switch (value) {
                case '0':
                    return '/resources/images/없음.gif';
                case '1':
                    return '/resources/images/비.gif';
                case '2':
                    return '/resources/images/비눈.gif';
                case '3':
                    return '/resources/images/눈.gif';
                case '5':
                    return '/resources/images/빗방울.gif';
                case '6':
                    return '/resources/images/빗방울눈날림.gif';
                default:
                    return '/resources/images/없음.gif';  // 기본 이미지 설정
            }
        }

        if (category === "하늘 상태") {
            switch (value) {
                case '1':
                    return '/resources/images/맑음.gif';
                case '3':
                    return '/resources/images/구름많음.gif';
                case '4':
                    return '/resources/images/흐림.gif';
                default:
                    return '/resources/images/없음.gif';  // 기본 이미지 설정
            }
        }

        if (category === "기온") {
            return '/resources/images/온도.gif';
        }

        if (category === "습도") {
            return '/resources/images/습도.gif';
        }

        if (category === "풍속") {
            return '/resources/images/풍속.gif';
        }

        return '/resources/images/없음.gif';  // 기본 이미지로 설정
    }
    
    function valueCheck(category, value) {
        // 기상 값에 따라 이미지를 선택하는 로직
        //console.log("값확인을 위한 콘솔로그"+category, value);

        if (category === "낙뢰") {
                return value + "kA(킬로암페어)";
        }

        if (category === "강수 형태") {
            switch (value) {
                case '0':
                    return "강수 없음";
                case '1':
                    return "비";
                case '2':
                    return "비 또는 눈";
                case '3':
                    return "눈";
                case '5':
                    return "빗방울";
                case '6':
                    return "빗방울,눈날림";
                default:
                    return '/resources/images/없음.gif';  
            }
        }

        if (category === "하늘 상태") {
            switch (value) {
                case '1':
                    return "맑음";
                case '3':
                    return "구름많음";
                case '4':
                    return "흐림";
                default:
                    return '/resources/images/없음.gif';  
            }
        }

        if (category === "기온") {
            return  value + "℃";
        }

        if (category === "습도") {
            return value + "%";
        }

        if (category === "풍속") {
            return value + "m/s";
        }

        return '/resources/images/없음.gif'; 
       }
    
  let currentUnitCode;
    
  // 마커 클릭시 unitCode와 함께 viewBoard함수 실행
  function viewBoard(unitCode) {
     
   currentUnitCode = unitCode;
    console.log(currentUnitCode);

    $.ajax({
        url: '/getUnitCode',
        type: 'get',
        dataType: 'json',
        data: { unitCode: currentUnitCode },
        async: false,
        success: function(data) {
            console.log(data);

            if (data.msg === 'success') {
                const RoadReply = data.RoadReply;
                console.log("댓글 리스트:", RoadReply);
                const replyListDiv = document.querySelector('.roadReplyList');

                let output = '';
                
            output += `<div class="replyInputForm">`;
                
                output += `<div class="inputReply">`;
                output += `<textarea class="inputReplyContent" id="comment" name="text" placeholder="댓글을 달아주세요!"></textarea>`;
                output += `</div>`;
                
                output += `<div class="replySaveBtn">`;
                output += `<img src="/resources/images/saveReply.png" onclick="saveReply('\${unitCode}');" />`;
                output += `</div>`;
                
                output += `</div>`;

                RoadReply.forEach(function(Rreply) {
                    console.log("댓글 데이터:", Rreply);
                    const replyDate = new Date(Rreply.postDate).toLocaleString();
                    
                    // ID 값을 로그로 확인
                    console.log("생성된 ID:", `\${Rreply.roadReplyNo}`);
                    
                    output += `
                        <div class="reply-item" id="\${Rreply.roadReplyNo}">
                          <div class="reply-content">
                             <div class="replyer-btns">
                                  <p><strong>\${Rreply.replyer}</strong></p>`;
                                if(Rreply.replyer == '${sessionScope.loginMember.userId}'){
                                    // 로그인햇을 때, 댓글작성자일 때 버튼 보이기
                                    output += `<div class='replyBtns'><span class="badge rounded-pill bg-danger delete-button" onclick="removeReply(\${Rreply.roadReplyNo}, currentUnitCode);">삭제</span></div>`;
                                  } else {
                                     // 로그인 안 했을 때, 댓글작성자가 아닐 때 replyBtns비우기
                                    output += `<div class='replyBtns'></div>`
                                  }
                      output += `</div>
                               <p>\${Rreply.content}</p>
                               <p class="reply-date">\${replyDate}</p>
                           </div>`;
                });
                
                output += `</div>`;

                replyListDiv.innerHTML = output;
                console.log(replyListDiv.innerHTML);
                
                
            }
        },
        error: function(data) {
            console.log(data);
        }
    });
}
  
  function removeReply(roadReplyNo, currentUnitCode) {
     console.log('삭제할 댓글의 번호 : ', roadReplyNo)
     console.log('currentUnitCode :', currentUnitCode);
     
     if (!confirm('해당 댓글을 삭제하시겠습니까?')) {
        return;
     }
     
     $.ajax({
       url: '/removeRoadReply',
       type: 'post',
       contentType: 'application/json',
       data: JSON.stringify(roadReplyNo),
       success: function(response) {
            alert(response.message); // 서버 응답의 메시지를 알림으로 표시
            
            viewBoard(currentUnitCode);
        },
        error: function(xhr, status, error) {
           alert('삭제 실패');
            console.error('댓글 삭제 실패:', xhr.responseText);
        }
     });
     
  }
    
  function saveReply(unitCode) {
       // textarea에서 입력된 내용 가져오기
       const replyContent = document.querySelector('.inputReplyContent').value;

       // JSON 데이터 생성
       const replyData = {
           content: replyContent,
           unitCode: unitCode // unitCode를 포함
       };

       $.ajax({
           url: '/saveReply', // 실제 컨트롤러의 URL
           type: 'post',
           contentType: 'application/json',
           data: JSON.stringify(replyData),
           success: function(response) {
               console.log("댓글이 저장되었습니다:", response);
               alert("댓글이 저장되었습니다");
               const RoadReply = response.replies;
                console.log("댓글 리스트:", RoadReply);
                const replyListDiv = document.querySelector('.roadReplyList');

                let output = '';
                
            output += `<div class="replyInputForm">`;
                
                output += `<div class="inputReply">`;
                output += `<textarea class="inputReplyContent" id="comment" name="text" placeholder="댓글을 달아주세요!"></textarea>`;
                output += `</div>`;
                
                output += `<div class="replySaveBtn">`;
                output += `<img src="/resources/images/saveReply.png" onclick="saveReply('\${unitCode}');" />`;
                output += `</div>`;
                
                output += `</div>`;

                RoadReply.forEach(function(Rreply) {
                    console.log("댓글 데이터:", Rreply);
                    const replyDate = new Date(Rreply.postDate).toLocaleString();
                    output += `
                        <div class="reply-item" id="reply-\${Rreply.roadReplyNo}">
                          <div class="reply-content">
                             <div class="replyer-btns">
                                  <p><strong>\${Rreply.replyer}</strong></p>`;
                                if(Rreply.replyer == '${sessionScope.loginMember.userId}'){
                                    // 로그인햇을 때, 댓글작성자일 때 버튼 보이기
                                    output += `<div class='replyBtns'><span class="badge rounded-pill bg-danger" onclick="removeReply(\${Rreply.roadReplyNo}, currentUnitCode);">삭제</span></div>`;
                                  } else {
                                     // 로그인 안 했을 때, 댓글작성자가 아닐 때 replyBtns비우기
                                    output += `<div class='replyBtns'></div>`
                                  }
                      output += `</div>
                               <p>\${Rreply.content}</p>
                               <p class="reply-date">\${replyDate}</p>
                           </div>`;
                });
                

                replyListDiv.innerHTML = output;
                console.log(replyListDiv.innerHTML);
               // 댓글 저장 후 UI 업데이트
           },
           error: function(response) {
               console.log("댓글 저장 실패:", response);
           }
       });
   }


</script>
<style>
.replyInputForm {
   display: flex; /* Flexbox로 설정 */
   align-items: center; /* 세로 중앙 정렬 */
   margin-top: 10px; /* 위쪽 여백 추가 */
}

.inputReply {
   flex: 1; /* 가능한 공간을 모두 차지하게 함 */
   margin-right: 8px; /* 버튼과의 간격 */
}

.inputReplyContent {
   width: 100%; /* textarea의 너비를 100%로 설정 */
   height: 60px;
   padding: 8px; /* 패딩 추가 */
   border: 1px solid #ccc; /* 테두리 추가 */
   border-radius: 4px; /* 모서리 둥글게 */
   resize: none; /* 크기 조정 비활성화 */
}

.replySaveBtn {
   display: flex; /* Flexbox로 설정 */
   align-items: right; /* 세로 중앙 정렬 */
}

.replySaveBtn img {
   cursor: pointer; /* 마우스 커서를 포인터로 변경 */
   width: 30px; /* 이미지 크기 조정 */
   height: 30px; /* 이미지 크기 조정 */
}

.wrap {
   position: absolute;
   left: 0;
   bottom: 40px;
   width: 400px;
   height: 220px;
   margin-left: -200px;
   font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;
   line-height: 1.5;
}

.wrap .info {
   width: 360px;
   height: 200px;
   border-radius: 5px;
   border: 1px solid #ccc;
   background: #fff;
   overflow: hidden;
   border-radius: 20px;
   background-color: rgba(255, 255, 255, 0.9); /* 배경색만 투명하게 설정 */
}

.info .title {
   padding: 5px 10px 5px 10px; /* 좌우 여백 조정 */
   background: #eee;
   font-size: 15px;
   font-weight: bold;
   text-align: left;
   position: relative; /* 닫기 버튼 위치 조정을 위해 position 추가 */
}

.info .desc {
   margin: 1px 0 0 50px;
   height: 150px;
   overflow-y: auto;
}

.info .desc .weather-list li {
   display: flex;
   justify-content: space-between;
   padding: 5px;
}
/* CSS 수정 부분 */
.overlayClose {
   position: absolute;
   right: 8px; /* 닫기 버튼을 제목 오른쪽에 위치하도록 조정 */
   top: 8px; /* 닫기 버튼이 제목 상단에 맞게 조정 */
   font-size: 14px; /* 닫기 버튼의 크기 조정 */
   cursor: pointer; /* 마우스 커서를 손가락 모양으로 변경 */
   color: #333;
}

.img img {
   margin-left: 30px;
   margin-top: 45px;
}

#menu_wrap {
   position: absolute;
   top: 290px; /* 상단 여백을 줄여서 지도의 상단에 맞춤 */
   left: 10px;
   height: 680px; /* 지도 높이와 일치하도록 설정 */
   width: 250px;
   margin: 0; /* 여백 제거 */
   padding: 5px;
   overflow-y: auto;
   background: rgba(255, 255, 255, 0.9);
   z-index: 10; /* z-index 값을 지도보다 높게 설정 */
   font-size: 12px;
   border-radius: 10px;
   background-color: rgba(255, 255, 255, 0.5); /* 배경색만 투명하게 설정 */
}

#icList {
   list-style: none;
   padding: 0;
   margin: 0;
}

#icList li {
   padding: 8px;
   border-bottom: 1px solid #ccc;
   background-color: #f9f9f9;
   cursor: pointer;
   background-color: rgba(255, 255, 255, 0.3); /* 배경색만 투명하게 설정 */
}

#icList li:hover {
   background-color: #e0e0e0;
}

.container {
   display: flex; /* Flexbox로 설정 */
   justify-content: space-between; /* 요소 간의 여백 */
}

#map {
   flex: 3; /* map 영역의 비율을 설정 */
}

.roadReplyList {
   flex: 1;
   margin-left: 20px;
   max-width: 100%;
   border-left: 2px solid #ddd;
   padding-left: 10px;
}

.reply-item {
    margin-bottom: 10px; /* 댓글 간격 */
    padding-bottom: 10px;
}

.reply-content {
    display: block; /* 세로로 정렬 */
}

.replyer-btns {
    display: flex; /* 작성자와 버튼을 가로로 정렬 */
    align-items: center; /* 수직 가운데 정렬 */
}

.replyer-btns p {
    margin-right: 10px; /* 작성자와 삭제 버튼 사이에 여백 */
}

.replyBtns {
    margin-left: auto; /* 삭제 버튼을 우측 끝으로 배치 */
}

.reply-date {
    font-size: 0.8em; /* 날짜 크기 */
    color: #888; /* 회색 */
    margin-top: 5px;
}
</style>
</head>
<body>
   <c:import url="./header.jsp" />
   <h2 style="text-align: center; margin-top: 15px;">기상청 API와 한국도로공사
      API를 활용하여 카카오맵 연동한 예제</h2>
   <p style="text-align: center; margin-top: 15px;">각 IC(도로공사 영업소 기준)
      날씨 정보입니다.</p>
   <div id="menu_wrap" class="bg_white">
      <div class="option" style="margin-top: 5px;">
         <b>영업소 목록</b>
      </div>
      <hr>
      <ul id="icList"></ul>
      <!-- IC 목록을 표시할 UL 태그 추가 -->
   </div>

   <div class="container">
      <div id="map" style="width: 100%; height: 700px;"></div>
      <div class="roadReplyList">
         <!-- 여기에서 JavaScript를 통해 동적으로 댓글이 추가됩니다 -->
      </div>
   </div>
   <c:import url="./footer.jsp" />
</body>
</html>
