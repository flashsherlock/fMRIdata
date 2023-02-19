library(plotly)
library(data.table)
load("search_rmbase.RData")
results_abs<- cbind(abs(results[,2]),results[,3:25])
# 3d scatter plot
ui <- fluidPage(
  sidebarLayout(
  sidebarPanel(
    numericInput("t1", "t threshold", round(2.051831,6), min = 0, max = NA, step = 0.1),
    # numericInput("t2", "t_lim-car", params$thr, min = 0, max = NA, step = 0.001),
    numericInput("p1", "p value", signif(2*(1-pt(q=2.051831, df=27)),2), min = 0.00001, max = 1, step = 0.05),
    radioButtons("method","Select sig:",c("All" = "all","Any" = "any")),
    radioButtons("select","Select:",c("All" = "all","Structure" = "str","Quality" = "qua"))
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("StrQua", plotlyOutput(outputId = "p5")),
                  tabPanel("lim-cit",plotlyOutput(outputId = "p1")),
                  tabPanel("lim-car",plotlyOutput(outputId = "p2")),
                  tabPanel("absx_lim-cit",plotlyOutput(outputId = "p3")),
                  tabPanel("absx_lim-cit",plotlyOutput(outputId = "p4"))
      )
    )
  )
)

server <- function(input, output, ...) {
  observe({
    updateNumericInput(
      inputId = "p1",
      value = signif(2*(1-pt(q=input$t1, df=27)),2)
    )
  })
  observe({
    updateNumericInput(
      inputId = "t1",
      value = round(qt(1-(input$p1/2),27),6)
    )
  })
  output$p1 <- renderPlotly({
    p1 <- plot_ly(results[`t_lim-cit`>input$t1,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-cit`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p2 <- renderPlotly({
    # lim-car
    p2 <- plot_ly(results[`t_lim-cit`>input$t1,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-car`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p3 <- renderPlotly({
    # activated only average voxels in the same coordinate
    # lim-cit
    p3 <- plot_ly(results_abs[`t_lim-cit`>input$t1,lapply(.SD, mean),.SDcol=5:14,by=c("x","y","z","roi")],
                  x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-cit`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p4<- renderPlotly({
    # lim-car
    p4 <-plot_ly(results_abs[`t_lim-car`>input$t1,lapply(.SD, mean),.SDcol=5:14,by=c("x","y","z","roi")],
                 x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                 color=~`m_lim-car`,size = I(30),symbol = I("square"), 
                 hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  
  output$p5<- renderPlotly({
    # select cit-lim-car-lim
    col <- grep(paste0("t_lim-(car|cit)"),colnames(results))
    results_select <- results[,c(2,3,4,5,col-10,col)]
    results_select <- results[,strnorm:=(`m_lim-cit`-`m_lim-car`)/(`m_lim-cit`+`m_lim-car`)]
    # select rows that all columns are above threshold in data.table
    if (input$method == 'any') {
      results_select[,t:=any(.SD>input$t1),.SDcols = c("t_lim-car","t_lim-cit"), by = seq_len(nrow(results_select))]
    } else{
      results_select[,t:=all(.SD>input$t1),.SDcols = c("t_lim-car","t_lim-cit"), by = seq_len(nrow(results_select))]
    }
    if (input$select == 'str') {
      results_select <- results_select[strnorm>0,]
      colorp <- colorRampPalette(c("white", "red"))(10)
    } else if (input$select == 'qua'){
      results_select <- results_select[strnorm<0,]
      colorp <- colorRampPalette(c("blue", "white"))(10)
    }
    else{
      colorp <- colorRampPalette(c("blue", "white", "red"))(20)
    }
    # normalized
    p5 <- plot_ly(results_select[t==TRUE,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~strnorm,colors=colorp,size = I(30),symbol = I("square"),
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))%>%colorbar(title = "struc-quality-norm")
  })
}
shinyApp(ui,server)