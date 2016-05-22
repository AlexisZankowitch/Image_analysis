# Image_analysis
project Enssat 

change base_path variable in the fonction initialization (utility.sce) by your path to this directory.

###### scilab command : 

```
overallAccuracy(n)
```
>Test overall accuracy, return a figure of the overall accuracy of the recognition per class

  - n : (int) images used to build learning base. 
  


```
faceDetection(n)
```
>work concerning face detection

  - n : (int) images used to build learning base. 

```
startLearning(n)
```
>Makes learning base with n images per classes, creates files : eigenfaces, D, m, s, img_used, classes

```
startRecognition(class)
```
>Use this command to test one class
  - class : (int) class number

```
startAllRecognition()
```
>Use this command to test recognition on all classes, return a figure of the overall distance per class **need improvement **
