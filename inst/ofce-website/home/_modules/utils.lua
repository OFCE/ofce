-- Utils - Fonctions utilitaires utilisées dans les shortcodes Quarto

local utils = {}

--- Échape les caractères HTML spéciaux (& < > ") dans une chaîne de caractères
--- @param text string|nil La chaîne de caractère à échapper
--- @return string La chaîne échappée (chaîne vide si text est nil ou vide)
function utils.html_escape(text)
    if not text then return "" end
    text = string.gsub(text, "&", "&amp;")
    text = string.gsub(text, "<", "&lt;")
    text = string.gsub(text, ">", "&gt;")
    text = string.gsub(text, '"', "&quot;")
    return text
end

return utils
