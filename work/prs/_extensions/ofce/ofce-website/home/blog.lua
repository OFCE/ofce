
local utils = require(
    quarto.utils.resolve_path("_modules/utils.lua"):gsub("%.lua$", "")
)

local function create_blog_item(item)
    local url = utils.html_escape(pandoc.utils.stringify(item.url or item[1] or "#"))
    local image = utils.html_escape(pandoc.utils.stringify(item.image or item[2] or ""))
    local title = utils.html_escape(pandoc.utils.stringify(item.title or item[3] or ""))
    local author = utils.html_escape(pandoc.utils.stringify(item.author or item[4] or ""))
    
    local image_html = ""
    if image and image ~= "" then
        image_html = string.format([[
            <div class="blog-listing__image">
                <img src="%s" />
            </div>
        ]], image)
    end

    local html = string.format([[
        <a href="%s" class="blog-listing__item">
            %s
            <div class="blog-listing__content">
                <h4>%s</h4>
                <p>%s</p>
                <div class="blog-listing__footer">
                    <span>Lire la suite</span>
                </div>
            </div>
        </a>
    ]], url, image_html, title, author)

    return html
end

local function read_blog_items(filepath)
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

return {
    ['blog'] = function(args, kwargs, meta)
        local blog_data = meta["extensions.ofce-website.blog"]

        if not blog_data then
            return pandoc.Str("")
        end

        local source_path = pandoc.utils.stringify(blog_data)
        local items = read_blog_items(source_path)

        local items_html = ""
        for i, item in ipairs(items) do
            items_html = items_html .. create_blog_item(item)
        end

        local html = string.format([[
            <section class="section">
                <div class="container">
                    <div class="d-flex justify-content-between align-items-start">
                        <a href="/blog2024" class="section-header">
                            <div class="section-header-title-line"></div>
                            <h2 class="section-header-title">LE BLOG</h2>
                        </a>
                        <a href="/blog2024" class="section-header-link">
                            <span>Tous les articles</span>
                            <span class="section-header-link-arrow">→</span>
                        </a>
                    </div>
                    
                    <div class="blog-listing">
                        %s
                    </div>
                </div>
            </section>
        ]], items_html)

        return pandoc.RawBlock('html', html)
    end
}
