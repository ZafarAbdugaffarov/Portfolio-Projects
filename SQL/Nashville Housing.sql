-- cleaning data in SQL queries

select * 
from PortfolioProject..NashvilleHousing

--standardize date format

select SaleDateConverted, convert(Date,SaleDate) 
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
set SaleDate = Convert(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date; 

Update NashvilleHousing
set SaleDateConverted = convert(Date,SaleDate)


-- populate property address data

select *
from PortfolioProject..NashvilleHousing
-- where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

--breaking out address into individual columns (address, city, state)

select PropertyAddress
from PortfolioProject..NashvilleHousing
-- where PropertyHousing is null
-- Order by ParcelID

select
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1) as Address
, substring(PropertyAddress, charindex(',',PropertyAddress) +1, len(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing



alter table NashvilleHousing
add PropertySplitAddress nvarchar(255); 

Update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255); 

Update NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',',PropertyAddress) +1, len(PropertyAddress))


select *
from PortfolioProject..NashvilleHousing

select owneraddress
from PortfolioProject..NashvilleHousing


select
parsename(replace(OwnerAddress, ',', '.'), 3)
, parsename(replace(OwnerAddress, ',', '.'), 2)
, parsename(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject..NashvilleHousing



alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255); 

Update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255); 

Update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255); 

Update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.'), 1)

select * 
from PortfolioProject..NashvilleHousing

-- change y and n to Yes and No in "Sold as Vacant field.

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end

-- remove duplicates

with RowNumCTE as (
select *, 
	ROW_NUMBER() over(
	partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
	order by 
		UniqueID
		) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
Select *
from RowNumCTE
where Row_Num > 1
order by PropertyAddress


select *
from PortfolioProject..NashvilleHousing

--- delete unused columns

select *
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress

alter table PortfolioProject..NashvilleHousing
drop column SaleDate