# How to ...

<details>
<summary>... print the wireframe to PDF</summary>

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
</details>

<details>
<summary>... convert the wireframe from PDF to PNG</summary>

Option 1: On Linux, run the following to create the PNG file(s):

```
sudo apt install poppler-utils
pdftoppm -png wireframe.pdf wireframe
```

Option 2: Browse to https://github.com/m5lk3n/wyatt/blob/main/docs/wireframe.pdf and right-click the preview image -> "Save Image As..."
</details>

<details>
<summary>... (re-)generate icons</summary>

Run `make icons`* from this repo's root folder.

*) "regenerate application launcher icons (from assets/icon/icon.png)"
</details>

<details>
<summary>... check that an image does not contain any EXIF data</summary>

```
$ exif --no-fixup assets/images/logo.png
Corrupt data
The data provided does not follow the specification.
ExifLoader: The data supplied does not seem to contain EXIF data.
```

</details>

## iOS

<details>
<summary>... run on Xcode</summary>

```
cd ios
pod install
```

Open `ios` folder in Xcode.

Plug in test iPhone.

In Xcode, open `Runner.xcodeproj`, pick the connected iPhone as runner, and hit the play button to build the project.
</details>

<details>
<summary>... trust a developer</summary>
"Tap Settings > General > VPN & Device Management. In the ~~Enterprise~~Developer App section, tap the name of the app developer. Tap Trust '[developer name]' to continue." (derived from [this](https://support.apple.com/en-us/118254) source)

</details>