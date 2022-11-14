# encoding: utf-8
# frozen_string_literal: true

$finalize_hooks << lambda do
    Dir.glob("page/**/diagram-*.html") do |path|
        puts "Copying diagram #{path}"
        outpath = "out/"+path.delete_prefix('page/')
        FileUtils.mkdir_p(File.dirname(outpath))
        FileUtils.copy_entry(path,outpath)
    end
end