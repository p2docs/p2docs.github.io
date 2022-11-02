# encoding: utf-8
# frozen_string_literal: true

require 'fileutils'
require 'erb'
require 'yaml'
require 'kramdown'
require 'front_matter_parser'
require 'sass'

IMAGE_EXTENSIONS = %w[jpg jpeg png gif]

# Stolen from https://www.cookieshq.co.uk/posts/how-to-run-erb-blocks-inside-static-markdown-pages-ruby-on-rails
class Kramdown::Parser::KramdownWithErb < Kramdown::Parser::Kramdown
    def initialize(source, options)
        super
        # Parse both inline and block occurences of ERB tags
        @block_parsers.unshift(:erb_tags)
        @span_parsers.unshift(:erb_tags)
        # Nesting ERB blocks will lead to quite a lot of indentation
        # which correspond to code blocks in Markdown. To avoid that
        # we'll disable the parsing for that part of the syntax
        @block_parsers.delete(:codeblock)
        # Delete image parser because we want to use figure templates
        @span_parsers.delete(:img)
        @block_parsers.delete(:img)
    end
    # Kramdown's parser scans the Markdown string, looking
    # for specific patterns using Regular Expressions. It then turns
    # each relevant piece of the string detected by the scanner
    # into a tree of ruby objects representing the structure of the file
    # This pattern will let it pick up ERB blocks
    # Allow any level of intenting before an ERB block
    ERB_TAGS_START = /s*<%.*?%>/
    def parse_erb_tags
        # Once a block is found, we can move the scanner past it
        @src.pos += @src.matched_size
        # And add a :raw node to the tree, 
        # which will be left as is when converted to HTML
        @tree.children << Element.new(:raw, @src.matched)
    end
    # Rails code reloading seems to make the parser 
    # get re-registered while already defined
    # so putting a little check ahead of the registration
    unless has_parser?(:erb_tags)
        define_parser(:erb_tags, ERB_TAGS_START, '<%')
    end
end


class SitePage

    attr_reader :props,:source,:kram_parsed,:sourcepath,:dir

    include Kramdown::Utils::Html
    @@template_cache = {}
    @@fmploader = FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Date])

    def initialize(path)
        @sourcepath = path
        @dir = File.dirname(path)
        puts "Loading #{@sourcepath} ..."
        parsed = FrontMatterParser::Parser.parse_file(File.join("page",@sourcepath),loader: @@fmploader)
        @source = parsed.content
        @props = parsed.front_matter || {}
    end

    def title
        props['title'] || sourcepath
    end

    def html_path
        "/"+@sourcepath.gsub(/\..+$/,'')+".html"
    end

    def href_path
        html_path.gsub(/\/index\.html$/,?/)
    end

    def htmlattr(name,val)
        if val
            %Q<#{name}="#{escape_html(val.to_s,:attribute)}">
        else
            ""
        end
    end

    def local_output_path
        File.join("out",html_path)
    end

    def relative(name)
        if name.start_with? ?/
            name
        else
            File.join(?/,@dir,name)
        end
    end

    def local_file(name)
        File.join("page",relative(name))
    end

    def path_for_template(name)
        File.join("template",name)+".html.erb"
    end

    def template_exist?(name)
        @@template_cache.key?(name) || File.exist?(path_for_template(name))
    end

    def invoke_template(name,*targ,**kwarg,&block)
        unless @@template_cache[name]
            @@template_cache[name] = ERB.new(File.read(path_for_template(name)),nil,nil,'@out')
        end
        outbak = @out
        begin
            tret = render_inner(@@template_cache[name],*targ,**kwarg,&block)
        rescue
            warn "Error encountered while invoking #{name}"
            raise
        end
        @out = outbak
        return tret
    end

    def method_missing(name,*targ,**kwarg,&block)
        namestr = name.to_s
        if template_exist?(namestr)
            return invoke_template(namestr,*targ,**kwarg,&block)
        else
            puts "(tried invoking template, does not exist)" unless namestr == "to_hash" # Weird ERB behaviour
            super
        end
    end

    def render_inner(_rendercode,*targ,**kwarg)
        return _rendercode.result(binding)
    end

    KRAMDOWN_OPTS = {
        input: 'KramdownWithErb',
        typographic_symbols: { # Yes, this is the easiest way to disable this stupid shit
            hellip: "..." , mdash: "---" , ndash: "--" , laquo: "<<" , raquo: ">>" , laquo_space: "<< " , raquo_space: " >>"
        },
    }

    # Content must be passed in to allow autodetect
    def top_css_list(content)
        ["/main.css",props['top_css']||[]].flatten
    end

    # Content must be passed in to allow autodetect
    def bottom_css_list(content)
        spec = [props['bottom_css']||[]].flatten
        if content.include? %Q<class="highlight">
            spec.unshift "/syntax.css"
        end
        return spec
    end

    def render_inline_css
        if props['inline-css']
            return Sass::Engine.new(props['inline-css'],syntax: :scss,style: :compressed).render.chomp(?\n)
        else
            return nil
        end
    end

    def content_postprocess(doc)
        return doc
    end

    def document_postprocess(doc)
        return doc
    end

    def render!
        puts "Rendering #{local_output_path} ..."
        begin
            @out = "".dup
            if @sourcepath.end_with? '.md'
                @kram_parsed = Kramdown::Document.new(@source,**KRAMDOWN_OPTS)
                rendered_document = @kram_parsed.to_html
            else
                rendered_document = @source
            end
            templated_document = content_postprocess(render_inner(ERB.new(rendered_document,nil,nil,'@out')))
            wrapped_document = document_postprocess(invoke_template("wrapper",templated_document))
            FileUtils.mkdir_p(File.dirname(local_output_path))
            File.write(local_output_path,wrapped_document)
        rescue
            warn "Error encountered while rendering #{local_output_path}"
            raise
        end
    end

end


begin
    puts "IRQsoft SiteGen!!!"

    unless File.directory? "page" and File.exist? "sitegen.rb"
        raise "running in wrong directory"
    end

    # Load config file
    CONFIG = YAML.load(File.read("config.yml"),symbolize_names: true)

    $finalize_hooks = []

    # Load plugins
    Dir.glob("plugin/*.rb") do |path|
        puts "Loading #{path}"
        require_relative path
    end

    Dir.mkdir "out" unless File.exist? "out"
    FileUtils.rm_r Dir.glob("out/*.html")
    FileUtils.copy_entry("common","out/common")

    PAGES = Array.new

    # Copy full-size images
    Dir.glob("page/**/*.{#{IMAGE_EXTENSIONS.join ?,}}") do |path|
        puts "Copying full size #{path}"
        outpath = "out/"+path.delete_prefix('page/')
        FileUtils.mkdir_p(File.dirname(outpath))
        FileUtils.copy_entry(path,outpath)
    end

    # Process stylesheets
    Dir.glob("page/**/*.scss") do |path|
        next if File.basename(path).start_with? ?_ # Ignore underscore SCSS files
        puts "Processing #{path}"
        scss_file = Sass::Engine.for_file(path,syntax: :scss,style: :compressed)
        File.write("out/"+path.chomp(File.extname(path)).delete_prefix("page/")+".css",scss_file.render)
    end

    # Load pages
    Dir.glob("page/**/*{.md,.html.erb}") do |path|
        PAGES << SitePage.new(path.delete_prefix('page/'))
    end

    PAGES.each(&:render!)

    $finalize_hooks.each &:call

end

