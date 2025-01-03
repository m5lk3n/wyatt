# How to ...

## ... print the wireframe to PDF

1. Open "moqup" in Chrome (not Firefox) to properly print it to PDF
2. -> Preview (make sure it's set to 100% zoom, but so that the zoom widget (lower left corner) is hidden)
3. -> Fullscreen
4. Chrome -> Print -> Save as PDF
   - Portrait
   - A3
   - Margin: None
   - Scale: Custom: 46 (or whatever makes the picture fit fully)
   - No Background Graphics
5. Save as `wireframe.pdf` to download the PDF

## ... convert the wireframe from PDF to PNG

Option 1: On Linux, run the following to create the PNG file(s):

```
sudo apt install poppler-utils
pdftoppm -png wireframe.pdf wireframe
```

Option 2: Browse to https://github.com/m5lk3n/wyatt/blob/main/docs/wireframe.pdf and right-click the preview image -> "Save Image As..."

## ... run on Xcode

```
cd ios
pod install
```

Open `ios` folder in Xcode.

Plug in test iPhone.

In Xcode, open `Runner.xcodeproj`, pick the connected iPhone as runner, and hit the play button to build the project.

## ... (re-)generate icons

Run `make icons`* from this repo's root folder.

*) "regenerate application launcher icons (from assets/icon/icon.png)"