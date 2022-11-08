# encoding: utf-8
# frozen_string_literal: true

$finalize_hooks << lambda do
    root_url = CONFIG[:sitemap_root_url]
    if root_url.nil? || root_url.empty?
        puts "Skipping sitemap.txt generation, missing sitemap_root_url"
        return
    end
    File.write("out/sitemap.txt",PAGES.reject{|pg|pg.props['sitemap_exclude']}.map{|pg|root_url+pg.href_path}.join(?\n))
    File.write("out/robots.txt",<<~ROBOTS)
    Sitemap: #{root_url}/sitemap.txt
    ROBOTS
end