ObesityData <- read.table("./Source_data/obesity.txt",
                          sep="", header = T)
# View(ObesityData)

ObesityData_noHW <- ObesityData[,!names(ObesityData) %in% c("Height","Weight")]

write.table(ObesityData_noHW, file = "./Derived_data/ObesityConvert.txt", 
            quote = FALSE, row.names = F, col.names = T, sep = "\t")
