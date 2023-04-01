# encoding: utf-8
# frozen_string_literal: true

require 'htmlcompressor'

module Minify

    @@compressor = HtmlCompressor::Compressor.new(**(CONFIG[:htmlcompressor]||{}))

    def self.compressor
        @@compressor
    end

    def document_postprocess(doc)
        #puts "lmao"
        @@compressor.compress(super)
    end

end

SitePage.prepend(Minify)
