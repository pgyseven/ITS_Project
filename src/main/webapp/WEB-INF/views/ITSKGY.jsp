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
   justify-content: flex-start;
   padding : 1em;
}
.codeResult {
   margin-left : 1em;
   
}
</style>
</head>
<body class="layout-fixed sidebar-expand-lg bg-body-tertiary">
      <c:import url="./header.jsp" />
   <div class="app-wrapper" style="width:100%; margin: 30px auto; align-items: center; ">
      <div class="title">
         <h2>교통사고 비율과 고령 운전자의 상관관계</h2>
         <h3 style="color:grey; text-align:right; margin-right:300px;">-김가윤</h3>
         <div class="finalResult">
            <div class="explain" style="size:0.7em;">
<pre style="font-family: Gowun Batang; font-size: normal;">
최근 들어 고령 운전자의 교통사고에 대한 문제가 화제가 됨에 따라
언론에서 과도한 물타기를 하는 것인지 아니면 실제 고령 운전자의 교통사고 비율이 높은지에
데이터를 분석해서 알아보고자 위와 같은 주제를 선정

</pre>
            </div>
            <img src="/resources/IMG/KGY/resultKgy.png" style="width:70%;">
            
         </div> 
<pre style="font-family: Gowun Batang; font-size: normal;">

- 분석 결과 -
고령 운전자의 사고가 연령별 사고 비율을 비교했을
때 생각보다 높은 비중을 차지하고 있다는 부분을 알았다.
그러나 가장 높은 비율을 차지하는 것은 아니기에
언론에서 고령운전자에 대한 부정적인 시각을 과하게 유도하는 것 같다.
</pre>
      </div>
      
      <div class="contentBody">
         <!-- 반복할 구간1 -->
         <div class="codeBody">
            <div class="topper">
               <div class="playBtn playBtn1">
                  <img src="/resources/IMG/play.png">
               </div>
               <div class="pyCode pyCode1" style="background-color:lightgrey;">
<pre style="font-family: Gowun Batang; font-size: normal;">
import csv
file = open('data/accident_age1.csv', 'r', encoding='utf-8')
data = csv.reader(file)

for row in data : 
    print(row)

file.close()
</pre>
               </div>
            </div>
            <div class="bottom bottom1">
               <div class="dots dots1">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult1">
                  <img src="/resources/IMG/KGY/resultKgy1.png" style="width:1000px;"/>
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
import pandas as pd

# CSV 파일 읽기
df = pd.read_csv('data/accident_age1.csv', encoding='utf-8')

# 각 나이대별로 그룹화하고, 합산할 컬럼들에 대해 합계 계산
grouped_by_age = df.groupby('가해자연령층').sum()

# 인덱스('가해자연령층')를 없애고 출력
grouped_by_age = grouped_by_age.reset_index()

# '61-64세'와 '65세이상' 데이터를 필터링합니다.
age_61_64 = grouped_by_age[grouped_by_age['가해자연령층'] == '61-64세']
age_65_plus = grouped_by_age[grouped_by_age['가해자연령층'] == '65세이상']

# 두 데이터프레임을 결합하기 위해 공통된 컬럼만 선택합니다.
common_columns = ['사고건수', '사망자수', '중상자수', '경상자수', '부상신고자수']

# 두 데이터프레임의 값을 합칩니다.
age_61_plus = age_61_64.copy()
for col in common_columns:
    age_61_plus[col] += age_65_plus[col].values

# 새로운 데이터프레임을 만듭니다.
age_61_plus['가해자연령층'] = '61세이상'

# 기존 데이터프레임에서 '61-64세'와 '65세이상'을 삭제합니다.
grouped_by_age = grouped_by_age[~grouped_by_age['가해자연령층'].isin(['61-64세', '65세이상'])]

# 새로운 데이터프레임을 기존 데이터에 추가합니다.
final_df = pd.concat([grouped_by_age, age_61_plus], ignore_index=True)

# 결과 출력
print(final_df)
</pre>
               </div>
            </div>
            <div class="bottom bottom2">
               <div class="dots dots2">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult2">
                  <img src="/resources/IMG/KGY/resultKgy2.png" style="width:1000px;"/>
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
import pandas as pd

# CSV 파일 읽기
df = pd.read_csv('data/accident_age1.csv', encoding='utf-8')

# 각 나이대별로 그룹화하고, 합산할 컬럼들에 대해 합계 계산
grouped = df.groupby('가해자연령층').sum()

# 인덱스('가해자연령층')를 없애고 출력
grouped = grouped.reset_index()

# 전체 사고건수 합계 계산
total_accidents = grouped['사고건수'].sum()

# 각 연령층의 사고건수 비율 계산
grouped['사고건수_비율'] = (grouped['사고건수'] / total_accidents) * 100

# 결과 출력
print(grouped)
</pre>
               </div>
            </div>
            <div class="bottom bottom3">
               <div class="dots dots3">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult3">
                  <img src="/resources/IMG/KGY/resultKgy3.png" style="width:1000px;"/>
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
import pandas as pd
import matplotlib.pyplot as plt

# CSV 파일 읽기
df = pd.read_csv('data/accident_age1.csv', encoding='utf-8')

# 각 나이대별로 그룹화하고, 합산할 컬럼들에 대해 합계 계산
grouped = df.groupby('가해자연령층').sum()

# 인덱스('가해자연령층')를 없애고 출력
grouped = grouped.reset_index()

# 전체 사고건수 합계 계산
total_accidents = grouped['사고건수'].sum()

# 전 연령층의 평균 사고건수 계산
mean_accidents = total_accidents / 7
print(mean_accidents)

# 각 연령층의 사고건수 비율 계산
grouped['사고건수_비율'] = (grouped['사고건수'] / total_accidents) * 100

# 막대 그래프 그리기
plt.rcParams['font.family'] ='D2Coding'
plt.figure(figsize=(10, 6))
plt.plot(grouped['가해자연령층'], grouped['사고건수_비율'], color='blue')
plt.xlabel('가해자연령층')
plt.ylabel('사고건수 비율')
plt.title('각 연령층의 사고건수 비율')
plt.xticks(rotation=45)  # X축 라벨을 45도 회전시켜 읽기 쉽게
plt.grid(axis='y', linestyle='--', alpha=0.7)  # Y축에 그리드 추가
plt.tight_layout()  # 레이아웃 조정
plt.show()
</pre>
               </div>
            </div>
            <div class="bottom bottom4">
               <div class="dots dots4">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult4">
                  <img src="/resources/IMG/KGY/resultKgy4.png" style="width:800px;"/>
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
import pandas as pd

# CSV 파일 읽기
df = pd.read_csv('data/accident_age1.csv', encoding='utf-8')

# 각 나이대별로 그룹화하고, 합산할 컬럼들에 대해 합계 계산
grouped = df.groupby('가해자연령층').sum()

# 인덱스('가해자연령층')를 없애고 출력
grouped = grouped.reset_index()

# 사망자수, 중상자수, 경상자수를 사고건수로 나눈 후 100을 곱해 비율 계산
grouped['사망자수_비율'] = (grouped['사망자수'] / grouped['사고건수']) * 100
grouped['중상자수_비율'] = (grouped['중상자수'] / grouped['사고건수']) * 100
grouped['경상자수_비율'] = (grouped['경상자수'] / grouped['사고건수']) * 100
grouped['부상신고자수_비율'] = (grouped['부상신고자수'] / grouped['사고건수']) * 100

# 결과 출력
print(grouped[['가해자연령층', '사고건수', '사망자수_비율', '중상자수_비율', '경상자수_비율', '부상신고자수_비율']])
</pre>
               </div>
            </div>
            <div class="bottom bottom5">
               <div class="dots dots5">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult5">
                  <img src="/resources/IMG/KGY/resultKgy5.png" style="width:1000px;"/>
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
import csv
file = open('data/licence_age.csv', 'r', encoding='utf-8')

data = csv.reader(file)

for row in data : 
    print(row)

file.close()
</pre>
               </div>
            </div>
            <div class="bottom bottom6">
               <div class="dots dots6">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult6">
                  <img src="/resources/IMG/KGY/resultKgy6.png" style="width:1000px;"/>
               </div>
            </div>
         </div>
         <!-- 반복구간 종료 -->
         
         <!-- 반복할 구간7 -->
         <div class="codeBody codeBody7">
            <div class="topper topper7">
               <div class="playBtn playBtn7">
                  <img src="/resources/IMG/play.png">
               </div>
               <div class="pyCode pyCode7" style="background-color:lightgrey; ">
<pre style="font-family: Gowun Batang; font-size: normal;">
import pandas as pd

# CSV 파일 읽기
df = pd.read_csv('data/licence_age.csv', encoding='utf-8')

# '연령대별(1)' 컬럼을 인덱스로 설정하고 '소계' 컬럼만 선택
df.set_index('연령대별(1)', inplace=True)
df = df[['소계']]

# '계'와 같은 값을 제외합니다.
df = df[~df.index.str.contains('계')]

# 데이터프레임의 인덱스를 정수형으로 변환
# '세이상'을 '99'로 변환한 후, '세'를 제거하고, 마지막으로 '이상'을 제거
def convert_age_index(index):
    index = index.replace('세이상', '99')
    index = index.replace('세', '')
    index = index.replace('이상', '')
    return index

df.index = df.index.map(convert_age_index)

# 이제 문자열을 정수형으로 변환합니다.
df.index = df.index.astype(int)

# 연령대별로 그룹화하고 합산하기
age_ranges = {
    '20세 이하': df.loc[df.index <= 20].sum(),
    '21-30세': df.loc[(df.index >= 21) & (df.index <= 30)].sum(),
    '31-40세': df.loc[(df.index >= 31) & (df.index <= 40)].sum(),
    '41-50세': df.loc[(df.index >= 41) & (df.index <= 50)].sum(),
    '51-60세': df.loc[(df.index >= 51) & (df.index <= 60)].sum(),
    '61세 이상': df.loc[df.index >= 61].sum()
}

# 새로운 데이터프레임 생성
combined_df = pd.DataFrame(age_ranges).T

# '소계' 컬럼 이름을 '면허소지자수'로 변경
combined_df.rename(columns={'소계': '면허소지자수'}, inplace=True)

# 인덱스를 기본 숫자 인덱스로 재설정
combined_df.reset_index(drop=True, inplace=True)

# 컬럼 이름 설정
combined_df.columns.name = None

# 결과 출력
print(combined_df)

</pre>
               </div>
            </div>
            <div class="bottom bottom7">
               <div class="dots dots7">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult7">
                  <img src="/resources/IMG/KGY/resultKgy7.png" style="width:1000px;"/>
               </div>
            </div>
         </div>
         <!-- 반복구간 종료 -->
         
         <!-- 반복할 구간8 -->
         <div class="codeBody codeBody8">
            <div class="topper topper8">
               <div class="playBtn playBtn8">
                  <img src="/resources/IMG/play.png">
               </div>
               <div class="pyCode pyCode8" style="background-color:lightgrey; ">
<pre style="font-family: Gowun Batang; font-size: normal;">
import pandas as pd

# CSV 파일 읽기
df = pd.read_csv('data/licence_age.csv', encoding='utf-8')

# '연령대별(1)' 컬럼을 인덱스로 설정하고 '소계' 컬럼만 선택
df.set_index('연령대별(1)', inplace=True)
df = df[['소계']]

# '계'와 같은 값을 제외합니다.
df = df[~df.index.str.contains('계')]

# 데이터프레임의 인덱스를 정수형으로 변환
def convert_age_index(index):
    index = index.replace('세이상', '99')
    index = index.replace('세', '')
    index = index.replace('이상', '')
    return index

df.index = df.index.map(convert_age_index)
df.index = df.index.astype(int)

# 연령대별로 그룹화하고 합산하기
age_ranges = {
    '20세 이하': df.loc[df.index <= 20].sum(),
    '21-30세': df.loc[(df.index >= 21) & (df.index <= 30)].sum(),
    '31-40세': df.loc[(df.index >= 31) & (df.index <= 40)].sum(),
    '41-50세': df.loc[(df.index >= 41) & (df.index <= 50)].sum(),
    '51-60세': df.loc[(df.index >= 51) & (df.index <= 60)].sum(),
    '61세 이상': df.loc[df.index >= 61].sum()
}
combined_df = pd.DataFrame(age_ranges).T
combined_df.rename(columns={'소계': '면허소지자수'}, inplace=True)
combined_df.reset_index(drop=True, inplace=True)
combined_df.columns.name = None

# 사고 데이터프레임 읽기
df_accidents = pd.read_csv('data/accident_age1.csv', encoding='utf-8')

# 각 나이대별로 그룹화하고, 합산할 컬럼들에 대해 합계 계산
grouped_by_age = df_accidents.groupby('가해자연령층').sum()
grouped_by_age = grouped_by_age.reset_index()

# '61-64세'와 '65세이상' 데이터를 필터링합니다.
age_61_64 = grouped_by_age[grouped_by_age['가해자연령층'] == '61-64세']
age_65_plus = grouped_by_age[grouped_by_age['가해자연령층'] == '65세이상']

# 두 데이터프레임의 값을 합칩니다.
common_columns = ['사고건수', '사망자수', '중상자수', '경상자수', '부상신고자수']
age_61_plus = age_61_64.copy()
for col in common_columns:
    age_61_plus[col] += age_65_plus[col].values

age_61_plus['가해자연령층'] = '61세이상'
grouped_by_age = grouped_by_age[~grouped_by_age['가해자연령층'].isin(['61-64세', '65세이상'])]
final_df = pd.concat([grouped_by_age, age_61_plus], ignore_index=True)

# 두 데이터프레임을 가로로 결합
final_combined_df = pd.concat([final_df, combined_df], axis=1)

# 결과 출력
print(final_combined_df)

# 비율 계산: 사고건수 / 면허소지자수
final_combined_df['사고건수 대비 면허소지자수 비율'] = final_combined_df['사고건수'] / final_combined_df['면허소지자수'] * 100

# 그래프를 그리기 위해 필요한 컬럼만 선택
plot_df = final_combined_df[['가해자연령층', '사고건수 대비 면허소지자수 비율']]

# 그래프 생성
plt.figure(figsize=(10, 6))
plt.plot(plot_df['가해자연령층'], plot_df['사고건수 대비 면허소지자수 비율'], color='blue')
plt.xlabel('연령대')
plt.ylabel('사고건수 대비 면허소지자수 비율 (%)')
plt.title('연령대별 사고건수 대비 면허소지자수 비율')
plt.xticks(rotation=45)
plt.tight_layout()

# 그래프 출력
plt.show()
</pre>
               </div>
            </div>
            <div class="bottom bottom8">
               <div class="dots dots8">
                  <img src="/resources/IMG/dots.png" style="width:20px;"/>
               </div>
               <div class="codeResult codeResult8">
                  <img src="/resources/IMG/KGY/resultKgy8.png" style="width:1000px;"/>
                  <img src="/resources/IMG/KGY/resultKgy.png" style="width:800px;"/>
               </div>
            </div>
         </div>
         <!-- 반복구간 종료 -->
         
      </div>
      
            <c:import url="./footer.jsp" />
   </div>
</body>
</html>
