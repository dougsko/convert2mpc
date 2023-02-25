module Convert2mpc
    class NameTruncator
        def initialize(src)
            @media_list = MediaList.new()
            @files = Dir.glob(src + "/**/*").reject { |p| File.directory? p or !File.extname(p).match(/wav/i)}
            @files.each do |f|
                filename = File.basename(f, File.extname(f))
                if filename.size > 16
                    shortname = filename.gsub(/[\s_]/m, '')
                    while shortname.size > 16 do
                        shortname.slice!(0) 
                    end
                    path = Pathname.new(f)
                    dir, base = path.split
                    newname = shortname + File.extname(f)
                    puts dir + newname
                    File.rename(f, dir + newname)
                end
            end
        end
    end
end