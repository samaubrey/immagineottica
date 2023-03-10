# immagineottica

Client per visualizzare i propri punti della Tessera Lac

## Caso d'uso principale

- Registrare un nuovo utente. (La creazione della tesseraLac collegata all'utente è da eseguire manualmente
  con la app di backoffice)
- Visualizzare i punti della propria tesseraLac
- Visualizzare una pagina di benvenuto con gli ultimi occhiali


### Note per sviluppatori
- Per far funzionare la web app è stato modificata la riga di /web/index.html <base href="$FLUTTER_BASE_HREF">
  con <base href="/webapp/">. Vedi commenti del file per modificare in caso di cambio server.
- Spunto per app ottimizzata : https://github.com/flutter/gallery/

### Prossimi passi:
- Scrivere test per comunicazione con database.

### Bug:

### Da fare:
- Su TesseraLac
    - Inserire la foto della tessera Lac
- Pubblicare app android su play store
    - https://docs.flutter.dev/deployment/android


