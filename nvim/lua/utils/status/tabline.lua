local colors = require("utils.colors")
local colors_default = colors.default
local icons = require("utils.icons")
local statusline = require("utils.status.statusline")
local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local tabline_bufnr = {
  provider = function(self)
    return tostring(self.bufnr) .. ". "
  end,
  hl = colors_default.comment,
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local tabline_filename = {
  provider = function(self)
    -- self.filename will be defined later, just keep looking at the example!
    local filename = self.filename
    filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
    return filename
  end,
  hl = function(self)
    return { bold = self.is_active or self.is_visible, italic = true }
  end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
local tabline_fileflags = {
  {
    condition = function(self)
      return vim.api.nvim_buf_get_option(self.bufnr, "modified")
    end,
    provider = icons.GitAdd,
    hl = { fg = colors_default.green },
  },
  {
    condition = function(self)
      return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
        or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
    end,
    provider = function(self)
      if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
        return "  "
      else
        return icons.FileReadOnly
      end
    end,
    hl = { fg = colors_default.orange },
  },
}

-- Here the filename block finally comes together
local tabline_fileName_block = {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(self.bufnr)
  end,
  hl = function(self)
    if self.is_active then
      return "TabLineSel"
      -- why not?
      -- elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
      --     return { fg = "gray" }
    else
      return "TabLine"
    end
  end,
  on_click = {
    callback = function(_, minwid, _, button)
      if button == "m" then -- close on mouse middle click
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
        end)
      else
        vim.api.nvim_win_set_buf(0, minwid)
      end
    end,
    minwid = function(self)
      return self.bufnr
    end,
    name = "heirline_tabline_buffer_callback",
  },
  tabline_bufnr,
  statusline.file_icon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
  tabline_filename,
  tabline_fileflags,
}

-- a nice "x" button to close the buffer
local tabline_close_button = {
  condition = function(self)
    return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
  end,
  { provider = " " },
  {
    provider = icons.TabClose,
    hl = { fg = colors_default.comment },
    on_click = {
      callback = function(_, minwid)
        vim.schedule(function()
          vim.api.nvim_buf_delete(minwid, { force = false })
          vim.cmd.redrawtabline()
        end)
      end,
      minwid = function(self)
        return self.bufnr
      end,
      name = "heirline_tabline_close_buffer_callback",
    },
  },
}

-- The final touch!
local tabline_buffer_block = utils.surround({ "", "" }, function(self)
  if self.is_active then
    return utils.get_highlight("TabLineSel").bg
  else
    return utils.get_highlight("TabLine").bg
  end
end, { tabline_fileName_block, tabline_close_button })

-- and here we go
local buffer_line = utils.make_buflist(
  tabline_buffer_block,
  { provider = "", hl = { fg = colors_default.comment } }, -- left truncation, optional (defaults to "<")
  { provider = "", hl = { fg = colors_default.comment } } -- right trunctation, also optional (defaults to ...... yep, ">")
  -- by the way, open a lot of buffers and try clicking them ;)
)

return buffer_line
