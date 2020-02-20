library(dplyr)

#download the data
dat=read.csv("./time_series.csv")%>%
  janitor::clean_names()

datcn=dat%>%
  select(-c(8,10,11,13,15,16,18,19,21,22,30,31,33,35,37,39))%>%
  filter(country_region%in%c("Mainland China","Macau","Hong Kong","Taiwan"))%>%
  mutate(i_province_state=recode(i_province_state,"Anhui"="安徽",
                                 "Beijing"="北京",
                                 "Chongqing"="重庆",
                                 "Fujian"="福建",
                                 "Gansu"="甘肃",
                                 "Guangdong"="广东",
                                 "Guangxi"="广西",
                                 "Guizhou"="贵州",
                                 "Hainan"="海南",
                                 "Hebei"="河北",
                                 "Heilongjiang"="黑龙江",
                                 "Henan"="河南",
                                 "Hubei"="湖北",
                                 "Hunan"="湖南",
                                 "Inner Mongolia"="内蒙古",
                                 "Jiangsu"="江苏",
                                 "Jilin"="吉林",
                                 "Jiangxi"="江西",
                                 "Liaoning"="辽宁",
                                 "Ningxia"="宁夏",
                                 "Qinghai"="青海",
                                 "Shaanxi"="陕西",
                                 "Shanxi"="山西",
                                 "Shandong"="山东",
                                 "Shanghai"="上海",
                                 "Sichuan"="四川",
                                 "Tianjin"="天津",
                                 "Tibet"="西藏",
                                 "Xinjiang"="新疆",
                                 "Yunnan"="云南",
                                 "Zhejiang"="浙江",
                                 "Macau"="澳门",
                                 "Hong Kong"="香港",
                                 "Taiwan"="台湾"
                                 ))


#download map  

library(leafletCN)
datcn%>%geojsonMap("china",namevar =.[[1]],valuevar = .[[15]],
           colorMethod = "quantile", smoothFactor = 0.1,stroke = T,
           palette = "YlOrRd", legendTitle = "Confirmed Cases Quantile")

