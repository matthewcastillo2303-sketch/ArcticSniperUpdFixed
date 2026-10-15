-- ARCTIC SNIPER V2 — COMPACT OXIDE-INSPIRED FROST UI
-- UI and announcement-text parser. Text must be supplied/pasted; this does not read
-- arbitrary on-screen announcements or redeem codes in third-party games.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
if not player then return end
local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("ArcticSniperV2")
if old then old:Destroy() end

local C = {
 bg=Color3.fromRGB(3,9,19), panel=Color3.fromRGB(5,17,33), row=Color3.fromRGB(7,27,49),
 row2=Color3.fromRGB(10,39,66), blue=Color3.fromRGB(0,190,255), bright=Color3.fromRGB(93,224,255),
 white=Color3.fromRGB(239,250,255), muted=Color3.fromRGB(132,177,203), off=Color3.fromRGB(21,49,70)
}
local function make(class, props, parent)
 local o=Instance.new(class); for k,v in pairs(props or {}) do o[k]=v end; o.Parent=parent; return o
end
local function corner(o,r) make("UICorner",{CornerRadius=UDim.new(0,r or 10)},o) end
local function stroke(o,color,thick,trans)
 make("UIStroke",{Color=color or C.blue,Thickness=thick or 1,Transparency=trans or .1},o)
end
local function txt(parent,text,size,pos,fontSize,color,xalign)
 return make("TextLabel",{BackgroundTransparency=1,Text=text,Size=size,Position=pos,Font=Enum.Font.GothamSemibold,
 TextSize=fontSize or 11,TextColor3=color or C.white,TextXAlignment=xalign or Enum.TextXAlignment.Left,
 TextYAlignment=Enum.TextYAlignment.Center,TextWrapped=true},parent)
end
local function btn(parent,text,size,pos,fn,bg)
 local b=make("TextButton",{Size=size,Position=pos,BackgroundColor3=bg or C.row2,BorderSizePixel=0,
 Text=text,TextColor3=C.white,TextSize=10,Font=Enum.Font.GothamBold,AutoButtonColor=false},parent)
 corner(b,8); stroke(b,C.blue,1,.22)
 b.Activated:Connect(function() if fn then fn() end end)
 return b
end
local gui=make("ScreenGui",{Name="ArcticSniperV2",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=999},pg)
local main=make("Frame",{Name="Main",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),
 Size=UDim2.fromOffset(350,570),BackgroundColor3=C.bg,BorderSizePixel=0,Active=true},gui)
 corner(main,16); stroke(main,C.blue,1.6,.04)
 local scale=make("UIScale",{Scale=1},main)
 local preferredScale=0.8
 local function fit()
  local cam=workspace.CurrentCamera; if not cam then return end
  local v=cam.ViewportSize
  local viewportLimit=math.clamp(math.min((v.X-24)/350,(v.Y-30)/570,1),.48,1)
  scale.Scale=math.min(preferredScale,viewportLimit)
 end
 fit(); if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fit) end

-- Header: compact Oxide-inspired top strip, with frosty branding and snowflake accents.
local header=make("Frame",{Size=UDim2.new(1,0,0,66),BackgroundColor3=C.panel,BorderSizePixel=0,Active=true},main)
corner(header,15); make("Frame",{Size=UDim2.new(1,0,0,15),Position=UDim2.new(0,0,1,-15),BackgroundColor3=C.panel,BorderSizePixel=0},header)
local logo=make("Frame",{Size=UDim2.fromOffset(43,43),Position=UDim2.fromOffset(12,11),BackgroundColor3=C.row2,BorderSizePixel=0},header)
corner(logo,11); stroke(logo,C.bright,1.3)
txt(logo,"❄",UDim2.fromScale(1,1),UDim2.new(),25,C.bright,Enum.TextXAlignment.Center)
txt(header,"ARCTIC SNIPER",UDim2.new(0,175,0,24),UDim2.fromOffset(63,8),15,C.white)
txt(header,"V2 • FROST EDITION",UDim2.new(0,175,0,18),UDim2.fromOffset(64,31),9,C.bright)
local stats=make("Frame",{Size=UDim2.fromOffset(118,31),Position=UDim2.new(1,-163,0,17),BackgroundColor3=C.row,BorderSizePixel=0},header)
corner(stats,9); txt(stats,"FPS 58    |    PING 45",UDim2.fromScale(1,1),UDim2.new(),8,C.white,Enum.TextXAlignment.Center)
local mini
btn(header,"—",UDim2.fromOffset(28,29),UDim2.new(1,-37,0,18),function() main.Visible=false; if mini then mini.Visible=true end end,C.row2)

-- Dragging supports touch and mouse.
do
 local dragging=false; local startPoint; local startPos; local inputType
 header.InputBegan:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.Touch or i.UserInputType==Enum.UserInputType.MouseButton1 then
   dragging=true; startPoint=i.Position; startPos=main.Position; inputType=i.UserInputType
  end
 end)
 UIS.InputChanged:Connect(function(i)
  if not dragging then return end
  if (inputType==Enum.UserInputType.Touch and i.UserInputType==Enum.UserInputType.Touch) or
   (inputType==Enum.UserInputType.MouseButton1 and i.UserInputType==Enum.UserInputType.MouseMovement) then
   local d=i.Position-startPoint
   main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
  end
 end)
 UIS.InputEnded:Connect(function(i)
  if (inputType==Enum.UserInputType.Touch and i.UserInputType==Enum.UserInputType.Touch) or
   (inputType==Enum.UserInputType.MouseButton1 and i.UserInputType==Enum.UserInputType.MouseButton1) then dragging=false; inputType=nil end
 end)
end
mini=btn(gui,"❄",UDim2.fromOffset(48,48),UDim2.new(0,18,.5,-24),function() main.Visible=true; mini.Visible=false end,C.panel)
mini.Visible=false; corner(mini,24); stroke(mini,C.bright,1.5)

local body=make("Frame",{Name="Body",Size=UDim2.new(1,-20,1,-78),Position=UDim2.fromOffset(10,72),BackgroundTransparency=1},main)
local layout=make("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},body)
local function card(height)
 local f=make("Frame",{Size=UDim2.new(1,0,0,height),BackgroundColor3=C.panel,BorderSizePixel=0},body)
 corner(f,12); stroke(f,C.blue,1,.18); return f
end

-- Code banner and sniped-code preview
local codeRow = card(38)

local codeRowText = txt(
    codeRow,
    "▤  CODE BUFFER: EMPTY",
    UDim2.new(1, -48, 1, 0),
    UDim2.fromOffset(13, 0),
    10,
    C.white
)

local code = card(96)

-- Announcement parser: processes text supplied by an authorized source or pasted by the user.
local function extractAnnouncedCode(text)
    if typeof(text) ~= "string" then return nil end
    local lower = string.lower(text)
    local startAt, phraseEnd = lower:find("use%s+code")
    if not startAt then startAt, phraseEnd = lower:find("the%s+code%s+is") end
    if not startAt then return nil end
    local remainder = text:sub(phraseEnd + 1):gsub("^%s*[:%-]?%s*", "")
    remainder = remainder:gsub("[%s%.!?,;]+$", "")
    if remainder == "" then return nil end
    return remainder
end

txt(
    code,
    "SNIPED CODE",
    UDim2.new(1, -95, 0, 18),
    UDim2.fromOffset(10, 8),
    9,
    C.bright,
    Enum.TextXAlignment.Center
)

local codeValue = txt(
    code,
    "",
    UDim2.new(1, -26, 0, 31),
    UDim2.fromOffset(13, 30),
    20,
    C.white,
    Enum.TextXAlignment.Center
)

local status = make("TextLabel", {
    Size = UDim2.fromOffset(108, 22),
    Position = UDim2.new(0.5, -54, 1, -29),
    BackgroundColor3 = C.row2,
    BorderSizePixel = 0,
    Text = "❄  WAITING",
    TextColor3 = C.bright,
    TextSize = 9,
    Font = Enum.Font.GothamBold
}, code)

corner(status, 11)
stroke(status, C.blue, 1, 0.2)

local function clearCode()
    codeValue.Text = ""
    codeRowText.Text = "▤  CODE BUFFER: EMPTY"
    status.Text = "❄  CLEARED"
end

local function processAnnouncementText(text)
    local found = extractAnnouncedCode(text)
    if not found then
        status.Text = "❄  NO CODE FOUND"
        return false
    end
    codeValue.Text = found
    codeRowText.Text = "▤  CODE BUFFER: CODE FOUND"
    status.Text = "❄  CODE CAPTURED"
    return true
end

local announcementInput = make("TextBox", {
    Name = "AnnouncementTextInput",
    Size = UDim2.new(1, -20, 0, 28),
    Position = UDim2.new(0, 10, 1, -36),
    BackgroundColor3 = C.row,
    BorderSizePixel = 0,
    Text = "",
    PlaceholderText = "Paste announcement text here",
    PlaceholderColor3 = C.muted,
    TextColor3 = C.white,
    TextSize = 10,
    Font = Enum.Font.Gotham,
    ClearTextOnFocus = false
}, code)
corner(announcementInput, 7)
stroke(announcementInput, C.blue, 1, .35)
announcementInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and announcementInput.Text ~= "" then
        processAnnouncementText(announcementInput.Text)
        announcementInput.Text = ""
    end
end)

btn(
    code,
    "RESET",
    UDim2.fromOffset(62, 25),
    UDim2.new(1, -73, 0, 8),
    clearCode,
    C.row2
)


local function toggleRow(title,subtitle,initial)
 local r=card(44)
 txt(r,"❄",UDim2.fromOffset(22,30),UDim2.fromOffset(8,7),17,C.bright,Enum.TextXAlignment.Center)
 txt(r,title,UDim.new(1,-100,0,18),UDim2.fromOffset(34,4),10,C.white)
 txt(r,subtitle,UDim.new(1,-100,0,14),UDim2.fromOffset(34,22),8,C.muted)
 local on=initial==true
 local track=make("TextButton",{Size=UDim2.fromOffset(46,24),Position=UDim2.new(1,-58,.5,-12),BackgroundColor3=on and C.blue or C.off,BorderSizePixel=0,Text="",AutoButtonColor=false},r)
 corner(track,14)
 local knob=make("Frame",{Size=UDim2.fromOffset(16,16),Position=on and UDim2.new(1,-20,.5,-8) or UDim2.fromOffset(4,4),BackgroundColor3=C.white,BorderSizePixel=0},track); corner(knob,10)
 track.Activated:Connect(function()
  on=not on; track.BackgroundColor3=on and C.blue or C.off
  TweenService:Create(knob,TweenInfo.new(.12),{Position=on and UDim2.new(1,-20,.5,-8) or UDim2.fromOffset(4,4)}):Play()
 end)
end
toggleRow("scan announcements","demo toggle • sample code notices",true)
toggleRow("auto scope","demo toggle • phrase detection preview",true)
toggleRow("spam redeem","visual toggle only • no redemption",false)
toggleRow("hide user","visual toggle only • no webhook",false)

local function optionRow(title,subtitle,values,default,onChange)
 local r=card(44)
 txt(r,"❄",UDim2.fromOffset(22,30),UDim2.fromOffset(8,7),17,C.bright,Enum.TextXAlignment.Center)
 txt(r,title,UDim.new(.43,0,0,18),UDim2.fromOffset(34,4),10,C.white)
 txt(r,subtitle,UDim.new(.43,0,0,14),UDim2.fromOffset(34,22),8,C.muted)
 local holder=make("Frame",{Size=UDim2.new(.53,-8,0,28),Position=UDim2.new(.46,0,.5,-14),BackgroundColor3=C.row,BorderSizePixel=0},r); corner(holder,8)
 local selected=default
 for i,v in ipairs(values) do
  local w=1/#values
  local b=make("TextButton",{Size=UDim2.new(w,-2,1,-4),Position=UDim2.new((i-1)*w,1,0,2),BackgroundColor3=v==selected and C.blue or C.row,BorderSizePixel=0,Text=tostring(v),TextColor3=C.white,TextSize=9,Font=Enum.Font.GothamBold,AutoButtonColor=false},holder)
  corner(b,6); b.Activated:Connect(function()
   selected=v
   for _,x in ipairs(holder:GetChildren()) do
    if x:IsA("TextButton") then x.BackgroundColor3=x.Text==tostring(selected) and C.blue or C.row end
   end
   if onChange then onChange(v) end
  end)
 end
end
optionRow("auto submit","preview count per code",{1,2,3,4,5},5)
optionRow("ui scale","visual size preset",{60,70,80,90,100},80,function(v)
 preferredScale=v/100
 fit()
end)

local footer=make("Frame",{Size=UDim2.new(1,0,0,46),BackgroundTransparency=1},body)
local footLayout=make("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},footer)
local function foot(title,sub,icon,fn)
 local b=make("TextButton",{Size=UDim2.new(1/3,-5,1,0),BackgroundColor3=C.row,BorderSizePixel=0,Text="",AutoButtonColor=false},footer)
 corner(b,10); stroke(b,C.blue,1,.2)
 txt(b,icon,UDim2.fromOffset(22,25),UDim2.fromOffset(7,7),14,C.bright,Enum.TextXAlignment.Center)
 txt(b,title,UDim.new(1,-33,0,18),UDim2.fromOffset(31,4),9,C.white)
 txt(b,sub,UDim.new(1,-33,0,14),UDim2.fromOffset(31,21),7,C.muted)
 b.Activated:Connect(function() if fn then fn() end end)
end

foot("CLEAR BOX", "clear code", "—", clearCode)

foot("RESET", "clear buffer", "⟳", function()
    clearCode()
    status.Text = "❄  SETTINGS RESET"
end)

-- Subtle decorative snowflakes, purely visual.
for i=1,7 do
 local flake=txt(main,"❄",UDim2.fromOffset(16,16),UDim2.new((i*13%90)/100,0,(i*19%88)/100,0),11,C.bright,Enum.TextXAlignment.Center)
 flake.TextTransparency=.35
end
