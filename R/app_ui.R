ui <- bs4Dash::bs4DashPage(
  header = bs4Dash::bs4DashNavbar(
    shiny::tags$style(".main-header {max-height: 145px}"),
    shiny::tags$style(".main-header .logo {height: 145px;}"),
    shiny::tags$style(".sidebar-toggle {height: 145px; padding-top: 1px !important;}"),
    shiny::tags$style(".navbar {min-height:145px !important}"),
    shiny::tags$img(
      class = "logo",
      src = "header_informe_dateless.png", title = "DASHBOARD DENGUE ",
      height = "100", width = "1360",
      style = "margin-top: 0px; margin-left: 0px"
    )
  ),
  sidebar = bs4Dash::bs4DashSidebar(
    disable = FALSE,
    inputId = "main_sidebar",
    title = shiny::strong("DASHBOARD", style = "color:#000000;font-size:22px"),
    src = "https://raw.githubusercontent.com/mleal93/projeto_dengue_git/master/www/dash_logo.png",
    src = "favicon.ico",
    expand_on_hover = TRUE,
    elevation = 5,
    skin = "light",
    bs4Dash::bs4SidebarMenu(
      id = "main_sidebar_menu",
      flat = TRUE,
      compact = TRUE,
      childIndent = FALSE,
      bs4Dash::bs4SidebarMenuItem(text = "Panorama", icon = shiny::icon(name = "home"), startExpanded = FALSE, tabName = "tab1"),
      bs4Dash::bs4SidebarMenuItem(text = "Descritivo", icon = shiny::icon("map-marked-alt"), startExpanded = FALSE, tabName = "tab2"),
      bs4Dash::bs4SidebarMenuItem(text = "Diagrama Controle", icon = shiny::icon("chart-line"), startExpanded = FALSE, tabName = "tab3"),
      bs4Dash::bs4SidebarMenuItem(text = "Sobre", icon = shiny::icon("info"), startExpanded = FALSE, tabName = "tab4")
    )
  ),
  footer = bs4Dash::bs4DashFooter(
    shiny::HTML(
      '<div class="footer">
  <div style="width: 100%;">
    <center>
       <div style="display:inline-flex">
        <a href="http://www.saude.pr.gov.br/">
        <img src="http://www.saude.pr.gov.br/sites/default/arquivos_restritos/files/imagem/2020-02/LogoSaude2019_Horizontal.png" style="height:80px">
      </a>
      <a href="http://www.uem.br/">
        <img src="https://s3-sa-east-1.amazonaws.com/casadenoticias/article_shots/images/27939/header/uem-modelo-01.png?1580416312" style="width:168px;padding-left:15px;">
      </a>

      </div>
    </center>
  </div>
</div>'
    )
  ),
  title = "Dashboard Arboviroses",
  controlbar = bs4Dash::dashboardControlbar(
    skin = "light",
    inputId = "control.bar",
    relatorio_open_button_ui("relatorio")
  ),
  body = bs4Dash::bs4DashBody(
    bs4Dash::tabItems(
      bs4Dash::tabItem(tabName = "tab1", panorama_geral_ui("panorama_geral")),
      bs4Dash::tabItem(
        tabName = "tab2",
        shiny::fluidRow(shiny::column(
          width = 12,
          shiny::HTML('<i class="fa fa-map-marked-alt"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">DESCRITIVO </b>')
        )),
        espaco_html(2),
        shiny::fluidRow(
          shiny::column(width = 8, mapa_cidades_macro_ui("mapa_cidades")),
          shiny::column(width = 4, comportamento_inicial_filtro_ui("comportamento_inicial"))
        ),
        espaco_html(2),
        comportamento_inicial_painel_ui("comportamento_inicial")
      ),
      bs4Dash::tabItem(tabName = "tab3", diagrama_controle_ui("diagrama_controle")),
      bs4Dash::tabItem(tabName = "tab4", sobre_ui("sobre"))
    )
  )
)
