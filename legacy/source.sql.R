library(sqldf)
library(RSQLite)


#df <- df[df$CLASSI_FIN==10|df$CLASSI_FIN==11|df$CLASSI_FIN==12,]
bd_path  <- "data.sqlite"
start<-function(){
  
  if(file.exists(bd_path)){
    print("BD Ja Existe!!!")
    db      <<-  dbConnect(RSQLite::SQLite(), bd_path) 
    
  }else{
    df <- read.table(file = "dbase.csv",header = T,sep = ",")
    print("Banco de Dados nao existe!!!")
    print("Criado com sucesso!!!")
    db = dbConnect(SQLite(), dbname=bd_path)
    dbWriteTable(conn = db,name = "dbase",value =df )
    
    dbDisconnect(db)
  }

}
start()

