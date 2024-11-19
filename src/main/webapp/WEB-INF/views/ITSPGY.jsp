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
		$('.container2').hide();
	    $('.proj1').click(function() {
	        $('.container2').hide(); 
	        $('.container1').show();
	        $('.proj1').removeClass('btn-secondary').addClass('btn-primary');
	        $('.proj2').removeClass('btn-primary').addClass('btn-secondary');
	    });
	    $('.proj2').click(function() {
	        $('.container1').hide(); 
	        $('.container2').show();
	        $('.proj1').removeClass('btn-primary').addClass('btn-secondary');
	        $('.proj2').removeClass('btn-secondary').addClass('btn-primary');
	    });
		
	});
</script>
<style>
* {
		font-family: "Gowun Batang";
		font-size: normal;
	}
.buttons {
	margin : 20px;
}
.title {
	text-align: center;
}
.topper {
	display : flex;
	flex:1;
	justify-content: space-around;
}

.pyCode {
	padding : 1em;
	width : 90%;
	margin-left : 10px;
}

.bottom {
	display : flex;
	flex:1;
	justify-content: space-between;
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
	<div class="buttons">
	<button type="button" class="btn btn-primary proj1">Project 1</button>
	<button type="button" class="btn btn-secondary proj2">Project 2</button>
	</div>
		<!-- 반복할 구간1 -->		
		<div class="container container1">	
			<div class="title title1">
				<h2>서울시 구별 연령대 차이에 따른 사고 유형의 차이</h2>
				<h3 style="color:grey; text-align:right; margin-right:300px;">-박근영</h3>
				<div class="finalResult finalResult1">
					<div class="explain explain1" style="size:0.7em; margin:1em;">
<pre style="font-family: Gowun Batang; font-size: normal;">
특정 연령대의 인구 비율과 사고 유형 간의 관계를 분석함으로써,
인구 구조가 사고 위험에 미치는 영향을 탐구하고자 했으며,
서울시 내 각 구별로 인구 규모가 다름에 따라 사고율에서도 차이가 발생할 것이라고 가정.
이를 통해 구별 사고 위험성을 파악하고, 사고 예방 대책을 제시
</pre>
					</div>
					<img src="/resources/IMG/PGY/resultPgy.png" style="width:70%;">
					
				</div> 
			<div class="finalResultCaption" style="size:0.2em;">
<pre style="font-family: Gowun Batang; font-size: normal;">

- 분석 결과 -
사고 데이터와 인구 데이터를 효과적으로 결합하여 구별 사고율을 분석한 성과를 얻었으나
추가 데이터 부족으로 사고율 차이의 원인을 충분히 분석하지 못함.
사고율의 원인을 명확히 분석하기 위해 도로 상태, 교통량, 시간대 등의 추가 데이터를 확보 필요
</pre>
			</div>
			</div>
			
			<div class="contentBody contentBody1">
				
				<div class="codeBody codeBody1">
					<div class="topper topper1">
						<div class="playBtn playBtn1">
							<img src="/resources/IMG/play.png">
						</div>
						<div class="pyCode pyCode1" style="background-color:lightgrey;">
	<pre style="font-family: Gowun Batang; font-size: normal;">
import folium
import pandas as pd
import geopandas as gpd
import matplotlib.pyplot as plt
from io import BytesIO
import base64
import matplotlib
from branca.colormap import linear

matplotlib.use('Agg')  # 백엔드 변경

# CSV 파일 읽기 (인구 데이터)
file_path = '202407_population copy.csv'
data = pd.read_csv(file_path, low_memory=False)

# 서울특별시 구 정보만 추출하기 위한 함수
def extract_district(row):
    parts = row.split()  # 공백으로 문자열을 분리
    if len(parts) > 1 and parts[0] == "서울특별시" and "구" in parts[1]:
        return parts[1]  # 구 이름 추출 ('종로구' 같은 경우)
    return None

# '구' 수준 데이터만 필터링
data['구'] = data['행정구역'].apply(extract_district)
data_filtered = data[data['구'].notna()]  # 구 정보가 있는 행만 추출

# 구간에 따른 나이 계산을 위한 함수
def sum_age_group(row, start, end):
    return sum([pd.to_numeric(str(row.get(f'2024년07월_계_{i}세', 0)).replace(",", ""), errors='coerce') for i in range(start, end+1)])

# 구별로 65세 이상 고령 인구수 계산
elderly_population = []
total_population = []

for idx, row in data_filtered.iterrows():
    elderly_population.append(int(sum_age_group(row, 65, 99) + pd.to_numeric(row.get('2024년07월_계_100세 이상', 0), errors='coerce')))
    total_population.append(int(row['2024년07월_계_총인구수'].replace(",", "")))

# 고령 인구 비율 계산
data_filtered['Elderly_Percentage'] = [(elderly / total) * 100 for elderly, total in zip(elderly_population, total_population)]

# 폰트 설정
plt.rc('font', family='Noto Sans CJK KR')

# GeoJSON 파일 경로 정의
geojson_path = 'data/SIG.geojson'

# GeoJSON 파일 읽기
geo_data = gpd.read_file(geojson_path)

# 서울 지역 구만 필터링 (서울 지역의 시군구 코드는 11로 시작)
seoul_geo_data = geo_data[geo_data['SIG_CD'].str.startswith('11')]

# 좌표계를 EPSG:3857로 변환하여 중심점 계산 정확도 향상
seoul_geo_data = seoul_geo_data.to_crs(epsg=3857)

# 구 이름 일치 확인: GeoJSON 데이터와 인구 데이터의 구 이름을 모두 대조하여 처리
data_filtered['구'] = data_filtered['구'].str.strip()  # 공백 제거
seoul_geo_data.loc[:, 'SIG_KOR_NM'] = seoul_geo_data['SIG_KOR_NM'].str.strip()  # 공백 제거

# 사고 데이터 읽기
accident_data_path = 'Report_edit.csv'
accident_data = pd.read_csv(accident_data_path)

# 사고 유형 리스트
accident_types = ['횡단중', '차도통행중', '길가장자리구역통행중', '보도통행중', '충돌', '추돌', '공작물충돌', '도로이탈', '전도전복']

# 시군구별 사고 데이터 집계 함수
def aggregate_accident_data_by_region(region):
    region_data = accident_data[accident_data['시군구'] == region]
    accident_sums = []
    for accident_type in accident_types:
        accident_columns = [col for col in region_data.columns if accident_type in col]
        accident_sum = region_data[accident_columns].replace('-', '0').astype(str).replace({',': ''}, regex=True).astype(float).sum().sum()
        accident_sums.append(int(accident_sum))
    return accident_sums

# 각 구별 사고 데이터 집계
accident_summary = {region: aggregate_accident_data_by_region(region) for region in data_filtered['구']}
accident_summary_df = pd.DataFrame.from_dict(accident_summary, orient='index', columns=accident_types)

# 지도 생성
seoul_map = folium.Map(location=[37.5665, 126.9780], zoom_start=11)

# 고령 인구 비율의 최소값과 최대값 계산
min_elderly = data_filtered['Elderly_Percentage'].min()
max_elderly = data_filtered['Elderly_Percentage'].max()

# 색상 맵 정의 (노란색에서 붉은색으로, 고령 인구 비율에 따라)
colormap = linear.YlOrRd_09.scale(min_elderly, max_elderly)

# Choropleth 추가 (고령 인구 비율을 기준으로 색상 매핑)
folium.Choropleth(
    geo_data=seoul_geo_data,
    name='Choropleth',
    data=data_filtered,
    columns=['구', 'Elderly_Percentage'],
    key_on='feature.properties.SIG_KOR_NM',
    fill_color='YlOrRd',
    fill_opacity=0.7,
    line_opacity=0.2,
    legend_name='Elderly Population Percentage',
    highlight=True,  # 구 선택 시 하이라이트
    reset=True
).add_to(seoul_map)

# 히트맵 범례 추가
colormap.add_to(seoul_map)

# 사고 데이터 팝업 생성 함수
def plot_accidents_popup(district):
    if district in accident_summary_df.index:
        pop_data = accident_summary_df.loc[district]
        accident_counts = pop_data.values
        sorted_accidents = sorted(zip(accident_types, accident_counts), key=lambda x: x[1], reverse=True)
        sorted_accidents_labels, sorted_accidents_counts = zip(*sorted_accidents)

        fig, ax = plt.subplots(figsize=(6, 4))  # 차트 크기 조정
        ax.bar(sorted_accidents_labels, sorted_accidents_counts, color='red', alpha=0.7)
        ax.set_title(f'{district} 사고 유형별 현황')
        ax.set_xlabel('사고 유형')
        ax.set_ylabel('사고 건수')

        plt.xticks(rotation=45, ha='right')

        # 이미지를 팝업으로 변환
        img = BytesIO()
        plt.savefig(img, format='png')
        plt.close(fig)
        img.seek(0)
        img_base64 = base64.b64encode(img.getvalue()).decode()
        return f'<img src="data:image/png;base64,{img_base64}"/>'
    else:
        return "사고 데이터 없음"

# 각 구별로 마커를 추가하고 팝업 표시
for idx, row in data_filtered.iterrows():
    district = row['구']
    html = plot_accidents_popup(district)
    iframe = folium.IFrame(html, width=450, height=350)
    popup = folium.Popup(iframe, max_width=450)

    # 서울시 각 구의 중심 좌표 (위도, 경도) 사용
    district_geo = seoul_geo_data[seoul_geo_data['SIG_KOR_NM'] == district]
    if not district_geo.empty:
        # 투영 좌표계를 사용하여 중심 계산 후 다시 EPSG:4326으로 변환
        district_geo = district_geo.to_crs(epsg=4326)
        lat, lon = district_geo.geometry.centroid.y.values[0], district_geo.geometry.centroid.x.values[0]
        folium.Marker(location=[lat, lon], popup=popup).add_to(seoul_map)

# 지도 저장
output_file_path = 'C:/lecture/Python/seoul_elderly_population_choropleth_with_accidents.html'

try:
    seoul_map.save(output_file_path)
    print(f"지도가 성공적으로 저장되었습니다: {output_file_path}")
except Exception as e:
    print(f"지도 저장 중 오류가 발생했습니다: {e}")

	</pre>
						</div>
					</div>
<!-- 					<div class="bottom bottom1">
						<div class="dots dots1">
							<img src="/resources/IMG/dots.png" style="width:20px;"/>
						</div>
						<div class="codeResult codeResult1">
							<img src="/resources/IMG/PGY/resultPgy1.png" style="width:1000px;"/>
						</div>
					</div> -->
				</div>
			</div>	
		</div>
		<!-- 반복구간 종료 -->
	
		<!-- 반복할 구간2 -->		
		<div class="container container2">	
			<div class="title title2">
				<h2>서울시 구별 인구대비 사고율 분석</h2>
				<h3 style="color:grey; text-align:right; margin-right:300px;">-박근영</h3>
				<div class="finalResult2">
					<div class="explain explain2" style="size:0.7em;">
<pre style="font-family: Gowun Batang; font-size: normal;">
특정 연령대의 인구 비율과 사고 유형 간의 관계를 분석함으로써, 
인구 구조가 사고 위험에 미치는 영향을 탐구.
서울시 내 각 구별로 인구 규모가 다름에 따라 사고율에서도 차이가 발생할 것이라 가정하고
구별 사고 위험성을 파악하고, 사고 예방 대책을 제시
</pre>
					</div>
					<img src="/resources/IMG/PGY/resultPgy2.png" style="width:70%;">
					
				</div> 
			<div class="finalResultCaption" style="size:0.2em;">
<pre style="font-family: Gowun Batang; font-size: normal;">
 
< 분석 결과 >
사고 데이터와 인구 데이터를 효과적으로 결합하여 구별 사고율을 분석한 성과를 얻었으나
추가 데이터 부족으로 사고율 차이의 원인을 충분히 분석하지 못함.
사고율의 원인을 명확히 분석하기 위해 도로 상태, 교통량, 시간대 등의 추가 데이터를 확보 필요
</pre>
			</div>
			</div>
			
			<div class="contentBody contentBody2">
				
				<div class="codeBody codeBody2">
					<div class="topper topper2">
						<div class="playBtn playBtn2">
							<img src="/resources/IMG/play.png">
						</div>
						<div class="pyCode pyCode2" style="background-color:lightgrey;">
	<pre style="font-family: Gowun Batang; font-size: normal;">
import pandas as pd  # pandas 라이브러리 (데이터 처리 도구)를 가져옵니다.
import matplotlib.pyplot as plt  # matplotlib 라이브러리 (그래프 시각화 도구)를 가져옵니다.

# 폰트 설정 (한글 깨짐 방지)
plt.rc('font', family='Noto Sans CJK KR')  
# rc는 runtime configuration (실행 시간 설정)이라는 뜻으로, 여기서는 폰트 설정을 지정합니다.

# 1. 사고 데이터와 인구 데이터 로드 (데이터 파일을 불러옵니다)
accident_data = pd.read_csv('Report2.csv')  
# read_csv() -> 파일을 읽는다 (CSV 파일 형식으로 된 데이터를 읽어서 pandas 데이터프레임으로 변환).
population_data = pd.read_csv('population.csv', low_memory=False)  
# low_memory=False는 메모리 사용 최적화를 해제하는 옵션으로, 데이터를 읽는 중간에 생기는 경고를 방지합니다.

# 2. 인구 데이터에서 쉼표를 제거하고 숫자형으로 변환 (텍스트 데이터를 숫자로 변환합니다)
population_data['2024년07월_계_총인구수'] = population_data['2024년07월_계_총인구수'].replace(',', '', regex=True).astype(float)
# replace() -> 바꾼다 (데이터에서 쉼표를 빈 문자열로 대체).
# astype(float) -> 데이터 타입을 float (실수)로 변환 (문자열을 숫자로 변환).

# 3. 구 단위로 데이터 정리 (서울특별시의 구 단위 데이터만 선택하고 복사합니다)
population_summary = population_data.loc[population_data['행정구역'].str.contains(r'서울특별시 \S+구') & 
                                         ~population_data['행정구역'].str.contains(r'\S+동')].copy()  
# loc -> 특정 조건에 맞는 데이터를 선택한다. (특정 구를 포함하는 행만 선택하고, 동을 포함한 행은 제외합니다).
# copy() -> 데이터를 복사한다 (원본 데이터가 수정되지 않도록 하기 위해 사용합니다).

# '구' 컬럼 생성 (행정구역에서 서울특별시 구 이름을 추출해 새로운 열을 만듭니다)
population_summary['구'] = population_summary['행정구역'].str.extract(r'(서울특별시 \S+구)')[0].str.replace('서울특별시 ', '')  
# extract() -> 추출한다 (정규 표현식을 사용해 서울특별시 구 이름만 추출).
# replace() -> 대체한다 (추출한 구 이름에서 '서울특별시'를 빈 문자열로 바꿔서 구 이름만 남김).

# 4. 사고 유형 중복 처리 (같은 사고 유형이 여러 열에 걸쳐 나타나므로, 이들을 합칩니다)
accident_types = ['횡단중', '차도통행중', '길가장자리구역통행중', '보도통행중', '기타']  
# 주요 사고 유형 목록을 정의합니다.

# 각 사고 유형별로 같은 이름의 열을 찾아 합산합니다.
for accident_type in accident_types:  # for -> 반복문 (사고 유형 리스트 내의 각 항목에 대해 반복합니다).
    matching_columns = [col for col in accident_data.columns if accident_type in col]  
    # columns -> 열 (사고 데이터에서 해당 사고 유형이 포함된 열 이름을 찾습니다).
    accident_data[matching_columns] = accident_data[matching_columns].apply(pd.to_numeric, errors='coerce')  
    # to_numeric() -> 숫자형으로 변환한다 (문자열로 된 데이터를 숫자로 변환하며, 변환할 수 없는 값은 NaN으로 처리).
    accident_data[accident_type] = accident_data[matching_columns].sum(axis=1)  
    # sum() -> 더한다 (같은 유형의 열을 행 단위로 더해 합계 값을 만듭니다).

# 필요한 열만 선택 (중복 처리된 사고 유형만 선택하여 새로운 데이터프레임 생성)
accident_summary = accident_data[['시도', '시군구'] + accident_types]  
# 특정 열을 선택하여 새로운 데이터프레임을 만듭니다.

# 5. 구별 사고 데이터 요약 (서울시만 선택해 각 구의 사고 건수를 합산합니다)
accident_summary = accident_summary[accident_summary['시도'] == '서울'].groupby('시군구')[accident_types].sum().reset_index()  
# groupby() -> 그룹화한다 (서울특별시의 각 구별로 사고 데이터를 그룹화하여 합산).
# sum() -> 더한다 (사고 건수를 각 구별로 더해 총합을 구합니다).
# reset_index() -> 인덱스를 초기화한다 (기존 인덱스를 제거하고 데이터프레임을 정렬).

# 6. 사고 데이터와 인구 데이터를 병합 (서울 구별 사고 데이터와 인구 데이터를 결합)
merged_data = pd.merge(accident_summary, population_summary[['구', '2024년07월_계_총인구수']], left_on='시군구', right_on='구')  
# merge() -> 결합한다 (두 데이터프레임을 '시군구'와 '구' 기준으로 병합).

# 7. 인구 대비 사고율 계산 (사고 건수를 인구수로 나누고 1000을 곱해 사고율을 계산합니다)
for accident_type in accident_types:  # 반복문으로 각 사고 유형에 대해 사고율을 계산합니다.
    merged_data[f'{accident_type} 대비 사고율'] = merged_data[accident_type] / merged_data['2024년07월_계_총인구수'] * 1000  
    # 사고 건수를 인구수로 나누고 1000을 곱해 인구 1000명당 사고율을 계산합니다.

# 8. 모든 사고 유형별 인구 대비 사고율 시각화 (stacked bar chart)
merged_data.set_index('구')[[f'{accident_type} 대비 사고율' for accident_type in accident_types]].plot(kind='bar', stacked=True, figsize=(12, 8))  
# set_index() -> 인덱스를 설정한다 (구별로 인덱스를 설정).
# plot() -> 그린다 (데이터를 그래프 형태로 시각화, kind='bar'는 막대 그래프를 의미, stacked=True는 데이터가 쌓여서 표현됨).
# figsize=(12, 8) -> 그래프의 크기를 12x8로 설정합니다.

plt.title('서울특별시 구별 인구 대비 주요 사고 유형별 사고율')  # title() -> 제목을 설정합니다.
plt.xlabel('구')  # xlabel() -> x축 이름을 설정합니다.
plt.ylabel('사고율 (1000명 당)')  # ylabel() -> y축 이름을 설정합니다.
plt.xticks(rotation=45, ha='right')  # xticks() -> x축 눈금 값을 설정하며, 45도 회전시켜 보기가 좋도록 합니다.
plt.tight_layout()  # tight_layout() -> 레이아웃을 자동으로 정리하여 겹치지 않도록 조정합니다.
plt.show()  # show() -> 그래프를 화면에 출력한다.

	</pre>
						</div>
					</div>
<!-- 					<div class="bottom bottom2">
						<div class="dots dots2">
							<img src="/resources/IMG/dots.png" style="width:20px;"/>
						</div>
						<div class="codeResult codeResult2">
							<img src="/resources/IMG/PGY/resultPgy2.png" style="width:1000px;"/>
						</div>
					</div> -->
				</div>
			</div>	
		</div>
		<!-- 반복구간 종료 -->

		
				<c:import url="./footer.jsp" />
	</div>
</body>
</html>
