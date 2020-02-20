library(shiny)
library(leaflet)
library(leafletCN)
library(dplyr)
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

# Define UI for application that draws a histogram
ui = bootstrapPage(
  
  tags$style(type = "text/css", "html, body {width:100%;height:100%;}"),
    
    leafletOutput("map",width = "100%",height = "100%"),
  absolutePanel(
    top = 10, right=10,style = "z-index:500; text-align:right ;",
    h2("COVID-19 China Map", style = "font-family:'Impact';
        font-weight: 700; line-height: 2; 
        color:  #ad1d28;")
  ),
    absolutePanel(top=100,right=10,draggable = T,
                  width = "20%", style = "z-index:500;;",
                  dateInput("Date",
                            label="Choose between 1/24~2/09",
                            value = "2020-02-09"))
                  
)

# Define server logic required to draw a histogram
server <- function(input, output,session) {
  
   datcn2=reactive({
     date=input$Date
     colu=as.numeric(difftime(date,"2020-01-21",units=c("days")))
     m=datcn%>%
       mutate(cases=.[[5+colu]])
     m=as.data.frame(m)
     m
   })

    output$map=renderLeaflet({
      
      datcn2()%>%geojsonMap( "china",namevar = .[[1]],
                 valuevar = .[["cases"]],
                 colorMethod = "quantile", smoothFactor = 0.1,stroke = T,
                 popup =  paste0(.[[1]], ":", .[["cases"]],"例"),
                 palette = "YlOrRd", legendTitle = "Confirmed Cases Quantile")
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
