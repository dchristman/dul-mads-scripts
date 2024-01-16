#A script to update links in ebook library records. The input is file of MARC records that need to be changed and a CSV with record ID, new URL
#Script replaces old URL with new URL, maintaining the rest of the file and skipping if the record isn't in the CSV.

require 'marc'

mrc_path = "ebl-bibs"

reader = MARC::Reader.new("#{mrc_path}.mrc")
writer = MARC::Writer.new("#{mrc_path}-fixed.mrc")

fix_lookup = {}

File.open("ebl-fix.csv") do |f|
    f.each_line do |line|
        arr = line.split(",")
        fix_lookup[arr[0]] = arr[1]
        puts fix_lookup
        exit
    end
end

