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
<script>
	$(function(){
		$('.bottom').hide();
		for (let i = 0; i <= 8; i++) {
	        $('.playBtn'+i).click(function() {
	            $('.bottom'+i).show(300); // 클릭 시 div를 보여줌
	        });
            $('.dots'+i).click(function() {
            	$('.bottom'+i).hide(300); //클릭시 div  숨김
            });
		}
	});
</script>
<style>
* {
		font-family: "Gowun Batang";
		font-size: normal;
	}
.title {
	text-align: center;
}
.topper {
	display : flex;
	flex:1;
	justify-content: space-around;
	margin : 10px;
}

.pyCode {
	padding : 1em;
	width : 90%;
	
}

.bottom {
	display : flex;
	flex:1;
flex-direction: row;
	padding : 1em;
}
.codeResult {
	margin-left : 1em;
	
}
</style>
</head>
		
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary" >
<c:import url="./header.jsp" />
	<div class="app-wrapper" style="width:100%; margin: 30px auto; align-items: center; ">
		<div class="title">
			<h2>서울시 구별 교통안전시설물과 교통사고의 상관관계 분석</h2>
			<h3 style="color:grey; text-align:right; margin-right:300px;">- 최미설</h3>
			<div class="finalResult">
				<div class="explain" style="size:0.7em;">
<pre style="font-family: Gowun Batang; font-size: normal;">
교통사고를 방지하기 위한 교통안전시설(신호등, 횡단보도) 등은 
실제 교통사고를 방지하는 역할을 하고 있는지
확인해보기 위해 교통안전시설과 교통사고의 상관관계 분석
</pre>
				</div>
				<img src="/resources/IMG/CMS/resultCms.png" style="width:70%;">
				
			</div> 
			<div class="finalResultCaption" style="size:0.2em;">
<pre style="font-family: Gowun Batang; font-size: normal;">

< 분석 결과 >
우리가 주변에서 쉽게 접할 수 있는 교통안전시설이 단순히 편의상 존재하는 것이 아니라 
나의 교통안전과 직접적으로 연결되있다는 것을 새삼 인지하게 되었다.
하지만 두 자료의 시각화자료만으로는 교통사고 사상자수와 교통안전시설의 개수의 선후관계를 파악할 수 없었다.
선후관계를 파악할 수 있도록 시간대별로 변화를 관측할 수 있는 데이터를 추가하여 보완하면 더 좋을 것 같다.

</pre>
			</div>
		</div>
		<br>
		
		<div class="contentBody">
			<!-- 반복할 구간1 -->
			<div class="codeBody">
				<div class="topper">
					<div class="playBtn playBtn1">
						<img src="/resources/IMG/play.png">
					</div>
					<div class="pyCode pyCode1" style="background-color:lightgrey;">
<pre style="font-family: Gowun Batang; font-size: normal;">
import matplotlib.pyplot as plt
import random
import numpy as np #numpy :
import csv
import seaborn as sns
import pandas as pd

import pandas as pd
traffic_data = pd.read_csv('/content/drive/MyDrive/Colab Notebooks/data/trafficAccident2023.csv')
traffic_data
</pre>
					</div>
				</div>
				<div class="bottom bottom1">
					<div class="dots dots1">
						<img src="/resources/IMG/dots.png" style="width:20px;"/>
					</div>
					<div class="codeResult codeResult1">
						<img src="/resources/IMG/CMS/resultCms1.png" style="width:800px;"/>
					</div>
				</div>
			</div>
			<!-- 반복구간 종료 -->
			
			<!-- 반복할 구간2 -->
			<div class="codeBody codeBody2">
				<div class="topper topper2">
					<div class="playBtn playBtn2">
						<img src="/resources/IMG/play.png">
					</div>
					<div class="pyCode pyCode2" style="background-color:lightgrey; ">
<pre style="font-family: Gowun Batang; font-size: normal;">
# 교통안전시설 갯수
fercility_data = pd.read_csv('/content/drive/MyDrive/Colab Notebooks/data/Crosswalk_TrafficLight_InSeoul.csv')
f_data = fercility_data.groupby('자치구')['자치구'].count()
f_data.sort_values
f_data
</pre>
					</div>
				</div>
				<div class="bottom bottom2">
					<div class="dots dots2">
						<img src="/resources/IMG/dots.png" style="width:20px;"/>
					</div>
					<div class="codeResult codeResult2">
						<img src="/resources/IMG/CMS/resultCms2.png" style="width:100%;"/>
					</div>
				</div>
			</div>
			<!-- 반복구간 종료 -->
			
			<!-- 반복할 구간3 -->
			<div class="codeBody codeBody3">
				<div class="topper topper3">
					<div class="playBtn playBtn3">
						<img src="/resources/IMG/play.png">
					</div>
					<div class="pyCode pyCode3" style="background-color:lightgrey; ">
<pre style="font-family: Gowun Batang; font-size: normal;">
plt.plot(f_data)
plt.xticks(np.arange(len(f_data)), rotation=45)
</pre>
					</div>
				</div>
				<div class="bottom bottom3">
					<div class="dots dots3">
						<img src="/resources/IMG/dots.png" style="width:20px;"/>
					</div>
					<div class="codeResult codeResult3">
						<img src="/resources/IMG/CMS/resultCms3.png" style="width:100%;"/>
					</div>
				</div>
			</div>
			<!-- 반복구간 종료 -->
			
			<!-- 반복할 구간4 -->
			<div class="codeBody codeBody4">
				<div class="topper topper4">
					<div class="playBtn playBtn4">
						<img src="/resources/IMG/play.png">
					</div>
					<div class="pyCode pyCode4" style="background-color:lightgrey; ">
<pre style="font-family: Gowun Batang; font-size: normal;">
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

# CSV 파일 읽기
total_data = pd.read_csv('/content/drive/MyDrive/Colab Notebooks/data/trafficAccident2023total.csv')
total_data

# 데이터를 길게 변환 (melt)하여 그래프 그리기 좋게 만듦
total_data_melted = pd.melt(total_data, id_vars=['연령'], var_name='구', value_name='사망+부상')
total_data_melted_sorted = total_data_melted.sort_values(by='구')
total_data_melted_sorted
</pre>
					</div>
				</div>
				<div class="bottom bottom4">
					<div class="dots dots4">
						<img src="/resources/IMG/dots.png" style="width:20px;"/>
					</div>
					<div class="codeResult codeResult4">
						<img src="/resources/IMG/CMS/resultCms4.png" style="width:100%;"/>
					</div>
				</div>
			</div>
			<!-- 반복구간 종료 -->
			
			<!-- 반복할 구간5 -->
			<div class="codeBody codeBody5">
				<div class="topper topper5">
					<div class="playBtn playBtn5">
						<img src="/resources/IMG/play.png">
					</div>
					<div class="pyCode pyCode5" style="background-color:lightgrey; ">
<pre style="font-family: Gowun Batang; font-size: normal;">
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

# CSV 파일 읽기
total_data = pd.read_csv('/content/drive/MyDrive/Colab Notebooks/data/trafficAccident2023total.csv')
total_data

# 데이터를 길게 변환 (melt)하여 그래프 그리기 좋게 만듦
total_data_melted = pd.melt(total_data, id_vars=['연령'], var_name='구', value_name='사망+부상')

# 가나다순으로 자치구별 정렬
total_data_melted_sorted = total_data_melted.sort_values(by='구')
total_data_melted_sorted

# 그래프 생성
plt.figure(figsize=(14, 8))
sns.barplot(x='구', y='사망+부상', hue='연령', data=total_data_melted_sorted, palette='coolwarm')

# 그래프 제목과 레이블 추가
plt.title('교통안전시설 개수와 교통사고사상자수 연관성', fontsize=16)
plt.xticks(rotation=45, ha='right')
plt.xlabel('구')
plt.ylabel('사상자수(사망자수+부상자수)')

# 그래프 표시
plt.tight_layout()
plt.show()
</pre>
					</div>
				</div>
				<div class="bottom bottom5">
					<div class="dots dots5">
						<img src="/resources/IMG/dots.png" style="width:20px;"/>
					</div>
					<div class="codeResult codeResult5">
						<img src="/resources/IMG/CMS/resultCms5.png" style="width:800px;"/>
					</div>
				</div>
			</div>
			<!-- 반복구간 종료 -->
			
			<!-- 반복할 구간6 -->
			<div class="codeBody codeBody6">
				<div class="topper topper6">
					<div class="playBtn playBtn6">
						<img src="/resources/IMG/play.png">
					</div>
					<div class="pyCode pyCode6" style="background-color:lightgrey; ">
<pre style="font-family: Gowun Batang; font-size: normal;">
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

# CSV 파일 읽기
total_data = pd.read_csv('/content/drive/MyDrive/Colab Notebooks/data/trafficAccident2023total.csv')
total_data

# 데이터를 길게 변환 (melt)하여 그래프 그리기 좋게 만듦
total_data_melted = pd.melt(total_data, id_vars=['연령'], var_name='구', value_name='사망+부상')

# 가나다순으로 자치구별 정렬
total_data_melted_sorted = total_data_melted.sort_values(by='구')
total_data_melted_sorted

# 그래프 생성
plt.figure(figsize=(14, 8))
sns.barplot(x='구', y='사망+부상', hue='연령', data=total_data_melted_sorted, palette='coolwarm')

# 그래프 제목과 레이블 추가
plt.title('교통안전시설 개수와 교통사고사상자수 연관성', fontsize=16)

# 두번째 그래프 y축 추가
plt.twinx()
plt.plot(f_data, marker='^', color='orange')
plt.xticks(rotation=45) # x축 라벨링
plt.ylabel('교통안전시설 개수')
plt.xticks(rotation=45, ha='right')
plt.xlabel('구')
plt.ylabel('사상자수(사망자수+부상자수)')

# 그래프 표시
plt.tight_layout()
plt.show()
</pre>
					</div>
				</div>
				<div class="bottom bottom6">
					<div class="dots dots6">
						<img src="/resources/IMG/dots.png" style="width:20px;"/>
					</div>
					<div class="codeResult codeResult6">
						<img src="/resources/IMG/CMS/resultCms6.png" style="width:800px;"/>
					</div>
				</div>
			</div>
			<!-- 반복구간 종료 -->

		</div>
		
				<c:import url="./footer.jsp" />
	</div>
</body>
</html>
