library(plotly)
library(stringr)
library(data.table)
library(ggpubr)
library(DT)
library(shiny)
# name <- "search_rmbase"
# load(paste0(name,".RData"))
# results_abs<- cbind(abs(results[,2]),results[,3:25])

# read tract xyz is in RAI (diff from results)
tract <- read.table("tract.txt")
names(tract) <- c("y","x","z","roi","prob")
tract <- as.data.table(tract)

# 3d scatter plot
ui <- fluidPage(
  tags$head(tags$script('
                        var dimension = [0, 0];
                        $(document).on("shiny:connected", function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        $(window).resize(function(e) {
                        dimension[0] = window.innerWidth;
                        dimension[1] = window.innerHeight;
                        Shiny.onInputChange("dimension", dimension);
                        });
                        ')),
  verticalLayout(
  sidebarPanel(class="panel",
    fluidRow(
    column(2,
    selectInput("data", "Pick a dataset", 
                choices = as.list(str_replace(list.files(pattern = "\\.RData$"),"\\.RData$","")),
                selected = "results"),
    radioButtons("roi","Select ROI:",c("All" = "all","Pir" = "pir","Amy" = "amy"),inline = TRUE), 
    numericInput("prob", "tract prob", 0, min = -1, max = 1, step = 0.001)
    ),
    column(2,
    numericInput("t1", "t threshold", round(2.051831,6), min = 0, max = NA, step = 0.1),
    # numericInput("t2", "t_lim-car", params$thr, min = 0, max = NA, step = 0.001),
    numericInput("p1", "p value", signif(2*(1-pt(q=2.051831, df=27)),2), min = 0.00001, max = 1, step = 0.05),
    numericInput("df", "df", 27, min = 1, max = 100, step = 1)
    ),
    column(2,
    radioButtons("method","Select sig:",c("Any" = "any","All" = "all","Individual" = "ind")),
    radioButtons("select","Select:",c("All" = "all","Structure" = "str","Quality" = "qua")),
    )
  ),
  width = 12
  ),
    # Main panel for displaying outputs ----
    mainPanel(
      # plotlyOutput(outputId = "p5"),
      tabsetPanel(type = "tabs",
                  tabPanel("StrQua", plotlyOutput(outputId = "p5", width = "auto")),
                  tabPanel("Table", DTOutput("table"))
      #             tabPanel("lim-cit",plotlyOutput(outputId = "p1")),
      #             tabPanel("lim-car",plotlyOutput(outputId = "p2")),
      #             tabPanel("absx_lim-cit",plotlyOutput(outputId = "p3")),
      #             tabPanel("absx_lim-cit",plotlyOutput(outputId = "p4"))
      ),
      width = 12
    )
  )
)

server <- function(input, output, ...) {
  data <- reactiveValues(results = NULL)
  # output$result <- renderText({
  #   paste("You chose", list.files(pattern = input$data))
  # })
  
  # https://community.rstudio.com/t/choose-a-rdata-dataset-before-launching-rest-of-shiny-app/49533/6
  observeEvent({
    input$data
    input$roi
    },{
    load(paste0(input$data,".RData"))
    results <- cbind(results,tract[,5])
    # compute strnorm
    if (ncol(results)<20){
      results[,strnorm:=(abs(`m_lim-cit`)-abs(`m_lim-car`))/(abs(`m_lim-cit`)+abs(`m_lim-car`))]
    } else{
      results[,strnorm:=(`m_lim-cit`-`m_lim-car`)/(`m_lim-cit`+`m_lim-car`)]
    }
    if (input$roi == "amy"){
      results <- results[roi %in% c("La","Ba","Ce","Me","Co","BM","CoT","Para"),]
    } else if (input$roi == "pir"){
      results <- results[roi %in% c("APc","PPc","APn"),]
    }
    # return results
    data$results <- (get("results"))
    })
  
  # updata pvalue
  # observe({
  #   updateNumericInput(
  #     inputId = "p1",
  #     value = signif(2*(1-pt(q=input$t1, df=input$df)),2)
  #   )
  # })
  
  # updata tvalue according to p and df
  observeEvent({
    input$p1
    input$df},{
    updateNumericInput(
      inputId = "t1",
      value = round(qt(1-(input$p1/2),input$df),6)
    )
  })
  
  output$p1 <- renderPlotly({
    p1 <- plot_ly(data$results[`t_lim-cit`>input$t1,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-cit`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p2 <- renderPlotly({
    # lim-car
    p2 <- plot_ly(data$results[`t_lim-cit`>input$t1,],x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-car`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p3 <- renderPlotly({
    results_abs<- cbind(abs(data$results[,2]),data$results[,3:25])
    # activated only average voxels in the same coordinate
    # lim-cit
    p3 <- plot_ly(results_abs[`t_lim-cit`>input$t1,lapply(.SD, mean),.SDcol=5:14,by=c("x","y","z","roi")],
                  x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~`m_lim-cit`,size = I(30),symbol = I("square"), 
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  output$p4<- renderPlotly({
    results_abs<- cbind(abs(data$results[,2]),data$results[,3:25])
    # lim-car
    p4 <-plot_ly(results_abs[`t_lim-car`>input$t1,lapply(.SD, mean),.SDcol=5:14,by=c("x","y","z","roi")],
                 x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                 color=~`m_lim-car`,size = I(30),symbol = I("square"), 
                 hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'))
  })
  
  output$p5<- renderPlotly({
    # str or qua
    if (input$select == 'str') {
      results_select <- data$results[strnorm>0,]
      colorp <- colorRampPalette(c("white", "red"))(10)
    } else if (input$select == 'qua'){
      results_select <- data$results[strnorm<0,]
      colorp <- colorRampPalette(c("blue", "white"))(10)
    }
    else{
      results_select <- data$results
      colorp <- colorRampPalette(c("blue", "white", "red"))(21)
    }
    # select rows that all columns are above threshold in data.table
    
    if (input$method == 'ind') {
      results_select <- results_select[abs(`t_ncit-ncar`)>=input$t1,]
    } else if (input$method == 'all'){
      results_select <- results_select[abs(`t_lim-car`)>input$t1 & abs(`t_lim-cit`)>input$t1,]
    } else {
      results_select <- results_select[abs(`t_lim-car`)>input$t1 | abs(`t_lim-cit`)>input$t1,]
    }
    
    # select prob
    if (input$prob>=0){
      results_select <- results_select[prob>=input$prob,]
    } else{
      results_select <- results_select[prob<abs(input$prob),]
    }
    # plot
    wid <- 0.95*as.numeric(input$dimension[1])
    hei <- 0.95*as.numeric(input$dimension[2])
    p5 <- plot_ly(results_select,x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~strnorm,colors=colorp,size = I(30),symbol = I("square"),
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'),
                  width = max(wid,hei), height = min(wid,hei))%>%
      colorbar(title = "struc-quality_n")%>%
      layout(scene = list(aspectmode = "data",
                          camera = list(eye = list(x = 0, y = -2, z = 2))
                          ))
      # layout(scene = list(aspectmode = "manual", aspectratio = list(x=2, y=1, z=1)))
  })
  
  output$table <- renderDT({
    out <- data$results[,lapply(.SD, function(x) if (is.numeric(x)) round(x, 2) else x)]
    datatable(out[,-1], filter = 'top',rownames = FALSE,
              caption = htmltools::tags$caption(
                style = 'caption-side: top; text-align: center;'))
  })
  
}
shinyApp(ui,server)