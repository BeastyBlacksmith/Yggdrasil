using BinaryBuilder
using BinaryBuilder: download_source, sourcify

# Read in input `.json` file
json = String(read(ARGS[1]))
buff = IOBuffer(strip(json))
objs = []
while !eof(buff)
    push!(objs, BinaryBuilder.JSON.parse(buff))
end

# Merge the multiple outputs into one
merged = BinaryBuilder.merge_json_objects(objs)
BinaryBuilder.cleanup_merged_object!(merged)

# Download all sources
download_source.(sourcify.(merged["sources"]); verbose=true)

# Then export platforms to file
open(ARGS[2], "w") do io
    println(io, join(triplet.(merged["platforms"]), " "))
end
