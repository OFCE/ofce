-- Lua filter to extract year from date

function Meta(meta)
  if meta.date then
    local date_str = pandoc.utils.stringify(meta.date)
    local year = date_str:match("^(%d%d%d%d)")
    if year then
      meta.year = year
    end
  end
  return meta
end
