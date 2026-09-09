rm_accent <- function(str,pattern="all") {
  if(!is.character(str))
    str <- as.character(str)
  pattern <- unique(pattern)
  if(any(pattern=="Ç"))
    pattern[pattern=="Ç"] <- "ç"
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
  accentTypes <- c("´","`","^","~","¨","ç")
  if(any(c("all","al","a","todos","t","to","tod","todo")%in%pattern)) # opcao retirar todos
    return(chartr(paste(symbols, collapse=""), paste(nudeSymbols, collapse=""), str))
  for(i in which(accentTypes%in%pattern))
    str <- chartr(symbols[i],nudeSymbols[i], str)
  return(str)
}



getColor.inc <- function(x) {
  if(is.na(x)){
    return("white")
  } else{
    
    if(x <= 0){
      
      return("white")
      
    }else if(x <= 50){
      
      return("lightgray")
      
    }else if(x <= 100){
      
      return("yellow")
      
    }else if(x <= 300){
      return("orange")
      
    }else if(x <= 500){
      return("red")
      
    }else{
      
      return("saddlebrown")
      
    }
  }
  
}


getColor.obt <- function(x) {
  if(is.na(x)){
    return("white")
  } else{
    
    if(x <= 0){
      
      return("white")
      
    }else if(x > 0){
      
      return("black")
      
    }
  }
  
}

getColor.lia <- function(x) {
  
   if(is.na(x)){
     
     return("white")
     
   }else{
     if(str_detect(string = x,pattern = "Não")){
       
       return("green")
       
     }else {
       
       return("red")
       
     }
     
   } 
    
  
}

getColor.lia("Não")

getColor2 <- function(x) {
  switch (x,
          "1" = col.brew2[1],
          "2" = col.brew2[2],
          "3" = col.brew2[3],
          "4" = col.brew2[4],
          "5" = col.brew2[5],
          "6" = col.brew2[6],
          "7" = col.brew2[7],
          "8" = col.brew2[8],
          "9" = col.brew2[9],
          "10" = col.brew2[10],
          "11" = col.brew2[11],
          "12" = col.brew2[12],
          "13" = col.brew2[13],
          "14" = col.brew2[14],
          "15" = col.brew2[15],
          "16" = col.brew2[16],
          "17" = col.brew2[17],
          "18" = col.brew2[18],
          "19" = col.brew2[19],
          "20" = col.brew2[20],
          "21" = col.brew2[21],
          "22" = col.brew2[22],
  )
  
  
  
}



getColor <- function(med) {
 # cols <- c()
  col.brew            <- brewer.pal(n = 6, name = "Set1")
  colors              <- col.brew
  if(med == "Norte") {
    return(colors[1])
  } else if(med == "Oeste") {
    return(colors[2])
  } else if(med == "Leste") {
    return(colors[3])
  }else if(med == "Noroeste") {
    return(colors[4])
  }
  
  
 # return(cols)
}

#sapply(1:length(dados.maps.pr$macroregional),FUN = function(i) getColor(as.character(dados.maps.pr$macroregional[i])))

kable_data <- function(data,cap,foot=" ",align="c"){
  library(kableExtra)
  
  t<- data %>%
    kable(booktabs=T,caption = cap,align = align,format ="latex" ) %>%
    #add_footnote(foot) %>%
    kable_styling(full_width = F, latex_options = "hold_position") 
  return(t)
}
