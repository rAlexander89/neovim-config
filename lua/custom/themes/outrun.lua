local M = {}

M.base_30 = {
  darker_black = "#090819",
  black = "#0c0a20",
  black2 = "#0f0c23",
  white = "#f2f3f7",

  -- Required additional base colors
  one_bg = "#131033",
  one_bg2 = "#1c1940",
  one_bg3 = "#24214d",
  grey = "#484f7d",
  grey_fg = "#545aa3",
  grey_fg2 = "#6164ad",
  light_grey = "#7984D1",
  red = "#ff2e97",
  baby_pink = "#ff2afc",
  pink = "#ff2afc",
  line = "#24214d",
  green = "#42c6ff",
  vibrant_green = "#42c6ff",
  nord_blue = "#1ea8fc",
  blue = "#62dfff",
  -- blue = "#ffffff",
  yellow = "#ffe566",
  sun = "#ffd400",
  purple = "#df85ff",
  dark_purple = "#A875FF",
  teal = "#42c6ff",
  orange = "#ff9b50",
  cyan = "#42c6ff",
  statusline_bg = "#131033",
  lightbg = "#1c1940",
  pmenu_bg = "#62d1ee",
  folder_bg = "#51dbff",
}

M.base_16 = {
  base00 = "#140b21",
  -- base00 = "#160b24",
  -- base00 = "#0c0a20",
  base01 = "#131033",
  base02 = "#1c1940",
  base03 = "#24214d",
  base04 = "#484f7d",
  base05 = "#f2f3f7",
  base06 = "#f8f8f2",
  base07 = "#ffffff",
  base08 = "#f8f8f2", -- struct fields
  base09 = "#ffd094", -- return type nil and such??
  base0A = "#ff70ba", -- struct data types
  base0B = "#9ae8e9", -- strings
  base0C = "#42c6ff",
  base0D = "#ff99ce", -- keywords?
  base0E = "#df85ff",
  base0F = "#ffe566"  -- grouping stuff
}

M.type = "dark"

return M
