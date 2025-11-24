# Ecrit sur le board

Wrapper pour pins. la fonction suppose qu'il existe un blob Azure qui a
été préalablement créé et dont les éléments sont dans .Renviron
(azure_url et azure_jeton) et dont les droits d'accès douvent être
corrects.

## Usage

``` r
bd_write(
  obj,
  name = NULL,
  title = NULL,
  description = NULL,
  metadata = NULL,
  tags = NULL,
  versioned = NULL
)
```

## Arguments

- obj:

  l'objet que l'on souhaite écrire

- name:

  le nom qu'il aura dans le pins::board, le nom de l'objet si ce n'est
  pas spécifié

- title:

  le titre du pins, optionel, mais aide à la compréhension de ce que
  l'objet contient

- description:

  une description, idem, pour faciliter l'usage

- metadata:

  des métadonnées utilisées par pins et stockées dans le board

- tags:

  idem, des tags

- versioned:

  verisoning du board (NULL par défaut, donc suit celui du board)

## Value

(invisible) le nom du pins
