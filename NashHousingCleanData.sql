-- Cleaning Data is SQL Queries

Select *
from NashvilleHousing

Select SaleDate, Convert(date,saledate)
from NashvilleHousing

Alter table nashvillehousing
add SalesDateConverted Date;

update NashvilleHousing
set SalesDateConverted = convert(date,SaleDate)


Select SalesDateConverted, Convert(date,saledate)
from NashvilleHousing

------ Getting rid of Null addresses by replacing with duplicates

Select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

------ Splitting City and Address for Property
Select propertyaddress
from NashvilleHousing

Select 
substring(propertyaddress, 1, charindex(',', propertyaddress) -1) as address
, substring(propertyaddress, charindex(',', propertyaddress) +1 , Len(propertyaddress)) as address
from NashvilleHousing


Alter table nashvillehousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = substring(propertyaddress, 1, charindex(',', propertyaddress) -1)



Alter table nashvillehousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = substring(propertyaddress, charindex(',', propertyaddress) +1 , Len(propertyaddress))


----- Owner address segmenting (Address, City, State)

select owneraddress
from NashvilleHousing

select parsename(replace(owneraddress, ',', '.') , 3)
,  parsename(replace(owneraddress, ',', '.') , 2)
,  parsename(replace(owneraddress, ',', '.') , 1)
from NashvilleHousing

Alter table nashvillehousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = parsename(replace(owneraddress, ',', '.') , 3)

Alter table nashvillehousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = parsename(replace(owneraddress, ',', '.') , 2)

Alter table nashvillehousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = parsename(replace(owneraddress, ',', '.') , 1)



----- Change Y and N to Yes and No in "Sold as Vacant"

select distinct(soldasvacant), Count(SoldAsVacant)
From NashvilleHousing
group by SoldAsVacant
Order by 2

select soldasvacant
, Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	else SoldAsVacant
	End
From NashvilleHousing


update NashvilleHousing
set SoldAsVacant = 
Case when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	else SoldAsVacant
	End



------ Delete Unused Colums


Alter table nashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
from NashvilleHousing