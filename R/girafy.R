#' Rend un graphique interactif (avec ggiraph)
#'
#' Cette fonction prend en charge le passage par ggiraph, en spécifiant les options
#' importantes (dont les tooltips). Elle enregistre le graphique pour usage ultérieur
#' (dans une présentation) afin de garantir l'unicité des sources. L'interactivité
#' repose sur l'utilisation des fonctions de `ggiraph` `geom_*_interactive()`.
#'
#' @param plot le graphique ggplot à rendre interactif
#' @param r (1.5) le rayon du zoom sur le point en cas de survol (en pixels)
#' @param o (0.5) l'opacité des autres éléments en cas de survol (entre 0 et 1)
#' @param id identifiant unique pour le graphique, utilisé pour l'enregistrement
#' @param pointsize (12) taille de la police pour le rendu SVG (en points)
#' @param width_svg largeur du graphique SVG en inches. Si NULL, déterminée automatiquement
#' @param height_svg hauteur du graphique SVG en inches. Si NULL, déterminée automatiquement
#' @param tooltip_css chaîne de style CSS personnalisé pour les tooltips.
#'   Utilise `.tooltip_css` par défaut (style intégré)
#' @param biratio vecteur numérique de longueur 2 pour le responsive design :
#'   `c(ratio_desktop, ratio_mobile)`. Par défaut NULL. Si fourni, génère deux versions
#'   du graphique adaptées à la largeur d'écran (desktop et mobile).
#'   Exemple : `c(0.6, 1.333)` produit un graphique plus carré pour desktop
#'   et plus haut pour mobile.
#' @param png_dpi (300) résolution du PNG téléchargé via le bouton de la barre d'outils.
#'   Le bouton natif de ggiraph exporte à la taille écran (~96 dpi) ; il est remplacé
#'   par un export à `png_dpi`, sur fond blanc, avec les polices OFCE incorporées
#'   (elles n'ont pas besoin d'être installées). `NULL` garde le bouton natif.
#' @param ... autres options passées à `ggiraph::girafe_options()`
#'
#' @returns un objet ggiraph (en sortie HTML/interactive) ou un ggplot (en sortie statique)
#' @export
girafy <- function(plot,
                   ...,
                   r = 1.5, o = 0.5, s = -1,
                   id = NULL,
                   pointsize = 12,
                   width_svg = NULL,
                   height_svg = NULL,
                   tooltip_css = .tooltip_css,
                   biratio = NULL,
                   png_dpi = 300) {
  withr::local_options(OutDec = ".")
  assertthat::assert_that(ggplot2::is_ggplot(plot),
                          msg = "Ce n'est pas un ggplot, pas possible de girafier")
  options <- list(...)
  save_graph(plot, id=id)
  if(knitr::is_html_output()| interactive()) {
    hover_str <- ""
    hover_inv_str <- ""
    if(r>=0)
      hover_str <- glue::glue("r:{r}px;")
    if(r>=0)
      hover_str <- glue::glue("{hover_str} stroke-width:{s}px;")
    if(o>=0)
      hover_inv_str <- glue::glue("opacity:{o};")
    local_options <- function(g)
      ggiraph::girafe_options(
        g,
        ggiraph::opts_hover_inv(css = hover_inv_str),
        ggiraph::opts_hover(css = hover_str),
        ggiraph::opts_tooltip(css = tooltip_css)) |>
      ggiraph::girafe_options(!!!options) |>
      png_export(dpi = png_dpi, name = if (is.null(id)) "graphique" else id)
    # fontset <- gdtools::font_set(sans = gdtools::font_google("Arimo"))
    if(is.null(biratio))
      return(
        ggiraph::girafe(
          plot,
          width_svg = width_svg,
          height_svg = height_svg,
          pointsize = pointsize,
          # font_set = fontset,
          bg = "transparent") |>
          local_options()
      )
    if(!(is.numeric(biratio) & length(biratio) == 2)) {
      chunk <-  knitr::opts_current$get()
      if(!is.null(chunk)) {
        biratio <- c(chunk$fig.width/chunk$fig.height, 1.333)
      } else {
        biratio <- c(0.6, 1.333) }
    }
    giraph_desk  <- ggiraph::girafe(
      plot,
      width_svg = 8,
      height_svg = 8 * biratio[[1]],
      pointsize = pointsize,
      # font_set = fontset,
      bg = "transparent") |>
      local_options()
    # mobile : portrait
    giraph_mob   <- ggiraph::girafe(
      plot,
      width_svg = 8,
      height_svg = 8 * biratio[[2]],
      # font_set = fontset,
      pointsize = pointsize,
      bg = "transparent") |>
      local_options()
    if(interactive())
      return(giraph_desk)
    return(
      htmltools::div(
        htmltools::div(class = "d-none d-md-block", giraph_desk),
        htmltools::div(class = "d-md-none",         giraph_mob)) )
  }

  if(!knitr::is_html_output()) {
    return(plot)
  }
  # au cas où rien ne colle, on ne fait rien
  plot
}

# Polices web (Arimo, Merriweather) attachées à chaque widget : le SVG
# s'affiche avec les bonnes polices même si elles ne sont pas installées sur
# le poste du lecteur.
ofce_fonts_dependency <- function() {
  htmltools::htmlDependency(
    name = "ofce-fonts",
    version = as.character(utils::packageVersion("ofce")),
    src = system.file("fonts", "web", package = "ofce"),
    stylesheet = "ofce-fonts.css",
    all_files = TRUE)
}

# Remplace le bouton "download png" de ggiraph, qui exporte le SVG à sa taille
# écran (saveSvgAsPng sans `scale`), par un export à `dpi`. Le clic est
# intercepté en phase de capture sur le conteneur du widget, avant le handler
# d'origine. Un SVG dessiné dans un canvas ne peut pas charger de police
# externe : les @font-face utilisées sont donc incorporées (data URI) dans la
# copie du SVG avant le rendu.
png_export <- function(g, dpi = 300, name = "graphique") {
  g$dependencies <- c(g$dependencies, list(ofce_fonts_dependency()))
  if (is.null(dpi))
    return(g)
  htmlwidgets::onRender(g, .png_export_js, data = list(dpi = dpi, name = name))
}

.png_export_js <- "
function(el, x, data) {
  // @font-face de la page, incorporées en data URI (une seule fois par page)
  function embeddedFonts(families) {
    if (!window.__ofceFontFaces) {
      var faces = [];
      Array.prototype.forEach.call(document.styleSheets, function(sheet) {
        var rules;
        try { rules = sheet.cssRules; } catch (e) { return; }
        Array.prototype.forEach.call(rules || [], function(rule) {
          if (rule.type !== CSSRule.FONT_FACE_RULE) return;
          var m = rule.style.getPropertyValue('src').match(/url\\([\"']?([^\"')]+)[\"']?\\)/);
          if (!m) return;
          faces.push({
            family: rule.style.getPropertyValue('font-family').replace(/[\"']/g, '').trim(),
            css: rule.cssText,
            raw: m[1],
            url: new URL(m[1], sheet.href || document.baseURI).href
          });
        });
      });
      window.__ofceFontFaces = Promise.all(faces.map(function(f) {
        return fetch(f.url)
          .then(function(r) { return r.blob(); })
          .then(function(blob) {
            return new Promise(function(resolve) {
              var fr = new FileReader();
              fr.onload = function() { f.css = f.css.split(f.raw).join(fr.result); resolve(f); };
              fr.readAsDataURL(blob);
            });
          })
          .catch(function() { return null; });
      }));
    }
    return window.__ofceFontFaces.then(function(faces) {
      return faces
        .filter(function(f) { return f && families.indexOf(f.family) >= 0; })
        .map(function(f) { return f.css; })
        .join(' ');
    });
  }

  el.addEventListener('click', function(ev) {
    var btn = ev.target.closest('.ggiraph-toolbar-icon-saveaspng');
    if (!btn) return;
    ev.stopImmediatePropagation();
    ev.preventDefault();
    var toolbar = btn.closest('[id$=\"_toolbar\"]');
    var svg = toolbar ?
      document.getElementById(toolbar.id.replace(/_toolbar$/, '')) :
      el.querySelector('svg[viewBox]');
    if (!svg) return;
    var vb = svg.viewBox.baseVal;
    var scale = data.dpi / 72;
    var w = Math.round(vb.width * scale), h = Math.round(vb.height * scale);
    var clone = svg.cloneNode(true);
    clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
    clone.setAttribute('width', w);
    clone.setAttribute('height', h);
    clone.removeAttribute('style');
    var families = [];
    clone.querySelectorAll('[font-family]').forEach(function(n) {
      var f = n.getAttribute('font-family').replace(/[\"']/g, '').trim();
      if (families.indexOf(f) < 0) families.push(f);
    });
    embeddedFonts(families).then(function(css) {
      if (css) {
        var style = document.createElementNS('http://www.w3.org/2000/svg', 'style');
        style.textContent = css;
        clone.insertBefore(style, clone.firstChild);
      }
      var src = new XMLSerializer().serializeToString(clone);
      var img = new Image();
      img.onload = function() {
        var canvas = document.createElement('canvas');
        canvas.width = w;
        canvas.height = h;
        var ctx = canvas.getContext('2d');
        ctx.fillStyle = 'white';
        ctx.fillRect(0, 0, w, h);
        ctx.drawImage(img, 0, 0, w, h);
        canvas.toBlob(function(blob) {
          var a = document.createElement('a');
          a.href = URL.createObjectURL(blob);
          a.download = data.name + '.png';
          document.body.appendChild(a);
          a.click();
          a.remove();
          setTimeout(function() { URL.revokeObjectURL(a.href); }, 1000);
        }, 'image/png');
      };
      img.src = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(src);
    });
  }, true);
}
"

.tooltip_css  <-
  "font-family:Open Sans;
  background-color:snow;
  border-radius:5px;
  border-color:gray;
  border-style:solid;
  border-width:0.5px;
  font-size:9pt;
  padding:4px;
  box-shadow: 2px 2px 2px gray;
  r:20px;"

girafe_opts <- function(x, ...) ggiraph::girafe_options(
  x,
  ggiraph::opts_hover(css = "stroke-width:1px;", nearest_distance = 60),
  ggiraph::opts_tooltip(css = tooltip_css, delay_mouseover = 10, delay_mouseout = 3000)) |>
  ggiraph::girafe_options(...)
