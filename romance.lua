local introText = "You see a beautiful woman. "
local positiveText = "She smiles brightly at you!"
local neutralText = "She ignores you."
local negativeText = "She sneers at you."
local endText = "You walk away, and wonder what could have been..."

local maxFeeling = 3
local minFeeling = -3

function GiveFlower(d)
    if not d.context.feeling then
        d.context.feeling = 1
    else
        d.context.feeling = math.min(d.context.feeling + 1, maxFeeling)
    end
end

function GiveFrog(d)
    if not d.context.feeling then
        d.context.feeling = -1
    else
        d.context.feeling = math.max(d.context.feeling - 1, minFeeling)
    end
end

function ShowResult(d)
    local feelingText = ""
    
    if d.context.feeling > 2 then
        feelingText = positiveText
    elseif not d.context.feeling or d.context.feeling > -1 then
        feelingText = neutralText
    else
        feelingText = negativeText
    end

    return {type="text", next="intro", text=feelingText}
end

local introChoices={
    {text="Give her a flower", next="flower"},
    {text="Give her a frog", next="frog"},
    {text="Walk away", next="finished"}
}

local data = 
{
    start="intro",
    intro={type="choice", text=introText, choices=introChoices},
    flower={type="function", func=GiveFlower, next="result"},
    frog={type="function", func=GiveFrog, next="result"},
    result={type="function", func=ShowResult},
    finished={type="text", text=endText}
}

return data