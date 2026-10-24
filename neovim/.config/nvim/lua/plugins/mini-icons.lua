return {
	-- Icons for every plugin; also stands in for nvim-web-devicons
	"echasnovski/mini.icons",
	opts = {},
	init = function()
		package.preload["nvim-web-devicons"] = function()
			require("mini.icons").mock_nvim_web_devicons()
			return package.loaded["nvim-web-devicons"]
		end
	end,
}
