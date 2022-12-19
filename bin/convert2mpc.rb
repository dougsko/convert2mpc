#!/usr/bin/env ruby

require "bundler/setup"
require "convert2mpc"

src = ARGV[0]
dst = ARGV[1]

# convert media
#c = Convert2mpc::Converter.new(src, dst)
#c.load_media

# rename media for MPC
c = Convert2mpc::NameTruncator.new(src)

