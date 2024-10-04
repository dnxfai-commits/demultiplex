#!/usr/bin/env Rscript

# Definisci la funzione per leggere e processare il file CSV
process_csv <- function(file_path) {
  # Leggi il file CSV
  file_csv <- readr::read_csv(file_path, show_col_types = F)
  
  # Creiamo la cartella
  dir.create("Params")
  
  # Esegui il gruppo e la scrittura per ogni gruppo
  file_csv |> 
    dplyr::group_by(SampleProject) |> 
    dplyr::group_split() |> 
    # Scrive ogni gruppo in un file separato (in alternativa modifica qui per scrivere un singolo file)
    purrr::iwalk(~ readr::write_csv(.x, paste0("Params/", .x$SampleProject[1], ".csv")))
}

# Usa argparser per gestire l'input del file da riga di comando
p <- argparser::arg_parser("Processa un file CSV in base al campo 'SampleProject'")
p <- argparser::add_argument(p, "file_path", help="Il percorso del file CSV")

# Parsing degli argomenti
argv <- argparser::parse_args(p)

# Esegui la funzione con il file dato dall'utente
process_csv(argv$file_path)

