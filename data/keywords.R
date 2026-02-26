
keywords <- tibble::tribble(
  ~FR,                     ~EN,
  "Conjoncture",            "Economic outlook",
  "Taux souverain",         "Sovereign interest rates",
  "Commerce extérieur",     "International trade",
  "Déficit public",         "Government deficit",
  "Dette publique",         "Public debt",
  "Politique budgétaire",   "Fiscal policy",
  "Politique territoriale", "Regional policy",
  "Politique industrielle", "Industrial policy",
  "Politique monétaire",    "Monetary policy",
  "Réglementation",         "Regulation",
  "Fiscalité",              "Tax policy",
  "Inflation",              "Inflation",
  "Productivité",           "Productivity",
  "France",                 "France",
  "Europe",                 "Europe",
  "USA",                    "United States",
  "Innovation",             "Innovation",
  "Numérique",              "Digital economy",
  "Agriculture",            "Agriculture",
  "Industrie",              "Manufacturing",
  "Énergie",                "Energy",
  "Environment",            "Environment",
  "Changement climatique",  "Climate change",
  "Capitalisme",            "Capitalism",
  "Emploi",                 "Employment",
  "Inégalités",             "Inequality",
  "Démographie",            "Demographics",
  "Genre",                  "Gender equality",
  "Logement",               "Housing",
  "Retraites",              "Pensions",
  "Etat-Providence",        "Welfare state",
  "Protection sociale",     "Social protection"
)

save(keywords, file = "data/keywords.rda")

