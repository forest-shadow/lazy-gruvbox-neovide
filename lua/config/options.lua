-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.spell = true
vim.opt.spelllang = { "ru", "en" }
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "winpos",
  "terminal",
  "localoptions",
}
vim.opt.guifont = "FiraCode Nerd Font Mono:h14"

vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.updatetime = 500
vim.opt.updatecount = 50

-- langmap transforms russian layout chars to nvim commands
local function escape_langmap_char(ch)
  if ch == "," or ch == ";" or ch == "\\" then
    return "\\" .. ch
  end

  return ch
end

local function lm(from, to)
  return escape_langmap_char(from) .. escape_langmap_char(to)
end

vim.opt.langmap = table.concat({
  -- lower case
  lm("й", "q"),
  lm("ц", "w"),
  lm("у", "e"),
  lm("к", "r"),
  lm("е", "t"),
  lm("н", "y"),
  lm("г", "u"),
  lm("ш", "i"),
  lm("щ", "o"),
  lm("з", "p"),
  lm("х", "["),
  lm("ъ", "]"),

  lm("ф", "a"),
  lm("ы", "s"),
  lm("в", "d"),
  lm("а", "f"),
  lm("п", "g"),
  lm("р", "h"),
  lm("о", "j"),
  lm("л", "k"),
  lm("д", "l"),
  lm("ж", ";"),
  lm("э", "'"),

  lm("я", "z"),
  lm("ч", "x"),
  lm("с", "c"),
  lm("м", "v"),
  lm("и", "b"),
  lm("т", "n"),
  lm("ь", "m"),
  lm("б", ","),
  lm("ю", "."),
  lm(".", "/"),

  -- upper case
  lm("Й", "Q"),
  lm("Ц", "W"),
  lm("У", "E"),
  lm("К", "R"),
  lm("Е", "T"),
  lm("Н", "Y"),
  lm("Г", "U"),
  lm("Ш", "I"),
  lm("Щ", "O"),
  lm("З", "P"),
  lm("Х", "{"),
  lm("Ъ", "}"),

  lm("Ф", "A"),
  lm("Ы", "S"),
  lm("В", "D"),
  lm("А", "F"),
  lm("П", "G"),
  lm("Р", "H"),
  lm("О", "J"),
  lm("Л", "K"),
  lm("Д", "L"),
  lm("Ж", ":"),
  lm("Э", '"'),

  lm("Я", "Z"),
  lm("Ч", "X"),
  lm("С", "C"),
  lm("М", "V"),
  lm("И", "B"),
  lm("Т", "N"),
  lm("Ь", "M"),
  lm("Б", "<"),
  lm("Ю", ">"),
  lm(",", "?"),

  lm("ё", "`"),
  lm("Ё", "~"),
}, ",")