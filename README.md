# A stash repository of random programs

## System scripts (bash, systemd services, etc)

- [Movies](https://github.com/thesave/stash/tree/master/kiosk): some bash files and systemd services to manage the scheduled playing of videos on a remote computer.

## [Jolie](http://www.jolie-lang.org) services.

- [PDFy HTML article](https://github.com/thesave/stash/tree/master/pdfy_html): this service uses the [Readability Parser API](https://www.readability.com/developers/api/parser) 
to extract the content of the article and launches [Pandoc](http://pandoc.org/) to transform the html document into a 
nicely-formatted PDF (it requires Pandoc and LaTex installed in the system).
