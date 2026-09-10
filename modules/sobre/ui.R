sobre_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      shiny::column(
        width = 6,
        shiny::fluidRow(shiny::column(
          width = 12,
          shiny::HTML('<i class="fa fa-info"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">SOBRE </b>')
        )),
        shiny::p("Arboviroses são as doenças causadas pelos chamados arbovírus, que incluem o vírus da dengue, Zika vírus, febre chikungunya e febre amarela.
                            A classificação \"arbovírus\" engloba todos aqueles transmitidos por artrópodes, ou seja, insetos e aracnídeos (como aranhas e carrapatos)."),
        shiny::p("Existem 545 espécies de arbovírus, sendo que 150 delas causam doenças em seres humanos. Apesar de a classificação arbovirose ser utilizada
                            para classificar diversos tipos de vírus, como o mayaro, meningite e as encefalites virais, hoje a expressão tem sido mais usada para designar
                            as doenças transmitidas pelo Aedes aegypti, como o Zika vírus, febre chikungunya, dengue e febre amarela.")
      ),
      shiny::column(
        width = 6,
        shiny::fluidRow(shiny::column(
          width = 12,
          shiny::HTML('<i class="fa fa-info"style = "color:#0072B2;font-size:50px;padding-left:0px;"></i>
                                  <b style = "padding-left:15px;color:#000000;font-size:30px;">COLABORADORES </b>')
        )),
        shiny::HTML('<div class="footer">
  <div style="width: 100%;">
    <left>
       <div style="display:inline-flex">
        <a href="http://www.saude.pr.gov.br/">
        <img src="http://www.saude.pr.gov.br/sites/default/arquivos_restritos/files/imagem/2020-02/LogoSaude2019_Horizontal.png" style="height:80px">
      </a>
      <a href="http://www.uem.br/">
        <img src="https://s3-sa-east-1.amazonaws.com/casadenoticias/article_shots/images/27939/header/uem-modelo-01.png?1580416312" style="width:168px;padding-left:15px;">
      </a>

      </div>
    </left>
  </div>
</div>')
      ),
      style = "text-align:justify;"
    )
  )
}
