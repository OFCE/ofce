# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

The `ofce` package is an R package for creating scientific documents following OFCE (Observatoire français des conjonctures économiques) standards. It provides:
- ggplot2 themes and color palettes following OFCE/Revue graphical standards
- Quarto templates for working papers, blogs, presentations, and websites
- French-language formatting utilities
- Integration with marquee for advanced text rendering

The package is primarily for French economic research publications, with French as the default language.

## Development Commands

### Building and Testing
```r
# Install package in development mode
devtools::load_all()

# Build documentation
devtools::document()

# Build and check package
devtools::check()

# Build pkgdown site
pkgdown::build_site()

# Install from local source
devtools::install()
```

### Common Development Tasks
```r
# Test a specific function interactively
devtools::load_all()
library(tidyverse)
# Your test code here

# Run examples from a function
devtools::run_examples()

# Check package for CRAN compliance
devtools::check()
```

## Architecture

### Core Components

**Quarto Templates System** (`R/quarto.R`, `inst/extdata/templates/`)
- `setup_quarto()`: Installs OFCE Quarto extensions to a project
- `setup_wp()`, `setup_blog()`, `setup_graph()`, `setup_pres()`: Initialize specific document types with templates
- Templates stored in `inst/extdata/templates/` (blog, graph, presentation, website, workingpaper)
- Extensions pulled from `ofce/ofce-quarto-extensions` repository

**Theme System** (`R/theme_ofce.R`)
- `theme_ofce()`: Main ggplot2 theme for OFCE graphics following Revue de l'OFCE standards
- `theme_ofce_void()`: Simplified theme for maps and minimal graphics
- Supports both marquee (advanced markdown text rendering) and standard ggplot2 text elements
- Configurable via global options: `ofce.base_size`, `ofce.base_family`, `ofce.marquee`, `ofce.background_color`

**Caption System** (`R/ofce_caption.R`)
- `ofce_caption()`: Creates standardized captions for ggplot2 graphics with source, note, lecture, champ, code
- `ofce_caption_gt()`: Caption system for gt tables
- `dernier_point()`: Formats "last known data point" dates in French or English
- Supports glue string interpolation and marquee markdown transformations (^x^ → superscript, ~x~ → subscript)

**Palette System** (multiple files)
- `R/ofce_palette*.R`: Color palettes (main, sequential, diverging, country-specific)
- `R/scale_color_pays.R`: Country-specific color scales
- Data stored in `inst/palette.ofce.rda`

**Graph Export** (`R/graph2xxx.R`)
- `graph2png()`, `graph2svg()`, `graph2pptx()`: Export graphics in various formats
- Handles ggplot2 and tmap objects
- Default size: 18cm width, 4:3 ratio
- Uses showtext for proper font rendering at high DPI (default 600)

**Formatting Utilities** (`R/formate.R`)
- `fmt_val()`: Format numbers in French style (comma as decimal, space as thousands separator)
- `fmt_pct()`: Format percentages
- `fmt_mds()`: Format billions of euros (Milliards d'euros)

**Initialization System** (`R/init_qmd.R`, `inst/rinit.r`)
- `init_qmd()`: Sources project-specific or package `rinit.r` at document start
- `pathify()`: Resolves paths from project root (paths starting with `/`)
- Default `rinit.r` sets up fonts, themes, knitr options, common libraries, and French locale

### Key Design Patterns

**Global Options**
The package heavily uses R options for configuration:
- `ofce.base_size`: Base font size (default 12)
- `ofce.base_family`: Font family (default "Open Sans")
- `ofce.marquee`: Enable marquee text rendering (default TRUE)
- `ofce.background_color`: Background color (default "transparent")
- `ofce.caption.*`: Caption formatting options (wrap, lang, ofce branding, glue interpolation)

**Font System**
- Uses Open Sans as default font (included in `inst/fonts/`)
- Relies on showtext/sysfonts for rendering
- systemfonts used to register fonts in rinit.r

**Marquee vs Standard Text**
- When `ofce.marquee = TRUE`: Uses `marquee::element_marquee()` for advanced markdown rendering in ggplot2
- When `ofce.marquee = FALSE`: Falls back to standard `ggplot2::element_text()`
- This dual system allows for rich text formatting while maintaining compatibility

**French Language Defaults**
- All user-facing text defaults to French
- Date formatting uses French locale
- Caption labels: "Source", "Lecture", "Note", "Champ", "Code", "Dernier point connu"
- Most functions have `lang` parameter for English output

## Important Files

- `DESCRIPTION`: Package metadata, dependencies (requires R >= 4.2, Quarto CLI)
- `inst/rinit.r`: Default initialization script sourced by `init_qmd()`
- `inst/extdata/templates/`: Quarto document templates
- `inst/fonts/`: OpenSans font files
- `_pkgdown.yml`: Documentation website configuration
- `.Rbuildignore`: Files to exclude from package builds

## Common Workflows

### Adding a New Graphical Theme Element
1. Edit `R/theme_ofce.R`
2. Update both marquee and non-marquee versions
3. Test with `devtools::load_all()` and create example plots
4. Document changes and rebuild with `devtools::document()`

### Creating a New Quarto Template
1. Add template files to `inst/extdata/templates/[type]/`
2. Create setup function in `R/quarto.R` (e.g., `setup_[type]()`)
3. Update `setup_quarto()` documentation to mention new format
4. Test installation with `setup_quarto()` in a test directory

### Modifying Color Palettes
1. Edit palette data in `data/` directory
2. Update corresponding `R/ofce_palette*.R` file
3. Regenerate `inst/palette.ofce.rda` if needed
4. Update documentation and examples

## Dependencies

**Critical Dependencies**
- ggplot2 >= 4.0.0: Core graphics system
- marquee >= 1.2.0: Advanced text rendering
- gt >= 1.1.0: Table formatting
- quarto: Document rendering (requires Quarto CLI installed)
- showtext/sysfonts: Font rendering

**Data Processing**
- tidyverse >= 2.0.0 (dplyr, tidyr, purrr, stringr)
- data.table: High-performance data manipulation

**Utility**
- glue: String interpolation
- fs: File system operations
- lubridate: Date handling

## Notes

- The package website is hosted at https://ofce.github.io/ofce/
- Documentation includes extensive vignettes for different chart types, Quarto usage, and graphic standards
- This is a specialized package for OFCE institutional use, not intended for CRAN
- Uses CC BY 4.0 license
