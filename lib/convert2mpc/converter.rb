require 'fileutils'

module Convert2mpc
    class Converter
        def initialize(src_dir, dst_dir)
            @src_pn = Pathname.new(src_dir)
            @dst_pn = Pathname.new(dst_dir)

            @src_dir, @src_base = @src_pn.split 
            @dst_dir, @dst_base = @dst_pn.split

            @target_dir = "#{@dst_pn.to_s}#{@src_base}" # WHOOHOO
            #puts "target dir = " + @target_dir

            @media_list = MediaList.new()
        end

        def load_media
            FileUtils.copy_entry(@src_pn.to_s, @target_dir)
            #files = Dir.glob(@target_dir + "/**/*").reject { |p| File.directory? p }
            files = Dir.glob(@target_dir + "/**/*").reject { |p| File.directory? p or !File.extname(p).match(/wav/i)}
            pb = ProgressBar.create(:title => "Media Processed", :total => files.size, :format => '%t: |%b%i| %c/%C %e')
            files.each do |file|
                #if file.match(/\.wav$/i)
                    media = Media.new(file)
                    @media_list << media
                    begin
                        system("ffmpeg -i \"#{media.path_name.to_s}\" -sample_fmt s16 -ar 44100 -ac 1 /tmp/a.wav")
                        FileUtils.mv("/tmp/a.wav", media.path_name.to_s)
                    rescue
                        puts "ERROR: " + media.path_name.to_s
                    end
                #else
                #    begin
                #        puts "deleting #{file}"
                #        File.delete(file)
                #    rescue
                #    end
                #end
                pb.increment
            end
            #check_names(@media_list)
        end

        def check_names(list)
            #puts @media_list.inspect
            tokens = {}
            too_long = []
            list.each do |media|
            #@media_list.each do |media|
                # first tokenize 
                media.base.to_s.split('_').each do |token|
                    if tokens.has_key?(token)
                        tokens[token] += 1
                    else
                        tokens[token] = 1
                    end
                end
                
                if media.name_len > 16
                    #puts media.path_name.to_s
                    too_long << media
                end
            end
            sorted = tokens.sort_by{|k, v| v}
            top_ten_tokens = sorted[sorted.index(sorted.last)-10..sorted.index(sorted.last)].reverse
            #puts top_ten_tokens.inspect
            puts "Remove " + top_ten_tokens.first.first + "? [y/N]"
            resp = STDIN.gets.chomp
            if resp == 'y'
                @media_list.each do |media|
                    media.remove_token(top_ten_tokens.first.first)
                    if media.name_len > 16
                        too_long << media
                    end
                end
            else
                puts "Change token?"
                resp = STDIN.gets.chomp
                if resp == 'y'
                    puts "Enter token to change"
                    old = STDIN.gets.chomp
                    puts "Enter desired token"
                    new = STDIN.gets.chomp
                    @media_list.each do |media|
                        media.change_token(old, new)
                    end
                else
                    too_long = []
                    @media_list.each do |media|
                        if media.name_len > 16
                            too_long << media
                        end
                    end
                    puts 'still too long:'
                    puts too_long.group_by{ |e| e.base }.select { |k, v| v.size > 1 }.map(&:first).inspect
                    check_names(too_long)
                end
            end
            puts 'still too long:'
            #puts too_long.inspect
            check_names(too_long)
        end

    end
end
