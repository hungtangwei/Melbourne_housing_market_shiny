# server.R
#install.packages('shiny')
#install.packages('leaflet')
#install.packages('shinythemes')
#install.packages('tidyr')
#install.packages('ggplot2')
#install.packages('DT')
#install.packages('shinyWidgets')
#install.packages('plotly')
#install.packages('lubridate')
#install.packages('caret')
#install.packages('stringr')
#install.packages('rgdal')

library(ggplot2)
library(shiny)
library(leaflet)
library(plyr)
library(dplyr)
library(tidyr)
library(lubridate)
library(caret)
library(stringr)
library(DT)
library(rgdal)
library(plotly)
library(shinythemes)
library(shinyWidgets)


vic_map=readOGR('VIC_LOCALITY_POLYGON_shp.shp')
melData = read.csv("housing_final.csv")
month_years_list <- c('2016/02','2016/04','2016/05','2016/06','2016/07','2016/08','2016/09',
                      '2016/10','2016/11','2016/12','2017/02','2017/03','2017/04','2017/05','2017/06','2017/07',
                      '2017/08','2017/09','2017/10','2017/11','2017/12','2018/01','2018/02','2018/03')


shinyServer(function(input, output) {
  SelectedSuburb <- reactive({
    paste("Suburb: ", input$Suburb)
  })
  
  # Return the text 
  output$SelectSuburb <- renderText({SelectedSuburb()})
  
  # Plot for the Top 10 suburb
  output$top_10_plot <- renderPlotly({
      index_time=match(input$month_year,month_years_list)
      select_month=month_years_list[1:index_time]
      mel_data=filter(melData, Year.Month %in% select_month)
      mel_data=filter(mel_data, Type %in% input$TypeFinder1)
      suburb_vs_price <- mel_data[c("Suburb","Price","Regionname","Incidents.Recorded","Postcode")] %>% na.omit() #remove 2688 NA observations
      top10sub_by_averprice <- suburb_vs_price %>% group_by(Suburb,Regionname) %>%
        summarise(Average = median(Price),Crime=as.integer(mean(Incidents.Recorded)),Post_code=median(Postcode)) %>%
        arrange(desc(Average)) %>% head(10)
      top10sub_by_averprice$Average2 = scales::dollar(top10sub_by_averprice$Average)
      g<-ggplot(top10sub_by_averprice, aes(reorder(Suburb, Average), Average, fill = Regionname,text = paste("Suburb: ", Suburb,
                                                                                                             "<br>Postcode: ", Post_code,
                                                                                                             "<br>price: $", Average,
                                                                                                             "<br>Regionname: ", Regionname,
                                                                                                             "<br>Crime rate: ", Crime)))+
        geom_bar(stat = "identity")+
        theme(legend.background = element_rect(fill="lightblue",
                                               size=0.3, linetype="solid", 
                                               colour ="darkblue"))+
        labs(x = "Suburb", y = "Average Price of House",
             title = "Top 10 Suburbs by the Average Price of House")+
        geom_text(aes(x = Suburb, y = 1, label = paste0("                     (",Average2,")",sep="")),
                  hjust=0, vjust=.5, size = 4, colour = 'black',
                  fontface = 'bold') +
        scale_y_continuous(breaks = c(seq(1000000,6000000,1000000)),
                           labels = c(paste("$", 1:6, "m", sep = "")))+
        coord_flip()
      ggplotly(g,tooltip = "text") 
  })
  
  
  
  # Plot for the House Distribution
  output$DistplayMap <- renderLeaflet({
    if (input$Suburb=='All') {
      map_data=melData
      final_map=filter(map_data, Type %in% input$TypeFinder)
      all_center_lon = median(final_map$Longtitude)
      all_center_lat = median(final_map$Lattitude)
    } else {
      map_data=melData[(melData$Suburb==input$Suburb),]
      final_map=filter(map_data, Type %in% input$TypeFinder)
      all_center_lon = median(final_map$Longtitude)
      all_center_lat = median(final_map$Lattitude)
    }
    getColor <- function(house) {
      sapply(house$Type, function(type) {
        if(type == 'h') {
          "green"
        } else if(type == 'u') {
          "orange"
        } else {
          "red"
        } })
    }
    icons <- awesomeIcons(
      icon = 'ios-close',
      iconColor = 'black',
      library = 'ion',
      markerColor = getColor(final_map)
    )
    leaflet(final_map) %>% addTiles() %>%
      addAwesomeMarkers(lng = ~Longtitude, lat = ~Lattitude, icon=icons,
                 popup = paste0(
                   "<b>Address: </b>"
                   , final_map$Address
                   , "<br>"
                   , "<b>Suburb: </b>"
                   , final_map$Suburb
                   , "<br>"
                   , "<b>Price: </b>"
                   , paste0("$AU",prettyNum(final_map$Price, big.mark=","))
                   , "<br>"
                   , "<b>Type: </b>"
                   , final_map$Type
                   , "<br>"
                   , "<b>Date: </b>"
                   , final_map$Date
                   , "<br>"
                   , "<b>Nearst Train Station: </b>"
                   , final_map$train_station_name
                   , "<br>"
                   , "<b>Time to City: </b>"
                   , paste0(as.integer(final_map$travel_min_to_CBD),' min')
                   , "<br>"),
                 clusterOptions = markerClusterOptions()
      )%>%
      addLegend(title="Type", position="bottomright", opacity=0.8,colors=c("green",'orange','red'),labels = c("House","Unit","Townhouse"))%>%
      # controls
      setView(lng=all_center_lon, lat=all_center_lat, zoom=11.5)
  })
  
  
  # Plot for the House Distribuion(trend of price in tooltip) 
  output$trend_plot1 <- renderPlot({
    if (input$Suburb=='All') {
      map_data=melData
      final_map=filter(map_data, Type %in% input$TypeFinder)
      final_map$Date <- as_date(final_map$Date)
      Type_hPrice_Date <- final_map[c("Suburb","Price","Date")] 
      Type_haverPrice_date <- Type_hPrice_Date %>% group_by(Date) %>%
        summarise(Average = sum(Price)/n())
      ggplot(Type_haverPrice_date, aes(Date, Average))+
        geom_line()+
        labs(y = "Price")
      
    } else {
      map_data=melData[(melData$Suburb==input$Suburb),]
      final_map=filter(map_data, Type %in% input$TypeFinder)
      final_map$Date <- as_date(final_map$Date)
      Type_hPrice_Date <- final_map[c("Suburb","Price","Date")] 
      Type_haverPrice_date <- Type_hPrice_Date %>% group_by(Date) %>%
        summarise(Average = sum(Price)/n())
      ggplot(Type_haverPrice_date, aes(Date, Average))+
        geom_line()+
        labs(y = "Price")
    }
    
  })
  
  
  # Plot for the House Distribuion(house number in tooltip) 
  output$house_number <- renderText({
    if (input$Suburb=='All') {
      map_data=melData
      final_map=filter(map_data, Type %in% input$TypeFinder)
      paste0(prettyNum(nrow(final_map), big.mark=","), " houses")
    } else {
      map_data=melData[(melData$Suburb==input$Suburb),]
      final_map=filter(map_data, Type %in% input$TypeFinder)
      paste0(prettyNum(nrow(final_map), big.mark=","), " houses")
    }
  })
  
  # Plot for the House Distribuion(average price in tooltip) 
  output$median_price <- renderText({
    if (input$Suburb=='All') {
      map_data=melData
      final_map=filter(map_data, Type %in% input$TypeFinder)
      paste0(prettyNum(median(final_map$Price), big.mark=","), " $AU")
    } else {
      map_data=melData[(melData$Suburb==input$Suburb),]
      final_map=filter(map_data, Type %in% input$TypeFinder)
      paste0(prettyNum(median(final_map$Price), big.mark=","), " $AU")
    }
  })
  
  
  # Plot for suburb comparision (trend of price)
  output$suburb_price_trend <- renderPlotly({
    select_suburbs <-c(input$Suburb1,input$Suburb2)
    tab3_plot=filter(melData, Suburb%in% select_suburbs)
    tab3_plot$Date <- as_date(tab3_plot$Date)
    suburb_price_date <- tab3_plot[c("Suburb","Price","Date")] 
    final_suburb_trend <- suburb_price_date %>% group_by(Suburb,Date) %>%
      summarise(Average = as.integer(sum(Price)/n()))
    trend1<-ggplot(final_suburb_trend, aes(Date, Average,colour=Suburb))+
      geom_line()+
      geom_point(aes(colour=factor(Suburb)))+
      ggtitle('The trend of average price')+
      scale_y_continuous(breaks = c(seq(1000000,6000000,1000000)),
                         labels = c(paste("$", 1:6, "m", sep = "")))+
      labs(y = "Price")
    ggplotly(trend1,tooltip = c('Suburb','Date','Average')) 

  })
  
  
  # Plot for suburb comparision (house number)
  output$suburb_house <- renderPlotly({
    select_suburbs <-c(input$Suburb1,input$Suburb2)
    tab3_plot2=filter(melData, Suburb %in% select_suburbs)
    Suburb_type <- tab3_plot2[c("Suburb","Type")] 
    Suburb_type_count <- Suburb_type %>% group_by(Suburb,Type) %>%
      summarise(Count = n())
    
    p1=ggplot(Suburb_type_count,aes(x=Suburb,y=Count,fill=Type))+
      geom_bar(position="stack", stat="identity")+
      labs(title="House Number",y="Count")+
      scale_fill_discrete(name = "Type", labels = c("House", "Townhouse", "Unit"))

    ggplotly(p1) 
  })
  
  
  # Plot for suburb comparision (crime rate)
  output$suburb_crime <- renderPlotly({
    select_suburbs <-c(input$Suburb1,input$Suburb2)
    tab3_plot2=filter(melData, Suburb %in% select_suburbs)
    crime_suburb <- tab3_plot2[c("Suburb","Incidents.Recorded","Year")] 
    suburb_crime_count <- crime_suburb %>% group_by(Suburb,Year) %>%
      summarise(Crime_rate = as.integer(sum(Incidents.Recorded)/n()))
    
    p2 <- ggplot(suburb_crime_count,aes(x=Year,y=Crime_rate,fill=Suburb))+
      geom_bar(position="dodge", stat="identity")+
      labs(title="Crime Rate",y="Crime Count")
    
    p2
    ggplotly(p2) 
  })
  
  
  # For data table
  output$table <- DT::renderDataTable(DT::datatable({
    data <- melData
    if (input$Suburb3 != "All") {
      data <- data[data$Suburb == input$Suburb3,]
    }
    if (input$Type3 != "All") {
      data <- data[data$Type == input$Type3,]
    }
    if (input$year_month3 != "All") {
      data <- data[data$Year_Month == input$year_month3,]
    }
    data[c("Suburb","Address","Rooms","Type","Price","Date","Lattitude","Longtitude","Regionname","Incidents.Recorded","Year_Month")]
  }))
  
  
})