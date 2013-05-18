# Vim Online Thesaurus

This is a plugin for Vim allowing you to look up words in an online thesaurus,
which is at the moment configured to be http://thesaurus.com

The plugin displays the definition of the word under the cursor and a list of
synonyms.

![](https://github.com/beloglazov/vim-online-thesaurus/raw/master/screenshot.png)

The credit for the original idea and code goes to Nick Coleman:
http://www.nickcoleman.org/


## Installation

If you are using Vundle, just add the following line to your .vimrc:

```
Bundle 'beloglazov/vim-online-thesaurus'
```

Then run `:BundleInstall` to install the plugin.


## Usage

The plugin provides the `:OnlineThesaurusLookup` command to look up the current
word under the cursor in an online thesaurus. The command makes a request to
http://thesaurus.com, parses results, and displays them in a vertical split in
the bottom.

By default the `:OnlineThesaurusLookup` command is mapped to `<LocalLeader>K`.
If you haven't remapped `<LocalLeader>`, it defaults to `\`. To close the split,
just press `q`.


## Configuration

If you want to disable the default key binding, add the following line to your
.vimrc:

```
let g:online_thesaurus_map_keys = 1
```

Then you can map the `:OnlineThesaurusLookup` command to anything you want as
follows:

```
nnoremap <your key binding> :OnlineThesaurusLookup<CR>
```

Enjoy!


## License

Copyright (c) Anton Beloglazov. Distributed under the same terms as Vim itself.
See :help license.
