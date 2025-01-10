#File to export all the targets from the Zambia target files.
#Doing a lot of manual way to go through the sheets so we can have a follow up as needed
pacman::p_load(dplyr, readxl,stringr, openxlsx, gmodels)
dirname <- "C:/Users/SNyimbili/OneDrive - Right to Care/Documents/RTCZ/RTCZ/R/RTCZ/Data/Provincial Targets"

setwd(dirname)

#Set the source data sets files
# ------- Adults ----------
Targets_Luapula <- "Targets Luapula.xlsx"
Targets_Muchinga <- "Targets Muchinga.xlsx"
Targets_Northen <- "Targets Northern.xlsx"

zambia_target_header <- c("Province","District", "Facility", "DatimTarget",
                            "DATIMTarget_Adj", "Indicator","Group")

#Reading the files in 
Targets_Luapula_sheetnames <- getSheetNames(Targets_Luapula)
Targets_Muchinga_sheetnames <- getSheetNames(Targets_Muchinga)
Targets_Northen_sheetnames <- getSheetNames(Targets_Northen)

Targets_Northen_sheetnames

#To remove these sheet names they do not contain data
Luapula_rem <- c("FY23_Pivot Results","DATIM Targets","DATIM Adj Internal")
Muchinga_rem <- c("FY23_Pivot Results","Sheet1","DATIM Targets","DATIM Adj Internal", "HTs_TST_OLD")
Nothern_rem <- c("")

Targets_Luapula_sheetnames <-  Targets_Luapula_sheetnames[! Targets_Luapula_sheetnames%in% Luapula_rem]
Targets_Muchinga_sheetnames <-  Targets_Muchinga_sheetnames[! Targets_Muchinga_sheetnames%in% Muchinga_rem]
Targets_Northen_sheetnames <-  Targets_Northen_sheetnames[! Targets_Northen_sheetnames%in% Nothern_rem]

Targets_Northen_sheetnames

#To exclude calculating Peads data
NopeadstargetsMuchinga = c("VMMC_CIRC", "KP_PREV", "PrEP_NEW", "PrEP_CT", "CXCA SCRN")
NopeadstargetsLuapula = c("TX_TB D", "CXCA_SCRN", "PrEP_CT", "PrEP_NEW", "KP_PREV", "GEND_GBV", "VMMC_CIRC")
NopeadstargetsNothern = c("")

NopeadstargetsNothern

##### #####################  LUAPULA TARGETS ######################################################

luapula.targ <- head(data.frame(t(zambia_target_header)),0) # get dummy df
names(luapula.targ) <- zambia_target_header

for (i in Targets_Luapula_sheetnames){
  
  print(paste0("This is indicator: ", i))
  
  tarLua_var.tar <- data.frame(read_excel(Targets_Luapula, sheet= i))
  tarLua_var.tar.names <- c("Province", "District", "Facility")
  target.var <- tarLua_var.tar %>% dplyr::select(matches('FY24'))
  target.varadj <- tarLua_var.tar %>% dplyr::select(matches('Adjusted'))
  
  #check for adjusted targets
  if(ncol(target.var)>1){
    names(target.var) <- c("DatimTarget","DATIMTarget_Adj")
  }else if(ncol(target.varadj)>0){
    target.var <- cbind(target.var,target.varadj)
    names(target.var) <- c("DatimTarget","DATIMTarget_Adj")
  }else{
    names(target.var) <- c("DatimTarget")
    target.var$DATIMTarget_Adj <- target.var$DatimTarget
  }
  
  if(!(i %in% NopeadstargetsLuapula)){  #  <- check if peads are set
    
    print(paste0(i, " - Has peads targets"))
    
    target.peads <- tarLua_var.tar %>% dplyr::select(matches('Peads.Target'))
    names(target.peads) <- "peads.tar"
    
    tarLua_var.tar <- tarLua_var.tar[tarLua_var.tar.names]
    #placeholder for peads
    tarLua_var.tar.peads <- tarLua_var.tar
    
    tarLua_var.tar.peads$DatimTarget <- as.numeric(target.peads$peads.tar)
    tarLua_var.tar.peads$DATIMTarget_Adj <- as.numeric(target.peads$peads.tar)
    
    tarLua_var.tar$DatimTarget <- as.numeric(target.var$DatimTarget) - as.numeric(target.peads$peads.tar)
    tarLua_var.tar$DATIMTarget_Adj <- as.numeric(target.var$DATIMTarget_Adj) - as.numeric(target.peads$peads.tar)
    
    tarLua_var.tar$Indicator <- i
    tarLua_var.tar$Group <- "Adults"
    
    ### peads
    tarLua_var.tar.peads$Indicator <- i
    tarLua_var.tar.peads$Group <- "Peads"
  
    
    luapula.targ <- rbind(luapula.targ, tarLua_var.tar)
    luapula.targ <- rbind(luapula.targ, tarLua_var.tar.peads)
    
  
  }else{
    
    print(paste0(i, " - Does not have peads targets"))
    
    tarLua_var.tar <- tarLua_var.tar[tarLua_var.tar.names]
    tarLua_var.tar.peads <- tarLua_var.tar
    
    tarLua_var.tar$DatimTarget <- target.var$DatimTarget
    tarLua_var.tar$DATIMTarget_Adj <- target.var$DATIMTarget_Adj
    
    
    tarLua_var.tar$Indicator <- i
    tarLua_var.tar$Group <- "Adults"
    

    luapula.targ <- rbind(luapula.targ, tarLua_var.tar)
    
  }
  
}

############# NORTHEN TARGETS #################################################

nothern.targ <- head(data.frame(t(zambia_target_header)),0) # get dummy df
names(nothern.targ) <- zambia_target_header

for (j in Targets_Northen_sheetnames){
  
  tarLua_var.tar <- data.frame(read_excel(Targets_Northen, sheet= j))
  tarLua_var.tar.names <- c("Province", "District", "Facility")
  target.var <- tarLua_var.tar %>% dplyr::select(matches('FY24'))
  target.varadj <- tarLua_var.tar %>% dplyr::select(matches('Adjusted'))
  
  #check for adjusted targets
  if(ncol(target.var)>1){
    names(target.var) <- c("DatimTarget","DATIMTarget_Adj")
  }else if(ncol(target.varadj)>0){
    target.var <- cbind(target.var,target.varadj)
    names(target.var) <- c("DatimTarget","DATIMTarget_Adj")
  }else{
    names(target.var) <- c("DatimTarget")
    target.var$DATIMTarget_Adj <- target.var$DatimTarget
  }
  
  if(!(j %in% NopeadstargetsNothern)){  #  <- check if peads are set
    
    target.peads <- tarLua_var.tar %>% dplyr::select(matches('Peads.Target'))
    names(target.peads) <- "peads.tar"
    
    tarLua_var.tar <- tarLua_var.tar[tarLua_var.tar.names]
    tarLua_var.tar.peads <- tarLua_var.tar
    
    tarLua_var.tar.peads$DatimTarget <- as.numeric(target.peads$peads.tar)
    tarLua_var.tar.peads$DATIMTarget_Adj <- as.numeric(target.peads$peads.tar)
    
    tarLua_var.tar$DatimTarget <- as.numeric(target.var$DatimTarget) - as.numeric(target.peads$peads.tar)
    tarLua_var.tar$DATIMTarget_Adj <- as.numeric(target.var$DATIMTarget_Adj) - as.numeric(target.peads$peads.tar)
    
    tarLua_var.tar$Indicator <- j
    tarLua_var.tar$Group <- "Adults"
    
    ### peads
    tarLua_var.tar.peads$Indicator <- j
    tarLua_var.tar.peads$Group <- "Peads"
    
    nothern.targ <- rbind(nothern.targ, tarLua_var.tar)
    nothern.targ <- rbind(nothern.targ, tarLua_var.tar.peads)
    
  }else{
    
    tarLua_var.tar <- tarLua_var.tar[tarLua_var.tar.names]
    tarLua_var.tar.peads <- tarLua_var.tar
    
    tarLua_var.tar$DatimTarget <- target.var$DatimTarget
    tarLua_var.tar$DATIMTarget_Adj <- target.var$DATIMTarget_Adj
    
    tarLua_var.tar$Indicator <- j
    tarLua_var.tar$Group <- "Adults"
    
    nothern.targ <- rbind(nothern.targ, tarLua_var.tar)
    
  }

}

############# MUCHINGA TARGETS ########################################################

muchinga.targ <- head(data.frame(t(zambia_target_header)),0) # get dummy df
names(muchinga.targ) <- zambia_target_header

for (k in Targets_Muchinga_sheetnames){
  
  tarLua_var.tar <- data.frame(read_excel(Targets_Muchinga, sheet= k))
  
  tarLua_var.tar.names <- c("Province", "District", "Facility")
  
  target.var <- tarLua_var.tar %>% dplyr::select(matches('FY24'))
  target.varadj <- tarLua_var.tar %>% dplyr::select(matches('Adjusted'))
  
  #check for adjusted targets
  if(ncol(target.var)>1){
    names(target.var) <- c("DatimTarget","DATIMTarget_Adj")
  }else if(ncol(target.varadj)>0){
    target.var <- cbind(target.var,target.varadj)
    names(target.var) <- c("DatimTarget","DATIMTarget_Adj")
  }else{
    names(target.var) <- c("DatimTarget")
    target.var$DATIMTarget_Adj <- target.var$DatimTarget
  }
  
  if(!(k %in% NopeadstargetsMuchinga)){  #  <- check if peads are set
    
    target.peads <- tarLua_var.tar %>% dplyr::select(matches('Peads.Target'))
    names(target.peads) <- "peads.tar"
    
    tarLua_var.tar <- tarLua_var.tar[tarLua_var.tar.names]
    tarLua_var.tar.peads <- tarLua_var.tar

    tarLua_var.tar.peads$DatimTarget <- as.numeric(target.peads$peads.tar)
    tarLua_var.tar.peads$DATIMTarget_Adj <- as.numeric(target.peads$peads.tar)
    
    tarLua_var.tar$DatimTarget <- as.numeric(target.var$DatimTarget) - as.numeric(target.peads$peads.tar)
    tarLua_var.tar$DATIMTarget_Adj <- as.numeric(target.var$DATIMTarget_Adj) - as.numeric(target.peads$peads.tar)
    
    tarLua_var.tar$Indicator <- k
    tarLua_var.tar$Group <- "Adults"
    
    ### peads
    tarLua_var.tar.peads$Indicator <- k
    tarLua_var.tar.peads$Group <- "Peads"
    
    muchinga.targ <- rbind(muchinga.targ, tarLua_var.tar)
    muchinga.targ <- rbind(muchinga.targ, tarLua_var.tar.peads)
    
  }else{
    
    tarLua_var.tar <- tarLua_var.tar[tarLua_var.tar.names]
    tarLua_var.tar.peads <- tarLua_var.tar

    tarLua_var.tar$DatimTarget <- target.var$DatimTarget
    tarLua_var.tar$DATIMTarget_Adj <- target.var$DATIMTarget_Adj
    
    tarLua_var.tar$Indicator <- k
    tarLua_var.tar$Group <- "Adults"
    
    muchinga.targ <- rbind(muchinga.targ, tarLua_var.tar)
    
  }
  
}


#BindAllTargest

combinedTarget <- rbind(luapula.targ, muchinga.targ, nothern.targ )


#Cleaning the final dataset
combinedTarget <- combinedTarget[-grep("Total", combinedTarget$District),]
combinedTarget <- combinedTarget[-grep("Total", combinedTarget$Province),]

#Clean district
combinedTarget$Province <- gsub(" Province", "", combinedTarget$Province)
combinedTarget$District <- gsub(" District", "", combinedTarget$District)

#numeric
combinedTarget$DatimTarget <- round(as.numeric(combinedTarget$DatimTarget),0)
combinedTarget$DATIMTarget_Adj <- round(as.numeric(combinedTarget$DATIMTarget_Adj),0)

#Match indicators for consistency
combinedTarget$Indicator[combinedTarget$Indicator=='CXCA SCRN'] <- 'CXCA_SCRN'
combinedTarget$Indicator[combinedTarget$Indicator=='HTs_TST'] <- 'HTS_TST'
combinedTarget$Indicator[combinedTarget$Indicator=='PMTCT_STATD'] <- 'PMTCT_STAT D'
combinedTarget$Indicator[combinedTarget$Indicator=='PMTCT_STATN'] <- 'PMTCT_STAT N'
combinedTarget$Indicator[combinedTarget$Indicator=='PMTCT STAT D'] <- 'PMTCT_STAT D'
combinedTarget$Indicator[combinedTarget$Indicator=='PMTCT STAT N'] <- 'PMTCT_STAT N'
combinedTarget$Indicator[combinedTarget$Indicator=='PMTCT ART'] <- 'PMTCT_ART'
combinedTarget$Indicator[combinedTarget$Indicator=='TB_PREV (N)'] <- 'TB_PREV N'
combinedTarget$Indicator[combinedTarget$Indicator=='TB_PREVD'] <- 'TB_PREV D'
combinedTarget$Indicator[combinedTarget$Indicator=='TB_PREVN'] <- 'TB_PREV N'
combinedTarget$Indicator[combinedTarget$Indicator=='TB PREV D'] <- 'TB_PREV D'
combinedTarget$Indicator[combinedTarget$Indicator=='TB PREV N'] <- 'TB_PREV N'
combinedTarget$Indicator[combinedTarget$Indicator=='Tx Curr'] <- 'TX_CURR'
combinedTarget$Indicator[combinedTarget$Indicator=='Tx_Curr'] <- 'TX_CURR'
combinedTarget$Indicator[combinedTarget$Indicator=='Tx Curr-Luapula'] <- 'TX_CURR'
combinedTarget$Indicator[combinedTarget$Indicator=='TX_PVLS (N)'] <- 'TX_PVLS N'
combinedTarget$Indicator[combinedTarget$Indicator=='TX_PVLSD'] <- 'TX_PVLS D'
combinedTarget$Indicator[combinedTarget$Indicator=='TX_PVLSN'] <- 'TX_PVLS N'
combinedTarget$Indicator[combinedTarget$Indicator=='TX_TBD'] <- 'TX_TB D'
combinedTarget$Indicator[combinedTarget$Indicator=='GEND GBV'] <- 'GEND_GBV'
combinedTarget$Indicator[combinedTarget$Indicator=='HTS TST'] <- 'HTS_TST'
combinedTarget$Indicator[combinedTarget$Indicator=='PMTCT EID'] <- 'PMTCT_EID'

table(combinedTarget$Indicator,combinedTarget$Group)

#get the final csv of the correctly exported targets
write.csv(combinedTarget, "Combined-Zambia-Targets-21-08-2024.csv", row.names = FALSE)



