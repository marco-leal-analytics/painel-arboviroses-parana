# Output

Artefatos gerados em runtime pelo módulo `modules/relatorio` (mapas em PNG,
`main.tex`/`body.tex` e o `main.pdf` compilado). Todo o diretório é ignorado
pelo git (ver `.gitignore`) e recriado automaticamente pela aplicação — ver
`R/utils.R#report_output_dir()`.

O PDF final é copiado para `pdf_folder/formulario.pdf`, que é o caminho
servido publicamente pelo Shiny.
