# A stash repository of pointer and (semi-disparate Jolie programs)

## Readings and Pointers

[Link to the dedicated Wiki page](https://github.com/thesave/stash/wiki/Readings)

## System scripts (bash, systemd services, etc)

- [Stats](https://github.com/thesave/stash/tree/master/stats): bash files for linux and osx to show statistics of the machine.

## [Jolie](http://www.jolie-lang.org) services.

- [PDFy HTML article](https://github.com/thesave/stash/tree/master/pdfy_html): this service uses the [Mecury Parser API](https://mercury.postlight.com/web-parser/) 
to extract the content of the article and launches [Pandoc](http://pandoc.org/) to transform the html document into a 
nicely-formatted PDF (it requires Pandoc and LaTex installed in the system).
