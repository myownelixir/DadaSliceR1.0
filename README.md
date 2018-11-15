# DadaSlicer1.0
Giving your samples a second life. Automated Sample Packs production.

## Why DadaSlicer?

I am a big believer in randomness and happy accidents. Inspired by an almost century old tradition of Dada movement and Surrealist automatism -  whereby the artist would suppresses conscious control over the making process, allowing the unconscious mind to have great sway, I wanted to create something similar for music production. I also wanted something useful and easy to use. In our case it is not the mind wondering, but the roll of automated dice which governs the process. 

## Installation

Use the devtools package to install the app:
```r
# install.packages("devtools")
devtools::install_github("myownelixir/DadaSlicer1.0")
```

## Features
* Filters out samples that are below 10 sec
* Takes each sample from provided list and extracts and normalises 1 sec audio clips from randomly generated 10 time points (roll of dice)
* Saves new samples to the output folder creating automatically new Sample Pack
* Can save samples into smaller Sample Packs by randomly distributing 15 1 sec files into newly created subfolders based on output value folder via ```
dada_folders(output) ```
* Each time the output is different, meaning that if you run the process again on the same ```input``` folder, the newly generated audio clips will be different as the time points would be different
* The output files are in the "one shots" category rather than loops etc.

## Setup
Make sure you have installed dependencies:
```r
install.packages("tuneR")
install.packages("seewave")
install.packages("dplyr")
```
Point to the path where you keep your samples you want to process:

```r
input <- "C:/some_folder/audiofiles/"
```
Make sure that the samples are Wave files, they are 44.1K, stereo and 16 bit. If your samples are in different format use GoldWave batch conversion function to convert them into desired format. 

Define output folder like below. If the output folder does not exist it will be created. 

```r
output <- "C:/some_folder/my_outout_folder"
```
## Usage

Core function is the ``` dada_slicer()``` which takes as arguments ```(input, output)``` values like so:
```r 
dada_slicer(input, output)
```
Once the the process is completed we can check the output folder to see if new samples were created:
```r 
>list.files(output)
[1] "sample_1.wav" "sample_2.wav" "sample_3.wav" sample_4.wav"
```
An additional function is an ``` dada_folders()``` which as an argument takes  earlier defined ```(output)``` folder. It takes the newly generated files, randomly selects 15 and puts this new selection into a new subfolder. The process is repeated until all the files are redistributed. WARNING (!) Be careful when using this function as when the process is finished it deletes all the original files from the ```(output)``` folder.
The output of this function are new folders in the ```(output)``` folder containing your 1 sec samples.

## Application of the package

When I was creating it, the main use case I was thinking about was to help me to go quickly through 100s or 1000s of samples from session recordings, foley recordings etc, and rather then manually select the most interesting bits I would leave it to chance, and let the faith decide and pick 10 1 sec audio clips from each of my files. I use it to generate my personal sample packs and use newly generated samples in music production, sound design, TidalCycles projects etc.  

I have noticed that always there will be some very interesting clips among those samples that otherwise I might have missed. 

So to sum up, here are some applications:
* Go through 1000s of audio files and instantly generate interesting sample packs
* Reuse your old samples and chop them in new fashion to breath new live into your older work
* Use it to chop your long foley recording sessions into nicely digestible audio clips
* Get inspired, start recording random sounds from various inputs and turn them into sound packs. I routinely use my iPhone, my synth sessions, my portable recorder sounds to generate something new and inspiring.
* Great for generating interesting textures and ambience sounds
* It will not produce your music automatically but it is a great tool to automate some of the processes

