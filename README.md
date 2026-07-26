# 🚗 Aurion Cars - Demand Forecasting & Analytics Dashboard

Aurion Cars is an interactive **R Shiny** application developed to analyze historical vehicle demand and forecast future sales using **time series forecasting** techniques. The project enables users to explore demand trends across different vehicle models and variants while generating accurate forecasts to support inventory planning and business decision-making.

> **Note:** This project is based on an industry internship and has been rebranded with fictional company and product names to maintain confidentiality. The dataset used in this project is for demonstration purposes.

---
View
https://jyothishr08.shinyapps.io/demand_forecasting/
---

## 📌 Features

- 📊 Interactive sales and demand analytics dashboard
- 🚘 Model-wise and variant-wise demand analysis
- 📈 Historical trend visualization
- 🔮 Future demand forecasting
- 📅 Monthly demand predictions
- 📉 Key Performance Indicators (KPIs)
- ⚡ Dynamic filtering for models and variants
- 📋 Forecast result tables

---

## 🛠️ Technologies Used

- **R**
- **R Shiny**
- **Forecast Package**
- **ggplot2**
- **dplyr**
- **plotly**
- **DT**
- **Time Series Analysis**

---

## 📈 Forecasting Models

The application combines multiple forecasting techniques to improve prediction performance.

- **ETS (Exponential Smoothing)**
- **ARIMA (AutoRegressive Integrated Moving Average)**

These models analyze historical demand patterns and generate future monthly demand forecasts for different vehicle models.

---

## 📊 Dashboard Highlights

- Total Demand Overview
- Average Monthly Demand
- Model Performance Analysis
- Variant-wise Demand Distribution
- Historical Sales Trends
- Forecast Visualization
- Monthly Prediction Table

---

## 📂 Project Structure

```
Aurion-Cars/
│── app.R
│── data/
│── www/
│── images/
│── README.md
```

---

## 🚀 Getting Started

### Clone the repository

```bash
git clone https://github.com/yourusername/aurion-cars.git
```

### Install required packages

```R
install.packages(c(
  "shiny",
  "forecast",
  "ggplot2",
  "plotly",
  "dplyr",
  "DT"
))
```

### Run the application

```R
shiny::runApp()
```

---



## 🎯 Project Objectives

- Analyze historical vehicle demand.
- Identify demand trends across different models and variants.
- Forecast future demand using statistical time series models.
- Provide interactive visualizations for business insights.
- Support data-driven inventory and production planning.

---

## 📌 Future Enhancements

- Machine Learning-based forecasting models
- Forecast accuracy comparison
- Export reports to PDF and Excel
- User authentication
- Cloud deployment

---

## 👨‍💻 Author

**Jyothish Ramachandran**

MCA Student | Data Analyst | Power BI | SQL | Python | R

---

## 📄 License

This project is intended for educational and portfolio purposes only.
```
