/*

Cleaning Data in SQL Queries

*/


Select *
From PortfolioProjectt..NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDateConverted, Convert(date, SaleDate)
From PortfolioProjectt..NashvilleHousing


Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(date, SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProjectt..NashvilleHousing
--Where PropertyAddress is NUll
Order by ParcelID

Select a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress, isnull(a.propertyaddress, b.propertyaddress)
From PortfolioProjectt..NashvilleHousing a
join PortfolioProjectt..NashvilleHousing b
on a.parcelID = b.ParcelID
And a.uniqueid <> b.uniqueid
Where a.propertyaddress is null

Update a
Set Propertyaddress = isnull(a.propertyaddress, b.propertyaddress)
From PortfolioProjectt..NashvilleHousing a
join PortfolioProjectt..NashvilleHousing b
on a.parcelID = b.ParcelID
And a.uniqueid <> b.uniqueid


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select *
From PortfolioProjectt..NashvilleHousing

select
Substring(PropertyAddress, 1, CharIndex(',', PropertyAddress) - 1) as Address
,Substring(PropertyAddress, CharIndex(',', PropertyAddress) + 1, Len(propertyaddress))as City
From PortfolioProjectt..NashvilleHousing

Alter Table NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, CharIndex(',', PropertyAddress) - 1)

Alter Table NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, CharIndex(',', PropertyAddress) + 1, Len(propertyaddress))






Select OwnerAddress
From PortfolioProjectt..NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From PortfolioProjectt..NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Alter Table NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Alter Table NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), count(soldasvacant)
From PortfolioProjectt..NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
,Case When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End

From PortfolioProjectt..NashvilleHousing


Update PortfolioProjectt..NashvilleHousing
SET SoldasVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
	  When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates
With RowNumCTE as (
Select *,
	Row_Number() Over (
	Partition by ParcelID,
			     PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by 
				 UniqueID) row_num
From PortfolioProjectt..NashvilleHousing
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
From PortfolioProjectt..NashvilleHousing

Alter Table PortfolioProjectt..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table PortfolioProjectt..NashvilleHousing
Drop Column SaleDate













-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------