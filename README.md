# ColorPickerController
ColorPickerController written in Swift 3

### Supported Platforms
iOS 10+

### Installing

In order to install `ColorPickerController`, you'll need to copy the `ColorPickerController.swift` into your Xcode project.

### Usage

In order to use `ColorPickerController`, you'll need to include the following code in your project:

```swift
      let colorPickerController = ColorPickerController()
      colorPickerController.modalPresentationStyle = .overCurrentContext
      colorPickerController.selectedColor = { color in
           // use color in your project
      }
      present(colorPickerController, animated: true){
            colorPickerController.addBlur()
      }
```

### License

All content is licensed under the terms of the MIT open source license.


### Contact

* Sebastian Gazolla Jr
* [@gazollajr](http://twitter.com/gazollajr)
* [http://gazapps.com](http://gazapps.com)
* [http://about.me/gazolla](http://about.me/gazolla)

