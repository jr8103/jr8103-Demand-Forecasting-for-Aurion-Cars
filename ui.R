library(shiny)
library(shinythemes)

data <- read.csv("Aurion_Demand_Forecasting.csv")

ui <- navbarPage(
  title = div(
    style = "display:flex; align-items:center;",
    img(src = "logo.png", height = "30px")
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
      img(src = "banner.png", width = "100%")
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
          h3(style = "color:#ffc107;", "1755.02"),
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
          h3(style = "color:#ffc107;","87.15%"),
          p("Forecast accuracy")
        )
      )
      
    ),
    h3("Core Modules:"),
    
    br(),
    
    wellPanel(
      h4("1. Analysis"),
      p("The Analysis module enables users to explore historical vehicle sales data across different Aurion Motors models and variants. It provides interactive visualizations to identify sales trends, seasonal demand patterns, model-wise performance, and customer preferences. These insights support informed business decisions related to production planning, inventory management, and market strategy.")
    ),
    
    wellPanel(
      h4("2. Forecast"),
      p("The Forecast module predicts future demand for Aurion Motors vehicles using advanced time series forecasting techniques such as ETS and ARIMA. Users can generate forecasts for individual models, variants, or the complete product portfolio. The predictions help optimize manufacturing schedules, inventory levels, supply chain operations, and future sales planning.")
    ),
    br(),
    
    
  ),
  
  tabPanel(
    title = tagList(icon("chart-column"), "Analysis"),
    h2("Aurion Motors Sales Analytics"),
    fluidRow(
      
      column(
        width = 4,
        selectInput(
          "model",
          "Choose Model:",
          choices = c(
            "All",
            "Model 1",
            "Model 2",
            "Model 3",
            "Model 4"
          )
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
        3,
        div(
          style = "
      background:#1c1c1c;
      border-radius:15px;
      padding:10px;
      color:white;
      box-shadow:0 0 10px rgba(255,193,7,0.2);
      text-align:center;
      ",
          
          icon("database",
               style = "color:#ffc107;
                    font-size:20px;"),
          
          h4("Total Demand"),
          
          h4(style = "color:#ffc107;",
             textOutput("total_demand")),
          
          p("Units sold")
        )
      ),
      
      column(
        3,
        div(
          style = "
      background:#1c1c1c;
      border-radius:15px;
      padding:10px;
      color:white;
      box-shadow:0 0 10px rgba(255,193,7,0.2);
      text-align:center;
      ",
          
          icon("chart-line",
               style = "color:#ffc107;
                    font-size:20px;"),
          
          h4("Average Demand"),
          
          h4(style = "color:#ffc107;",
             textOutput("avg_demand")),
          
          p("Units per month")
        )
      ),
      
      column(
        3,
        div(
          style = "
      background:#1c1c1c;
      border-radius:15px;
      padding:10px;
      color:white;
      box-shadow:0 0 10px rgba(255,193,7,0.2);
      text-align:center;
      ",
          
          icon("arrow-up",
               style = "color:#ffc107;
                    font-size:20px;"),
          
          h4("Maximum Demand"),
          
          h4(style = "color:#ffc107;",
             textOutput("max_kpi")),
          br()
          
        )
      ),
      
      column(
        3,
        div(
          style = "
      background:#1c1c1c;
      border-radius:15px;
      padding:10px;
      color:white;
      box-shadow:0 0 10px rgba(255,193,7,0.2);
      text-align:center;
      ",
          
          icon("arrow-down",
               style = "color:#ffc107;
                    font-size:20px;"),
          
          h4("Minimum Demand"),
          
          h4(style = "color:#ffc107;",
             textOutput("min_kpi")),
          br()
        )
      )
      
    ),
    br(),
    
    fluidRow(
      
      column(
        width = 8,
        
        div(
          style = "display:flex;
               justify-content:space-between;
               align-items:center;",
          
          h3(
            style = "color:white;",
            "Demand Trend"
          ),
          
          uiOutput("growth_rate")
        ),
        
        plotOutput("trend_plot")
      ),
      
      column(
        width = 4,
        
        conditionalPanel(
          condition = "input.variant == 'All'",
          plotOutput(
            "pie_chart",
            height = "350px",
            width = "385px"
          )
        ),
        
        tags$style(HTML("
      #pie_chart {
        background-color: black !important;
      }
    ")),
        
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
            
            uiOutput("description")
          )
        )
        
      )
      
    )
  ),
  
  tabPanel(
    title = tagList(icon("chart-line"), "Forecast"),
    
    h2("Aurion Motors Demand Forecasting"),
    
    fluidRow(
      
      column(
        3,
        selectInput(
          "modelf",
          "Choose Model:",
          choices = c(
            "All",
            "Model 1",
            "Model 2",
            "Model 3",
            "Model 4"
          )
        )
      ),
      
      column(
        3,
        selectInput(
          "variantf",
          "Choose Variant:",
          choices = "All"
        )
      ),
      
      column(
        3,
        selectInput(
          "forecast_tenure",
          "Training Data Period:",
          choices = c(
            "Overall",
            "1Y",
            "5Y",
            "10Y"
          )
        )
      ),column(
        3,
        selectInput(
          "forecast_model",
          "Forecasting Model:",
          choices = c(
            "ETS",
            "ARIMA",
            "Both"
          )
        )
      )
      
    ),
    
    br(),
    
    conditionalPanel(
      condition = "input.forecast_model == 'ETS'",
      
      plotOutput("ets_plot"),
      
      br(),
      h4(textOutput("forecast_title_ets")),
      tableOutput("ets_table"),
      
      br(),
      h4(textOutput("ets_rmse")),
      h4(textOutput("ets_accuracy"))
    ),
    
    conditionalPanel(
      condition = "input.forecast_model == 'ARIMA'",
      
      plotOutput("arima_plot"),
      
      br(),
      
      h4(textOutput("forecast_title_arima")),
      tableOutput("arima_table"),
      
      br(),
      h4(textOutput("arima_rmse")),
      h4(textOutput("arima_accuracy"))
    ),
    
    conditionalPanel(
      condition = "input.forecast_model == 'Both'",
      
      fluidRow(
        
        column(
          6,
          
          h3("ETS"),
          
          plotOutput("ets_plot2"),
          
          h4("Forecast Result for Year 2026"),
          tableOutput("ets_table2"),
          br(),
          h4(textOutput("ets_rmse2")),
          h4(textOutput("ets_accuracy2"))
        ),
        
        column(
          6,
          
          h3("ARIMA"),
          
          plotOutput("arima_plot2"),
          
          h4("Forecast Result for Year 2026"),
          
          tableOutput("arima_table2"),
          br(),
          h4(textOutput("arima_rmse2")),
          h4(textOutput("arima_accuracy2"))
        )
        
      )
    )
    
  )
)

