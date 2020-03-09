# Load in the files

big_df <- read.table("~/Downloads/Full.csv", 
                       header = TRUE,
                       sep = ",")


summary(big_df)


head(big_df, n=5)

big_df$X

big_df = big_df[, !(colnames(big_df) %in% c("X"))]

colnames(big_df)

na_count <-sapply(big_df, function(y) sum(length(which(is.na(y)))))
na_count <- data.frame(na_count)
na_count

# 4 'N/A' values in zipcode, but otherwise everything is filled. I'll inputate with zip code '-11111'

big_df$ZIP <- replace(big_df$ZIP,is.na(big_df$ZIP),-11111)

na_count <-sapply(big_df, function(y) sum(length(which(is.na(y)))))
na_count <- sum(data.frame(na_count))
na_count

# No more N/A values

summary(big_df)

##### Check the columns

# Salesprice has a minimum of 0? Seems ridiculously low - drop values below 30k, above 4M

boxplot(big_df$SalePrice, data=big_df, main="SalePrice",
        xlab="Number", ylab="SalePrice")

big_df = big_df[(big_df$SalePrice < 4000000 & big_df$SalePrice > 30000),]

# PrPerSqFt has no 0-values after cutting on SalesPrice

# what is p_cat?

summary(big_df$p_Cat)

boxplot(big_df$p_Cat, data=big_df, main="SalePrice",
        xlab="Number", ylab="SalePrice")

## P-cat looks like a factor and not a numerical value


# every single entry in PropertyType is 'Single Family'. This field is completely useless.
# Same for 'SFRCONDO'
# COMPLEXID is '9999' for all entries

big_df = big_df[, !(colnames(big_df) %in% c("PropertyType", "SFRCONDO", "COMPLEXID"))]

# Onehot encode IntendedUse, Deed, Financing, ValidationDescription, BuyerSellerRelated, Solar, PersonalProperty,
# PartialInterest, RecordingDate, 

big_df$NonPrimary <- ifelse(big_df$IntendedUse=='NonPrimary', 1, 0)
big_df$PrimaryRes[big_df$IntendedUse=='PrimaryRes'] <- 1
big_df$Rental[big_df$IntendedUse=='Rental'] <- 1

big_df$JointTenancyDeed[big_df$Deed=='Joint Tenancy Deed'] <- 1
big_df$WarrantyDeed[big_df$Deed=='Warranty Deed'] <- 1

big_df$FinancingCash[big_df$Financing=='Cash'] <- 1
big_df$FinancingCash[big_df$Financing=='Other'] <- 0

big_df$isSolar[big_df$Solar=='Yes'] <- 1
big_df$isSolar[big_df$Solar=='No'] <- 0

big_df$GoodSale[big_df$ValidationDescription=='Good Sale'] <- 1
big_df$BSOutOfState[big_df$ValidationDescription=='Buyer/Seller has an Out-Of-State Address'] <- 1
big_df$SaleUnderDuress[big_df$ValidationDescription=='Sale under duress'] <- 1
big_df$NoAssessmentRole[big_df$ValidationDescription=='Improvements not yet on assessment roll'] <- 1
big_df$BSRelatedorCorporate[big_df$ValidationDescription=='Buyer/Seller are related parties or corporate entities'] <- 1
big_df$SaleGovt[big_df$ValidationDescription=='Sale to or from a government agency'] <- 1

big_df$isBuyerSellerRelated[big_df$BuyerSellerRelated=='No'] <- 0
big_df$isBuyerSellerRelated[big_df$BuyerSellerRelated=='Yes'] <- 1

big_df$isPersonalProperty[big_df$PersonalProperty=='No'] <- 0
big_df$isPersonalProperty[big_df$PersonalProperty=='Yes'] <- 1

big_df$isPartialInterest[big_df$PartialInterest=='No'] <- 0
big_df$isPartialInterest[big_df$PartialInterest=='Yes'] <- 1

## Drop original columns

big_df = big_df[, !(colnames(big_df) %in% c("IntendedUse", "ValidationDescription", "Deed", "Financing", 
                                            "BuyerSellerRelated", "PersonalProperty", "PartialInterest", "Solar"))]

## This creates lots of 'NA' elements - fill them.

big_df <- replace(big_df,is.na(big_df),0)
big_df <- replace(big_df,is.na(big_df),'0')
# 'Inspection' is a date

# CLASS, STORIES, QUALITY look fine. Why does a house have 99 rooms?

summary(big_df$ROOMS)

boxplot(big_df$ROOMS, data=big_df, main="SalePrice",
        xlab="Number", ylab="SalePrice")

## There's a weird group of 'houses' with 50+ rooms. Drop.

big_df = big_df[(big_df$ROOMS < 50),]

# WALLS, ROOF, HEAT, COOL, BATHFIXTUR, PATIO, PATIONUMBE, CONDITION, SQFT, YEAR, GARAGE,
# GARAGECAPA, POOLAREA - check outliers

summary(big_df$GISACRES)

boxplot(big_df$GISACRES, data=big_df, main="SalePrice",
        xlab="Number", ylab="SalePrice")

## No idea what WALLS, ROOF, HEAT, COOL represents - I'll leave it alone for now. Material category?

## Houses with high BATHFIXTURE also have high price and lots of ROOMS. I'll leave it alone.

## PATIO takes on either 3 or 9 for all values. Better to encode as 0 or 1?

big_df$PATIO[big_df$PATIO==3] <- 0
big_df$PATIO[big_df$PATIO==9] <- 1

# MAIN, CONTROL, ACTUAL are tax assssments - looks fine

# LASTACTION is a date - why are some really low? Drop before 1900

big_df = big_df[(big_df$LASTACTION > 19000000),]

# MAP can be dropped

big_df = big_df[, !(colnames(big_df) %in% c("Map"))]

# GISACRES has outlier? Cut the top values

big_df = big_df[(big_df$GISACRES < 50),]


# LON, LAT, ZIP are fine

# Drop url1, url2 - I'm not doing data mining

big_df = big_df[, !(colnames(big_df) %in% c("URL", "URL2"))]

# Cleaning done - export data

write.csv(big_df, "MSteele_cleaned_full_data.csv",row.names=F)

summary(big_df$isSolar)
