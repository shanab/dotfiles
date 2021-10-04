-- Install packer
local install_path =
	vim.fn.stdpath(
		"data"
	) .. "/site/pack/packer/start/packer.nvim"

if
	vim.fn.empty(
		vim.fn.glob(
			install_path
		)
	)
	> 0
then
	vim.fn.execute(
		"!git clone https://github.com/wbthomason/packer.nvim "
			.. install_path
	)
end

vim.api.nvim_exec(
	[[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]],
	false
)

local use =
	require(
		"packer"
	).use
require(
	"packer"
).startup(
	function(


	)
		use(
			"wbthomason/packer.nvim"
		) -- Package manager
		use(
			"tpope/vim-fugitive"
		) -- Git commands in nvim
		use(
			"tpope/vim-rhubarb"
		) -- Fugitive-companion to interact with github
		use(
			"tpope/vim-commentary"
		) -- "gc" to comment visual regions/lines
		use(
			"joshdick/onedark.vim"
		) -- Theme inspired by Atom
		use(
			"itchyny/lightline.vim"
		) -- Fancier statusline
		-- Add indentation guides even on blank lines
		use(
			"lukas-reineke/indent-blankline.nvim"
		)
		-- Add git related info in the signs columns and popups
		use({
			"lewis6991/gitsigns.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
			},
		})
		-- Highlight, edit, and navigate code using a fast incremental parsing library
		use(
			"nvim-treesitter/nvim-treesitter"
		)
		-- Additional textobjects for treesitter
		use(
			"nvim-treesitter/nvim-treesitter-textobjects"
		)
		use({
			"neovim/nvim-lspconfig",
			requires = {
				{
					"folke/todo-comments.nvim",
					config = function(


					)
						require(
							"todo-comments"
						).setup({})
					end,
				},
				{
					"tami5/lspsaga.nvim",
					config = function(


					)
						require(
							"lspsaga"
						).init_lsp_saga({})
					end,
				},
				{
					"ray-x/lsp_signature.nvim",
				},
			},
		}) -- Collection of configurations for built-in LSP client
		use(
			"hrsh7th/nvim-cmp"
		) -- Autocompletion plugin
		use(
			"hrsh7th/cmp-nvim-lsp"
		)
		use(
			"saadparwaiz1/cmp_luasnip"
		)
		use(
			"L3MON4D3/LuaSnip"
		) -- Snippets plugin
		use(
			"mhartington/formatter.nvim"
		) -- Code formatter

		use({
			"mhinz/vim-startify",
			event = "BufEnter",
			config = {},
		})

		use({
			"kyazdani42/nvim-tree.lua",
			requires = "kyazdani42/nvim-web-devicons",
			config = function(


			)
				require(
					"nvim-tree"
				).setup({
					auto_close = true,
					view = {
						auto_resize = true,
					},
				})
			end,
		}) -- Folder navigation

		use({
			"christoomey/vim-tmux-navigator",
			opt = true,
			cond = function(

			)
				return vim.env.TMUX
					~= nil
			end,
			config = function(

			)
				if
					vim.fn.exists("g:loaded_tmux_navigator")
					== 0
				then
					vim.g.tmux_navigator_disable_when_zoomed =
						1
				end
			end,
		})

		use({
			"junegunn/fzf.vim",
			-- I have the bin globally, so don't build, and just grab plugin directory
			requires = {
				{
					"https://github.com/junegunn/fzf",
				},
			},
		}) -- File search and ctrlP replacement
	end
)

--Incremental live completion (note: this is now a default on master)
vim.o.inccommand =
	"nosplit"

--Set highlight on search
vim.o.hlsearch =
	false

--Make line numbers default
vim.wo.number =
	true

--Do not save when switching buffers (note: this is now a default on master)
vim.o.hidden =
	true

--Enable mouse mode
vim.o.mouse =
	"a"

--Enable break indent
vim.o.breakindent =
	true

-- Disable swap files
vim.o.swapfile =
	false

--Save undo history
vim.opt.undofile =
	true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase =
	true
vim.o.smartcase =
	true

-- spaces per tab
vim.opt.tabstop =
	2
vim.opt.softtabstop =
	2

-- spaces per tab (when shifting)
vim.opt.shiftwidth =
	2

--Decrease update time
vim.o.updatetime =
	250
vim.wo.signcolumn =
	"yes"

--Set colorscheme (order is important here)
vim.o.termguicolors =
	true
vim.g.onedark_terminal_italics =
	2
vim.cmd(
	[[colorscheme onedark]]
)

-- NvimTree setup
vim.g.nvim_tree_indent_markers =
	1
vim.g.nvim_tree_show_icons =
	{
		git = 1,
		folders = 0,
		files = 0,
		folder_arrows = 0,
	}

-- Normally README.md gets highlighted by default. Stopping that.
vim.g.nvim_tree_special_files =
	{}

--Set statusbar
vim.g.lightline =
	{
		colorscheme = "onedark",
		active = {
			left = {
				{
					"mode",
					"paste",
				},
				{
					"gitbranch",
					"readonly",
					"filename",
					"modified",
				},
			},
		},
		component_function = {
			gitbranch = "fugitive#head",
		},
	}

--Remap space as leader key
vim.api.nvim_set_keymap(
	"",
	"<Space>",
	"<Nop>",
	{
		noremap = true,
		silent = true,
	}
)
vim.g.mapleader =
	" "
vim.g.maplocalleader =
	" "

--Remap for dealing with word wrap
vim.api.nvim_set_keymap(
	"n",
	"k",
	"v:count == 0 ? 'gk' : 'k'",
	{
		noremap = true,
		expr = true,
		silent = true,
	}
)
vim.api.nvim_set_keymap(
	"n",
	"j",
	"v:count == 0 ? 'gj' : 'j'",
	{
		noremap = true,
		expr = true,
		silent = true,
	}
)

-- Highlight on yank
vim.api.nvim_exec(
	[[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]],
	false
)

-- Y yank until the end of line  (note: this is now a default on master)
vim.api.nvim_set_keymap(
	"n",
	"Y",
	"y$",
	{
		noremap = true,
	}
)

--Map blankline
vim.g.indent_blankline_char =
	"┊"
vim.g.indent_blankline_filetype_exclude =
	{
		"help",
		"packer",
	}
vim.g.indent_blankline_buftype_exclude =
	{
		"terminal",
		"nofile",
	}
vim.g.indent_blankline_char_highlight =
	"LineNr"
vim.g.indent_blankline_show_trailing_blankline_indent =
	false

-- Gitsigns
require(
	"gitsigns"
).setup({
	signs = {
		add = {
			hl = "GitGutterAdd",
			text = "+",
		},
		change = {
			hl = "GitGutterChange",
			text = "~",
		},
		delete = {
			hl = "GitGutterDelete",
			text = "_",
		},
		topdelete = {
			hl = "GitGutterDelete",
			text = "‾",
		},
		changedelete = {
			hl = "GitGutterChange",
			text = "~",
		},
	},
})

--Productivity shortcuts
vim.api.nvim_set_keymap(
	"n",
	"<leader>w",
	":w!<cr>",
	{
		noremap = true,
		silent = true,
	}
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>q",
	":q!<cr>",
	{
		noremap = true,
		silent = true,
	}
)
vim.api.nvim_set_keymap(
	"i",
	"jj",
	"<Esc>",
	{
		noremap = true,
		silent = true,
	}
)
-- Better split switching
local navchars =
	{
		"h",
		"j",
		"k",
		"l",
	}
for _, nav in pairs(
	navchars
) do
	vim.api.nvim_set_keymap(
		"n",
		"<C-"
			.. nav
			.. ">",
		"<C-W>"
			.. nav,
		{
			silent = true,
			noremap = true,
		}
	)
end

-- NvimTree shortcut
vim.api.nvim_set_keymap(
	"n",
	"<leader>n",
	":NvimTreeFindFile<cr>",
	{
		silent = true,
		noremap = true,
	}
)

-- Fzf shortcuts
vim.api.nvim_set_keymap(
	"n",
	"<leader><leader>",
	":Files<cr>",
	{
		silent = true,
		noremap = true,
	}
)

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require(
	"nvim-treesitter.configs"
).setup({
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})

-- LSP settings
local nvim_lsp =
	require(
		"lspconfig"
	)
local on_attach =
	function(
		_,
		bufnr
	)
		vim.api.nvim_buf_set_option(
			bufnr,
			"omnifunc",
			"v:lua.vim.lsp.omnifunc"
		)

		local opts =
			{
				noremap = true,
				silent = true,
			}
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"gD",
			"<Cmd>lua vim.lsp.buf.declaration()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"gd",
			"<Cmd>lua vim.lsp.buf.definition()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"K",
			"<Cmd>lua vim.lsp.buf.hover()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"gi",
			"<cmd>lua vim.lsp.buf.implementation()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<C-k>",
			"<cmd>lua vim.lsp.buf.signature_help()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>wa",
			"<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>wr",
			"<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>wl",
			"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>D",
			"<cmd>lua vim.lsp.buf.type_definition()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>rn",
			"<cmd>lua vim.lsp.buf.rename()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"gr",
			"<cmd>lua vim.lsp.buf.references()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>ca",
			"<cmd>lua vim.lsp.buf.code_action()<CR>",
			opts
		)
		-- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>e",
			"<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"[d",
			"<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"]d",
			"<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
			opts
		)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>ll",
			"<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
			opts
		)
		vim.cmd(
			[[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
		)
	end

-- nvim-cmp supports additional completion capabilities
local capabilities =
	vim.lsp.protocol.make_client_capabilities()
capabilities =
	require(
		"cmp_nvim_lsp"
	).update_capabilities(
		capabilities
	)

-- Enable the following language servers
local servers =
	{
		"clangd",
		"rust_analyzer",
		"pyright",
		"tsserver",
	}
for _, lsp in ipairs(
	servers
) do
	nvim_lsp[lsp].setup({
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

-- Try out gopls config
nvim_lsp["gopls"].setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"gopls",
		"serve",
	},
	root_dir = function(
		fname
	)
		return nvim_lsp.util.root_pattern(
			"go.mod",
			".git"
		)(
			fname
		) or vim.loop.cwd()
	end,
	settings = {
		gopls = {
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

local sumneko_root_path =
	vim.fn.getenv(
		"HOME"
	) .. "/.local/bin/lua-language-server"
local sumneko_binary = sumneko_root_path
	.. "/bin/macOS/lua-language-server"

-- Make runtime files discoverable to the server
local runtime_path =
	vim.split(
		package.path,
		";"
	)
table.insert(
	runtime_path,
	"lua/?.lua"
)
table.insert(
	runtime_path,
	"lua/?/init.lua"
)

require(
	"lspconfig"
).sumneko_lua.setup({
	cmd = {
		sumneko_binary,
		"-E",
		sumneko_root_path
			.. "/main.lua",
	},
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {
					"vim",
				},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file(
					"",
					true
				),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Set completeopt to have a better completion experience
vim.o.completeopt =
	"menuone,noselect"

-- luasnip setup
local luasnip =
	require(
		"luasnip"
	)

-- nvim-cmp setup
local cmp =
	require(
		"cmp"
	)
cmp.setup({
	snippet = {
		expand = function(
			args
		)
			require(
				"luasnip"
			).lsp_expand(
				args.body
			)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(
			-4
		),
		["<C-f>"] = cmp.mapping.scroll_docs(
			4
		),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = function(
			fallback
		)
			if
				vim.fn.pumvisible()
				== 1
			then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<C-n>",
						true,
						true,
						true
					),
					"n"
				)
			elseif
				luasnip.expand_or_jumpable()
			then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<Plug>luasnip-expand-or-jump",
						true,
						true,
						true
					),
					""
				)
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(
			fallback
		)
			if
				vim.fn.pumvisible()
				== 1
			then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<C-p>",
						true,
						true,
						true
					),
					"n"
				)
			elseif
				luasnip.jumpable(
					-1
				)
			then
				vim.fn.feedkeys(
					vim.api.nvim_replace_termcodes(
						"<Plug>luasnip-jump-prev",
						true,
						true,
						true
					),
					""
				)
			else
				fallback()
			end
		end,
	},
	sources = {
		{
			name = "nvim_lsp",
		},
		{
			name = "luasnip",
		},
	},
})

local function prettier(


)
	return {
		exe = "prettier",
		args = {
			"--config-precedence",
			"prefer-file",
			"--end-of-line",
			"lf",
			"--stdin-filepath",
			vim.fn.shellescape(
				vim.api.nvim_buf_get_name(
					0
				)
			),
		},
		stdin = true,
	}
end

local function shfmt(


)
	return {
		exe = "shfmt",
		args = {
			"-",
		},
		stdin = true,
	}
end

local filetype =
	{
		javascript = {
			prettier,
		},
		typescript = {
			prettier,
		},
		javascriptreact = {
			prettier,
		},
		typescriptreact = {
			prettier,
		},
		["javascript.jsx"] = {
			prettier,
		},
		["typescript.tsx"] = {
			prettier,
		},
		markdown = {
			prettier,
		},
		css = {
			prettier,
		},
		json = {
			prettier,
		},
		scss = {
			prettier,
		},
		less = {
			prettier,
		},
		yaml = {
			prettier,
		},
		graphql = {
			prettier,
		},
		html = {
			prettier,
		},
		sh = {
			shfmt,
		},
		bash = {
			shfmt,
		},
		rust = {
			function(


			)
				return {
					exe = "rustfmt",
					args = {
						"--emit=stdout",
					},
					stdin = true,
				}
			end,
		},
		python = {
			function(


			)
				return {
					exe = "black",
					args = {
						"--quiet",
						"-",
					},
					stdin = true,
				}
			end,
		},
		go = {
			function(


			)
				return {
					exe = "gofmt",
					stdin = true,
				}
			end,
		},
		lua = {
			function(


			)
				return {
					exe = "stylua",
					args = {
						"--indent-type",
						"Tabs",
						"--line-endings",
						"Unix",
						"--indent-width",
						vim.bo.tabstop,
						"--column-width",
						vim.bo.textwidth,
						"-",
					},
					stdin = true,
				}
			end,
		},
	}

require(
	"formatter"
).setup({
	logging = false,
	filetype = filetype,
})

vim.api.nvim_exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.lua,*.py,*.go FormatWrite
augroup END
]],
	true
)
