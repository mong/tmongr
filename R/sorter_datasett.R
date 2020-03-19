sorter_datasett <- function(datasett) {
  # Sortere datasett i forhold til boområdet og behandlingsområdet

  # Hvis det kun er en rad, vil denne rutinen "ødelegge" tabellen.
  if (nrow(datasett) == 1) {
    return(datasett)
  }

  names1 <- c(
    "Eget lokalsykehus", # 1
    "Annet sykehus i eget HF", # 2
    "UNN Troms", # 3
    "UNN HF", # 4
    "NLSH Bod", # 5
    "Nordlandssyk", # 6
    "Annet HF i HN", # 7
    "HF i andre RHF", # 8 #A
    "Kirkenes", "Hammerfest", "Troms", "Harstad", "Narvik", "Vester", "Lofoten", "Bod", "Rana", "Mosj", "Sandnessj", # B
    "Finnmark", "Klinikk", "UNN", "Nordland", "Helgeland", "HF i S", # C
    "Bor utenfor", "Resterende", "Andre offentlige", "Private", # D
    "Helse Nord RHF", "Helse Midt-Norge", "Helse Vest RHF", "Helse S", # E
    "Døgnopphold", "Dagbehandling", "Poliklinikk", "Avtalespesialister", "Avtalespesialist", # F
    "Planlagt medisin", "Akutt medisin", "Planlagt kirurgi", "Akutt kirurgi", # G
    "Sum", "Akutt", "Planlagt" # H
  )

  names2 <- c(
    "aaa", "aab", "baa", "bab", "bac", "bae", "caa", "cab", #A
    "daa", "dab", "dac", "dad", "dae", "daf", "dag", "dah", "dai", "daj", "dak", #B
    "aba", "abb", "baf", "bag", "cba", "cbb", #C
    "xaa", "xbb", "xcc", "xxx", # D
    "aca", "acb", "acc", "acd", # E
    "ada", "adb", "adc", "yyy", "add", # F
    "aea", "aeb", "aec", "aed", # G
    "zzz", "mmm", "nnn" # H
  )
  tmp <- datasett

  for (i in seq_along(names1)) tmp <- gsub(names1[i], names2[i], tmp)

  tmp <- tmp[order(tmp[, 1], tmp[, 2]), ]

  for (i in seq_along(names1)) tmp <- gsub(names2[i], names1[i], tmp)

  return(tmp)
}
