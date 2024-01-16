#A script to update links in ebook library records. The input is file of MARC records that need to be changed and a CSV with record ID, new URL
#Script replaces old URL with new URL, maintaining the rest of the file and skipping if the record isn't in the CSV.

require 'marc'

mrc_path = "ebl-bibs"

reader = MARC::Reader.new("#{mrc_path}.mrc")
writer = MARC::Writer.new("#{mrc_path}-fixed.mrc")
skipped_records = File.new("ebl-skipped.txt","w")


fix_lookup = {}

#for future reference, this is skipping the first line. I just added a throwaway line in the csv, but for future iterations fix this logic
File.open("ebl-fix.csv") do |f|
    for line in f
        arr = line.split(",")
        fix_lookup[arr[0].strip] = arr[1].strip
    end
end


for record in reader
    if fix_lookup.has_key?(record["001"].value.strip )
        fixed_record = MARC::Record.new()
        fixed_record.leader = record.leader
        for field in record
            if field.tag == '856' && field['u'].include?("EBLWeb")
              fixed_record.append(MARC::DataField.new('856',field.indicator1, field.indicator2,
                ['y','get it@Duke'],['u',fix_lookup[record['001'].value.strip]]))
            else 
                fixed_record.append(field)
            end
        end
        writer.write(fixed_record)
    else
        puts "skipped record, #{record['001']}"
        skipped_records.puts(record['001'].value)
    end
end


