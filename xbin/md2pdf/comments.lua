--[[
comments – strip %%%- ... -%%%
]]
local stringify_orig = (require 'pandoc.utils').stringify

local function stringify(x)
  return type(x) == 'string' and x or stringify_orig(x)
end

local function trimLeft(s)
    return (s:gsub("^(.-)%s*$", "%1"))
 end

pandoc.in_comment = 0;

-- Filter function called on each Block element.
function Block1 (el)
    if el.c == nil then
      return nil
    end  
    -- print ('block1 ' .. pandoc.in_comment .. ' type=' .. el.t .." ".. trimLeft(string.sub(stringify(el.c),1,30)).."...")
    if (pandoc.in_comment == 0) and (#el.c > 1) and (el.c[1].text == '%%%-') and (el.c[#el.c].text == '-%%%') then
      return pandoc.Null(), false
    end
    return nil
end
function Block2 (el)
    if el.c == nil then
      return nil
    end  
    if (pandoc.in_comment == 0) and (#el.c > 1) and (el.c[1].text == '%%%-') and (el.c[#el.c].text == '-%%%') then
      return pandoc.Null(), false
    end
    -- print ('block2 ' .. pandoc.in_comment .. ' type=' .. el.t .." ".. trimLeft(string.sub(stringify(el.c),1,30)).."...")
    if (#el.c >= 1) and (el.c[1].text == '%%%-') then
      pandoc.in_comment = pandoc.in_comment + 1
  --    print ('comment ' .. pandoc.in_comment)
      return pandoc.Null(), false
    end
    if (pandoc.in_comment > 0) and (#el.c >= 1) and (el.c[#el.c].text == '-%%%') then
      pandoc.in_comment = pandoc.in_comment - 1
  --    print ('comment ' .. pandoc.in_comment)
      return pandoc.Null(), false
    end
    if (pandoc.in_comment > 0) and (#el.c >= 1) then
      return pandoc.Para(trimLeft(string.sub(stringify(el.c[1]),1,10)).."... TBD."), false
    end
    if (pandoc.in_comment > 0) then
  --    print ('check comment ' .. pandoc.in_comment)
      return pandoc.Null(), false
    end
    -- otherwise, leave the block unchanged
    return nil
end
    
function Check (el)

  if el.c == nil then
    return nil
  end  
  
  -- print ('check comment ' .. pandoc.in_comment .. ' type=' .. el.t .." ".. trimLeft(string.sub(stringify(el.c),1,30)).."...")

  if (pandoc.in_comment > 0) and (#el.c >= 1) then
    return pandoc.Para(trimLeft(string.sub(stringify(el.c[1]),1,5)).."... TBD."), false
  end
  if (pandoc.in_comment > 0) then
  return pandoc.Null(), false
  end
  -- otherwise, leave the block unchanged
  return nil
end

function Pandoc(doc)
    local hblocks = {}
    for i,el in pairs(doc.blocks) do
        -- print ("debug-pandoc ".. i .." t=".. el.t .. "")

        if ( el.t == 'Table') and (pandoc.in_comment > 0) then
            -- ignore
        else
            local repl = Block1(el)

            if (repl == nil) then
                repl = Block2(el)
                if (repl == nil) then
                    table.insert(hblocks, el)
                else
                    table.insert(hblocks, repl)
                end
            else
                table.insert(hblocks, el)
            end
        end
    end
    return pandoc.Pandoc(hblocks, doc.meta)
end

return {
    {
        Pandoc = Pandoc
    }
}
    
