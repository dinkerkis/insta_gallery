# insta_gallery

A new Flutter project.

## Getting Started

## 1.  Add in pubspec.yaml file under
 
 dependencies:
``` 
 insta_gallery:  
   git:  
     url: https://github.com/dinkerkis/insta_gallery.git
``` 
 
## 2. Add package

``` 
import 'package:insta_gallery/insta_gallery.dart';

``` 


## 3.  Use in the code like this: 

``` 
AddPostScreen(shouldEdit: true,
                  onGalleryImagePicked: (file) {
                    if (mounted) {
                      setState(() {

                      });
                    }
                  },
                  onGalleryVideoPicked: (file) {
                    if (mounted) {
                      setState(() {

                      });
                    }
                  },
                )
```

