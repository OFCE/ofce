
function match_comment(block)
  for k, v in pairs(block) do
    if v.t == "RawBlock" then 
      if string.match(v.text, "^<!%-%-#") then
          return(k)
        end
    end 
  end
  return(nil)
end


function remove_comment(block)
  if FORMAT:match 'html' or FORMAT:match 'html5' then
    quarto.log.debug("------- block")
    for k, v in pairs(block) do
      if v.t == "RawBlock" then 
        if string.match(v.text, "^<!%-%-#") then
            quarto.log.debug(v.text)
            block[k].text = string.gsub(block[k].text, "^<!%-%-#", "<!-- #")
            --block:remove(k)
        end
      end
    end
  --if k then
  --  quarto.log.debug("------- comment detected", k)
  --  quarto.log.debug(block[k])
    --block[k].text = string.gsub(block[k].text, "^<!%-%-#", "<!-- #")
  --  block:remove(k)
  -- end
    return(block)
  end
  return(block)
end

function remove_comment_inline(inline)
  if quarto.doc.is_format("html") then
    quarto.log.debug("------- inline")
    for k, v in pairs(inline) do
      if(v.t == "RawInline") then
        quarto.log.debug(v.text)
        v.text = string.gsub(v.text, "^<!%-%-#", "<!-- #")
        end
      end
    return(inline)
  end
  return(inline)
end

return {
  { Blocks = remove_comment,
    Inlines = remove_comment_inline}
}