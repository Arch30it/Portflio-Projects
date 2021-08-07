

SELECT *
FROM NashvilleHousing..Nashville

-- Standardize Date Format

SELECT SaleDate, CONVERT(Date, SaleDate) AS Date
FROM NashvilleHousing..Nashville
ORDER BY 2

UPDATE Nashville
SET SaleDate = CONVERT(Date, SaleDate)

SELECT *
FROM NashvilleHousing..Nashville

ALTER TABLE Nashville
Add SaleDateConverted Date

UPDATE Nashville
SET SaleDateConverted = CONVERT(Date, SaleDate)


--Populate ptoperty address

SELECT *
FROM NashvilleHousing..Nashville
Where PropertyAddress is null
ORDER BY ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) AS propertyaddress
FROM NashvilleHousing..Nashville as a
JOIN NashvilleHousing..Nashville as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHousing..Nashville as a
JOIN NashvilleHousing..Nashville as b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress is null

--Breaking address into separate columns

SELECT PropertyAddress
FROM NashvilleHousing..Nashville

Select SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing..Nashville

ALTER TABLE Nashville
Add PropertySplitAddress Nvarchar(255)

UPDATE Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) 


ALTER TABLE Nashville
Add PropertySplitCity Nvarchar(255)

UPDATE Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 


SELECT *
FROM NashvilleHousing..Nashville




SELECT OwnerAddress
FROM NashvilleHousing..Nashville


SELECT PARSENAME(REPLACE(OwnerAddress,',', '.'), 3) As States,
PARSENAME(REPLACE(OwnerAddress,',', '.'), 2) AS City,
PARSENAME(REPLACE(OwnerAddress,',', '.'), 1) AS Addr
FROM NashvilleHousing..Nashville


ALTER TABLE Nashville
Add States Nvarchar(255)

UPDATE Nashville
SET States = PARSENAME(REPLACE(OwnerAddress,',', '.'), 3) 


ALTER TABLE Nashville
Add City Nvarchar(255)

UPDATE Nashville
SET City = PARSENAME(REPLACE(OwnerAddress,',', '.'), 2) 


ALTER TABLE Nashville
Add Addr Nvarchar(255)

UPDATE Nashville
SET Addr = PARSENAME(REPLACE(OwnerAddress,',', '.'), 1) 


SELECT *
FROM NashvilleHousing..Nashville


--Change Y and N to yes, No


SELECT distinct(SoldAsVacant), Count(*) AS Responses
FROM NashvilleHousing..Nashville 
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing..Nashville 

UPDATE Nashville
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	               When SoldAsVacant = 'N' THEN 'No'
	               ELSE SoldAsVacant
	               END
FROM NashvilleHousing..Nashville 

--Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SaleDate,
					 LegalReference
		ORDER BY UniqueID
	)row_num
FROM NashvilleHousing..Nashville
--ORDER BY ParcelID
)

SELECT *
FROM RowNumCTE
WHERE row_num > 1
Order By PropertyAddress

--Delete unused columns

Select *
FROM NashvilleHousing..Nashville

Alter TABLE Nashville
DROP COLUMN  SaleDate, SalDateConverted
