pacman::p_load("shiny","shinymaterial", "plotly")
source("read_data.R")
ui=material_page(
  title = "Zillow Dashboard",
  tags$br(),
  material_row(
    material_column(
      width=2,
      material_card(
        title = "",
        depth = 4,
        uiOutput("state_select"),
        uiOutput("metro_select")
      )
    ),
    material_column(
      width = 5,
      material_card(
        title = "Average Zillow Housing Value Index",
        depth = 4,
        plotlyOutput("zhvi_plot")
      )
    ),
    material_column(
      width=5,
      material_card(
        title = "Price to Rent Ratio",
        depth = 4,
        plotlyOutput("p2rr_plot")
      )
    ),
    material_row(
      material_column(
        width=2
      ),
      material_column(
        width=5,
        material_card(
          title = "Price Cut (%)",
          depth = 4,
          plotlyOutput("pcut_plot")
        )
      ),
      material_column(
        width=5,
        material_card(
          title = "Buyer-Seller Index",
          depth = 4,
          plotlyOutput("bsi_plot")
        )
      )
    )
  )
)
server<-function(input, output) {
  output$state_select <- renderUI({
    selectInput(inputId = "state_input", label = "Select State:", choices = levels(data_1$State))
                })
  metros <- reactive({
                  c(as.character(data_1[data_1$State==req(input$state_input),"Metro"]),
                     as.character(data_2[data_2$State==req(input$state_input),"Metro"]),
                     as.character(data_3[data_3$State==req(input$state_input),"Metro"]),
                     as.character(data_4[data_4$State==req(input$state_input),"Metro"])) %>% unique()
  })
  output$metro_select <- renderUI({
    selectInput(inputId = "metro_input", label = "Select Metro:", choices = metros())
  })
  data_1_input <- reactive({
    mydata_1 <- (data_1 %>% filter(State == req(input$state_input), Metro==req(input$metro_input)) %>% group_by(date) %>% summarise(ZHVI=mean(zhvi,na.rm = T)))
  })
  data_2_input <- reactive({
    mydata_2 <- (data_2 %>% filter(State == req(input$state_input), Metro==req(input$metro_input)) %>% group_by(date) %>% summarise(P2RR=mean(p2rr,na.rm = T)))
  })
  data_3_input <- reactive({
    mydata_3 <- (data_3 %>% filter(State == req(input$state_input), Metro==req(input$metro_input)) %>% group_by(date) %>% summarise(BSI=mean(bsi,na.rm = T)))
  })
  data_4_input <- reactive({
    mydata_4 <- (data_4 %>% filter(State == req(input$state_input), Metro==req(input$metro_input)) %>% group_by(date) %>% summarise(PCUT_PCT=mean(pcut,na.rm = T)))
  })
  output$zhvi_plot <- renderPlotly({
    plot_output <- ggplot(data_1_input(), aes(date,ZHVI)) + geom_line()
    plot_output %>% ggplotly() %>% config(displayModeBar=F)
  })
  output$p2rr_plot <- renderPlotly({
    plot_output <- ggplot(data_2_input(), aes(date,P2RR)) + geom_line()
    plot_output %>% ggplotly() %>% config(displayModeBar=F)
  })
  output$pcut_plot <- renderPlotly({
    plot_output <- ggplot(data_4_input(), aes(date,PCUT_PCT)) + geom_line()
    plot_output %>% ggplotly() %>% config(displayModeBar=F)
  })
  output$bsi_plot <- renderPlotly({
    plot_output <- ggplot(data_3_input(), aes(date,BSI)) + geom_line()
    plot_output %>% ggplotly() %>% config(displayModeBar=F)
  })
}
shinyApp(ui, server)