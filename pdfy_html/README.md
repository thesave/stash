To use the program:

1. get an API key from [Mercury](https://mercury.postlight.com/web-parser/);
2. clone the files in this folder;
3. create a file `config.iol` with the line `constants { API_KEY = "THE API KEY AT POINT 1."}` next to the other files in the folder;
4. modify lines 29--31 of file `pdfy_html.ol` so that variable `art` contains the URLs of the html pages to transform into PDF, e.g.,
```Java
art[#art] = "https://aPage.html";
art[#art] = "http://anotherPage.php";
art[#art] = "http://a/Third/page/";
```

Finally, run <kbd>jolie pdfy_html.ol</kbd>.

Enjoy
