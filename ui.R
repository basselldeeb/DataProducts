library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  headerPanel('Stock Loader'),
  
  sidebarPanel(selectInput("Vector", "Select Ticker", 
                           c('','AAPL','AXP','BA','CAT','CSCO','CVX','DD','DIS','GE','GS','HD','IBM','INTC','JNJ','JPM','KO','MCD','MMM','MRK','MSFT','NKE','PFE','PG','TRV','UNH','UTX','V','VZ','WMT','XOM'
                           ), selected = 0, multiple = FALSE),
               dateRangeInput("daterange", "Choose Start Date:", start = Sys.Date() - 365, end = Sys.Date()
                              ),
               selectInput(inputId = "chart_type",
                           label = "Chart type",
                           choices = c("Candlestick" = "candlesticks",
                                       "Matchstick" = "matchsticks",
                                       "Bar" = "bars",
                                       "Line" = "line"
                              )),
               wellPanel(
                 p(strong("indicators")),
                 checkboxInput(inputId = "RSI", label = "RSI Indicator",     value = FALSE),
                 checkboxInput(inputId = "MA", label = "Moving Avg",     value = FALSE),
                 checkboxInput(inputId = "MACD", label = "MACD Indicator",     value = FALSE),
                 checkboxInput(inputId = "BBands", label = "BBands Indicator",     value = FALSE)
               ),
                 sliderInput("Forecast",
                             "Number of days to Predict:",
                             min = 1,
                             max = 50,
                             value = 0),
                 
               
               downloadButton('downloadData', 'Download')
  ),
  
  mainPanel(
    tabsetPanel(type = "tabs", 
                tabPanel("Plot", plotOutput("distPlot")), 
                tabPanel("Predict", plotOutput("predict"))
    ))
  
))


