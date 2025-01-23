#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)



  #ssPath="/home/lucio/superGrive/Mega/bioinformatics/data/QuantSeq/2019/Lexogen_57-58/ssDb_Lexogen_57-58.xls"
  #mainProject="lucioTest"
  #fileout="/home/lucio/superGrive/Mega/bioinformatics/data/QuantSeq/2019/Lexogen_57-58/testOutoDemulSS.csv"
  #format c("xlsx","csv")
  ssPath <- args[1]
  originalSampleProject <- args[2]
  format <- args[3]
  mainProject <- args[4]
  OverrideCycles <- args[5]
  IndexReads <- args[6]
  date <- Sys.Date()

  if (format=="xlsx"){
    sst<-openxlsx::read.xlsx(ssPath)
  } else if (format=="tsv"){
    sst<-read.delim(file=ssPath, header=TRUE, sep="\t")
  } else if (format=="txt"){
    sst<-read.delim(file=ssPath, header=TRUE, sep="\t")
  } else if (format=="csv"){
    sst<-read.delim(file=ssPath, header=TRUE, sep=",")
  }

OverrideCycles <- gsub(",", ";", OverrideCycles)


  if (length(grep("-", sst[,5]))==length(sst[,5])){
    print("Dual index analysis identified")
    index_length <- paste0((nchar(sst[1,5])-1)/2)
    outname <- paste0("DEMULTIPLEX_DUAL", index_length, "NT.csv")
    ncols=5
    numInd<-2
    colsnames=c("Sample_ID", "index", "index2", "Sample_Project", "Lane")
  } else {
    if (length(grep("-", sst[,5]))==0){
      index_length <- paste0((nchar(sst[1,5]))
      outname <- paste0("DEMULTIPLEX_SINGLE", index_length, "NT.csv")
      print("Single index analysis identified")
      ncols=4
      numInd<-1
      colsnames=c("Sample_ID", "index", "Sample_Project", "Lane")
    } else {
      print("index error")
    }
  }

  sst<-as.data.frame(apply(sst,2,function(x)gsub('\\s+', '',x))) 

  resuMa1<-matrix(ncol=ncols,nrow=12)
  resuMa1[1,1]<-"[Header]"

  resuMa1[2,1]<-"IEMFileVersion"
  resuMa1[2,2]<-"4"

  resuMa1[3,1]<-"Investigator Name"
  resuMa1[3,2]<-"Cacchiarelli"

  resuMa1[4,1]<-"Experiment Name"
  resuMa1[4,2]<-mainProject

  resuMa1[5,1]<-"Date"
  resuMa1[5,2]<-date

  resuMa1[6,1]<-"Workflow"
  resuMa1[6,2]<-"GenerateFASTQ"

  resuMa1[7,1]<-"Application"
  resuMa1[7,2]<-"FASTQ Only"

  resuMa1[10,1]<-"[Settings]"
  resuMa1[11,1]<-paste0("OverrideCycles,",OverrideCycles)
  if(IndexReads == "NO") {
    resuMa1[12,1]<-paste0("CreateFastqForIndexReads,0")
    } else if(IndexReads == "YES") {
    resuMa1[12,1]<-paste0("CreateFastqForIndexReads,1")
    }

  resuMa2<-matrix(ncol=ncols,nrow=length(sst[,1])+2)
  resuMa2[1,1]<-"[Data]"

  resuMa2[2,]<-colsnames

  #sample id
  resuMa2[3:(length(sst[,1])+2),1]<-as.character(sst[,3])

  #index
  if(ncols==4){
    resuMa2[3:(length(sst[,1])+2),2]<-as.character(sst[,5])
  }else{
    id1<-unlist(lapply(strsplit(as.character(sst[,5]),"-"), function(x) x[1]))
    id2<-unlist(lapply(strsplit(as.character(sst[,5]),"-"), function(x) x[2]))
    resuMa2[3:(length(sst[,1])+2),2]<-id1
    resuMa2[3:(length(sst[,1])+2),3]<-id2
  }

  #sample project
  if(originalSampleProject==FALSE){
    resuMa2[3:(length(sst[,1])+2),ncols-1]<-mainProject
  }else{
    resuMa2[3:(length(sst[,1])+2),ncols-1]<-as.character(sst[,12])
  }

  #Lane column
  if(!any(is.na(sst[,2]))){
    resuMa2[3:(length(sst[,1])+2),ncols]<-as.character(sst[,2])
  }else{
    resuMa2<-resuMa2[,-ncols]
    resuMa1<-resuMa1[,-ncols]
  }


  resuma<-rbind(resuMa1,resuMa2)



  write.table(x=resuma,file=outname,quote=FALSE, na="",row.names=FALSE,col.names=FALSE,sep=",")
