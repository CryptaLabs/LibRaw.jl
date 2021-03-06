using LibRaw: libraw_version, LibRawImage
using AxisArrays
using Base.Test

# write your own tests here
@testset "Basic library access" begin
    @test libraw_version.major == 0
    @test libraw_version.minor >= 18
end

@testset "Check opening a file" begin
    image = LibRawImage(joinpath(dirname(@__FILE__), "example.dng"))

    @test LibRaw.make(image) == "Samsung"
    @test LibRaw.model(image) == "SM-G930F"
    @test LibRaw.color_description(image) == "RGBG"
    @test LibRaw.raw_size(image) == (2268, 4032)
    @test LibRaw.size(image) == (2268, 4032)
    @test LibRaw.output_size(image) == (2268, 4032)
    @test LibRaw.iso_speed(image) ≈ 200.0
    @test isapprox(LibRaw.shutter_speed(image), 0.06666666, atol=1e-6)
    @test isapprox(LibRaw.aperture(image), 1.7000000, atol=1e-6)
    @test isapprox(LibRaw.focal_length(image), 4.1999999, atol=1e-6)
end

@testset "Check reading data" begin
    image = LibRawImage(joinpath(dirname(@__FILE__), "example.dng"))
    data = LibRaw.image_data(image)

    @test size(data) == (2268, 4032, 4)
    @test axes(data, 3) == Axis{:color}([:R, :G1, :B, :G2])
    @test data[1, 2, :R] == 0x0042
    @test data[3, 2, :R] == 0x0047
    @test data[2, 3, :R] == 0x0000
end
