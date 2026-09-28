
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

local function to_str(val)
    if val == nil then return "" end
    if type(val) == "string" then return val end
    return pandoc.utils.stringify(val)
end

local function create_focus_item(item)
    local url = utils.html_escape(to_str(item.url or item[1] or "#"))
    local category = utils.html_escape(to_str(item.category or item[2] or ""))
    local title = utils.html_escape(to_str(item.title or item[3] or ""))
    local subtitle = utils.html_escape(to_str(item.subtitle or item[4] or ""))
    local color = to_str(item.color or item[5] or "green")

    local color_class = "focus__item--" .. color

    local html = string.format([[
        <a href="%s" class="focus__item %s">
            <span class="focus__category">%s</span>
            <h3 class="focus__title">%s</h3>
            <p class="focus__subtitle">%s</p>
        </a>
    ]], url, color_class, category, title, subtitle)

    return html
end

return {
  ['focus'] = function(args, kwargs, meta) 
    -- see https://quarto.org/docs/extensions/shortcodes.html
    -- for documentation on shortcode development
    local focus_data = meta["extensions.ofce-website.focus"]

    if not focus_data then
        return pandoc.Str("")
    end

    local title = "FOCUS"
    local items = {}

    if focus_data.items then
        local filepath = pandoc.utils.stringify(focus_data.items)
        if filepath:match("%.json$") then
            items = read_items_from_json(filepath)
        else
            for i, item in ipairs(focus_data.items) do
                table.insert(items, {
                    url = item.url,
                    category = item.category,
                    title = item.title,
                    subtitle = item.subtitle,
                    color = item.color
                })
            end
        end
    end

    local items_html = ""
    for i, item in ipairs(items) do
        items_html = items_html .. create_focus_item(item)
    end

    local html = string.format([[
        <section class="section">
            <div class="container">
                <div class="section-header">
                    <div class="section-header-title-line"></div>
                    <h2 class="section-header-title">%s</h2>
                </div>
                <div class="focus">
                    %s
                </div>
            </div>
        </section>
    ]], title, items_html)

    return pandoc.RawBlock('html', html)
  end
}
