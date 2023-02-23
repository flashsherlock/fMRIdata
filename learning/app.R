library(plotly)
library(stringr)
library(data.table)
library(psych)
library(ggpubr)
library(ggprism)
library(DT)
library(shiny)
library(patchwork)
theme_set(theme_prism(base_size = 20,
                      base_fontface = "plain",
                      base_line_size = 0.5,
                      base_rect_size = 0.5,))
# colors
gf_color <- c("#f0803b","#56a2d4","#ECB556","#55b96f","#777DDD")
# name <- "search_rmbase"
# load(paste0(name,".RData"))
# results_abs<- cbind(abs(results[,2]),results[,3:25])

# read tract xyz is in RAI (diff from results)
tract <- read.table("tract.txt")
names(tract) <- c("y","x","z","roi","prob")
tract <- as.data.table(tract)
# roi name
roi_name <- c("Amy","BaLa","CeMe","Cortical",'Pir_new','Pir_old','APC_new','APC_old','PPC')

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
                          numericInput("prob", "tract prob", 0, min = -1, max = 1, step = 0.001),
                          radioButtons("roi","Select ROI:",
                                       c("All" = "all","Pir" = "pir","Pir_old" = "piro","Amy" = "amy"),inline = TRUE),
                          actionButton("cam", "Set camera",width = "100%"),
                          textOutput("camera")
                   ),
                   column(3,
                          sliderInput("xrange","x range:",min = -46, max = 44,value = c(-46,44),step = 1,round = TRUE),
                          sliderInput("yrange","y range:",min = -14, max = 13,value = c(-14,13),step = 1,round = TRUE),
                          sliderInput("zrange","z range:",min = -33, max = -6,value = c(-33,-6),step = 1,round = TRUE),
                   ),
                   column(2,
                          numericInput("t1", "t threshold", round(2.051831,6), min = 0, max = 100, step = 0.1),
                          # numericInput("t2", "t_lim-car", params$thr, min = 0, max = NA, step = 0.001),
                          numericInput("p1", "p value", signif(2*(1-pt(q=2.051831, df=27)),2), min = 0, max = 1, step = 0.005),
                          numericInput("df", "df", 27, min = 1, max = 100, step = 1),
                          actionButton("reset", "Reset xyz range",width = "100%")
                          # submitButton("Update",width = "100%")
                   ),
                   column(2,
                          radioButtons("method","Select sig:",c("Any" = "any","All" = "all","Individual" = "ind")),
                          radioButtons("select","Select:",c("All" = "all","Structure" = "str","Quality" = "qua")),
                          checkboxInput("ylim", "y >= -2")
                   )
                 ),
                 width = 12
    ),
    # Main panel for displaying outputs ----
    mainPanel(
      # plotlyOutput(outputId = "p5"),
      tabsetPanel(type = "tabs",
                  tabPanel("StrQua", plotlyOutput(outputId = "p5", width = "auto")),
                  tabPanel("ROI", plotOutput(outputId = "mean")),
                  tabPanel("XYZ", plotOutput(outputId = "xyz")),
                  tabPanel("XYZ_m", plotOutput(outputId = "xyz_mean")),
                  tabPanel("Prob", plotOutput(outputId = "prob")),
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
  data <- reactiveValues(cam = list(x=0,y=-2,z=2))
  # camera position info
  output$camera <- renderText({
    paste("Camera:", round(data$cam$x,2), round(data$cam$y,2), round(data$cam$z,2))
  })

  # updata pvalue
  # observe({
  #   updateNumericInput(
  #     inputId = "p1",
  #     value = signif(2*(1-pt(q=input$t1, df=input$df)),2)
  #   )
  # })
  # calculate roi mean
  calmean <- reactive({
    A <- c("La","Ba","Ce","Me","Co","BM","CoT","Para")
    B <- c("La","Ba","BM","Para")
    Ce <- c("Ce","Me")
    Co <- c("Co","CoT")
    Pn <- c("APc","PPc","APn")
    Po <- c("APc","PPc")
    An <- c("APc","APn")
    Ao <- "APc"
    PPC <- "PPc"
    roilist <- list(Amy=A,BaLa=B,CeMe=Ce,Cortical=Co,Pir_new=Pn,Pir_old=Po,APC_new=An,APC_old=Ao,PPC=PPC)
    
    if (input$method=="ind"){
      idx <- "m_ncit-ncar"
    } else {
      idx <- "strnorm"
    }
    avg <- data.frame(matrix(ncol = 3, nrow = 0))
    for (roi_i in names(roilist)) {
      # results[.(roi = roilist[[roi_i]], to = roi_i), on = "roi", roi_n := i.to]
      act <- data$results[roi %in% roilist[[roi_i]],.SD,.SDcols = c("sub","m_lim-cit","m_lim-car",idx)]
      # act <- subset(results,roi %in% roilist[[roi_i]],select = c("sub","m_lim-cit","m_lim-car"))
      if (nrow(act)>0){
      m <- describeBy(cbind(abs(act[,2:3]),act[,4]),list(act$sub),mat=T)
      m <- subset(m,select = c("group1","mean","se"))
      m <- cbind(str_remove(rownames(m),"1"),m)
      # add roi name
      act <- cbind(rep(roi_i,times=nrow(m)),m)
      avg <- rbind(avg,act)
      # avg <- rbind(avg,results[roi_n==roi_i, lapply(.SD, mean), .SDcols = c("m_lim-cit","m_lim-car"),by = "roi_n"])
      }
    }
    # change column names
    names(avg)[1:3] <- c("roi","voxels","sub")
    return(avg)
  })
  
  # updata tvalue according to p and df
  observeEvent({
    input$p1
    input$df},{
    updateNumericInput(
      inputId = "t1",
      value = min(round(qt(1-(input$p1/2),input$df),6),100)
    )
  })
  
  observeEvent(input$reset,{
    updateSliderInput(inputId = "xrange",value = c(-46,44))
    updateSliderInput(inputId = "yrange",value = c(-14,13))
    updateSliderInput(inputId = "zrange",value = c(-33,-6))
  })
  
  observeEvent(input$cam,{
    position <- event_data("plotly_relayout",source = "p5")$scene.camera$eye
    if (length(position)>0){
      data$cam <- position
    }
  })
  
  # https://community.rstudio.com/t/choose-a-rdata-dataset-before-launching-rest-of-shiny-app/49533/6
  observe({
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
    } else if (input$roi == "piro"){
      results <- results[roi %in% c("APc","PPc"),]
    }
    
    # str or qua
    if (input$select == 'str') {
      results_select <- results[strnorm>0,]
      data$colorp <- colorRampPalette(c("white", "red"))(10)
    } else if (input$select == 'qua'){
      results_select <- results[strnorm<0,]
      data$colorp <- colorRampPalette(c("blue", "white"))(10)
    }
    else{
      results_select <- results
      data$colorp <- colorRampPalette(c("blue", "white", "red"))(21)
    }
    # select rows that all columns are above threshold in data.table
    
    if (input$method == 'ind') {
      results_select <- results_select[abs(`t_ncit-ncar`)>input$t1,]
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
    
    # select y
    if (input$ylim==TRUE){
      results_select <- results_select[y>=-2,]
    }
    # select datarange
    results_select <- results_select[(x %between% input$xrange) &
                                     (y %between% input$yrange)&
                                     (z %between% input$zrange),]
    # return results
    # data$results <- (get("results"))
    data$results <- results_select
    })
  
  observeEvent(input$dimension,{
    data$wid <- 0.95*as.numeric(input$dimension[1])
    data$hei <- 0.95*as.numeric(input$dimension[2])
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
    # plot
    p5 <- plot_ly(data$results,x=~x, y=~y, z=~z, split=~roi,type="scatter3d", mode="markers", 
                  color=~strnorm,colors=data$colorp,size = I(30),symbol = I("square"),
                  hovertemplate = paste('%{x} %{y} %{z}<br>','%{marker.color:.2f}'),
                  width = max(1,data$wid,data$hei), height = min(1,data$wid,data$hei),
                  source = "p5")%>%
      # colorbar(title = "struc-quality_n")%>%
      layout(scene = list(aspectmode = "data",
                          camera = list(eye = list(x = data$cam$x, y = data$cam$y, z = data$cam$z))
                          ))
      # layout(scene = list(aspectmode = "manual", aspectratio = list(x=2, y=1, z=1)))
  })
  
  output$mean <- renderPlot({
    avg <- calmean()
    # change column names
    names(avg)[1:3] <- c("roi","voxels","sub")
    datachosen <- mutate(avg,roi = factor(roi,levels=roi_name))
    # plot
    ggplot(datachosen, aes(x=roi, y=mean, fill=voxels)) +
      labs(x='ROI',y='Mean difference',fill='voxels')+#设置坐标轴
      geom_bar(position="dodge", stat="identity") +
      scale_y_continuous(expand = c(0,0))+
      scale_fill_manual(values=gf_color[2:5])+ #颜色
      geom_errorbar(aes(ymin=mean-se, ymax=mean+se), width=.2,color='black',
                    position=position_dodge(.9))
  })
  
  corr_xyz <- reactive({
    # plot
    plots <- list()
    plotdata <- data$results[,c("x","y","z","m_lim-cit","m_lim-car","strnorm")]
    plotdata$x <- abs(plotdata$x)
    setnames(plotdata,c("m_lim-cit","m_lim-car"),c("lim_cit","lim_car"))
    odors <- c("lim_cit","lim_car","strnorm")
    for (odor in odors) {
      for (xlab in c("x","y","z")) {
        p <- paste(xlab,odor,sep = "_")
        plots[[p]] <- ggscatter(plotdata,color = "#4c95c8",
                                x = xlab, y = odor,alpha = 0.8,
                                conf.int = TRUE,add = "reg.line",add.params = list(color = "gray20")
                                ,fullrange = F)+
          stat_cor(aes(label = paste(after_stat(r.label), after_stat(p.label), sep = "~`,`~")),
                   show.legend=F)
      }
    }
    return(wrap_plots(c(plots),ncol = 3,nrow = length(odors)))
  })
  
  corr_xyz_mean <- reactive({
    # plot
    plots_avg <- list()
    plotdata <- data$results[,c("x","y","z","m_lim-cit","m_lim-car","strnorm")]
    plotdata$x <- abs(plotdata$x)
    setnames(plotdata,c("m_lim-cit","m_lim-car"),c("lim_cit","lim_car"))
    odors <- c("lim_cit","lim_car","strnorm")
    for (odor in odors) {
      for (xlab in c("x","y","z")) {
        p <- paste(xlab,odor,sep = "_")
        # averaged
        # position=position_jitter(h=0.02,w=0.02, seed = 5)) +
        plots_avg[[p]] <- ggscatter(plotdata[,lapply(.SD, mean),.SDcol=odor,by=xlab],
                                    color = "#4c95c8", x = xlab, y = odor,alpha = 0.8,
                                    conf.int = TRUE,add = "reg.line",add.params = list(color = "gray20")
                                    ,fullrange = F)+
          stat_cor(aes(label = paste(after_stat(r.label), after_stat(p.label), sep = "~`,`~")),
                   show.legend=F)
      }
    }
    return(wrap_plots(c(plots_avg),ncol = 3,nrow = length(odors)))
  })
  
  output$xyz <- renderPlot({
    corr_xyz()
  },height = function(){data$wid*1})
  
  output$xyz_mean <- renderPlot({
    corr_xyz_mean()
  },height = function(){data$wid*1})
  
  output$prob <- renderPlot({
    ggscatter(data$results,
              color = "#4c95c8", x = "prob", y = "strnorm", alpha = 0.8,
              conf.int = TRUE,add = "reg.line",add.params = list(color = "gray20")
              ,fullrange = F)+
      stat_cor(aes(label = paste(after_stat(r.label), after_stat(p.label), sep = "~`,`~")),show.legend=F)
  })
  
  output$table <- renderDT({
    out <- data$results[,lapply(.SD, function(x) if (is.numeric(x)) round(x, 2) else x)]
    # select columns
    out <- out[,.SD,.SDcol=c(2:5,(ncol(out)-5):ncol(out))]
    datatable(out, filter = 'top',rownames = FALSE,
              caption = htmltools::tags$caption(
                style = 'caption-side: top; text-align: center;'))
  })
  
}
shinyApp(ui,server)