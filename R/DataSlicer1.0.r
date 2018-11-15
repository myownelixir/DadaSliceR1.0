

library(devtools)
document()

require(tuneR)
require(seewave)
require(dplyr)




###### DEFINE DIRECTORIES #######
#' Define input and out folders
#' @param input,output if output folder does not exist it will be created
#' @examples
#' input <- "C:/some_folder/audiofiles/"
#' output <- "C:/some_folder/audiofiles/chopped_samples"

input <- NULL
output <- NULL


###### GET WAVE LIST OF FILES ABOVE 10 SEC ########
#' A data_slicer is the main function of the package. There are couple of main steps 1. It filters out the files that are above 10 sec. 2. It generates 5 or 10 random points (from, to) in time based on length of each file, extracts those samples into the output folder.
#' @param input,output directories from where to take files and where to save new chopped files
#' @return function does not return value, however it choppes the files from input folder and deposits new ones into the output folder
#' @examples
#' dada_slicer(input,output)


dada_slicer <- function(input, output) {

  FromTo <- function(x) {
    from <- if (x > 10){
      sample(0:ceiling(x-1), 10, replace=F)
    } else {
      sample(0:ceiling(x-1), 5, replace=F)
    }

  }



  GetWaveList <- function(input) {
    wav_list <- list.files(input, pattern = "\\.wav$")

    df <- data.frame(matrix(unlist(wav_list), byrow = T))

    names(df)[1] <- "wave_list"

    df$length_sec <- 0

    print("Filtering wave files > 10 secs from your input directory")

    pb <-
      txtProgressBar(min = 0,
                     max = length(wav_list),
                     style = 3)



    for (i in 1:length(wav_list)) {
      #print(sprintf(paste0("Procesing wave files from your input list, %s/", length(wav_list), " objects processed"), i))

      setTxtProgressBar(pb, i)

      wav_length <-
        round(length(readWave(paste0(
          input, wav_list[i]
        ))) / 44100, 0) - 2

      df$length_sec[i] <- wav_length
    }

    close(pb)

    wave_list_df <- df %>% filter(length_sec > 10)
    WaveList <- wave_list_df$wave_list

    return(WaveList)
  }


  temp_wave_list <- GetWaveList(input)


  SampleSlicer <- function(temp_wave_list, output) {

    print("Slicing your samples into tiny ninja chunks")

    pb <-
      txtProgressBar(min = 0,
                     max = length(temp_wave_list),
                     style = 3)
    for (i in 1:length(temp_wave_list)) {
      try({
        wave1 <- readWave(paste0(input, temp_wave_list[i]))

        setTxtProgressBar(pb, i)

        wave_length <-
          round(length(readWave(
            paste0(input, temp_wave_list[i])
          )) / 44100, 0) - 2

        fromage <- FromTo(wave_length - 1)

        for (i in 1:length(fromage)) {
          temp_from <- fromage[i]

          temp_wave <-
            extractWave(wave1,
                        from = temp_from,
                        to = temp_from + 1,
                        xunit = "time")

          temp_STEREO <- c("left", "right")

          for (i in 1:length(temp_STEREO)) {
            temp_sound <- mono(temp_wave, which = temp_STEREO[i])

            temp_wave1 <- fadew(
              temp_sound,
              din = 0.15,
              dout = 0.15,
              shape = "exp",
              plot = F,
              listen = F,
              output = "Wave"
            )

            assign(paste0("temp_", temp_STEREO[i]), temp_wave1)
          }

          temp_wave2 <-
            normalize(stereo(temp_left, temp_right), unit = "16")

          if (!dir.exists(output))
            dir.create(output)

          mypath <-
            file.path(output,
                      paste("sample_", sample(1:as.numeric(
                        length(temp_wave_list) * 10
                      ), 1), ".wav", sep = ""))

          writeWave(temp_wave2, filename = mypath)

        }
      })
    }
    close(pb)
  }

  SampleSlicer(temp_wave_list, output)
}



################# FILES REDISTRIBUTION INTO RANDOM FOLDERS #######################
#' A data_folders is an additional function that takes as an argument (output) folder. The main purpose of this function is to redistribute randomly the newly generated files from the previous function into folders that contain only 15 files, creating effectively small sample packs.
#' @return function creates new folders in the (output) folder and randomly chooses 15 files from the this folder, copies them and pastes them into the new folder. This operation is repeated untill all the files are redistributed in new folders. Once the operation is finished all the files from the (output) folder are removed.
#' @examples
#' ada_folders(output)

dada_folders <- function(output){

  list.of.files <- list.files(output, "\\.wav$", full.names = T)

  FolderNumbers <-
    sample(1:ceiling(length(list.of.files)/15), ceiling(length(list.of.files) /
                                                          15))
  print(paste0("For more randomization, your files are being redistributed among ", length(list.of.files)/15, " folders."))

  pb <-
    txtProgressBar(min = 0,
                   max = length(FolderNumbers),
                   style = 3)

  for (i in 1:length(FolderNumbers)) {
    setTxtProgressBar(pb, i)
    newdir <- paste0(output, i)
    dir.create(newdir)
    toprocess <- sample(list.of.files, size = 15)
    file.copy(toprocess, paste0(newdir, "/"))

  }
  close(pb)

  unlink(output, recursive = T)
}
