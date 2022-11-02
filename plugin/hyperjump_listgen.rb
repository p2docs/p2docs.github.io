# encoding: utf-8
# frozen_string_literal: true

require 'json'

$finalize_hooks << lambda do

    items = Array.new();

    P2Opdata::P2Instructions.each do |instr|
        next if instr.category == :empty
        items << {
            name: instr.name,
            type: "Instruction (#{P2Opdata::CATEGORIES[instr.category]})",
            href: "/#{instr.category}.html##{instr.name.downcase}",
        }
    end

    PAGES.each do |page|
        if page.props["jump-toplevel"]
            items << {
                name: page.title,
                href: page.href_path,
                type: page.props["jump-toplevel"],
            }
        end
    end

    File.write("out/hjlist.js","let $hyperJumpList = "+JSON.dump(items)+?;)
end
