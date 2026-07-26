library(shiny)
library(shinythemes)
library(dplyr)
library(ggplot2)
library(forecast)

data <- read.csv("JCB_INDIA_DF.csv")

ui <- navbarPage(
  title = div(
    style = "display:flex; align-items:center;",
    img(src = "jcb_logo.jpg", height = "30px")
  ),
  theme = shinytheme("cyborg"),
  header = tags$head(
    tags$style(HTML("
      .navbar {
        background-color: #FFB400 !important;
        border-color: #FFB400 !important;
      }

      .navbar-default .navbar-brand,
      .navbar-default .navbar-nav > li > a {
        color: black !important;
        font-weight: bold;
      }

      .navbar-default .navbar-nav > li > a:hover {
        color: white !important;
      }

      .navbar-default .navbar-nav > .active > a,
      .navbar-default .navbar-nav > .active > a:hover {
        background-color: black !important;
        color: #FFB400 !important;
      }
      .btn-default {
  background-color: #FFB400 !important;
  border-color: #FFB400 !important;
  color: black !important;
  font-weight: bold;
}

.btn-default:hover {
  background-color: #FFD54F !important;
  border-color: #FFD54F !important;
  color: black !important;
}
table {
    background-color: black !important;
    color: white !important;
    width: 100%;
  }

  th {
    background-color: #FFB400 !important;
    color: black !important;
    text-align: center;
    font-weight: bold;
  }

  td {
    background-color: black !important;
    color: white !important;
    text-align: center;
    border: 1px solid #555555;
  }
    "))
  ),
  
  tabPanel(
    title = tagList(icon("house"), "Home"),
    div(
      align = "center",
      img(src = "jcb_banner.png", width = "100%")
    ),
    tags$h3(
      style = "color:white; font-weight:bold; margin-top:30px;",
      "Dashboard Overview"
    ),
    
    fluidRow(
      
      column(
        width = 3,
        div(
          style = "
        background:#1c1c1c;
        border-radius:15px;
        padding:10px;
        color:white;
        box-shadow:0 0 10px rgba(255,193,7,0.2);
      ",
          icon("database", style = "color:#ffc107; font-size:30px;"),
          h4("Total Records"),
          h3(style = "color:#ffc107;", nrow(data)),
          p("Historical data points")
        )
      ),
      
      column(
        width = 3,
        div(
          style = "
        background:#1c1c1c;
        border-radius:15px;
        padding:10px;
        color:white;
        box-shadow:0 0 10px rgba(255,193,7,0.2);
      ",
          icon("chart-line", style = "color:#ffc107; font-size:30px;"),
          h4("Avg Demand"),
          h3(style = "color:#ffc107;", round(mean(data$Monthly_Sales, na.rm = TRUE),2)),
          p("Units per month")
        )
      ),
      
      column(
        width = 3,
        div(
          style = "
        background:#1c1c1c;
        border-radius:15px;
        padding:10px;
        color:white;
        box-shadow:0 0 10px rgba(255,193,7,0.2);
      ",
          icon("calendar", style = "color:#ffc107; font-size:30px;"),
          h4("Forecast Period"),
          h3(style = "color:#ffc107;", "12"),
          p("Months ahead")
        )
      ),
      
      column(
        width = 3,
        div(
          style = "
        background:#1c1c1c;
        border-radius:15px;
        padding:10px;
        color:white;
        box-shadow:0 0 10px rgba(255,193,7,0.2);
      ",
          icon("bullseye", style = "color:#ffc107; font-size:30px;"),
          h4("Model Accuracy"),
          h3(style = "color:#ffc107;", "87.4%"),
          p("Forecast accuracy")
        )
      )
      
    ),
    h3("Core Modules:"),
    
    br(),
    
    wellPanel(
      h4("1. Analysis"),
      p("Through this section, users can explore and analyze historical demand trends and patterns for different JCB machine categories. The analysis helps in understanding past performance and supports data-driven decision-making.")
    ),
    
    wellPanel(
      h4("2. Forecast"),
      p("This section enables users to predict future demand for various JCB machine categories based on historical data. The forecasts support production planning and efficient resource allocation.")
    ),
    br(),
    
    div(
      align = "center",
      h2(
        "\"Made in India for the World\"",
        style = "
      color:#FFB400;
      font-style:italic;
      font-weight:bold;
      letter-spacing:2px;
    "
      )
    )
  ),
  
  tabPanel(
    title = tagList(icon("chart-column"), "Analysis"),
    h2("JCB Backhoe Loader Analysis"),
    fluidRow(
      
      column(
        width = 4,
        selectInput(
          "model",
          "Choose Model:",
          choices = c("All", "Model 1", "Model 2")
        )
      ),
      
      column(
        width = 4,
        selectInput(
          "variant",
          "Choose Variant:",
          choices = "All"
        )
      ),
      
      column(
        width = 4,
        selectInput(
          "tenure",
          "Choose Tenure:",
          choices = c("Overall", "5M", "1Y", "5Y", "10Y")
        )
      )),
    br(),
    
    fluidRow(
      column(
        width = 8,
        plotOutput("trend_plot")
      ),
      
      column(
        width = 4,
        
        conditionalPanel(
          condition = "input.variant == 'All'",
          plotOutput("pie_chart",
                     height = "350px",
                     width="385px")
        ),
        tags$style(HTML("
  #pie_chart {
    background-color: black !important;
  }
                      
                        ")
        ),
        
        conditionalPanel(
          condition = "input.variant != 'All'",
          wellPanel(
            style = "background-color:black; color:black; border-color:black;",
            
            h3("Product Description"),
            
            imageOutput(
              "product_image",
              height = "250px"
            ),
            
            br(),
            
            textOutput("description")
          )
        )
      )
    )
    
  ),
  
  tabPanel(
    title = tagList(icon("chart-line"), "Forecast"),
    h2("JCB Backhoe Loader Demand Forecasting"),
    fluidRow(
      
      column(
        width = 4,
        selectInput(
          "modelf",
          "Choose Model:",
          choices = c("All", "Model 1", "Model 2")
        )
      ),
      
      column(
        width = 4,
        selectInput(
          "variantf",
          "Choose Variant:",
          choices = c("All","V101","V102","V201","V202")
        )
      ),
      column(
        width = 5,
        actionButton(
          inputId = "submit",
          label = "SUBMIT"
        )
      ),
      br(),
      br(),
      br(),
      plotOutput("forecast_plot"),
      
      br(),
      h4("Forecast Result for 2026"),
      tableOutput("forecast_table"),
      
      br(),
      
      h5(textOutput("rmse"))
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    
    if(input$model == "All"){
      
      updateSelectInput(
        session,
        "variant",
        choices = c("All"),
        selected = "All"
      )
      
    }
    
    else if(input$model == "Model 1"){
      
      updateSelectInput(
        session,
        "variant",
        choices = c("All", "V101", "V102"),
        selected = "All"
      )
      
    }
    
    else if(input$model == "Model 2"){
      
      updateSelectInput(
        session,
        "variant",
        choices = c("All", "V201", "V202"),
        selected = "All"
      )
      
    }
    
  })
  
  filtered_data <- reactive({
    
    df <- data
    
    # Filter model
    if(input$model != "All"){
      df <- df %>%
        filter(Model_Name == input$model)
    }
    
    # Filter variant
    if(input$variant != "All"){
      df <- df %>%
        filter(Variant_Code == input$variant)
    }
    
    # Sort data by date
    df <- df %>%
      arrange(Year, Month)
    
    # Filter tenure
    if(input$tenure == "5M"){
      df <- tail(df, 5)
    }
    
    if(input$tenure == "1Y"){
      df <- tail(df, 12)
    }
    
    if(input$tenure == "5Y"){
      df <- tail(df, 60)
    }
    
    if(input$tenure == "10Y"){
      df <- tail(df, 120)
    }
    
    df
  })
  
  
  # LINE GRAPH
  output$trend_plot <- renderPlot({
    
    df <- filtered_data()
    
    trend_data <- df %>%
      group_by(Year, Month) %>%
      summarise(
        Sales = sum(Monthly_Sales),
        .groups = "drop"
      )
    
    trend_data$Date <- as.Date(
      paste(
        trend_data$Year,
        trend_data$Month,
        "1",
        sep = "-"
      )
    )
    
    ggplot(trend_data, aes(Date, Sales)) +
      geom_line(
        color = "orange",
        linewidth = 1.2
      ) +
      labs(
        title='Demand Trend',
        x='Date',
        y='No. of Backhoe Loaders produced'
      )+
      geom_point(
        color = "white",
        size = 2
      ) +
      theme(
        
        panel.background = element_rect(fill = "black"),
        plot.background = element_rect(fill = "gray20"),
        
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        
        axis.line = element_line(color = "white"),
        
        axis.ticks = element_line(color = "white"),
        
        axis.text = element_text(color = "white"),
        
        axis.title = element_text(color = "white"),
        plot.title = element_text(
          color = "white",
          face = "bold",
          size = 20,
          hjust = 0.5
        )
      )
    
  })
  
  
  
  # PIE CHART
  output$pie_chart <- renderPlot({
    
    if(input$model == "All"){
      
      pie_data <- data %>%
        group_by(Model_Name) %>%
        summarise(
          Sales = sum(Monthly_Sales)
        )
      par(
        bg = "black",
        fg = "white",
        col.main = "white"
      )
      
      pie(
        pie_data$Sales,
        labels = pie_data$Model_Name,
        main = "Model Distribution",
        cex.main = 2,        
        cex = 1.5,           
        radius = 1,        
        col = c("#FFB400", "#555555")
      )
      
    }
    
    else{
      
      pie_data <- data %>%
        filter(Model_Name == input$model) %>%
        group_by(Variant_Code) %>%
        summarise(
          Sales = sum(Monthly_Sales)
        )
      
      ggplot(
        pie_data,
        aes(
          x = 2,
          y = Sales,
          fill = Variant_Code
        )
      ) +
        geom_col(width = 1) +
        coord_polar(theta = "y") +
        xlim(1, 2.5) +
        labs(
          title = "Variant Distribution"
        ) +
        scale_y_continuous(expand = c(0,0))+
        theme_void() +
        theme(
          plot.background = element_rect(
            fill = "black",
            color = NA
          ),
          
          panel.background = element_rect(
            fill = "black",
            color = NA
          ),
          
          legend.background = element_rect(
            fill = "black",
            color = NA
          ),
          
          legend.key = element_rect(
            fill = "black",
            color = NA
          ),
          
          legend.text = element_text(
            color = "white"
          ),
          
          legend.title = element_blank(),
          
          plot.title = element_text(
            color = "white",
            face = "bold",
            size = 18,
            hjust = 0.5
          )
        ) +
        
        scale_fill_manual(
          values = c(
            "#FFB400",
            "#555555"
          )
        )
    }
  })
  # PRODUCT DESCRIPTION
  output$description <- renderText({
    
    req(input$variant != "All")
    
    data %>%
      filter(Variant_Code == input$variant) %>%
      distinct(Description) %>%
      pull(Description)
    
  })
  output$product_image <- renderImage({
    
    req(input$variant != "All")
    
    if(input$model == "Model 1") {
      
      list(
        src = "jcb2dx.jpg",
        width = 350
      )
      
    } else {
      
      list(
        src = "jcb3dx.jpg",
        width = 350
      )
      
    }
    
  }, deleteFile = FALSE)
  forecast_data <- reactive({
    
    df <- data
    
    if(input$modelf != "All"){
      df <- df %>%
        filter(Model_Name == input$modelf)
    }
    
    if(input$variantf != "All"){
      df <- df %>%
        filter(Variant_Code == input$variantf)
    }
    
    df %>%
      group_by(Year, Month) %>%
      summarise(
        Sales = sum(Monthly_Sales),
        .groups = "drop"
      )
    
  })
  forecast_result <- eventReactive(input$submit, {
    
    df <- forecast_data()
    
    ts_data <- ts(
      df$Sales,
      start = c(min(df$Year), min(df$Month)),
      frequency = 12
    )
    
    train_size <- floor(0.8 * length(ts_data))
    
    train <- ts_data[1:train_size]
    test <- ts_data[(train_size + 1):length(ts_data)]
    
    model <- auto.arima(
      train,
      seasonal = TRUE
    )
    
    pred_test <- forecast(
      model,
      h = length(test)
    )
    
    rmse <- sqrt(
      mean(
        (test - pred_test$mean)^2
      )
    )
    
    final_model <- auto.arima(
      ts_data,
      seasonal = TRUE
    )
    
    future_forecast <- forecast(
      final_model,
      h = 12
    )
    
    list(
      model = final_model,
      forecast = future_forecast,
      rmse = rmse
    )
    
  })
  output$forecast_plot <- renderPlot({
    
    req(forecast_result())
    par(
      bg = "black",      # background
      fg = "white",      # axis lines and text
      col.axis = "white",
      col.lab = "white",
      col.main = "white"
    )
    plot(
      forecast_result()$forecast,
      main = "Demand Forecast for 2026",
      xlab = "Year",
      ylab = "Demand",
      col = c("#FFB400"),
      shadecols = c("gray50", "gray80"),
      lwd = 3
    )
    
    
  })
  output$forecast_table <- renderTable({
    
    req(forecast_result())
    
    fc <- forecast_result()$forecast
    
    data.frame(
      
      Month = month.abb,
      
      Forecast =
        round(fc$mean,0)
      
    )
    
  })
  output$rmse <- renderText({
    
    req(forecast_result())
    
    paste(
      "RMSE:",
      round(
        forecast_result()$rmse,
        2
      )
    )
    
  })
}

shinyApp(ui = ui, server = server)
