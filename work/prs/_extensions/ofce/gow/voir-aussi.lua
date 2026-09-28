-- Lua filter to add "Voir aussi" section at the end of the document

function Pandoc(doc)
  local extraref = doc.meta.extraref

  if extraref then
    local items = {}

    for _, ref in ipairs(extraref) do
      local texte = pandoc.utils.stringify(ref.texte)
      local item
      if ref.lien then
        local lien = pandoc.utils.stringify(ref.lien)
        item = pandoc.Link(texte, lien)
      else
        item = pandoc.Str(texte)
      end
      table.insert(items, {pandoc.Plain(item)})
    end

    local heading = pandoc.Para({pandoc.Strong({pandoc.Str("Voir aussi")})})
    local list = pandoc.BulletList(items)

    local div = pandoc.Div({heading, list}, {class = "voir-aussi"})

    table.insert(doc.blocks, div)
  end

  return doc
end
