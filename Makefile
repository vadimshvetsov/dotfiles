.PHONY: clean_nvim

COMMAND = Clear Neovim deps, state and cache

clean_nvim:
	rm -rf ~/.cache/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
