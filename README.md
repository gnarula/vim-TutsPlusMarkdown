This vim plugin is based on Dan Harper's Sinantra app to generate Tuts+ Flavored HTML from Markdown files.

## Dependencies

* Vim >= 7.3 with Python support (+python in vim --version)
* [misaka](https://github.com/FSX/misaka) (Python binding for Sundown)

## Installation

Install `misaka` system-wide using pip

    sudo pip install misaka

Then install the plugin using pathogen

    cd ~/.vim/bundle
    git clone https://github.com/gnarula/vim-TutsPlusMarkdown.git

Default key binding for the plugin in normal mode is `Ctrl+m`

__Note__:
* This plugin has only been tested Vim 7.3 on Ubuntu 12.10
* Use the plugin only when the current buffer has been saved to a file or `set hidden` is in your vimrc

## Credits

* [Dan Harper](https://github.com/danharper/) for the Sinantra App
* Developers of `misaka`
