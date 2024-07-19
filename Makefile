.PHONY: clean_astronvim

COMMAND = Clear AstroNvim deps, state and cache

clean_astronvim:
	rm -rf ~/.cache/nvim
	rm -rf ~/.local/share/nvim
	rm -rf ~/.local/state/nvim
