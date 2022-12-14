# encoding: utf-8
# frozen_string_literal: true

require 'json'

$finalize_hooks << lambda do

    items = Array.new();

    P2Opdata::P2Instructions.each do |instr|
        next if instr.category == :empty
        items << {
            name: instr.name,
            extra: instr.extra,
            type: "Instruction (#{P2Opdata::CATEGORIES[instr.category]})",
            href: instr.doc_href,
            nudge: instr.search_prefer ? instr.name : nil,
        }
    end

    P2Opdata::P2SmartModes.each do |mode|
        items << {
            name: mode.name,
            #extra: mode.extra,
            type: "Smart Pin Mode",
            href: mode.doc_href,
            #nudge: mode.search_prefer ? mode.name : nil,
        }
    end

    PAGES.each do |page|
        if page.props['hyperjump']
            page.props['hyperjump'].each do |item|
                id = item['id']
                name = item['name']
                name = page.title if name.nil? && id.nil?
                type = item['type']
                hidden = item['hidden']
                raise "malformed hyperjump in #{page.sourcepath}" unless name && type
                items << {
                    name: name,
                    href: "#{page.href_path}#{"##{id}" if id}",
                    type: type,
                    hidden: hidden,
                }
            end
        end
    end

    File.write("out/hjlist.js","let $hyperJumpList = "+JSON.dump(items)+?;)
end
