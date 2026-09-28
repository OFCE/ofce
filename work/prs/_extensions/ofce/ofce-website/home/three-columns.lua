local utils = require(
    quarto.utils.resolve_path("_modules/utils.lua"):gsub("%.lua$", "")
)

local function read_items_from_json(filepath)
    local paths = { filepath }
    if not (filepath:match("^/") or filepath:match("^%a:")) then
        local cwd = (pandoc.system and pandoc.system.get_working_directory and pandoc.system.get_working_directory()) or "."
        table.insert(paths, 1, (quarto.project and quarto.project.directory or cwd) .. "/" .. filepath)
        table.insert(paths, cwd .. "/" .. filepath)
    end
    local content = nil
    for _, path in ipairs(paths) do
        local file = io.open(path, "r")
        if file then
            content = file:read("*all")
            file:close()
            break
        end
    end
    if not content or content == "" then return {} end
    local ok, data = pcall(quarto.json.decode, content)
    if not ok or not data or not data.items then return {} end
    return data.items
end

-- Gère les valeurs Pandoc (MetaInlines, etc.) ET les strings Lua natifs (JSON)
local function to_str(val)
    if val == nil then return "" end
    if type(val) == "string" then return val end
    return pandoc.utils.stringify(val)
end

local function create_three_columns_item(item)
    local url = utils.html_escape(to_str(item.url or item[1] or "#"))
    local header = utils.html_escape(to_str(item.header or item[2] or ""))
    local title = utils.html_escape(to_str(item.title or item[3] or ""))
    -- La description peut contenir du HTML, donc on ne l'échappe pas
    local description = to_str(item.description or item[4] or "")

    local html = string.format([[
        <a href="%s" class="three-columns-item">
            <span class="three-columns-item-header">%s</span>
            <h4 class="three-columns-item-title">%s</h4>
            <p class="three-columns-item-description">%s</p>
        </a>
    ]], url, header, title, description)

    return html
end

local function create_three_columns_column(column)
    local column_title = utils.html_escape(to_str(column.title or ""))
    local items = {}

    if column.items then
        -- Stringify pour détecter si items est un chemin de fichier JSON
        local filepath = pandoc.utils.stringify(column.items)
        if filepath:match("%.json$") then
            items = read_items_from_json(filepath)
        else
            for i, item in ipairs(column.items) do
                table.insert(items, {
                    url = item.url,
                    header = item.header,
                    title = item.title,
                    description = item.description
                })
            end
        end
    end

    local items_html = ""
    for i, item in ipairs(items) do
        items_html = items_html .. create_three_columns_item(item)
    end

    local html = string.format([[
        <div class="three-columns-column">
            <h3 class="three-columns-column-title">%s</h3>
            <div class="three-columns-list">
                %s
            </div>
        </div>
    ]], column_title, items_html)

    return html
end

return {
    ['three-columns'] = function(args, kwargs, meta) 
        -- see https://quarto.org/docs/extensions/shortcodes.html
        -- for documentation on shortcode development
        local three_columns_data = meta["extensions.ofce-website.three-columns"]
    
        if not three_columns_data then
            return pandoc.Str("")
        end
    
        local columns = {}
    
        if three_columns_data.columns then
            for i, column in ipairs(three_columns_data.columns) do
                table.insert(columns, {
                    title = column.title,
                    items = column.items
                })
            end
        end
    
        local columns_html = ""
        for i, column in ipairs(columns) do
            columns_html = columns_html .. create_three_columns_column(column)
        end
    
        local html = string.format([[
            <section class="section">
                <div class="container">
                    <div class="three-columns-grid">
                        %s
                    </div>
                </div>
            </section>
        ]], columns_html)
    
        return pandoc.RawBlock('html', html)
    end
}
