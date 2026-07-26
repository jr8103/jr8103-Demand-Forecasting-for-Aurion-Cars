library(shiny)
library(dplyr)
library(ggplot2)
library(forecast)

data <- read.csv("Aurion_Demand_Forecasting.csv")

server <- function(input, output, session) {
  
  observe({
    
    if(input$model == "All"){
      
      variants <- "All"
      
    } else {
      
      variants <- c(
        "All",
        sort(
          unique(
            data$Variant_Code[
              data$Model_Name == input$model
            ]
          )
        )
      )
      
    }
    
    updateSelectInput(
      session,
      "variant",
      choices = variants,
      selected = "All"
    )
    
  })
  
  observe({
    
    if(input$modelf == "All"){
      
      variants <- "All"
      
    } else {
      
      variants <- c(
        "All",
        sort(
          unique(
            data$Variant_Code[
              data$Model_Name == input$modelf
            ]
          )
        )
      )
      
    }
    
    updateSelectInput(
      session,
      "variantf",
      choices = variants,
      selected = "All"
    )
    
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
    
    
    df <- df %>%
      group_by(Year, Month) %>%
      summarise(
        Monthly_Sales = sum(Monthly_Sales),
        .groups = "drop"
      ) %>%
      arrange(Year, Month)
    
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
  output$growth_rate <- renderUI({
    
    growth_data <- filtered_data() %>%
      group_by(Year, Month) %>%
      summarise(
        Sales = sum(Monthly_Sales),
        .groups = "drop"
      )
    
    n <- nrow(growth_data)
    
    if (n < 2)
      return(span(""))
    
    first_value <- growth_data$Sales[1]
    last_value <- growth_data$Sales[n]
    
    growth <- ((last_value - first_value) / first_value) * 100
    
    if (growth >= 0) {
      
      span(
        style = "color:#00FF00;
               font-size:18px;
               font-weight:bold;",
        paste0("↑ ", round(growth, 2), "% Growth")
      )
      
    } else {
      
      span(
        style = "color:#FF4444;
               font-size:18px;
               font-weight:bold;",
        paste0("↓ ", abs(round(growth, 2)), "% Decline")
      )
      
    }
    
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
  
  output$total_demand <- renderText({
    
    monthly_data <- filtered_data() %>%
      group_by(Year, Month) %>%
      summarise(
        Sales = sum(Monthly_Sales),
        .groups = "drop"
      )
    
    format(sum(monthly_data$Sales), big.mark = ",")
    
  })
  output$avg_demand <- renderText({
    
    monthly_data <- filtered_data() %>%
      group_by(Year, Month) %>%
      summarise(
        Sales = sum(Monthly_Sales),
        .groups = "drop"
      )
    
    round(mean(monthly_data$Sales), 2)
    
  })
  output$max_kpi <- renderText({
    
    if(input$model == "All"){
      
      temp <- data %>%
        group_by(Model_Name) %>%
        summarise(Sales = sum(Monthly_Sales))
      
      temp$Model_Name[which.max(temp$Sales)]
      
    } else if(input$variant == "All"){
      
      temp <- data %>%
        filter(Model_Name == input$model) %>%
        group_by(Variant_Code) %>%
        summarise(Sales = sum(Monthly_Sales))
      
      temp$Variant_Code[which.max(temp$Sales)]
      
    } else{
      
      paste(max(filtered_data()$Monthly_Sales), "units")
      
    }
    
  })
  output$min_kpi <- renderText({
    
    if(input$model == "All"){
      
      temp <- data %>%
        group_by(Model_Name) %>%
        summarise(Sales = sum(Monthly_Sales))
      
      temp$Model_Name[which.min(temp$Sales)]
      
    } else if(input$variant == "All"){
      
      temp <- data %>%
        filter(Model_Name == input$model) %>%
        group_by(Variant_Code) %>%
        summarise(Sales = sum(Monthly_Sales))
      
      temp$Variant_Code[which.min(temp$Sales)]
      
    } else{
      
      paste(min(filtered_data()$Monthly_Sales), "units")
      
    }
    
  })
  
  
  # PIE CHART
  output$pie_chart <- renderPlot({
    
    if(input$model == "All"){
      
      pie_data <- chart_data() %>%
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
        cex = 1.4,           
        radius = 1,        
        col = c("#FFB400", "#555555","#FFD700",
                "#9370DB")
      )
      
    }
    
    else{
      
      pie_data <- chart_data() %>%
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
        
        scale_fill_brewer(palette = "Paired")
    }
  })
  
  # PRODUCT DESCRIPTION
  output$description <- renderUI({
    
    req(input$variant != "All")
    
    desc <- data %>%
      filter(Variant_Code == input$variant) %>%
      distinct(Description) %>%
      pull(Description)
    
    tags$p(
      style = "
      color:white;
      background-color:black;
      font-size:20px;
      text-align:justify;
      margin-top:10px;
    ",
      desc
    )
    
  })
  
  output$product_image <- renderImage({
    
    req(input$variant != "All")
    
    image_name <- switch(
      input$model,
      
      "Model 1" = "model1.png",
      
      "Model 2" = "model2.png",
      
      "Model 3" = "model3.png",
      
      "Model 4" = "model4.png"
    )
    
    list(
      src = image_name,
      width = 350
    )
    
  }, deleteFile = FALSE)
  
  chart_data <- reactive({
    
    df <- data
    
    if(input$tenure == "5M"){
      end_date <- max(as.Date(paste(df$Year, df$Month, "1", sep = "-")))
      start_date <- seq(end_date, length = 2, by = "-4 months")[2]
      
      df <- df %>%
        mutate(Date = as.Date(paste(Year, Month, "1", sep = "-"))) %>%
        filter(Date >= start_date)
    }
    
    if(input$tenure == "1Y"){
      end_date <- max(as.Date(paste(df$Year, df$Month, "1", sep = "-")))
      start_date <- seq(end_date, length = 2, by = "-11 months")[2]
      
      df <- df %>%
        mutate(Date = as.Date(paste(Year, Month, "1", sep = "-"))) %>%
        filter(Date >= start_date)
    }
    
    if(input$tenure == "5Y"){
      end_date <- max(as.Date(paste(df$Year, df$Month, "1", sep = "-")))
      start_date <- seq(end_date, length = 2, by = "-59 months")[2]
      
      df <- df %>%
        mutate(Date = as.Date(paste(Year, Month, "1", sep = "-"))) %>%
        filter(Date >= start_date)
    }
    
    if(input$tenure == "10Y"){
      end_date <- max(as.Date(paste(df$Year, df$Month, "1", sep = "-")))
      start_date <- seq(end_date, length = 2, by = "-119 months")[2]
      
      df <- df %>%
        mutate(Date = as.Date(paste(Year, Month, "1", sep = "-"))) %>%
        filter(Date >= start_date)
    }
    
    df
    
  })
  
  
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
    
    df <- df %>%
      group_by(Year, Month) %>%
      summarise(
        Sales = sum(Monthly_Sales),
        .groups = "drop"
      ) %>%
      arrange(Year, Month)
    
    if(input$forecast_tenure == "1Y"){
      df <- tail(df,12)
    }
    
    if(input$forecast_tenure == "5Y"){
      df <- tail(df,60)
    }
    
    if(input$forecast_tenure == "10Y"){
      df <- tail(df,120)
    }
    
    df
    
  })
  
  
  forecast_result <- eventReactive(
    list(
      input$modelf,
      input$variantf,
      input$forecast_tenure
    ),{
      
      df <- forecast_data()
      
      ts_data <- ts(
        df$Sales,
        start = c(min(df$Year), min(df$Month)),
        frequency = 12
      )
      
      train_size <- floor(0.9 * length(ts_data))
      
      train <- ts_data[1:train_size]
      
      test <- ts_data[(train_size + 1):length(ts_data)]
      
      ets_model <- ets(
        tsclean(train),
        biasadj = TRUE
      )
      
      ets_test_forecast <- forecast(
        ets_model,
        h = length(test)
      )
      
      ets_mape <- mean(
        abs((test - ets_test_forecast$mean)/test)
      ) * 100
      
      ets_accuracy <- round(
        100 - ets_mape,
        2
      )
      
      ets_rmse <- round(
        sqrt(mean((test - ets_test_forecast$mean)^2)),
        2
      )
      
      arima_model <- auto.arima(
        train,
        seasonal = TRUE,
        approximation = TRUE
      )
      
      arima_test_forecast <- forecast(
        arima_model,
        h = length(test)
      )
      
      arima_mape <- mean(
        abs((test - arima_test_forecast$mean)/test)
      ) * 100
      
      arima_accuracy <- round(
        100 - arima_mape,
        2
      )
      
      arima_rmse <- round(
        sqrt(mean((test - arima_test_forecast$mean)^2)),
        2
      )
      
      ets_model_full <- ets(
        tsclean(ts_data),
        biasadj = TRUE
      )
      
      ets_future <- forecast(
        ets_model_full,
        h = 12
      )
      
      arima_model_full <- auto.arima(
        ts_data,
        seasonal = TRUE
      )
      
      arima_future <- forecast(
        arima_model_full,
        h = 12
      )
      
      list(
        
        ets_forecast = ets_future,
        
        arima_forecast = arima_future,
        
        ets_accuracy = ets_accuracy,
        
        arima_accuracy = arima_accuracy,
        
        ets_rmse = ets_rmse,
        
        arima_rmse = arima_rmse
        
      )
      
    })
  output$ets_plot <- renderPlot({
    
    req(input$forecast_model == "ETS")
    
    par(
      bg = "black",      
      fg = "white",      
      col.axis = "white",
      col.lab = "white",
      col.main = "white"
    )
    
    plot(
      forecast_result()$ets_forecast,
      main = paste(
        "Demand Forecast for",
        input$modelf,
        "- 2026 from ETS Model"
      ),
      xlab = "Year",
      ylab = "Demand",
      col = c("#FFB400"),
      shadecols = c("gray50", "gray80"),
      lwd = 3
    )
    
  })
  
  output$arima_plot <- renderPlot({
    
    req(input$forecast_model == "ARIMA")
    
    par(
      bg = "black",      
      fg = "white",      
      col.axis = "white",
      col.lab = "white",
      col.main = "white"
    )
    
    plot(
      forecast_result()$arima_forecast,
      main = paste(
        "Demand Forecast for",
        input$modelf,
        "- 2026 from ARIMA Model"
      ),
      xlab = "Year",
      ylab = "Demand",
      col = c("#FFB400"),
      shadecols = c("gray50", "gray80"),
      lwd = 3
    )
    
  })
  
  output$ets_table <- renderTable({
    
    fc <- forecast_result()$ets_forecast
    
    data.frame(
      Month = month.abb,
      Forecast = round(fc$mean,0)
    )
  })
  
  output$arima_table <- renderTable({
    fc <- forecast_result()$arima_forecast
    
    data.frame(
      
      Month = month.abb,
      
      Forecast = round(fc$mean,0)
      
    )
    
  })
  
  output$ets_accuracy <- renderText({
    paste(
      "ETS Accuracy:",
      round(forecast_result()$ets_accuracy,2),
      "%"
    )
    
  })
  
  
  output$ets_rmse <- renderText({
    
    paste(
      "ETS RMSE:",
      round(forecast_result()$ets_rmse, 2)
    )
    
  })
  
  output$arima_accuracy <- renderText({
    paste(
      "ARIMA Accuracy:",
      round(forecast_result()$arima_accuracy,2),
      "%"
    )
    
  })
  
  output$arima_rmse <- renderText({
    req(input$forecast_model == "ARIMA")
    
    paste(
      "ARIMA RMSE:",
      round(forecast_result()$arima_rmse, 2)
    )
    
  })
  
  output$ets_rmse2 <- renderText({
    paste(
      "ETS RMSE:",
      round(forecast_result()$ets_rmse, 2)
    )
  })
  
  output$arima_rmse2 <- renderText({
    paste(
      "ARIMA RMSE:",
      round(forecast_result()$arima_rmse, 2)
    )
  })
  
  output$ets_plot2 <- renderPlot({
    req(forecast_result())
    par(
      bg = "black",      
      fg = "white",      
      col.axis = "white",
      col.lab = "white",
      col.main = "white"
    )
    plot(forecast_result()$ets_forecast, 
         main = paste(
           "Demand Forecast for",
           input$modelf,
           "- 2026 from ETS Model"
         ),
         xlab = "Year",
         ylab = "Demand",
         col = c("#FFB400"),
         shadecols = c("gray50", "gray80"),
         lwd = 3)
  })
  
  output$arima_plot2 <- renderPlot({
    req(forecast_result())
    par(
      bg = "black",      
      fg = "white",      
      col.axis = "white",
      col.lab = "white",
      col.main = "white"
    )
    plot(forecast_result()$arima_forecast,
         main = paste(
           "Demand Forecast for",
           input$modelf,
           "- 2026 from ARIMA Model"
         ),
         xlab = "Year",
         ylab = "Demand",
         col = c("#FFB400"),
         shadecols = c("gray50", "gray80"),
         lwd = 3)
  })
  
  output$forecast_title_ets <- renderText({
    paste("ETS Forecast Results for", input$modelf, "- Year 2026")
  })
  
  output$forecast_title_arima <- renderText({
    paste("ARIMA Forecast Results for", input$modelf, "- Year 2026")
  })
  
  output$ets_table2 <- renderTable({
    req(forecast_result())
    fc <- forecast_result()$ets_forecast
    data.frame(Month = month.abb, Forecast = round(fc$mean, 0))
  })
  
  output$arima_table2 <- renderTable({
    req(forecast_result())
    fc <- forecast_result()$arima_forecast
    data.frame(Month = month.abb, Forecast = round(fc$mean, 0))
  })
  
  output$ets_accuracy2 <- renderText({
    req(forecast_result())
    paste("ETS Accuracy:", round(forecast_result()$ets_accuracy, 2), "%")
  })
  
  output$arima_accuracy2 <- renderText({
    req(forecast_result())
    paste("ARIMA Accuracy:", round(forecast_result()$arima_accuracy, 2), "%")
  })
  
}
