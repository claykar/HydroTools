######
# Clay Karnis
##
# read and write raster to/from array
#####
import GDAL

_get_gdal_type(::Type{UInt8}) = GDAL.GDT_Byte
_get_gdal_type(::Type{Int16}) = GDAL.GDT_Int16
_get_gdal_type(::Type{UInt16}) = GDAL.GDT_UInt16
_get_gdal_type(::Type{Int32}) = GDAL.GDT_Int32
_get_gdal_type(::Type{UInt32}) = GDAL.GDT_UInt32
_get_gdal_type(::Type{Float32}) = GDAL.GDT_Float32
_get_gdal_type(::Type{Float64}) = GDAL.GDT_Float64
_get_gdal_type(::Type{T}) where {T} = error("not supported raster element type, $T")


function read_raster(file_path::AbstractString, ::Type{T} = Float32, band_number::Integer = 1) where {T}
    data_source = GDAL.gdalopen(file_path, GDAL.GA_ReadOnly)
    data_source === C_NULL && error("failed to open: $file_path")

    band = GDAL.gdalgetrasterband(data_source, band_number)
    band === C_NULL && error("failed to get band: @band $band_number")

    nx = GDAL.gdalgetrasterbandxsize(band)
    ny = GDAL.gdalgetrasterbandysize(band)
    
    raster_array = Array{T}(undef, nx, ny)

    GC.@preserve raster_array begin
        err = GDAL.gdalrasterio(
            band,
            GDAL.GF_Read,
            0, 0,
            nx, ny,
            pointer(raster_array),
            nx, ny,
            _get_gdal_type(T),
            0, 0
        )
        err == GDAL.CE_None || error("GDALRasterIO failed")
    end

    GDAL.gdalclose(data_source)

    return raster_array

end
