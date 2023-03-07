/*
Cleaning Data in SQL Queries
*/

-- Look the Table Nashvillle Housing
Select *
From NashvilleHousing.dbo.NashvilleHousing1


/****** Script for SelectTopNRows command from SSMS  ******/

SELECT TOP (1000) [UniqueID]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [NashvilleHousing].[dbo].[NashvilleHousing1]



  -- Populate Property Address Data Where Property address is Null and we have rows with same ParcelID. So, we can populate address.
-- Look the column

SELECT * --PropertyAddress
FROM NashvilleHousing.dbo.NashvilleHousing1
WHERE PropertyAddress IS NULL
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) --PropertyAddress
FROM NashvilleHousing.dbo.NashvilleHousing1 a
JOIN NashvilleHousing.dbo.NashvilleHousing1 b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID]<> b.[UniqueID]
WHERE a.PropertyAddress IS NULL
--ORDER BY ParcelID


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing.dbo.NashvilleHousing1 a
JOIN NashvilleHousing.dbo.NashvilleHousing1 b
ON a.ParcelID=b.ParcelID
AND a.[UniqueID]<> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


-- Create columns Address, City, State from the column Property Address

--SELECT PropertyAddress
--FROM NashvilleHousing.dbo.NashvilleHousing1


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address -- separate an address (house number and street)
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address -- separate a city name
FROM NashvilleHousing.dbo.NashvilleHousing1


ALTER TABLE NashvilleHousing1
ADD PropertyStreet NVARCHAR(255)

UPDATE NashvilleHousing1
SET PropertyStreet = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


ALTER TABLE NashvilleHousing1
ADD PropertyCity NVARCHAR(255)

UPDATE NashvilleHousing1
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--Select *
--From NashvilleHousing.dbo.NashvilleHousing1


-- Create new columns OwnerStreet, OwnerCity, OwnerState froma column OwnerAddress

--Select OwnerAddress
--From NashvilleHousing.dbo.NashvilleHousing1


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From NashvilleHousing.dbo.NashvilleHousing1


ALTER TABLE NashvilleHousing1
ADD OwnerStreet NVARCHAR(255)

UPDATE NashvilleHousing1
SET OwnerStreet = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


ALTER TABLE NashvilleHousing1
ADD OwnerCity NVARCHAR(255)

UPDATE NashvilleHousing1
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing1
ADD OwnerState NVARCHAR(255)

UPDATE NashvilleHousing1
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)


--Select *
--From NashvilleHousing.dbo.NashvilleHousing1


-- Check rows in a column 'Sold as vacant'

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
From NashvilleHousing.dbo.NashvilleHousing1
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant


-- Remove duplicates rows

WITH rownumCTE AS(
SELECT *, 
ROW_NUMBER() OVER (
PARTITION BY ParcelID,PropertyAddress, SalePrice, SaleDate, LegalReference
ORDER BY UniqueID
) row_num
From NashvilleHousing.dbo.NashvilleHousing1
)
--SELECT *
DELETE
FROM rownumCTE
WHERE row_num >1



--Remove columns we think we do not need in our table

--Select *
--From NashvilleHousing.dbo.NashvilleHousing1

ALTER TABLE NashvilleHousing.dbo.NashvilleHousing1
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

--Select *
--From NashvilleHousing.dbo.NashvilleHousing1