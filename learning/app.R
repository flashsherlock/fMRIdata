library(plotly)
library(stringr)
library(data.table)
# name <- "search_rmbase"
# load(paste0(name,".RData"))
# results_abs<- cbind(abs(results[,2]),results[,3:25])
# 3d scatter plot
ui <- fluidPage(
  selectInput("data", "Pick a dataset", 
              choices = as.list(str_replace(list.files(pattern = "\\.RData$"),"\\.RData$",""))),
  # textOutput("result"),
  sidebarLayout(
  sidebarPanel(
    numericInput("t1", "t threshold", round(2.051831,6), min = 0, max = NA, step = 0.1),
    # numericInput("t2", "t_lim-car", params$thr, min = 0, max = NA, step = 0.001),
    numericInput("p1", "p value", signif(2*(1-pt(q=2.051831, df=27)),2), min = 0.00001, max = 1, step = 0.05),
    numericInput("df", "df", 27, min = 1, max = 100, step = 1),
    radioButtons("method","Select sig:",c("All" = "all","Any" = "any","Individual" = "ind")),
    radioButtons("select","Select:",c("All" = "all","Structure" = "str","Quality" = "qua")),
    width = 2
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      plotlyOutput(outputId = "p5"),
      # tabsetPanel(type = "tabs",
      #             tabPanel("StrQua", plotlyOutput(outputId = "p5")),
      #             tabPanel("lim-cit",plotlyOutput(outputId = "p1")),
      #             tabPanel("lim-car",plotlyOutput(outputId = "p2")),
      #             tabPanel("absx_lim-cit",plotlyOutput(outputId = "p3")),
      #             tabPanel("absx_lim-cit",plotlyOutput(outputId = "p4"))
      # ),
      width = 10
    )
  )
)

server <- function(input, output, ...) {
  
  # output$result <- renderText({
  #   paste("You chose", list.files(pattern = input$data))
  # })
  
  # https://community.rstudio.com/t/choose-a-rdata-dataset-before-launching-rest-of-shiny-app/49533/6
  results <- reactive({
    req(input$data)
    load(paste0(input$data,".RData"))
    return(get("results"))
    })
  
  # updata pvalue
  # observe({
  #   updateNumericInput(
  #     inputId = "p1",
  #     value = signif(2*(1-pt(q=input$t1, df=input$df)),2)
  #   )
  # })
  
  # updata tvalue according to p and df
  observe({
    updateNumericInput(
      inputId = "t1",
      value = round(qt(1-(input$p1/2),input$df),6)
    )
  })
  
  output$p1 <- renderPlotly({
    p1 <- plot_ly(results()[`t_lim-cit`>input$t1,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-cit`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p2 <- renderPlotly({
    # lim-car
    p2 <- plot_ly(results()[`t_lim-cit`>input$t1,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-car`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p3 <- renderPlotly({
    results_abs<- cbind(abs(results()[,2]),results()[,3:25])
    # activated only average voxels in the same coordinate
    # lim-cit
    p3 <- plot_ly(results_abs[`t_lim-cit`>input$t1,lapply(.SD, mean),.SDcol=5:14,by=c("x","y","z","roi")],
                  x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-cit`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p4<- renderPlotly({
    results_abs<- cbind(abs(results()[,2]),results()[,3:25])
    # lim-car
    p4 <-plot_ly(results_abs[`t_lim-car`>input$t1,lapply(.SD, mean),.SDcol=5:14,by=c("x","y","z","roi")],
                 x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                 color=~`m_lim-car`,size = I(30),symbol = I("square"), 
                 hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  
  output$p5<- renderPlotly({
    
    # # select cit-lim-car-lim
    # colm <- grep(paste0("m_lim-(car|cit)"),colnames(results()))
    # colt <- grep(paste0("t_lim-(car|cit)"),colnames(results()))
    # results_select <- results()[,c(2,3,4,5,colm,colt)]
    if (ncol(results())<20){
      results_select <- results()[,strnorm:=(abs(`m_lim-cit`)-abs(`m_lim-car`))/(abs(`m_lim-cit`)+abs(`m_lim-car`))]
    } else{
      results_select <- results()[,strnorm:=(`m_lim-cit`-`m_lim-car`)/(`m_lim-cit`+`m_lim-car`)]
    }
    # select rows that all columns are above threshold in data.table
    if (input$method == 'any') {
      results_select[,t:=any(abs(.SD)>=input$t1),.SDcols = c("t_lim-car","t_lim-cit"), by = seq_len(nrow(results_select))]
    } else{
      results_select[,t:=all(abs(.SD)>=input$t1),.SDcols = c("t_lim-car","t_lim-cit"), by = seq_len(nrow(results_select))]
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
    if (input$method == 'ind') {
      p5 <- plot_ly(results_select[abs(`t_ncit-ncar`)>=input$t1,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                    color=~`m_ncit-ncar`,colors=colorp,size = I(30),symbol = I("square"),
                    hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))%>%colorbar(title = "struc-quality-norm")
    } else {
      p5 <- plot_ly(results_select[t==TRUE,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                    color=~strnorm,colors=colorp,size = I(30),symbol = I("square"),
                    hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))%>%colorbar(title = "struc-quality-norm")
    }
  })
}
shinyApp(ui,server)