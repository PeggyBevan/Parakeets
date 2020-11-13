###Clipping audio files

#AIM of this script: 
# To single out clips listed in ClipLocations.csv and save in one folder. 
# (they no longer have to be 4s long)
# for songs of adaptation classifier. 
# code for finding SPL and converting to distance are in APC1.R and ClippingFiles.R

# Packages ----------------------------------------------------------------
install.packages('seewave')
install.packages('tuneR')

library(seewave)
library(tuneR)
library(lubridate)
setwd("/Users/peggybevan/Dropbox/Parakeet Survey/May19/AcousticDS")
setWavPlayer("afplay")

# Packages ----------------------------------------------------------------
install.packages('seewave')
install.packages('tuneR')

library(seewave)
library(tuneR)
library(lubridate)
setwd("/Users/peggybevan/Dropbox/Parakeet Survey/May19/AcousticDS")
setWavPlayer("afplay")

# Data --------------------------------------------------------------------
APC<-read.csv("Data/APC12_wDist.csv")

# script ------------------------------------------------------------------

#tidying dataframe

#make location two integers i/e 01, 02 etc
APC$Sample.Label<-sprintf("%02d", APC$Sample.Label)

#if needed - check all files exist
# APC$fileExist<-file.exists(paste0("/Volumes/Parakeet1/PeggysParakeets/24k_Audio/pointCountSubset/", APC$Sample.Label,"/", APC$filename,"_24k.wav"))
# error<-APC[APC$fileExist=="FALSE",]
# View(error)


# In this loop, I need to make a clip for each row and save it
# File names needs to include location (HH), site, distance and time info

#creating save directories (for every location, creates directory)
for (i in 1:nrow(APC)){
  # remember to change name of folder on the hard drive
  output_dir <- paste0("/Volumes/Parakeet1/PeggysParakeets/SongsOfAdaptation/Clips/", APC$Sample.Label[i])

  if (!dir.exists(output_dir)){
    dir.create(output_dir)
  }
  else {
    print("Already exists!")
  }
}


# Clipping
# Code adapted from APC1.R

for (i in 1:nrow(APC)) {
  
  if(is.na(APC$Obs.Start[i])) {
    next
  }
  # find wave directory
  wave_dir<-paste0("/Volumes/Parakeet1/PeggysParakeets/24k_Audio/pointCountSubset/", 
                   APC$Sample.Label[i],"/",
                   APC$filename[i],"_24k.wav")
  # find place to save files
  save_dir<-paste0("/Volumes/Parakeet1/PeggysParakeets/SongsOfAdaptation/Clips/", 
                  APC$Sample.Label[i],
                  "/HH",
                  APC$Sample.Label[i],"_",
                 APC$filename[i],"_",
                 APC$dist67.5[i], "_",
                  i,".wav")
  # This looks like "/Volumes/Parakeet1/PeggysParakeets/SongsOfAdaptation/Clips/01/HH01_180626_051012_1.wav"
  # Read this file
  wave1<-readWave(wave_dir)
  # Chop relevant bit out
  cutwave<-cutw(wave1, 24000, 
                from = APC$Obs.Start[i], 
                to = APC$Obs.End[i], 
                output = "Wave")
  # Save it
  savewav(wave = cutwave, f = 24000, filename = save_dir, extensible = F)
}

