function Image(element)
    return pandoc.Image(element.caption, element.src:gsub(".svg", ".png"))
end