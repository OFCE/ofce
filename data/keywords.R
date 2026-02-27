# Ancien --------

keywords <- tibble::tribble(
  ~FR,                      ~EN,
  "Conjoncture",            "Forecasting",
  "Taux souverain",         "Interest rates",
  "Commerce extérieur",     "Foreign trade",
  "Déficit publique",       "Public deficit",
  "Dette public",           "Public debt",
  "Politique budgétaire",   "Fiscal policy",
  "Politique territoriale", "Territorial policy",
  "Politique industrielle", "Industrial policy",
  "Politique monétaire",    "Monetary policy",
  "Réglementation",         "Regulation",
  "Fiscalité",              "Taxation",
  "Inflation",              "Inflation",
  "Productivité",           "Productivity",
  "France",                 "France",
  "Europe",                 "Europe",
  "USA",                    "USA",
  "Innovation",             "Innovation",
  "Numérique",              "Digital",
  "Agriculture",            "Agriculture",
  "Industrie",              "Industry",
  "Énergie",                "Energy",
  "Environnment",           "Environment",
  "Changement climatique",  "Climate change",
  "Capitalisme",            "Capitalism",
  "Emploi",                 "Labor",
  "Inégalités",             "Inequalities",
  "Démographie",            "Demography",
  "Genre",                  "Gender",
  "Logement",               "Housing",
  "Retraites",              "Pensions",
  "Etat-Providence",        "Welfare State",
  "Protection sociale",     "Social security"
)


# Nouveau --------

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

