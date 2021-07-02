--Cleaning data in SQL Queries 

Select * From [dbo].[US Housing Data ]

Select SaleDateConverted, CONVERT(Date, Saledate)
From [dbo].[US Housing Data ] 

UPDATE [dbo].[US Housing Data ]
SET SaleDate = CONVERT(Date, SaleDate)

Alter Table [dbo].[US Housing Data ]
Add SaleDateConverted Date;

UPDATE [dbo].[US Housing Data ]
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate Property Address Data 

Select * From [dbo].[US Housing Data ]
--Where PropertyAddress is Null 
Order By ParcelID

Select a.ParcelID, a. PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [dbo].[US Housing Data ] a
Join [dbo].[US Housing Data ] b
ON a. ParcelID = b. ParcelID
AND a. [UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress IS NULL 

UPDATE a 
SET  PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
From [dbo].[US Housing Data ] a
Join [dbo].[US Housing Data ] b
ON a. ParcelID = b. ParcelID
AND a. [UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress IS NULL 

--Breaking  out Address into  Individual  Columns (Address, City, State)


Select PropertyAddress From [dbo].[US Housing Data ]
--Where PropertyAddress is Null 
Order By ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress))  AS Address
From [dbo].[US Housing Data ]

Alter Table [dbo].[US Housing Data ]
Add PropertySplitAddress Nvarchar(255);

UPDATE [dbo].[US Housing Data ]
SET PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table [dbo].[US Housing Data ]
Add PropertySplitCity Nvarchar(255);

UPDATE [dbo].[US Housing Data ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1,LEN(PropertyAddress)) 

Select OwnerAddress From [dbo].[US Housing Data ]

Select 
PARSENAME(REPLACE(OwnerAddress,',', ','),3)
,PARSENAME(REPLACE(OwnerAddress,',', ','),2)
,PARSENAME(REPLACE(OwnerAddress,',', ','),1)
From [dbo].[US Housing Data ]

Alter Table [dbo].[US Housing Data ]
Add OwnerSplitAddress Nvarchar(255);

UPDATE [dbo].[US Housing Data ]
SET PropertySplitAddress  = PARSENAME(REPLACE(OwnerAddress,',', ','),3)

Alter Table [dbo].[US Housing Data ]
Add OwnerSplitCity Nvarchar(255);

UPDATE [dbo].[US Housing Data ]
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',', ','),2)

Alter Table [dbo].[US Housing Data ]
Add OwnerSplitState Nvarchar(255);

UPDATE [dbo].[US Housing Data ]
SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress,',', ','),1)

--Change Y and N to Yes and No in Sold as Vacant field 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
 From [dbo].[US Housing Data ]
 Group By SoldAsVacant
 Order By 2 


 Select SoldASVacant 
 , CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsvacant 
		END 
FROM [dbo].[US Housing Data ] 

UPDATE [dbo].[US Housing Data ]
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsvacant 
		END

-- Remove Duplicates
WITH RowNumCTE AS(
Select *, 
Row_NUMBER() OVER(
PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			 UniqueID
			 ) row_num
From [dbo].[US Housing Data ]
--Order by ParcelID 
)
SELECT * 
From RowNumCTE
Where row_num > 1
--Order By PropertyAddress 

--Delete unused Columns 
SELECT * 
From [dbo].[US Housing Data ]

ALTER TABLE [dbo].[US Housing Data ]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE [dbo].[US Housing Data ]
DROP COLUMN SaleDate 