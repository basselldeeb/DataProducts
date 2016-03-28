
library(shiny)
library(quantmod)



# Download data for a stock if needed, and return the data
require_symbol <- function(symbol, envir = parent.frame()) {
  if (is.null(envir[[symbol]])) {
    envir[[symbol]] <- getSymbols(symbol, auto.assign = FALSE)
  }
  
  envir[[symbol]]
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Create an environment for storing data
  symbol_env <- new.env()



  # Make a chart for a symbol, with the settings from the inputs
  make_chart <- function(symbol) {
    symbol_data <- require_symbol(symbol, symbol_env)
    
    chartSeries(symbol_data,
                name      = symbol,
                type      = input$chart_type,
                subset    = paste(input$daterange, collapse = "::"),
                ##log.scale = input$log_y,
                theme     = "white",
                TA =  c(paste('addVo()',ifelse(input$MA==TRUE,';addSMA()',''),
                              ifelse(input$MACD==TRUE,';addMACD()',''),
                              ifelse(input$BBands==TRUE,';addBBands()',''),sep='')
                        )
                )
  }  
  
  # Make a chart for a symbol, with the settings from the inputs
  make_chart2 <- function(symbol) {
    symbol_data <- require_symbol(symbol, symbol_env)
    
    chartSeries(Next(symbol_data, k = input$Forecast),
                name      = symbol,
                type      = input$chart_type,
                subset    = paste(input$daterange, collapse = "::"),
                ##log.scale = input$log_y,
                theme     = "white",
                TA =  c(paste('addVo()',ifelse(input$MA==TRUE,';addSMA()',''),
                              ifelse(input$MACD==TRUE,';addMACD()',''),
                              ifelse(input$BBands==TRUE,';addBBands()',''),sep='')
                )
                
    )
  }  
  
  
  
  output$distPlot <- renderPlot({
    validate(need(input$Vector, "Please select a Ticket"))
    ##validate(need(input$dates[1]<input$dates[2], "Please select a correct date Start"))
    ##validate(need(input$dates[2]<=Sys.Date(), "Please select a correct date End"))
    
    
    
    make_chart(input$Vector)
    
    if(input$RSI==TRUE){addRSI()}
    
  })
  
  
  output$downloadData <- downloadHandler( filename = function() {
    paste('Dashboard', Sys.Date(), '.csv', sep='')} ,
    content = function(file){
      write.csv(require_symbol(input$Vector, symbol_env), file)
    })

  output$predict <- renderPlot({
    validate(need(input$Vector, "Please select a Ticket"))
    ##validate(need(input$dates[1]<input$dates[2], "Please select a correct date Start"))
    ##validate(need(input$dates[2]<=Sys.Date(), "Please select a correct date End"))
    
    make_chart2(input$Vector)
    
    
    
    if(input$RSI==TRUE){addRSI()}
    
  })
  


})
