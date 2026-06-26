# Des sites dédiés

Les sites dédiés sont un ensemble de documents autour d’un sujet. Le
site s’intègre (et s’intègrera de mieux en mieux) sur le site principal
de l’OFCE, l’objectif étant une fluidité invisible aux yeux des
navigateurs.

Un site dédié se compose donc :

1.  d’un nom de domaine le reliant au site de l’OFCE et lui donnant son
    propre espace et son identification.

2.  d’un dépôt github sur le compte OFCE, accessible sur
    [github.com](https://github.com/ofce). Les contributeurs ont le
    droit d’écriture, il y a un ou plusieurs administrateurs. Les
    administrateurs assurent la publication du site, le fonctionnement
    du travail. Ce dépôt est accessible à l’ensemble des membres du
    compet OFCE en lecture et ils peuvent s’en inspirer comme point de
    départ pour d’autres travaux.

3.  de contenus, c’est-à-dire de documents `.qmd` (voir
    [`vignette("quarto")`](https://ofce.github.io/ofce/articles/quarto.md))
    avec des graphiques, si possible en
    [ggplot2](https://ggplot2.tidyverse.org) (voir la
    [`vignette("graphiques")`](https://ofce.github.io/ofce/articles/graphiques.md)),
    interactifs ([ggiraph](https://davidgohel.github.io/ggiraph/)) dont
    les données sont téléchargeables
    [downloadthis](https://github.com/fmmattioni/downloadthis) et dont
    les codes sont accessibles (reproductibilité et transparence). La
    tableaux sont préférablement en [gt](https://gt.rstudio.com) (voir
    la vignette sur les tableaux
    [`vignette("tableaux")`](https://ofce.github.io/ofce/articles/tableaux.md)).

4.  d’une structure (des menus, une hiérarchie) qui est spécifiée dans
    un fichier particulier : `_quarto.yml` (ou le iamèle). Ce fichier
    contient également plein d’éléments généraux, comme le titre du
    site, son numéro Google Analytics, des instructions pour la mise en
    page, etc.

5.  Les choix éditoriaux reviennent aux administrateurs, en suivant les
    recommandations générales. En particulier, bien que ce ne soit pas
    encore mis sous forme de procédure, les sites dédiés seront d’abord
    publiés de façon privée (*stage*) pour être validés puis publiés.

Le blog de l’OFCE sera (le 5/7/2024 le futur est encore de mise) un site
dédié, ouvert à tous les contributeurs avec quelques administrateurs
permanents. Les règles de cette vignette s’y appliquent donc et la
[`vignette("blog")`](https://ofce.github.io/ofce/articles/blog.md)
détaille les spécificités.

## Comment contribuer : *pull request*

Pour contribuer nous vous demandons de suivre une procédure stricte.
Elle peut paraître compliquée, mais elle est fluide et permet d’éviter
des bêtises. En effet, la branche `master` et la branche du site
(`gh-pages`) sont protégées : il faut des droits administrateur pour les
modifier. Cela évite les mauvaises manipulations et sécurise le site.

Il est possible d’utiliser plusieurs outils pour travailler. Le premier
combo est `RStudio`, combiné à `github desktop` et github.com. Une
alternative est `VSCode` qui regroupe l’éditeur quarto et l’interface
github dans un même logiciel. La
[`vignette("outils")`](https://ofce.github.io/ofce/articles/outils.md)
détaille les configurations et les instructions d’installation.

### Comment faire ?

1.  créer une branche à partir de `master`. C’est simple avec
    `github desktop` (`menu branch/new branch`). Cette branche est
    modifiable par celui qui l’a créée (mais aussi par d’autres, s’il le
    souhaite, ce qui peut permettre la mise au point). Elle contient une
    copie de `master` donc vous pouvez tout modifier dedans. Cependant,
    afin d’éviter le chaos, il est préférable de modifier le contenu
    pour lequel on est contributeur et s’en tenir à ça. Si vous voulez
    corriger le contenu d’autres auteurs ou intervenir sur la structure
    générale c’est bien sûr possible.  
    Si vous continuez sur votre branche, elle est sans doute en retard.
    Vous pouvez la mettre à jour à partir de `master` (menu
    `branch/Update from master` dans `github desktop`) afin d’éviter de
    vous trouver trop en retard et Vous pouvez aussi faire un *merge* de
    `master` dans votre branche. Ne pas le faire va multiplier les
    conflits et rendre l’inclusion de vos modifications pénibles.

2.  Modifier, ajouter, bricoler et… **tester**. Dans RStudio vous pouvez
    à tout moment faire un *render* du site (bouton `render`). Si ça ne
    marche pas dans votre branche, il y a peu de chance que ça s’arrange
    tout seul en suite. Vous pouvez toujours appeler à l’aide quand ça
    ne marche pas. Vérifiez que les liens sont bons, que la mise en page
    vous convient, etc.

3.  A chaque fois que vous avez franchi une étape dans votre travail,
    faites un *commit*. Pas besoin nécessairement de le *pusher* (c’est
    mieux pour sauvegarder ou partager avec quelqu’un ce qu’il y a dans
    votre branche). Un *commit* c’est une sauvegarde. Avant de lancer
    une nouvelle tâche, faites le *commit*, ça pourra toujours servir et
    il n’y a pas d’excès de *commit*.

4.  Quand vous êtes satisfait, vous faites une *pull request* (facile
    dans `github desktop`, il le propose une fois *pushé* votre dernier
    *commit*). La *pull request* n’est possible que lorsque tous vos
    changements sont *commités* et que votre branche est *pushée*. La
    possibilité de le faire apparaît dans la fenêtre principale de
    `github desktop` lorsque les conditions sont réunies.

5.  Si vous êtes consciencieux, vous pouvez vérifier que votre branche
    est compatible avec `master` et faire le *merge.* Passez par le menu
    `branch/update from master` avant de faire la `pull request`. Cela
    permet de vérifier (et de résoudre) les éventuels conflits qui
    existeraient entre votre branche la branche `master`.

6.  Une fois la *pull request* envoyée, elle va être validée par les
    administrateurs (et les conflits résolus si vous ne l’avez pas
    fait). Au moment de la *pull request* vous pouvez assigner un
    *reviewer.* Une fois validée, votre branche est intégrée (*mergée)*
    à la branche `master` ce qui permettra de mettre à jour le site en
    ligne et de détruire votre branche. (Pourquoi la détruire ? 1. votre
    travail est intégré dans `master` donc il est en sécurité, 2. si
    vous refaites des modifications, **il faut partir de la dernière
    version disponible**, i.e. `master` et non pas votre branche qui va
    devenir très en retard).

## Quelques conseils aux administrateurs de projets

1.  Définissez à l’avance la structure du projet et communiquez là aux
    auteurs. Parfois, on a envie de changer en cours de route, c’est
    toujours possible, mais source de confusion et potentiellement
    d’erreurs.

2.  Protégez la branche `master` et définissez ceux qui ont droit de la
    modifier. Cela évitera aussi de nombreuses erreurs. Protégez aussi
    `gh-pages`. Ces opérations se réalisent très simplement depuis
    [github.com](htpps://github.com/ofce).

3.  Si votre dépôt est sur OFCE, il sera lisible par les membres de
    l’OFCE et les admins d’OFCE pourront intervenir dessus. Si il est
    dans votre espace personnel, vous êtes seul maître à bord et donc
    sans assistance possible.

4.  Au démarrage du projet, il y a quelques configurations à faire. Rien
    de compliqué, mais c’est dispersé dans de nombreux écrans. Une fois
    configuré, c’est assez simple à faire fonctionner.

5.  Ne bricolez pas trop le `_quarto.yml`. Certaines options assurent
    l’homogénéité des sites entre eux. Pensez faire aussi
    `ofce::quarto_setup()` dans R pour s’assurer d’avoir la dernière
    version des templates. Attention, il faut quand même modifier le
    `_quarto.yml` puisqu’il contient la structure des menus et
    l’architecture du site, ainsi que les twitter cards ou le numéro
    google analytics.

6.  N’hésitez pas à la faire la police (`qmd` dans les bons dossiers,
    `yml` nettoyés, chasse aux chemins absolus. A force, les déviances
    devraient se réduire.

7.  Répondez rapidement aux *pull request*. On est souvent impatient de
    voir son travail déployé.
