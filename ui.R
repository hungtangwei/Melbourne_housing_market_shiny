#install.packages('shiny')
#install.packages('leaflet')
#install.packages('shinythemes')
#install.packages('tidyr')
#install.packages('ggplot2')
#install.packages('DT')
#install.packages('shinyWidgets')
#install.packages('plotly')

library(shiny)
library(leaflet)
library(shinythemes)
library(tidyr)
library(ggplot2)
library(DT)
library(shinyWidgets)
library(plotly)


#read coral data
housing_Data<-read.csv('housing_final.csv')
suburb_list<-c('All','Abbotsford','Aberfeldie','Airport West','Albanvale','Albert Park','Albion','Alphington','Altona','Altona Meadows','Altona North','Ardeer',
               'Armadale','Ascot Vale','Ashburton','Ashwood','Aspendale','Aspendale Gardens','Attwood','Avondale Heights','Bacchus Marsh','Balaclava','Balwyn',
               'Balwyn North','Bayswater','Bayswater North','Beaconsfield','Beaconsfield Upper','Beaumaris','Bellfield','Bentleigh','Bentleigh East','Berwick',
               'Black Rock','Blackburn','Blackburn North','Blackburn South','Bonbeach','Boronia','Botanic Ridge','Box Hill','Braybrook','Briar Hill','Brighton',
               'Brighton East','Broadmeadows','Brookfield','Brooklyn','Brunswick','Brunswick East','Brunswick West','Bulla','Bulleen','Bullengarook','Bundoora','Burnley','Burnside','Burnside Heights','Burwood',
               'Burwood East','Cairnlea','Camberwell','Campbellfield','Canterbury','Carlton','Carlton North','Carnegie',
               'Caroline Springs','Carrum','Carrum Downs','Caulfield','Caulfield East','Caulfield North','Caulfield South','Chadstone','Chelsea','Chelsea Heights','Cheltenham','Chirnside Park','Clarinda','Clayton','Clayton South',
               'Clifton Hill','Clyde North','Coburg','Coburg North','Coldstream','Collingwood','Coolaroo','Craigieburn','Cranbourne','Cranbourne North','Cranbourne West','Cremorne','Croydon','Croydon Hills','Croydon North',
               'Croydon South','Dallas','Dandenong','Dandenong North','Deepdene','Deer Park','Delahey','Derrimut','Diamond Creek',
               'Diggers Rest','Dingley Village','Docklands','Doncaster','Doncaster East','Donvale','Doreen','Doveton','Eaglemont',
               'East Melbourne','Edithvale','Elsternwick','Eltham','Eltham North','Elwood','Emerald','Endeavour Hills','Epping',
               'Essendon','Essendon North','Essendon West','Eumemmerring','Eynesbury','Fairfield','Fawkner','Ferntree Gully','Ferny Creek',
               'Fitzroy','Fitzroy North','Flemington','Footscray','Forest Hill','Frankston','Frankston North',
               'Frankston South','Gardenvale','Gisborne','Gisborne South','Gladstone Park','Glen Huntly','Glen Iris',
               'Glen Waverley','Glenroy','Gowanbrae','Greensborough','Greenvale','Hadfield','Hallam','Hampton','Hampton East','Hampton Park',
               'Hawthorn','Hawthorn East','Healesville','Heatherton','Heathmont','Heidelberg','Heidelberg Heights','Heidelberg West','Highett',
               'Hillside','Hoppers Crossing','Hughesdale','Huntingdale','Hurstbridge','Ivanhoe','Ivanhoe East','Jacana',
               'Kalkallo','Kealba','Keilor','Keilor Downs','Keilor East','Keilor Lodge','Keilor Park','Kensington','Kew',
               'Kew East','Keysborough','Kilsyth','Kings Park','Kingsbury','Kingsville','Knoxfield','Kooyong','Kurunjang',
               'Lalor','Langwarrin','Laverton','Lilydale','Lower Plenty','Lynbrook','Lysterfield','Maidstone','Malvern','Malvern East',
               'Maribyrnong','McKinnon','Meadow Heights','Melbourne','Melton','Melton South','Melton West','Mentone','Mernda',
               'Mickleham','Middle Park','Mill Park','Mitcham','Monbulk','Mont Albert','Montmorency','Montrose','Moonee Ponds','Moorabbin',
               'Mooroolbark','Mordialloc','Mount Evelyn','Mount Waverley','Mulgrave','Murrumbeena','Narre Warren','New Gisborne','Newport',
               'Niddrie','Noble Park','North Melbourne','North Warrandyte','Northcote','Notting Hill','Nunawading','Oak Park','Oakleigh',
               'Oakleigh East','Oakleigh South','Officer','Ormond','Pakenham','Parkdale','Parkville','Pascoe Vale','Patterson Lakes',
               'Plenty','Plumpton','Point Cook','Port Melbourne','Prahran','Preston','Princes Hill','Research','Reservoir','Richmond',
               'Riddells Creek','Ringwood','Ringwood East','Ringwood North','Ripponlea','Rockbank','Rosanna','Rowville','Roxburgh Park',
               'Sandhurst','Sandringham','Scoresby','Seabrook','Seaford','Seaholme','Seddon','Silvan','Skye','South Kingsville',
               'South Melbourne','South Morang','South Yarra','Southbank','Spotswood','Springvale','Springvale South','St Albans','St Helena','St Kilda',
               'Strathmore','Strathmore Heights','Sunbury','Sunshine','Sunshine North','Sunshine West','Surrey Hills','Sydenham',
               'Tarneit','Taylors Hill','Taylors Lakes','Templestowe','Templestowe Lower','The Basin','Thomastown','Thornbury',
               'Toorak','Travancore','Truganina','Tullamarine','Upwey','Vermont','Vermont South','Viewbank','Wallan','Wandin North',
               'Wantirna','Wantirna South','Warrandyte','Warranwood','Waterways','Watsonia','Watsonia North','Wattle Glen',
               'Werribee','Werribee South','West Footscray','West Melbourne','Westmeadows','Wheelers Hill','Whittlesea','Wildwood',
               'Williams Landing','Williamstown','Williamstown North','Windsor','Wollert',
               'Wonga Park','Wyndham Vale','Yallambie','Yarra Glen','Yarraville')
month_years_list <- c('2016/02','2016/04','2016/05','2016/06','2016/07','2016/08','2016/09',
                      '2016/10','2016/11','2016/12','2017/02','2017/03','2017/04','2017/05','2017/06','2017/07',
                      '2017/08','2017/09','2017/10','2017/11','2017/12','2018/01','2018/02','2018/03')
suburb_list1<-suburb_list[2:339]

bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  navbarPage(theme= shinytheme("flatly"),collapsible = TRUE,"FIT 5147 Narrative Visualisation Project", id='nav',
             
             #---------The sheet of home page----------
             tabPanel("Home", value="home",
                      tags$head(tags$script(HTML('
                                                       var fakeClick = function(tabName) {
                                                       var dropdownList = document.getElementsByTagName("a");
                                                       for (var i = 0; i < dropdownList.length; i++) {
                                                       var link = dropdownList[i];
                                                       if(link.getAttribute("data-value") == tabName) {
                                                       link.click();
                                                       };
                                                       }
                                                       };
                                                       '))),
                      fluidRow(
                        HTML("
                                     
                                     <section class='banner'>
                                     <center><h2 class='parallax'>The House Market In Victoria</h2></center>
                                     <center><p class='parallax_description'>A guide helps you understand the house market in Victoria.</p></center><br>
                                     </section>
                                     ")
                      ),
                      fluidRow(
                        column(12,
                               HTML('<center><img src="news_Melbourne_AdobeStock.jpg"></center>')
                        )
                      ),
                      
                      fluidRow(
                        column(3),
                        column(6,
                               shiny::HTML("<br><br><center> <h1>What you'll find here</h1> </center><br>"),
                               shiny::HTML("<center><h5>An interactive tool to help you explore the house market in Victoria. With information about the 
                                                   trend of houses price, the Type of house, the Crime rate, and more, you can 
                                                   compare two suburb and then choose what's your favorite.</h5><br><center>")
                        ),
                        column(3)
                      ),
                      fluidRow(
                        column(3),
                        
                        column(2,
                               div(class="panel panel-default", 
                                   div(class="panel-body",  width = "600px",
                                       align = "center",
                                       div(
                                         tags$img(src = "one.png", 
                                                  width = "50px", height = "50px")
                                       ),
                                       div(
                                         h5(
                                           "The Distribution of the houses in Victoria. "
                                         )
                                       )
                                   )
                               )
                        ),
                        column(2,
                               div(class="panel panel-default",
                                   div(class="panel-body",  width = "600px", 
                                       align = "center",
                                       div(
                                         tags$img(src = "two.png", 
                                                  width = "50px", height = "50px")
                                       ),
                                       div(
                                         h5(
                                           "The bar chart race of the Top 10 suburbs."
                                         )
                                       )
                                   )
                               )
                        ),
                        column(2,
                               div(class="panel panel-default",
                                   div(class="panel-body",  width = "600px", 
                                       align = "center",
                                       div(
                                         tags$img(src = "three.png", 
                                                  width = "50px", height = "50px")),
                                       div(
                                         h5(
                                           "The Comparison tool for two suburbs."
                                         )
                                       )
                                   )
                               )
                        ),
                        column(3)
                        
                      ),
                      
                      fluidRow(
                        style = "height:50px;"),
                      
                      tags$hr(),
                      
                      fluidRow(shiny::HTML("<center> <h1>Ready to Get Started?</h1> </center>
                                                 <br>")
                      ),
                      
                      fluidRow(
                        column(3),
                        column(6,
                               tags$div(align = "center", 
                                        tags$a("Start", 
                                               onclick="fakeClick('tab1')", 
                                               class="btn btn-primary btn-lg")
                               )
                        ),
                        column(3)
                      ),
                      fluidRow(style = "height:25px;"
                      )
                      
                      ),
             

             #--------The sheet of Houses Distribution-------
             
             tabPanel("Houses Distribution", value = "tab1",
                      div(class="outer",
                          tags$head(includeCSS("styles.css")),
                      leafletOutput("DistplayMap", width = "100%", height = "100%"),
                      absolutePanel(id = "controls", class = "panel panel-default",
                                    top = 75, left = 55, width = 250, fixed=TRUE,
                                    draggable = TRUE, height = "auto",
                                    
                                    span(tags$i(h6("The distribution of houses in Victoria house market for each Suburb")), style="color:#045a8d"),
                                    h3(textOutput("house_number"), align = "right"),
                                    span(h4(textOutput("median_price"), align = "right"), style="color:#cc4c02"),
                                    plotOutput("trend_plot1", height="130px", width="100%"),
                                    
                                    selectInput("Suburb",
                                                "Suburb:", 
                                                choices = suburb_list),

                                    checkboxGroupInput(inputId = "TypeFinder",
                                         label = "Select Type(s):",
                                         choices = c("House" = "h", "Unit" = "u","Townhouse" = "t"),
                                         selected = "h")),
             )),

             
             
             #--------The sheet of Top 10 Suburbs-------
             
             tabPanel("Top 10 Suburbs",
                      plotlyOutput("top_10_plot"),
                      column(3,
                             absolutePanel(top = 500, left = 55, width = 300, fixed=TRUE,
                                           draggable = TRUE, height = "auto",
                                           
                                           sliderTextInput(
                                             inputId = "month_year", label = h4(tags$b("Select Month/Year:")), 
                                             choices = month_years_list, 
                                             #selected = range(month_years_list), 
                                             grid = TRUE,
                                             animate=animationOptions(interval = 3000, loop = FALSE)),
                                          
                                            checkboxGroupInput(inputId = "TypeFinder1",
                                                              label = "Select Type(s):",
                                                              choices = c("House" = "h", "Unit" = "u","Townhouse" = "t"),
                                                              selected = c("h","u","t"))
                             )),
             ),
             
             
             
             #--------The sheet of Compare Suburb-------
             
             tabPanel("Compare Suburbs",fluidPage(
                      fluidRow(
                        column(6,
                          selectInput("Suburb1",
                                    "Select Suburb 1:", 
                                    choices = suburb_list1)),
                        
                        column(6,selectInput("Suburb2",
                                      "Select Suburb 2:", 
                                      choices = suburb_list1,
                                      selected = 'Albion')
                          ),
                        
                        column(12,hr()
                        ),
                        
                        column(5,
                               plotlyOutput("suburb_house")
                        ),
                        
                        column(7,
                               plotlyOutput("suburb_crime")
                        ),
                        
                        column(12,
                               hr(),
                               plotlyOutput("suburb_price_trend")
                        ),
                      ),
                      )
                      ),
             
             
             
             #--------The sheet of Data Table-------
             
             tabPanel('Data',
                      titlePanel("DataTable"),
                      fluidRow(
                        column(4,
                               selectInput("Suburb3",
                                           "Suburb:",
                                           c("All",
                                             unique(as.character(housing_Data$Suburb))))
                        ),
                        column(4,
                               selectInput("Type3",
                                           "Type:",
                                           c("All",
                                             unique(as.character(housing_Data$Type))))
                        ),
                        column(4,
                               selectInput("year_month3",
                                           "Year/Month:",
                                           c("All",
                                             unique(as.character(housing_Data$Year_Month))))
                        )
                      ),
                      # Create a new row for the table.
                      DT::dataTableOutput("table")
                      )

             )
)







