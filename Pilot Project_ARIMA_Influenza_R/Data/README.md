# CGRD_Flu

### 研究簡介

 流感為一急性呼吸道傳染病，其傳播力強，並可能導致患者出現流感併發重症或死亡的情形，故為台灣疾管署疾病防治重點之一。流感併發重症現為第四類法定傳染病，醫師及檢疫人員發現案例後需通報案例。目前台灣已發展多元疾病監視系統，協助衛生單位監測、掌握疫情發展，然而監視系統仍有其限制存在。故本研究期能運用長庚醫院的病歷資料篩選流感與流感重症案例，並建立時間序列預測模型。

#### 病程演算法

 <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/episode_CGRD.md/">病程演算法</a>


#### 流感案例

 以ICD-9、ICD-10診斷碼(487* 、J09* 、J10* 、J11*)找出有流感診斷的案例，合併病程後，檢視病程前七天是否有類流感診斷，若有類流感診斷則將其診斷區間加入病程中。取得最後病程，並結合WHO年週，取2010年-2015年間的病程做為案例。

* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/Import_FluDiagnosis.R">篩選流感診斷碼資料<a>

* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluEpisode.R/">病程演算法</a>

* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/ILI_code.rds/">類流感診斷</a>

* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/StartdayExtendedforILI.R/">將病程前七日內的類流感診斷合併入病程中，取2010-2015年病程</a>

 流感相關檢驗包含：流感抗原快速篩檢、A/B型流感病毒RNA檢驗、病毒分離與鑑定、流行性感冒A/B型病毒抗體。各檢驗資料整理過程如下。

 1. <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluRapidTestResultTable.R/">流感抗原快速篩檢 (長庚檢驗代碼:72-768) </a>
 
 2. <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluRNADetectionResultTable.R/">A/B型流感病毒RNA檢驗 (長庚檢驗代碼:72-906) </a>
 
 3. <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/positiveVirusIsolation.R/">病毒分離與鑑定 (長庚檢驗代碼:72-901) </a>
 
4. <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluIgGResultTable.R/">流行性感冒A/B型病毒抗體 (長庚檢驗代碼:72-959,72-960,72-961)  </a>

 若其中一項檢驗為陽性，則為有檢驗數據支持的流感案例，亦為本研究的目標族群，篩選過程程式碼如 <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluCasesCriteria.R/">附檔 </a>。
 * <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/Flu_episode2010to2015_FluVirus.rds">結果檔 </a>
 
 FluCases欄位標籤 | 說明 
 --- | ---
FluPositive | 至少一項流感檢驗案例
FluNegative | 曾於病程內進行流感檢驗，但流感檢驗結果為陰性
nolab | 於病程內未進行流感檢驗

 <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluDrug.R/">流感相關用藥</a>

藥物名稱 | 途徑 | 長庚藥物代碼 
--- | --- | ---
TAMIFLU(OSELTAMIVIR)75MG/CAP | 口服 | PZA183M、PNA021M、PNA025M、P4A090M、P4A133M
ZANAMIVIR DISKHALER 5MG/BLISTER | 吸劑 | P4A045E、P6A545E
PERAMIVIR 300MG/60ML/BAG | 針劑 | P6A890P

#### 流感重症案例
**定義：使用流感案例，排除無住院紀錄(<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluCasesWithoutAdmission.R/">程式碼</a>)者，且符合肺部合併症、侵襲性細菌感染或心肌炎定義者**<br>

1. 肺部合併症

**定義：至少接受一次X光檢查者，且符合下列任一條件（接受呼吸治療、插管、急救處置、痰液培養呈現陽性、進行動脈血氧氣體分析**<br>

* 條件篩選過程(<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluComplication_Pulmonary_Order.R/">醫囑</a>、<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/Drug_ACLSandINHA.R/">藥物</a>、<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/SputumCulture.R/">痰液培養</a>、<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/BloodGasAnalysis.R/">動脈血氧氣體分析</a>)


2. 侵襲性細菌感染

**定義：Blood culture異常者或具敗血症或毒性休克症候群診斷碼的案例**<br>
* 檢驗條件：<br>
Blood Culture (長庚檢驗代碼:72-607，檢體類型:血液)，檢驗結果若有培養出細菌為異常<br>
* 診斷條件：<br>
敗血症ICD：78552, 9959, 99590, 99591, 99592, 99593, 99594, R7881, R651, R652, R6510, R6511, R6520, R6521<br>
毒性休克症候群ICD：04082, 04089, A483<br>
* 條件篩選過程(<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/BloodCulture.R/">檢驗</a>、<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/InvasiveBaterialInfection_Diagnosis.R/">診斷</a>)

3. 心肌炎/心包膜炎

**定義：Troponin-I 或CK檢驗數值異常者，且過去沒有慢性心臟疾病病史的案例**<br>
* 檢驗條件：<br>
Troponin-I (長庚檢驗代碼:72-566)，檢驗結果值介於0.04ng/ml和0.3ng/ml之間為異常<br>
CK(長庚檢驗代碼:72-555, 72-374)，男性CK>200ng/ml、女性>180ng/ml為異常<br>
* 診斷條件：<br>
慢性心臟疾病ICD：410, 411, 412, 413, 414, I20, I21, I22, I23, I24, I25<br>

* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/FluComplication_Myopathy.R/"> 條件篩選過程(檢驗、診斷)</a>
 

#### 人口學資料 ( * <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/WHOAgeGroup.R/"> 年齡、年齡層分佈 </a>)

年齡層標籤 | 0-4 | 5-14 | 15-49 | 50-64 | 65-74 | 75+
--- | --- | --- | --- | --- | --- | ---
年齡區間 | <5 | >=5&<15 | >=15&<50 | >=50&<65 | >=65&<75 | >=75

#### Virus Coinection

**定義：流感相關檢驗為陽性且病毒培養結果為陽性者**<br>

* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/positiveVirusIsolation.R/">病毒培養結果整理</a>
 
#### Bacterial Coinection

**定義：流感相關檢驗為陽性且細菌培養結果為陽性者**<br>

* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/BacteriaCultureData.R/">細菌培養結果整理</a>

將細菌培養結果進行分組(共兩組)，Grouping 1 為依照菌種分類，Grouping 2 分為Gram positive、Gram negative、Fungus、Mycobactrium四類，分類過程以EXCEL處理，整理結果如* <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/BacterialCultureData_Grouping.csv/">表格</a>

#### * <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/Flu_episode2010to2015_Summarize.R/"> 案例彙整大表</a>
<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/Demographic.R/"> 資料敘述</a>

#### 重症案例與非重症案例比較

主要使用tableone套件，此套件使用方法可參考此<a href="https://cran.r-project.org/web/packages/tableone/vignettes/introduction.html">連結</a>
 
 <a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/tableone_Analysis.R/">人口學資料比較</a>
<a href="https://github.com/DHLab-CGU/CGRD_Flu/blob/master/tableone_CultureDataAnalysis.R/">培養資料比較</a>

#### 預測模型

*1. ETS模型*

*2. ARIMA 模型*

*3. Prophet 模型*

- 模型成效評估方式：

1. RMSE

2. MAE
