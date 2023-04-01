# encoding: utf-8
# frozen_string_literal: true

require 'htmlcompressor'

module Minify

    # All valid CSS is also valid SCSS, so we can use that to compress
    class SCSS_Minifier
        def compress(style)
            Sass::Engine.new(style,syntax: :scss,style: :compressed).render.chomp(?\n)
        end
    end

    @@compressor = HtmlCompressor::Compressor.new(css_compressor: SCSS_Minifier.new,**(CONFIG[:htmlcompressor]||{}))

    def self.compressor
        @@compressor
    end

    def document_postprocess(doc)
        #puts "lmao"
        @@compressor.compress(super)
    end

end

SitePage.prepend(Minify)
