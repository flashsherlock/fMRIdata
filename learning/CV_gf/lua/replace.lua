
function Block(el)
    if el.t == "Para" or el.t == "Plain" then
        for k, _ in ipairs(el.content) do

            if el.content[k].t == "Str" and el.content[k].text == "(n.d.)." and
                el.content[k + 1].t == "Space" then
                    
                el.content[k] = pandoc.Str("(in preparation).")

            end

        end
    end
    return el
end