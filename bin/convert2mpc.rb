#!/usr/bin/env ruby

require "bundler/setup"
require "convert2mpc"

src = ARGV[0]
dst = ARGV[1]
c = Convert2mpc::Converter.new(src, dst)
c.load_media
#c.convert2mpc
