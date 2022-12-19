module Convert2mpc
    class Media
        attr_accessor :dir, :base, :path_name, :extension, :name_len, :base_length, :short_name, :short_name_len

        def initialize(path)
            @path_name = Pathname.new(path)
            @dir, @base = @path_name.split
            @short_name = @base
            @extension = File.extname(path)
            @name_len = File.basename(@base.to_s, ".*").size
        end

        def get_short_name_len
            @short_name_len = File.basename(@short_name.to_s, ".*").size
            puts @short_name_len
        end

        def remove_token(token)
            File.rename(self.path_name.to_s, self.dir.to_s + '/' + self.base.to_s.gsub(/_*#{token}_/, ''))
            self.path_name = Pathname.new(self.dir.to_s + '/' + self.base.to_s.gsub(/_*#{token}_/, ''))    
            self.dir, self.base = self.path_name.split
            self.extension = File.extname(self.dir.to_s + '/' + self.base.to_s.gsub(/_*#{token}_/, ''))
            self.name_len = File.basename(self.base.to_s, ".*").size    
            #puts self.inspect
            return self
        end

        def change_token(old, new)
            begin
                File.rename(self.path_name.to_s, self.dir.to_s + '/' + self.base.to_s.gsub(/#{old}/, new))
                self.path_name = Pathname.new(self.dir.to_s + '/' + self.base.to_s.gsub(/#{old}/, new))    
                self.dir, self.base = self.path_name.split
                self.extension = File.extname(self.dir.to_s + '/' + self.base.to_s.gsub(/#{old}/, new))
                self.name_len = File.basename(self.base.to_s, ".*").size    
                #puts self.inspect
                return self
            rescue
            end
        end

    end
end
