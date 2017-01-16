# [Stuff of Dreams tarot](juliosepia.com/posts/stuff-of-dreams-tarot.html)

[![Node](https://img.shields.io/badge/node-4.4.1-brightgreen.svg)]()
[![CC-BY-NA license](https://img.shields.io/badge/license%20for%20media-CC--BY--NA-lightgrey.svg)](http://creativecommons.org/licenses/by-nc/4.0/)
[![MIT license](https://img.shields.io/badge/license%20for%20code-MIT-lightgrey.svg)]()

[![Completion progress](http://progressed.io/bar/32)](juliosepia.com/posts/stuff-of-dreams-tarot.html)
<br />
**7/22** Major Arcana completed

This contains the cards for my tarot set as well as a script that converts them into print-ready assets. Even though I plan on selling my tarot deck through a print-on-demand site, I've decided to release all the assets and scripts to the public domain free of charge, so that you may use them and modify them as you wish. You can even print your own copy.

## The script

### Installation

On OS X / Linux:

```sh
git clone https://github.com/jsepia/stuff-of-dreams.git
cd stuff-of-dreams
npm install
```

Windows is not supported at the moment.

### Usage

```sh
npm run build         # default (300dpi)
npm run build:medium  # 144dpi
npm run build:low     # 72dpi
```

## Licenses

* The file `resources/fg-light-grunge-texture-3.jpg` is (C) Fudgegraphics ("free for both personal and commercial use", according to the author) and can be found [here](http://www.fudgegraphics.com/2011/10/11-free-hi-res-light-grunge-textures-set-1/).
* Any image files in the `src/` directory are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.
* Any other files in this repository, including (but not limited to) source code, are licensed under a [MIT License](https://opensource.org/licenses/MIT).

## TODO

* ~~Desaturate the image sources to hide any blue stains from dried white~~
* Add a subtle burgundy color overlay
* Make the template look more handmade and painterly
* Rescan the drawings in at least 300dpi for print
* Clean up the drawings in photoshop
* Remove the dependency on `bc`
* [BONUS GOAL] Minor arcana!
* [BONUS GOAL] Full color!
