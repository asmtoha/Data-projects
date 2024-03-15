--data cleaning project

select * from Projects..NashHousing

--standardize date format

select SaleDate,convert(date,SaleDate) 
from Projects..NashHousing

update NashHousing
set SaleDate = convert(date,SaleDate)

select SaleDate from Projects..NashHousing

alter table NashHousing
add SaleDateConverted Date

update NashHousing
set SaleDateConverted = convert(date,SaleDate)

select SaleDateConverted,SaleDate from Projects..NashHousing

--property address

select * from Projects..NashHousing
--where PropertyAddress is null
order by ParcelID

--populatred the address

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
isnull(a.PropertyAddress,b.PropertyAddress)
from Projects..NashHousing a
join Projects..NashHousing b
on a.ParcelID = b.ParcelID --making instance of same table to compare
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from Projects..NashHousing a
join Projects..NashHousing b
on a.ParcelID = b.ParcelID 
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


--making part in address

select PropertyAddress,
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress))
as Address from Projects..NashHousing


alter table NashHousing
add property_split_address nvarchar(255)

update NashHousing
set  property_split_address = SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress) -1)

alter table NashHousing
add property_split_city nvarchar(255)

update NashHousing
set property_split_city = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) 



select * from Projects..NashHousing

select OwnerAddress from Projects..NashHousing

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from Projects..NashHousing


alter table NashHousing
add owner_split_address nvarchar(255)

update NashHousing
set  owner_split_address = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table NashHousing
add owner_split_city nvarchar(255)

update NashHousing
set owner_split_city = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table NashHousing
add owner_split_state nvarchar(255)

update NashHousing
set owner_split_state = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--change y,n

select distinct(SoldAsVacant),count(SoldAsVacant)
from Projects..NashHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end
from Projects..NashHousing

update Projects..NashHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
end

select distinct(SoldAsVacant) 
,COUNT(SoldAsVacant) from Projects..NashHousing
group by SoldAsVacant
order by 2

--remove duplication

with RowCTE as(
select *,
ROW_NUMBER() over (
				partition by ParcelID,
							PropertyAddress,
							SalePrice,
							SaleDate,
							LegalReference
							order by  UniqueID
							)row_num
from Projects..NashHousing
--order by ParcelID
)
select * from RowCTE
where row_num >1
order by PropertyAddress


select * from Projects..NashHousing

--delete unused column

select * from Projects..NashHousing

alter table Projects..NashHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate