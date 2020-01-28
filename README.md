# ImageKit.IO

[![Release](https://jitpack.io/v/User/Repo.svg)]
(https://jitpack.io/#User/Repo)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Twitter Follow](https://img.shields.io/twitter/follow/imagekitio?label=Follow&style=social)](https://twitter.com/ApacheAirflow)

Android SDK for [ImageKit.io](https://imagekit.io) which implements client-side upload and URL generation for use inside an Android application.

ImageKit is a complete image optimization and transformation solution that comes with an [image CDN](https://imagekit.io/features/imagekit-infrastructure) and media storage. It can be integrated with your existing infrastructure - storages like AWS S3, web servers, your CDN and custom domain names, allowing you to deliver optimized images in minutes with minimal code changes.
Android client for Imagekit Integration

## Requirements
The library requires Android version 5.0.0 (API level 21 - Lollipop) or above.

## Installation
In your root build.gradle file, add:
```xml
allprojects {
    repositories {
       ...
        maven { url "https://jitpack.io" }
    }
}
```

In the module build.gradle file, add:
```xml 
implementation 'com.github.imagekit-developer:imagekit-android:<VERSION>'
```

## Initialization
You need to initialize the sdk by providing the application context, `publicKey` and the `urlEndpoint`. You can do this either in your application or launcher activity. This needs to be called before any other function in the SDK or else an exception would be thrown.

`authenticationEndpoint` is only required if you want to use the upload functionality.

_Note: Do not include your Private Key in any client side code, including this SDK or its initialization._

```kotlin
// In kotlin
import com.imagekit.android.ImageKit;

ImageKit.init(
            context = applicationContext,
            publicKey = "your_public_api_key",
            urlEndpoint = "https://ik.imagekit.io/your_imagekit_id",
            transformationPosition = "path",
            authenticationEndpoint = "http://www.yourserver.com/auth"
        )
```

```java
// In Java
import com.imagekit.android.ImageKit;

ImageKit.Companion.init(
        getApplicationContext(),
        "your_public_api_key",
        "path",
        "https://ik.imagekit.io/your_imagekit_id",
        "http://www.yourserver.com/auth"
    );
```

## Sample application
This project has a sample application under `sample` folder. The sample application demonstrates the use of this SDK.

## Usage
### URL construction
#### Using image path
```kotlin
// https://ik.imagekit.io/your_imagekit_id/default-image.jpg?tr=h-400.00,ar-3-2
ImageKit.getInstance()
        .url(
            path = "default-image.jpg",
            transformationPosition = TransformationPosition.QUERY
        )
        .height(400f)
        .aspectRatio(3, 2)
        .create()
```

#### Using full image URL
```kotlin
// https://ik.imagekit.io/your_imagekit_id/medium_cafe_B1iTdD0C.jpg?tr=oi-logo-white_SJwqB4Nfe.png,ox-10,oy-20
ImageKit.getInstance()
        .url(
            src = https://ik.imagekit.io/your_imagekit_id/medium_cafe_B1iTdD0C.jpg",
            transformationPosition = TransformationPosition.PATH
        )
        .overlayImage("logo-white_SJwqB4Nfe.png")
        .overlayPosX(10)
        .overlayPosY(20)
        .create()
```

#### Using a custom parameter
```kotlin
// https://ik.imagekit.io/your_imagekit_id/plant.jpeg?tr=w-400,ot-Hand with a green plant,otc-264120,ots-30,ox-10,oy-10
ImageKit.getInstance()
        .url(src = "https://ik.imagekit.io/your_imagekit_id/plant.jpeg?tr=oi-logo-white_SJwqB4Nfe.png,ox-10,oy-20")
        .addCustomTransformation("w", "400")
        .overlayText("Hand with a green plant")
        .overlayTextColor("264120")
        .overlayTextSize(30)
        .overlayPosX(10)
        .overlayPosY(10)
        .create()
```

### List of supported transformations
The complete list of transformations supported and their usage in ImageKit can be found [here](https://docs.imagekit.io/imagekit-docs/image-transformations). The SDK provides a function for each transformation parameter, making the code simpler and readable. If a transformation is supported in ImageKit, but a name for it cannot be found in the table below, then use the `addCustomTransformation` function and pass the transformation code from ImageKit docs as the first parameter and value as second paramter. For example - `.addCustomTransformation("w", "400")`

| Supported Transformation Function | Translates to parameter |
| ----------------------------- | ----------------------- |
| height                        | h                       |
| width                         | w                       |
| aspectRatio                   | ar                      |
| quality                       | q                       |
| crop                          | c                       |
| cropMode                      | cm                      |
| focus                         | fo                      |
| format                        | f                       |
| radius                        | r                       |
| background                    | bg                      |
| border                        | bo                      |
| rotation                      | rt                      |
| blur                          | bl                      |
| named                         | n                       |
| overlayImage                  | oi                      |
| overlayX                      | ox                      |
| overlayY                      | oy                      |
| overlayFocus                  | ofo                     |
| overlayHeight                 | oh                      |
| overlayWidth                  | ow                      |
| overlayText                   | ot                      |
| overlayTextFontSize           | ots                     |
| overlayTextFontFamily         | otf                     |
| overlayTextColor              | otc                     |
| overlayAlpha                  | oa                      |
| overlayTextTypography         | ott                     |
| overlayBackground             | obg                     |
| progressive                   | pr                      |
| lossless                      | lo                      |
| trim                          | t                       |
| metadata                      | md                      |
| colorProfile                  | cp                      |
| defaultImage                  | di                      |
| dpr                           | dpr                     |
| effectSharpen                 | e-sharpen               |
| effectUSM                     | e-usm                   |
| effectContrast                | e-contrast              |
| effectGray                    | e-grayscale             |

### File Upload
The SDK provides a simple interface using the `ImageKit.getInstance().uploader().upload` method to upload files to the ImageKit Media Library. It accepts all the parameters supported by the [ImageKit Upload API](https://docs.imagekit.io/api-reference/upload-file-api/client-side-file-upload#request-structure-multipart-form-data).

The SDK invokes the endpoint speicified by `authenticationEndpoint` parameter at time of SDK initialization to get `token`, `expiry` and `signature`. You can implement this endpoint on your server-side using the utility function provided in all [server-side SDKs](https://docs.imagekit.io/api-reference/api-introduction/sdk#server-side-sdks).

#### Upload file from bitmap
``` kotlin
val filename = "file-name.jpg"
val timestamp = System.currentTimeMillis()
ImageKit.getInstance().uploadImage(
    file = bitmap!!
    , fileName = filename
    , useUniqueFilename = false
    , tags = arrayOf("nice", "copy", "books")
    , folder = "/dummy/folder/"
    , imageKitCallback = this
)
```

#### Upload file from a remote URL
``` kotlin
val filename = "file-name.jpg"
val timestamp = System.currentTimeMillis()
ImageKit.getInstance().uploader().upload(
    file = "https://ik.imagekit.io/demo/img/default-image.jpg"
    , fileName = filename
    , useUniqueFilename = false
    , tags = arrayOf("nice", "copy", "books")
    , folder = "/dummy/folder/"
    , imageKitCallback = this
)
```

#### Upload file using binary
```kotlin
ImageKit.getInstance().uploader().upload(
    file = file!!
    , fileName = file!!.name
    , useUniqueFilename = true
    , tags = arrayOf("nice", "copy", "books")
    , folder = "/dummy/folder/"
    , imageKitCallback = this
)
```

## Support

For any feedback or to report any issues or general implementation support please reach out to [support@imagekit.io](mailto:support@imagekit.io)

## Links
* [Documentation](https://docs.imagekit.io)
* [Main website](https://imagekit.io)

## License

Released under the MIT license.




MIT license. See the LICENSE file for more info.
