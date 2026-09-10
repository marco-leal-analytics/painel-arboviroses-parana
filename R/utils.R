espaco_html <- function(n = 6) {
  shiny::HTML(rep("<br>", n))
}

# Diretório de artefatos gerados em runtime (gráficos e LaTeX do relatório),
# mantido fora da raiz do projeto. Ver output/README.md.
report_output_dir <- function() {
  dir <- file.path("output", "relatorio")
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
  }
  dir
}

rm_accent <- function(str, pattern = "all") {
  if (!is.character(str)) {
    str <- as.character(str)
  }
  pattern <- unique(pattern)
  if (any(pattern == "Ç")) {
    pattern[pattern == "Ç"] <- "ç"
  }
  symbols <- c(
    acute = "áéíóúÁÉÍÓÚýÝ",
    grave = "àèìòùÀÈÌÒÙ",
    circunflex = "âêîôûÂÊÎÔÛ",
    tilde = "ãõÃÕñÑ",
    umlaut = "äëïöüÄËÏÖÜÿ",
    cedil = "çÇ"
  )
  nudeSymbols <- c(
    acute = "aeiouAEIOUyY",
    grave = "aeiouAEIOU",
    circunflex = "aeiouAEIOU",
    tilde = "aoAOnN",
    umlaut = "aeiouAEIOUy",
    cedil = "cC"
  )
  accentTypes <- c("´", "`", "^", "~", "¨", "ç")
  if (any(c("all", "al", "a", "todos", "t", "to", "tod", "todo") %in% pattern)) {
    return(chartr(paste(symbols, collapse = ""), paste(nudeSymbols, collapse = ""), str))
  }
  for (i in which(accentTypes %in% pattern)) {
    str <- chartr(symbols[i], nudeSymbols[i], str)
  }
  return(str)
}

getColor.inc <- function(x) {
  if (is.na(x)) {
    return("white")
  }

  if (x <= 0) {
    return("white")
  } else if (x <= 50) {
    return("lightgray")
  } else if (x <= 100) {
    return("yellow")
  } else if (x <= 300) {
    return("orange")
  } else if (x <= 500) {
    return("red")
  } else {
    return("saddlebrown")
  }
}

getColor.obt <- function(x) {
  if (is.na(x)) {
    return("white")
  }

  if (x <= 0) {
    return("white")
  } else if (x > 0) {
    return("black")
  }
}

getColor.lia <- function(x) {
  if (is.na(x)) {
    return("white")
  }

  if (stringr::str_detect(string = x, pattern = "Não")) {
    return("green")
  } else {
    return("red")
  }
}

# Depende de `col.brew2` estar definido no ambiente de chamada; sem uso ativo
# no app hoje (ver modules/README.md), preservada por fidelidade ao legado.
getColor2 <- function(x) {
  switch(x,
    "1" = col.brew2[1], "2" = col.brew2[2], "3" = col.brew2[3], "4" = col.brew2[4],
    "5" = col.brew2[5], "6" = col.brew2[6], "7" = col.brew2[7], "8" = col.brew2[8],
    "9" = col.brew2[9], "10" = col.brew2[10], "11" = col.brew2[11], "12" = col.brew2[12],
    "13" = col.brew2[13], "14" = col.brew2[14], "15" = col.brew2[15], "16" = col.brew2[16],
    "17" = col.brew2[17], "18" = col.brew2[18], "19" = col.brew2[19], "20" = col.brew2[20],
    "21" = col.brew2[21], "22" = col.brew2[22]
  )
}

getColor <- function(med) {
  colors <- RColorBrewer::brewer.pal(n = 6, name = "Set1")
  if (med == "Norte") {
    return(colors[1])
  } else if (med == "Oeste") {
    return(colors[2])
  } else if (med == "Leste") {
    return(colors[3])
  } else if (med == "Noroeste") {
    return(colors[4])
  }
}

kable_data <- function(data, cap, foot = " ", align = "c") {
  data %>%
    knitr::kable(booktabs = TRUE, caption = cap, align = align, format = "latex") %>%
    kableExtra::kable_styling(full_width = FALSE, latex_options = "hold_position")
}

axis.theme <- function(x.angle = 0, vjust = 0, hjust = 0.5) {
  textsize <- 18
  ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = x.angle, face = "bold", size = textsize, hjust = hjust, vjust = vjust),
      axis.text.y = ggplot2::element_text(angle = 0, face = "bold", size = textsize),
      legend.background = ggplot2::element_rect(fill = "transparent", colour = NA, size = 2),
      panel.background = ggplot2::element_rect(fill = "transparent", colour = NA),
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),
      axis.title.x = ggplot2::element_text(colour = "black", size = textsize, face = "bold"),
      axis.title.y = ggplot2::element_text(colour = "black", size = textsize, face = "bold"),
      legend.title = ggplot2::element_text(colour = "black", size = 10),
      legend.position = "top",
      legend.text = ggplot2::element_text(colour = "black", size = 14, face = "bold"),
      panel.grid = ggplot2::element_line(linetype = "dashed"),
      panel.grid.major = ggplot2::element_line(colour = "gray"),
      title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5),
      plot.title = ggplot2::element_text(hjust = 0.5),
      axis.title = ggplot2::element_text(color = "#000000", face = "bold", size = textsize, lineheight = 2)
    )
}
